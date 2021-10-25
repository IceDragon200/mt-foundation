local Luna = assert(foundation.com.Luna)
local m = foundation.com.Rect

local case = Luna:new("foundation.com.Rect")

case:describe("new/0", function (t2)
  t2:test("can return a zeroed rect", function (t3)
    local r = m.new()

    t3:assert_table_eq({ x = 0, y = 0, w = 0, h = 0 }, r)
  end)
end)

case:describe("new/4", function (t2)
  t2:test("can create rectangle with specified coords", function (t3)
    local r = m.new(2, 4, 22, 30)

    t3:assert_table_eq({ x = 2, y = 4, w = 22, h = 30 }, r)
  end)
end)

case:describe("new_from_vec2/2", function (t2)
  t2:test("can create a rectangle from 2 vector2s", function (t3)
    local r = m.new_from_vec2({ x = 2, y = 4 }, { x = 22, y = 30 })

    t3:assert_table_eq({ x = 2, y = 4, w = 22, h = 30 }, r)
  end)
end)

case:describe("new_from_extents/2", function (t2)
  t2:test("can create a rectangle from extends", function (t3)
    local r = m.new_from_extents({ x = 2, y = 3 }, { x = 8, y = 10 })

    t3:assert_table_eq({ x = 2, y = 3, w = 6, h = 7 }, r)
  end)
end)

case:describe("copy/1", function (t2)
  t2:test("can copy a rect", function (t3)
    local r = m.new(2, 4, 22, 30)
    local r2 = m.copy(r)

    r.x = 8

    t3:assert_table_eq({ x = 2, y = 4, w = 22, h = 30 }, r2)
  end)
end)

case:describe("position/1", function (t2)
  t2:test("returns the rect position as a vector2", function (t3)
    local r = m.new(2, 3, 7, 8)

    t3:assert_table_eq({ x = 2, y = 3 }, m.position(r))
  end)
end)

case:describe("size/1", function (t2)
  t2:test("returns the size of the rect as a vector2", function (t3)
    local r = m.new(2, 3, 7, 8)

    t3:assert_table_eq({ x = 7, y = 8 }, m.size(r))
  end)
end)

case:describe("is_empty/1", function (t2)
  t2:test("correctly determines a rect is not-empty", function (t3)
    t3:refute(m.is_empty(m.new(0, 3, 7, 8)))
    t3:refute(m.is_empty(m.new(2, 0, 7, 8)))
    t3:refute(m.is_empty(m.new(2, 3, 7, 8)))
  end)

  t2:test("correctly determines a rect is empty", function (t3)
    t3:assert(m.is_empty(m.new(2, 3, 0, 8)))
    t3:assert(m.is_empty(m.new(2, 3, 7, 0)))
  end)
end)

case:describe("contract/2", function (t2)
  t2:test("shifts the position and shrinks the size of the rect (given only 1 size)", function (t3)
    local r = m.new(3, 5, 7, 9)

    t3:assert_table_eq({ x = 4, y = 6, w = 5, h = 7 }, m.contract(r, 1))
  end)
end)

case:describe("contract/3", function (t2)
  t2:test("shifts the position and shrinks the size of the rect", function (t3)
    local r = m.new(3, 5, 7, 9)

    t3:assert_table_eq({ x = 4, y = 8, w = 5, h = 3 }, m.contract(r, 1, 3))
  end)
end)

case:describe("expand/2", function (t2)
  t2:test("shifts the position and increases the size of the rect (given only 1 size)", function (t3)
    local r = m.new(3, 5, 7, 9)

    t3:assert_table_eq({ x = 2, y = 4, w = 9, h = 11 }, m.expand(r, 1))
  end)
end)

case:describe("expand/3", function (t2)
  t2:test("shifts the position and increases the size of the rect", function (t3)
    local r = m.new(3, 5, 7, 9)

    t3:assert_table_eq({ x = 2, y = 2, w = 9, h = 15 }, m.expand(r, 1, 3))
  end)
end)

case:describe("resize/3", function (t2)
  t2:test("can change the size of a rect", function (t3)
    local r = m.new(3, 5, 7, 9)

    t3:assert_table_eq({ x = 3, y = 5, w = 10, h = 12 }, m.resize(r, 10, 12))
  end)
end)

case:describe("move/3", function (t2)
  t2:test("can change the position of a rect", function (t3)
    local r = m.new(3, 5, 7, 9)

    t3:assert_table_eq({ x = 4, y = 6, w = 7, h = 9 }, m.move(r, 4, 6))
  end)
end)

case:describe("translate/3", function (t2)
  t2:test("can move a rectangle relative to its position", function (t3)
    local r = m.new(3, 5, 8, 9)

    t3:assert_table_eq({ x = 4, y = 7, w = 8, h = 9 }, m.translate(r, 1, 2))
  end)
end)

case:describe("floor/1", function (t2)
  t2:test("rounds all components of a rect using floor method", function (t3)
    local r = m.new(3.4, 5.7, 8.9, 9.1)

    t3:assert_table_eq({ x = 3, y = 5, w = 8, h = 9 }, m.floor(r))
  end)
end)

case:describe("ceil/1", function (t2)
  t2:test("rounds all components of a rect using ceil method", function (t3)
    local r = m.new(3.4, 5.7, 8.9, 9.1)

    t3:assert_table_eq({ x = 4, y = 6, w = 9, h = 10 }, m.ceil(r))
  end)
end)

case:describe("round/1", function (t2)
  t2:test("rounds all components of a rect", function (t3)
    local r = m.new(3.4, 5.7, 8.9, 10.1)

    t3:assert_table_eq({ x = 3, y = 6, w = 9, h = 10 }, m.round(r))
  end)
end)

case:describe("align/4", function (t2)
  t2:test("can align given rect to a container", function (t3)
    local container = m.new(2, 3, 20, 24)
    local child = m.new(4, 5, 7, 6)

    local x_m1 = 2
    local x_0 = 8.5
    local x_p1 = 15

    local y_m1 = 3
    local y_0 = 12
    local y_p1 = 21

    -- no effect
    t3:assert_table_eq({ x = 4, y = 5, w = 7, h = 6 }, m.align(child, nil, nil, container))

    -- x-coord -1
    t3:assert_table_eq({ x = x_m1, y = 5, w = 7, h = 6 }, m.align(child, -1, nil, container))

    -- x-coord 0
    t3:assert_table_eq({ x = x_0, y = 5, w = 7, h = 6 }, m.align(child, 0, nil, container))

    -- x-coord 1
    t3:assert_table_eq({ x = x_p1, y = 5, w = 7, h = 6 }, m.align(child, 1, nil, container))

    -- y-coord -1
    t3:assert_table_eq({ x = x_p1, y = y_m1, w = 7, h = 6 }, m.align(child, nil, -1, container))

    -- y-coord 0
    t3:assert_table_eq({ x = x_p1, y = y_0, w = 7, h = 6 }, m.align(child, nil, 0, container))

    -- y-coord 1
    t3:assert_table_eq({ x = x_p1, y = y_p1, w = 7, h = 6 }, m.align(child, nil, 1, container))

    for y_align, y in pairs({ [-1] = y_m1, [0] = y_0, [1] = y_p1 }) do
      for x_align, x in pairs({ [-1] = x_m1, [0] = x_0, [1] = x_p1 }) do
        t3:assert_table_eq({ x = x, y = y, w = 7, h = 6 }, m.align(child, x_align, y_align, container))
      end
    end
  end)
end)

case:describe("subdivide/3", function (t2)
  t2:test("can subdivide a rectangle by x subdivisions", function (t3)
    local r = m.new(2, 4, 32, 20)
    local result = m.subdivide(r, 4, nil)

    t3:assert_deep_eq(
      {
        {
          x = 2,
          y = 4,
          w = 8,
          h = 20,
        },
        {
          x = 10,
          y = 4,
          w = 8,
          h = 20,
        },
        {
          x = 18,
          y = 4,
          w = 8,
          h = 20,
        },
        {
          x = 26,
          y = 4,
          w = 8,
          h = 20,
        },
      },
      result
    )
  end)

  t2:test("can subdivide a rectangle by y subdivisions", function (t3)
    local r = m.new(2, 4, 32, 40)
    local result = m.subdivide(r, nil, 4)

    t3:assert_deep_eq(
      {
        {
          x = 2,
          y = 4,
          w = 32,
          h = 10,
        },
        {
          x = 2,
          y = 14,
          w = 32,
          h = 10,
        },
        {
          x = 2,
          y = 24,
          w = 32,
          h = 10,
        },
        {
          x = 2,
          y = 34,
          w = 32,
          h = 10,
        },
      },
      result
    )
  end)

  t2:test("can subdivide a rectangle by both x and y subdivisions", function (t3)
    local r = m.new(2, 4, 32, 30)

    local result = m.subdivide(r, 2, 3)

    t3:assert_deep_eq(
      {
        {
          x = 2,
          y = 4,
          w = 16,
          h = 10,
        },
        {
          x = 18,
          y = 4,
          w = 16,
          h = 10,
        },

        {
          x = 2,
          y = 14,
          w = 16,
          h = 10,
        },
        {
          x = 18,
          y = 14,
          w = 16,
          h = 10,
        },

        {
          x = 2,
          y = 24,
          w = 16,
          h = 10,
        },
        {
          x = 18,
          y = 24,
          w = 16,
          h = 10,
        },
      },
      result
    )
  end)
end)

case:describe("slice/3", function (t2)
  t2:test("can slice a rect by a x-coord", function (t3)
    local r = m.new(3, 4, 20, 14)

    t3:assert_deep_eq(
      {
        {
          x = 3,
          y = 4,
          w = 15,
          h = 14,
        },
        {
          x = 18,
          y = 4,
          w = 5,
          h = 14,
        },
      },
      m.slice(r, 15, nil)
    )
  end)

  t2:test("can slice a rect by a y-coord", function (t3)
    local r = m.new(3, 4, 20, 14)

    t3:assert_deep_eq(
      {
        {
          x = 3,
          y = 4,
          w = 20,
          h = 8,
        },
        {
          x = 3,
          y = 12,
          w = 20,
          h = 6,
        },
      },
      m.slice(r, nil, 8)
    )
  end)

  t2:test("can slice a rect by x and y coords", function (t3)
    local r = m.new(3, 4, 20, 14)

    t3:assert_deep_eq(
      {
        {
          x = 3,
          y = 4,
          w = 15,
          h = 8,
        },
        {
          x = 18,
          y = 4,
          w = 5,
          h = 8,
        },
        {
          x = 3,
          y = 12,
          w = 15,
          h = 6,
        },
        {
          x = 18,
          y = 12,
          w = 5,
          h = 6,
        },
      },
      m.slice(r, 15, 8)
    )
  end)
end)

case:describe("contains/2", function (t2)
  t2:test("can determine if a rect fits in another rect", function (t3)
    local parent = m.new(2, 3, 20, 15)
    local child = m.new(3, 4, 5, 10)

    t3:assert(m.contains(parent, child))
  end)

  t2:test("will report false if the child is completely outside the parent", function (t3)
    local parent = m.new(2, 3, 20, 15)
    local child1 = m.new(22, 4, 5, 10)
    local child2 = m.new(2, 16, 5, 10)

    t3:refute(m.contains(parent, child1))
    t3:refute(m.contains(parent, child2))
  end)

  t2:test("will report false if the other rect interects but doesn't completely fit in the parent", function (t3)
    local parent = m.new(2, 3, 20, 15)

    local child0 = m.new(1, 2, 22, 17) -- expanded
    local child1 = m.new(3, 4, 5, 15) -- h overflow
    local child2 = m.new(3, 4, 20, 10) -- w overflow
    local child3 = m.new(2, 2, 5, 12) -- y underflow
    local child4 = m.new(1, 3, 5, 12) -- x underflow

    t3:refute(m.contains(parent, child0))
    t3:refute(m.contains(parent, child1))
    t3:refute(m.contains(parent, child2))
    t3:refute(m.contains(parent, child3))
    t3:refute(m.contains(parent, child4))
  end)
end)

case:describe("intersects/2", function (t2)
  t2:test("can determine if a rect fits in another rect", function (t3)
    local parent = m.new(2, 3, 20, 15)
    local child = m.new(3, 4, 5, 10)

    t3:assert(m.intersects(parent, child))
  end)

  t2:test("will report false if the child is completely outside the parent", function (t3)
    local parent = m.new(2, 3, 20, 15)
    local child1 = m.new(23, 4, 5, 10)
    local child2 = m.new(2, 19, 5, 10)

    t3:refute(m.intersects(parent, child1))
    t3:refute(m.intersects(parent, child2))
  end)

  t2:test("will report true if the other rect overlaps but doesn't completely fit in the parent", function (t3)
    local parent = m.new(2, 3, 20, 15)

    local child0 = m.new(1, 2, 22, 17) -- expanded
    local child1 = m.new(3, 4, 5, 15) -- h overflow
    local child2 = m.new(3, 4, 20, 10) -- w overflow
    local child3 = m.new(2, 2, 5, 12) -- y underflow
    local child4 = m.new(1, 3, 5, 12) -- x underflow

    t3:assert(m.intersects(parent, child0))
    t3:assert(m.intersects(parent, child1))
    t3:assert(m.intersects(parent, child2))
    t3:assert(m.intersects(parent, child3))
    t3:assert(m.intersects(parent, child4))
  end)
end)

case:describe("merge/1+", function (t2)
  t2:test("can merge multiple rectangles together to form one encompassing one", function (t3)
    local r1 = m.new(2, 3, 20, 15)
    local r2 = m.new(15, 12, 16, 8)

    t3:assert_table_eq({ x = 2, y = 3, w = 29, h = 17 }, m.merge(r1, r2))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
