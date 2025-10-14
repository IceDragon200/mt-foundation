--- @namespace foundation.com.headless

--- @class ItemStack
local ItemStack = foundation.com.Class:extends("foundation.com.headless.ItemStack")
do
  local ic = assert(ItemStack.instance_class)

  --- @spec #initialize(data?: Table | String): void
  function ic:initialize(data)
    self.wear = 0
    self.name = ""
    self.count = 0

    if data == "" then
      --
    elseif type(data) == "string" then
      local name, count, wear
      name, count, wear = data:match("(%g+:%g+)%s+(%d+)%s+(%d+)")
      if not name then
        name, count = data:match("(%g+:%g+)%s+(%d+)")
        wear = 0

        if not name then
          wear = 0
          count = 1
          name = data:match("(%g+:%g+)")
        end
      end

      if not name then
        error("invalid itemstring str='" .. data .. "'")
      end

      self.name = assert(name, "expected name")
      self.count = tonumber(count)
      self.wear = tonumber(wear)
    elseif type(data) == "table" then
      self.name = assert(data.name, "expected item name")
      self.count = data.count or 1
      self.wear = data.wear or 0
    elseif data == nil then
      --
    else
      error("bad argument")
    end

    assert(type(self.count) == "number")
    assert(type(self.wear) == "number")
  end

  function ic:__copy()
    local other = ItemStack:new()

    other.name = self.name
    other.count = self.count
    other.wear = self.wear

    if self.__meta then
      other.__meta = self.__meta.__copy()
    end

    return other
  end

  function ic:get_definition()
    return core.registered_items[self.name]
  end

  function ic:get_name()
    return self.name
  end

  function ic:set_name(name)
    self.name = assert(name)
  end

  function ic:get_count()
    return self.count
  end

  function ic:set_count(count)
    self.count = assert(count)
  end

  function ic:get_stack_max()
    local def = self:get_definition()
    if def and def.stack_max then
      return def.stack_max
    end
    return 99
  end

  function ic:get_free_space()
    return self:get_stack_max() - self.count
  end

  function ic:get_wear()
    return self.wear
  end

  function ic:set_wear(wear)
    self.wear = assert(wear)
  end

  function ic:get_meta()
    if not self.__meta  then
      self.__meta = MetaDataRef()
    end
    return self.__meta
  end

  function ic:clear()
    self.name = ""
    self.count = 0
    self.wear = 0
    self.__meta = nil
  end

  function ic:to_string()
    local result = self.name

    if self.count > 1 or self.wear > 0 then
      result = result .. " " .. tostring(self.count)
      if self.wear > 0 then
        result = result .. " " .. tostring(self.wear)
      end
    end

    return result
  end

  function ic:inspect()
    return "ItemStack<" .. self:to_string() .. ">"
  end

  function ic:is_empty()
    return self.count == 0
  end

  --- @spec #add_item(other: ItemStack): ItemStack
  function ic:add_item(other)
    local can_merge = self.count == 0 or self.name == ""

    if not can_merge then
      can_merge =
        self.name == other.name and
        self.wear == other.wear
    end

    if can_merge then
      local stack_max = self:get_stack_max()

      local size = self.count + other.count

      local leftover_size = size - stack_max

      self.name = other.name
      self.count = math.min(size, stack_max)
      self.wear = other.wear

      if leftover_size > 0 then
        local leftover = copy_item_stack(other)
        leftover.count = leftover_size
        return leftover
      else
        return ItemStack:new()
      end
    end

    return other
  end

  --- @spec #peek_item(count: Integer): ItemStack
  function ic:peek_item(count)
    local dest = self:__copy()
    dest.count = count
    return dest
  end

  --- @spec #take_item(count: Integer): ItemStack
  function ic:take_item(count)
    local max_takeable = math.max(math.min(count, self.count), 0)

    local dest = self:__copy()
    dest.count = count

    self.count = self.count - dest.count

    if self.count == 0 then
      self.name = ""
      self.wear = 0
    end

    return dest
  end

  --- @spec #equals(other: ItemStack): Boolean
  function ic:equals(other)
    if self.name ~= other.name then
      return false
    end

    if self.count ~= other.count then
      return false
    end

    if self.wear ~= other.wear then
      return false
    end

    return true
  end
end

foundation.com.headless.ItemStack = ItemStack
