--- @namespace foundation.com

---
--- StringBuffer is an in-memory equivalent of love's File interface
---
local utf8 = foundation.com.utf8

--- @class StringBuffer
local StringBuffer = foundation.com.Class:extends("foundation.com.StringBuffer")
local ic = StringBuffer.instance_class

--- Initializes a Buffer with data and a possible mode
---
--- Modes:
---   * `r` - open the buffer in read-only mode
---   * `w` - open the buffer in write-only mode
---   * `rw` - open the buffer in read-write mode
---   * `a` - open the buffer in append mode, similar to write, but starts from end of data
---
--- @spec #initialize(data: String, mode?: String): void
function ic:initialize(data, mode)
  assert(type(data) == "string", "expected a string for data")
  ic._super.initialize(self)
  self.m_data = data
  self.m_size = #self.m_data
  self:open(mode)
end

--- Clears the buffer and resets all positions back to the start
---
--- @since "2.4.0"
--- @spec #truncate(): void
function ic:truncate()
  assert(self.m_mode == "w" or self.m_mode == "rw", "expected write mode")
  self.m_data = ""
  self.m_size = 0
  self.m_cursor = 1
  self.m_lazy_data = {
    size = 0,
    data = {},
  }
end

--- Flushes a lazy buffer if it exists
---
--- @since "2.3.0"
--- @spec #flush()
function ic:flush()
  if self.m_lazy_data.size > 0 then
    local data = self.m_lazy_data.data

    self.m_data = self.m_data .. table.concat(data)

    self.m_lazy_data.size = 0
    self.m_lazy_data.data = {}
  end
end

--- Reports the byte size of the internal data
---
--- @spec #size(): Integer
function ic:size()
  return self.m_size
end

--- Determines if buffer is in read mode
---
--- @since "2.3.0"
--- @spec #can_read(): Boolean
function ic:can_read()
  return self.m_mode == "r" or
    self.m_mode == "a" or
    self.m_mode == "rw"
end

--- Checks if the buffer is readable, will error otherwise
---
--- @since "2.3.0"
--- @spec #check_readable(): void
function ic:check_readable()
  if not self:can_read() then
    if self.m_mode then
      error("buffer is not open for reading mode=" .. self.m_mode)
    else
      error("buffer is not open")
    end
  end
end

--- Returns the internal data as a string, or a part of the data given a length
---
--- @spec #blob(len?: Integer): String
function ic:blob(len)
  self:flush()
  if len then
    len = len or self.size()
    return string.sub(self.m_data, 1, len)
  else
    return self.m_data
  end
end

--- Opens the buffer in the specified mode see #initialize/2 for modes.
---
--- @spec open(mode: String): void
function ic:open(mode)
  mode = mode or "r"
  assert(type(mode) == "string", "expected mode to be a string")
  assert(mode == "a" or mode == "r" or mode == "w" or mode == "rw",
    "expected mode to be r (for read), w (write), or a (append) (got "..mode..")"
  )
  if self.m_mode then
    error("buffer already open with mode=" .. self.m_mode)
  end

  self.m_mode = mode
  self.m_cursor = 1
  self.m_lazy_data = {
    size = 0,
    data = {},
  }

  -- append
  if self.m_mode == "a" then
    self.m_cursor = 1 + self.m_size
  end
end

--- Closes the buffer if it is open and returns true, otherwise the buffer was already closed and
--- false is returned instead.
---
--- @since "2.3.0"
--- @spec #maybe_close(): Boolean
function ic:maybe_close()
  if self.m_mode then
    self:flush()
    self.m_cursor = 1
    self.m_mode = nil
    return true
  end
  return false
end

--- Closes the buffer for reading or writing, will also reset the cursor position
---
--- @spec #close(): void
function ic:close()
  if self.m_mode then
    self:maybe_close()
  else
    error("buffer was not open, if you wanted to close quietly, use maybe_close/0 instead")
  end
end

--- Closes and reopens the buffer with given mode
---
--- @since "2.3.0"
--- @spec #reopen(mode: String): void
function ic:reopen(mode)
  self:close()
  self:open(mode)
end

--- Has the buffer reached the end of the data?
---
--- @spec #isEOF(): Boolean
function ic:isEOF()
  return self.m_cursor > self.m_size
end

--- Reports current cursor position
---
--- @spec #tell(): Integer
function ic:tell()
  return self.m_cursor
end

--- Resets the cursor position
---
--- @spec #rewind(): self
function ic:rewind()
  self.m_cursor = 1
  return self
end

--- Moves the cursor to the specified position, note that the cursor is 1-index.
---
--- @spec #seek(pos: Integer): self
function ic:seek(pos)
  self.m_cursor = pos
  return self
end

--- Alternative to seek, instead this is 0-index
---
--- @spec #cseek(pos: Integer): self
function ic:cseek(pos)
  return self:seek(pos + 1)
end

--- Move the cursor ahead by the specific amount
---
--- @spec #walk(distance?: Integer = 1): self
function ic:walk(distance)
  distance = distance or 1
  self.m_cursor = self.m_cursor + distance
  return self
end

--- Locates a specific pattern in the underlying data
---
--- @spec #find(pattern: String): (Integer, Integer) | (nil, Integer)
function ic:find(pattern)
  self:check_readable()

  return string.find(self.m_data, pattern, self.m_cursor)
end

--- Determines if the head of the string matches the specific pattern
---
--- @spec #scan(pattern: String): (String, bytes_read: Integer) | (nil, Integer)
function ic:scan(pattern)
  self:check_readable()

  local i, j = self:find("^" .. pattern)
  if i then
    return self:read(j - i + 1)
  else
    return nil, 0
  end
end

--- Scans and returns everything until the pattern matches (including the match)
---
--- @spec #scan_until(pattern: String): (String, Integer) | (nil, Integer)
function ic:scan_until(pattern)
  self:check_readable()

  local k = self:tell()
  local i, j = self:find(pattern)
  if i then
    return self:read(j - k + 1)
  else
    return nil, 0
  end
end

--- @spec #scan_upto(pattern: String): (String, Integer) | (nil, Integer)
function ic:scan_upto(pattern)
  self:check_readable()

  local k = self:tell()
  local i, j = self:find(pattern)
  if i then
    return self:read(j - k)
  else
    return nil, 0
  end
end

--- @spec #scan_while(pattern: String): String
function ic:scan_while(pattern)
  self:check_readable()

  local result = {}

  while not self:isEOF() do
    local str = self:scan(pattern)
    if str then
      table.insert(result, str)
    else
      break
    end
  end

  local k = next(result)
  if k then
    return table.concat(result)
  end
  return nil
end

--- @spec #skip(pattern: String): Boolean
function ic:skip(pattern)
  self:check_readable()

  local i, j = self:find("^" .. pattern)
  if i then
    self.m_cursor = j + 1
    return true
  else
    return false
  end
end

--- @spec #skip_until(pattern: String): Boolean
function ic:skip_until(pattern)
  self:check_readable()

  local i, j = self:find(pattern)
  if i then
    self.m_cursor = j + 1
    return true
  else
    return false
  end
end

--- @alias skip_bytes = walk
ic.skip_bytes = ic.walk

--- @spec #calc_read_length(len?: Integer): Integer
function ic:calc_read_length(len)
  assert(self.m_mode == "r" or self.m_mode == "rw", "expected read mode")
  local remaining_len = self.m_size - self.m_cursor + 1
  len = math.min(len or remaining_len, remaining_len)
  return len
end

--- @spec #peek_bytes(len?: Integer): (Integer[], Integer)
function ic:peek_bytes(len)
  self:check_readable()

  len = self:calc_read_length(len)
  return string.byte(self.m_data, self.m_cursor, self.m_cursor + len - 1), len
end

--- @spec #read_bytes(len?: Integer): (Integer[], Integer)
function ic:read_bytes(len)
  self:check_readable()

  len = self:calc_read_length(len)
  local pos = self.m_cursor
  self.m_cursor = self.m_cursor + len
  return string.byte(self.m_data, pos, pos + len - 1), len
end

--- Reads the buffers next available data without advancing the cursor.
--- If len is not specified will return the remaining data in the buffer.
---
--- @spec #peek(len?: Integer): (String, Integer))
function ic:peek(len)
  self:check_readable()

  len = self:calc_read_length(len)
  return string.sub(self.m_data, self.m_cursor, self.m_cursor + len - 1), len
end

--- Reads the buffer's next available data and advances the cursor.
--- If the len is not specified will return the remaining data in the buffer.
---
--- @spec #read(len?: Integer): (String, bytes_read: Integer)
function ic:read(len)
  self:check_readable()

  len = self:calc_read_length(len)
  local pos = self.m_cursor
  self.m_cursor = self.m_cursor + len
  return string.sub(self.m_data, pos, pos + len - 1), len
end

if utf8 then
  --- Reads the next bytes as a utf8 codepoint string
  ---
  --- @since "2.0.0"
  --- @spec read_utf8_codepoint(): (String, Integer)
  function ic:read_utf8_codepoint()
    self:check_readable()

    local pos = self.m_cursor
    local uni8char, tail = utf8.next_codepoint(self.m_data, pos)
    if uni8char then
      self.m_cursor = tail + 1
      return uni8char, string.len(uni8char)
    else
      return '', 0
    end
  end

  --- Read len number of codepoints and return it as a string
  ---
  --- @since "2.0.0"
  --- @spec read_utf8_codepoints(len: Integer): (String, Integer)
  function ic:read_utf8_codepoints(len)
    self:check_readable()

    local result = ''
    local all_bytes_read = 0

    for _ = 1,len do
      local char, bytes_read = self:read_utf8_codepoint()
      if char then
        all_bytes_read = all_bytes_read + bytes_read
        result = result .. char
      else
        break
      end
    end

    return result, all_bytes_read
  end

  --- Peeks the next bytes as a utf8 codepoint string
  ---
  --- @since "2.1.0"
  --- @spec peek_utf8_codepoint(): (String, Integer)
  function ic:peek_utf8_codepoint()
    self:check_readable()

    local pos = self.m_cursor
    local uni8char = utf8.next_codepoint(self.m_data, pos)
    if uni8char then
      return uni8char, string.len(uni8char)
    else
      return '', 0
    end
  end

  --- Skips the next bytes as a utf8 codepoint
  ---
  --- @since "2.1.0"
  --- @spec skip_utf8_codepoint(): (String, Integer)
  function ic:skip_utf8_codepoint()
    self:check_readable()

    local pos = self.m_cursor
    local start, tail = utf8.next_codepoint_pos(self.m_data, pos)
    if start and tail then
      self.m_cursor = tail + 1
      return true
    else
      return false
    end
  end
end

--- Writes the specified data to the buffer.
--- The data can be anything that supports tostring/1
---
--- @spec #write(data: Any): (true, nil) | (false, String)
function ic:write(data)
  assert(self.m_mode == "w" or self.m_mode == "rw", "expected write mode")
  data = tostring(data)
  local current_len = self.m_size
  local len = #data
  local final_cursor = self.m_cursor + len
  if final_cursor < current_len then
    self:flush()
    -- the final cursor is still inside the string
    -- the data will overwrite a section of the existing data and add new data
    local head = string.sub(self.m_data, 1, self.m_cursor)
    local tail = string.sub(self.m_data, final_cursor, current_len)
    self.m_data = head .. data .. tail
  else
    -- data will just be appended
    -- self.m_data = self.m_data .. data
    self.m_lazy_data.size = self.m_lazy_data.size + 1
    self.m_lazy_data.data[self.m_lazy_data.size] = data
  end
  self.m_cursor = final_cursor
  self.m_size = self.m_size + len
  return true, nil
end

foundation.com.StringBuffer = StringBuffer
