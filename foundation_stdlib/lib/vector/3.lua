--- @namespace foundation.com.Vector3
local xyz = {"x", "y", "z"}
local vector3
vector3 = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xyz[key]) or vector3[key]
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

--- @spec new(x: Number, y: Number, z: Number): Vector3
function vector3.new(x, y, z)
  return setmetatable({ x = x, y = y, z = z }, vector3.metatable)
end

--- @spec copy(Vector3): Vector3
function vector3.copy(v1)
  return vector3.new(v1.x, v1.y, v1.z)
end

--- @spec new(Any): (Number, Number, Number)
function vector3.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z
  elseif type(v) == "number" then
    return v, v, v
  end
  error("expected a table or number")
end

--- @spec zero(): Vector3
function vector3.zero()
  return vector3.new(0, 0, 0)
end

--- @spec to_string(Vector3, seperator?: String): String
function vector3.to_string(v1, seperator)
  seperator = seperator or ","
  return v1.x .. seperator .. v1.y .. seperator .. v1.z
end

--- @spec equals(a: Vector3, b: Vector3): Boolean
function vector3.equals(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z
end

--- @spec distance(a: Vector3, b: Vector3): Float
function vector3.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y
  local z = a.z - b.z
  z = z * z

  return math.sqrt(x + y + z)
end

--- @spec floor(Vector3, Vector3): Vector3
function vector3.floor(dest, v2)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = math.floor(v2x)
  dest.y = math.floor(v2y)
  dest.z = math.floor(v2z)
  return dest
end

--- @spec ceil(Vector3, Vector3): Vector3
function vector3.ceil(dest, v2)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = math.ceil(v2x)
  dest.y = math.ceil(v2y)
  dest.z = math.ceil(v2z)
  return dest
end

--- @spec round(Vector3, Vector3): Vector3
function vector3.round(dest, v2)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = math.floor(v2x + 0.5)
  dest.y = math.floor(v2y + 0.5)
  dest.z = math.floor(v2z + 0.5)
  return dest
end

--- @spec dot(Vector3, Vector3): Number
function vector3.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

--- @since "1.27.0"
--- @spec cross(Vector3, Vector3, Vector3): Vector3
function vector3.cross(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1y * v2z - v1z * v2y
  dest.y = v1z * v2x - v1x * v2z
  dest.z = v1x * v2y - v1y * v2x
  return dest
end

--- @spec add(dest: Vector3, Vector3, Vector3): Vector3
function vector3.add(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

--- @spec subtract(dest: Vector3, Vector3, Vector3): Vector3
function vector3.subtract(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

--- @spec multiply(dest: Vector3, Vector3, Vector3): Vector3
function vector3.multiply(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  return dest
end

--- @spec divide(dest: Vector3, Vector3, Vector3): Vector3
function vector3.divide(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  return dest
end

--- @spec idivide(dest: Vector3, Vector3, Vector3): Vector3
function vector3.idivide(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  return dest
end

--- @since "1.28.0"
--- @spec apply(dest: Vector3, source: Vector3, func: Function/1): Vector3
function vector3.apply(dest, v1, func)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  dest.x = func(v1x)
  dest.y = func(v1y)
  dest.z = func(v1z)
  return dest
end

--- Intended to be used by persistence systems to dump a vector3 to a plain table
---
--- @spec dump_data(Vector3): Table
function vector3.dump_data(vec)
  return { x = vec.x, y = vec.y, z = vec.z }
end

--- @spec load_data(Table): Vector3
function vector3.load_data(data)
  return vector3.new(data.x, data.y, data.z)
end

vector3.sub = vector3.subtract
vector3.mul = vector3.multiply
vector3.div = vector3.divide
vector3.idiv = vector3.idivide

--- @since "1.27.0"
--- @spec metatable.__tostring(Vector3): String
vector3.metatable.__tostring = assert(vector3.to_string)

--- @since "1.27.0"
--- @spec metatable.__eq(Vector3, Vector3): Boolean
vector3.metatable.__eq = assert(vector3.equals)

--- @since "1.27.0"
--- @spec vector3.metatable.__unm(Vector3): Vector3
function vector3.metatable.__unm(v3)
  return vector3.new(
    -v3.x,
    -v3.y,
    -v3.z
  )
end

--- @since "1.27.0"
--- @spec metatable.__add(Vector3, Vector3): Vector3
function vector3.metatable.__add(a, b)
  local v2x, v2y, v2z = vector3.unwrap(b)
  return vector3.new(
    a.x + v2x,
    a.y + v2y,
    a.z + v2z
  )
end

--- @since "1.27.0"
--- @spec metatable.__sub(Vector3, Vector3): Vector3
function vector3.metatable.__sub(a, b)
  local v2x, v2y, v2z = vector3.unwrap(b)
  return vector3.new(
    a.x - v2x,
    a.y - v2y,
    a.z - v2z
  )
end

--- @since "1.27.0"
--- @spec metatable.__mul(Vector3, Vector3): Vector3
function vector3.metatable.__mul(a, b)
  local v2x, v2y, v2z = vector3.unwrap(b)
  return vector3.new(
    a.x * v2x,
    a.y * v2y,
    a.z * v2z
  )
end

--- @since "1.27.0"
--- @spec metatable.__div(Vector3, Vector3): Vector3
function vector3.metatable.__div(a, b)
  local v2x, v2y, v2z = vector3.unwrap(b)
  return vector3.new(
    a.x / v2x,
    a.y / v2y,
    a.z / v2z
  )
end

foundation.com.Vector3 = vector3
