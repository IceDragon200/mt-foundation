local Luna = assert(foundation.com.Luna)
local subject = foundation.com

local case = Luna:new("foundation.com.list_*")

case:describe("list_last/1", function (t2)
  t2:test("returns the last element in the list", function (t3)
    t3:assert_eq(nil, subject.list_last({}))
    t3:assert_eq(1, subject.list_last({1}))
    t3:assert_eq("abcdef", subject.list_last({"zyx", "abcdef"}))
    t3:assert_eq(5, subject.list_last({1, 2, 3, 4, 5}))
  end)
end)

case:describe("list_last/2", function (t2)
  t2:test("returns the last n elements in list", function (t3)
    t3:assert_table_eq({}, subject.list_last({}, 1))
    t3:assert_table_eq({1}, subject.list_last({1}, 1))
    t3:assert_table_eq({2, 3, 4}, subject.list_last({1, 2, 3, 4}, 3))
    t3:assert_table_eq({1, 2, 3, 4}, subject.list_last({1, 2, 3, 4}, 5))
  end)
end)

case:describe("list_concat/*", function (t2)
  t2:test("can concatenate multiple list-like tables together", function (t3)
    local a = {"abc", "def"}
    local b = {"other", "stuff"}
    local c = {1, 2, 3}
    local r = subject.list_concat(a, b, c)
    t3:assert_table_eq(r, {"abc", "def", "other", "stuff", 1, 2, 3})
  end)
end)

case:describe("list_sample/1", function (t2)
  t2:test("randomly select one element from a given list", function (t3)
    local items = {"a", "b", "c", "d"}
    local item = subject.list_sample(items)
    t3:assert_in(item, items)
  end)
end)

case:describe("list_get_next/2", function (t2)
  local l = {"abc", "def", "xyz", "123", "456"}

  t2:test("will return the first element given a nil element", function (t3)
    t3:assert_eq(subject.list_get_next(l, nil), "abc")
  end)

  t2:test("will return the next element given an existing element name", function (t3)
    t3:assert_eq(subject.list_get_next(l, "abc"), "def")
    t3:assert_eq(subject.list_get_next(l, "def"), "xyz")
  end)

  t2:test("will loop around the next element given an existing element name", function (t3)
    t3:assert_eq(subject.list_get_next(l, "456"), "abc")
  end)
end)

case:describe("list_crawford_base32_le_rolling_encode_table/*", function (t2)
  t2:test("can encode a list of integers as base32", function (t3)
    ---t3:assert_eq(m.list_crawford_base32_le_rolling_encode_table())
  end)
end)

case:describe("list_split/2", function (t2)
  t2:test("can split a list like table into 2 tables given the index", function (t3)
    local list = {"a", "b", "c", "d", "e", "f"}

    local a
    local b

    a, b = subject.list_split(list, 3)

    t3:assert_table_eq({"a", "b", "c"}, a)
    t3:assert_table_eq({"d", "e" ,"f"}, b)
  end)

  t2:test("can handle an empty list", function (t3)
    local list = {}

    local a
    local b

    a, b = subject.list_split(list, 3)

    t3:assert_table_eq({}, a)
    t3:assert_table_eq({}, b)
  end)

  t2:test("can handle a list where the len is the first item", function (t3)
    local list = {"a", "b", "c", "d", "e", "f"}

    local a
    local b

    a, b = subject.list_split(list, 0)

    t3:assert_table_eq({}, a)
    t3:assert_table_eq(list, b)
  end)

  t2:test("can handle a list where the len is the last item", function (t3)
    local list = {"a", "b", "c", "d", "e", "f"}

    local a
    local b

    a, b = subject.list_split(list, 6)

    t3:assert_table_eq(list, a)
    t3:assert_table_eq({}, b)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
