--- @namespace foundation.com

--- @type Point2Callback<T>: (x: T, y: T) => void
--- @type Point3Callback<T>: (x: T, y: T, z: T) => void

--- http://members.chello.at/%7Eeasyfilter/bresenham.html
--- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
---
--- @since "1.37.0"
--- @spec plot_line2(
---   x1: Integer,
---   y1: Integer,
---   x2: Integer,
---   y2: Integer,
---   callback?: Point2Callback<Integer>
--- ): nil | (has_more: Boolean, x: Integer, y: Integer)
function foundation.com.plot_line2(x1, y1, x2, y2, callback)
  if callback then
    foundation.com.plot_line2_inline(x1, y1, x2, y2, callback)
  else
    return foundation.com.plot_line2_iter(x1, y1, x2, y2)
  end
end

--- http://members.chello.at/%7Eeasyfilter/bresenham.html
--- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
---
--- @since "1.37.0"
--- @spec plot_line2_inline(
---   x1: Integer,
---   y1: Integer,
---   x2: Integer,
---   y2: Integer,
---   callback: Point2Callback<Integer>
--- ): void
function foundation.com.plot_line2_inline(x1, y1, x2, y2, callback)
  assert(x1, "expected x1-coord")
  assert(y1, "expected y1-coord")
  assert(x2, "expected x2-coord")
  assert(y2, "expected y2-coord")
  local dx = math.abs(x2 - x1)
  local dy = -math.abs(y2 - y1)

  local sx = 1
  local sy = 1

  if x1 > x2 then
    sx = -1
  end

  if y1 > y2 then
    sy = -1
  end

  local e = dx + dy
  local e2

  while true do
    callback(x1, y1)
    if x1 == x2 and y1 == y2 then
      break
    end

    e2 = e * 2
    if e2 >= dy then
      if x1 == x2 then
        break
      end
      e = e + dy
      x1 = x1 + sx
    end
    if e2 <= dx then
      if y1 == y2 then
        break
      end
      e = e + dx
      y1 = y1 + sy
    end
  end
end

--- http://members.chello.at/%7Eeasyfilter/bresenham.html
--- https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
---
--- @since "1.37.0"
--- @spec plot_line2_iter(
---   x1: Integer,
---   y1: Integer,
---   x2: Integer,
---   y2: Integer
--- ): () => (has_more: Boolean, Integer, Integer)
function foundation.com.plot_line2_iter(x1, y1, x2, y2)
  assert(x1, "expected x1-coord")
  assert(y1, "expected y1-coord")
  assert(x2, "expected x2-coord")
  assert(y2, "expected y2-coord")
  local dx = math.abs(x2 - x1)
  local dy = -math.abs(y2 - y1)

  local sx = 1
  local sy = 1

  if x1 > x2 then
    sx = -1
  end

  if y1 > y2 then
    sy = -1
  end

  local e = dx + dy
  local e2

  local x
  local y

  return function ()
    x = x1
    y = y1

    if x1 == x2 and y1 == y2 then
      return false, x, y
    end

    e2 = e * 2
    if e2 >= dy then
      if x1 == x2 then
        return false, x, y
      end
      e = e + dy
      x1 = x1 + sx
    end
    if e2 <= dx then
      if y1 == y2 then
        return false, x, y
      end
      e = e + dx
      y1 = y1 + sy
    end

    return true, x, y
  end
end

--- http://members.chello.at/%7Eeasyfilter/bresenham.html
--- @since "1.37.0"
--- @spec plot_line3(
---   x1: Integer,
---   y1: Integer,
---   z1: Integer,
---   x2: Integer,
---   y2: Integer,
---   z2: Integer,
---   callback?: Point3Callback<Integer>
--- ): nil | (has_more: Boolean, x: Integer, y: Integer, z: Integer)
function foundation.com.plot_line3(x1, y1, z1, x2, y2, z2, callback)
  if callback then
    foundation.com.plot_line3_inline(x1, y1, z1, x2, y2, z2, callback)
  else
    return foundation.com.plot_line3_iter(x1, y1, z1, x2, y2, z2)
  end
end

--- http://members.chello.at/%7Eeasyfilter/bresenham.html
--- @since "1.37.0"
--- @spec plot_line3_inline(
---   x1: Integer,
---   y1: Integer,
---   z1: Integer,
---   x2: Integer,
---   y2: Integer,
---   z2: Integer,
---   callback: Point3Callback<Integer>
--- ): void
function foundation.com.plot_line3_inline(x1, y1, z1, x2, y2, z2, callback)
  local dx = math.abs(x2 - x1)
  local dy = math.abs(y2 - y1)
  local dz = math.abs(z2 - z1)
  local dm = math.max(dx, math.max(dy, dz))
  local i = dm
  local x
  local y
  local z
  local sx = 1
  local sy = 1
  local sz = 1
  if x1 > x2 then
    sx = -1
  end
  if y1 > y2 then
    sy = -1
  end
  if z1 > z2 then
    sz = -1
  end
  x2 = math.floor(dm / 2)
  y2 = x2
  z2 = x2

  while true do
    callback(x1, y1, z1)
    if i == 0 then
      break
    end
    i = i - 1
    x2 = x2 - dx
    if x2 < 0 then
      x2 = x2 + dm
      x1 = x1 + sx
    end
    y2 = y2 - dy
    if y2 < 0 then
      y2 = y2 + dm
      y1 = y1 + sy
    end
    z2 = z2 - dz
    if z2 < 0 then
      z2 = z2 + dm
      z1 = z1 + sz
    end
  end
end

--- http://members.chello.at/%7Eeasyfilter/bresenham.html
--- @since "1.37.0"
--- @spec plot_line3_iter(
---   x1: Integer,
---   y1: Integer,
---   z1: Integer,
---   x2: Integer,
---   y2: Integer,
---   z2: Integer
--- ): () => (has_more: Boolean, x: Integer, y: Integer, z: Integer)
function foundation.com.plot_line3_iter(x1, y1, z1, x2, y2, z2)
  local dx = math.abs(x2 - x1)
  local dy = math.abs(y2 - y1)
  local dz = math.abs(z2 - z1)
  local dm = math.max(dx, math.max(dy, dz))
  local i = dm
  local x
  local y
  local z
  local sx = 1
  local sy = 1
  local sz = 1
  if x1 > x2 then
    sx = -1
  end
  if y1 > y2 then
    sy = -1
  end
  if z1 > z2 then
    sz = -1
  end
  x2 = math.floor(dm / 2)
  y2 = x2
  z2 = x2

  return function ()
    x = x1
    y = y1
    z = z1

    if i == 0 then
      return false, x, y, z
    end
    i = i - 1
    x2 = x2 - dx
    if x2 < 0 then
      x2 = x2 + dm
      x1 = x1 + sx
    end
    y2 = y2 - dy
    if y2 < 0 then
      y2 = y2 + dm
      y1 = y1 + sy
    end
    z2 = z2 - dz
    if z2 < 0 then
      z2 = z2 + dm
      z1 = z1 + sz
    end

    return true, x, y, z
  end
end

--- https://docs.rs/line_drawing/latest/line_drawing/struct.WalkGrid.html
--- @since "1.37.0"
--- @spec walk_ortho2(
---   x1: Number,
---   y1: Number,
---   x2: Number,
---   y2: Number,
---   callback?: Point2Callback<Number>
--- ): nil | Function/0
function foundation.com.walk_ortho2(x1, y1, x2, y2, callback)
  if callback then
    foundation.com.walk_ortho2_inline(x1, y1, x2, y2, callback)
  else
    return foundation.com.walk_ortho2_iter(x1, y1, x2, y2)
  end
end

--- @since "1.37.0"
--- @spec walk_ortho2_inline(
---   x1: Number,
---   y1: Number,
---   x2: Number,
---   y2: Number,
---   callback: Point2Callback<Number>
--- ): void
function foundation.com.walk_ortho2_inline(x1, y1, x2, y2, callback)
  local dx = x2 - x1
  local dy = y2 - y1
  local ix = 0
  local iy = 0
  local sx = 1
  local sy = 1
  local nx = math.abs(dx)
  local ny = math.abs(dy)
  local x = x1
  local y = y1

  if x1 > x2 then
    sx = -1
  end
  if y1 > y2 then
    sy = -1
  end

  while true do
    if ix <= nx and iy <= ny then
      callback(x, y)

      if (0.5 + ix) / nx < (0.5 + iy) / ny then
        x = x + sx
        ix = ix + 1
      else
        y = y + sy
        iy = iy + 1
      end
    else
      break
    end
  end
end

--- @since "1.37.0"
--- @spec walk_ortho2_iter(
---   x1: Number,
---   y1: Number,
---   x2: Number,
---   y2: Number
--- ): (has_more: Boolean, x: Number, y: Number) | (nil, nil, nil)
function foundation.com.walk_ortho2_iter(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  local ix = 0
  local iy = 0
  local sx = 1
  local sy = 1
  local nx = math.abs(dx)
  local ny = math.abs(dy)
  local x = x1
  local y = y1

  if x1 > x2 then
    sx = -1
  end
  if y1 > y2 then
    sy = -1
  end

  local rx
  local ry

  return function ()
    if ix <= nx and iy <= ny then
      rx = x
      ry = y

      if (0.5 + ix) / nx < (0.5 + iy) / ny then
        x = x + sx
        ix = ix + 1
      else
        y = y + sy
        iy = iy + 1
      end

      return ix <= nx and iy <= ny, rx, ry
    else
      return nil, nil, nil
    end
  end
end
