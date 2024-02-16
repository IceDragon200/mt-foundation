local number_round = assert(foundation.com.number_round)

--- @namespace foundation.com.Vector3
local xyz = {"x", "y", "z"}
local m
m = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xyz[key]) or m[key]
    end,

    __newindex = function (v, key, value)
      rawset(v, xyz[key] or key, value)
    end,
  },
}

--- @type Vector3: {
---   x: Number,
---   y: Number,
---   z: Number,
--- }

--- @since "1.29.0"
--- @spec is_m(obj: Any): Boolean
function m.is_m(obj)
  return getmetatable(obj) == m.metatable
end

--- @spec new(x: Number, y: Number, z: Number): Vector3
function m.new(x, y, z)
  return setmetatable({ x = x, y = y, z = z }, m.metatable)
end

--- @spec copy(Vector3): Vector3
function m.copy(v1)
  return m.new(v1.x, v1.y, v1.z)
end

--- @spec new(Any): (Number, Number, Number)
function m.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z
  elseif type(v) == "number" then
    return v, v, v
  end
  error("expected a table or number")
end

--- @spec zero(): Vector3
function m.zero()
  return m.new(0, 0, 0)
end

--- @spec to_string(Vector3, seperator?: String): String
function m.to_string(v1, seperator)
  seperator = seperator or ","
  return v1.x .. seperator .. v1.y .. seperator .. v1.z
end

--- @since "1.29.0"
--- @spec inspect(Vector3, seperator?: String): String
function m.inspect(v1, seperator)
  seperator = seperator or ","
  return "(" .. v1.x .. seperator .. v1.y .. seperator .. v1.z .. ")"
end

--- @spec equals(a: Vector3, b: Vector3): Boolean
function m.equals(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z
end

--- @spec distance(a: Vector3, b: Vector3): Number
function m.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y
  local z = a.z - b.z
  z = z * z

  return math.sqrt(x + y + z)
end

--- @since "1.29.0"
--- @spec length(a: Vector3): Number
--- @spec #length(): Number
function m.length(a)
  return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

--- @spec floor(Vector3, Vector3): Vector3
function m.floor(dest, v2)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = math.floor(v2x)
  dest.y = math.floor(v2y)
  dest.z = math.floor(v2z)
  return dest
end

--- @spec ceil(Vector3, Vector3): Vector3
function m.ceil(dest, v2)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = math.ceil(v2x)
  dest.y = math.ceil(v2y)
  dest.z = math.ceil(v2z)
  return dest
end

--- @spec round(dest: Vector3, v2: Vector3): Vector3
--- @spec #round(v2: Vector3): Vector3
--- @since "1.40.0"
--- @spec round(dest: Vector3, v2: Vector3, places?: Number): Vector3
--- @spec #round(v2: Vector3, places?: Number): Vector3
function m.round(dest, v2, places)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = number_round(v2x, places)
  dest.y = number_round(v2y, places)
  dest.z = number_round(v2z, places)
  return dest
end

--- @spec dot(Vector3, Vector3): Number
function m.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

--- @since "1.40.0"
--- @mutative dest
--- @spec normalize(dest: Vector3, v1: Vector3): Vector3
function m.normalize(dest, v1)
  local x, y, z = m.unwrap(v1)
  local len = math.sqrt(x * x + y * y + z * z)
  return m.divide(dest, v1, len)
end

--- @since "1.27.0"
--- @spec cross(Vector3, Vector3, Vector3): Vector3
function m.cross(dest, v1, v2)
  local v1x, v1y, v1z = m.unwrap(v1)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = v1y * v2z - v1z * v2y
  dest.y = v1z * v2x - v1x * v2z
  dest.z = v1x * v2y - v1y * v2x
  return dest
end

--- @spec add(dest: Vector3, Vector3, Vector3): Vector3
function m.add(dest, v1, v2)
  local v1x, v1y, v1z = m.unwrap(v1)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

--- @spec subtract(dest: Vector3, Vector3, Vector3): Vector3
function m.subtract(dest, v1, v2)
  local v1x, v1y, v1z = m.unwrap(v1)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

--- @spec multiply(dest: Vector3, Vector3, Vector3): Vector3
function m.multiply(dest, v1, v2)
  local v1x, v1y, v1z = m.unwrap(v1)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  return dest
end

--- @spec divide(dest: Vector3, Vector3, Vector3): Vector3
function m.divide(dest, v1, v2)
  local v1x, v1y, v1z = m.unwrap(v1)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  return dest
end

--- @spec idivide(dest: Vector3, Vector3, Vector3): Vector3
function m.idivide(dest, v1, v2)
  local v1x, v1y, v1z = m.unwrap(v1)
  local v2x, v2y, v2z = m.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  return dest
end

--- @since "1.28.0"
--- @spec apply(dest: Vector3, source: Vector3, func: Function/1): Vector3
function m.apply(dest, v1, func)
  local v1x, v1y, v1z = m.unwrap(v1)
  dest.x = func(v1x)
  dest.y = func(v1y)
  dest.z = func(v1z)
  return dest
end

--- http://number-none.com/product/Understanding%20Slerp,%20Then%20Not%20Using%20It/
---
--- @since "1.40.0"
--- @mutative dest
--- @spec slerp(dest: Vector3, v1: Vector3, v2: Vector3, t: Number): Vector3
--- @spec #slerp(v1: Vector3, v2: Vector3, t: Number): Vector3
function m.slerp(dest, v1, v2, t)
  local dot = m.dot(v1, v2)
  if dot < -1 then
    dot = -1
  elseif dot > 1 then
    dot = 1
  end
  local tmp = m.multiply({}, v1, dot)
  tmp = m.subtract(tmp, v2, tmp)
  tmp = m.normalize(tmp)
  local theta = math.acos(dot) * t
  dest = m.multiply(dest, v1, math.cos(theta))
  tmp = m.multiply(tmp, tmp, math.sin(theta))
  return m.add(dest, dest, tmp)
end

--- Intended to be used by persistence systems to dump a Vector3 to a plain table
---
--- @spec dump_data(Vector3): Table
function m.dump_data(vec)
  return { x = vec.x, y = vec.y, z = vec.z }
end

--- @spec load_data(Table): Vector3
function m.load_data(data)
  return m.new(data.x, data.y, data.z)
end

m.sub = m.subtract
m.mul = m.multiply
m.div = m.divide
m.idiv = m.idivide

--- @since "1.27.0"
--- @spec metatable.__tostring(Vector3): String
m.metatable.__tostring = assert(m.to_string)

--- @since "1.27.0"
--- @spec metatable.__eq(Vector3, Vector3): Boolean
m.metatable.__eq = assert(m.equals)

--- @since "1.27.0"
--- @spec m.metatable.__unm(Vector3): Vector3
function m.metatable.__unm(v3)
  return m.new(
    -v3.x,
    -v3.y,
    -v3.z
  )
end

--- @since "1.27.0"
--- @spec metatable.__add(Vector3, Vector3): Vector3
function m.metatable.__add(a, b)
  local v2x, v2y, v2z = m.unwrap(b)
  return m.new(
    a.x + v2x,
    a.y + v2y,
    a.z + v2z
  )
end

--- @since "1.27.0"
--- @spec metatable.__sub(Vector3, Vector3): Vector3
function m.metatable.__sub(a, b)
  local v2x, v2y, v2z = m.unwrap(b)
  return m.new(
    a.x - v2x,
    a.y - v2y,
    a.z - v2z
  )
end

--- @since "1.27.0"
--- @spec metatable.__mul(Vector3, Vector3): Vector3
function m.metatable.__mul(a, b)
  local v2x, v2y, v2z = m.unwrap(b)
  return m.new(
    a.x * v2x,
    a.y * v2y,
    a.z * v2z
  )
end

--- @since "1.27.0"
--- @spec metatable.__div(Vector3, Vector3): Vector3
function m.metatable.__div(a, b)
  local v2x, v2y, v2z = m.unwrap(b)
  return m.new(
    a.x / v2x,
    a.y / v2y,
    a.z / v2z
  )
end

foundation.com.Vector3 = m
