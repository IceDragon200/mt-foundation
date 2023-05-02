--- @namespace foundation.com

--- Helper function for recovering some amount of hp
---
--- It will return the amount that was actually recovered
---
--- A return of 0 means nothing was recovered
---
--- @mutative entity
--- @spec recover_hp(entity: ObjectRef, amount: Integer, reason: Any): Integer
function foundation.com.recover_hp(entity, amount, reason)
  local hp = entity:get_hp()
  local hp_max = entity:get_properties().hp_max

  local used_amount = math.min(hp + amount, hp_max) - hp
  if used_amount > 0 then
    entity:set_hp(hp + used_amount, reason)
  end
  return used_amount
end

--- A copy of minetest default's get_inventory_drops
---
--- Adds an inventory's items to a given drops list
---
--- @mutative drops
--- @spec get_inventory_drops(pos: Vector3, inventory: InventoryRef, drops: ItemStack[]): void
function foundation.com.get_inventory_drops(pos, inventory, drops)
  local inv = minetest.get_meta(pos):get_inventory()
  local n = #drops
  for i = 1, inv:get_size(inventory) do
    local stack = inv:get_stack(inventory, i)
    if stack:get_count() > 0 then
      n = n + 1
      drops[n] = stack:to_table()
    end
  end
end
