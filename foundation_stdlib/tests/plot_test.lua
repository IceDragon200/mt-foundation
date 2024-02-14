local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.plot_*")

case:describe("plot_line2_inline/5", function (t2)
  t2:test("can plot a 2-dimensional line (+x, +y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, 5, 5, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = 1 },
      { x = 2, y = 2 },
      { x = 3, y = 3 },
      { x = 4, y = 4 },
      { x = 5, y = 5 },
    }, result)
  end)

  t2:test("can plot a 2-dimensional line (+x, =y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, 5, 0, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = 0 },
      { x = 2, y = 0 },
      { x = 3, y = 0 },
      { x = 4, y = 0 },
      { x = 5, y = 0 },
    }, result)
  end)

  t2:test("can plot a 2-dimensional line (=x, +y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, 0, 5, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 0, y = 1 },
      { x = 0, y = 2 },
      { x = 0, y = 3 },
      { x = 0, y = 4 },
      { x = 0, y = 5 },
    }, result)
  end)

  t2:test("can plot a 2-dimensional line (-x, +y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, -5, 5, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = -1, y = 1 },
      { x = -2, y = 2 },
      { x = -3, y = 3 },
      { x = -4, y = 4 },
      { x = -5, y = 5 },
    }, result)
  end)

  t2:test("can plot a 2-dimensional line (+x, -y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, 5, -5, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = -1 },
      { x = 2, y = -2 },
      { x = 3, y = -3 },
      { x = 4, y = -4 },
      { x = 5, y = -5 },
    }, result)
  end)

  t2:test("can plot a 2-dimensional line (-x, -y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, -5, -5, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = -1, y = -1 },
      { x = -2, y = -2 },
      { x = -3, y = -3 },
      { x = -4, y = -4 },
      { x = -5, y = -5 },
    }, result)
  end)

  t2:test("can plot a 2-dimensional line (++x, +y)", function (t3)
    local result = {}
    m.plot_line2(0, 0, 5, 1, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = 0 },
      { x = 2, y = 0 },
      { x = 3, y = 1 },
      { x = 4, y = 1 },
      { x = 5, y = 1 },
    }, result)
  end)
end)

case:describe("plot_line2_iter/5", function (t2)
  t2:test("can plot a 2-dimensional line (+x, +y)", function (t3)
    local result = {}
    local iter = m.plot_line2(0, 0, 5, 5)

    local has_more, x, y
    has_more = true
    while has_more do
      has_more, x, y = iter()
      table.insert(result, {x = x, y = y})
    end

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = 1 },
      { x = 2, y = 2 },
      { x = 3, y = 3 },
      { x = 4, y = 4 },
      { x = 5, y = 5 },
    }, result)
  end)
end)

case:describe("plot_line3_inline/7", function (t2)
  t2:test("can plot a 3-dimensional line (+x, +y, +z)", function (t3)
    local result = {}
    m.plot_line3(0, 0, 0, 5, 5, 5, function (x, y, z)
      table.insert(result, {x = x, y = y, z = z})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 1, z = 1 },
      { x = 2, y = 2, z = 2 },
      { x = 3, y = 3, z = 3 },
      { x = 4, y = 4, z = 4 },
      { x = 5, y = 5, z = 5 },
    }, result)
  end)
end)

case:describe("plot_line3_iter/6", function (t2)
  t2:test("can plot a 3-dimensional line (+x, +y, +z)", function (t3)
    local result = {}
    local iter = m.plot_line3(0, 0, 0, 5, 5, 5)

    local has_more, x, y, z
    has_more = true
    while has_more do
      has_more, x, y, z = iter()
      table.insert(result, {x = x, y = y, z = z})
    end

    t3:assert_deep_eq({
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 1, z = 1 },
      { x = 2, y = 2, z = 2 },
      { x = 3, y = 3, z = 3 },
      { x = 4, y = 4, z = 4 },
      { x = 5, y = 5, z = 5 },
    }, result)
  end)
end)

case:describe("walk_ortho2_inline/5", function (t2)
  t2:test("can walk to a 2-dimensional point orthogonally (+x, +y)", function (t3)
    local result = {}
    m.walk_ortho2(0, 0, 4, 3, function (x, y)
      table.insert(result, {x = x, y = y})
    end)

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = 0 },
      { x = 1, y = 1 },
      { x = 2, y = 1 },
      { x = 2, y = 2 },
      { x = 3, y = 2 },
      { x = 3, y = 3 },
      { x = 4, y = 3 },
    }, result)
  end)
end)

case:describe("walk_ortho2_iter/5", function (t2)
  t2:test("can walk to a 2-dimensional point orthogonally (+x, +y)", function (t3)
    local result = {}
    local iter = m.walk_ortho2(0, 0, 4, 3)

    local has_more, x, y
    has_more = true

    while has_more do
      has_more, x, y = iter()
      table.insert(result, {x = x, y = y})
    end

    t3:assert_deep_eq({
      { x = 0, y = 0 },
      { x = 1, y = 0 },
      { x = 1, y = 1 },
      { x = 2, y = 1 },
      { x = 2, y = 2 },
      { x = 3, y = 2 },
      { x = 3, y = 3 },
      { x = 4, y = 3 },
    }, result)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
