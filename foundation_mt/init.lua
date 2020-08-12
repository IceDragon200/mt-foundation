local mod = foundation.new_module("foundation_mt", "1.0.0")

-- A copy of minetest default's get_inventory_drops
--
-- Adds an inventory's items to a given drops list
--
-- @spec get_inventory_drops(Vector3, InventoryRef, Table) :: void
function foundation.com.get_inventory_drops(pos, inventory, drops)
  local inv = minetest.get_meta(pos):get_inventory()
  local n = #drops
  for i = 1, inv:get_size(inventory) do
    local stack = inv:get_stack(inventory, i)
    if stack:get_count() > 0 then
      drops[n+1] = stack:to_table()
      n = n + 1
    end
  end
end

mod:require("groups.lua")
mod:require("schematic_helpers.lua")
