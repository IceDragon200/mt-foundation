local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.Quaternion)

local case = Luna:new("foundation.com.Quaternion")

case:describe("is_quaternion/1", function (t2)
  t2:test("can correctly identify a Quaternion object", function (t3)
    local q = subject.unit()
    t3:assert(subject.is_quaternion(q))
  end)

  t2:test("vector4 is not a Quaternion", function (t3)
    local v4 = foundation.com.Vector4.zero()
    t3:refute(subject.is_quaternion(q))
  end)
end)

case:describe("new/4", function (t2)
  t2:test("can create a Quaternion", function (t3)
    local q1 = subject.new(4, 1, 2, 3)

    t3:assert_table_eq({
      w = 4,
      x = 1,
      y = 2,
      z = 3,
    }, q1)
  end)
end)

case:describe("copy/1", function (t2)
  t2:test("can copy a Quaternion", function (t3)
    local q1 = subject.new(4, 1, 2, 3)
    local q2 = subject.copy(q1)

    t3:assert_table_eq({
      w = 4,
      x = 1,
      y = 2,
      z = 3,
    }, q2)
  end)
end)

case:describe("multiply/3", function (t2)
  t2:test("can multiply two Quaternions", function (t3)
    local q1 = subject.new(0.50, 0.76, 0.38, 0.19)
    local q2 = subject.new(-0.312, -0.003, -0.901, 0.300)
    local q3 = subject.unit()

    local q = subject.multiply(q3, q1, q2)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
