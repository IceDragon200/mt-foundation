-- So Luna can test itself, at least it's assertions, the exception is if the test scaffolding
-- itself is so broken that the module doesn't even run.

local Luna = assert(foundation.com.Luna)

do
  local case = Luna:new("Luna.self_test")

  case:describe("#assert/1", function (t2)
    t2:test("can assert any truthy values", function (t3)
      t3:assert("")
      t3:assert(true)
      t3:assert({})
      t3:assert(0)
    end)
  end)

  case:describe("#assert_eq/2", function (t2)
    t2:test("can compare two values and determines if they are equal", function (t3)
      t3:assert_eq(nil, nil)
      t3:assert_eq(true, true)
      t3:assert_eq(1, 1)
      t3:assert_eq("", "")
      local a = {}
      local b = {}
      t3:assert_eq(a, a)
      t3:refute_eq(a, b) -- they should not be the same, since they are different tables
    end)
  end)

  case:describe("#assert_table_eq/2", function (t2)
    t2:test("can compare two tables by their root values", function (t3)
      t3:assert_table_eq(
        {a = 1, b = 1, c = 1},
        {a = 1, b = 1, c = 1}
      )

      local c = { d = 1 }
      t3:assert_table_eq(
        {a = 1, b = 1, c = c},
        {a = 1, b = 1, c = c}
      )

      t3:refute_table_eq(
        {a = 1, b = 1, c = { d = 1 }},
        {a = 1, b = 1, c = { d = 1 }}
      )
    end)
  end)

  case:describe("#refute/1", function (t2)
    t2:test("can assert that a falsy value is false", function (t3)
      t3:refute(false)
      t3:refute(nil)
    end)
  end)

  case:describe("#refute_eq/2", function (t2)
    t2:test("can assert falsy comparisons", function (t3)
      t3:refute_eq(nil, false)
      t3:refute_eq(true, false)
      t3:refute_eq(1, 2)
      t3:refute_eq("", 0)
      t3:refute_eq({}, {}) -- they should NOT be the same, since these are two different tables
    end)
  end)

  case:execute()
  case:display_stats()
  case:maybe_error()
end
