-- Minetest has pos_to_string, but I believe that floor rounds the vector and adds bracket around it
function foundation.com.vector_to_string(vec)
  return vec.x .. "," .. vec.y .. "," .. vec.z
end

local vector2 = {}

function vector2.new(x, y)
  return { x = x, y = y }
end

function vector2.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y
  elseif type(v) == "number" then
    return v, v
  end
  error("expected a table or number")
end

function vector2.zero()
  return vector2.new(0, 0)
end

function vector2.to_string(v1, seperator)
  seperator = seperator or ","
  return v1.x .. seperator .. v1.y
end

function vector2.floor(dest, v1)
  dest.x = math.floor(v1.x)
  dest.y = math.floor(v1.y)
  return dest
end

function vector2.round(dest, v1)
  dest.x = math.floor(v1.x + 0.5)
  dest.y = math.floor(v1.y + 0.5)
  return dest
end

function vector2.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

function vector2.add(dest, v1, v2)
  dest.x = v1.x + v2.x
  dest.y = v1.y + v2.y
  return dest
end

function vector2.subtract(dest, v1, v2)
  dest.x = v1.x + v2.x
  dest.y = v1.y + v2.y
  return dest
end

function vector2.multiply(dest, v1, v2)
  dest.x = v1.x * v2.x
  dest.y = v1.y * v2.y
  return dest
end

function vector2.divide(dest, v1, v2)
  dest.x = v1.x / v2.x
  dest.y = v1.y / v2.y
  return dest
end

function vector2.idivide(dest, v1, v2)
  dest.x = math.floor(v1.x / v2.x)
  dest.y = math.floor(v1.y / v2.y)
  return dest
end

vector2.sub = vector2.subtract
vector2.mul = vector2.multiply
vector2.div = vector2.divide
vector2.idiv = vector2.idivide

local vector3 = {}

function vector3.new(x, y, z)
  return { x = x, y = y, z = z }
end

function vector3.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z
  elseif type(v) == "number" then
    return v, v, v
  end
  error("expected a table or number")
end

function vector3.zero()
  return vector3.new(0, 0, 0)
end

function vector3.to_string(v1, seperator)
  seperator = seperator or ","
  return v1.x .. seperator .. v1.y .. seperator .. v1.z
end

function vector3.floor(dest, v1)
  dest.x = math.floor(v1.x)
  dest.y = math.floor(v1.y)
  dest.z = math.floor(v1.z)
  return dest
end

function vector3.round(dest, v1)
  dest.x = math.floor(v1.x + 0.5)
  dest.y = math.floor(v1.y + 0.5)
  dest.z = math.floor(v1.z + 0.5)
  return dest
end

function vector3.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

function vector3.add(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

function vector3.subtract(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  return dest
end

function vector3.multiply(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  return dest
end

function vector3.divide(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  return dest
end

function vector3.idivide(dest, v1, v2)
  local v1x, v1y, v1z = vector3.unwrap(v1)
  local v2x, v2y, v2z = vector3.unwrap(v2)
  dest.x = math.floor(v1x / v2x)
  dest.y = math.floor(v1y / v2y)
  dest.z = math.floor(v1z / v2z)
  return dest
end

vector3.sub = vector3.subtract
vector3.mul = vector3.multiply
vector3.div = vector3.divide
vector3.idiv = vector3.idivide

local vector4 = {}

function vector4.new(x, y, z, w)
  return { x = x, y = y, z = z, w = w }
end

function vector4.unwrap(v)
  if type(v) == "table" then
    return v.x, v.y, v.z, v.w
  elseif type(v) == "number" then
    return v, v, v, v
  end
  error("expected a table or number")
end

function vector4.zero()
  return vector4.new(0, 0, 0)
end

function vector4.to_string(v1)
  return v1.x .. "," .. v1.y .. "," .. v1.z .. "," .. v1.w
end

function vector4.floor(dest, v1)
  dest.x = math.floor(v1.x)
  dest.y = math.floor(v1.y)
  dest.z = math.floor(v1.z)
  dest.w = math.floor(v1.w)
  return dest
end

function vector4.round(dest, v1)
  dest.x = math.floor(v1.x + 0.5)
  dest.y = math.floor(v1.y + 0.5)
  dest.z = math.floor(v1.z + 0.5)
  dest.w = math.floor(v1.w + 0.5)
  return dest
end

function vector4.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z + v1.w * v2.w
end

function vector4.add(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

function vector4.subtract(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x + v2x
  dest.y = v1y + v2y
  dest.z = v1z + v2z
  dest.w = v1w + v2w
  return dest
end

function vector4.multiply(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x * v2x
  dest.y = v1y * v2y
  dest.z = v1z * v2z
  dest.w = v1w * v2w
  return dest
end

function vector4.divide(dest, v1, v2)
  local v1x, v1y, v1z, v1w = vector4.unwrap(v1)
  local v2x, v2y, v2z, v2w = vector4.unwrap(v2)
  dest.x = v1x / v2x
  dest.y = v1y / v2y
  dest.z = v1z / v2z
  dest.w = v1w / v2w
  return dest
end

vector4.sub = vector4.subtract
vector4.mul = vector4.multiply
vector4.div = vector4.divide

foundation.com.Vector2 = vector2
foundation.com.Vector3 = vector3
foundation.com.Vector4 = vector4
