local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.Vector4)

local case = Luna:new("foundation.com.Vector4")

case:describe("new/4", function (t2)
  t2:test("can create a new vector", function (t3)
    local a = subject.new(3, 6, 9, 12)

    t3:assert_table_eq({
      x = 3,
      y = 6,
      z = 9,
      w = 12,
    }, a)
  end)
end)

case:describe("copy/1", function (t2)
  t2:test("can copy an existing vector", function (t3)
    local a = subject.new(3, 6, 9, 12)
    local b = subject.copy(a)

    t3:assert_table_eq({
      x = 3,
      y = 6,
      z = 9,
      w = 12,
    }, b)
  end)
end)

case:describe("zero/0", function (t2)
  t2:test("can create a zeroed vector", function (t3)
    local a = subject.zero()

    t3:assert_table_eq({
      x = 0,
      y = 0,
      z = 0,
      w = 0,
    }, a)
  end)
end)

case:describe("equals/2", function (t2)
  t2:test("can compare two vectors", function (t3)
    local a = subject.new(3, 6, 9, 12)
    local b = subject.new(2, 4, 7, 11)
    local c = subject.new(a.x, a.y, a.z, a.w)

    t3:refute(subject.equals(a, b))
    t3:assert(subject.equals(a, c))
  end)
end)

case:describe("#-~", function (t2)
  t2:test("can negate a vector", function (t3)
    local a = subject.new(2, -4, 3, -9)

    t3:assert_table_eq({
      x = -2,
      y = 4,
      z = -3,
      w = 9,
    }, -a)
  end)
end)

case:describe("#==", function (t2)
  t2:test("can compare two vectors", function (t3)
    local a = subject.new(3, 6, 9, 12)
    local b = subject.new(2, 4, 7, 11)
    local c = subject.new(a.x, a.y, a.z, a.w)

    t3:refute(a == b)
    t3:assert(a == c)
  end)
end)

case:describe("#+", function (t2)
  t2:test("can add 2 vectors together", function (t3)
    local a = subject.new(3, 6, 9, 12)
    local b = subject.new(2, 4, 7, 11)

    local c = a + b

    t3:assert_table_eq({
      x = 5,
      y = 10,
      z = 16,
      w = 23,
    }, c)
  end)
end)

case:describe("#-", function (t2)
  t2:test("can subtract 2 vectors", function (t3)
    local a = subject.new(3, 6, 9, 12)
    local b = subject.new(2, 4, 6, 8)

    local c = a - b

    t3:assert_table_eq({
      x = 1,
      y = 2,
      z = 3,
      w = 4,
    }, c)
  end)
end)

case:describe("#*", function (t2)
  t2:test("can multiply 2 vectors", function (t3)
    local a = subject.new(3, 6, 9, 12)
    local b = subject.new(2, 4, 6, 8)

    local c = a * b

    t3:assert_table_eq({
      x = 6,
      y = 24,
      z = 54,
      w = 96,
    }, c)
  end)
end)

case:describe("#/", function (t2)
  t2:test("can divide 2 vectors", function (t3)
    local a = subject.new(6, 12, 32, 50)
    local b = subject.new(3, 4, 8, 10)

    local c = a / b

    t3:assert_table_eq({
      x = 2.0,
      y = 3.0,
      z = 4.0,
      w = 5.0,
    }, c)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
