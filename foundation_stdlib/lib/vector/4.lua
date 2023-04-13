--- @namespace foundation.com

--- @namespace foundation.com.Vector4
local xyzw = {"x", "y", "z", "w"}
local vector4
vector4 = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xyzw[key]) or vector4[key]
    end,

    __newindex = function (v, key, value)
      rawset(v, xyzw[key] or key, value)
    end,
  },
}

--- @type Vector4: {
---   x: Number,
---   y: Number,
---   z: Number,
---   w: Number,
--- }

--- @spec new(x: Number, y: Number, z: Number, w: Number): Vector4
function vector4.new(x, y, z, w)
  return setmetatable({ x = x, y = y, z = z, w = w }, vector4.metatable)
end

--- @spec copy(Vector4): Vector4
function vector4.copy(v1)
  return vector4.new(v1.x, v1.y, v1.z, v1.w)
end

--- @spec unwrap(Any): (Number, Number, Number, Number)
function vector4.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z, v.w
  elseif type(v) == "number" then
    return v, v, v, v
  end
  error("expected a table or number")
end

--- @spec zero(): Vector4
function vector4.zero()
  return vector4.new(0, 0, 0, 0)
end

--- @spec to_string(Vector4, sep?: String): String
function vector4.to_string(v1, sep)
  sep = sep or ","
  return v1.x .. sep .. v1.y .. sep .. v1.z .. sep .. v1.w
end

--- @spec equals(a: Vector4, b: Vector4): Boolean
function vector4.equals(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w
end

--- @spec distance(a: Vector4, b: Vector4): Float
function vector4.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y
  local z = a.z - b.z
  z = z * z
  local w = a.w - b.w
  w = w * w

  return math.sqrt(x + y + z + w)
end

--- @spec floor(Vector4, Vector4): Vector4
function vector4.floor(dest, v2)
  local v2x, v2y, v2z, v2w = vector3.unwrap(v2)
  dest.x = math.floor(v2x)
  dest.y = math.floor(v2y)
  dest.z = math.floor(v2z)
  dest.w = math.floor(v2w)
  return dest
end

--- @spec ceil(Vector4, Vector4): Vector4
function vector4.ceil(dest, v2)
  local v2x, v2y, v2z, v2w = vector3.unwrap(v2)
  dest.x = math.ceil(v2x)
  dest.y = math.ceil(v2y)
  dest.z = math.ceil(v2z)
  dest.w = math.ceil(v2w)
  return dest
end

--- @spec round(Vector4, Vector4): Vector4
function vector4.round(dest, v2)
  local v2x, v2y, v2z, v2w = vector3.unwrap(v2)
  dest.x = math.floor(v2x + 0.5)
  dest.y = math.floor(v2y + 0.5)
  dest.z = math.floor(v2z + 0.5)
  dest.w = math.floor(v2w + 0.5)
  return dest
end

--- @spec dot(Vector4, Vector4): Vector4
function vector4.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z + v1.w * v2.w
end

--- @spec add(dest: Vector4, Vector4, Vector4): Vector4
function vector4.add(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

--- @spec subtract(dest: Vector4, Vector4, Vector4): Vector4
function vector4.subtract(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

--- @spec multiply(dest: Vector4, Vector4, Vector4): Vector4
function vector4.multiply(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  dest.w = v1w * v2w
  return dest
end

--- @spec divide(dest: Vector4, Vector4, Vector4): Vector4
function vector4.divide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  dest.w = v1w / v2w
  return dest
end

--- @spec idivide(dest: Vector4, Vector4, Vector4): Vector4
function vector4.idivide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  dest.w = math.floor(v1w / v2w)
  return dest
end

--- @since "1.28.0"
--- @spec apply(dest: Vector4, source: Vector4, func: Function/1): Vector4
function vector4.apply(dest, v1, func)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  dest.x = func(v1x)
  dest.y = func(v1y)
  dest.z = func(v1z)
  dest.w = func(v1w)
  return dest
end

--- Intended to be used by persistence systems to dump a vector4 to a plain table
---
--- @spec dump_data(Vector4): Table
function vector4.dump_data(vec)
  return { x = vec.x, y = vec.y, z = vec.z, w = vec.w }
end

--- @spec load_data(Table): Vector4
function vector4.load_data(data)
  return vector4.new(data.x, data.y, data.z, data.w)
end

vector4.sub = vector4.subtract
vector4.mul = vector4.multiply
vector4.div = vector4.divide
vector4.idiv = vector4.idivide

--- @since "1.27.0"
--- @spec metatable.__tostring(Vector4): String
vector4.metatable.__tostring = assert(vector4.to_string)

--- @since "1.27.0"
--- @spec metatable.__eq(Vector4, Vector4): Boolean
vector4.metatable.__eq = assert(vector4.equals)

--- @since "1.27.0"
--- @spec vector4.metatable.__unm(Vector4): Vector4
function vector4.metatable.__unm(v4)
  return vector4.new(
    -v4.x,
    -v4.y,
    -v4.z,
    -v4.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__add(Vector4, Vector4): Vector4
function vector4.metatable.__add(a, b)
  return vector4.new(
    a.x + b.x,
    a.y + b.y,
    a.z + b.z,
    a.w + b.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__sub(Vector4, Vector4): Vector4
function vector4.metatable.__sub(a, b)
  return vector4.new(
    a.x - b.x,
    a.y - b.y,
    a.z - b.z,
    a.w - b.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__mul(Vector4, Vector4): Vector4
function vector4.metatable.__mul(a, b)
  return vector4.new(
    a.x * b.x,
    a.y * b.y,
    a.z * b.z,
    a.w * b.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__div(Vector4, Vector4): Vector4
function vector4.metatable.__div(a, b)
  return vector4.new(
    a.x / b.x,
    a.y / b.y,
    a.z / b.z,
    a.w / b.w
  )
end

foundation.com.Vector4 = vector4
