-- @namespace foundation.com

-- @spec iodata_to_string(Table | String): String
local function iodata_to_string(value)
  if type(value) == "string" then
    return value
  elseif type(value) == "table" then
    local result = ""
    for _, item in ipairs(value) do
      result = result .. iodata_to_string(item)
    end
    return result
  else
    error("unexpected value " .. dump(value))
  end
end

foundation.com.iodata_to_string = iodata_to_string
