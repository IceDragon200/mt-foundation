local WeightedList = foundation.com.Class:extends("WeightedList")

local ic = assert(WeightedList.instance_class)

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
-- @spec :push(term, Integer) :: self
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
-- @spec :get_item_within_weight(weight::Integer) :: term
function ic:get_item_within_weight(weight)
  if weight < 1 then
    return nil
  elseif weight > self.total_weight then
    return nil
  end

  local index = math.floor(self.size / 2)
  local iterations = 0

  while true do
    if iterations > self.size then
      error("stalled")
    end

    local current_weight = self.weight_at_index[index]
    local prev_weight = self.weight_at_index[index - 1] or 0

    if weight > current_weight then
      -- currently behind
      index = index + math.floor((self.size - index + 1) / 2)
    elseif weight < prev_weight then
      -- currently ahead
      index = math.floor(index / 2)
    elseif weight > prev_weight and weight <= current_weight then
      -- within range
      return self.data[index]
    end

    iterations = iterations + 1
  end
end

--
-- Randomly select an item from the list
--
-- @spec :random() :: term
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
-- @spec :random_list(Integer) :: {term}
function ic:random_list(count)
  local t = {}
  for i = 1,count do
    t[i] = self:random()
  end
  return t
end

foundation.com.WeightedList = WeightedList
