--- @namespace foundation.com
local table_copy = assert(foundation.com.table_copy)

--- @class MinHeap<T>
local MinHeap = foundation.com.Class:extends("MinHeap")
do
  local ic = assert(MinHeap.instance_class)

  --- @spec #initialize(): void
  function ic:initialize()
    ic._super.initialize(self)

    self.m_data = {}
    self.m_weights = {}
    self.m_cursor = 0
  end

  --- Called by #copy internally to initialize the destination heap (self)
  --- with the source heap (other)'s data.
  ---
  --- @spec #initialize_copy(other: List): void
  function ic:initialize_copy(other)
    self.m_data = table_copy(other.m_data)
    self.m_weights = table_copy(other.m_weights)
    self.m_cursor = other.m_cursor
  end

  --- Returns a copy of the heap
  ---
  --- @spec #copy(): List<T>
  function ic:copy()
    local other = self._class:alloc()
    other:initialize_copy(self)
    return other
  end

  --- Returns the underlying data as is, this can be used to effectively unwrap
  --- the heap.
  ---
  --- @spec #data(): Table
  function ic:data()
    return self.m_data
  end

  --- Returns the underlying weights as is, this can be used to effectively unwrap
  --- the heap.
  ---
  --- @spec #weights(): Table
  function ic:weights()
    return self.m_weights
  end

  --- @spec #size(): Integer
  function ic:size()
    return self.m_cursor
  end

  --- Reports true if the heap contains no elements, false otherwise
  ---
  --- @spec #is_empty(): Boolean
  function ic:is_empty()
    return self.m_cursor < 1
  end

  --- Clears all data in the heap, this will replace the internal table with an
  --- empty one, it is safe to call #data/0 before to retrieve the table.
  ---
  --- @spec #clear(): self
  function ic:clear()
    self.m_data = {}
    self.m_weights = {}
    self.m_cursor = 0
    return self
  end

  function ic:_sift_up(idx)
    local pidx = math.floor(idx / 2)
    while idx > 1 and self.m_weights[idx] < self.m_weights[pidx] do
      self.m_weights[idx], self.m_weights[pidx] = self.m_weights[pidx], self.m_weights[idx]
      self.m_data[idx], self.m_data[pidx] = self.m_data[pidx], self.m_data[idx]
      idx = pidx
      pidx = math.floor(idx / 2)
    end
  end

  function ic:_sift_down(idx)
    local min_idx
    local l
    local r

    while true do
      min_idx = idx
      l = 2 * min_idx
      r = l + 1

      if l <= self.m_cursor and self.m_weights[l] < self.m_weights[min_idx] then
        min_idx = l
      end
      if r <= self.m_cursor and self.m_weights[r] < self.m_weights[min_idx] then
        min_idx = r
      end

      if min_idx == idx then
        break
      else
        self.m_weights[idx], self.m_weights[min_idx] = self.m_weights[min_idx], self.m_weights[idx]
        self.m_data[idx], self.m_data[min_idx] = self.m_data[min_idx], self.m_data[idx]
        idx = min_idx
      end
    end
  end

  --- @spec #insert(item: T, weight: Number): self
  function ic:insert(item, weight)
    self.m_cursor = self.m_cursor + 1
    self.m_data[self.m_cursor] = item
    self.m_weights[self.m_cursor] = weight
    self:_sift_up(self.m_cursor)
    return self
  end

  --- @spec #peek(): (value: T, weight: Number)
  function ic:peek()
    if self.m_cursor > 0 then
      local weight = self.m_weights[1]
      local item = self.m_data[1]
      return item, weight
    else
      return nil, nil
    end
  end

  --- @spec #pop_min(): (value: T, weight: Number)
  function ic:pop_min()
    if self.m_cursor > 0 then
      local weight = self.m_weights[1]
      local item = self.m_data[1]

      self.m_weights[1] = self.m_weights[self.m_cursor]
      self.m_data[1] = self.m_data[self.m_cursor]
      self.m_weights[self.m_cursor] = nil
      self.m_data[self.m_cursor] = nil
      self.m_cursor = self.m_cursor - 1
      self:_sift_down(1)

      return item, weight
    else
      return nil, nil
    end
  end

  --- Dumps the internal state which can be persisted (assuming the contents could be
  --- persisted to begin with).
  ---
  --- @since "1.11.0"
  --- @spec #dump_data(): Table
  function ic:dump_data()
    return {
      cursor = self.m_cursor,
      data = self.m_data,
      weights = self.m_weights,
    }
  end

  --- Loads the data dumped from `dump_data/0`, to rebuild state
  ---
  --- @since "1.11.0"
  --- @spec #load_data(data: Table): void
  function ic:load_data(data)
    self.m_cursor = data.cursor
    self.m_data = data.data
    self.m_weights = data.weights
  end
end

foundation.com.MinHeap = MinHeap
