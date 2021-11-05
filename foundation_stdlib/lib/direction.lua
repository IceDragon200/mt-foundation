-- @namespace foundation.com.Directions

local Directions = {}

-- This uses a bit flag map, for quick use with binary-styled representations
-- It does make face values a pain though
-- UD WSEN
Directions.D_NONE = 0 -- no direction
Directions.D_NORTH = 1 -- +Z
Directions.D_EAST = 2 -- +X
Directions.D_SOUTH = 4 -- -Z
Directions.D_WEST = 8 -- -X
Directions.D_DOWN = 16 -- -Y
Directions.D_UP = 32 -- +Y

-- In case one needs the 4 cardinal directions for whatever reason
Directions.DIR4 = {
  Directions.D_NORTH,
  Directions.D_EAST,
  Directions.D_SOUTH,
  Directions.D_WEST,
}

Directions.DIR6 = {
  Directions.D_NORTH,
  Directions.D_EAST,
  Directions.D_SOUTH,
  Directions.D_WEST,
  Directions.D_DOWN,
  Directions.D_UP,
}

-- Vectors, repsenting the directions
Directions.V3_NORTH = vector.new(0, 0, 1)
Directions.V3_EAST = vector.new(1, 0, 0)
Directions.V3_SOUTH = vector.new(0, 0, -1)
Directions.V3_WEST = vector.new(-1, 0, 0)
Directions.V3_DOWN = vector.new(0, -1, 0)
Directions.V3_UP = vector.new(0, 1, 0)

-- A helper table for converting the D_* constants to their vectors
Directions.DIR6_TO_VEC3 = {
  [Directions.D_NORTH] = Directions.V3_NORTH,
  [Directions.D_EAST] = Directions.V3_EAST,
  [Directions.D_SOUTH] = Directions.V3_SOUTH,
  [Directions.D_WEST] = Directions.V3_WEST,
  [Directions.D_DOWN] = Directions.V3_DOWN,
  [Directions.D_UP] = Directions.V3_UP,
}

Directions.DIR4_TO_VEC3 = {
  [Directions.D_NORTH] = Directions.V3_NORTH,
  [Directions.D_EAST] = Directions.V3_EAST,
  [Directions.D_SOUTH] = Directions.V3_SOUTH,
  [Directions.D_WEST] = Directions.V3_WEST,
}

-- Clockwise and Anti-Clockwise tables
Directions.DIR4_CW_ROTATION = {
  [Directions.D_NORTH] = Directions.D_EAST,
  [Directions.D_EAST] = Directions.D_SOUTH,
  [Directions.D_SOUTH] = Directions.D_WEST,
  [Directions.D_WEST] = Directions.D_NORTH,
}

Directions.DIR4_ACW_ROTATION = {
  [Directions.D_NORTH] = Directions.D_WEST,
  [Directions.D_EAST] = Directions.D_NORTH,
  [Directions.D_SOUTH] = Directions.D_EAST,
  [Directions.D_WEST] = Directions.D_SOUTH,
}

-- A helper table for converting the D_* constants to strings
Directions.DIR_TO_STRING = {
  [Directions.D_NONE] = "NONE",
  [Directions.D_NORTH] = "NORTH",
  [Directions.D_EAST] = "EAST",
  [Directions.D_SOUTH] = "SOUTH",
  [Directions.D_WEST] = "WEST",
  [Directions.D_DOWN] = "DOWN",
  [Directions.D_UP] = "UP",
}

Directions.DIR_TO_STRING1 = {
  [Directions.D_NONE] = "0",
  [Directions.D_NORTH] = "N",
  [Directions.D_EAST] = "E",
  [Directions.D_SOUTH] = "S",
  [Directions.D_WEST] = "W",
  [Directions.D_DOWN] = "D",
  [Directions.D_UP] = "U",
}

Directions.STRING1_TO_DIR = {}
for dir, str in pairs(Directions.DIR_TO_STRING1) do
  Directions.STRING1_TO_DIR[str] = dir
end

-- And the inversions
Directions.INVERTED_DIR6 = {
  [Directions.D_NONE] = Directions.D_NONE,
  [Directions.D_SOUTH] = Directions.D_NORTH,
  [Directions.D_WEST] = Directions.D_EAST,
  [Directions.D_NORTH] = Directions.D_SOUTH,
  [Directions.D_EAST] = Directions.D_WEST,
  [Directions.D_UP] = Directions.D_DOWN,
  [Directions.D_DOWN] = Directions.D_UP,
}
Directions.INVERTED_DIR6_TO_VEC3 = {
  [Directions.D_SOUTH] = Directions.V3_NORTH,
  [Directions.D_WEST] = Directions.V3_EAST,
  [Directions.D_NORTH] = Directions.V3_SOUTH,
  [Directions.D_EAST] = Directions.V3_WEST,
  [Directions.D_UP] = Directions.V3_DOWN,
  [Directions.D_DOWN] = Directions.V3_UP,
}

-- Facedir Axis
Directions.FD_AXIS_Yp = 0
Directions.FD_AXIS_Ym = 20

Directions.FD_AXIS_Xp = 12
Directions.FD_AXIS_Xm = 16

Directions.FD_AXIS_Zp = 4
Directions.FD_AXIS_Zm = 8

-- Axis Index to Axis facedir offsets
Directions.FD_AXIS = {
  [0] = Directions.FD_AXIS_Yp,
  [1] = Directions.FD_AXIS_Zp,
  [2] = Directions.FD_AXIS_Zm,
  [3] = Directions.FD_AXIS_Xp,
  [4] = Directions.FD_AXIS_Xm,
  [5] = Directions.FD_AXIS_Ym,
}

-- Axis index to D_* constant
Directions.AXIS = {
  [0] = Directions.D_UP,
  [1] = Directions.D_NORTH,
  [2] = Directions.D_SOUTH,
  [3] = Directions.D_EAST,
  [4] = Directions.D_WEST,
  [5] = Directions.D_DOWN,
}

local fm = function(u, n, s, e, w, d)
  return {
    [Directions.D_UP] = u,
    [Directions.D_NORTH] = n,
    [Directions.D_SOUTH] = s,
    [Directions.D_EAST] = e,
    [Directions.D_WEST] = w,
    [Directions.D_DOWN] = d,
  }
end

local U = Directions.D_UP    -- Y+
local N = Directions.D_NORTH -- Z+
local S = Directions.D_SOUTH -- Z-
local E = Directions.D_EAST  -- X+
local W = Directions.D_WEST  -- X-
local D = Directions.D_DOWN  -- Y-

-- Never again, f*** this seriously.
-- Updated 2019-10-30, changed it a bit
Directions.FACEDIR_TO_LOCAL_FACE = {
  -- Yp
  [0]  = fm(U, N, S, E, W, D),
  [1]  = fm(U, W, E, N, S, D),
  [2]  = fm(U, S, N, W, E, D),
  [3]  = fm(U, E, W, S, N, D),
  -- Zp
  [4]  = fm(S, U, D, E, W, N),
  [5]  = fm(E, U, D, N, S, W),
  [6]  = fm(N, U, D, W, E, S),
  [7]  = fm(W, U, D, S, N, E),
  -- Zm
  [8]  = fm(N, D, U, E, W, S),
  [9]  = fm(W, D, U, N, S, E),
  [10] = fm(S, D, U, W, E, N),
  [11] = fm(E, D, U, S, N, W),
  -- Xp
  [12] = fm(W, N, S, U, D, E),
  [13] = fm(S, W, E, U, D, N),
  [14] = fm(E, S, N, U, D, W),
  [15] = fm(N, E, W, U, D, S),
  -- Xm
  [16] = fm(E, N, S, D, U, W),
  [17] = fm(N, W, E, D, U, S),
  [18] = fm(W, S, N, D, U, E),
  [19] = fm(S, E, W, D, U, N),
  -- Ym
  [20] = fm(D, N, S, W, E, U),
  [21] = fm(D, W, E, S, N, U),
  [22] = fm(D, S, N, E, W, U),
  [23] = fm(D, E, W, N, S, U),
}

Directions.FACEDIR_TO_FACES = {}

for facedir, map in pairs(Directions.FACEDIR_TO_LOCAL_FACE) do
  Directions.FACEDIR_TO_FACES[facedir] = {}
  for dir, dir2 in pairs(map) do
    -- invert mapping
    Directions.FACEDIR_TO_FACES[facedir][dir2] = dir
  end
end

function Directions.dir_to_string(dir)
  return Directions.DIR_TO_STRING[dir]
end

--[[

  Code is a short 1 byte string that represents the direction.

  I.e the first initial of the string, it just so happens that NONE is 0 instead of N (which is used for NORTH)

]]
function Directions.dir_to_code(dir)
  return Directions.DIR_TO_STRING1[dir]
end

--[[

  Args:
  * `facedir` :: integer - the facedir

  Returns:
  * `table` :: a table containing each new face mapped using Directions.D_*

]]
function Directions.facedir_to_faces(facedir)
  return Directions.FACEDIR_TO_FACES[facedir % 32]
end

function Directions.facedir_to_face(facedir, base_face)
  assert(base_face, "expected a face")
  assert(facedir, "expected a facedir")
  local faces = Directions.facedir_to_faces(facedir)
  if faces then
    return faces[base_face]
  else
    return nil
  end
end

function Directions.facedir_to_local_faces(facedir)
  return Directions.FACEDIR_TO_LOCAL_FACE[facedir % 32]
end

function Directions.facedir_to_local_face(facedir, base_face)
  assert(base_face, "expected a face")
  assert(facedir, "expected a facedir")
  local faces = Directions.facedir_to_local_faces(facedir)
  if faces then
    return faces[base_face]
  else
    return nil
  end
end

-- TODO
--function Directions.facedir_to_axis_and_rotation(facedir)
--  local axis_index = math.floor((facedir % 32) / 4)
--  local axis = assert(Directions.FD_AXIS[axis_index])
--  return axis, facedir % 4
--end

function Directions.facedir_to_fd_axis_and_fd_rotation(facedir)
  local fd_axis = math.floor((facedir % 32) / 4)
  local fd_rotation = (facedir % 4)
  return fd_axis * 4, fd_rotation
end

function Directions.rotate_facedir_axis_clockwise(facedir)
  local fd_axis, fd_rotation = Directions.facedir_to_fd_axis_and_fd_rotation(facedir)
  return (fd_axis + 4) % 24 + fd_rotation
end

function Directions.rotate_facedir_axis_anticlockwise(facedir)
  local fd_axis, fd_rotation = Directions.facedir_to_fd_axis_and_fd_rotation(facedir)
  return (fd_axis - 4) % 24 + fd_rotation
end

function Directions.rotate_facedir_face_clockwise(facedir)
  local fd_axis, fd_rotation = Directions.facedir_to_fd_axis_and_fd_rotation(facedir)
  return fd_axis + ((fd_rotation + 1) % 4)
end

function Directions.rotate_facedir_face_anticlockwise(facedir)
  local fd_axis, fd_rotation = Directions.facedir_to_fd_axis_and_fd_rotation(facedir)
  return fd_axis + ((fd_rotation - 1) % 4)
end

function Directions.rotate_facedir_face_180(facedir)
  local fd_axis, fd_rotation = Directions.facedir_to_fd_axis_and_fd_rotation(facedir)
  return fd_axis + ((fd_rotation + 2) % 4)
end

function Directions.invert_dir_to_vec3(dir)
  assert(type(dir) == "number", "expected a number")
  return Directions.INVERTED_DIR6_TO_VEC3[dir]
end

function Directions.invert_dir(dir)
  assert(type(dir) == "number", "expected a number")
  return Directions.INVERTED_DIR6[dir]
end

function Directions.new_accessible_dirs()
  return {
    [Directions.D_NORTH] = true,
    [Directions.D_EAST] = true,
    [Directions.D_SOUTH] = true,
    [Directions.D_WEST] = true,
    [Directions.D_DOWN] = true,
    [Directions.D_UP] = true,
  }
end

-- done with it, let the gc reclaim it
fm = nil
N = nil
E = nil
S = nil
W = nil
D = nil
U = nil

function Directions.vdir_to_wallmounted_facedir(dir)
  if dir.x > 0 then
    return Directions.FD_AXIS_Xp
  elseif dir.x < 0 then
    return Directions.FD_AXIS_Xm
  end
  if dir.y > 0 then
    return Directions.FD_AXIS_Yp
  elseif dir.y < 0 then
    return Directions.FD_AXIS_Ym
  end
  if dir.z > 0 then
    return Directions.FD_AXIS_Zp
  elseif dir.z < 0 then
    return Directions.FD_AXIS_Zm
  end
  return nil
end

function Directions.facedir_wallmount_after_place_node(pos, _placer, _itemstack, pointed_thing)
  assert(pointed_thing, "expected a pointed thing")
  local above = pointed_thing.above
  local under = pointed_thing.under
  local dir = {
    x = above.x - under.x,
    y = above.y - under.y,
    z = above.z - under.z
  }
  local node = minetest.get_node(pos)
  node.param2 = Directions.vdir_to_wallmounted_facedir(dir)
  minetest.swap_node(pos, node)
end

function Directions.rotate_position_by_facedir(p, from_facedir, to_facedir)
  if from_facedir == to_facedir then
    return p
  end

  local n = Directions.facedir_to_face(from_facedir, Directions.D_NORTH)
  local e = Directions.facedir_to_face(from_facedir, Directions.D_EAST)
  local u = Directions.facedir_to_face(from_facedir, Directions.D_UP)

  local to_n = Directions.facedir_to_face(to_facedir, n)
  local to_e = Directions.facedir_to_face(to_facedir, e)
  local to_u = Directions.facedir_to_face(to_facedir, u)

  local vz = Directions.DIR6_TO_VEC3[to_n]
  local vx = Directions.DIR6_TO_VEC3[to_e]
  local vy = Directions.DIR6_TO_VEC3[to_u]

  return {
    x = vx.x * p.x + vy.x * p.y + vz.x * p.z,
    y = vx.y * p.x + vy.y * p.y + vz.y * p.z,
    z = vx.z * p.x + vy.z * p.y + vz.z * p.z,
  }
end

--[[
Determines what direction the `looker` is from the `target`
]]
function Directions.cardinal_direction_from(axis, target, looker)
  local normal = {
    x = looker.x - target.x,
    y = looker.y - target.y,
    z = looker.z - target.z,
  }

  if axis == Directions.D_UP then
    -- Coordinates are pretty plain and boring
    -- y-axis should be ignored
    local ax = math.abs(normal.x)
    local az = math.abs(normal.z)
    if ax > az then
      if normal.x > 0 then
        return Directions.D_EAST
      else
        return Directions.D_WEST
      end
    else
      if normal.z > 0 then
        return Directions.D_NORTH
      else
        return Directions.D_SOUTH
      end
    end
  elseif axis == Directions.D_DOWN then
    -- Coordinates are inverted
    -- y-axis should be ignored
    local ax = math.abs(normal.x)
    local az = math.abs(normal.z)
    if ax > az then
      if normal.x > 0 then
        return Directions.D_WEST
      else
        return Directions.D_EAST
      end
    else
      if normal.z > 0 then
        return Directions.D_NORTH
      else
        return Directions.D_SOUTH
      end
    end
  elseif axis == Directions.D_NORTH then
    -- Coordinates are normal
    -- z-axis should be ignored
    local ax = math.abs(normal.x)
    local ay = math.abs(normal.y)
    if ax > ay then
      if normal.x > 0 then
        return Directions.D_EAST
      else
        return Directions.D_WEST
      end
    else
      if normal.y > 0 then
        return Directions.D_NORTH
      else
        return Directions.D_SOUTH
      end
    end
  elseif axis == Directions.D_EAST then
    -- Coordinates are normal
    -- x-axis should be ignored
    local ay = math.abs(normal.y)
    local az = math.abs(normal.z)
    if az > ay then
      if normal.z > 0 then
        return Directions.D_EAST
      else
        return Directions.D_WEST
      end
    else
      if normal.y > 0 then
        return Directions.D_NORTH
      else
        return Directions.D_SOUTH
      end
    end
  elseif axis == Directions.D_SOUTH then
    -- Coordinates are inverted
    -- z-axis should be ignored
    local ax = math.abs(normal.x)
    local ay = math.abs(normal.y)
    if ax > ay then
      if normal.x > 0 then
        return Directions.D_WEST
      else
        return Directions.D_EAST
      end
    else
      if normal.y > 0 then
        return Directions.D_NORTH
      else
        return Directions.D_SOUTH
      end
    end
  elseif axis == Directions.D_WEST then
    -- Coordinates are inverted
    -- x-axis should be ignored
    local ay = math.abs(normal.y)
    local az = math.abs(normal.z)
    if az > ay then
      if normal.z > 0 then
        return Directions.D_WEST
      else
        return Directions.D_EAST
      end
    else
      if normal.y > 0 then
        return Directions.D_NORTH
      else
        return Directions.D_SOUTH
      end
    end
  end
  return Directions.D_NONE
end

function Directions.axis_to_facedir(axis)
  if axis == Directions.D_UP then
    return Directions.FD_AXIS_Yp
  elseif axis == Directions.D_DOWN then
    return Directions.FD_AXIS_Ym
  elseif axis == Directions.D_EAST then
    return Directions.FD_AXIS_Xp
  elseif axis == Directions.D_WEST then
    return Directions.FD_AXIS_Xm
  elseif axis == Directions.D_SOUTH then
    return Directions.FD_AXIS_Zm
  elseif axis == Directions.D_NORTH then
    return Directions.FD_AXIS_Zp
  end
  return 0
end

function Directions.axis_to_facedir_rotation(axis)
  if axis == Directions.D_NORTH then
    return 0
  elseif axis == Directions.D_EAST then
    return 1
  elseif axis == Directions.D_SOUTH then
    return 2
  elseif axis == Directions.D_WEST then
    return 3
  end
  return 0
end

--
-- Directions.facedir_from_axis_and_rotation(axis :: DIR6, rotation :: DIR4)
--
function Directions.facedir_from_axis_and_rotation(axis, rotation)
  local base = Directions.axis_to_facedir(axis)
  return base + Directions.axis_to_facedir_rotation(rotation)
end

function Directions.inspect_axis(axis)
  return Directions.DIR_TO_STRING[axis]
end

function Directions.inspect_axis_and_rotation(axis, rotation)
  return Directions.DIR_TO_STRING[axis] .. " rotated to " .. Directions.DIR_TO_STRING[rotation]
end

foundation.com.Directions = Directions
