local mod = foundation.com.WeightedList
local m = foundation.com
local Luna = assert(m.Luna)

local case = Luna:new("foundation.com.WeightedList")

case:describe(":new/0", function (t2)
  t2:test("can create a new WeightedList", function (t3)
    local list = mod:new()

    t3:assert(list.size == 0)
    t3:assert(list.total_weight == 0)
  end)
end)

case:describe("#push/2", function (t2)
  t2:test("can push a new element unto weighted list", function (t3)
    local list = mod:new()

    list:push("Item", 4)

    t2:assert(list.size == 1)
    t2:assert(list.total_weight == 4)

    list:push("Item 2", 8)

    t2:assert(list.size == 2)
    t2:assert(list.total_weight == 12)

    list:push("Item 3", 7)

    t2:assert(list.size == 3)
    t2:assert(list.total_weight == 19)
  end)
end)

case:describe("#get_item_within_weight/1", function (t2)
  t2:test("can retrieve an item at the specific weight position", function (t3)
    local list = mod:new()

    list:push("Item", 4)
    list:push("Item 2", 8)
    list:push("Item 3", 7)

    t2:assert_eq("Item", list:get_item_within_weight(1))
    t2:assert_eq("Item", list:get_item_within_weight(4))
    t2:assert_eq("Item 2", list:get_item_within_weight(5))
    t2:assert_eq("Item 2", list:get_item_within_weight(12))
    t2:assert_eq("Item 3", list:get_item_within_weight(13))
    t2:assert_eq("Item 3", list:get_item_within_weight(19))
    t2:assert_eq(nil, list:get_item_within_weight(20))
  end)
end)

case:describe("#random/0", function (t2)
  t2:test("can randomly select an element from list", function (t3)
    local list = mod:new()

    list:push("Item", 4)
    list:push("Item 2", 8)
    list:push("Item 3", 7)

    for _ = 1,10 do
      local value = list:random()

      t3:assert(value == "Item" or value == "Item 2" or value == "Item 3")
    end
  end)
end)

case:describe("#random_list/1", function (t2)
  t2:test("can collect a list of random items from list", function (t3)
    local list = mod:new()

    list:push("Item", 4)
    list:push("Item 2", 8)
    list:push("Item 3", 7)

    local l = list:random_list(6)

    for _, value in ipairs(l) do
      t3:assert(value == "Item" or
                value == "Item 2" or
                value == "Item 3")
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
