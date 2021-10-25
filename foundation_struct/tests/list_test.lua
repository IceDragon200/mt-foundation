local m = foundation.com.List
local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.List")

case:describe("&new/0", function (t2)
  t2:test("can initialize a new list with no arguments", function (t3)
    local list = m:new()
    t3:assert(list)
  end)
end)

case:describe("&new/1", function (t2)
  -- POLT = plain old lua table
  t2:test("can initialize a list from a POLT", function (t3)
    local list = m:new({1, '2', 'c'})
    t3:assert_eq(1, list:get(1))
    t3:assert_eq('2', list:get(2))
    t3:assert_eq('c', list:get(3))
    t3:assert_eq(3, list:size())
  end)

  t2:test("can initialize a list from another list", function (t3)
    local a = m:new({1, '2', 'c'})
    local list = m:new(a)

    -- check data
    t3:assert_eq(1, list:get(1))
    t3:assert_eq('2', list:get(2))
    t3:assert_eq('c', list:get(3))
    t3:assert_eq(3, list:size())

    -- try replacing the first element
    t3:assert(list:put_at(1, 12))

    -- ensure that the original list is unaffected
    t3:assert_eq(1, a:get(1))

    -- check that the change actually took place
    t3:assert_eq(12, list:get(1))
  end)
end)

case:describe("#equals/1", function (t2)
  t2:test("can compare list and any other value", function (t3)
    local list = m:new()

    t3:refute(list:equals(false))
    t3:refute(list:equals(true))
    t3:refute(list:equals(nil))
    t3:refute(list:equals(1))
    t3:refute(list:equals("abc"))
    t3:refute(list:equals({}))
  end)

  t2:test("can compare against another list", function (t3)
    local a = m:new()
    local b = m:new()
    local c = m:new({ 1, 2, 3 })

    t3:assert(a:equals(a))
    t3:assert(a:equals(b))
    t3:assert(c:equals(c))
    t3:refute(a:equals(c))
    t3:refute(c:equals(b))
  end)
end)

case:describe("#copy/0", function (t2)
  t2:test("can copy a list", function (t3)
    local list = m:new({ "a", "b", "c" })
    local other = list:copy()

    t3:assert(other:equals(list))
  end)
end)

case:describe("#data/0", function (t2)
  t2:test("can retrieve underlying table", function (t3)
    local list = m:new({ "a", "b", "c" })
    local tab = list:data()

    t3:assert_table_eq({ "a", "b", "c" }, tab)
  end)
end)

case:describe("#to_table/0", function (t2)
  t2:test("can retrieve underlying table", function (t3)
    local list = m:new({ "a", "b", "c" })
    local tab = list:to_table()

    t3:assert_table_eq({ "a", "b", "c" }, tab)
  end)
end)

case:describe("#push/1", function (t2)
  t2:test("can push a value unto the list", function (t3)
    local list = m:new()
    t3:assert_eq(0, list:size())

    list:push(true)
    t3:assert_eq(1, list:size())
    t3:assert_eq(true, list:last())

    list:push(1)
    t3:assert_eq(2, list:size())
    t3:assert_eq(1, list:last())
  end)
end)

case:describe("#reverse/0", function (t2)
  t2:test("can reverse an empty list", function (t3)
    local list = m:new()

    list:reverse()

    t3:assert_eq(0, list:size())
  end)

  t2:test("can reverse a single element list", function (t3)
    local list = m:new({ 1 })

    list:reverse()

    t3:assert_eq(1, list:size())

    t3:assert_table_eq({ 1 }, list:data())
  end)

  t2:test("can reverse an even length list", function (t3)
    local list = m:new({ "a", "b", "c", "d", "e", "f" })

    list:reverse()

    t3:assert_eq(6, list:size())

    t3:assert_table_eq({ "f", "e", "d", "c", "b", "a" }, list:data())
  end)

  t2:test("can reverse an odd length list", function (t3)
    local list = m:new({ "a", "b", "c", "d", "e", "f", "g" })

    list:reverse()

    t3:assert_eq(7, list:size())

    t3:assert_table_eq({ "g", "f", "e", "d", "c", "b", "a" }, list:data())
  end)
end)

case:describe("#push/1+", function (t2)
  t2:test("can push multiple values unto the list", function (t3)
    local list = m:new()
    t3:assert_eq(0, list:size())

    list:push(true, 1, "a")
    t3:assert_eq(3, list:size())
    t3:assert_eq("a", list:last())
    t3:assert_table_eq({true, 1, "a"}, list:data())
  end)
end)

case:describe("#concat/1", function (t2)
  t2:test("can concatentate with an empty lists", function (t3)
    local a = m:new()
    local b = m:new()

    a:concat(b)

    t3:assert_eq(0, a:size())
  end)

  t2:test("can concatentate a list with items into an empty list", function (t3)
    local a = m:new()
    local b = m:new({ "a", "b", "c" })

    a:concat(b)
    t3:assert_eq(3, a:size())
    t3:assert_table_eq({"a", "b", "c"}, a:data())
  end)

  t2:test("can concatentate a list with items into another list with items", function (t3)
    local a = m:new({ 1, 2, 3 })
    local b = m:new({ "a", "b", "c" })

    a:concat(b)

    t3:assert_eq(6, a:size())
    t3:assert_table_eq({1, 2, 3, "a", "b", "c"}, a:data())
  end)
end)

case:describe("#shift/0", function (t2)
  t2:test("can pop the last item on a list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_eq("a", list:shift())
    t3:assert_eq(2, list:size())
    t3:assert_eq("b", list:shift())
    t3:assert_eq(1, list:size())
    t3:assert_eq("c", list:shift())
    t3:assert_eq(0, list:size())
    t3:assert_eq(nil, list:shift())
    t3:assert_eq(0, list:size())
  end)
end)

case:describe("#shift/1", function (t2)
  t2:test("can shift a list of items off the list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"a", "b"}, list:shift(2))
    t3:assert_eq(1, list:size())
    t3:assert_eq("c", list:first())
    t3:assert_eq("c", list:last())
  end)

  t2:test("can adjust shift if length", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"a", "b", "c"}, list:shift(4))
    t3:assert_eq(0, list:size())
    t3:assert_eq(nil, list:first())
  end)
end)

case:describe("#pop/0", function (t2)
  t2:test("can pop the last item on a list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_eq("c", list:pop())
    t3:assert_eq(2, list:size())
    t3:assert_eq("b", list:last())
    t3:assert_eq("b", list:pop())
    t3:assert_eq(1, list:size())
    t3:assert_eq("a", list:pop())
    t3:assert_eq(0, list:size())
    t3:assert_eq(nil, list:pop())
    t3:assert_eq(0, list:size())
  end)
end)

case:describe("#pop/1", function (t2)
  t2:test("can pop a list of items off the list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"b", "c"}, list:pop(2))
    t3:assert_eq(1, list:size())
    t3:assert_eq("a", list:last())
  end)
end)

case:describe("#pop_at/1", function (t2)
  t2:test("can pop an item at specified position", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_eq("b", list:pop_at(2))
    t3:assert_eq(2, list:size())
    t3:assert_eq("c", list:last())
    t3:assert_table_eq({"a", "c"}, list:data())
  end)
end)

case:describe("#delete_at/1", function (t2)
  t2:test("can delete an item at specified position", function (t3)
    local list = m:new({ "a", "b", "c" })

    list:delete_at(2)
    t3:assert_eq(2, list:size())
    t3:assert_eq("c", list:last())
    t3:assert_table_eq({"a", "c"}, list:data())
  end)
end)

case:describe("#put_at/2", function (t2)
  t2:test("can place a value in the list that is within range", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert(list:put_at(2, "X"))
    t3:assert_eq(3, list:size())
    t3:assert_eq("c", list:last())
    t3:assert_table_eq({"a", "X", "c"}, list:data())
  end)

  t2:test("cannot place a value outside of the list's size", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:refute(list:put_at(0, "X"))
    t3:refute(list:put_at(4, "X"))

    t3:assert_eq(3, list:size())
    t3:assert_eq("c", list:last())
    t3:assert_table_eq({"a", "b", "c"}, list:data())
  end)

  t2:test("cannot place values in an empty list", function (t3)
    local list = m:new()

    t3:refute(list:put_at(1, "X"))

    t3:assert_eq(0, list:size())
  end)
end)

case:describe("#get/1", function (t2)
  t2:test("can retrieve a value in the list given the position", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_eq(nil, list:get(0))
    t3:assert_eq("a", list:get(1))
    t3:assert_eq("b", list:get(2))
    t3:assert_eq("c", list:get(3))
    t3:assert_eq(nil, list:get(4))
  end)

  t2:test("will return nil if the list is empty", function (t3)
    local list = m:new()

    t3:assert_eq(nil, list:get(0))
  end)
end)

case:describe("#first/0", function (t2)
  t2:test("can return the first element in the list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_eq("a", list:first())
    t3:assert_eq(3, list:size())
  end)

  t2:test("will return nil if the list is empty", function (t3)
    local list = m:new()

    t3:assert_eq(nil, list:first())
    t3:assert_eq(0, list:size())
  end)
end)

case:describe("#first/1", function (t2)
  t2:test("can return the first element in the list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"a", "b"}, list:first(2))
    t3:assert_eq(3, list:size())
  end)

  t2:test("can handle overflowing length", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"a", "b", "c"}, list:first(4))
  end)
end)

case:describe("#last/0", function (t2)
  t2:test("can return the last element in the list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_eq("c", list:last())
  end)

  t2:test("will return nil if the list is empty", function (t3)
    local list = m:new()

    t3:assert_eq(nil, list:last())
  end)
end)

case:describe("#last/1", function (t2)
  t2:test("can return the last element in the list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"c"}, list:last(1))
    t3:assert_table_eq({"b", "c"}, list:last(2))
    t3:assert_eq(3, list:size())
  end)

  t2:test("can handle overflowing length", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_table_eq({"a", "b", "c"}, list:last(4))
  end)
end)

case:describe("#sample/0", function (t2)
  t2:test("can randomly return an element in list", function (t3)
    local list = m:new({ "a", "b", "c" })

    for _ = 1,3 do
      t3:assert_in(list:sample(), {"a", "b", "c"})
    end

    t3:assert_eq(3, list:size())
  end)
end)

case:describe("#pop_sample/0", function (t2)
  t2:test("can randomly pop an element in list", function (t3)
    local list = m:new({ "a", "b", "c" })

    t3:assert_in(list:pop_sample(), {"a", "b", "c"})

    t3:assert_eq(2, list:size())
  end)
end)

case:describe("#reduce/2", function (t2)
  t2:test("can iterate an empty list", function (t3)
    local list = m:new()

    local result = list:reduce(0, function (_item, _index, acc)
      return acc
    end)

    t3:assert_eq(0, result)
  end)

  t2:test("can iterate a list with items", function (t3)
    local list = m:new({ 1, 2, 3 })

    local result = list:reduce(0, function (item, _index, acc)
      return acc + item
    end)

    t3:assert_eq(6, result)
  end)
end)

case:describe("#each/1", function (t2)
  t2:test("can iterate an empty list", function (t3)
    local list = m:new()

    local touched = false
    local result = list:each(function (item, _index)
      touched = true
    end)

    t3:refute(touched)
  end)

  t2:test("can iterate over a list", function (t3)
    local list = m:new({ 1, 2, 3 })

    local seen = {}
    list:each(function (item, _index)
      table.insert(seen, item)
    end)

    t3:assert_table_eq({ 1, 2, 3 }, seen)
  end)
end)

case:describe("#each/0", function (t2)
  t2:test("will return a valid lua iterator without a callback", function (t3)
    local list = m:new({ 1, 2, 3 })

    local seen = {}
    for i, item in list:each() do
      seen[i] = item
    end

    t3:assert_table_eq({ 1, 2, 3 }, seen)
  end)
end)

case:describe("#map/1", function (t2)
  t2:test("can map an empty list", function (t3)
    local list = m:new()

    local result = list:map(function (item)
      return item
    end)

    t3:assert_table_eq({}, result:data())
  end)

  t2:test("can map values in a list and return a new list", function (t3)
    local list = m:new({ 1, 2, 3 })

    local result = list:map(function (item)
      return item * 2
    end)

    t3:assert_table_eq({ 2, 4, 6 }, result:data())
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
