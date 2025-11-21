local CraftRegistry = assert(foundation.com.headless.CraftRegistry)

local case = foundation.com.Luna:new("foundation.com.headless.CraftRegistry")

case:describe("#initialize/0", function (t2)
  t2:test("can initialize a new craft registry", function (t3)
    local cr = CraftRegistry:new()
  end)
end)

case:describe("registering, retrieving and removing recipes", function (t2)
  t2:test("can register, retrieve and remove recipes", function (t3)
    local cr = CraftRegistry:new()

    cr:register_craft{
      type = "cooking",
      recipe = "example:src_item",
      cooktime = 4,
      output = "example:dest_item",
    }

    local recipe, leftover = cr:get_craft_result{
      method = "cooking",
      width = 1,
      items = { "example:src_item" },
    }

    t3:assert_eq(recipe.time, 4)
    t3:assert_eq(recipe.item:get_name(), "example:dest_item")
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
