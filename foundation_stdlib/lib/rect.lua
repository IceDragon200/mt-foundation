--
-- Rect(angles) are a 2d shape representation
--
local Rect = {}

-- Create a new rectangle with all 4 components specified
-- @spec new(Number, Number, Number, Number) :: Rect
function Rect.new(x, y, w, h)
  return {
    x = x or 0,
    y = y or 0,
    w = w or 0,
    h = h or 0,
  }
end

-- Create a new rectangle with its components specified as 2 vec2 args
-- @spec new_from_vec2(Vector2, Vector2) :: Rect
function Rect.new_from_vec2(pos, size)
  return {
    x = pos.x,
    y = pos.y,
    w = size.x,
    h = size.y
  }
end

-- Create a new rectangle given the extents, that is the top left and bottom right
-- coords
-- @spec new_from_extents(Vector2, Vector2) :: Rect
function Rect.new_from_extents(pos1, pos2)
  local x1 = math.min(pos1.x, pos2.x)
  local x2 = math.max(pos1.x, pos2.x)

  local y1 = math.min(pos1.y, pos2.y)
  local y2 = math.max(pos1.y, pos2.y)

  return {
    x = x1,
    y = y1,
    w = x2 - x1,
    h = y2 - y1
  }
end

-- Copy an existing table as a rect
-- @spec copy(Table) :: Rect
function Rect.copy(rect)
  return {
    x = rect.x,
    y = rect.y,
    w = rect.w,
    h = rect.h
  }
end

-- Shrink the specified rect by the given horizontal and vertical size
-- if no vertical is given, it is assumed to be the same size as the horizontal
-- @spec contract(Rect, Number, Number) :: Rect
function Rect.contract(rect, horz, vert)
  vert = vert or horz

  rect.x = rect.x + horz
  rect.y = rect.y + vert
  rect.w = rect.w - horz * 2
  rect.h = rect.h - vert * 2

  return rect
end

-- Changes the width and height of the specified rectangle
-- @spec resize(Rect, Number, Number) :: Rect
function Rect.resize(rect, w, h)
  rect.w = w
  rect.h = h

  return rect
end

-- Moves the rectangle relative by the given coords
-- @spec translate(Rect, Number, Number) :: Rect
function Rect.translate(rect, x, y)
  rect.x = rect.x + x
  rect.y = rect.y + y

  return rect
end

foundation.com.Rect = Rect
