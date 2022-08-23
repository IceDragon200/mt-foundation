-- @namespace foundation.com

--
-- Wrapper around lua file handle to be compatible with standard buffer functions
--
-- @class FileBuffer
local FileBuffer = foundation.com.Class:extends("foundation.com.FileBuffer")
local ic = FileBuffer.instance_class

function ic:initialize(file)
  assert(file, "expected a file handle")
  self.m_file = file
end

-- @spec #read(len: Integer): (blob: String, bytes_read: Integer)
function ic:read(len)
  local blob = self.m_file:read(len)

  return blob, #blob
end

-- @spec #write(blob: String): (written: Boolean, error: String)
function ic:write(blob)
  return self.m_file:write(blob)
end

foundation.com.FileBuffer = FileBuffer
