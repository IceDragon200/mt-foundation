local ByteBuf = assert(foundation.com.ByteBuf.little)
local BinSchema = assert(foundation.com.BinSchema)

--- @namespace foundation.com.binary_types

local NaiveDateTimeSchema0 = BinSchema:new("NaiveDateTimeSchema", {
  {"year", "u16"},
  {"month", "u8"},
  {"day", "u8"},
  {"hour", "u8"},
  {"minute", "u8"},
  {"second", "u8"},
})

--- @class NaiveDateTime
local NaiveDateTime = foundation.com.Class:extends("NaiveDateTime")
do
  local ic = NaiveDateTime.instance_class

  function ic:write(byte_buf, file, datetime)
    local abw = 0
    local bw
    local err
    -- Datetime Version, in case the format needs to change
    bw, err = byte_buf:w_u32(file, 0)
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = NaiveDateTimeSchema0:write(file, datetime)
    abw = abw + bw
    return abw, err
  end

  function ic:read(byte_buf, file)
    local value, br = byte_buf:r_u32(file)
    if value == 0 then
      return NaiveDateTimeSchema0:read(file), br
    else
      error("invalid naive_datetimme version")
    end
  end
end

foundation.com.binary_types.NaiveDateTime = NaiveDateTime
