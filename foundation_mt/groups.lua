local Groups = {}

local NO_GROUPS = {}

function Groups.get(object)
  return object.groups or NO_GROUPS
end

function Groups.get_item_groups(name)
  local item = minetest.registered_items[name]
  if item then
    return item.groups or NO_GROUPS
  end
  return NO_GROUPS
end

function Groups.patch_get(object)
  if not object.groups then
    object.groups = {}
  end
  return object.groups
end

function Groups.get_item(object, key)
  return Groups.get(object)[key]
end

function Groups.put_item(object, key, value)
  Groups.patch_get(object)[key] = value
  return object
end

function Groups.has_group(object, name, optional_rank)
  if object.groups then
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

function Groups.item_has_group(name, group_name, optional_rank)
  local rank = minetest.get_item_group(name, group_name)
  if rank and rank > 0 then
    if optional_rank then
      return value >= optional_rank
    else
      return true
    end
  end
  return false
end

foundation.com.Groups = Groups
