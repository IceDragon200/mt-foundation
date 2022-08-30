-- @namespace foundation.com.binary_types
local ByteBuf = assert(foundation.com.ByteBuf.little)
local BinSchema = assert(foundation.com.BinSchema)

local NaiveDateTimeSchema0 = BinSchema:new("NaiveDateTimeSchema", {
  {"year", "u16"},
  {"month", "u8"},
  {"day", "u8"},
  {"hour", "u8"},
  {"minute", "u8"},
  {"second", "u8"},
})

-- @class NaiveDateTime
local NaiveDateTime = foundation.com.Class:extends("NaiveDateTime")
local ic = NaiveDateTime.instance_class

function ic:write(file, datetime)
  local all_bytes_written = 0
  local bytes_written
  local err
  -- Datetime Version, in case the format needs to change
  bytes_written, err = ByteBuf:w_u32(file, 0)
  all_bytes_written = all_bytes_written + bytes_written
  if err then
    return all_bytes_written, err
  end
  bytes_written, err = NaiveDateTimeSchema0:write(file, datetime)
  all_bytes_written = all_bytes_written + bytes_written
  return all_bytes_written, err
end

function ic:read(file)
  -- local value, read_bytes = ByteBuf:r_u32(file)
  local value = ByteBuf:r_u32(file)
  if value == 0 then
    return NaiveDateTimeSchema0:read(file)
  else
    error("invalid naive_datetimme version")
  end
end

foundation.com.binary_types.NaiveDateTime = NaiveDateTime
