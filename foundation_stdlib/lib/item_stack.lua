-- @namespace foundation.com

-- @spec itemstack_deep_equals(ItemStack, ItemStack): Boolean
function foundation.com.itemstack_deep_equals(a, b)
  if a == b then
    return true
  end

  if a and b then
    return a:get_name() == b:get_name() and
           a:get_count() == b:get_count() and
           a:get_wear() == b:get_wear() and
           a:get_meta():equals(b:get_meta())
  end

  return false
end

-- @spec itemstack_is_blank(ItemStack): Boolean
function foundation.com.itemstack_is_blank(stack)
  if stack then
    return stack:is_empty()
  end
  return true
end

-- @spec itemstack_copy(ItemStack): ItemStack
function foundation.com.itemstack_copy(stack)
  return stack:peek_item(stack:get_count())
end

-- @spec itemstack_get_itemdef(ItemStack | nil): Table
function foundation.com.itemstack_get_itemdef(stack)
  if not foundation.com.itemstack_is_blank(stack) then
    return stack:get_definition()
  end
  return nil
end

-- @spec itemstack_has_group(stack: ItemStack, group_name: String, optional_value: Integer): Boolean
function foundation.com.itemstack_has_group(stack, group_name, optional_value)
  local itemdef = foundation.com.itemstack_get_itemdef(stack)
  if itemdef then
    return foundation.com.Groups.has_group(itemdef, group_name, optional_value)
  else
    return false
  end
end

-- @spec itemstack_inspect(stack: ItemStack | nil): String
function foundation.com.itemstack_inspect(stack)
  if stack then
    return "stack[" ..
      stack:get_name() ..
      "/" ..
      stack:get_count() ..
      "/" ..
      stack:get_wear() ..
    "]"
  else
    return "nil"
  end
end

-- @spec itemstack_new_blank(): ItemStack
function foundation.com.itemstack_new_blank()
  return ItemStack({
    name = "",
    count = 0,
    wear = 0
  })
end

-- A non-destructive version of ItemStack#take_item,
-- this will return the taken stack as the first value and the remaining as the second
--
-- @spec itemstack_split(stack: ItemStack, size: Integer): (stack: ItemStack, leftover: ItemStack)
function foundation.com.itemstack_split(stack, size)
  local max = stack:get_count()
  local takable = math.min(size, max)
  if takable == max then
    return stack, foundation.com.itemstack_new_blank()
  else
    return stack:peek_item(takable), stack:peek_item(max - takable)
  end
end

-- @spec itemstack_maybe_merge(
--   base_stack: ItemStack,
--   merging_stack: ItemStack
-- ): (stack: ItemStack, leftover: ItemStack)
function foundation.com.itemstack_maybe_merge(base_stack, merging_stack)
  local result = base_stack:peek_item(base_stack:get_count())
  local leftover = result:add_item(merging_stack)
  return result, leftover
end

local function assert_itemstack_meta(itemstack)
  if not itemstack or not itemstack.get_meta then
    error("expected an itemstack with get_meta function (got " .. dump(itemstack) .. ")")
  end
end

-- @spec get_itemstack_item_description(itemstack: ItemStack): String
function foundation.com.get_itemstack_item_description(itemstack)
  local itemdef = itemstack:get_definition()

  return itemdef.description or itemstack:get_name()
end

-- @spec get_itemstack_description(itemstack: ItemStack): String
function foundation.com.get_itemstack_description(itemstack)
  assert_itemstack_meta(itemstack)
  local desc = itemstack:get_meta():get_string("description")
  if foundation.com.is_blank(desc) then
    local itemdef = itemstack:get_definition()
    return itemdef.description or itemstack:get_name()
  else
    return desc
  end
end

-- @mutative
-- @spec set_itemstack_meta_description(itemstack: ItemStack, description: String): ItemStack
function foundation.com.set_itemstack_meta_description(itemstack, description)
  assert_itemstack_meta(itemstack)
  itemstack:get_meta():set_string("description", description)
  return itemstack
end

-- @spec append_itemstack_meta_description(itemstack: ItemStack, description: String): ItemStack
function foundation.com.append_itemstack_meta_description(itemstack, description)
  local new_desc = foundation.com.get_itemstack_description(itemstack) .. description

  return foundation.com.set_itemstack_meta_description(itemstack, new_desc)
end
