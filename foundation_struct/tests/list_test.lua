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

case:describe("#to_list/0", function (t2)
  t2:test("should return self", function (t3)
    local list = m:new({ "a", "b", "c" })
    local other_list = list:to_list()

    --- Should be the same list
    t3:assert_eq(list, other_list)
  end)
end)

case:describe("#to_linked_list/0", function (t2)
  t2:test("can retrieve underlying table", function (t3)
    local list = m:new({ "a", "b", "c" })
    local ll = list:to_linked_list()

    t3:assert(ll:is_instance_of(assert(foundation.com.LinkedList)))

    --- Should be the same list
    t3:refute_eq(list, ll)

    t3:assert_eq(ll:size(), 3)
    t3:assert_eq(ll:first(), "a")
    t3:assert_eq(ll:last(), "c")
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

case:describe("#flatten_iodata/0", function (t2)
  t2:test("can flatten a list for iodata", function (t3)
    local list = m:new({ "a", "b", m:new({"c", "d"}), {"e", "f", "g"} })

    list:flatten_iodata()

    t3:assert_eq(7, list:size())

    t3:assert_table_eq({ "a", "b", "c", "d", "e", "f", "g" }, list:data())
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
  t2:test("can concatenate with an empty lists", function (t3)
    local a = m:new()
    local b = m:new()

    a:concat(b)

    t3:assert_eq(0, a:size())
  end)

  t2:test("can concatenate a list with items into an empty list", function (t3)
    local a = m:new()
    local b = m:new({ "a", "b", "c" })

    a:concat(b)
    t3:assert_eq(3, a:size())
    t3:assert_table_eq({"a", "b", "c"}, a:data())
  end)

  t2:test("can concatenate a list with items into another list with items", function (t3)
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

case:describe("#is_empty/0", function (t2)
  t2:test("can correctly determine if a list is empty", function (t3)
    local list = m:new()

    t3:assert(list:is_empty())
  end)

  t2:test("can correctly determine a list is not empty", function (t3)
    local list = m:new({ 1, 2, 3 })

    t3:refute(list:is_empty())
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

case:describe("#reduce_while/2", function (t2)
  t2:test("can iterate an empty list", function (t3)
    local list = m:new()

    local result = list:reduce_while(0, function (_item, _index, acc)
      return true, acc
    end)

    t3:assert_eq(0, result)
  end)

  t2:test("can iterate a list with items", function (t3)
    local list = m:new({ 1, 2, 3 })

    local result = list:reduce_while(0, function (item, _index, acc)
      return item < 2, acc + item
    end)

    t3:assert_eq(3, result)
  end)
end)

case:describe("#each/1", function (t2)
  t2:test("can iterate an empty list", function (t3)
    local list = m:new()

    local touched = false
    list:each(function (_item, _index)
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

case:describe("#find/2", function (t2)
  t2:test("can find an element that matches criteria", function (t3)
    local t = m:new({
      1,
      2,
      3
    })

    t3:assert_eq(
      t:find(nil, function (elm, _index)
        return elm == 2
      end),
      2
    )
  end)

  t2:test("correctly returns default when find fails", function (t3)
    local t = m:new({
      1,
      2,
      3
    })

    t3:assert_eq(
      t:find(-1, function (elm, _index)
        return elm == 4
      end),
      -1
    )
  end)
end)

case:describe("#filter/2", function (t2)
  t2:test("only includes truthy elements from callback", function (t3)
    local t = m:new({
      1,
      2,
      3,
      4,
      5,
      6,
    })

    local new_t =
      t:filter(function (value, _index)
        return math.fmod(value, 2) == 0
      end)

    t3:assert_table_eq(
      t:data(),
      {
        1,
        2,
        3,
        4,
        5,
        6,
      }
    )

    t3:assert_table_eq(
      new_t:data(),
      {
        2,
        4,
        6,
      }
    )
  end)
end)

case:describe("#reject/2", function (t2)
  t2:test("only removes truthy elements from callback", function (t3)
    local t = m:new({
      1,
      2,
      3,
      4,
      5,
      6,
    })

    local new_t =
      t:reject(function (value, _index)
        return math.fmod(value, 2) == 0
      end)

    t3:assert_table_eq(
      t:data(),
      {
        1,
        2,
        3,
        4,
        5,
        6,
      }
    )

    t3:assert_table_eq(
      new_t:data(),
      {
        1,
        3,
        5,
      }
    )
  end)
end)

case:describe("#bsearch/1", function (t2)
  t2:test("can perform a binary search on an empty list", function (t3)
    local list = m:new()

    local res, idx = list:bsearch(1)

    t3:assert_eq(res, nil)
    t3:assert_eq(idx, nil)
  end)

  t2:test("can perform a binary search on a sorted list (with integers)", function (t3)
    local list = m:new({10, 20, 30, 40, 50, 60, 70, 80, 90})

    for aidx, a in list:each() do
      local b, bidx = list:bsearch(a)

      t3:assert_eq(a, b)
      t3:assert_eq(aidx, bidx)
    end

    for _, a in ipairs({ 0, 100 }) do
      local b, bidx = list:bsearch(a)

      t3:assert_eq(b, nil)
      t3:assert_eq(bidx, nil)
    end
  end)

  t2:test("can perform a binary search on a sorted list (with integers) of random length", function (t3)
    local list = m:new({})

    for i = 1,math.random(20) do
      list:push(i * 20)
    end

    for aidx, a in list:each() do
      local b, bidx = list:bsearch(a)

      t3:assert_eq(a, b)
      t3:assert_eq(aidx, bidx)
    end
  end)
end)

case:describe("#bsearch_by/1", function (t2)
  t2:test("can perform a binary search on an empty list", function (t3)
    local list = m:new()

    local res, idx = list:bsearch_by(function (_a)
      return 1
    end)

    t3:assert_eq(res, nil)
    t3:assert_eq(idx, nil)
  end)

  t2:test("can perform a binary search on a sorted list", function (t3)
    local list = m:new({10, 20, 30, 40, 50, 60, 70, 80, 90})

    for aidx, a in list:each() do
      local c, cidx = list:bsearch_by(function (b, bidx)
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
      local c, cidx = list:bsearch_by(function (b)
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
