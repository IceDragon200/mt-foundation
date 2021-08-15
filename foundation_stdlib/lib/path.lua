-- @namespace foundation.com

function foundation.com.path_join(a, b)
  local a = foundation.com.string_trim_trailing(a, "/")
  local b = foundation.com.string_trim_leading(b, "/")

  return a .. "/" .. b
end
