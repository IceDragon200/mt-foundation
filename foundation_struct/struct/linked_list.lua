--
-- Singlely linked list, suitable for Queues
--
local Class = assert(foundation.com.Class)

-- @namespace foundation.com

-- @since "1.2.0"
-- @class LinkedList<T>
local LinkedList = Class:extends("LinkedList")
local ic = LinkedList.instance_class

-- @type LinkedList.Node<T>: {
--   value: T,
--   next: LinkedList.Node<T> | nil,
-- }

-- @spec linked_list_next(LinkedList<T>, LinkedList.Node<T>): (LinkedList.Node<T>, T) | nil
local function linked_list_next(ll, node)
  node = node.next

  if node then
    return node, node.value
  else
    return nil
  end
end

-- @spec #initialize(): void
function ic:initialize(value)
  -- kind of useless assignments, but gives an idea of the structure
  self.next = nil
  self.tail = nil

  if value then
    if type(value) == "table" then
      if Class.is_object(value) then
        if value:is_instance_of(LinkedList) then
          self:initialize_copy(value)
        elseif value.to_linked_list then
          self:initialize_copy(value:to_linked_list())
        else
          error("unexpected object")
        end
      else
        for _, item in ipairs(value) do
          self:push(item)
        end
      end
    else
      error("unexpected initialized value")
    end
  end
end

-- @spec #initialize_copy(LinkedList<T>): void
function ic:initialize_copy(other)
  for _, item in other:each() do
    self:push(item)
  end
end

-- @spec #copy(): LinkedList<T>
function ic:copy()
  local ll = self._class:alloc()
  ll:initialize_copy(self)
  return ll
end

-- @spec #to_linked_list(): LinkedList<T>
function ic:to_linked_list()
  return self
end

-- @spec #to_table(): Table
function ic:to_table()
  local result = {}
  local i = 0
  local node = self.next

  while node do
    i = i + 1
    result[i] = node.value
    node = node.next
  end

  return result
end

-- @spec #size(): Integer
function ic:size()
  local len = 0
  local node = self.next

  while node do
    len = len + 1
    node = node.next
  end

  return len
end

-- @spec #shift_node(): LinkedList.Node<T> | nil
function ic:shift_node()
  local node
  if self.next then
    node = self.next
    if node == self.tail then
      self.next = nil
      self.tail = nil
    else
      self.next = node.next
    end
  end
  return node
end

-- @spec #shift(): T | nil
function ic:shift(len)
  local node

  if len then
    local result = {}
    local i = 0
    local x = len

    while x > 0 do
      x = x - 1
      node = self:shift_node()
      if node then
        i = i + 1
        result[i] = node.value
      else
        break
      end
    end

    return result
  else
    node = self:shift_node()

    if node then
      return node.value
    end
    return nil
  end
end

-- @spec #push(...): self
function ic:push(...)
  local len = select('#', ...)
  local value
  local node

  if len > 0 then
    for i = 1,len do
      value = select(i, ...)

      node = {
        value = value,
      }

      if self.tail then
        self.tail.next = node
        self.tail = node
      else
        self.next = node
        self.tail = node
      end
    end
  end

  return self
end

-- @spec #first_node(): LinkedList.Node<T> | nil
function ic:first_node()
  return self.next
end

-- @spec #first(): T | nil
function ic:first()
  local node = self:first_node()

  if node then
    return node.value
  end

  return nil
end

-- @spec #last_node(): LinkedList.Node<T> | nil
function ic:last_node()
  return self.tail
end

-- @spec #last(): T | nil
function ic:last()
  local node = self:last_node()

  if node then
    return node.value
  end

  return nil
end

-- Retrieve a node by index
--
-- @spec #get_node(Integer): LinkedList.Node<T> | nil
function ic:get_node(index)
  if index > 0 then
    local i = 0
    local node = self.next

    while node do
      i = i + 1

      if i == index then
        return node
      end

      node = node.next
    end
  end

  return nil
end

-- Retrieve an item by index
--
-- @spec #get(Integer): T | nil
function ic:get(index)
  local node = self:get_node(index)

  if node then
    return node.value
  end

  return nil
end

-- @spec #each(): (Function, LinkedList, LinkedList)
-- @spec #each(Function/2): self
function ic:each(callback)
  if callback then
    local node = self.next

    while node do
      callback(node.value, node)
      node = node.next
    end

    return self
  end

  return linked_list_next, self, self
end

foundation.com.LinkedList = LinkedList
