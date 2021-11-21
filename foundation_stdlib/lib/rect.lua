local number_round = assert(foundation.com.number_round)

-- @namespace foundation.com.Rect

--
-- Rect(angles) are a 2d shape representation
--
local Rect = {}

-- Create a new rectangle with all 4 components specified
--
-- @spec new(x?: Number, y?: Number, w?: Number, h?: Number): Rect
function Rect.new(x, y, w, h)
  return {
    x = x or 0,
    y = y or 0,
    w = w or 0,
    h = h or 0,
  }
end

-- Create a new rectangle with its components specified as 2 vec2 args
--
-- @spec new_from_vec2(Vector2, Vector2): Rect
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
--
-- @spec new_from_extents(Vector2, Vector2): Rect
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
--
-- @spec copy(Table): Rect
function Rect.copy(rect)
  return {
    x = rect.x,
    y = rect.y,
    w = rect.w,
    h = rect.h
  }
end

-- Returns the position of the rect as a vector2
--
-- @since "1.10.0"
-- @spec position(Rect): Vector2
function Rect.position(rect)
  return {
    x = rect.x,
    y = rect.y,
  }
end

-- Returns the size of the rect as a vector2
--
-- @since "1.10.0"
-- @spec size(Rect): Vector2
function Rect.size(rect)
  return {
    x = rect.w,
    y = rect.h,
  }
end

-- @since "1.10.0"
-- @spec area(Rect): Number
function Rect.area(rect)
  return rect.w * rect.h
end

-- @since "1.10.0"
-- @spec perimeter(Rect): Number
function Rect.perimeter(rect)
  return rect.w * 2 + rect.h * 2
end

-- Determines if the rectangle is empty.
-- A rectangle is considered empty if either its width or height are zero.
--
-- @since "1.10.0"
-- @spec is_empty(Rect): Boolean
function Rect.is_empty(rect)
  return rect.w == 0 or rect.h == 0
end

-- Shrink the specified rect by the given horizontal and vertical size
-- if no vertical is given, it is assumed to be the same size as the horizontal
--
-- @mutative
-- @spec contract(Rect, x: Number, y: Number): Rect
function Rect.contract(rect, x, y)
  y = y or x

  rect.x = rect.x + x
  rect.y = rect.y + y
  rect.w = rect.w - x * 2
  rect.h = rect.h - y * 2

  return rect
end

-- Expands the size of the rect from the center point, inverse of contract.
--
-- @since "1.10.0"
-- @mutative
-- @spec expand(Rect, x: Number, y: Number): Rect
function Rect.expand(rect, x, y)
  y = y or x

  return Rect.contract(rect, -x, -y)
end

-- Changes the width and height of the specified rectangle
--
-- @mutative
-- @spec resize(Rect, w: Number, h: Number): Rect
function Rect.resize(rect, w, h)
  rect.w = w
  rect.h = h

  return rect
end

-- Changes the x and y coords of the specified rectangle
--
-- @since "1.10.0"
-- @mutative
-- @spec move(Rect, x: Number, y: Number): Rect
function Rect.move(rect, x, y)
  rect.x = x
  rect.y = y

  return rect
end

-- Moves the rectangle relative by the given coords
--
-- @mutative
-- @spec translate(Rect, x: Number, y: Number): Rect
function Rect.translate(rect, x, y)
  rect.x = rect.x + x
  rect.y = rect.y + y

  return rect
end

-- Rounds all components in the rect using floor.
--
-- @since "1.10.0"
-- @mutative
-- @spec floor(rect: Rect): Rect
function Rect.floor(rect)
  rect.x = math.floor(rect.x)
  rect.y = math.floor(rect.y)
  rect.w = math.floor(rect.w)
  rect.h = math.floor(rect.h)

  return rect
end

-- Rounds all components in the rect using ceil.
--
-- @since "1.10.0"
-- @mutative
-- @spec ceil(rect: Rect): Rect
function Rect.ceil(rect)
  rect.x = math.ceil(rect.x)
  rect.y = math.ceil(rect.y)
  rect.w = math.ceil(rect.w)
  rect.h = math.ceil(rect.h)

  return rect
end

-- Rounds all components in the rect.
--
-- @since "1.10.0"
-- @mutative
-- @spec round(rect: Rect): Rect
function Rect.round(rect)
  rect.x = number_round(rect.x)
  rect.y = number_round(rect.y)
  rect.w = number_round(rect.w)
  rect.h = number_round(rect.h)

  return rect
end

-- Aligns the given rect to the parent `container` based on the given x, and y
-- The x and y coords are values -1 to 1, where -1 means align to the
-- left or top and 1 means to align to the right or bottom, 0 is centered.
--
-- @since "1.10.0"
-- @mutative
-- @spec align(rect: Rect, x?: Integer/2, y?: Integer/2, container: Rect): Rect
function Rect.align(rect, x, y, container)
  if x then
    if x < 0 then
      rect.x = container.x
    elseif x > 0 then
      rect.x = container.x + container.w - rect.w
    else
      rect.x = container.x + (container.w - rect.w) / 2
    end
  end

  if y then
    if y < 0 then
      rect.y = container.y
    elseif y > 0 then
      rect.y = container.y + container.h - rect.h
    else
      rect.y = container.y + (container.h - rect.h) / 2
    end
  end

  return rect
end

-- Splits the rectangle into a list of evenly spaced subdivisions.
-- Either or both the x_subdivisions and y_subdivisions can be provided to split
-- the rect.
--
-- @since "1.10.0"
-- @mutative
-- @spec subdivide(rect: Rect, x_subdivisions?: Integer, y_subdivisions?: Integer): Rect[]
function Rect.subdivide(rect, x_subdivisions, y_subdivisions)
  local x
  local y
  local w
  local h
  local result = {}

  if x_subdivisions and y_subdivisions then
    --
    w = rect.w / x_subdivisions
    h = rect.h / y_subdivisions

    for i = 1,y_subdivisions do
      for j = 1,x_subdivisions do
        x = (j - 1) * w
        y = (i - 1) * h
        result[1 + (i - 1) * x_subdivisions + j - 1] = Rect.new(rect.x + x, rect.y + y, w, h)
      end
    end
  elseif x_subdivisions then
    w = rect.w / x_subdivisions

    for i = 1,x_subdivisions do
      x = (i - 1) * w
      result[i] = Rect.new(rect.x + x, rect.y, w, rect.h)
    end
  elseif y_subdivisions then
    h = rect.h / y_subdivisions

    for i = 1,y_subdivisions do
      y = (i - 1) * h
      result[i] = Rect.new(rect.x, rect.y + y, rect.w, h)
    end
  else
    error("expected either x and or y subdivisions")
  end

  return result
end

-- Slices the Rectangle on the X-axis at specified position
--
-- @since "1.10.0"
-- @spec slice_x(Rect, x: Number): Rect[]
function Rect.slice_x(rect, x)
  --
  local result = {}

  local left = Rect.resize(Rect.copy(rect), x, rect.h)
  local right = Rect.resize(Rect.copy(rect), math.max(rect.w - x, 0), rect.h)
  right.x = right.x + x

  result[1] = left
  result[2] = right

  return result
end

-- Slices the Rectangle on the Y-axis at specified position
--
-- @since "1.10.0"
-- @spec slice_y(Rect, y: Number): Rect[]
function Rect.slice_y(rect, y)
  --
  local result = {}

  local up = Rect.resize(Rect.copy(rect), rect.w, y)
  local down = Rect.resize(Rect.copy(rect), rect.w, math.max(rect.h - y, 0))
  down.y = down.y + y

  result[1] = up
  result[2] = down

  return result
end

-- Splits a rectangle into segments.
-- If the x coord is provided it will split the rectangle horizontally into
-- 2 segments where the second segment starts at the x position.
--
-- Note that the coords are relative to the rect itself.
--
-- @since "1.10.0"
-- @spec slice(rect: Rect, x?: Number, y?: Number): Rect[]
function Rect.slice(rect, x, y)
  if x and y then
    --
    local result = {}

    local ul = Rect.copy(rect)
    ul.w = x
    ul.h = y

    local ur = Rect.copy(rect)
    ur.x = ur.x + x
    ur.w = math.max(ur.w - x, 0)
    ur.h = y

    local dl = Rect.copy(rect)
    dl.y = dl.y + y
    dl.w = x
    dl.h = math.max(dl.h - y, 0)

    local dr = Rect.copy(rect)
    dr.x = dr.x + x
    dr.y = dr.y + y
    dr.w = math.max(dr.w - x, 0)
    dr.h = math.max(dr.h - y, 0)

    result[1] = ul
    result[2] = ur
    result[3] = dl
    result[4] = dr

    return result

  elseif x then
    return Rect.slice_x(rect, x)

  elseif y then
    return Rect.slice_y(rect, y)

  else
    error("expected either x and or y coordinates")
  end
end

-- Determines if `rect` contains another rect `other`, returns true if `other`
-- fits completely in `rect`, returns false otherwise.
--
-- @since "1.10.0"
-- @spec contains(rect: Rect, other: Rect): Boolean
function Rect.contains(rect, other)
  local px1 = rect.x
  local py1 = rect.y
  local px2 = rect.x + rect.w
  local py2 = rect.y + rect.h

  local cx1 = other.x
  local cy1 = other.y
  local cx2 = other.x + other.w
  local cy2 = other.y + other.h

  return cx1 >= px1 and cx1 <= px2 and
         cx2 >= px1 and cx2 <= px2 and
         cy1 >= py1 and cy1 <= py2 and
         cy2 >= py1 and cy2 <= py2
end

-- Determines if `rect` and `other` intersect at any point.
--
-- @since "1.10.0"
-- @spec intersects(rect: Rect, other: Rect): Boolean
function Rect.intersects(rect, other)
  local ax1 = rect.x
  local ay1 = rect.y
  local ax2 = rect.x + rect.w
  local ay2 = rect.y + rect.h

  local bx1 = other.x
  local by1 = other.y
  local bx2 = bx1 + other.w
  local by2 = by1 + other.h

  --     child in parent
  return (bx1 >= ax1 and bx1 <= ax2 and by1 >= ay1 and by1 <= ay2) or
         (bx2 >= ax1 and bx2 <= ax2 and by1 >= ay1 and by1 <= ay2) or
         (bx1 >= ax1 and bx1 <= ax2 and by2 >= ay1 and by2 <= ay2) or
         (bx2 >= ax1 and bx2 <= ax2 and by2 >= ay1 and by2 <= ay2) or
         -- parent in child
         (ax1 >= bx1 and ax1 <= bx2 and ay1 >= by1 and ay1 <= by2) or
         (ax2 >= bx1 and ax2 <= bx2 and ay1 >= by1 and ay1 <= by2) or
         (ax1 >= bx1 and ax1 <= bx2 and ay2 >= by1 and ay2 <= by2) or
         (ax2 >= bx1 and ax2 <= bx2 and ay2 >= by1 and ay2 <= by2)
end

function Rect.merge(...)
  local len = select('#', ...)

  local ix2
  local iy2

  local x1
  local x2
  local y1
  local y2
  local rect

  for i = 1,len do
    rect = select(i, ...)

    if x1 then
      if rect.x < x1 then
        x1 = rect.x
      end
    else
      x1 = rect.x
    end

    if y1 then
      if rect.y < y1 then
        y1 = rect.y
      end
    else
      y1 = rect.y
    end

    ix2 = rect.x + rect.w
    iy2 = rect.y + rect.h

    if x2 then
      if ix2 > x2 then
        x2 = ix2
      end
    else
      x2 = ix2
    end

    if y2 then
      if iy2 > y2 then
        y2 = iy2
      end
    else
      y2 = iy2
    end
  end

  return Rect.new(
    x1 or 0,
    y1 or 0,
    (x2 or 0) - (x1 or 0),
    (y2 or 0) - (y1 or 0)
  )
end

foundation.com.Rect = Rect
