-- @namespace foundation.com

-- @spec is_blank(value: Any): Boolean
function foundation.com.is_blank(value)
  if value == nil then
    return true
  elseif value == "" then
    return true
  else
    return false
  end
end

local is_blank = foundation.com.is_blank

--
-- Takes a list of arguments, and returns the first non-blank one
--
-- @spec first_present(...Any): Any
function foundation.com.first_present(...)
  for _, value in ipairs({...}) do
    if not is_blank(value) then
      return value
    end
  end
  return nil
end

--
--
-- @spec deep_equals(Value, Value): Boolean
local function deep_equals(a, b, depth)
  depth = depth or 0
  if depth > 20 then
    error("deep_equals depth exceeded")
  end

  if type(a) == type(b) then
    if type(a) == "table" then
      local keys = {}
      for k, _ in pairs(a) do
        keys[k] = true
      end
      for k, _ in pairs(b) do
        keys[k] = true
      end

      for k, _ in pairs(keys) do
        if not deep_equals(a[k], b[k], depth + 1) then
          return false
        end
      end
      return true
    else
      return a == b
    end
  else
    return false
  end
end

foundation.com.deep_equals = deep_equals
