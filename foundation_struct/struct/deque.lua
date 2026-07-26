local Class = foundation.com.Class
local table_copy = assert(foundation.com.table_copy)

--- @namespace balm.s

--- @since "1.12.0"
--- @class Deque<T>
local Deque = Class:extends("foundation.com.Deque")
do
  local ic = Deque.instance_class

  --- @override
  --- @spec #initialize(data: Any): void
  function ic:initialize(data)
    ic._super.initialize(self)
    self.m_head = 0
    self.m_tail = 0
    self.m_data = {}
    if data then
      if Class.is_object(data) then
        self:initialize_from_object(data)
      elseif type(data) == "table" then
        self:concat(data)
      else
        error("unexpected data")
      end
    end
  end

  --- @override
  --- @spec #initialize_copy(other: Deque): void
  function ic:initialize_copy(other)
    ic._super.initialize_copy(self, other)
    self.m_data = table_copy(other.m_data)
  end

  --- @spec #initialize_from_object(other: Class): void
  function ic:initialize_from_object(other)
    if other:is_instance_of(Deque) then
      self:merge(other.m_data)
    else
      error("unexpected object")
    end
  end

  --- @spec #is_empty(): Boolean
  function ic:is_empty()
    return self.m_head == self.m_tail
  end

  --- @spec #size(): Number
  function ic:size()
    return self.m_tail - self.m_head
  end

  --- @since "2026.5.23"
  --- @spec #clear(): self
  function ic:clear()
    self.m_head = 0
    self.m_tail = 0
    self.m_data = {}
    return self
  end

  --- @spec #push(item: T): self
  function ic:push(item)
    self.m_data[self.m_tail] = item
    self.m_tail = self.m_tail + 1
    return self
  end

  --- @spec #unshift(item: T): self
  function ic:unshift(item)
    self.m_head = self.m_head - 1
    self.m_data[self.m_head] = item
    return self
  end

  --- @spec #concat(data: T[]): self
  function ic:concat(data)
    for _, item in ipairs(data) do
      self:push(item)
    end
    return self
  end

  --- @spec #merge(other: Deque): self
  function ic:merge(other)
    if other:size() > 0 then
      for i = other.m_head,other.m_tail do
        self:push(other.m_data[i])
      end
    end
    return self
  end

  --- @spec #pop(): T | nil
  function ic:pop()
    if self.m_tail > self.m_head then
      self.m_tail = self.m_tail - 1
      local item = self.m_data[self.m_tail]
      self.m_data[self.m_tail] = nil
      self:maybe_zero()
      return item
    end
    return nil
  end

  --- @spec #shift(): T | nil
  function ic:shift()
    if self.m_head < self.m_tail then
      local item = self.m_data[self.m_head]
      self.m_data[self.m_head] = nil
      self.m_head = self.m_head + 1
      self:maybe_zero()
      return item
    end
    return nil
  end

  --- @spec #peek_first(): T | nil
  function ic:peek_first()
    if self.m_head < self.m_tail then
      return self.m_data[self.m_head]
    end
    return nil
  end

  --- @spec #peek_last(): T | nil
  function ic:peek_last()
    if self.m_tail > self.m_head then
      return self.m_data[self.m_tail]
    end
    return nil
  end

  --- @spec #maybe_zero(): void
  function ic:maybe_zero()
    if self.m_head == self.m_tail then
      self.m_head = 0
      self.m_tail = 0
    end
  end
end

foundation.com.Deque = Deque
