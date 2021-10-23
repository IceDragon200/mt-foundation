-- @namespace foundation.com

--
-- StringBuffer is an in-memory equivalent of love's File interface
--
local utf8 = foundation.com.utf8

-- @class StringBuffer
local StringBuffer = foundation.com.Class:extends("foundation.com.StringBuffer")
local ic = StringBuffer.instance_class

-- Initializes a Buffer with data and a possible mode
--
-- Modes:
--   * `r` - open the buffer in read-only mode
--   * `w` - open the buffer in write-only mode
--   * `rw` - open the buffer in read-write mode
--   * `a` - open the buffer in append mode, similar to write, but starts from end of data
--
-- @spec #initialize(data: String, mode?: String): void
function ic:initialize(data, mode)
  assert(type(data) == "string", "expected a string for data")
  ic._super.initialize(self)
  self.m_data = data
  self:open(mode)
end

-- Reports the byte size of the internal data
--
-- @spec #size(): Integer
function ic:size()
  return #self.m_data
end

-- Returns the internal data as a string, or a part of the data given a length
--
-- @spec #blob(len?: Integer): String
function ic:blob(len)
  if len then
    len = len or self.size()
    return string.sub(self.m_data, 1, len)
  else
    return self.m_data
  end
end

-- Opens the buffer in the specified mode see #initialize/2 for modes.
--
-- @spec open(mode: String): void
function ic:open(mode)
  self.m_cursor = 1
  self.m_mode = mode or "r"
  -- append
  if self.m_mode == "a" then
    self.m_cursor = 1 + #self.m_data
  end
end

-- Closes the buffer for reading or writing, will also reset the cursor position
--
-- @spec close(): void
function ic:close()
  self.m_cursor = 1
  self.m_mode = nil
end

-- Has the buffer reached the end of the data?
--
-- @spec #isEOF(): Boolean
function ic:isEOF()
  return self.m_cursor > #self.m_data
end

-- Reports current cursor position
--
-- @spec #tell(): Integer
function ic:tell()
  return self.m_cursor
end

-- Resets the cursor position
--
-- @spec #rewind(): self
function ic:rewind()
  self.m_cursor = 1
  return self
end

-- Moves the cursor to the specified position, note that the cursor is 1-index.
--
-- @spec #seek(pos: Integer): self
function ic:seek(pos)
  self.m_cursor = pos
  return self
end

-- Alternative to seek, instead this is 0-index
--
-- @spec #cseek(pos: Integer): self
function ic:cseek(pos)
  return self:seek(pos + 1)
end

-- Move the cursor ahead by the specific amount
--
-- @spec #walk(distance?: Integer = 1): self
function ic:walk(distance)
  distance = distance or 1
  self.m_cursor = self.m_cursor + distance
  return self
end

-- Locates a specific pattern in the underlying data
--
-- @spec #find(pattern: String): (Integer, Integer) | (nil, Integer)
function ic:find(pattern)
  return string.find(self.m_data, pattern, self.m_cursor)
end

-- Determines if the head of the string matches the specific pattern
--
-- @spec #scan(pattern: String): (String, bytes_read: Integer) | (nil, Integer)
function ic:scan(pattern)
  local i, j = self:find("^" .. pattern)
  if i then
    return self:read(j - i + 1)
  else
    return nil, 0
  end
end

-- Scans and returns everything until the pattern matches (including the match)
--
-- @spec #scan_until(pattern: String): (String, Integer) | (nil, Integer)
function ic:scan_until(pattern)
  local k = self:tell()
  local i, j = self:find(pattern)
  if i then
    return self:read(j - k + 1)
  else
    return nil, 0
  end
end

-- @spec #scan_upto(pattern: String): (String, Integer) | (nil, Integer)
function ic:scan_upto(pattern)
  local k = self:tell()
  local i, j = self:find(pattern)
  if i then
    return self:read(j - k)
  else
    return nil, 0
  end
end

-- @spec #scan_while(pattern: String): String
function ic:scan_while(pattern)
  local k = self:tell()
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

-- @spec #skip(pattern: String): Boolean
function ic:skip(pattern)
  local i, j = self:find("^" .. pattern)
  if i then
    self.m_cursor = j + 1
    return true
  else
    return false
  end
end

-- @spec #skip_until(pattern: String): Boolean
function ic:skip_until(pattern)
  local i, j = self:find(pattern)
  if i then
    self.m_cursor = j + 1
    return true
  else
    return false
  end
end

-- @alias skip_bytes = walk
ic.skip_bytes = ic.walk

-- @spec #calc_read_length(len?: Integer): Integer
function ic:calc_read_length(len)
  assert(self.m_mode == "r" or self.m_mode == "rw", "expected read mode")
  local remaining_len = #self.m_data - self.m_cursor + 1
  local len = math.min(len or remaining_len, remaining_len)
  return len
end

-- @spec #peek_bytes(len?: Integer): (Integer[], Integer)
function ic:peek_bytes(len)
  local len = self:calc_read_length(len)
  return string.byte(self.m_data, self.m_cursor, self.m_cursor + len - 1), len
end

-- @spec #read_bytes(len?: Integer): (Integer[], Integer)
function ic:read_bytes(len)
  local len = self:calc_read_length(len)
  local pos = self.m_cursor
  self.m_cursor = self.m_cursor + len
  return string.byte(self.m_data, pos, pos + len - 1), len
end

-- Reads the buffers next available data without advancing the cursor.
-- If len is not specified will return the remaining data in the buffer.
--
-- @spec #peek(len?: Integer): (String, Integer))
function ic:peek(len)
  local len = self:calc_read_length(len)
  return string.sub(self.m_data, self.m_cursor, self.m_cursor + len - 1), len
end

-- Reads the buffer's next available data and advances the cursor.
-- If the len is not specified will return the remaining data in the buffer.
--
-- @spec #read(len?: Integer): (String, bytes_read: Integer)
function ic:read(len)
  local len = self:calc_read_length(len)
  local pos = self.m_cursor
  self.m_cursor = self.m_cursor + len
  return string.sub(self.m_data, pos, pos + len - 1), len
end

if utf8 then
  -- Reads the next bytes as a utf8 codepoint string
  --
  -- @since "2.0.0"
  -- @spec read_utf8_codepoint(): (String, Integer)
  function ic:read_utf8_codepoint()
    local pos = self.m_cursor
    local uni8char, tail = utf8.next_codepoint(self.m_data, pos)
    if uni8char then
      self.m_cursor = tail + 1
      return uni8char, string.len(uni8char)
    else
      return '', 0
    end
  end

  -- Read len number of codepoints and return it as a string
  --
  -- @since "2.0.0"
  -- @spec read_utf8_codepoints(len: Integer): (String, Integer)
  function ic:read_utf8_codepoints(len)
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

  -- Peeks the next bytes as a utf8 codepoint string
  --
  -- @since "2.1.0"
  -- @spec peek_utf8_codepoint(): (String, Integer)
  function ic:peek_utf8_codepoint()
    local pos = self.m_cursor
    local uni8char, tail = utf8.next_codepoint(self.m_data, pos)
    if uni8char then
      return uni8char, string.len(uni8char)
    else
      return '', 0
    end
  end

  -- Skips the next bytes as a utf8 codepoint
  --
  -- @since "2.1.0"
  -- @spec skip_utf8_codepoint(): (String, Integer)
  function ic:skip_utf8_codepoint()
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

-- Writes the specified data to the buffer.
-- The data can be anything that supports tostring/1
--
-- @spec #write(data: Any): (true, nil) | (false, String)
function ic:write(data)
  assert(self.m_mode == "w" or self.m_mode == "rw", "expected write mode")
  data = tostring(data)
  local current_len = #self.m_data
  local len = #data
  local final_cursor = self.m_cursor + len
  if final_cursor < current_len then
    -- the final cursor is still inside the string
    local head = string.sub(self.m_data, 1, self.m_cursor)
    local tail = string.sub(self.m_data, final_cursor, current_len)
    self.m_data = head .. data .. tail
  else
    -- the data will overwrite a section of the existing data and add new data
    self.m_data = string.sub(self.m_data, 1, self.m_cursor)
    self.m_data = self.m_data .. data
  end
  self.m_cursor = final_cursor
  return true, nil
end

foundation.com.StringBuffer = StringBuffer
