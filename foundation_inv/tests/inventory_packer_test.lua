local Luna = assert(foundation.com.Luna)
local InventoryPacker = assert(foundation.com.InventoryPacker)
local itemstack_deep_equals = assert(foundation.com.itemstack_deep_equals)

local case = Luna:new("foundation.com.InventoryPacker")

local item4 = ItemStack({ name = "test:item4", count = 12, wear = 55 })
local meta = item4:get_meta()
meta:set_float("flt", 233.22)
meta:set_int("something", 22)
meta:set_string("abc", "data")

local TEST_LIST = {
  ItemStack("test:item1"),
  ItemStack({ name = "test:item2", count = 3 }),
  ItemStack({ name = "test:item3", count = 5, wear = 44 }),
  item4,
}

case:describe("(un)pack_list/1", function (t2)
  t2:test("can pack an empty inventory list", function (t3)
    local list = {}

    local state = InventoryPacker.pack_list(list)

    t3:assert_table_eq({}, InventoryPacker.unpack_list(state))
  end)

  t2:test("can pack a list with some items", function (t3)
    local state = InventoryPacker.pack_list(TEST_LIST)

    local new_list = InventoryPacker.unpack_list(state)

    t3:assert_eq(#new_list, #TEST_LIST)
    t3:assert(itemstack_deep_equals(new_list[1], TEST_LIST[1]))
    t3:assert(itemstack_deep_equals(new_list[2], TEST_LIST[2]))
    t3:assert(itemstack_deep_equals(new_list[3], TEST_LIST[3]))
    t3:assert(itemstack_deep_equals(new_list[4], TEST_LIST[4]))
  end)
end)

case:describe("ascii_(un)pack_list/1", function (t2)
  t2:test("can pack an empty inventory list", function (t3)
    local list = {}

    local blob = InventoryPacker.ascii_pack_list(list)

    t3:assert_table_eq({}, InventoryPacker.ascii_unpack_list(blob))
  end)

  t2:test("can pack a list with some items", function (t3)
    local state = InventoryPacker.pack_list(TEST_LIST)

    local new_list = InventoryPacker.unpack_list(state)

    t3:assert_eq(#new_list, #TEST_LIST)
    t3:assert(itemstack_deep_equals(new_list[1], TEST_LIST[1]))
    t3:assert(itemstack_deep_equals(new_list[2], TEST_LIST[2]))
    t3:assert(itemstack_deep_equals(new_list[3], TEST_LIST[3]))
    t3:assert(itemstack_deep_equals(new_list[4], TEST_LIST[4]))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
