-- @namespace foundation.com

-- @class WeightedList
local WeightedList = foundation.com.Class:extends("WeightedList")
local ic = assert(WeightedList.instance_class)

--
-- @spec #initialize(): void
function ic:initialize()
  self.weights = {}
  self.weight_at_index = {}
  self.data = {}
  self.size = 0
  self.total_weight = 0
end

--
-- Push item with specific weight unto the list
--
-- @spec #push(item: Any, weight: Integer): self
function ic:push(item, weight)
  assert(weight, "need a weight")
  assert(weight > 0, "weight must be greater than 0")

  self.size = self.size + 1

  self.data[self.size] = item
  self.weights[self.size] = weight
  self.total_weight = self.total_weight + weight
  self.weight_at_index[self.size] = self.total_weight

  return self
end

--
-- Retrieve item in weight value
--
-- @spec #get_item_within_weight(weight: Integer): Any
function ic:get_item_within_weight(weight)
  if weight < 1 then
    return nil
  elseif weight > self.total_weight then
    return nil
  end

  local index = 1
  local prev_weight = 0
  local current_weight

  while index <= self.size do
    current_weight = self.weight_at_index[index]

    if weight >= prev_weight and weight <= current_weight then
      return self.data[index]
    else
      index = index + 1
    end
  end

  -- Binary search
  -- local index = math.floor(self.size / 2)
  -- local iterations = 0

  -- local current_weight
  -- local prev_weight

  -- while true do
  --   if iterations > self.size then
  --     error("stalled: index=" .. index)
  --   end

  --   current_weight = self.weight_at_index[index]
  --   prev_weight = self.weight_at_index[index - 1] or 0

  --   if weight > current_weight then
  --     -- currently behind
  --     index = index + math.floor((self.size - index + 1) / 2)
  --   elseif weight < prev_weight then
  --     -- currently ahead
  --     index = math.floor(index / 2)
  --   else
  --     -- within range
  --     return self.data[index]
  --   end

  --   iterations = iterations + 1
  -- end
end

--
-- Randomly select an item from the list
--
-- @spec #random(): Any
function ic:random()
  if self.total_weight > 0 then
    local weight = math.random(self.total_weight)
    return self:get_item_within_weight(weight)
  else
    return nil
  end
end

--
-- Retrieve a list of random items
--
-- @spec #random_list(Integer): Any[]
function ic:random_list(count)
  local t = {}
  for i = 1,count do
    t[i] = self:random()
  end
  return t
end

foundation.com.WeightedList = WeightedList
