--- @namespace foundation.com.Color

local byte_to_hexpair = assert(foundation.com.byte_to_hexpair)
local hexpair_to_byte = assert(foundation.com.string_hex_pair_to_byte)
local nibble_to_hex = assert(foundation.com.nibble_to_hex)
local table_freeze = assert(foundation.com.table_freeze)

local function hex_to_color_byte(hex)
  return hexpair_to_byte(hex .. hex)
end

local Color = {

}

--- @type Byte: Integer/8
---
--- @type Color: {
---   r: Byte,
---   g: Byte,
---   b: Byte,
---   a: Byte,
--- }

local function color_channel_clamp(a)
  return math.max(math.min(math.floor(a), 255), 0)
end

local function channel_overlay(a, b)
  local r
  local n = a / 255.0
  local n2 = b / 255.0

  if n < 0.5 then
    r = 2 * (n * n2)
  else
    r = 1 - 2 * (1 - n) * (1 - n2)
  end

  return color_channel_clamp(r * 255)
end

local function channel_hard_light(a, b)
  local r
  local n = a / 255.0
  local n2 = b / 255.0

  if n2 < 0.5 then
    r = 2 * (n * n2)
  else
    r = 1 - 2 * (1 - n) * (1 - n2)
  end

  return color_channel_clamp(r * 255)
end

---
--- @spec new(r: Byte, g: Byte, b: Byte, a?: Byte): Color
function Color.new(r, g, b, a)
  return { r = r, g = g, b = b, a = a or 255 }
end

--- @spec copy(Color): Color
function Color.copy(color)
  return {
    r = color.r,
    g = color.g,
    b = color.b,
    a = color.a,
  }
end

--- @spec lerp(a: Color, b: Color, d: Number): Color
function Color.lerp(a, b, d)
  return {
    r = color_channel_clamp(a.r + (b.r - a.r) * d),
    g = color_channel_clamp(a.g + (b.g - a.g) * d),
    b = color_channel_clamp(a.b + (b.b - a.b) * d),
    a = color_channel_clamp(a.a + (b.a - a.a) * d),
  }
end

--- @spec add(Color, Color): Color
function Color.add(a, b)
  return {
    r = color_channel_clamp((a.r * a.a / 255) + (b.r * b.a / 255), 255),
    g = color_channel_clamp((a.g * a.a / 255) + (b.g * b.a / 255), 255),
    b = color_channel_clamp((a.b * a.a / 255) + (b.b * b.a / 255), 255),
    a = 255,
  }
end

--- @spec sub(Color, Color): Color
function Color.sub(a, b)
  return {
    r = color_channel_clamp((a.r * a.a / 255) - (b.r * b.a / 255), 0),
    g = color_channel_clamp((a.g * a.a / 255) - (b.g * b.a / 255), 0),
    b = color_channel_clamp((a.b * a.a / 255) - (b.b * b.a / 255), 0),
    a = 255,
  }
end

--- @spec mult(Color, Color): Color
function Color.mult(a, b)
  return {
    r = color_channel_clamp((a.r * a.a / 255) * (b.r * b.a / 255) / 255),
    g = color_channel_clamp((a.g * a.a / 255) * (b.g * b.a / 255) / 255),
    b = color_channel_clamp((a.b * a.a / 255) * (b.b * b.a / 255) / 255),
    a = 255,
  }
end

--- @spec blend_overlay(Color, Color): Color
function Color.blend_overlay(a, b)
  return {
    r = channel_overlay(a.r, b.r),
    g = channel_overlay(a.g, b.g),
    b = channel_overlay(a.b, b.b),
    a = color_channel_clamp(a.a * b.a / 255),
  }
end

--- @spec blend_hard_light(Color, Color): Color
function Color.blend_hard_light(a, b)
  return {
    r = channel_hard_light(a.r, b.r),
    g = channel_hard_light(a.g, b.g),
    b = channel_hard_light(a.b, b.b),
    a = color_channel_clamp(a.a * b.a / 255),
  }
end

--- @spec blend_multiply(Color, Color): Color
function Color.blend_multiply(a, b)
  return {
    r = color_channel_clamp(a.r * b.r / 255),
    g = color_channel_clamp(a.g * b.g / 255),
    b = color_channel_clamp(a.b * b.b / 255),
    a = color_channel_clamp(a.a * b.a / 255),
  }
end

--- @spec to_grayscale_value(Color): Integer
function Color.to_grayscale_value(color)
  return color_channel_clamp(0.299 * color.r + 0.587 * color.g + 0.114 * color.b)
end

--- @spec to_grayscale(Color): Color
function Color.to_grayscale(color)
  local y = Color.to_grayscale_value(color)
  return {
    r = y,
    g = y,
    b = y,
    a = y,
  }
end

--- @spec to_string32(Color): String
function Color.to_string32(color)
  local result = "#" ..
    byte_to_hexpair(color.r) ..
    byte_to_hexpair(color.g) ..
    byte_to_hexpair(color.b) ..
    byte_to_hexpair(color.a)

  return result
end

--- @spec to_string24(Color): String
function Color.to_string24(color)
  local result = "#" ..
    byte_to_hexpair(color.r) ..
    byte_to_hexpair(color.g) ..
    byte_to_hexpair(color.b)

  return result
end

--- @spec to_string16(Color): String
function Color.to_string16(color)
  local result = "#" ..
    nibble_to_hex(math.floor(color.r / 16)) ..
    nibble_to_hex(math.floor(color.g / 16)) ..
    nibble_to_hex(math.floor(color.b / 16)) ..
    nibble_to_hex(math.floor(color.a / 16))

  return result
end

--- @spec to_string12(Color): String
function Color.to_string12(color)
  local result = "#" ..
    nibble_to_hex(math.floor(color.r / 16)) ..
    nibble_to_hex(math.floor(color.g / 16)) ..
    nibble_to_hex(math.floor(color.b / 16))

  return result
end

--- Converts the given colorstring into a Color table or nil if it was named but doesn't exist.
---
--- @spec from_colorstring(colorstring: String): Color | nil
function Color.from_colorstring(colorstring)
  if colorstring:sub(1, 1) == "#" then
    local rest = colorstring:sub(2)

    local len = #rest
    local r
    local g
    local b
    local a

    if len == 3 then
      -- RGB
      r = hex_to_color_byte(rest:sub(1, 1))
      g = hex_to_color_byte(rest:sub(2, 2))
      b = hex_to_color_byte(rest:sub(3, 3))
      a = 0xFF
    elseif len == 4 then
      -- RGBA
      r = hex_to_color_byte(rest:sub(1, 1))
      g = hex_to_color_byte(rest:sub(2, 2))
      b = hex_to_color_byte(rest:sub(3, 3))
      a = hex_to_color_byte(rest:sub(4, 4))
    elseif len == 6 then
      -- RRGGBB
      r = hexpair_to_byte(rest:sub(1, 2))
      g = hexpair_to_byte(rest:sub(3, 4))
      b = hexpair_to_byte(rest:sub(5, 6))
      a = 0xFF
    elseif len == 8 then
      -- RRGGBBAA
      r = hexpair_to_byte(rest:sub(1, 2))
      g = hexpair_to_byte(rest:sub(3, 4))
      b = hexpair_to_byte(rest:sub(5, 6))
      a = hexpair_to_byte(rest:sub(7, 8))
    else
      error("invalid colorstring=" .. colorstring)
    end

    return {
      r = r,
      g = g,
      b = b,
      a = a
    }
  else
    local idx = colorstring:find("#")
    local name = colorstring
    local alpha = 255

    if idx then
      name = colorstring:sub(1, idx - 1)
      alpha = hexpair_to_byte(colorstring:sub(idx, #colorstring))
    end

    local color = Color.NAMED[name]

    if color then
      color = Color.copy(color)
      color.a = alpha
      return color
    else
      return nil
    end
  end
end

---
--- Takes any value and may or may not return a valid color string.
---
--- @exception
--- @spec maybe_to_colorstring(value: Any): String
function Color.maybe_to_colorstring(value)
  if type(value) == "string" then
    return value
  elseif type(value) == "table" then
    if value.a then
      return Color.to_string32(value)
    else
      return Color.to_string24(value)
    end
  else
    error("unexpected color value=" .. dump(value))
  end
end

--- @spec maybe_to_color(value: String | Table | Color): Color
function Color.maybe_to_color(value)
  if type(value) == "string" then
    return Color.from_colorstring(value)
  elseif type(value) == "table" then
    assert(value.r and value.g and value.b and value.a)
    return value
  else
    error("unexpected value=" .. dump(value))
  end
end

-- https://www.w3.org/TR/css-color-4/#named-color
Color.NAMED = {
  aliceblue =            Color.new(240, 248, 255),
  antiquewhite =         Color.new(250, 235, 215),
  aqua =                 Color.new(0, 255, 255),
  aquamarine =           Color.new(127, 255, 212),
  azure =                Color.new(240, 255, 255),
  beige =                Color.new(245, 245, 220),
  bisque =               Color.new(255, 228, 196),
  black =                Color.new(0, 0, 0),
  blanchedalmond =       Color.new(255, 235, 205),
  blue =                 Color.new(0, 0, 255),
  blueviolet =           Color.new(138, 43, 226),
  brown =                Color.new(165, 42, 42),
  burlywood =            Color.new(222, 184, 135),
  cadetblue =            Color.new(95, 158, 160),
  chartreuse =           Color.new(127, 255, 0),
  chocolate =            Color.new(210, 105, 30),
  coral =                Color.new(255, 127, 80),
  cornflowerblue =       Color.new(100, 149, 237),
  cornsilk =             Color.new(255, 248, 220),
  crimson =              Color.new(220, 20, 60),
  cyan =                 Color.new(0, 255, 255),
  darkblue =             Color.new(0, 0, 139),
  darkcyan =             Color.new(0, 139, 139),
  darkgoldenrod =        Color.new(184, 134, 11),
  darkgray =             Color.new(169, 169, 169),
  darkgreen =            Color.new(0, 100, 0),
  darkgrey =             Color.new(169, 169, 169),
  darkkhaki =            Color.new(189, 183, 107),
  darkmagenta =          Color.new(139, 0, 139),
  darkolivegreen =       Color.new(85, 107, 47),
  darkorange =           Color.new(255, 140, 0),
  darkorchid =           Color.new(153, 50, 204),
  darkred =              Color.new(139, 0, 0),
  darksalmon =           Color.new(233, 150, 122),
  darkseagreen =         Color.new(143, 188, 143),
  darkslateblue =        Color.new(72, 61, 139),
  darkslategray =        Color.new(47, 79, 79),
  darkslategrey =        Color.new(47, 79, 79),
  darkturquoise =        Color.new(0, 206, 209),
  darkviolet =           Color.new(148, 0, 211),
  deeppink =             Color.new(255, 20, 147),
  deepskyblue =          Color.new(0, 191, 255),
  dimgray =              Color.new(105, 105, 105),
  dimgrey =              Color.new(105, 105, 105),
  dodgerblue =           Color.new(30, 144, 255),
  firebrick =            Color.new(178, 34, 34),
  floralwhite =          Color.new(255, 250, 240),
  forestgreen =          Color.new(34, 139, 34),
  fuchsia =              Color.new(255, 0, 255),
  gainsboro =            Color.new(220, 220, 220),
  ghostwhite =           Color.new(248, 248, 255),
  gold =                 Color.new(255, 215, 0),
  goldenrod =            Color.new(218, 165, 32),
  gray =                 Color.new(128, 128, 128),
  green =                Color.new(0, 128, 0),
  greenyellow =          Color.new(173, 255, 47),
  grey =                 Color.new(128, 128, 128),
  honeydew =             Color.new(240, 255, 240),
  hotpink =              Color.new(255, 105, 180),
  indianred =            Color.new(205, 92, 92),
  indigo =               Color.new(75, 0, 130),
  ivory =                Color.new(255, 255, 240),
  khaki =                Color.new(240, 230, 140),
  lavender =             Color.new(230, 230, 250),
  lavenderblush =        Color.new(255, 240, 245),
  lawngreen =            Color.new(124, 252, 0),
  lemonchiffon =         Color.new(255, 250, 205),
  lightblue =            Color.new(173, 216, 230),
  lightcoral =           Color.new(240, 128, 128),
  lightcyan =            Color.new(224, 255, 255),
  lightgoldenrodyellow = Color.new(250, 250, 210),
  lightgray =            Color.new(211, 211, 211),
  lightgreen =           Color.new(144, 238, 144),
  lightgrey =            Color.new(211, 211, 211),
  lightpink =            Color.new(255, 182, 193),
  lightsalmon =          Color.new(255, 160, 122),
  lightseagreen =        Color.new(32, 178, 170),
  lightskyblue =         Color.new(135, 206, 250),
  lightslategray =       Color.new(119, 136, 153),
  lightslategrey =       Color.new(119, 136, 153),
  lightsteelblue =       Color.new(176, 196, 222),
  lightyellow =          Color.new(255, 255, 224),
  lime =                 Color.new(0, 255, 0),
  limegreen =            Color.new(50, 205, 50),
  linen =                Color.new(250, 240, 230),
  magenta =              Color.new(255, 0, 255),
  maroon =               Color.new(128, 0, 0),
  mediumaquamarine =     Color.new(102, 205, 170),
  mediumblue =           Color.new(0, 0, 205),
  mediumorchid =         Color.new(186, 85, 211),
  mediumpurple =         Color.new(147, 112, 219),
  mediumseagreen =       Color.new(60, 179, 113),
  mediumslateblue =      Color.new(123, 104, 238),
  mediumspringgreen =    Color.new(0, 250, 154),
  mediumturquoise =      Color.new(72, 209, 204),
  mediumvioletred =      Color.new(199, 21, 133),
  midnightblue =         Color.new(25, 25, 112),
  mintcream =            Color.new(245, 255, 250),
  mistyrose =            Color.new(255, 228, 225),
  moccasin =             Color.new(255, 228, 181),
  navajowhite =          Color.new(255, 222, 173),
  navy =                 Color.new(0, 0, 128),
  oldlace =              Color.new(253, 245, 230),
  olive =                Color.new(128, 128, 0),
  olivedrab =            Color.new(107, 142, 35),
  orange =               Color.new(255, 165, 0),
  orangered =            Color.new(255, 69, 0),
  orchid =               Color.new(218, 112, 214),
  palegoldenrod =        Color.new(238, 232, 170),
  palegreen =            Color.new(152, 251, 152),
  paleturquoise =        Color.new(175, 238, 238),
  palevioletred =        Color.new(219, 112, 147),
  papayawhip =           Color.new(255, 239, 213),
  peachpuff =            Color.new(255, 218, 185),
  peru =                 Color.new(205, 133, 63),
  pink =                 Color.new(255, 192, 203),
  plum =                 Color.new(221, 160, 221),
  powderblue =           Color.new(176, 224, 230),
  purple =               Color.new(128, 0, 128),
  rebeccapurple =        Color.new(102, 51, 153),
  red =                  Color.new(255, 0, 0),
  rosybrown =            Color.new(188, 143, 143),
  royalblue =            Color.new(65, 105, 225),
  saddlebrown =          Color.new(139, 69, 19),
  salmon =               Color.new(250, 128, 114),
  sandybrown =           Color.new(244, 164, 96),
  seagreen =             Color.new(46, 139, 87),
  seashell =             Color.new(255, 245, 238),
  sienna =               Color.new(160, 82, 45),
  silver =               Color.new(192, 192, 192),
  skyblue =              Color.new(135, 206, 235),
  slateblue =            Color.new(106, 90, 205),
  slategray =            Color.new(112, 128, 144),
  slategrey =            Color.new(112, 128, 144),
  snow =                 Color.new(255, 250, 250),
  springgreen =          Color.new(0, 255, 127),
  steelblue =            Color.new(70, 130, 180),
  tan =                  Color.new(210, 180, 140),
  teal =                 Color.new(0, 128, 128),
  thistle =              Color.new(216, 191, 216),
  tomato =               Color.new(255, 99, 71),
  turquoise =            Color.new(64, 224, 208),
  violet =               Color.new(238, 130, 238),
  wheat =                Color.new(245, 222, 179),
  white =                Color.new(255, 255, 255),
  whitesmoke =           Color.new(245, 245, 245),
  yellow =               Color.new(255, 255, 0),
  yellowgreen =          Color.new(154, 205, 50),
}

for name, color in pairs(Color.NAMED) do
  -- prevent the color from being modified
  table_freeze(color)
end

foundation.com.Color = Color
