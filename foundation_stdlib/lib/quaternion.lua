--- @namespace foundation.com.Quaternion

local wxyz = {"w", "x", "y", "z"}
local m
m = {
  metatable = {
    __index = function (self, key)
      return rawget(self, wxyz[key]) or m[key]
    end,

    __newindex = function (self, key, value)
      rawset(self, wxyz[key] or key, value)
    end,
  },
}

--- @type Quaternion: {
---   w: Number,
---   x: Number,
---   y: Number,
---   z: Number,
--- }

--- @since "1.30.0"
--- @spec is_quaternion(obj: Any): Boolean
--- @spec #is_quaternion(): Boolean
function m.is_quaternion(obj)
  return getmetatable(obj) == m.metatable
end

--- @since "1.30.0"
--- @spec new(x: Number, y: Number, z: Number, w: Number): Quaternion
function m.new(w, x, y, z)
  return setmetatable({ w = w, x = x, y = y, z = z }, m.metatable)
end

--- @since "1.30.0"
--- @spec copy(Quaternion): Quaternion
--- @spec #copy(): Quaternion
function m.copy(q1)
  return m.new(q1.w, q1.x, q1.y, q1.z)
end

--- @since "1.30.0"
--- @spec from_vector(Vector4): Quaternion
function m.from_vector4(vec4)
  return m.new(vec4.w, vec4.x, vec4.y, vec4.z)
end

--- @since "1.30.0"
--- @spec unwrap(Any): (w: Number, x: Number, y: Number, z: Number)
function m.unwrap(v)
  if type(v) == "table" then
    return v.w, v.x, v.y, v.z
  elseif type(v) == "number" then
    return v, v, v, v
  end
  error("expected a table or number")
end

--- @since "1.30.0"
--- @spec unit(): Quaternion
function m.unit()
  return m.new(1, 0, 0, 0)
end

--- @since "1.30.0"
--- @spec to_string(Quaternion, sep?: String): String
--- @spec #to_string(): String
function m.to_string(q1, sep)
  sep = sep or ","
  return q1.w .. sep .. q1.x .. sep .. q1.y .. sep .. q1.z
end

--- @since "1.30.0"
--- @spec inspect(Quaternion, sep?: String): String
--- @spec #inspect(sep?: String): String
function m.inspect(q1, sep)
  sep = sep or ","
  return "(" .. q1.w .. sep .. q1.x .. sep .. q1.y .. sep .. q1.z .. ")"
end

--- @since "1.30.0"
--- @spec equals(a: Quaternion, b: Quaternion): Boolean
--- @spec #equals(b: Quaternion): Boolean
function m.equals(a, b)
  return a.w == b.w and a.x == b.x and a.y == b.y and a.z == b.z
end

--- @since "1.30.0"
--- @spec length(a: Quaternion): Number
--- @spec #length(): Number
function m.length(a)
  return math.sqrt(a.w * a.w + a.x * a.x + a.y * a.y + a.z * a.z)
end

--- @since "1.40.0"
--- @spec dot(q1: Quaternion, q2: Quaternion): Number
--- @spec #dot(q2: Quaternion): Number
function m.dot(q1, q2)
  return q1.w * q2.w + q1.x * q2.x + q1.y * q2.y + q1.z * q2.z
end

--- @since "1.30.0"
--- @mutative dest
--- @spec conjugate(dest: Quaternion, q1: Quaternion): Quaternion
function m.conjugate(dest, q1)
  local w, x, y, z = m.unwrap(q1)
  dest.w = w
  dest.x = -x
  dest.y = -y
  dest.z = -z
  return dest
end

--- @since "1.30.0"
--- @mutative dest
--- @spec inverse(dest: Quaternion, q1: Quaternion): Quaternion
function m.inverse(dest, q1)
  local w, x, y, z = m.unwrap(q1)
  local len = math.sqrt(w * w + x * x + y * y + z * z)
  dest.w = w / len
  dest.x = -x / len
  dest.y = -y / len
  dest.z = -z / len
  return dest
end

--- @since "1.30.0"
--- @mutative dest
--- @spec normalize(dest: Quaternion, q1: Quaternion): Quaternion
function m.normalize(dest, q1)
  local w, x, y, z = m.unwrap(q1)
  local len = math.sqrt(w * w + x * x + y * y + z * z)
  return m.divide(dest, q1, len)
end

--- @since "1.30.0"
--- @mutative dest
--- @spec add(dest: Quaternion, q1: Quaternion, q2: Quaternion): Quaternion
--- @spec #add(q1: Quaternion, q2: Quaternion): Quaternion
function m.add(dest, q1, q2)
  local q1w, q1x, q1y, q1z = m.unwrap(q1)
  local q2w, q2x, q2y, q2z = m.unwrap(q2)
  dest.w = q1w + q2w
  dest.x = q1x + q2x
  dest.y = q1y + q2y
  dest.z = q1z + q2z
  return dest
end

--- @since "1.30.0"
--- @mutative dest
--- @spec subtract(dest: Quaternion, q1: Quaternion, q2: Quaternion): Quaternion
--- @spec #subtract(q1: Quaternion, q2: Quaternion): Quaternion
function m.subtract(dest, q1, q2)
  local q1w, q1x, q1y, q1z = m.unwrap(q1)
  local q2w, q2x, q2y, q2z = m.unwrap(q2)
  dest.w = q1w + q2w
  dest.x = q1x + q2x
  dest.y = q1y + q2y
  dest.z = q1z + q2z
  return dest
end

--- @since "1.30.0"
--- @mutative dest
--- @spec hadamard_multiply(dest: Quaternion, q1: Quaternion, q2: Quaternion): Quaternion
--- @spec #hadamard_multiply(q1: Quaternion, q2: Quaternion): Quaternion
function m.hadamard_multiply(dest, q1, q2)
  local q1w, q1x, q1y, q1z = m.unwrap(q1)
  local q2w, q2x, q2y, q2z = m.unwrap(q2)
  dest.w = q1w * q2w
  dest.x = q1x * q2x
  dest.y = q1y * q2y
  dest.z = q1z * q2z
  return dest
end

--- @since "1.30.0"
--- @mutative dest
--- @spec multiply(dest: Quaternion, q1: Quaternion, q2: Quaternion): Quaternion
--- @spec #multiply(q1: Quaternion, q2: Quaternion): Quaternion
function m.multiply(dest, q1, q2)
  local q1w, q1x, q1y, q1z = m.unwrap(q1)
  local q2w, q2x, q2y, q2z = m.unwrap(q2)
  dest.w = q1w * q2w - q1x * q2x - q1y * q2y - q1z * q2z
  dest.x = q1w * q2x + q1x * q2w + q1y * q2z - q1z * q2y
  dest.y = q1w * q2y - q1x * q2z + q1y * q2w + q1z * q2x
  dest.z = q1w * q2z + q1x * q2y - q1y * q2x + q1z * q2w
  return dest
end

--- @since "1.30.0"
--- @mutative dest
--- @spec divide(dest: Quaternion, q1: Quaternion, q2: Quaternion): Quaternion
--- @spec #divide(q1: Quaternion, q2: Quaternion): Quaternion
function m.divide(dest, q1, q2)
  local q1w, q1x, q1y, q1z = m.unwrap(q1)
  local q2w, q2x, q2y, q2z = m.unwrap(q2)
  dest.w = q1w / q2w
  dest.x = q1x / q2x
  dest.y = q1y / q2y
  dest.z = q1z / q2z
  return dest
end

--- http://number-none.com/product/Understanding%20Slerp,%20Then%20Not%20Using%20It/
---
--- @since "1.40.0"
--- @mutative dest
--- @spec slerp(dest: Quaternion, q1: Quaternion, q2: Quaternion, t: Number): Quaternion
--- @spec #slerp(q1: Quaternion, q2: Quaternion, t: Number): Quaternion
function m.slerp(dest, q1, q2, t)
  local dot = m.dot(q1, q2)
  if dot < -1 then
    dot = -1
  elseif dot > 1 then
    dot = 1
  end
  local tmp = m.multiply({}, q1, dot)
  tmp = m.subtract(tmp, q2, tmp)
  tmp = m.normalize(tmp, tmp)
  local theta = math.acos(dot) * t
  dest = m.multiply(dest, q1, math.cos(theta))
  tmp = m.multiply(tmp, tmp, math.sin(theta))
  return m.add(dest, dest, tmp)
end

--- @since "1.30.0"
--- @spec to_euler(Quaternion): (roll: Number, pitch: Number, yaw: Number)
--- @spec #to_euler(): (roll: Number, pitch: Number, yaw: Number)
function m.to_euler(q1)
  local w, x, y, z = unwrap(q1)
  local roll = math.atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))
  local pitch = math.asin(2 * (w * y - z * x))
  local yaw = math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))

  return roll, pitch, yaw
end

--- Intended to be used by persistence systems to dump a vector4 to a plain table
---
--- @since "1.30.0"
--- @spec dump_data(Quaternion): Table
--- @spec #dump_data(): Table
function m.dump_data(q1)
  return { w = q1.w, x = q1.x, y = q1.y, z = q1.z }
end

--- @since "1.30.0"
--- @spec load_data(Table): Quaternion
function m.load_data(data)
  return m.new(data.w, data.x, data.y, data.z)
end

m.sub = m.subtract
m.mul = m.multiply
m.div = m.divide
m.idiv = m.idivide

--- @since "1.30.0"
--- @spec metatable.__tostring(Quaternion): String
m.metatable.__tostring = assert(m.to_string)

--- @since "1.30.0"
--- @spec metatable.__eq(Quaternion, Quaternion): Boolean
m.metatable.__eq = assert(m.equals)

--- @since "1.30.0"
--- @spec m.metatable.__unm(Quaternion): Quaternion
function m.metatable.__unm(v4)
  return m.new(
    -v4.w,
    -v4.x,
    -v4.y,
    -v4.z
  )
end

--- @since "1.30.0"
--- @spec metatable.__add(Quaternion, Quaternion): Quaternion
function m.metatable.__add(a, b)
  local result = {}
  return m.add(result, a, b)
end

--- @since "1.30.0"
--- @spec metatable.__sub(Quaternion, Quaternion): Quaternion
function m.metatable.__sub(a, b)
  local result = {}
  return m.subtract(result, a, b)
end

--- @since "1.30.0"
--- @spec metatable.__mul(Quaternion, Quaternion): Quaternion
function m.metatable.__mul(a, b)
  local result = {}
  return m.multiply(result, a, b)
end

--- @since "1.30.0"
--- @spec metatable.__div(Quaternion, Quaternion): Quaternion
function m.metatable.__div(a, b)
  local result = {}
  return m.divide(result, a, b)
end

foundation.com.Quaternion = m
