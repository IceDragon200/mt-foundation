local min = assert(math.min)
local ceil = assert(math.ceil)
local floor = assert(math.floor)
local strsub = assert(string.sub)
local strrep = assert(string.rep)
local table_concat = assert(table.concat)

---
--- Binary Buffer - similar interface as StringBuf but using an FFI allocated uchar array
---
--- @class LuaBinaryBuffer
local LuaBinaryBuffer = foundation.com.BaseBinaryBuffer:extends("foundation.com.LuaBinaryBuffer")
do
  local ic = LuaBinaryBuffer.instance_class

  ic.is_lua = true

  --- @override
  --- @spec #prepare_data(data: String): void
  function ic:prepare_data(data)
    self.m_data = {}
    local bs = self.BLOCK_SIZE
    if #data <= bs then
      local padding = strrep("\0", bs - #data)
      self.m_data[1] = data .. padding
    else
      local blocks = ceil(#data / bs)

      if blocks > 0 then
        local si
        local padding
        local s
        for bi = 1,blocks do
          si = 1 + (bi - 1) * bs
          s = strsub(data, si, si + bs - 1)
          s = s .. strrep("\0", bs - #s)
          assert(#s == bs)
          self.m_data[bi] = s
        end
      end
    end
  end

  --- @override
  --- @spec #initialize(other: LuaBinaryBuffer): void
  function ic:initialize_copy(other)
    ic._super.initialize(self, other)
    self.m_data = {}
    for i, blob in pairs(other.m_data) do
      self.m_data[i] = blob
    end
  end

  --- @override
  --- @spec #blob(len?: Integer): String
  function ic:blob(len)
    len = len or self.m_size
    if len < 1 then
      return ""
    end
    local bs = self.BLOCK_SIZE
    if len == bs then
      return self.m_data[1]
    elseif len < bs then
      local elm = self.m_data[1]
      return strsub(elm, 1, len)
    else
      local result = {}
      local x = 0
      local y = len
      local bi = 0
      local s
      while y > 0 do
        bi = bi + 1
        s = self.m_data[bi]
        if y > bs then
          if not s then
            s = strrep("\0", bs)
          end
          result[bi] = s
          x = x + #s
          y = y - bs
        elseif bs == y then
          result[bi] = s
          y = 0
        else
          if s then
            s = strsub(s, 1, y)
          else
            s = strrep("\0", y)
          end
          result[bi] = s
          x = x + #s
          y = 0
        end
      end
      return table_concat(result)
    end
  end

  --- @override
  --- @spec #resize(new_size: Integer): self
  function ic:resize(new_size)
    local old_size = self.m_size
    local old_allocated_size = self.m_allocated_size

    self.m_size = new_size
    self.m_allocated_size = ic:next_block_size(new_size)

    local bs = self.BLOCK_SIZE
    local old_allocated_blocks = ceil(old_allocated_size / bs)
    local allocated_blocks = ceil(self.m_allocated_size / bs)

    if old_size > self.m_size then
      -- the old size was larger than the new, truncate the data
      for i = allocated_blocks,old_allocated_blocks do
        self.m_data[i] = nil
      end
    end

    return self
  end

  --- Allocates a new block.
  --- @spec allocate_next_block(): self
  function ic:allocate_next_block()
    self.m_allocated_size = self.m_allocated_size + self.BLOCK_SIZE
    return self
  end

  --- @override
  --- @spec #read(len: Integer): (bytes: String, bytes_read: Integer)
  function ic:read(len)
    local remlen
    local bs = self.BLOCK_SIZE
    len, remlen = self:calc_read_length(len)
    local pos = self.m_cursor

    if (pos - 1 + len) > self.m_size then
      error("read would exceed length remaining=" .. remlen .. " len=" .. len)
    end

    if len > 0 then
      local ri = 0
      local result = {}
      local bi
      local x = pos
      local y = len
      local si
      local s
      local d
      while y > 0 do
        bi = floor((x - 1) / bs) + 1
        s = self.m_data[bi]
        if y > bs then
          d = bs - ((x - 1) % bs)
        else
          d = y
        end
        ri = ri + 1
        si = (x - 1) % bs + 1
        result[ri] = strsub(s, si, si + d - 1)
        x = x + d
        y = y - d
      end
      self.m_cursor = self.m_cursor + len
      return table_concat(result), len
    else
      return nil, len
    end
  end

  --- @override
  --- @spec #write(blob: String): (written: Boolean, error: String | nil)
  function ic:write(blob)
    assert(self.m_mode == "w" or self.m_mode == "rw", "must be opened for writing")
    blob = tostring(blob)
    local blob_size = #blob
    if blob_size == 0 then
      return true, nil
    end

    local next_cursor = self.m_cursor + blob_size

    while next_cursor > self.m_allocated_size do
      self:allocate_next_block()
    end

    local bs = self.BLOCK_SIZE
    local x = self.m_cursor
    local y = blob_size
    local bi
    local s
    local h
    local t
    local si
    local ii = 1
    local l
    while y > 0 do
      bi = floor((x - 1) / bs) + 1
      si = (x - 1) % bs
      l = min(y, bs - si)

      s = self.m_data[bi]
      if s then
        if si > 0 then
          h = strsub(s, 1, si)
        else
          h = ""
        end
        if si < bs then
          t = strsub(s, si + l + 1)
        else
          t = ""
        end
      else
        if si > 0 then
          h = strrep("\0", si)
        else
          h = ""
        end
        if si < bs then
          t = strrep("\0", bs - l)
        else
          t = ""
        end
      end
      s = strsub(blob, ii, ii + l - 1)
      s = h .. s .. t
      assert(#s == bs)
      ii = ii + l
      y = y - l
      x = x + l
      self.m_data[bi] = s
    end
    self.m_cursor = next_cursor
    self.m_size = self.m_size + blob_size
    return true, nil
  end
end

foundation.com.LuaBinaryBuffer = LuaBinaryBuffer
