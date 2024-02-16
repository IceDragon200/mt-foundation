--
-- Inventory Serializer is a basic transformation module, by taking any
-- list of item stacks and turning them into POLTs (Plain Old Lua Tables), that
-- can be safely serialized.
-- Since the dumped items are almost 1:1 with their original, the format is not
-- optimized for larger inventories.
-- Try InventoryPacker instead for a smaller serialized footprint.
--

--- @namespace foundation.com.InventorySerializer

---
--- @type DumpedItemStack: {
---   name: String,
---   count: Integer,
---   wear: Integer,
---   meta: Table,
--- }

---
--- @type DumpedInventory: {
---   size: Integer,
---   data: DumpedItemStack,
--- }
local is_blank = assert(foundation.com.is_blank)

local dump_list
local load_list

--- @spec description(DumpedInventory): DumpedItemStack
local function description(dumped_list)
  local count = dumped_list.size
  local used = 0
  for key,item_stack in pairs(dumped_list.data) do
    if not is_blank(item_stack.name) and item_stack.count > 0 then
      used = used + 1
    end
  end
  return used .. " / " .. count
end

--- @spec dump_item_stack(ItemStack): DumpedItemStack
local function dump_item_stack(item_stack)
  local item_name = item_stack:get_name()
  local count = item_stack:get_count()
  local wear = item_stack:get_wear()
  local meta = item_stack:get_meta():to_table()
  local inventory = {}

  if meta.inventory then
    for name,list in pairs(meta.inventory) do
      inventory[name] = dump_list(list)
    end
  end

  meta.inventory = inventory

  return {
    name = item_name,
    count = count,
    wear = wear,
    meta = meta,
  }
end

--- @spec dump_list(ItemStack[]): DumpedInventory
function dump_list(list)
  local result = {
    size = 0,
    data = {},
  }

  if list then
    result.size = #list
    for key,item_stack in pairs(list) do
      result.data[key] = dump_item_stack(item_stack)
    end
  end

  return result
end

--- @spec load_item_stack(DumpedItemStack): ItemStack
local function load_item_stack(source_stack)
  local item_stack = ItemStack({
    name = source_stack.name,
    count = source_stack.count,
    wear = source_stack.wear
  })

  local meta = item_stack:get_meta()

  local new_meta = {}
  local inventory

  for key,value in pairs(source_stack.meta) do
    if key == "inventory" then
      inventory = {}
      for name, dumped_list in pairs(source_stack.meta.inventory) do
        inventory[name] = load_list(dumped_list, {})
      end
      new_meta[key] = inventory
    else
      new_meta[key] = value
    end
  end

  meta:from_table(new_meta)

  return item_stack
end

--- Loads a dumped inventory list from dump_list/1
---
--- @spec load_list(DumpedInventory, target_list: ItemStack[]): ItemStack[]
function load_list(dumped, target_list)
  assert(dumped, "expected dumped inventory list")
  assert(target_list, "expected a target inventory list")

  local stack
  for i = 1,dumped.size do
    stack = dumped.data[i]
    target_list[i] = load_item_stack(stack)
  end

  return target_list
end

foundation.com.InventorySerializer = {
  description = description,
  dump_item_stack = dump_item_stack,
  dump_list = dump_list,
  load_item_stack = load_item_stack,
  load_list = load_list,
}
