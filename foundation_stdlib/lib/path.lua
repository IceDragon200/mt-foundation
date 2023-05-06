--- @namespace foundation.com
local string_split = assert(foundation.com.string_split)

--- @spec path_components(a: String): String[]
function foundation.com.path_components(a)
  if a == "" then
    return {}
  else
    local parts = string_split(a, DIR_DELIM)
    local result = {}
    local i = 0
    local was_blank = false
    for j,part in pairs(parts) do
      if part == "" then
        if not was_blank then
          was_blank = true
          i = i + 1
          result[i] = part
        end
      else
        was_blank = false
        i = i + 1
        result[i] = part
      end
    end

    return result
  end
end

--- @spec path_dirname(a: String): String
function foundation.com.path_dirname(a)
  local components = foundation.com.path_components(a)

  if components[2] then
    -- it has 2 or more components
    components[#components] = nil
    if components[2] then
      return table.concat(components, DIR_DELIM)
    else
      if components[1] == "" then
        return "/"
      else
        return components[1]
      end
    end
  else
    -- has an initial component
    if components[1] then
      return "/" .. components[1]
    else
      return "."
    end
  end
end

--- @spec path_basename(a: String): String
function foundation.com.path_basename(a)
  local components = foundation.com.path_components(a)
  if components[1] then
    local item = components[#components]
    if item == "" then
      return ""
    end
    return item
  end
  return ""
end

--- @spec path_join(a: String, b: String): String
function foundation.com.path_join(a, b)
  a = foundation.com.string_trim_trailing(a, DIR_DELIM)
  b = foundation.com.string_trim_leading(b, DIR_DELIM)

  return a .. DIR_DELIM .. b
end
