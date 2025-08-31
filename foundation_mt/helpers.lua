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

--- A copy of luanti default's get_inventory_drops
---
--- Adds an inventory's items to a given drops list
---
--- @mutative drops
--- @spec get_inventory_drops(pos: Vector3, inventory: InventoryRef, drops: ItemStack[]): void
function foundation.com.get_inventory_drops(pos, inventory, drops)
  local meta = tetra.get_meta(pos)
  local inv = meta:get_inventory()
  local n = #drops
  for i = 1, inv:get_size(inventory) do
    local stack = inv:get_stack(inventory, i)
    if stack:get_count() > 0 then
      n = n + 1
      drops[n] = stack:to_table()
    end
  end
end

--- Copies a NodeRef, you could also just use table_copy, but this guarantees only the NodeRef
--- fields are being copied and set.
---
--- @since "2.1.0"
--- @spec copy_node(node: NodeRef): NodeRef
function foundation.com.copy_node(node)
  return {
    name = node.name,
    param1 = node.param1,
    param2 = node.param2,
  }
end

--- Formats a NodeRef as a string for logging purposes
---
--- @since "2.1.0"
--- @spec node_to_string(node?: NodeRef): String
function foundation.com.node_to_string(node)
  if node then
    return node.name .. "," .. (node.param1 or "N/A") .. "," .. (node.param2 or "N/A")
  else
    return "N/A,N/A,N/A"
  end
end
