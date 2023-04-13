--- @namespace foundation.com.Vector2
local xy = {"x", "y"}

local vector2
vector2 = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xy[key]) or vector2[key]
    end,

    __newindex = function (v, key, value)
      rawset(v, xy[key] or key, value)
    end,
  },
}

--- @type Vector2: {
---   x: Number,
---   y: Number,
--- }

--- @spec new(x: Number, y: Number): Vector2
function vector2.new(x, y)
  return setmetatable({ x = x, y = y }, vector2.metatable)
end

--- @spec copy(Vector2): Vector2
function vector2.copy(v1)
  return vector2.new(v1.x, v1.y)
end

--- @spec unwrap(Any): (Number, Number)
function vector2.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y
  elseif type(v) == "number" then
    return v, v
  end
  error("expected a table or number")
end

--- @spec zero(): Vector2
function vector2.zero()
  return vector2.new(0, 0)
end

--- @spec to_string(Vector2, seperator?: String): String
function vector2.to_string(v2, seperator)
  seperator = seperator or ","
  return v2.x .. seperator .. v2.y
end

--- @spec equals(a: Vector2, b: Vector2): Boolean
function vector2.equals(a, b)
  return a.x == b.x and a.y == b.y
end

--- @spec distance(a: Vector2, b: Vector2): Float
function vector2.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y

  return math.sqrt(x + y)
end

--- @spec floor(dest: Vector2, v2: Vector2): Vector2
function vector2.floor(dest, v2)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = math.floor(v2x)
  dest.y = math.floor(v2y)
  return dest
end

--- @spec ceil(dest: Vector2, v2: Vector2): Vector2
function vector2.ceil(dest, v2)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = math.ceil(v2x)
  dest.y = math.ceil(v2y)
  return dest
end

--- @spec round(dest: Vector2, v2: Vector2): Vector2
function vector2.round(dest, v2)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = math.floor(v2x + 0.5)
  dest.y = math.floor(v2y + 0.5)
  return dest
end

--- @spec dot(Vector2, Vector2): Vector2
function vector2.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

--- @spec add(dest: Vector2, Vector2, Vector2): Vector2
function vector2.add(dest, v1, v2)
  local v1x, v1y = vector2.unwrap(v1)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  return dest
end

--- @spec subtract(dest: Vector2, Vector2, Vector2): Vector2
function vector2.subtract(dest, v1, v2)
  local v1x, v1y = vector2.unwrap(v1)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  return dest
end

--- @spec multiply(dest: Vector2, Vector2, Vector2): Vector2
function vector2.multiply(dest, v1, v2)
  local v1x, v1y = vector2.unwrap(v1)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  return dest
end

--- @spec divide(dest: Vector2, Vector2, Vector2): Vector2
function vector2.divide(dest, v1, v2)
  local v1x, v1y = vector2.unwrap(v1)
  local v2x, v2y = vector2.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  return dest
end

--- @spec idivide(dest: Vector2, Vector2, Vector2): Vector2
function vector2.idivide(dest, v1, v2)
  local v1x, v1y = vector2.unwrap(v1)
  local v2x, v2y = vector2.unwrap(v2)

  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  return dest
end

--- @since "1.28.0"
--- @spec apply(dest: Vector2, source: Vector2, func: Function/1): Vector2
function vector2.apply(dest, v1, func)
  local v1x, v1y = vector2.unwrap(v1)
  dest.x = func(v1x)
  dest.y = func(v1y)
  return dest
end

--- Intended to be used by persistence systems to dump a vector2 to a plain table
---
--- @spec dump_data(Vector2): Table
function vector2.dump_data(vec)
  return { x = vec.x, y = vec.y }
end

--- @spec load_data(Table): Vector2
function vector2.load_data(data)
  return vector2.new(data.x, data.y)
end

vector2.sub = vector2.subtract
vector2.mul = vector2.multiply
vector2.div = vector2.divide
vector2.idiv = vector2.idivide

--- @since "1.27.0"
--- @spec metatable.__tostring(Vector2): String
vector2.metatable.__tostring = assert(vector2.to_string)

--- @since "1.27.0"
--- @spec metatable.__eq(Vector2, Vector2): Boolean
vector2.metatable.__eq = assert(vector2.equals)

--- @since "1.27.0"
--- @spec vector2.metatable.__unm(Vector2): Vector2
function vector2.metatable.__unm(v2)
  return vector2.new(
    -v2.x,
    -v2.y
  )
end

--- @since "1.27.0"
--- @spec metatable.__add(Vector2, Vector2): Vector2
function vector2.metatable.__add(a, b)
  local v2x, v2y = vector2.unwrap(b)
  return vector2.new(
    a.x + v2x,
    a.y + v2y
  )
end

--- @since "1.27.0"
--- @spec metatable.__sub(Vector2, Vector2): Vector2
function vector2.metatable.__sub(a, b)
  local v2x, v2y = vector2.unwrap(b)
  return vector2.new(
    a.x - v2x,
    a.y - v2y
  )
end

--- @since "1.27.0"
--- @spec metatable.__mul(Vector2, Vector2): Vector2
function vector2.metatable.__mul(a, b)
  local v2x, v2y = vector2.unwrap(b)
  return vector2.new(
    a.x * v2x,
    a.y * v2y
  )
end

--- @since "1.27.0"
--- @spec metatable.__div(Vector2, Vector2): Vector2
function vector2.metatable.__div(a, b)
  local v2x, v2y = vector2.unwrap(b)
  return vector2.new(
    a.x / v2x,
    a.y / v2y
  )
end

foundation.com.Vector2 = vector2
