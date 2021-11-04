-- @namespace foundation.com.InventoryList
foundation_stdlib:require("lib/item_stack.lua")

local itemstack_new_blank = assert(foundation.com.itemstack_new_blank)
local itemstack_is_blank = assert(foundation.com.itemstack_is_blank)
local itemstack_split = assert(foundation.com.itemstack_split)
local itemstack_maybe_merge = assert(foundation.com.itemstack_maybe_merge)

local InventoryList = {}

-- Determines if the given inventory list should be considered empty
--
-- @spec is_empty(ItemStack[]): Boolean
function InventoryList.is_empty(list)
  for _index, item_stack in ipairs(list) do
    if not item_stack:is_empty() then
      return false
    end
  end

  return true
end

-- @spec first_present_stack(ItemStack[]): ItemStack | nil
function InventoryList.first_present_stack(list)
  assert(list, "expected an inventory list")
  for _,item_stack in ipairs(list) do
    if not itemstack_is_blank(item_stack) then
      return item_stack
    end
  end
  return nil
end

-- @spec merge_stack(list: ItemStack[], stack: ItemStack): (ItemStack[], ItemStack)
function InventoryList.merge_stack(list, stack)
  assert(list, "expected an inventory list")
  local max_stack_size = stack:get_stack_max()
  for i,item_stack in ipairs(list) do
    local new_stack
    if itemstack_is_blank(stack) then
      break
    end
    if itemstack_is_blank(item_stack) then
      new_stack, stack = itemstack_split(stack, max_stack_size)
      list[i] = new_stack
    else
      new_stack, stack = itemstack_maybe_merge(item_stack, stack)
      list[i] = new_stack
    end
  end
  return list, stack
end

-- @spec extract_stack(list: ItemStack[], stack_or_size: ItemStack | Integer): (ItemStack[], ItemStack)
function InventoryList.extract_stack(list, stack_or_size)
  assert(list, "expected an inventory list")
  local taken = nil
  if type(stack_or_size) == "number" then
    -- the criteria is any stack with a count
    for i,item_stack in ipairs(list) do
      if item_stack:get_count() > 0 then
        taken = item_stack:peek_item(stack_or_size)
        local new_count = item_stack:get_count() - taken:get_count()
        if new_count == 0 then
          list[i] = itemstack_new_blank()
        else
          list[i] = item_stack:peek_item(new_count)
        end
        break
      end
    end
  else
    -- the criteria is another stack
    for i,item_stack in ipairs(list) do
      -- TODO: proper matching
      if item_stack:get_name() == stack_or_size:get_name() then
        taken = item_stack:peek_item(stack_or_size:get_count())
        local new_count = item_stack:get_count() - taken:get_count()
        if new_count == 0 then
          list[i] = itemstack_new_blank()
        else
          list[i] = item_stack:peek_item(new_count)
        end
        break
      end
    end
  end
  return list, taken
end

foundation.com.InventoryList = InventoryList
