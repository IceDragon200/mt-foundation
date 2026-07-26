local Class = foundation.com.Class
local table_copy = assert(foundation.com.table_copy)
local floor = assert(math.floor)
local min = assert(math.min)
local random = assert(math.random)
local table_insert = assert(table.insert)
local table_remove = assert(table.remove)

--- @since "1.12.0"
--- @class OrderedSet<T> extends Class
local OrderedSet = Class:extends("foundation.com.OrderedSet")
do
  local ic = OrderedSet.instance_class

  --- @spec #initialize(data: T[] | OrderedSet<T>): void
  function ic:initialize(data)
    ic._super.initialize(self)

    if data then
      if type(data) == "table" then
        if Class.is_object(data) then
          if data:is_instance_of(OrderedSet) then
            self:initialize_copy(data)
          elseif data.to_ordered_set then
            self:initialize_copy(data:to_ordered_set())
          else
            error("Expected object to be an instance of OrderedSet")
          end
        else
          self.m_set = {}
          self.m_data = {}
          self.m_cursor = 0

          for _, item in ipairs(data) do
            self:insert(item)
          end
        end
      else
        error("Expected a Table")
      end
    else
      self.m_set = {}
      self.m_data = {}
      self.m_cursor = 0
    end
  end

  --- @spec #initialize_copy(other: OrderedSet<T>): void
  function ic:initialize_copy(other)
    ic._super.initialize_copy(self, other)
    self.m_data = table_copy(other.m_data)
    self.m_set = table_copy(other.m_set)
  end

  --- Compares self against another ordered set to determine if they contain the same
  --- values.
  ---
  --- @spec #equals(other: OrderedSet<T>): Boolean
  function ic:equals(other)
    if Class.is_object(other, OrderedSet) then
      -- check if the lengths match, avoids the deeper check if they have
      -- mismatch lengths
      if other.m_cursor == self.m_cursor then
        if self.m_cursor > 0 then
          for i = 1,self.m_cursor do
            if other.m_data[i] ~= self.m_data[i] then
              return false
            end
          end
        end
        return true
      end
    end
    return false
  end

  --- @spec #insert(...: T[]): self
  function ic:insert(...)
    local len = select('#', ...)
    if len > 0 then
      local x
      local y
      local idx
      for i = 1,len do
        x = select(i, ...)
        idx = self.m_cursor + 1
        if self.m_cursor > 0 then
          for j = 1,self.m_cursor do
            y = self.m_data[j]
            if y == x then
              idx = 0
              break
            elseif x < y then
              idx = j
              break
            end
          end
        end

        if idx > 0 then
          self.m_cursor = self.m_cursor + 1
          table_insert(self.m_data, idx, x)
          self.m_set[x] = true
        end
      end
    end
    return self
  end

  --- @spec #concat(other: OrderedSet<T>): self
  function ic:concat(other)
    if Class.is_object(other) then
      if other:is_instance_of(OrderedSet) then
        return self:_concat_ordered_set(other)
      else
        error("unexpected object")
      end
    elseif type(other) == "table" then
      for _,item in ipairs(other) do
        self:insert(item)
      end
      return self
    else
      error("unexpected value")
    end
  end

  function ic:_concat_ordered_set(other)
    local data = other.m_data
    local len = other.m_cursor

    if len > 0 then
      for i = 1,len do
        self:insert(data[i])
      end
    end
    return self
  end

  --- Removes instance of the value in the set.
  --- @spec #delete(value: T): self
  function ic:delete(value)
    if self.m_cursor > 0 then
      for i = 1,self.m_cursor do
        if self.m_data[i] == value then
          table_remove(self.m_data, i)
          self.m_cursor = self.m_cursor - 1
          self.m_set[value] = nil
          break
        end
      end
    end
    return self
  end

  --- Take item from set and return it after deleting it from the original data.
  --- @spec #pop_at(pos: Number): T | nil
  function ic:pop_at(pos)
    if pos > 0 and pos <= self.m_cursor then
      local item = self.m_data[pos]
      table_remove(self.m_data, pos)
      self.m_cursor = self.m_cursor - 1
      self.m_set[item] = nil
      return item
    end
    return nil
  end

  --- Delete an item at the specified position, this is equivalent to a pop(pos)
  --- and discarding the returned value.
  ---
  --- @spec #delete_at(pos: Integer): self
  function ic:delete_at(pos)
    self:pop_at(pos)
    return self
  end

  --- Clears all data in the list, this will replace the internal table with an
  --- empty one, it is safe to call #data/0 before to retrieve the table.
  ---
  --- @spec #clear(): self
  function ic:clear()
    self.m_set = {}
    self.m_data = {}
    self.m_cursor = 0
    return self
  end

  --- Returns the underlying data as is, this can be used to effectively unwrap
  --- the list.
  ---
  --- @spec #data(): Table
  function ic:data()
    return self.m_data
  end

  --- Returns a shallow copy of the internal data.
  ---
  --- @spec #to_table(): Table
  function ic:to_table()
    return table_copy(self.m_data)
  end

  --- @spec #size(): Number
  function ic:size()
    return self.m_cursor
  end

  --- @spec #is_empty(): Boolean
  function ic:is_empty()
    return self.m_cursor == 0
  end

  --- @spec #get(index: Number): T | nil
  function ic:get(index)
    if self.m_cursor >= index then
      return self.m_data[index]
    end
    return nil
  end

  --- Returns true if the given value is present in the set.
  --- @spec #contains(value: T): Boolean
  function ic:contains(value)
    return self.m_set[value] ~= nil
  end

  --- Returns the first value in the list, if `len` is specified, it will
  --- return a list of the first `len` elements
  ---
  --- @spec #first(len: Integer): T[]
  --- @spec #first(): T | nil
  function ic:first(len)
    if len then
      local result = {}
      if self.m_cursor > 0 then
        for i = 1,min(len, self.m_cursor) do
          result[i] = self.m_data[i]
        end
      end
      return result
    else
      return self.m_data[1]
    end
  end

  --- Returns the last value in the list
  ---
  --- @spec #last(len: Integer): T[] | nil
  --- @spec #last(): T | nil
  function ic:last(len)
    if len then
      local result = {}
      if self.m_cursor > 0 then
        local start = 1 + self.m_cursor - min(self.m_cursor, len)
        local i = 0
        for x = start,self.m_cursor do
          i = i + 1
          result[i] = self.m_data[x]
        end
      end
      return result
    else
      return self.m_data[self.m_cursor]
    end
  end

  --- Randomly returns an element in the list, or nil if the list is empty
  ---
  --- @spec #sample(): T | nil
  function ic:sample()
    if self.m_cursor > 0 then
      return self.m_data[random(self.m_cursor)]
    end
    return nil
  end

  --- Randomly pops an element from the list and returns it
  ---
  --- @spec #pop_sample(): T | nil
  function ic:pop_sample()
    if self.m_cursor > 0 then
      local pos = random(self.m_cursor)
      return self:pop_at(pos)
    end
    return nil
  end

  --- @spec #map<T2>((item: T, index: Integer) => T2): OrderedSet<T2>
  function ic:map(callback)
    return self:reduce(OrderedSet:new(), function (item, index, acc)
      acc:insert(callback(item, index))
      return acc
    end)
  end

  --- @spec #filter((item: T, index: Integer) => Boolean): OrderedSet<T>
  function ic:filter(callback)
    return self:reduce(OrderedSet:new(), function (item, index, acc)
      if callback(item, index) then
        acc:insert(item)
      end
      return acc
    end)
  end

  --- @spec #reject((item: T, index: Integer) => Boolean): OrderedSet<T>
  function ic:reject(callback)
    return self:reduce(OrderedSet:new(), function (item, index, acc)
      if not callback(item, index) then
        acc:insert(item)
      end
      return acc
    end)
  end

  --- @spec #find(default: T2, callback: (item: T, index: Integer) => Boolean): T | T2
  function ic:find(default, callback)
    return self:reduce_while(default, function (item, index, acc)
      if callback(item, index) then
        return false, item
      else
        return true, acc
      end
    end)
  end

  --- @spec #find_index(callback: (item: T, index: Integer) => Boolean): Integer
  function ic:find_index(callback)
    return self:reduce_while(-1, function (item, index, acc)
      if callback(item, index) then
        return false, index
      else
        return true, acc
      end
    end)
  end

  --- @spec #reduce<A>(acc: A, fn: (x: T, index: Number, acc: A) => A): A
  function ic:reduce(acc, fn)
    if self.m_cursor > 0 then
      for i = 1,self.m_cursor do
        acc = fn(self.m_data[i], i, acc)
      end
    end
    return acc
  end

  --- @spec #reduce_while<A>(acc: A, (item: T, index: Integer, acc: A) => (Boolean, A)): A
  function ic:reduce_while(acc, callback)
    local should_continue
    if self.m_cursor > 0 then
      local item
      for index = 1,self.m_cursor do
        item = self.m_data[index]
        should_continue, acc = callback(item, index, acc)
        if not should_continue then
          break
        end
      end
    end
    return acc
  end

  --- @spec #each(fn: (x: T, index: Number) => void): self
  function ic:each(fn)
    if self.m_cursor > 0 then
      for i = 1,self.m_cursor do
        fn(self.m_data[i], i)
      end
    end
    return self
  end

  --- @spec #bsearch_by(predicate: (value: T, idx: Integer) => Integer): T | nil
  function ic:bsearch_by(predicate)
    assert(type(predicate) == "function", "expected predicate function")
    if self.m_cursor > 0 then
      local len = self.m_cursor
      local lo = 1
      local hi = len
      local idx
      local elem
      local res
      while lo <= hi do
        idx = lo + floor((hi - lo) / 2)
        elem = self.m_data[idx]

        res = predicate(elem, idx)

        if res > 0 then
          -- Needed item is above the idx position
          lo = idx + 1
        elseif res < 0 then
          -- Needed item is below the idx position
          hi = idx - 1
        elseif res == 0 then
          return elem, idx
        else
          error("invalid result from predicate/2, expected a value between -1 and 1")
        end
      end
    end

    return nil, nil
  end

  --- @spec #bsearch(a: T): T | nil
  function ic:bsearch(a)
    return self:bsearch_by(function (b, _bidx)
      if a == b then
        return 0
      elseif a > b then
        return 1
      elseif a < b then
        return -1
      end
    end)
  end
end

do
  local mt = OrderedSet.__imt

  --- @spec @..(other: OrderedSet<T> | T[]): OrderedSet<T>
  function mt:__concat(other)
    return self:copy():concat(other)
  end

  --- @spec #@(): Number
  function mt:__len()
    return self.m_cursor
  end
end

foundation.com.OrderedSet = OrderedSet
