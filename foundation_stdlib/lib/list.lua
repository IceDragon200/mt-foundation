function foundation.com.list_slice(t, start, len)
  local result = {}

  local j = 1
  for i = start,start+len do
    result[j] = t[i]
    j = j + 1
  end
  return result
end

function foundation.com.list_last(t, count)
  if count then
    count = math.min(#t, count)
    return foundation.com.list_slice(t, #t - count + 1, count)
  else
    return t[#t]
  end
end

function foundation.com.list_reverse(list)
  -- https://forums.coronalabs.com/topic/61784-function-for-reversing-table-order/
  local j = #list
  local i = 1
  while i < j do
    list[i], list[j] = list[j], list[i]
    i = i + 1
    j = j - 1
  end
  return list
end

function foundation.com.list_reduce(list, acc, fun)
  local should_break
  for _, v in ipairs(list) do
    acc, should_break = fun(v, acc)
    if should_break then
      break
    end
  end
  return acc
end

-- Perform a reduce map on the specified list, this will return a new list
-- where elements were transformed by 'fun'
function foundation.com.list_map(list, fun)
  return foundation.com.list_reduce(list, {}, function (value, acc)
    table.insert(acc, fun(value))
    return acc, false
  end)
end

-- Selects and returns a random value in the specified list
function foundation.com.list_sample(l)
  local c = #l
  return l[math.random(c)]
end

-- Retrieves the next value after the specified 'current'
function foundation.com.list_get_next(list, current)
  -- returns the next element in a list given the current value,
  -- if the current is nil,
  -- it will return the first element in the list
  if current then
    local index = foundation.com.table_key_of(list, current)
    if index then
      -- adjust the index by -1
      local index0 = index - 1
      -- then increment the 0-ed index and modulo it against the size of the list
      local next_index = (index0 + 1) % #list
      -- finally return the next element by incrementing the new_index by 1 to return it to normal
      return list[next_index + 1]
    else
      return list[1]
    end
  else
    return list[1]
  end
end

--
-- Combines multiple list-like tables into a single resultant list
-- Not to be confused with table.concat,
-- which is actually a 'join' in other languages.
--
function foundation.com.list_concat(...)
  local result = {}
  local i = 1
  for _,t in ipairs({...}) do
    for _,element in ipairs(t) do
      result[i] = element
      i = i + 1
    end
  end
  return result
end

--
-- Returns a new list with only unique values
--
function foundation.com.list_uniq(l)
  local seen = {}
  local result = {}
  for _,e in ipairs(l) do
    if not seen[e] then
      seen[e] = true
      table.insert(result, e)
    end
  end
  return result
end
