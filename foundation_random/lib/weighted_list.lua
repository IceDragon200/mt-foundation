--- @namespace foundation.com

--- @class WeightedList<T>
local WeightedList = foundation.com.Class:extends("WeightedList")
local ic = assert(WeightedList.instance_class)

---
--- @spec #initialize(): void
function ic:initialize()
  ic._super.initialize(self)

  self.weights = {}
  self.weight_at_index = {}
  self.data = {}
  self.size = 0
  self.total_weight = 0
end

---
--- Push item with specific weight unto the list
---
--- @spec #push(item: T, weight: Integer): self
function ic:push(item, weight)
  assert(type(weight) == "number", "expected weight value to be a number")
  assert(weight > 0, "weight must be greater than 0")

  self.size = self.size + 1

  self.data[self.size] = item
  self.weights[self.size] = weight
  self.total_weight = self.total_weight + weight
  self.weight_at_index[self.size] = self.total_weight

  return self
end

---
--- Retrieve item in weight value
---
--- @spec #get_item_within_weight(expected_weight: Integer): (value: T, index: Integer)
function ic:get_item_within_weight(expected_weight)
  assert(type(expected_weight) == "number", "expected number for expected_weight")

  if expected_weight < 1 then
    return nil
  elseif expected_weight > self.total_weight then
    return nil
  end

  -- Binary search
  local lo = 1
  local hi = self.size
  local idx
  local weight
  local prev_weight

  while lo <= hi do
    idx = lo + math.floor((hi - lo) / 2)
    weight = self.weight_at_index[idx]
    prev_weight = self.weight_at_index[idx - 1] or 0

    if expected_weight > weight then
      -- the expected is higher than the current
      lo = idx + 1
    elseif expected_weight <= prev_weight then
      -- the expected is less than the current
      hi = idx - 1
    else
      -- within range
      return self.data[idx], idx
    end
  end

  return nil, nil
end

---
--- Randomly select an item from the list
---
--- @spec #random(): T
function ic:random()
  if self.total_weight > 0 then
    local weight = math.random(self.total_weight)
    return self:get_item_within_weight(weight)
  else
    return nil
  end
end

---
--- Retrieve a list of random items
---
--- @spec #random_list(Integer): T[]
function ic:random_list(count)
  local t = {}
  for i = 1,count do
    t[i] = self:random()
  end
  return t
end

foundation.com.WeightedList = WeightedList
