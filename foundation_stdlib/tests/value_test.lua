local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.value")

case:describe("is_blank/1", function (t2)
  t2:test("nil is blank", function (t3)
    t3:assert(m.is_blank(nil))
  end)

  t2:test("an empty string is blank", function (t3)
    t3:assert(m.is_blank(""))
  end)

  t2:test("a string with only whitespaces is not blank, though it should be", function (t3)
    t3:refute(m.is_blank(" "))
    t3:refute(m.is_blank("    "))
  end)

  t2:test("booleans are not blank", function (t3)
    t3:refute(m.is_blank(false))
    t3:refute(m.is_blank(true))
  end)
end)

case:describe("deep_equals/2", function (t2)
  t2:test("can compare 2 scalar values", function (t3)
    t3:assert(m.deep_equals(0, 0))
    t3:assert(m.deep_equals(12.747, 12.747))
    t3:assert(m.deep_equals("", ""))
    t3:assert(m.deep_equals("Hello", "Hello"))
    t3:assert(m.deep_equals(true, true))

    t3:refute(m.deep_equals(0, 1))
    t3:refute(m.deep_equals(365.334, 7742.486))
    t3:refute(m.deep_equals("", "String"))
    t3:refute(m.deep_equals("Value", "Other"))
    t3:refute(m.deep_equals(true, false))
  end)

  t2:test("will report false for mismatched types", function (t3)
    t3:refute(m.deep_equals(0, "0"))
    t3:refute(m.deep_equals(false, "0"))
    t3:refute(m.deep_equals(false, 0))
  end)

  t2:test("can compare tables (flat)", function (t3)
    t3:assert(m.deep_equals({}, {}))
    t3:assert(m.deep_equals({1}, {1}))
    t3:assert(m.deep_equals({"Hello", "World"}, {"Hello", "World"}))

    t3:refute(m.deep_equals({}, {data = 1}))
    t3:refute(m.deep_equals({1}, {2}))
    t3:refute(m.deep_equals({"Hello", "World"}, {"Hello", "Universe"}))
  end)

  t2:test("can compare nested tables", function (t3)
    t3:assert(m.deep_equals({a = {b = 2}}, {a = {b = 2}}))
    t3:refute(m.deep_equals({a = {b = 2}}, {a = {b = 3}}))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
