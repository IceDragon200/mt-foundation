local Luna = assert(foundation.com.Luna)
local mod = assert(foundation.com.InventorySerializer)

local ITERATIONS = 1000000
local case = Luna:new("foundation.com.InventorySerializer benchmark")

case:describe(".serialize/1", function (t2)
  t2:test("can serialize an empty list ("..ITERATIONS.." times)", function (t3)
    local list = {}
    for _ = 1,ITERATIONS do
      mod.serialize(list)
    end
  end)

  t2:test("can serialize a list of 4 item stacks ("..ITERATIONS.." times)", function (t3)
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

    for _ = 1,ITERATIONS do
      mod.serialize(list)
    end
  end)
end)

case:describe(".deserialize_list/1", function (t2)
  t2:test("can deserialize an empty list ("..ITERATIONS.." times)", function (t3)
    local list = {}

    local dumped = mod.serialize(list)

    for _ = 1,ITERATIONS do
      mod.deserialize_list(dumped, {})
    end
  end)

  t2:test("can deserialize a 4 item stack list ("..ITERATIONS.." times)", function (t3)
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

    local dumped = mod.serialize(list)

    for _ = 1,ITERATIONS do
      mod.deserialize_list(dumped, {})
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
