local number_round = assert(foundation.com.number_round)

--- @namespace foundation.com.Vector2
local xy = {"x", "y"}

local m
m = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xy[key]) or m[key]
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

--- @since "1.29.0"
--- @spec is_vector2(obj: Any): Boolean
function m.is_vector2(obj)
  return getmetatable(obj) == m.metatable
end

--- @spec new(x: Number, y: Number): Vector2
function m.new(x, y)
  return setmetatable({ x = x, y = y }, m.metatable)
end

--- @spec copy(Vector2): Vector2
function m.copy(v1)
  return m.new(v1.x, v1.y)
end

--- @spec unwrap(Any): (Number, Number)
function m.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y
  elseif type(v) == "number" then
    return v, v
  end
  error("expected a table or number")
end

--- @spec zero(): Vector2
function m.zero()
  return m.new(0, 0)
end

--- @spec to_string(Vector2, seperator?: String): String
function m.to_string(v2, seperator)
  seperator = seperator or ","
  return v2.x .. seperator .. v2.y
end

--- @since "1.29.0"
--- @spec inspect(Vector2, seperator?: String): String
function m.inspect(v2, seperator)
  seperator = seperator or ","
  return "(" .. v2.x .. seperator .. v2.y .. ")"
end

--- @spec equals(a: Vector2, b: Vector2): Boolean
function m.equals(a, b)
  return a.x == b.x and a.y == b.y
end

--- @spec distance(a: Vector2, b: Vector2): Number
function m.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y

  return math.sqrt(x + y)
end

--- @since "1.29.0"
--- @spec length(a: Vector2): Number
--- @spec #length(): Number
function m.length(a)
  return math.sqrt(a.x * a.x + a.y * a.y)
end

--- @spec floor(dest: Vector2, v2: Vector2): Vector2
function m.floor(dest, v2)
  local v2x, v2y = m.unwrap(v2)
  dest.x = math.floor(v2x)
  dest.y = math.floor(v2y)
  return dest
end

--- @spec ceil(dest: Vector2, v2: Vector2): Vector2
function m.ceil(dest, v2)
  local v2x, v2y = m.unwrap(v2)
  dest.x = math.ceil(v2x)
  dest.y = math.ceil(v2y)
  return dest
end

--- @since "1.44.0"
--- @spec truncate(dest: Vector2, v2: Vector2): Vector2
--- @spec #truncate(v2: Vector2): Vector3
function m.truncate(dest, v2)
  local v2x, v2y = m.unwrap(v2)
  dest.x = number_truncate(v2x, places)
  dest.y = number_truncate(v2y, places)
  return dest
end

--- @spec round(dest: Vector2, v2: Vector2): Vector2
--- @spec #round(v2: Vector2): Vector2
--- @since "1.40.0"
--- @spec round(dest: Vector2, v2: Vector2, places?: Integer): Vector2
--- @spec #round(v2: Vector2, places?: Integer): Vector2
function m.round(dest, v2, places)
  local v2x, v2y = m.unwrap(v2)
  dest.x = number_round(v2x, places)
  dest.y = number_round(v2y, places)
  return dest
end

--- @spec dot(Vector2, Vector2): Vector2
function m.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

--- @since "1.40.0"
--- @mutative dest
--- @spec normalize(dest: Vector2, v1: Vector2): Vector2
function m.normalize(dest, v1)
  local x, y = m.unwrap(v1)
  local len = math.sqrt(x * x + y * y)
  return m.divide(dest, v1, len)
end

--- @spec add(dest: Vector2, Vector2, Vector2): Vector2
function m.add(dest, v1, v2)
  local v1x, v1y = m.unwrap(v1)
  local v2x, v2y = m.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  return dest
end

--- @spec subtract(dest: Vector2, Vector2, Vector2): Vector2
function m.subtract(dest, v1, v2)
  local v1x, v1y = m.unwrap(v1)
  local v2x, v2y = m.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  return dest
end

--- @spec multiply(dest: Vector2, Vector2, Vector2): Vector2
function m.multiply(dest, v1, v2)
  local v1x, v1y = m.unwrap(v1)
  local v2x, v2y = m.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  return dest
end

--- @spec divide(dest: Vector2, Vector2, Vector2): Vector2
function m.divide(dest, v1, v2)
  local v1x, v1y = m.unwrap(v1)
  local v2x, v2y = m.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  return dest
end

--- @spec idivide(dest: Vector2, Vector2, Vector2): Vector2
function m.idivide(dest, v1, v2)
  local v1x, v1y = m.unwrap(v1)
  local v2x, v2y = m.unwrap(v2)

  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  return dest
end

--- @since "1.28.0"
--- @spec apply(dest: Vector2, source: Vector2, func: Function/1): Vector2
function m.apply(dest, v1, func)
  local v1x, v1y = m.unwrap(v1)
  dest.x = func(v1x)
  dest.y = func(v1y)
  return dest
end

--- http://number-none.com/product/Understanding%20Slerp,%20Then%20Not%20Using%20It/
---
--- @since "1.40.0"
--- @mutative dest
--- @spec slerp(dest: Vector2, v1: Vector2, v2: Vector2, t: Number): Vector2
--- @spec #slerp(v1: Vector2, v2: Vector2, t: Number): Vector2
function m.slerp(dest, v1, v2, t)
  local dot = m.dot(v1, v2)
  if dot < -1 then
    dot = -1
  elseif dot > 1 then
    dot = 1
  end
  local theta = math.acos(dot) * t
  local tmp = m.multiply({}, v1, dot)
  tmp = m.subtract(tmp, v2, tmp)
  tmp = m.normalize(tmp, tmp)
  dest = m.multiply(dest, v1, math.cos(theta))
  tmp = m.multiply(tmp, tmp, math.sin(theta))
  return m.add(dest, dest, tmp)
end

--- Intended to be used by persistence systems to dump a vector2 to a plain table
---
--- @spec dump_data(Vector2): Table
function m.dump_data(vec)
  return { x = vec.x, y = vec.y }
end

--- @spec load_data(Table): Vector2
function m.load_data(data)
  return m.new(data.x, data.y)
end

m.sub = m.subtract
m.mul = m.multiply
m.div = m.divide
m.idiv = m.idivide

--- @since "1.27.0"
--- @spec metatable.__tostring(Vector2): String
m.metatable.__tostring = assert(m.to_string)

--- @since "1.27.0"
--- @spec metatable.__eq(Vector2, Vector2): Boolean
m.metatable.__eq = assert(m.equals)

--- @since "1.27.0"
--- @spec metatable.__unm(Vector2): Vector2
function m.metatable.__unm(v2)
  return m.new(
    -v2.x,
    -v2.y
  )
end

--- @since "1.27.0"
--- @spec metatable.__add(Vector2, Vector2): Vector2
function m.metatable.__add(a, b)
  local v2x, v2y = m.unwrap(b)
  return m.new(
    a.x + v2x,
    a.y + v2y
  )
end

--- @since "1.27.0"
--- @spec metatable.__sub(Vector2, Vector2): Vector2
function m.metatable.__sub(a, b)
  local v2x, v2y = m.unwrap(b)
  return m.new(
    a.x - v2x,
    a.y - v2y
  )
end

--- @since "1.27.0"
--- @spec metatable.__mul(Vector2, Vector2): Vector2
function m.metatable.__mul(a, b)
  local v2x, v2y = m.unwrap(b)
  return m.new(
    a.x * v2x,
    a.y * v2y
  )
end

--- @since "1.27.0"
--- @spec metatable.__div(Vector2, Vector2): Vector2
function m.metatable.__div(a, b)
  local v2x, v2y = m.unwrap(b)
  return m.new(
    a.x / v2x,
    a.y / v2y
  )
end

foundation.com.Vector2 = m
