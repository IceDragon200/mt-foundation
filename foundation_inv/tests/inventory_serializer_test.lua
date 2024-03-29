local Luna = assert(foundation.com.Luna)
local InventorySerializer = assert(foundation.com.InventorySerializer)

local case = Luna:new("foundation.com.InventorySerializer")

case:describe(".dump_list/1", function (t2)
  t2:test("can dump a list of item stacks", function (t3)
    local list = {
      ItemStack({
        name = "yatm_core:hammer_iron",
        count = 1,
        wear = 50,
      }),
      ItemStack({
        name = "yatm_core:gear_iron",
        count = 4,
      }),
      ItemStack({
        name = "yatm_core:plate_iron",
        count = 3,
      }),
      ItemStack({
        name = "",
        count = 0,
      }),
    }
    local dumped = InventorySerializer.dump_list(list)
    t3:assert_eq(dumped.size, 4)
    t3:assert(dumped.data, "expected dumped data")
    t3:assert(dumped.data[1], "expected to have element 1")
    t3:assert(dumped.data[2], "expected to have element 2")
    t3:assert(dumped.data[3], "expected to have element 3")
    t3:assert(dumped.data[4], "expected to have element 4")

    t3:assert_eq(dumped.data[1].name, "yatm_core:hammer_iron")
    t3:assert_eq(dumped.data[2].name, "yatm_core:gear_iron")
    t3:assert_eq(dumped.data[3].name, "yatm_core:plate_iron")
    t3:assert_eq(dumped.data[4].name, "")

    t3:assert_eq(dumped.data[1].count, 1)
    t3:assert_eq(dumped.data[2].count, 4)
    t3:assert_eq(dumped.data[3].count, 3)
    t3:assert_eq(dumped.data[4].count, 0)

    t3:assert_eq(dumped.data[1].wear, 50)
    t3:assert_eq(dumped.data[2].wear, 0)
    t3:assert_eq(dumped.data[3].wear, 0)
    t3:assert_eq(dumped.data[4].wear, 0)
  end)
end)

case:describe(".load_list/1", function (t2)
  t2:test("can load a serialized list of item stacks", function (t3)
    local list = {
      ItemStack({
        name = "yatm_core:hammer_iron",
        count = 1,
        wear = 50,
      }),
      ItemStack({
        name = "yatm_core:gear_iron",
        count = 4,
      }),
      ItemStack({
        name = "yatm_core:plate_iron",
        count = 3,
      }),
      ItemStack({
        name = "",
        count = 0,
      }),
    }

    local dumped = InventorySerializer.dump_list(list)
    local new_list = InventorySerializer.load_list(dumped, {})

    t3:assert(new_list[1])
    t3:assert(new_list[2])
    t3:assert(new_list[3])
    t3:assert(new_list[4])

    t3:assert_eq(new_list[1]:get_name(), "yatm_core:hammer_iron")
    t3:assert_eq(new_list[2]:get_name(), "yatm_core:gear_iron")
    t3:assert_eq(new_list[3]:get_name(), "yatm_core:plate_iron")
    t3:assert_eq(new_list[4]:get_name(), "")

    t3:assert_eq(new_list[1]:get_count(), 1)
    t3:assert_eq(new_list[2]:get_count(), 4)
    t3:assert_eq(new_list[3]:get_count(), 3)
    t3:assert_eq(new_list[4]:get_count(), 0)

    t3:assert_eq(new_list[1]:get_wear(), 50)
    t3:assert_eq(new_list[2]:get_wear(), 0)
    t3:assert_eq(new_list[3]:get_wear(), 0)
    t3:assert_eq(new_list[4]:get_wear(), 0)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
