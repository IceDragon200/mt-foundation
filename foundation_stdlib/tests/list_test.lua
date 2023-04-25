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
    t3:assert(subject.list_crawford_base32_le_rolling_encode_table(1, 255, 2, 0x0FFF))
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

case:describe("list_sort/1", function (t2)
  t2:test("can sort a given table of numbers", function (t3)
    local list = {0, 2, 1, 4, 3}

    t3:assert_table_eq(subject.list_sort(list), {0, 1, 2, 3, 4})
  end)

  t2:test("can sort a given table of random numbers", function (t3)
    local list = {}

    for i = 1,10 do
      list[i] = math.random(100)
    end

    list = subject.list_sort(list)

    local a = list[1]

    for i = 2,#list do
      local b = list[i]

      t3:assert(a <= b)

      a = b
    end
  end)

  t2:test("can sort a given table of strings", function (t3)
    local list = {"a", "c", "b", "e", "d"}

    t3:assert_table_eq(subject.list_sort(list), {"a", "b", "c", "d", "e"})
  end)
end)

case:describe("list_sort_by/2", function (t2)
  t2:test("can sort a given table of sub tables", function (t3)
    local list = {
      {
        value = 0,
        name = "A",
      },
      {
        value = 2,
        name = "B",
      },
      {
        value = 1,
        name = "C",
      },
      {
        value = 4,
        name = "D",
      },
      {
        value = 3,
        name = "E",
      }
    }

    t3:assert_deep_eq(
      subject.list_sort_by(
        list,
        function (a)
          return a.value
        end
      ),
      {
        {
          value = 0,
          name = "A"
        },
        {
          value = 1,
          name = "C"
        },
        {
          value = 2,
          name = "B"
        },
        {
          value = 3,
          name = "E"
        },
        {
          value = 4,
          name = "D"
        }
      }
    )
  end)

  t2:test("can sort a given table of random numbers", function (t3)
    local list = {}

    for i = 1,10 do
      list[i] = {
        value = math.random(100)
      }
    end

    list = subject.list_sort_by(list, function (a)
      return a.value
    end)

    local a = list[1]

    for i = 2,#list do
      local b = list[i]

      t3:assert(a.value <= b.value)

      a = b
    end
  end)

  t2:test("can sort a given table of strings", function (t3)
    local list = {
      {
        value = "a"
      },
      {
        value = "c"
      },
      {
        value = "b"
      },
      {
        value = "e"
      },
      {
        value = "d"
      }
    }

    t3:assert_deep_eq(
      subject.list_sort_by(
        list,
        function (a)
          return a.value
        end
      ),
      {
        {
          value = "a"
        },
        {
          value = "b"
        },
        {
          value = "c"
        },
        {
          value = "d"
        },
        {
          value = "e"
        }
      }
    )
  end)
end)

case:describe("list_filter/2", function (t2)
  t2:test("only includes truthy elements from callback", function (t3)
    local t = {
      1,
      2,
      3,
      4,
      5,
      6,
    }

    local new_t =
      subject.list_filter(t, function (value, _index)
        return math.fmod(value, 2) == 0
      end)

    t3:assert(subject.table_equals(
      t,
      {
        1,
        2,
        3,
        4,
        5,
        6,
      }
    ))

    t3:assert(subject.table_equals(
      new_t,
      {
        2,
        4,
        6,
      }
    ))
  end)
end)

case:describe("list_reject/2", function (t2)
  t2:test("only removes truthy elements from callback", function (t3)
    local t = {
      1,
      2,
      3,
      4,
      5,
      6,
    }

    local new_t =
      subject.list_reject(t, function (value, _index)
        return math.fmod(value, 2) == 0
      end)

    t3:assert(subject.table_equals(
      t,
      {
        1,
        2,
        3,
        4,
        5,
        6,
      }
    ))

    t3:assert(subject.table_equals(
      new_t,
      {
        1,
        3,
        5,
      }
    ))
  end)
end)

case:describe("list_find/2", function (t2)
  t2:test("can find matching pair by predicate", function (t3)
    local t = {
      1,
      2,
      3,
      4,
      5,
      6,
    }

    local value, idx = subject.list_find(t, function (v, _idx)
      return (v / 2.0) == 2.0
    end)

    t3:assert_eq(value, 4)
    t3:assert_eq(idx, 4)

    value, idx = subject.list_find(t, function (v, _idx)
      return (v / 2.0) == 4.0
    end)

    t3:refute(value)
    t3:refute(idx)
  end)

  --- Just to make sure it actually does something
  t2:test("works with string values", function (t3)
    local t = {
      "Apple",
      "Banana",
      "Cantalope",
      "Durian",
      "Elderberry",
      "Fig",
    }

    local value, idx = subject.list_find(t, function (v, _idx)
      return "Apple" == v
    end)

    t3:assert_eq(value, "Apple")
    t3:assert_eq(idx, 1)

    value, idx = subject.list_find(t, function (v, _idx)
      return "Durian" == v
    end)

    t3:assert_eq(value, "Durian")
    t3:assert_eq(idx, 4)
  end)
end)

case:describe("list_bsearch/2", function (t2)
  t2:test("can perform a binary search on an empty list", function (t3)
    local t = {}

    local res, idx = subject.list_bsearch(t, 1)

    t3:assert_eq(res, nil)
    t3:assert_eq(idx, nil)
  end)

  t2:test("can perform a binary search on a sorted list (with integers)", function (t3)
    local t = {10, 20, 30, 40, 50, 60, 70, 80, 90}

    for aidx, a in ipairs(t) do
      local b, bidx = subject.list_bsearch(t, a)

      t3:assert_eq(a, b)
      t3:assert_eq(aidx, bidx)
    end

    for _, a in ipairs({ 0, 100 }) do
      local b, bidx = subject.list_bsearch(t, a)

      t3:assert_eq(b, nil)
      t3:assert_eq(bidx, nil)
    end
  end)

  t2:test("can perform a binary search on a sorted list (with integers) of random length", function (t3)
    local t = {}

    for i = 1,math.random(20) do
      t[i] = i * 20
    end

    for aidx, a in ipairs(t) do
      local b, bidx = subject.list_bsearch(t, a)

      t3:assert_eq(a, b)
      t3:assert_eq(aidx, bidx)
    end
  end)
end)

case:describe("list_bsearch_by/2", function (t2)
  t2:test("can perform a binary search on an empty list", function (t3)
    local t = {}

    local res, idx = subject.list_bsearch_by(t, function (_a)
      return 1
    end)

    t3:assert_eq(res, nil)
    t3:assert_eq(idx, nil)
  end)

  t2:test("can perform a binary search on a sorted list", function (t3)
    local t = {10, 20, 30, 40, 50, 60, 70, 80, 90}

    for aidx, a in ipairs(t) do
      local c, cidx = subject.list_bsearch_by(t, function (b, bidx)
        if a == b then
          return 0
        elseif a > b then
          return 1
        elseif a < b then
          return -1
        end
      end)

      t3:assert_eq(a, c)
      t3:assert_eq(aidx, cidx)
    end

    for _, a in ipairs({ 0, 100 }) do
      local c, cidx = subject.list_bsearch_by(t, function (b)
        if a == b then
          return 0
        elseif a > b then
          return 1
        elseif a < b then
          return -1
        end
      end)

      t3:assert_eq(c, nil)
      t3:assert_eq(cidx, nil)
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
