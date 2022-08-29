-- @namespace foundation.com

-- Minetest has pos_to_string, but I believe that floors the vector coords
-- and adds bracket around it this function is intended to keep the
-- decimal places and only create a csv
function foundation.com.vector_to_string(vec)
  return vec.x .. "," .. vec.y .. "," .. vec.z
end

-- @namespace foundation.com.Vector2
local vector2 = {}

-- @type Vector2: {
--   x: Number,
--   y: Number,
-- }

-- @spec new(x: Number, y: Number): Vector2
function vector2.new(x, y)
  return { x = x, y = y }
end

-- @spec copy(Vector2): Vector2
function vector2.copy(v1)
  return { x = v1.x, y = v1.y }
end

-- @spec unwrap(Any): (Number, Number)
function vector2.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y
  elseif type(v) == "number" then
    return v, v
  end
  error("expected a table or number")
end

-- @spec zero(): Vector2
function vector2.zero()
  return vector2.new(0, 0)
end

-- @spec to_string(Vector2, seperator?: String): String
function vector2.to_string(v2, seperator)
  seperator = seperator or ","
  return v2.x .. seperator .. v2.y
end

-- @spec equals(a: Vector2, b: Vector2): Boolean
function vector2.equals(a, b)
  return a.x == b.x and a.y == b.y
end

-- @spec distance(a: Vector2, b: Vector2): Float
function vector2.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y

  return math.sqrt(x + y)
end

-- @spec floor(dest: Vector2, v2: Vector2): Vector2
function vector2.floor(dest, v2)
  dest.x = math.floor(v2.x)
  dest.y = math.floor(v2.y)
  return dest
end

-- @spec ceil(dest: Vector2, v2: Vector2): Vector2
function vector2.ceil(dest, v2)
  dest.x = math.ceil(v2.x)
  dest.y = math.ceil(v2.y)
  return dest
end

-- @spec round(dest: Vector2, v2: Vector2): Vector2
function vector2.round(dest, v2)
  dest.x = math.floor(v2.x + 0.5)
  dest.y = math.floor(v2.y + 0.5)
  return dest
end

-- @spec dot(Vector2, Vector2): Vector2
function vector2.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

-- @spec add(dest: Vector2, Vector2, Vector2): Vector2
function vector2.add(dest, v1, v2)
  dest.x = v1.x + v2.x
  dest.y = v1.y + v2.y
  return dest
end

-- @spec subtract(dest: Vector2, Vector2, Vector2): Vector2
function vector2.subtract(dest, v1, v2)
  dest.x = v1.x + v2.x
  dest.y = v1.y + v2.y
  return dest
end

-- @spec multiply(dest: Vector2, Vector2, Vector2): Vector2
function vector2.multiply(dest, v1, v2)
  dest.x = v1.x * v2.x
  dest.y = v1.y * v2.y
  return dest
end

-- @spec divide(dest: Vector2, Vector2, Vector2): Vector2
function vector2.divide(dest, v1, v2)
  dest.x = v1.x / v2.x
  dest.y = v1.y / v2.y
  return dest
end

-- @spec idivide(dest: Vector2, Vector2, Vector2): Vector2
function vector2.idivide(dest, v1, v2)
  dest.x = math.floor(v1.x / v2.x)
  dest.y = math.floor(v1.y / v2.y)
  return dest
end

-- Intended to be used by persistence systems to dump a vector2 to a plain table
--
-- @spec dump_data(Vector2): Table
function vector2.dump_data(vec)
  return { x = vec.x, y = vec.y }
end

-- @spec load_data(Table): Vector2
function vector2.load_data(data)
  return vector2.new(data.x, data.y)
end

vector2.sub = vector2.subtract
vector2.mul = vector2.multiply
vector2.div = vector2.divide
vector2.idiv = vector2.idivide

-- @namespace foundation.com.Vector3
local vector3 = {}

-- @type Vector3: {
--   x: Number,
--   y: Number,
--   z: Number,
-- }

-- @spec new(x: Number, y: Number, z: Number): Vector3
function vector3.new(x, y, z)
  return { x = x, y = y, z = z }
end

-- @spec copy(Vector3): Vector3
function vector3.copy(v1)
  return { x = v1.x, y = v1.y, z = v1.z }
end

-- @spec new(Any): (Number, Number, Number)
function vector3.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z
  elseif type(v) == "number" then
    return v, v, v
  end
  error("expected a table or number")
end

-- @spec zero(): Vector3
function vector3.zero()
  return vector3.new(0, 0, 0)
end

-- @spec to_string(Vector3, seperator?: String): String
function vector3.to_string(v1, seperator)
  seperator = seperator or ","
  return v1.x .. seperator .. v1.y .. seperator .. v1.z
end

-- @spec equals(a: Vector3, b: Vector3): Boolean
function vector3.equals(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z
end

-- @spec distance(a: Vector3, b: Vector3): Float
function vector3.distance(a, b)
  local x = a.x - b.x
  x = x * x
  local y = a.y - b.y
  y = y * y
  local z = a.z - b.z
  z = z * z

  return math.sqrt(x + y + z)
end

-- @spec floor(Vector3, Vector3): Vector3
function vector3.floor(dest, v1)
  dest.x = math.floor(v1.x)
  dest.y = math.floor(v1.y)
  dest.z = math.floor(v1.z)
  return dest
end

-- @spec ceil(Vector3, Vector3): Vector3
function vector3.ceil(dest, v1)
  dest.x = math.ceil(v1.x)
  dest.y = math.ceil(v1.y)
  dest.z = math.ceil(v1.z)
  return dest
end

-- @spec round(Vector3, Vector3): Vector3
function vector3.round(dest, v1)
  dest.x = math.floor(v1.x + 0.5)
  dest.y = math.floor(v1.y + 0.5)
  dest.z = math.floor(v1.z + 0.5)
  return dest
end

-- @spec dot(Vector3, Vector3): Number
function vector3.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

-- @spec add(dest: Vector3, Vector3, Vector3): Vector3
function vector3.add(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

-- @spec subtract(dest: Vector3, Vector3, Vector3): Vector3
function vector3.subtract(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

-- @spec multiply(dest: Vector3, Vector3, Vector3): Vector3
function vector3.multiply(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  return dest
end

-- @spec divide(dest: Vector3, Vector3, Vector3): Vector3
function vector3.divide(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  return dest
end

-- @spec idivide(dest: Vector3, Vector3, Vector3): Vector3
function vector3.idivide(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  return dest
end

-- Intended to be used by persistence systems to dump a vector3 to a plain table
--
-- @spec dump_data(Vector3): Table
function vector3.dump_data(vec)
  return { x = vec.x, y = vec.y, z = vec.z }
end

-- @spec load_data(Table): Vector3
function vector3.load_data(data)
  return vector3.new(data.x, data.y, data.z)
end

vector3.sub = vector3.subtract
vector3.mul = vector3.multiply
vector3.div = vector3.divide
vector3.idiv = vector3.idivide

-- @namespace foundation.com.Vector4
local vector4 = {}

-- @type Vector4: {
--   x: Number,
--   y: Number,
--   z: Number,
--   w: Number,
-- }

-- @spec new(x: Number, y: Number, z: Number, w: Number): Vector4
function vector4.new(x, y, z, w)
  return { x = x, y = y, z = z, w = w }
end

-- @spec copy(Vector4): Vector4
function vector4.copy(v1)
  return { x = v1.x, y = v1.y, z = v1.z, w = v1.w }
end

-- @spec unwrap(Any): (Number, Number, Number, Number)
function vector4.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z, v.w
  elseif type(v) == "number" then
    return v, v, v, v
  end
  error("expected a table or number")
end

-- @spec zero(): Vector4
function vector4.zero()
  return vector4.new(0, 0, 0, 0)
end

-- @spec to_string(Vector4, sep?: String): String
function vector4.to_string(v1, sep)
  sep = sep or ","
  return v1.x .. sep .. v1.y .. sep .. v1.z .. sep .. v1.w
end

-- @spec equals(a: Vector4, b: Vector4): Boolean
function vector4.equals(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w
end

-- @spec distance(a: Vector4, b: Vector4): Float
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

-- @spec floor(Vector4, Vector4): Vector4
function vector4.floor(dest, v1)
  dest.x = math.floor(v1.x)
  dest.y = math.floor(v1.y)
  dest.z = math.floor(v1.z)
  dest.w = math.floor(v1.w)
  return dest
end

-- @spec ceil(Vector4, Vector4): Vector4
function vector4.ceil(dest, v1)
  dest.x = math.ceil(v1.x)
  dest.y = math.ceil(v1.y)
  dest.z = math.ceil(v1.z)
  dest.w = math.ceil(v1.w)
  return dest
end

-- @spec round(Vector4, Vector4): Vector4
function vector4.round(dest, v1)
  dest.x = math.floor(v1.x + 0.5)
  dest.y = math.floor(v1.y + 0.5)
  dest.z = math.floor(v1.z + 0.5)
  dest.w = math.floor(v1.w + 0.5)
  return dest
end

-- @spec dot(Vector4, Vector4): Vector4
function vector4.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z + v1.w * v2.w
end

-- @spec add(dest: Vector4, Vector4, Vector4): Vector4
function vector4.add(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

-- @spec subtract(dest: Vector4, Vector4, Vector4): Vector4
function vector4.subtract(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

-- @spec multiply(dest: Vector4, Vector4, Vector4): Vector4
function vector4.multiply(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  dest.w = v1w * v2w
  return dest
end

-- @spec divide(dest: Vector4, Vector4, Vector4): Vector4
function vector4.divide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  dest.w = v1w / v2w
  return dest
end

-- @spec idivide(dest: Vector4, Vector4, Vector4): Vector4
function vector4.idivide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  dest.w = math.floor(v1w / v2w)
  return dest
end

-- Intended to be used by persistence systems to dump a vector4 to a plain table
--
-- @spec dump_data(Vector4): Table
function vector4.dump_data(vec)
  return { x = vec.x, y = vec.y, z = vec.z, w = vec.w }
end

-- @spec load_data(Table): Vector4
function vector4.load_data(data)
  return vector4.new(data.x, data.y, data.z, data.w)
end

vector4.sub = vector4.subtract
vector4.mul = vector4.multiply
vector4.div = vector4.divide
vector4.idiv = vector4.idivide

foundation.com.Vector2 = vector2
foundation.com.Vector3 = vector3
foundation.com.Vector4 = vector4
