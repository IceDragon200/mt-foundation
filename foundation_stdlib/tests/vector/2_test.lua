local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.Vector2)

local case = Luna:new("foundation.com.Vector2")

case:describe(".new/2", function (t2)
  t2:test("can create a new vector", function (t3)
    local a = subject.new(3, 6)

    t3:assert_table_eq({
      x = 3,
      y = 6,
    }, a)
  end)
end)

case:describe(".copy/1", function (t2)
  t2:test("can copy an existing vector", function (t3)
    local a = subject.new(3, 6)
    local b = subject.copy(a)

    t3:assert_table_eq({
      x = 3,
      y = 6,
    }, b)
  end)
end)

case:describe("#copy/0", function (t2)
  t2:test("can copy the current vector instance", function (t3)
    local a = subject.new(3, 6)
    local b = a:copy()

    t3:assert_table_eq({
      x = 3,
      y = 6,
    }, b)
  end)
end)

case:describe(".zero/0", function (t2)
  t2:test("can create a zeroed vector", function (t3)
    local a = subject.zero()

    t3:assert_table_eq({
      x = 0,
      y = 0,
    }, a)
  end)
end)

case:describe(".equals", function (t2)
  t2:test("can compare two vectors", function (t3)
    local a = subject.new(3, 6)
    local b = subject.new(2, 4)
    local c = subject.new(a.x, a.y)

    t3:refute(subject.equals(a, b))
    t3:assert(subject.equals(a, c))
  end)
end)

case:describe(".round/2", function (t2)
  t2:test("can round a vector to nearest integral", function (t3)
    local a = subject.new(12.8222, 13.5)
    local b = subject.round({}, a)

    t3:assert_table_eq({
      x = 13,
      y = 14,
    }, b)
  end)
end)

case:describe(".round/3", function (t2)
  t2:test("can round a vector to specified decimal places", function (t3)
    local a = subject.new(12.8222, 13.5)
    local b = subject.round({}, a, 2)

    t3:assert_table_eq({
      x = 12.82,
      y = 13.5,
    }, b)
  end)
end)

case:describe(".slerp/4", function (t2)
  t2:test("slerp two vectors", function (t3)
    local a = subject.new(0, 1)
    local b = subject.new(1, 0)

    local c = {}
    c = subject.slerp(c, a, b, 0)
    t3:assert_table_eq({
      x = 0,
      y = 1,
    }, c)

    c = subject.slerp(c, a, b, 0.5)
    t3:assert_table_eq({
      x = 0.7,
      y = 0.7,
    }, subject.round(c, c, 2))

    c = subject.slerp(c, a, b, 1)
    t3:assert_table_eq({
      x = 1.0,
      y = 0.0,
    }, subject.round(c, c, 2))
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
