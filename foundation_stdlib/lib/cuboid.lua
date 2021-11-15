-- @namespace foundation.com.Cuboid
local Vector3 = assert(foundation.com.Vector3)

local Cuboid = {}

-- Or just sixteenth
Cuboid.SIXTEENTH = 1 / 16.0

-- @spec new(x: Number, y: Number, z: Number, w: Number, h: Number, d: Number): Cuboid
function Cuboid.new(x, y, z, w, h, d)
  return {
    x = x,
    y = y,
    z = z,
    w = w,
    h = h,
    d = d,
  }
end

-- @spec position(Cuboid): Vector3
function Cuboid.position(cuboid)
  return Vector3.new(cuboid.x, cuboid.y, cuboid.z)
end

-- @spec dimensions(Cuboid): Vector3
function Cuboid.dimensions(cuboid)
  return Vector3.new(cuboid.w, cuboid.h, cuboid.d)
end

-- @alias size = dimensions
Cuboid.size = Cuboid.dimensions

-- @spec volume(Cuboid): Number
function Cuboid.volume(cuboid)
  return cuboid.w * cuboid.h * cuboid.d
end

-- @mutative
-- @spec scale(Cuboid, x: Number, y: Number, z: Number): Cuboid
function Cuboid.scale(cuboid, x, y, z)
  if type(x) == "table" then
    z = x.z
    y = x.y
    x = x.x
  end
  y = y or x
  z = z or y
  cuboid.x = cuboid.x * x
  cuboid.y = cuboid.y * y
  cuboid.z = cuboid.z * z
  cuboid.w = cuboid.w * x
  cuboid.h = cuboid.h * y
  cuboid.d = cuboid.d * z
  return cuboid
end

-- @mutative
-- @spec translate(Cuboid, x: Number, y: Number, z: Number): Cuboid
function Cuboid.translate(cuboid, x, y, z)
  if type(x) == "table" then
    z = x.z
    y = x.y
    x = x.x
  end
  cuboid.x = cuboid.x + x
  cuboid.y = cuboid.y + y
  cuboid.z = cuboid.z + z
  return cuboid
end

-- @spec scale(Cuboid, x: Number, y: Number, z: Number): (Vector3, Vector3)
function Cuboid.to_extents(cuboid)
  return Vector3.new(cuboid.x, cuboid.y, cuboid.z),
         Vector3.new(cuboid.x + cuboid.w, cuboid.y + cuboid.h, cuboid.z + cuboid.d)
end

-- @spec to_node_box(Cuboid): Array<Number>[6]
function Cuboid.to_node_box(cuboid)
  return {cuboid.x, cuboid.y, cuboid.z, cuboid.x + cuboid.w, cuboid.y + cuboid.h, cuboid.z + cuboid.d}
end

-- @spec fast_node_box(Cuboid, scale: Float): Array<Number>[6]
function Cuboid.fast_node_box(cuboid, scale)
  local result = Cuboid.scale(cuboid, scale or Cuboid.SIXTEENTH)
  result = Cuboid.translate(result, -0.5, -0.5, -0.5)
  return Cuboid.to_node_box(cuboid)
end

-- @spec new_fast_node_box(x: Number, y: Number, z: Number, w: Number, h: Number, d: Number): Array<Number>[6]
function Cuboid.new_fast_node_box(...)
  return Cuboid.fast_node_box(Cuboid.new(...))
end

foundation.com.Cuboid = Cuboid
