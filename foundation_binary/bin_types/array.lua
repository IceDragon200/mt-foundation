-- @namespace foundation.com.binary_types
local ByteBuf = assert(foundation.com.ByteBuf.little)
local ScalarTypes = assert(foundation.com.binary_types.Scalars)

-- @class Array
local Array = foundation.com.Class:extends("Array")
local ic = Array.instance_class

function ic:initialize(value_type, len)
  ic._super.initialize(self)
  self.value_type = ScalarTypes.normalize_type(value_type)
  self.len = len
end

function ic:write(file, data)
  assert(data, "expected data")
  local all_bytes_written = 0
  local len
  local bytes_written
  local err

  if self.len >= 0 then
    len = self.len
  else
    len = #data
    bytes_written, err = ByteBuf:w_u32(file, self.len)
    all_bytes_written = all_bytes_written + bytes_written
    if err then
      return all_bytes_written, err
    end
  end

  local item

  for i = 1,len do
    item = data[i]
    bytes_written, err = self.value_type:write(file, item)
    all_bytes_written = all_bytes_written + bytes_written
    if err then
      return all_bytes_written, err
    end
  end
  return all_bytes_written, nil
end

function ic:read(file)
  local all_bytes_read = 0
  local len
  local bytes_read

  if self.len >= 0 then
    len = self.len
  else
    local v
    v, bytes_read = ByteBuf:r_u32(file)
    all_bytes_read = all_bytes_read + bytes_read
    len = v
  end
  local result = {}
  local item

  for i = 1,len do
    item, bytes_read = self.value_type:read(file)
    all_bytes_read = all_bytes_read + bytes_read
    result[i] = item
  end
  return result, all_bytes_read
end

foundation.com.binary_types.Array = Array
