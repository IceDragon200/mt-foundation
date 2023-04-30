--- @namespace foundation.com

local Class = foundation.com.Class
local table_copy = assert(foundation.com.table_copy)

--- @class RingBuffer<T>
local RingBuffer = Class:extends("foundation.com.RingBuffer")
local ic = RingBuffer.instance_class

---
--- Initialize a RingBuffer, max_size is optional, if not given INT32_MAX (i.e. 0xFFFFFFFF) is used.
--- max_size affects how many items can live in the buffer at a time
---
--- @spec #initialize(max_size?: Integer = 0xFFFFFFFF): void
function ic:initialize(max_size)
  ic._super.initialize(self)

  self.m_max_size = max_size or 0xFFFFFFFF
  self.m_size = 0
  self.m_head = 0
  self.m_tail = 0
  self.m_data = {}
end

--- Called by #copy internally to initialize the destination buffer (self)
--- with the source buffer (other)'s data.
---
--- @spec #initialize_copy(other: RingBuffer): void
function ic:initialize_copy(other)
  self.m_data = table_copy(other.m_data)
  self.m_size = other.m_size
  self.m_head = other.m_head
  self.m_tail = other.m_tail
end

---
--- Returns a copy of the ring buffer
---
--- @spec #copy(): RingBuffer<T>
function ic:copy()
  local other = self._class:alloc()
  other:initialize_copy(self)
  return other
end

---
--- The maximum size of the buffer
---
--- @spec #max_size(): Integer
function ic:max_size()
  return self.m_max_size
end

---
--- The number of items currently in the buffer
---
--- @spec #size(): Integer
function ic:size()
  return self.m_size
end

---
--- Is the buffer empty?
---
--- @spec #is_empty(): Boolean
function ic:is_empty()
  return self.m_size < 1
end

---
--- Determines if the buffer has items at all.
---
--- @since "1.7.0"
--- @spec #has_items(): Boolean
function ic:has_items()
  return self.m_size > 0
end

---
--- Is the buffer full?
---
--- @spec #is_full(): Boolean
function ic:is_full()
  return self.m_size >= self.m_max_size
end

--- @spec #safe_push(T): self
function ic:safe_push(item)
  if self.m_size < self.m_max_size then
    self.m_size = self.m_size + 1
    -- now this may seem backwards to c programmers, but lua is indexed by 1
    self.m_head = (self.m_head % self.m_max_size) + 1
    self.m_data[self.m_head] = item
    return true
  else
    return false
  end
end

---
--- @spec #push(T): self
function ic:push(item)
  if self:safe_push(item) then
    return self
  else
    error("buffer exhautsed")
  end
end

--- @spec #pop(): T
function ic:pop()
  if self.m_size > 0 then
    self.m_tail = (self.m_tail % self.m_max_size) + 1
    local item = self.m_data[self.m_tail]
    self.m_data[self.m_tail] = nil
    self.m_size = self.m_size - 1
    return item
  end
  return nil
end

---
--- Clears data in ring and resets internal positions
---
--- @spec #clear(): T
function ic:clear()
  self.m_size = 0
  self.m_head = 0
  self.m_tail = 0
  self.m_data = {}
  return self
end

---
--- Look at the next value in the buffer without actually advancing the head
---
--- @spec #peek(): T
function ic:peek()
  if self.m_size > 0 then
    local idx = (self.m_tail % self.m_max_size) + 1
    local item = self.m_data[idx]
    return item
  end
  return nil
end

foundation.com.RingBuffer = RingBuffer
