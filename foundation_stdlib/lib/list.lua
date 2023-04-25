--- @namespace foundation.com
local CROCKFORD_BASE32_ENCODE_TABLE = assert(foundation.com.CROCKFORD_BASE32_ENCODE_TABLE)

local POW2 = {}

for x = 0,31 do
  POW2[x] = math.pow(2, x * 8)
end

--- Encodes a list of integers or strings as crawford base32, the list should contain interspersed
--- values
--- That is the odd numbered parameters should be the integer length, followed by the integer
---
--- Usage:
---    list_crawford_base32_le_rolling_encode_table(4, int32, 2, int16, 6, int48) -- => Table
---
--- @spec list_crawford_base32_le_rolling_encode_table(
---   ...(int_len: Integer, int: Integer | String)
--- ): Table
function foundation.com.list_crawford_base32_le_rolling_encode_table(...)
  local items = {...}
  local len = #items
  local len1 = len + 1
  local i = 1
  local acc = 0
  local po
  local slen
  local ilen
  local item
  local int
  local str
  local segments
  local value
  local result = {}
  local r = 1

  while i < len1 do
    -- integer length in bytes
    ilen = items[i]
    -- the integer
    item = items[i + 1]
    -- increment the items counter
    i = i + 2
    -- determine the number segments that is the integer's byte count (as bits)
    -- divided by the base32 bit length (5), floored
    segments = math.floor(ilen * 8 / 5)

    if type(item) == "string" then
      str = item
      int = 0
      slen = string.len(str)
      po = 0

      for j = 1,slen do
        value = string.byte(str, j)
        int = int + value * POW2[po]
        po = po + 1
      end
    elseif type(item) == "number" then
      int = item
    else
      error("unexpected item")
    end

    int = math.floor(int)

    for _ = 1,segments do
      -- add 5 bits of the int to the accumulator
      acc = acc + (int % 32)
      -- modulo the accumulator to get the next value
      value = acc % 32
      -- reduce the accumulator
      acc = math.floor(acc / 32)
      -- reduce the primary integer
      int = math.floor(int / 32)
      -- write the encoded value
      result[r] = CROCKFORD_BASE32_ENCODE_TABLE[value]
      -- increment the result index
      r = r + 1
    end
  end

  while acc > 0 do
    value = acc % 32
    acc = math.floor(acc / 32)
    result[r] = CROCKFORD_BASE32_ENCODE_TABLE[value]
    r = r + 1
  end

  return result
end

--- @spec list_slice(Table, start: Integer, len: Integer): Table
function foundation.com.list_slice(t, start, len)
  local result = {}

  local j = 1
  for i = start,start+len do
    result[j] = t[i]
    j = j + 1
  end
  return result
end

local list_slice = foundation.com.list_slice

--- @spec list_last(Table, count: Integer): Any
function foundation.com.list_last(t, count)
  if count then
    count = math.min(#t, count)
    return list_slice(t, #t - count + 1, count)
  else
    return t[#t]
  end
end

--- @spec list_reverse(list: Table): Table
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

--- @spec list_reduce(list: Table, acc: Any, fun: Function/2): Any
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

local list_reduce = foundation.com.list_reduce

--- Perform a reduce map on the specified list, this will return a new list
--- where elements were transformed by 'fun'
---
--- @spec list_map(Table, ReducerFunction): Table
function foundation.com.list_map(list, fun)
  return list_reduce(list, {}, function (value, acc)
    table.insert(acc, fun(value))
    return acc, false
  end)
end

--- Selects and returns a random value in the specified list
---
--- @spec list_sample(list: Table): Any
function foundation.com.list_sample(list)
  local c = #list
  return list[math.random(c)]
end

--- Retrieves the next value after the specified 'current'
---
--- @spec list_get_next(list: Table, current: Any): Any
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

---
--- Combines multiple list-like tables into a single resultant list
--- Not to be confused with table.concat,
--- which is actually a 'join' in other languages.
---
--- @spec list_concat(...Table): Table
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

---
--- Returns a new list with only unique values
---
--- @spec list_uniq(list: Table): Table
function foundation.com.list_uniq(list)
  local seen = {}
  local result = {}
  for _,e in ipairs(list) do
    if not seen[e] then
      seen[e] = true
      table.insert(result, e)
    end
  end
  return result
end

--- @spec list_split(list: Table, alen: Integer): (Table, Table)
function foundation.com.list_split(list, alen)
  local head = {}
  local tail = {}

  local source_len = #list

  if source_len > 0 then
    if alen > 0 then
      for i = 1,math.min(alen, source_len) do
        head[i] = list[i]
      end
    end

    if source_len > alen then
      local j = 0
      for i = alen+1,source_len do
        j = j + 1
        tail[j] = list[i]
      end
    end
  end

  return head, tail
end

---
--- Sorts given list, I do not guarantee any performance, this is the easiest possible sort
---
--- @mutative
--- @spec #list_sort(list: Table): Table
function foundation.com.list_sort(list)
  if next(list) then
    local size = #list
    local a
    local b

    for i = 1,size do
      a = list[i]
      for j = i,size do
        b = list[j]

        if a > b then
          list[i] = b
          list[j] = a
          a = b
        end
      end
    end
  end

  return list
end

---
--- Sorts given list, I do not guarantee any performance, this is the easiest possible sort
---
--- @since "1.26.0"
--- @mutative
--- @spec #list_sort_by(list: Table, callback: Function/2): Table
function foundation.com.list_sort_by(list, callback)
  if next(list) then
    local size = #list
    local a
    local b
    local weights = {}
    local tmp
    local tmp2

    for i = 1,size do
      weights[i] = callback(list[i], i)
    end

    for i = 1,size do
      a = weights[i]
      for j = i,size do
        b = weights[j]

        if a > b then
          tmp = list[i]
          list[i] = list[j]
          list[j] = tmp
          tmp2 = weights[i]
          weights[i] = weights[j]
          weights[j] = tmp2
          a = b
        end
      end
    end
  end

  return list
end

--- @since "1.25.0"
--- @spec list_filter(list: Table<K, V>, (value: V, index: K) => Boolean): Table
function foundation.com.list_filter(list, callback)
  local result = {}
  local i = 0

  for index, value in ipairs(list) do
    if callback(value, index) then
      i = i + 1
      result[i] = value
    end
  end

  return result
end

--- @since "1.25.0"
--- @spec list_reject(list: Table<K, V>, (value: V, index: K) => Boolean): Table
function foundation.com.list_reject(list, callback)
  local result = {}
  local i = 0

  for index, value in ipairs(list) do
    if not callback(value, index) then
      i = i + 1
      result[i] = value
    end
  end

  return result
end

--- Returns the matching pair that evaluates to true based on the predicate function.
--- Keep in mind, the key and value are reversed for lists unlike with tables.
---
--- @since "1.31.0"
--- @spec list_find(
---   t: Table<K, V>,
---   (value: V, index: K) => Boolean
--- ): (value: V | nil, index: K | nil)
function foundation.com.list_find(t, predicate)
  local result = {}

  for index, value in ipairs(t) do
    if predicate(value, index) then
      return value, index
    end
  end

  return nil, nil
end

--- @since "1.32.0"
--- @spec list_bsearch_by(
---   t: Table<K, V>,
---   (value: V, index: K) => Integer
--- ): (value: V | nil, index: K | nil)
function foundation.com.list_bsearch_by(t, predicate)
  local len = #t

  if len > 0 then
    local lo = 1
    local hi = len
    local idx
    local elem
    local res
    while lo <= hi do
      idx = lo + math.floor((hi - lo) / 2)
      elem = t[idx]

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

local list_bsearch_by = assert(foundation.com.list_bsearch_by)
--- @since "1.32.0"
--- @spec list_bsearch_by(
---   t: Table<K, V>,
---   v: Any,
--- ): (value: V | nil, index: K | nil)
function foundation.com.list_bsearch(t, a)
  return list_bsearch_by(t, function (b, bidx)
    if a == b then
      return 0
    elseif a > b then
      return 1
    elseif a < b then
      return -1
    end
  end)
end
