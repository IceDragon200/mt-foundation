function foundation.com.itemstack_is_blank(stack)
  if stack then
    -- return foundation.com.is_blank(stack:get_name()) or stack:get_count() == 0
    return stack:is_empty()
  else
    return true
  end
end

function foundation.com.itemstack_copy(stack)
  return stack:peek_item(stack:get_count())
end

function foundation.com.itemstack_get_itemdef(stack)
  if not foundation.com.itemstack_is_blank(stack) then
    local name = stack:get_name()
    return minetest.registered_items[name]
  end
  return nil
end

function foundation.com.itemstack_has_group(stack, group_name, optional_value)
  local itemdef = foundation.com.itemstack_get_itemdef(stack)
  if itemdef then
    return foundation.com.Groups.has_group(itemdef, group_name, optional_value)
  else
    return false
  end
end

function foundation.com.itemstack_inspect(stack)
  if stack then
    return "stack[" .. stack:get_name() .. "/" .. stack:get_count() .. "]"
  else
    return "nil"
  end
end

function foundation.com.itemstack_new_blank()
  return ItemStack({
    name = "",
    count = 0,
    wear = 0
  })
end

-- A non-destructive version of ItemStack#take_item,
-- this will return the taken stack as the first value and the remaining as the second
function foundation.com.itemstack_split(stack, length)
  local max = stack:get_count()
  local takable = math.min(length, max)
  if takable == max then
    return stack, foundation.com.itemstack_new_blank()
  else
    return stack:peek_item(takable), stack:peek_item(max - takable)
  end
end

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

function foundation.com.get_itemstack_item_description(itemstack)
  local itemdef = itemstack:get_definition()

  return itemdef.description or itemstack:get_name()
end

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

function foundation.com.set_itemstack_meta_description(itemstack, description)
  assert_itemstack_meta(itemstack)
  itemstack:get_meta():set_string("description", description)
  return itemstack
end

function foundation.com.append_itemstack_meta_description(itemstack, description)
  local new_desc = foundation.com.get_itemstack_description(itemstack) .. description

  return foundation.com.set_itemstack_meta_description(itemstack, new_desc)
end
