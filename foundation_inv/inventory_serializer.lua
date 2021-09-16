-- @namespace foundation.com.InventorySerializer
--
-- @type SerializedItemStack: {
--   name: String,
--   count: Integer,
--   wear: Integer,
--   meta: Table,
-- }
--
-- @type SerializedInventory: {
--   size: Integer,
--   data: SerializedItemStack,
-- }
local is_blank = assert(foundation.com.is_blank)

local serialize
local deserialize_list

-- @spec description(SerializedInventory): SerializedItemStack
local function description(serialized_list)
  local count = serialized_list.size
  local used = 0
  for key,item_stack in pairs(serialized_list.data) do
    if not is_blank(item_stack.name) and item_stack.count > 0 then
      used = used + 1
    end
  end
  return used .. " / " .. count
end

-- @spec serialize_item_stack(ItemStack): SerializedItemStack
local function serialize_item_stack(item_stack)
  local item_name = item_stack:get_name()
  local count = item_stack:get_count()
  local wear = item_stack:get_wear()
  local meta = item_stack:get_meta():to_table()
  local inventory = {}

  if meta.inventory then
    for name,list in pairs(meta.inventory) do
      inventory[name] = serialize(list)
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

-- @spec serialize(ItemStack[]): SerializedInventory
local function serialize(list)
  local result = {
    size = 0,
    data = {},
  }

  if list then
    result.size = #list
    for key,item_stack in pairs(list) do
      result.data[key] = serialize_item_stack(item_stack)
    end
  end

  return result
end

-- @spec deserialize_item_stack(SerializedItemStack): ItemStack
local function deserialize_item_stack(source_stack)
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
      for name,serialized_list in pairs(source_stack.meta.inventory) do
        inventory[name] = deserialize_list(serialized_list, {})
      end
      new_meta[key] = inventory
    else
      new_meta[key] = value
    end
  end

  meta:from_table(new_meta)

  return item_stack
end

-- Deserializes a serialized inventory list from serialize/1
--
  -- @spec deserialize_list(SerializedInventory, target_list: ItemStack[]): ItemStack[]
function deserialize_list(dumped, target_list)
  assert(dumped, "expected dumped inventory list")
  assert(target_list, "expected a target inventory list")

  for i = 1,dumped.size do
    local stack = dumped.data[i]
    target_list[i] = deserialize_item_stack(stack)
  end

  return target_list
end

foundation.com.InventorySerializer = {
  description = description,
  serialize_item_stack = serialize_item_stack,
  serialize = serialize,
  deserialize_item_stack = deserialize_item_stack,
  deserialize_list = deserialize_list,
}
