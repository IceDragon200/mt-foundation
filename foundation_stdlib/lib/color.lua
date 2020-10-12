local Color = {}

-- @type Byte :: 0..255
--
-- @spec new(Byte, Byte, Byte, Byte) :: Color
function Color.new(r, g, b, a)
  return { r = r, g = g, b = b, a = a or 255 }
end

-- @spec add(Color, Color) :: Color
function Color.add(a, b)
  return {
    r = math.min((a.r * a.a / 255) + (b.r * b.a / 255), 255),
    g = math.min((a.g * a.a / 255) + (b.g * b.a / 255), 255),
    b = math.min((a.b * a.a / 255) + (b.b * b.a / 255), 255),
    a = 255,
  }
end

-- @spec sub(Color, Color) :: Color
function Color.sub(a, b)
  return {
    r = math.max((a.r * a.a / 255) - (b.r * b.a / 255), 0),
    g = math.max((a.g * a.a / 255) - (b.g * b.a / 255), 0),
    b = math.max((a.b * a.a / 255) - (b.b * b.a / 255), 0),
    a = 255,
  }
end

-- @spec mult(Color, Color) :: Color
function Color.mult(a, b)
  return {
    r = (a.r * a.a / 255) * (b.r * b.a / 255) / 255,
    g = (a.g * a.a / 255) * (b.g * b.a / 255) / 255,
    b = (a.b * a.a / 255) * (b.b * b.a / 255) / 255,
    a = 255,
  }
end

-- to_string32(Color) :: String
function Color.to_string32(color)
  local result = "#" ..
    foundation.com.byte_to_hexpair(color.r) ..
    foundation.com.byte_to_hexpair(color.g) ..
    foundation.com.byte_to_hexpair(color.b) ..
    foundation.com.byte_to_hexpair(color.a)

  return result
end

-- to_string24(Color) :: String
function Color.to_string24(color)
  local result = "#" ..
    foundation.com.byte_to_hexpair(color.r) ..
    foundation.com.byte_to_hexpair(color.g) ..
    foundation.com.byte_to_hexpair(color.b)

  return result
end

-- to_string16(Color) :: String
function Color.to_string16(color)
  local result = "#" ..
    foundation.com.nibble_to_hex(math.floor(color.r / 16)) ..
    foundation.com.nibble_to_hex(math.floor(color.g / 16)) ..
    foundation.com.nibble_to_hex(math.floor(color.b / 16)) ..
    foundation.com.nibble_to_hex(math.floor(color.a / 16))

  return result
end

-- to_string12(Color) :: String
function Color.to_string12(color)
  local result = "#" ..
    foundation.com.nibble_to_hex(math.floor(color.r / 16)) ..
    foundation.com.nibble_to_hex(math.floor(color.g / 16)) ..
    foundation.com.nibble_to_hex(math.floor(color.b / 16))

  return result
end

foundation.com.Color = Color
