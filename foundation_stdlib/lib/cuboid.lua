foundation_stdlib:require("lib/vector.lua")

local Vector3 = foundation.com.Vector3

local Cuboid = {}

-- Or just sixteenth
Cuboid.SIXTEENTH = 1 / 16.0

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

function Cuboid.position(cuboid)
  return Vector3.new(cuboid.x, cuboid.y, cuboid.z)
end

function Cuboid.dimensions(cuboid)
  return Vector3.new(cuboid.w, cuboid.h, cuboid.d)
end

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

function Cuboid.to_extents(cuboid)
  return Vector3.new(cuboid.x, cuboid.y, cuboid.z),
         Vector3.new(cuboid.x + cuboid.w, cuboid.y + cuboid.h, cuboid.z + cuboid.d)
end

function Cuboid.to_node_box(cuboid)
  return {cuboid.x, cuboid.y, cuboid.z, cuboid.x + cuboid.w, cuboid.y + cuboid.h, cuboid.z + cuboid.d}
end

function Cuboid.fast_node_box(cuboid, scale)
  local result = Cuboid.scale(cuboid, scale or Cuboid.SIXTEENTH)
  result = Cuboid.translate(result, -0.5, -0.5, -0.5)
  return Cuboid.to_node_box(cuboid)
end

function Cuboid.new_fast_node_box(...)
  return Cuboid.fast_node_box(Cuboid.new(...))
end

foundation.com.Cuboid = Cuboid
