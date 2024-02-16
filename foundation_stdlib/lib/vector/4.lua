local number_round = assert(foundation.com.number_round)

--- @namespace foundation.com

--- @namespace foundation.com.Vector4
local xyzw = {"x", "y", "z", "w"}
local m
m = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xyzw[key]) or m[key]
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

--- @since "1.29.0"
--- @spec is_m(obj: Any): Boolean
--- @spec #is_m(): Boolean
function m.is_m(obj)
  return getmetatable(obj) == m.metatable
end

--- @spec new(x: Number, y: Number, z: Number, w: Number): Vector4
function m.new(x, y, z, w)
  return setmetatable({ x = x, y = y, z = z, w = w }, m.metatable)
end

--- @spec copy(Vector4): Vector4
--- @spec #copy(): Vector4
function m.copy(v1)
  return m.new(v1.x, v1.y, v1.z, v1.w)
end

--- @spec unwrap(Any): (Number, Number, Number, Number)
function m.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z, v.w
  elseif type(v) == "number" then
    return v, v, v, v
  end
  error("expected a table or number")
end

--- @spec zero(): Vector4
function m.zero()
  return m.new(0, 0, 0, 0)
end

--- @spec to_string(Vector4, sep?: String): String
--- @spec #to_string(): String
function m.to_string(v1, sep)
  sep = sep or ","
  return v1.x .. sep .. v1.y .. sep .. v1.z .. sep .. v1.w
end

--- @spec inspect(Vector4, sep?: String): String
--- @spec #inspect(sep?: String): String
function m.inspect(v1, sep)
  sep = sep or ","
  return "(" .. v1.x .. sep .. v1.y .. sep .. v1.z .. sep .. v1.w .. ")"
end

--- @spec equals(a: Vector4, b: Vector4): Boolean
--- @spec #equals(b: Vector4): Boolean
function m.equals(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w
end

--- @spec distance(a: Vector4, b: Vector4): Number
--- @spec #distance(b: Vector4): Number
function m.distance(a, b)
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

--- @since "1.29.0"
--- @spec length(a: Vector4): Number
--- @spec #length(): Number
function m.length(a)
  return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w)
end

--- @spec floor(Vector4, Vector4): Vector4
function m.floor(dest, v2)
  local v2x, v2y, v2z, v2w = vector3.unwrap(v2)
  dest.x = math.floor(v2x)
  dest.y = math.floor(v2y)
  dest.z = math.floor(v2z)
  dest.w = math.floor(v2w)
  return dest
end

--- @spec ceil(Vector4, Vector4): Vector4
function m.ceil(dest, v2)
  local v2x, v2y, v2z, v2w = vector3.unwrap(v2)
  dest.x = math.ceil(v2x)
  dest.y = math.ceil(v2y)
  dest.z = math.ceil(v2z)
  dest.w = math.ceil(v2w)
  return dest
end

--- @spec round(dest: Vector4, v1: Vector4): Vector4
--- @spec #round(v1: Vector4): Vector4
--- @since "1.40.0"
--- @spec round(dest: Vector4, v1: Vector4, places: Integer): Vector4
--- @spec #round(v1: Vector4, places: Integer): Vector4
function m.round(dest, v1, places)
  local v2x, v2y, v2z, v2w = vector3.unwrap(v1)
  dest.x = number_round(v2x, places)
  dest.y = number_round(v2y, places)
  dest.z = number_round(v2z, places)
  dest.w = number_round(v2w, places)
  return dest
end

--- @spec dot(Vector4, Vector4): Vector4
--- @spec #dot(v2: Vector4): Vector4
function m.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z + v1.w * v2.w
end

--- @since "1.40.0"
--- @mutative dest
--- @spec normalize(dest: Vector4, v1: Vector4): Vector4
function m.normalize(dest, v1)
  local w, x, y, z = m.unwrap(v1)
  local len = math.sqrt(x * x + y * y + z * z + w * w)
  return m.divide(dest, v1, len)
end

--- @spec add(dest: Vector4, Vector4, Vector4): Vector4
--- @spec #add(Vector4, Vector4): Vector4
function m.add(dest, v1, v2)
  local v1x, v1y, v1z, v1w = m.unwrap(v1)
  local v2x, v2y, v2z, v2w = m.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

--- @spec subtract(dest: Vector4, Vector4, Vector4): Vector4
--- @spec #subtract(Vector4, Vector4): Vector4
function m.subtract(dest, v1, v2)
  local v1x, v1y, v1z, v1w = m.unwrap(v1)
  local v2x, v2y, v2z, v2w = m.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

--- @spec multiply(dest: Vector4, Vector4, Vector4): Vector4
--- @spec #multiply(Vector4, Vector4): Vector4
function m.multiply(dest, v1, v2)
  local v1x, v1y, v1z, v1w = m.unwrap(v1)
  local v2x, v2y, v2z, v2w = m.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  dest.w = v1w * v2w
  return dest
end

--- @spec divide(dest: Vector4, Vector4, Vector4): Vector4
--- @spec #divide(Vector4, Vector4): Vector4
function m.divide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = m.unwrap(v1)
  local v2x, v2y, v2z, v2w = m.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  dest.w = v1w / v2w
  return dest
end

--- @spec idivide(dest: Vector4, Vector4, Vector4): Vector4
--- @spec #idivide(v1: Vector4, v2: Vector4): Vector4
function m.idivide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = m.unwrap(v1)
  local v2x, v2y, v2z, v2w = m.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  dest.w = math.floor(v1w / v2w)
  return dest
end

--- @since "1.28.0"
--- @spec apply(dest: Vector4, source: Vector4, func: Function/1): Vector4
--- @spec #apply(source: Vector4, func: Function/1): Vector4
function m.apply(dest, v1, func)
  local v1x, v1y, v1z, v1w = m.unwrap(v1)
  dest.x = func(v1x)
  dest.y = func(v1y)
  dest.z = func(v1z)
  dest.w = func(v1w)
  return dest
end

--- http://number-none.com/product/Understanding%20Slerp,%20Then%20Not%20Using%20It/
---
--- @since "1.40.0"
--- @mutative dest
--- @spec slerp(dest: Vector4, v1: Vector4, v2: Vector4, t: Number): Vector4
--- @spec #slerp(v1: Vector4, v2: Vector4, t: Number): Vector4
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

--- Intended to be used by persistence systems to dump a Vector4 to a plain table
---
--- @spec dump_data(Vector4): Table
--- @spec #dump_data(): Table
function m.dump_data(vec)
  return { x = vec.x, y = vec.y, z = vec.z, w = vec.w }
end

--- @spec load_data(Table): Vector4
function m.load_data(data)
  return m.new(data.x, data.y, data.z, data.w)
end

m.sub = m.subtract
m.mul = m.multiply
m.div = m.divide
m.idiv = m.idivide

--- @since "1.27.0"
--- @spec metatable.__tostring(Vector4): String
m.metatable.__tostring = assert(m.to_string)

--- @since "1.27.0"
--- @spec metatable.__eq(Vector4, Vector4): Boolean
m.metatable.__eq = assert(m.equals)

--- @since "1.27.0"
--- @spec m.metatable.__unm(Vector4): Vector4
function m.metatable.__unm(v4)
  return m.new(
    -v4.x,
    -v4.y,
    -v4.z,
    -v4.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__add(Vector4, Vector4): Vector4
function m.metatable.__add(a, b)
  return m.new(
    a.x + b.x,
    a.y + b.y,
    a.z + b.z,
    a.w + b.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__sub(Vector4, Vector4): Vector4
function m.metatable.__sub(a, b)
  return m.new(
    a.x - b.x,
    a.y - b.y,
    a.z - b.z,
    a.w - b.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__mul(Vector4, Vector4): Vector4
function m.metatable.__mul(a, b)
  return m.new(
    a.x * b.x,
    a.y * b.y,
    a.z * b.z,
    a.w * b.w
  )
end

--- @since "1.27.0"
--- @spec metatable.__div(Vector4, Vector4): Vector4
function m.metatable.__div(a, b)
  return m.new(
    a.x / b.x,
    a.y / b.y,
    a.z / b.z,
    a.w / b.w
  )
end

foundation.com.Vector4 = m
