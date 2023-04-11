local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.Vector2)

local case = Luna:new("foundation.com.Vector2")

case:describe(".new", function (t2)
  t2:test("can create a new vector", function (t3)
    local a = subject.new(3, 6)

    t3:assert_table_eq({
      x = 3,
      y = 6,
    }, a)
  end)
end)

case:describe(".copy", function (t2)
  t2:test("can copy an existing vector", function (t3)
    local a = subject.new(3, 6)
    local b = subject.copy(a)

    t3:assert_table_eq({
      x = 3,
      y = 6,
    }, b)
  end)
end)

case:describe(".zero", function (t2)
  t2:test("can create a zeroed vector", function (t3)
    local a = subject.zero()

    t3:assert_table_eq({
      x = 0,
      y = 0,
    }, a)
  end)
end)

case:describe("#-~", function (t2)
  t2:test("can negate a vector", function (t3)
    local a = subject.new(2, -4)

    t3:assert_table_eq({
      x = -2,
      y = 4,
    }, -a)
  end)
end)

case:describe("#==", function (t2)
  t2:test("can compare two vectors", function (t3)
    local a = subject.new(3, 6)
    local b = subject.new(2, 4)
    local c = subject.new(a.x, a.y)

    t3:refute(a == b)
    t3:assert(a == c)
  end)
end)

case:describe("#+", function (t2)
  t2:test("can add 2 vectors together", function (t3)
    local a = subject.new(3, 6)
    local b = subject.new(2, 4)

    local c = a + b

    t3:assert_table_eq({
      x = 5,
      y = 10,
    }, c)
  end)
end)

case:describe("#-", function (t2)
  t2:test("can subtract 2 vectors", function (t3)
    local a = subject.new(3, 6)
    local b = subject.new(2, 4)

    local c = a - b

    t3:assert_table_eq({
      x = 1,
      y = 2,
    }, c)
  end)
end)

case:describe("#*", function (t2)
  t2:test("can multiply 2 vectors", function (t3)
    local a = subject.new(3, 6)
    local b = subject.new(2, 4)

    local c = a * b

    t3:assert_table_eq({
      x = 6,
      y = 24,
    }, c)
  end)
end)

case:describe("#/", function (t2)
  t2:test("can divide 2 vectors", function (t3)
    local a = subject.new(6, 12)
    local b = subject.new(3, 4)

    local c = a / b

    t3:assert_table_eq({
      x = 2.0,
      y = 3.0,
    }, c)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
