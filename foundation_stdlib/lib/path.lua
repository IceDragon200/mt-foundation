-- @namespace foundation.com

local SEPARATOR_BYTE = string.byte("/")

-- @spec path_dirname(a: String): String
function foundation.com.path_dirname(a)
  local len = string.len(a)
  local tail = string.len(a)
  local b = string.byte(a, tail)

  if tail == 0 then
    return "."
  else
    local i = tail

    while i > 0 do
      b = string.byte(a, i)

      if b == SEPARATOR_BYTE then
        return string.sub(a, 1, i)
      end
    end

    if tail == len then
      return a
    else
      return string.sub(a, 1, tail)
    end
  end
end

-- @spec path_basename(a: String): String
function foundation.com.path_basename(a)
  local len = string.len(a)
  local tail = string.len(a)
  local b = string.byte(a, tail)

  -- if string ends with a /, shorten the initial length to exclude it
  while tail > 0 and b == SEPARATOR_BYTE do
    tail = tail - 1
    b = string.byte(a, tail)
  end

  if tail == 0 then
    return ""
  else
    local i = tail

    while i > 0 do
      b = string.byte(a, i)

      if b == SEPARATOR_BYTE then
        return string.sub(a, i+1, tail)
      end
    end

    if tail == len then
      return a
    else
      return string.sub(a, 1, tail)
    end
  end
end

-- @spec path_join(a: String, b: String): String
function foundation.com.path_join(a, b)
  local a = foundation.com.string_trim_trailing(a, "/")
  local b = foundation.com.string_trim_leading(b, "/")

  return a .. "/" .. b
end
