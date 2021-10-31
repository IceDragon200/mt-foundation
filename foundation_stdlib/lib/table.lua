-- @namespace foundation.com

-- Not table.concat (which is really just a join)
-- This is concat like any other sane language, it really should be used on
-- array/list like tables and not map like ones.
--
-- @spec table_concat(...Table): Table
function foundation.com.table_concat(...)
  local result = {}
  local len = select('#', ...)
  local t
  local x = 0
  if len > 0 then
    for i = 1,len do
      t = select(i, ...)
      for _,value in ipairs(t) do
        x = x + 1
        result[x] = value
      end
    end
  end

  return result
end

-- Copy the specified keys from the given table, returning a new table with those keys
--
-- @spec table_take(t: Table, keys: String[]): Table
function foundation.com.table_take(t, keys)
  local result = {}

  for _, key in ipairs(keys) do
    result[key] = t[key]
  end

  return result
end

-- Removes the specified keys from the given table
-- This will return the same table.
--
-- @mutative
-- @spec table_drop(Table, keys: String[]): Table
function foundation.com.table_drop(t, keys)
  for _, key in ipairs(keys) do
    t[key] = nil
  end
  return t
end

-- Determines if the expected value is a key of the given table.
--
-- @spec table_key_of(Table<T, _V>, expected: T): Boolean()
function foundation.com.table_key_of(t, expected)
  for key,value in pairs(t) do
    if value == expected then
      return key
    end
  end
  return nil
end

-- @spec table_reduce(table: Table, acc: T, Function/3): T
function foundation.com.table_reduce(tbl, acc, fun)
  local should_break
  for k, v in pairs(tbl) do
    acc, should_break = fun(k, v, acc)
    if should_break then
      break
    end
  end
  return acc
end

-- Returns the total count of key-value pairs in the table
--
-- @spec table_length(Table): Integer
function foundation.com.table_length(tbl)
  local len = 0
  for _k, _v in pairs(tbl) do
    len = len + 1
  end
  return len
end

-- Attempts to push the value unto the specified key, if the key doesn't
-- have a table value, one will be created and the value will be inserted into it
--
-- @mutative
-- @spec table_cpush(t: Table, key: String, value: Any): Table
function foundation.com.table_cpush(t, key, value)
  if not t[key] then
    t[key] = {}
  end
  table.insert(t[key], value)
  return t
end

-- Used to merge multiple map-like tables together, if you need to merge lists
-- use `list_concat/*` instead
--
-- @spec table_merge(...Table): Table
function foundation.com.table_merge(...)
  local result = {}
  local len = select('#', ...)
  local t

  if len > 0 then
    for i = 1,len do
      t = select(i, ...)
      for key,value in pairs(t) do
        result[key] = value
      end
    end
  end
  return result
end

-- @spec table_deep_merge(...Table): Table
function foundation.com.table_deep_merge(...)
  local result = {}
  local len = select('#', ...)
  local t

  if len > 0 then
    for i = 1,len do
      t = select(i, ...)
      for key,value in pairs(t) do
        if type(result[key]) == "table" and type(value) == "table" and not result[key][1] and not value[1] then
          result[key] = foundation.com.table_deep_merge(result[key], value)
        else
          result[key] = value
        end
      end
    end
  end

  return result
end

-- Makes a copy of the given table
--
-- @spec table_copy(Table): Table
function foundation.com.table_copy(tab)
  local result = {}
  for key,value in pairs(tab) do
    result[key] = value
  end
  return result
end

-- Makes a deep copy of the table.
-- Note that this function is recursive and does not make any effort to
-- deduplicate any values for sake of performance.
--
-- @recursive unsafe
-- @spec table_deep_copy(Table): Table
function foundation.com.table_deep_copy(tab)
  local result = {}

  for key, value in pairs(tab) do
    if type(value) == "table" then
      result[key] = foundation.com.table_deep_copy(value)
    else
      result[key] = value
    end
  end

  return result
end

-- Sets a key in the specified table to the given value.
-- You really shouldn't need this under normal circumstances.
--
-- @mutative
-- @spec table_put(t: Table, k: Any, v: Any): Table
function foundation.com.table_put(t, key, value)
  t[key] = value
  return t
end

-- Puts a value nested into a table following the specified path.
-- Note that additional tables may be created to complete the bury.
--
-- @mutative
-- @spec table_bury(Table, path: Any[], value: Any): Table
function foundation.com.table_bury(t, path, value)
  local top = t
  for i = 1,(#path - 1) do
    if not top[path[i]] then
      top[path[i]] = {}
    end
    top = top[path[i]]
  end
  top[path[#path]] = value
  return t
end

-- Returns all keys in the given table in a new table (list)
--
-- @spec table_keys(Table<T, _V>): T[]
function foundation.com.table_keys(t)
  local keys = {}
  local i = 0
  for key,_ in pairs(t) do
    i = i + 1
    keys[i] = key
  end
  return keys
end

-- Returns all value sin the given table in a new table (list)
--
-- @spec table_values(Table<_K, T>): T[]
function foundation.com.table_values(t)
  local values = {}
  local i = 0
  for _,value in pairs(t) do
    i = i + 1
    values[i] = value
  end
  return values
end

-- Shallow compares two given tables
--
-- @spec table_equals(a: Table, b: Table): Boolean
function foundation.com.table_equals(a, b)
  if a == b then
    -- even if a and b are nil, its true that they are at least equal
    return true
  elseif a == nil then
    return false
  elseif b == nil then
    return false
  end

  local merged = foundation.com.table_merge(a, b)
  for key,_ in pairs(merged) do
    if a[key] ~= b[key] then
      return false
    end
  end
  return true
end

-- Determines if the given value contains the specified table (expected)
--
-- @spec table_includes_value(Table<_K, T>, expected: T): Boolean
function foundation.com.table_includes_value(t, expected)
  for _, value in pairs(t) do
    if value == expected then
      return true
    end
  end
  return false
end

-- Adds a spacer item between values, this is intended to be used on
-- lists rather than tables.
--
-- @spec table_intersperse(Table, spacer: Any): Table
function foundation.com.table_intersperse(t, spacer)
  local count = #t
  local result = {}
  local i = 0
  for index, item in ipairs(t) do
    i = i + 1
    result[i] = item
    if index < count then
      i = i + 1
      result[i] = spacer
    end
  end
  return result
end

-- Determines if the given table is empty
--
-- @spec is_table_empty(Table): Boolean
function foundation.com.is_table_empty(t)
  return next(t) == nil
end

local function flatten_reducer(t, index, value, depth)
  assert(depth < 20, "flatten depth exceeded, maybe there is a loop")
  if type(value) == "table" then
    for _,item in ipairs(value) do
      t, index = flatten_reducer(t, index, item, depth + 1)
    end
    return t, index
  else
    t[index] = value
    return t, index + 1
  end
end

-- Attempts to flatten the given table structure, that is all sub tables
-- are merged directly into the top-level, leaving a 1 level deep table as the
-- result.
--
-- @spec table_flatten(Table): Table
function foundation.com.table_flatten(t)
  return flatten_reducer({}, 1, t, 0)
end
