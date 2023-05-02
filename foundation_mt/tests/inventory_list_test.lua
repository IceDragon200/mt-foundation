local itemstack_deep_equals = assert(foundation.com.itemstack_deep_equals)

local Luna = assert(foundation.com.Luna)
local m = assert(foundation.com.InventoryList)

local case = Luna:new("foundation.com.InventoryList")

case:describe("new/1", function (t2)
  t2:test("can create a new itemstack list", function (t3)
    local list = m.new(10)

    t3:assert_eq(#list, 10)

    for _, item_stack in ipairs(list) do
      -- all item stacks should be empty by default
      t3:assert(item_stack:is_empty())
    end
  end)
end)

case:describe("copy/1", function (t2)
  t2:test("can copy an existing inventory list", function (t3)
    local other = {
      ItemStack("my_mod:my_name"),
      ItemStack("my_mod:my_name1 5"),
      ItemStack("my_mod:my_name2 7 44")
    }

    local list = m.copy(other)

    t3:assert_eq(#list, #other)

    for i, item_stack in ipairs(other) do
      t3:assert(itemstack_deep_equals(list[i], item_stack))
    end
  end)
end)

case:describe("add_items/2", function (t2)
  t2:test("will attempt to add given items to the inventory list", function (t3)
    local dest = m.new(3)

    local other = {
      ItemStack("my_mod:my_name"),
      ItemStack("my_mod:my_name1 5"),
      ItemStack("my_mod:my_name2 7 44")
    }

    local leftovers = m.add_items(dest, other)

    t3:assert_eq(#leftovers, 0)

    for i, item_stack in ipairs(other) do
      t3:assert_eq(itemstack_deep_equals(dest[i], item_stack), true)
    end
  end)

  t2:test("will have leftovers if not all items could be added", function (t3)
    local dest = m.new(2)

    local other = {
      ItemStack("my_mod:my_name"),
      ItemStack("my_mod:my_name1 5"),
      ItemStack("my_mod:my_name2 7 44")
    }

    local leftovers = m.add_items(dest, other)

    local has_next = next(leftovers)

    t3:assert(has_next)

    t3:assert_eq(#leftovers, 1)

    for i, item_stack in ipairs(other) do
      if i >= 3 then
        t3:assert_eq(itemstack_deep_equals(leftovers[i - 2], item_stack), true)
      else
        t3:assert_eq(itemstack_deep_equals(dest[i], item_stack), true)
      end
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
