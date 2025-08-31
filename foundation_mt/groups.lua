-- @namespace foundation.com.Groups
local Groups = {}

local NO_GROUPS = {}

-- @spec get(Any): Table
function Groups.get(object)
  return object.groups or NO_GROUPS
end

-- @spec get_item_groups(name: String): Table
function Groups.get_item_groups(name)
  local item = core.registered_items[name]
  if item then
    return item.groups or NO_GROUPS
  end
  return NO_GROUPS
end

-- Attempts to retrieve the object's groups, if the groups are not set, then
-- a groups table will be set on the given object.
--
-- @spec patch_get(object: Any): Table
function Groups.patch_get(object)
  if not object.groups then
    object.groups = {}
  end
  return object.groups
end

-- Retrieve a group's value from the given object
--
-- @spec get_item(object: Any, name: String): nil | Integer
function Groups.get_item(object, name)
  return Groups.get(object)[name]
end

-- Sets group by `name` on given `object` to `value`
--
-- @spec put_item(object: T, name: String, value: Integer): T
function Groups.put_item(object, name, value)
  Groups.patch_get(object)[name] = value
  return object
end

-- Determines if the given object has a group by name, with an optional rank.
-- When the optional rank is provided the group will only be considered if it
-- has a value greater than or equal to the optional rank
--
-- @spec has_group(object: Any, name: String, optional_rank?: Integer): Boolean
function Groups.has_group(object, name, optional_rank)
  if object and object.groups then
    local value = object.groups[name]
    if value then
      if optional_rank then
        return value >= optional_rank
      else
        return value > 0
      end
    end
  end
  return false
end

-- Determines if the given item (by name) has the specified group, with an optional rank.
--
-- @spec item_has_group(name: String, group_name: String, optional_rank: Integer): Boolean
function Groups.item_has_group(name, group_name, optional_rank)
  local rank = core.get_item_group(name, group_name)
  if rank and rank > 0 then
    if optional_rank then
      return rank >= optional_rank
    else
      return true
    end
  end
  return false
end

foundation.com.Groups = Groups
