-- @namespace foundation.com.Directions

local table_freeze = assert(foundation.com.table_freeze)

local Vector3 = assert(foundation.com.Vector3)
local Directions = {}

-- This uses a bit flag map, for quick use with binary-styled representations
-- It does make face values a pain though
-- UD WSEN

-- @type DirectionCode: Integer

-- @type DirectionCodeMap: {
--   [dir_code: DirectionCode]: DirectionCode
-- }

-- @const D_NONE: DirectionCode
Directions.D_NONE = 0 -- no direction
-- @const D_NORTH: DirectionCode
Directions.D_NORTH = 1 -- +Z
-- @const D_EAST: DirectionCode
Directions.D_EAST = 2 -- +X
-- @const D_SOUTH: DirectionCode
Directions.D_SOUTH = 4 -- -Z
-- @const D_WEST: DirectionCode
Directions.D_WEST = 8 -- -X
-- @const D_DOWN: DirectionCode
Directions.D_DOWN = 16 -- -Y
-- @const D_UP: DirectionCode
Directions.D_UP = 32 -- +Y

-- In case one needs the 4 cardinal directions for whatever reason
-- @const DIR4: DirectionCode[]
Directions.DIR4 = table_freeze({
  Directions.D_NORTH,
  Directions.D_EAST,
  Directions.D_SOUTH,
  Directions.D_WEST,
})

-- @const DIR6: DirectionCode[]
Directions.DIR6 = table_freeze({
  Directions.D_NORTH,
  Directions.D_EAST,
  Directions.D_SOUTH,
  Directions.D_WEST,
  Directions.D_DOWN,
  Directions.D_UP,
})

-- Vectors, repsenting the directions

-- North face normal
-- @const V3_NORTH: Vector3
Directions.V3_NORTH = table_freeze(Vector3.new(0, 0, 1))
-- East face normal
-- @const V3_EAST: Vector3
Directions.V3_EAST = table_freeze(Vector3.new(1, 0, 0))
-- South face normal
-- @const V3_SOUTH: Vector3
Directions.V3_SOUTH = table_freeze(Vector3.new(0, 0, -1))
-- West face normal
-- @const V3_WEST: Vector3
Directions.V3_WEST = table_freeze(Vector3.new(-1, 0, 0))
-- Down face normal
-- @const V3_DOWN: Vector3
Directions.V3_DOWN = table_freeze(Vector3.new(0, -1, 0))
-- Up face normal
-- @const V3_UP: Vector3
Directions.V3_UP = table_freeze(Vector3.new(0, 1, 0))

-- @const DIR_TO_HEADING: {
--   [dir_code: DirectionCode]: Float
-- }
Directions.DIR_TO_HEADING = table_freeze({
  [Directions.D_NORTH] = 0.0,
  [Directions.D_EAST] = math.pi / 2,
  [Directions.D_SOUTH] = math.pi,
  [Directions.D_WEST] = (math.pi / 2) * 3,
})

-- @const ROT_TO_HEADING: {
--   [rotation: Integer]: Float
-- }
Directions.ROT_TO_HEADING = table_freeze({
  [0] = Directions.DIR_TO_HEADING[Directions.D_NORTH],
  [1] = Directions.DIR_TO_HEADING[Directions.D_EAST],
  [2] = Directions.DIR_TO_HEADING[Directions.D_SOUTH],
  [3] = Directions.DIR_TO_HEADING[Directions.D_WEST],
})

-- A helper table for converting the D_* constants to their vectors
--
-- @const DIR6_TO_VEC3: {
--   [dir_code: DirectionCode]: Vector3
-- }
Directions.DIR6_TO_VEC3 = table_freeze({
  [Directions.D_NORTH] = Directions.V3_NORTH,
  [Directions.D_EAST] = Directions.V3_EAST,
  [Directions.D_SOUTH] = Directions.V3_SOUTH,
  [Directions.D_WEST] = Directions.V3_WEST,
  [Directions.D_DOWN] = Directions.V3_DOWN,
  [Directions.D_UP] = Directions.V3_UP,
})

-- @const DIR4_TO_VEC3: {
--   [dir_code: DirectionCode]: Vector3
-- }
Directions.DIR4_TO_VEC3 = table_freeze({
  [Directions.D_NORTH] = Directions.V3_NORTH,
  [Directions.D_EAST] = Directions.V3_EAST,
  [Directions.D_SOUTH] = Directions.V3_SOUTH,
  [Directions.D_WEST] = Directions.V3_WEST,
})

-- Clockwise and Anti-Clockwise tables
-- @const DIR4_CW_ROTATION: {
--   [dir_code: DirectionCode]: DirectionCode
-- }
Directions.DIR4_CW_ROTATION = table_freeze({
  [Directions.D_NORTH] = Directions.D_EAST,
  [Directions.D_EAST] = Directions.D_SOUTH,
  [Directions.D_SOUTH] = Directions.D_WEST,
  [Directions.D_WEST] = Directions.D_NORTH,
})

-- @const DIR4_ACW_ROTATION: {
--   [dir_code: DirectionCode]: DirectionCode
-- }
Directions.DIR4_ACW_ROTATION = table_freeze({
  [Directions.D_NORTH] = Directions.D_WEST,
  [Directions.D_EAST] = Directions.D_NORTH,
  [Directions.D_SOUTH] = Directions.D_EAST,
  [Directions.D_WEST] = Directions.D_SOUTH,
})

-- A helper table for converting the D_* constants to strings
-- @const DIR_TO_STRING: {
--   [dir_code: DirectionCode]: String
-- }
Directions.DIR_TO_STRING = table_freeze({
  [Directions.D_NONE] = "NONE",
  [Directions.D_NORTH] = "NORTH",
  [Directions.D_EAST] = "EAST",
  [Directions.D_SOUTH] = "SOUTH",
  [Directions.D_WEST] = "WEST",
  [Directions.D_DOWN] = "DOWN",
  [Directions.D_UP] = "UP",
})

-- @const DIR_TO_STRING1: {
--   [dir_code: DirectionCode]: String
-- }
Directions.DIR_TO_STRING1 = table_freeze({
  [Directions.D_NONE] = "0",
  [Directions.D_NORTH] = "N",
  [Directions.D_EAST] = "E",
  [Directions.D_SOUTH] = "S",
  [Directions.D_WEST] = "W",
  [Directions.D_DOWN] = "D",
  [Directions.D_UP] = "U",
})

-- @const STRING1_TO_DIR: {
--   [code: String]: DirectionCode
-- }
Directions.STRING1_TO_DIR = {}
for dir, str in pairs(Directions.DIR_TO_STRING1) do
  Directions.STRING1_TO_DIR[str] = dir
end
Directions.STRING1_TO_DIR = table_freeze(Directions.STRING1_TO_DIR)

-- And the inversions
-- @const INVERTED_DIR6: {
--   [dir_code: DirectionCode]: DirectionCode
-- }
Directions.INVERTED_DIR6 = table_freeze({
  [Directions.D_NONE] = Directions.D_NONE,
  [Directions.D_SOUTH] = Directions.D_NORTH,
  [Directions.D_WEST] = Directions.D_EAST,
  [Directions.D_NORTH] = Directions.D_SOUTH,
  [Directions.D_EAST] = Directions.D_WEST,
  [Directions.D_UP] = Directions.D_DOWN,
  [Directions.D_DOWN] = Directions.D_UP,
})

-- @const INVERTED_DIR6_TO_VEC3: {
--   [dir_code: DirectionCode]: Vector3
-- }
Directions.INVERTED_DIR6_TO_VEC3 = table_freeze({
  [Directions.D_SOUTH] = Directions.V3_NORTH,
  [Directions.D_WEST] = Directions.V3_EAST,
  [Directions.D_NORTH] = Directions.V3_SOUTH,
  [Directions.D_EAST] = Directions.V3_WEST,
  [Directions.D_UP] = Directions.V3_DOWN,
  [Directions.D_DOWN] = Directions.V3_UP,
})

-- Facedir Axis
Directions.FD_AXIS_Yp = 0
Directions.FD_AXIS_Ym = 20

Directions.FD_AXIS_Xp = 12
Directions.FD_AXIS_Xm = 16

Directions.FD_AXIS_Zp = 4
Directions.FD_AXIS_Zm = 8

-- Axis Index to Axis facedir offsets
Directions.FD_AXIS = table_freeze({
  [0] = Directions.FD_AXIS_Yp,
  [1] = Directions.FD_AXIS_Zp,
  [2] = Directions.FD_AXIS_Zm,
  [3] = Directions.FD_AXIS_Xp,
  [4] = Directions.FD_AXIS_Xm,
  [5] = Directions.FD_AXIS_Ym,
})

-- Axis index to D_* constant
Directions.AXIS = table_freeze({
  [0] = Directions.D_UP,
  [1] = Directions.D_NORTH,
  [2] = Directions.D_SOUTH,
  [3] = Directions.D_EAST,
  [4] = Directions.D_WEST,
  [5] = Directions.D_DOWN,
})

local function fm(u, n, s, e, w, d)
  return table_freeze({
    [Directions.D_UP] = u,
    [Directions.D_NORTH] = n,
    [Directions.D_SOUTH] = s,
    [Directions.D_EAST] = e,
    [Directions.D_WEST] = w,
    [Directions.D_DOWN] = d,
  })
end

local U = Directions.D_UP    -- Y+
local N = Directions.D_NORTH -- Z+
local S = Directions.D_SOUTH -- Z-
local E = Directions.D_EAST  -- X+
local W = Directions.D_WEST  -- X-
local D = Directions.D_DOWN  -- Y-

-- Never again, f*** this seriously.
-- Updated 2019-10-30, changed it a bit

-- Transforms the facedir to the node's local face.
--
-- @const FACEDIR_TO_LOCAL_FACE: {
--   [facedir: Integer]: DirectionCodeMap
-- }
Directions.FACEDIR_TO_LOCAL_FACE = table_freeze({
  -- Yp
  [0]  = fm(U, N, S, E, W, D), -- neutral face
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
})

-- Transforms the world facing to the local
--
-- @const FACEDIR_TO_FACES: {
--   [facedir: Integer]: DirectionCodeMap
-- }
Directions.FACEDIR_TO_FACES = {}

for facedir, map in pairs(Directions.FACEDIR_TO_LOCAL_FACE) do
  Directions.FACEDIR_TO_FACES[facedir] = {}
  for dir, dir2 in pairs(map) do
    -- invert mapping
    Directions.FACEDIR_TO_FACES[facedir][dir2] = dir
  end
end

-- @spec dir_to_string(DirectionCode): String
function Directions.dir_to_string(dir)
  return Directions.DIR_TO_STRING[dir]
end

--
-- Code is a short 1 byte string that represents the direction.
--
-- I.e the first initial of the string, it just so happens that NONE is 0 instead of N
-- (which is used for NORTH).
--
-- @spec dir_to_code(DirectionCode): String
function Directions.dir_to_code(dir)
  return Directions.DIR_TO_STRING1[dir]
end

--[[

  Args:
  * `facedir` :: integer - the facedir

  Returns:
  * `table` :: a table containing each new face mapped using Directions.D_*

]]
-- @spec facedir_to_faces(Facedir): DirectionCodeMap
function Directions.facedir_to_faces(facedir)
  return Directions.FACEDIR_TO_FACES[facedir % 32]
end

-- @spec facedir_to_face(Facedir, base_face: DirectionCode): DirectionCode
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

-- @spec facedir_to_local_faces(Facedir): DirectionCodeMap
function Directions.facedir_to_local_faces(facedir)
  return Directions.FACEDIR_TO_LOCAL_FACE[facedir % 32]
end

-- @spec facedir_to_local_face(Facedir, base_face: DirectionCode): DirectionCode
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

-- @spec facedir_to_fd_axis_and_fd_rotation(facedir: Integer): (axis: Integer, rotation: Integer)
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

-- @spec rotate_position_by_facedir(Vector3, from_facedir: Facedir, to_facedir: Facedir): Vector3
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

-- Determines what direction the `looker` is from the `target`
--
-- @spec cardinal_direction_from(axis: DirectionCode, target: Vector3, looker: Vector3):
--   DirectionCode
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

-- @spec axis_to_facedir(axis: DirectionCode): Integer
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

-- @spec axis_to_facedir_rotation(axis: DirectionCode): Integer
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
-- @spec facedir_from_axis_and_rotation(axis: DIR6, rotation: DIR4): Integer
function Directions.facedir_from_axis_and_rotation(axis, rotation)
  local base = Directions.axis_to_facedir(axis)
  return base + Directions.axis_to_facedir_rotation(rotation)
end

-- @spec inspect_axis(axis: Integer): String
function Directions.inspect_axis(axis)
  return Directions.DIR_TO_STRING[axis]
end

-- @spec inspect_axis_and_rotation(axis: Integer, rotation: Integer): String
function Directions.inspect_axis_and_rotation(axis, rotation)
  return Directions.DIR_TO_STRING[axis] .. " rotated to " .. Directions.DIR_TO_STRING[rotation]
end

foundation.com.Directions = Directions
