local Luna = foundation.com.Luna
local M = foundation.com.OrderedSet

local case = Luna:new("foundation.com.OrderedSet")

case:describe("#initialize/0", function (t2)
  t2:test("can initialize an empty set", function (t3)
    local subject = M:new()

    t3:assert(subject:is_empty())
    t3:assert_eq(0, subject:size())
  end)
end)

case:describe("#initialize/1", function (t2)
  t2:test("can initialize an ordered set from a table", function (t3)
    local subject = M:new({ 3, 2, 1 })

    t3:refute(subject:is_empty())
    t3:assert_eq(3, subject:size())

    t3:assert_eq(1, subject:get(1))
    t3:assert_eq(2, subject:get(2))
    t3:assert_eq(3, subject:get(3))
  end)
end)

case:describe("#initialize_copy/1", function (t2)
  t2:test("can copy a set", function (t3)
    local a = M:new({ 3, 2, 1 })
    local b = a:copy()

    t3:assert_eq(a, b) -- ==/equals
    t3:refute_raw_eq(a, b)
    t3:refute_raw_eq(a.m_data, b.m_data)
    t3:assert_table_eq(a.m_data, b.m_data)
    t3:refute_raw_eq(a.m_set, b.m_set)
    t3:assert_table_eq(a.m_set, b.m_set)

    a:contains(3)
    b:contains(3)
  end)
end)

case:describe("#insert/1+", function (t2)
  t2:test("can insert an item into the set", function (t3)
    local subject = M:new({ 3, 2, 1 })
    t3:assert_eq(3, subject:size())
    subject:insert(0)
    subject:insert(4)
    t3:assert_eq(5, subject:size())
    t3:assert_eq(0, subject:get(1))
    t3:assert_eq(4, subject:get(5))
  end)
end)

case:describe("#concat/1", function (t2)
  t2:test("can concatenate one set into another", function (t3)
    local subject = M:new({ 3, 2, 1 })
    subject:concat(M:new({ 6, 5, 7 }))

    t3:assert_table_eq({1, 2, 3, 5, 6, 7}, subject:to_table())
  end)

  t2:test("can concatenate a table", function (t3)
    local subject = M:new({ 3, 2, 1 })
    subject:concat({ 6, 5, 7 })

    t3:assert_table_eq({1, 2, 3, 5, 6, 7}, subject:to_table())
  end)
end)

case:describe("#delete/1", function (t2)
  t2:test("can delete an item from the set", function (t3)
    local subject = M:new({ "3", "2", "1" })
    t3:assert(subject:contains("3"))

    subject:delete("3")
    t3:refute(subject:contains("3"))
    t3:assert_eq(2, subject:size())
    t3:assert_table_eq({ "1", "2" }, subject:to_table())
    t3:refute(subject:contains("4"))

    subject:delete("4")
    t3:assert_eq(2, subject:size())
    t3:assert_table_eq({ "1", "2" }, subject:to_table())

    subject:delete("1")
    t3:refute(subject:contains("1"))
    t3:assert_eq(1, subject:size())
    t3:assert_table_eq({ "2" }, subject:to_table())
  end)
end)

case:describe("#pop_at/1", function (t2)
  t2:test("can pop an item at position", function (t3)
    local subject = M:new({ "3", "2", "1" })
    t3:assert(subject:contains("2"))

    t3:assert_eq("2", subject:pop_at(2))
    t3:refute(subject:contains("2"))
    t3:assert_eq(2, subject:size())
    t3:assert_table_eq({ "1", "3" }, subject:to_table())

    t3:assert_eq("3", subject:pop_at(2))
    t3:refute(subject:contains("3"))
    t3:assert_eq(1, subject:size())
    t3:assert_table_eq({ "1" }, subject:to_table())
  end)
end)

case:describe("#first/0", function (t2)
  t2:test("can return the first item in the set", function (t3)
    local subject = M:new({ "3", "2", "1" })

    t3:assert_eq("1", subject:first())
  end)
end)

case:describe("#first/1", function (t2)
  t2:test("can return the first X items in the set", function (t3)
    local subject = M:new({ "3", "2", "1" })

    t3:assert_table_eq({"1", "2"}, subject:first(2))
  end)
end)

case:describe("#last/0", function (t2)
  t2:test("can return the last item in the set", function (t3)
    local subject = M:new({ "3", "2", "1" })

    t3:assert_eq("3", subject:last())
  end)
end)

case:describe("#last/1", function (t2)
  t2:test("can return the last X items in the set", function (t3)
    local subject = M:new({ "3", "2", "1" })

    t3:assert_table_eq({"2", "3"}, subject:last(2))
  end)
end)

case:describe("#sample/0", function (t2)
  t2:test("can randomly return 1 element in the set", function (t3)
    local subject = M:new({ "3", "2", "1" })
    for i = 1,100 do
      local x = subject:sample()
      t3:assert(x == "1" or x == "2" or x == "3", "expected to random of the available items")
    end
  end)
end)

case:describe("#pop_sample/0", function (t2)
  t2:test("can pop and randomly return 1 element in set", function (t3)
    local a = M:new({ "3", "2", "1" })
    local b = M:new()

    b:insert(a:pop_sample())
    b:insert(a:pop_sample())
    b:insert(a:pop_sample())

    t3:assert_eq(0, a:size())
    t3:assert_eq(true, a:is_empty())

    t3:assert_eq(3, b:size())
    t3:assert_eq(false, b:is_empty())

    t3:assert_table_eq({"1", "2", "3"}, b:to_table())
  end)
end)

case:describe("#map/1", function (t2)
  t2:test("can reduce set and return new set", function (t3)
    local a = M:new({3, 2, 1})
    local b = a:map(function (x)
      return x * 2
    end)
    t3:assert_table_eq({2, 4, 6}, b:to_table())
  end)
end)

case:describe("#filter/1", function (t2)
  t2:test("can reduce set and return only filtered items", function (t3)
    local a = M:new({4, 3, 2, 1})
    local b = a:filter(function (x)
      return x % 2 == 0
    end)
    t3:assert_table_eq({2, 4}, b:to_table())
  end)
end)

case:describe("#reject/1", function (t2)
  t2:test("can reduce set and return only unrejected items", function (t3)
    local a = M:new({4, 3, 2, 1})
    local b = a:reject(function (x)
      return x % 2 == 0
    end)
    t3:assert_table_eq({1, 3}, b:to_table())
  end)
end)

case:describe("#find/2", function (t2)
  t2:test("can find an return an item in the set", function (t3)
    local a = M:new({ 4, 3, 2, 1 })
    local item = a:find(nil, function (x)
      return x == 4
    end)
    t3:assert_eq(4, item)

    item = a:find(nil, function (x)
      return x == 5
    end)
    t3:assert_eq(nil, item)
  end)
end)

case:describe("#find_index/1", function (t2)
  t2:test("can find an item's index in the set", function (t3)
    local a = M:new({ "4", "3", "2", "1" })
    local item = a:find_index(function (x)
      return x == "4"
    end)
    t3:assert_eq(4, item)

    item = a:find_index(function (x)
      return x == "5"
    end)
    t3:assert_eq(-1, item)
  end)
end)

case:describe("#each/1", function (t2)
  t2:test("can iterate and pass all items to callback", function (t3)
    local a = M:new({ "4", "3", "2", "1" })
    local b = M:new()
    local li = 0
    local l = "0"
    local item = a:each(function (x, idx)
      t3:assert(li < idx)
      t3:assert(l < x)
      l = x
      li = idx
      b:insert(x)
    end)
    t3:assert_table_eq({"1", "2", "3", "4"}, b:to_table())
    t3:assert(item)
  end)
end)

case:describe("#bsearch/1", function (t2)
  t2:test("can perform a bsearch on items", function (t3)
    local a = M:new({ "4", "3", "2", "1" })
    a:each(function (x)
      t3:assert_eq(x, a:bsearch(x))
    end)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
