--- @namespace foundation.com.headless

--- @class InvRef
local InvRef = foundation.com.Class:extends("foundation.com.headless.InvRef")
do
  local ic = assert(InvRef.instance_class)

  --- @spec #initialize(): void
  function ic:initialize()
    --- @member.private m_data: { [name: String]: ItemStack[] }
    self.m_data = {}

    --- @member.private m_sizes: { [name: String]: Integer }
    self.m_sizes = {}
  end

  --- @spec #inspect(): String
  function ic:inspect()
    local result = "InvRef<data={"
    local data_result = {}

    for name, list in pairs(self.m_data) do
      local items = {}

      for i, item_stack in ipairs(list) do
        items[i] = item_stack:inspect()
      end

      table.insert(data_result, name .. "=" .. "{" .. table.concat(items, ", ") .. "}")
    end

    return result .. table.concat(data_result, ", ") .. "}>"
  end

  --- @spec #get_size(name: String): Integer
  function ic:get_size(name)
    assert(type(name) == "string", "expected inventory list name")

    return self.m_sizes[name] or 0
  end

  function ic:set_size(name, size)
    assert(type(name) == "string", "expected inventory list name")

    if size > 0 then
      if not self.m_data[name] then
        self.m_data[name] = {}
      end

      self.m_sizes[name] = size

      local inv = self.m_data[name]
      local isize = #inv

      if isize < size then
        for i = isize+1,size do
          inv[i] = ItemStack()
        end
      else
        for i = size,isize do
          inv[i] = nil
        end
      end
    else
      self.m_data[name] = nil
      self.m_sizes[name] = nil
    end
  end

  function ic:set_stack(name, index, item_stack)
    assert(type(name) == "string", "expected inventory list name")
    assert(type(index) == "number", "expected list index")

    item_stack = item_stack or ItemStack()

    local list = self.m_data[name]
    if list then
      if index < 0 or index > self.m_sizes[name] then
        error("index out of range")
      end

      list[index] = item_stack
      return
    end

    error("set_stack/3: undefined behaviour - no list present")
  end

  function ic:get_stack(name, index)
    assert(type(name) == "string", "expected inventory list name")
    assert(type(index) == "number", "expected list index")

    local list = self.m_data[name]
    if list then
      if index < 0 or index > self.m_sizes[name] then
        error("index out of range")
      end

      return list[index]
    end
    error("get_stack/2: undefined behaviour")
  end

  function ic:set_list(name, list)
    assert(type(name) == "string", "expected inventory list name")
    assert(type(list) == "table", "expected list")

    local size = self.m_sizes[name]
    local target_list = self.m_data[name]
    if size and target_list then
      for i = 1,size do
        target_list[i] = list[i] or ItemStack()
      end
    end
  end

  -- @spec get_list(name: String): ItemStack[]
  function ic:get_list(name)
    assert(type(name) == "string", "expected inventory list name")

    local result = {}

    local size = self.m_sizes[name]
    if size then
      for i = 1,size do
        result[i] = ItemStack(self.m_data[i])
      end
    end

    return result
  end

  function ic:add_item(name, stack)
    assert(type(name) == "string", "expected inventory list name")

    local list = self.m_data[name]

    if list then
      for _, item_stack in pairs(list) do
        stack = item_stack:add_item(stack)
      end
    end

    return stack
  end

  function ic:remove_item(name, stack)
    assert(type(name) == "string", "expected inventory list name")
    assert(stack, "expected an item stack")

    local remaining_count = stack:get_count()
    local result = ItemStack()
    local list = self.m_data[name]
    local taken

    if list then
      for _, item_stack in pairs(list) do
        if item_stack:get_name() == stack:get_name() then
          taken = item_stack:take_item(remaining_count)

          if taken:get_name() == stack:get_name() then
            result:set_name(taken:get_name())
            result:set_count(result:get_count() + taken:get_count())
            remaining_count = remaining_count - taken:get_count()
          end
        end

        if remaining_count <= 0 then
          break
        end
      end
    end

    return result
  end

  function ic:is_empty(name)
    assert(type(name) == "string", "expected inventory list name")

    local list = self.m_data[name]

    if list then
      for _, item_stack in pairs(list) do
        if not item_stack:is_empty() then
          return false
        end
      end

      return true
    end

    return true
  end

  --- @spec #contains_item(name: String, stack: ItemStack)
  function ic:contains_item(name, expected_stack)
    local list = self.m_data[name]

    if list then
      local existing_count = 0
      local expected_name = expected_stack:get_name()
      local expected_count = expected_stack:get_count()

      for _, item_stack in pairs(list) do
        if not item_stack:is_empty() then
          if item_stack:get_name() == expected_name then
            existing_count = existing_count + item_stack:get_count()
          end
        end

        if existing_count >= expected_count then
          break
        end
      end

      if existing_count >= expected_count then
        return true
      end
    end

    return false
  end

  function ic:room_for_item(name, stack)
    assert(type(name) == "string", "expected inventory list name")

    local list = self.m_data[name]

    if list then
      local remaining_count = stack:get_count()
      local expected_name = stack:get_name()

      for _, item_stack in pairs(list) do
        if item_stack:is_empty() then
          remaining_count = remaining_count - math.min(item_stack:get_stack_max(), remaining_count)
        elseif item_stack:get_name() == expected_name then
          remaining_count = math.max(remaining_count - item_stack:get_free_space(), 0)
        end

        if remaining_count <= 0 then
          break
        end
      end

      if remaining_count <= 0 then
        return true
      end
    end

    return false
  end
end

foundation.com.headless.InvRef = InvRef
