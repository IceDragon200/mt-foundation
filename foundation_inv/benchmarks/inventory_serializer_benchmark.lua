local Luna = assert(foundation.com.Luna)
local mod = assert(foundation.com.InventorySerializer)

local ITERATIONS = 1000000
local case = Luna:new("foundation.com.InventorySerializer benchmark")

case:describe("ItemStack/0..1", function (t2)
  t2:test("creating "..ITERATIONS.." empty item stacks", function (t3)
    for _ = 1,ITERATIONS do
      ItemStack()
    end
  end)

  t2:test("creating "..ITERATIONS.." itemstring item stacks", function (t3)
    for _ = 1,ITERATIONS do
      ItemStack("yatm_core:hammer_iron 1")
    end
  end)

  t2:test("creating "..ITERATIONS.." table item stacks", function (t3)
    for _ = 1,ITERATIONS do
      ItemStack({
        name = "yatm_core:hammer_iron",
        count = 1,
        wear = 50,
      })
    end
  end)

  t2:test("creating "..ITERATIONS.." table item stacks with blank name", function (t3)
    for _ = 1,ITERATIONS do
      ItemStack({
        name = "",
        count = 0,
      })
    end
  end)
end)

case:describe(".dump_list/1", function (t2)
  t2:test("can dump an empty list ("..ITERATIONS.." times)", function (t3)
    local list = {}
    for _ = 1,ITERATIONS do
      mod.dump_list(list)
    end
  end)

  t2:test("can dump a list of 4 item stacks ("..ITERATIONS.." times)", function (t3)
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
      mod.dump_list(list)
    end
  end)
end)

case:describe(".load_list/1", function (t2)
  t2:test("can load an empty list ("..ITERATIONS.." times)", function (t3)
    local list = {}

    local dumped = mod.dump_list(list)

    for _ = 1,ITERATIONS do
      mod.load_list(dumped, {})
    end
  end)

  t2:test("can load a 4 item stack list ("..ITERATIONS.." times)", function (t3)
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

    local dumped = mod.dump_list(list)

    for _ = 1,ITERATIONS do
      mod.load_list(dumped, {})
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
