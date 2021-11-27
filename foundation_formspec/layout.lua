--
--
--
local Rect = assert(foundation.com.Rect)
local List = assert(foundation.com.List)

-- @namespace foundation.com.formspec

-- @class Layout
local Layout = foundation.com.Class:extends("foundation.com.formspec.Layout")
local ic = Layout.instance_class

-- @spec #initialize(): void
function ic:initialize()
  self.m_boxes = List:new()
end

-- @spec #new_inv_box(String, x: Number, y: Number, w: Number, h: Number, Function/2): Box
function ic:new_box(id, x, y, w, h, callback)
  local rect = Rect.new(x, y, w, h)

  local box = {
    id = id,
    rect = rect,
    callback = callback,
  }

  self.m_boxes:push(box)

  return box
end

-- Creates a box, but compensates for a inventory list
--
-- @spec #new_inv_box(String, x: Number, y: Number, cols: Integer, rows: Integer, Function/2): Box
function ic:new_inv_box(id, x, y, cols, rows, callback)
  return self:new_box(id, x, y, cols * 1.5, rows * 1.5, callback)
end

-- @spec #render(x: Number, y: Number): Rect
function ic:render(x, y)
  x = x or 0
  y = y or 0

  local x1
  local x2
  local y1
  local y2

  local rx2
  local ry2
  local rect

  local formspec = ""
  for _index, box in self.m_boxes:each() do
    rect = Rect.copy(box.rect)
    rect.x = rect.x + x
    rect.y = rect.y + y

    formspec = formspec .. box:callback(rect)

    rx2 = rect.x + rect.w
    ry2 = rect.y + rect.h

    if x1 then
      x1 = math.min(x1, rect.x)
    else
      x1 = rect.x
    end

    if y1 then
      y1 = math.min(y1, rect.y)
    else
      y1 = rect.y
    end

    if x2 then
      x2 = math.max(rx2, x2)
    else
      x2 = rx2
    end

    if y2 then
      y2 = math.max(ry2, y2)
    else
      y2 = ry2
    end
  end

  x1 = x1 or 0
  x2 = x2 or 0
  y1 = y1 or 0
  y2 = y2 or 0

  return formspec, Rect.new(x1, y1, x2 - x1, y2 - y1)
end

foundation.com.formspec.Layout = Layout
