-- @namespace foundation.com

-- @spec string_to_list(str: String): Table
function foundation.com.string_to_list(str)
  return {string.byte(str, 1, #str)}
end
