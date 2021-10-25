-- @namespace foundation.com

local Class = foundation.com.Class
local table_copy = assert(foundation.com.table_copy)

-- @class List<T>
local List = Class:extends("foundation.com.List")
local ic = List.instance_class

-- @spec list_next(List<T>, Integer): (Integer, T) | nil
local function list_next(list, index)
  index = index + 1
  if index > list.m_cursor then
    return nil
  else
    return index, list.m_data[index]
  end
end

List.list_next = list_next

-- @spec #initialize(data?: T[] | List<T>): void
function ic:initialize(data)
  ic._super.initialize(self)

  if data then
    if type(data) == "table" then
      if Class.is_object(data) then
        if data:is_instance_of(List) then
          self:initialize_copy(data)
        elseif data.to_list then
          self:initialize_copy(data:to_list())
        else
          error("Expected object to be an instance of List")
        end
      else
        self.m_data = {}
        self.m_cursor = 0

        for _, item in ipairs(data) do
          self.m_cursor = self.m_cursor + 1
          self.m_data[self.m_cursor] = item
        end
      end
    else
      error("Expected a Table")
    end
  else
    self.m_data = {}
    self.m_cursor = 0
  end
end

-- Returns itself, but is an interface function for other classes to implement
--
-- @since "1.1.0"
-- @spec #to_list(): List<T>
function ic:to_list()
  return self
end

-- Compares self against another list to determine if they contain the same
-- values.
--
-- @spec #equals(other: List): Boolean
function ic:equals(other)
  if foundation.com.Class.is_object(other, List) then
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

-- Called by #copy internally to initialize the destination list (self)
-- with the source list (other)'s data.
--
-- @spec #initialize_copy(other: List): void
function ic:initialize_copy(other)
  self.m_data = table_copy(other.m_data)
  self.m_cursor = other.m_cursor
end

-- Returns a copy of the list
--
-- @spec #copy(): List<T>
function ic:copy()
  local list = self._class:alloc()
  list:initialize_copy(self)
  return list
end

-- Returns the underlying data as is, this can be used to effectively unwrap
-- the list.
--
-- @spec #data(): Table
function ic:data()
  return self.m_data
end

-- Returns a shallow copy of the internal data.
--
-- @spec #to_table(): Table
function ic:to_table()
  return table_copy(self.m_data)
end

-- Reverses the data in the list
--
-- @spec #reverse(): self
function ic:reverse()
  -- check if there is more than 1 item in the list to reverse it
  if self.m_cursor > 1 then
    local half = math.floor(self.m_cursor / 2)
    local tmp
    local x2

    for x = 1,half do
      x2 = 1 + self.m_cursor - x
      local tmp = self.m_data[x2]
      self.m_data[x2] = self.m_data[x]
      self.m_data[x] = tmp
    end
  end
  return self
end

-- Clears all data in the list, this will replace the internal table with an
-- empty one, it is safe to call #data/0 before to retrieve the table.
--
-- @spec #clear(): self
function ic:clear()
  self.m_data = {}
  self.m_cursor = 0
  return self
end

-- Pushes the item unto the list.
-- Yes, you can push nil.
--
-- @spec #push(T): self
function ic:push(...)
  local len = select('#', ...)
  for i = 1,len do
    local item = select(i, ...)
    self.m_cursor = self.m_cursor + 1
    self.m_data[self.m_cursor] = item
  end
  return self
end

-- Concatenates one list into the target list.
--
-- @since "1.1.0"
-- @spec #concat(other: List<T> | Table | {#to_list<T>}): self
function ic:concat(other)
  if Class.is_object(other) then
    if other:is_instance_of(List) then
      return self:_concat_list(other)
    elseif other.to_list then
      return self:_concat_list(other:to_list())
    else
      error("unexpected object")
    end
  elseif type(other) == "table" then
    for _,item in ipairs(other) do
      self.m_cursor = self.m_cursor + 1
      self.m_data[self.m_cursor] = item
    end
    return self
  else
    error("unexpected value")
  end
end

function ic:_concat_list(list)
  local data = list.m_data
  local len = list.m_cursor

  if len > 0 then
    for i = 1,len do
      self.m_cursor = self.m_cursor + 1
      self.m_data[self.m_cursor] = data[i]
    end
  end
  return self
end

-- Removes the first element or elements in the list and returns them
--
-- @since "1.1.0"
-- @spec #shift(len: Integer): T[] | nil
-- @spec #shift(): T | nil
function ic:shift(len)
  local item
  local data
  local i

  if len then
    local result = {}

    if self.m_cursor > 0 then
      len = math.min(self.m_cursor, len)
      for x = 1,len do
        result[x] = self.m_data[x]
      end

      data = self.m_data
      self.m_data = {}

      if self.m_cursor > len then
        i = 0
        for x = len+1,self.m_cursor do
          i = i + 1
          self.m_data[i] = data[x]
        end
      end

      self.m_cursor = self.m_cursor - len
    end

    return result
  else
    if self.m_cursor > 0 then
      item = self.m_data[1]

      if self.m_cursor == 1 then
        self.m_data[1] = nil
        self.m_cursor = self.m_cursor - 1
      else
        data = self.m_data
        self.m_data = {}
        i = 0
        len = self.m_cursor
        self.m_cursor = self.m_cursor - 1
        for x = 2,len do
          i = i + 1
          self.m_data[i] = data[x]
        end
      end

      return item
    end

    return nil
  end
end

-- Pops the last item in the list.
-- A `len` is specified it will attempt to pop that many items from the list and
-- return a table containing those items.
--
-- @spec #pop(len: Integer): T[] | nil
-- @spec #pop(): T | nil
function ic:pop(len)
  local item
  if len then
    local result = {}
    if self.m_cursor > 0 then
      local start = 1 + self.m_cursor - math.min(len, self.m_cursor)
      local tail = self.m_cursor
      local i = 0

      for x = start,tail do
        item = self.m_data[x]
        self.m_data[x] = nil
        self.m_cursor = self.m_cursor - 1
        i = i + 1
        result[i] = item
      end
    end
    return result
  else
    if self.m_cursor > 0 then
      item = self.m_data[self.m_cursor]
      self.m_data[self.m_cursor] = nil
      self.m_cursor = self.m_cursor - 1
      return item
    end
  end
  return nil
end

-- Pops the item at the specified position, this will rebuild the internal
-- table if the position is not at the end of the list.
--
-- @spec #pop_at(pos: Integer): T | nil
function ic:pop_at(pos)
  local item
  if pos > 0 and pos <= self.m_cursor then
    if pos == self.m_cursor then
      item = self.m_data[pos]
      self.m_data[pos] = nil
      self.m_cursor = self.m_cursor - 1
      return item
    else
      item = self.m_data[pos]
      local data = self.m_data
      self.m_data = {}
      local i = 0
      local len = self.m_cursor
      self.m_cursor = self.m_cursor - 1
      for x = 1,len do
        if x == pos then
          --
        else
          i = i + 1
          self.m_data[i] = data[x]
        end
      end
      return item
    end
  end
  return nil
end

-- Delete an item at the specified position, this is equivalent to a pop(pos)
-- and discarding the returned value.
--
-- @spec #delete_at(pos: Integer): self
function ic:delete_at(pos)
  self:pop_at(pos)
  return self
end

-- @spec #size(): Integer
function ic:size()
  return self.m_cursor
end

-- Tries to put the item in a selected list at position.
-- Returns true if the item was placed, false otherwise.
--
-- @spec #put_at(pos: Integer, item: T): Boolean
function ic:put_at(pos, item)
  if pos > 0 and pos <= self.m_cursor then
    self.m_data[pos] = item
    return true
  end
  return false
end

-- Retrieve item at position
--
-- @spec #get(pos: Integer): T | nil
function ic:get(pos)
  return self.m_data[pos]
end

-- Returns the first value in the list, if `len` is specified, it will
-- return a list of the first `len` elements
--
-- @spec #first(len: Integer): T[]
-- @spec #first(): T | nil
function ic:first(len)
  if len then
    local result = {}
    if self.m_cursor > 0 then
      for i = 1,math.min(len, self.m_cursor) do
        result[i] = self.m_data[i]
      end
    end
    return result
  else
    return self.m_data[1]
  end
end

-- Returns the last value in the list
--
-- @spec #last(len: Integer): T[] | nil
-- @spec #last(): T | nil
function ic:last(len)
  if len then
    local result = {}
    if self.m_cursor > 0 then
      local start = 1 + self.m_cursor - math.min(self.m_cursor, len)
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

-- Randomly returns an element in the list, or nil if the list is empty
--
-- @spec #sample(): T | nil
function ic:sample()
  if self.m_cursor > 0 then
    return self.m_data[math.random(self.m_cursor)]
  end
  return nil
end

-- Randomly pops an element from the list and returns it
--
-- @spec #pop_sample(): T | nil
function ic:pop_sample()
  if self.m_cursor > 0 then
    local pos = math.random(self.m_cursor)
    return self:pop_at(pos)
  end
  return nil
end

-- @since "1.1.0"
-- @spec #reduce(Any, Function/3): Any
function ic:reduce(acc, callback)
  if self.m_cursor > 0 then
    for index, item in list_next,self,0 do
      acc = callback(item, index, acc)
    end
  end
  return acc
end

-- @since "1.1.0"
-- @spec #each(): (Function, List<T>, Integer)
-- @spec #each(Function/1): self
function ic:each(callback)
  if callback then
    if self.m_cursor > 0 then
      for index, item in list_next,self,0 do
        callback(item, index)
      end
    end
    return self
  end

  return list_next, self, 0
end

-- @since "1.1.0"
-- @spec #map(Function<T>/1): List<T>
function ic:map(callback)
  return self:reduce(List:new(), function (item, index, acc)
    acc:push(callback(item, index))
    return acc
  end)
end

foundation.com.List = List
