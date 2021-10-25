local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.table")

case:describe("table_concat/1+", function (t2)
  t2:test("can concatenate several array-like tables together", function (t3)
    local t1 = {1, 2, 3}
    local t2 = {"a", "b", "c"}

    t3:assert_table_eq({1, 2, 3, "a", "b", "c"}, m.table_concat(t1, t2))
  end)
end)

case:describe("table_take/2", function (t2)
  t2:test("can pick out pairs from a table by keys", function (t3)
    local t1 = {
      name = "John Doe",
      age = 1000,
      address = "Somewhere",
      state = "FL",
    }

    t3:assert_table_eq(
      {
        name = "John Doe",
        age = 1000,
      },
      m.table_take(t1, { "name", "age" })
    )
  end)
end)

case:describe("table_drop/2", function (t2)
  t2:test("can drop a list of keys from a table", function (t3)
    local t1 = {
      name = "John Doe",
      age = 1000,
      address = "Somewhere",
      state = "FL",
    }

    t3:assert_table_eq(
      {
        name = "John Doe",
        age = 1000,
      },
      m.table_drop(t1, { "address", "state" })
    )
  end)
end)

case:describe("table_key_of/2", function (t2)
  t2:test("can lookup a key given only the value", function (t3)
    local t1 = {
      name = "John Doe",
      age = 1000,
      address = "Somewhere",
      state = "FL",
    }

    t3:assert_table_eq(
      {
        name = "John Doe",
        age = 1000,
      },
      m.table_drop(t1, { "address", "state" })
    )
  end)
end)

case:describe("table_merge/1+", function (t2)
  t2:test("can merge multiple tables together", function (t3)
    local t1  = {
      name = "John Doe",
      age = 1000,
    }

    local t2 = {
      address = "Somewhere",
      state = "FL",
    }

    t3:assert_table_eq(
      {
        name = "John Doe",
        age = 1000,
        address = "Somewhere",
        state = "FL",
      },
      m.table_merge(t1, t2)
    )
  end)
end)

case:describe("table_copy/1", function (t2)
  t2:test("can shallow copy a table", function (t3)
    local t1 = {
      name = "John Doe",
      age = 1000,
      address = "Somewhere",
      state = "FL",
    }

    local t2 = m.table_copy(t1)

    t3:refute_eq(t2, t1)
    t3:assert_table_eq(t2, t1)
  end)
end)

case:describe("table_equals/2", function (t2)
  t2:test("compares 2 tables and determines if they're equal", function (t3)
    t3:assert(m.table_equals({a = 1}, {a = 1}))
    t3:refute(m.table_equals({a = 1}, {a = 1, b = 2}))
    t3:refute(m.table_equals({a = 1}, {a = 2}))
    t3:refute(m.table_equals({a = 1}, {b = 1}))
  end)
end)

case:describe("table_intersperse/2", function (t2)
  t2:test("will add spacer item between elements in table", function (t3)
    local t = {"a", "b", "c", "d", "e"}
    local r = m.table_intersperse(t, ",")

    t3:assert_table_eq(r, {"a", ",", "b", ",", "c", ",", "d", ",", "e"})
  end)

  t2:test("will return an empty table given an empty table", function (t3)
    local t = {}
    local r = m.table_intersperse({}, ",")
    t3:assert_table_eq(r, {})
  end)
end)

case:describe("table_bury/3", function (t2)
  t2:test("deeply place value into map", function (t3)
    local t = {}

    -- a single key
    m.table_bury(t, {"a"}, 1)

    t3:assert_eq(t["a"], 1)

    m.table_bury(t, {"b", "c"}, 2)
    t3:assert(t["b"])
    t3:assert_eq(t["b"]["c"], 2)
  end)
end)

case:describe("is_table_empty/1", function (t2)
  t2:test("returns true if a table is empty", function (t3)
    t3:assert(m.is_table_empty({}))
    t3:assert(m.is_table_empty({a = nil, b = nil, c = nil}))
  end)

  t2:test("returns false if table contains any pairs", function (t3)
    t3:refute(m.is_table_empty({a = 1}))
    t3:refute(m.is_table_empty({b = 1, c = nil}))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
