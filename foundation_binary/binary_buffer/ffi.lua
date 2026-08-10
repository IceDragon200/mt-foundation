local min = assert(math.min)
local ffi = foundation_binary.ffi
--- @namespace foundation.com

if not ffi then
  core.log(
    "warning",
    "LuaJIT's ffi module is unavailable, using a slightly less optimal datastructure"
  )
  return
end

---
--- Binary Buffer - similar interface as StringBuf but using an FFI allocated uchar array
---
--- @class FFIBinaryBuffer
local FFIBinaryBuffer = foundation.com.BaseBinaryBuffer:extends("foundation.com.FFIBinaryBuffer")
do
  local ic = FFIBinaryBuffer.instance_class

  ic.is_ffi = true

  --- @override
  --- @spec #initialize_copy(other: FFIBinaryBuffer): void
  function ic:initialize_copy(other)
    ic._super.initialize_copy(self, other)
    self.m_data = ffi.new('unsigned char[?]', self.m_allocated_size)
    ffi.copy(self.m_data, other.m_data, self.m_size)
  end

  --- @override
  function ic:prepare_data(data)
    self.m_data = ffi.new('unsigned char[?]', self.m_allocated_size)
    ffi.fill(self.m_data, self.m_allocated_size)
    ffi.copy(self.m_data, data, self.m_size)
  end

  --- @override
  --- @spec #blob(len?: Integer): String
  function ic:blob(len)
    len = len or self.m_size
    return ffi.string(self.m_data, len)
  end

  --- @override
  --- @spec #resize(Integer): self
  function ic:resize(new_size)
    local old_allocated_size = self.m_allocated_size
    local old_data = self.m_data

    self.m_size = new_size
    self.m_allocated_size = ic:align_block_size(new_size)
    self.m_data = ffi.new('unsigned char[?]', self.m_allocated_size)
    ffi.fill(self.m_data, self.m_allocated_size)
    ffi.copy(self.m_data, old_data, min(old_allocated_size, self.m_allocated_size))

    return self
  end

  --- Allocates a new block.
  --- @spec allocate_next_block(): self
  function ic:allocate_next_block()
    local old_allocated_size = self.m_allocated_size
    self.m_allocated_size = self.m_allocated_size + self.BLOCK_SIZE
    local old_data = self.m_data
    self.m_data = ffi.new('unsigned char[?]', self.m_allocated_size)
    ffi.fill(self.m_data, self.m_allocated_size)
    ffi.copy(self.m_data, old_data, old_allocated_size)
    return self
  end

  --- @override
  --- @spec #read(len?: Integer): (blob: String, bytes_read: Integer)
  function ic:read(len)
    assert(self.m_mode == "r" or self.m_mode == "rw", "must be opened for reading")
    local remlen
    len, remlen = self:calc_read_length(len)
    local pos = self.m_cursor - 1

    if (pos + len) > self.m_size then
      error("read would exceed length remaining=" .. remlen .. " len=" .. len)
    end

    if len > 0 then
      self.m_cursor = self.m_cursor + len
      return ffi.string(self.m_data + pos, len), len
    else
      return nil, len
    end
  end

  --- @override
  --- @spec #write(blob: String): (was_written: Boolean, err: Error)
  function ic:write(blob)
    assert(self.m_mode == "w" or self.m_mode == "rw", "must be opened for writing")
    blob = tostring(blob)
    local blob_size = #blob
    local next_cursor = self.m_cursor + blob_size

    while next_cursor > self.m_allocated_size do
      self:allocate_next_block()
    end

    ffi.copy(self.m_data + (self.m_cursor - 1), blob, blob_size)
    self.m_cursor = next_cursor

    local new_size = self.m_cursor - 1
    if self.m_size < new_size then
      self.m_size = new_size
    end

    return true, nil
  end
end

foundation.com.FFIBinaryBuffer = FFIBinaryBuffer
