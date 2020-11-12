local WeightedList = foundation.com.Class:extends("WeightedList")

local ic = assert(WeightedList.instance_class)

function ic:initialize()
  self.weights = {}
  self.weight_at_index = {}
  self.data = {}
  self.size = 0
  self.total_weight = 0
end

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
      print(index, weight, prev_weight, current_weight, "behind")
      -- currently behind
      index = index + math.floor((self.size - index + 1) / 2)
    elseif weight < prev_weight then
      print(index, weight, prev_weight, current_weight, "ahead")
      -- currently ahead
      index = math.floor(index / 2)
    elseif weight > prev_weight and weight <= current_weight then
      -- within range
      return self.data[index]
    end
    iterations = iterations + 1
  end
end

function ic:random()
  if self.total_weight > 0 then
    local weight = math.random(self.total_weight)
    return self:get_item_within_weight(weight)
  else
    return nil
  end
end

foundation.com.WeightedList = WeightedList
