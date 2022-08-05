local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.itemstack_*")

case:describe("itemstack_deep_equals/2", function (t2)
  t2:test("can compare the same itemstack", function (t3)
    local item_stack = ItemStack()
    t3:assert_eq(m.itemstack_deep_equals(item_stack, item_stack), true)
  end)

  t2:test("can compare 2 itemstacks that have the same content", function (t3)
    local a = ItemStack()
    local b = ItemStack()

    t3:assert_eq(m.itemstack_deep_equals(a, b), true)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
