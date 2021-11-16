-- @namespace foundation.com

local function iodata_to_string_recur(value, result, index)
  if type(value) == "table" then
    for _, item in ipairs(value) do
      result, index = iodata_to_string_recur(item, result, index)
    end
  elseif type(value) == "string" then
    index = index + 1
    result[index] = value
  else
    error("unexpected value " .. dump(value))
  end
  return result, index
end

-- Flattens a table into a string
--
-- @spec iodata_to_string(Table | String): String
local function iodata_to_string(value)
  if type(value) == "string" then
    return value
  elseif type(value) == "table" then
    local result = iodata_to_string_recur(value, {}, 0)
    return table.concat(result)
  else
    error("unexpected value " .. dump(value))
  end
end

foundation.com.iodata_to_string = iodata_to_string
