local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.itemstack_*")

case:describe("itemstack_deep_equals/2", function (t2)
  t2:test("can compare the same itemstack", function (t3)
    local item_stack = ItemStack()
    t3:assert_eq(m.itemstack_deep_equals(item_stack, item_stack), true)
  end)

  t2:test("can compare 2 empty itemstacks", function (t3)
    local a = ItemStack()
    local b = ItemStack()

    t3:assert_eq(m.itemstack_deep_equals(a, b), true)
  end)

  t2:test("can compare 2 itemstacks (with just the same name)", function (t3)
    local a = ItemStack("my_mod:my_name")
    local b = ItemStack("my_mod:my_name")
    local c = ItemStack("my_mod:my_name2")

    t3:assert_eq(m.itemstack_deep_equals(a, b), true)
    t3:refute_eq(m.itemstack_deep_equals(a, c), true)
  end)

  t2:test("can compare 2 itemstacks (with just the same name and count)", function (t3)
    local a = ItemStack("my_mod:my_name 5")
    local b = ItemStack("my_mod:my_name 5")
    local c = ItemStack("my_mod:my_name 6")

    t3:assert_eq(m.itemstack_deep_equals(a, b), true)
    t3:refute_eq(m.itemstack_deep_equals(a, c), true)
  end)

  t2:test("can compare 2 itemstacks (with the same name, count and wear)", function (t3)
    local a = ItemStack("my_mod:my_name 5 25")
    local b = ItemStack("my_mod:my_name 5 25")
    local c = ItemStack("my_mod:my_name 5 26")

    t3:assert_eq(m.itemstack_deep_equals(a, b), true)
    t3:refute_eq(m.itemstack_deep_equals(a, c), true)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
