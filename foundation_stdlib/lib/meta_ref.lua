-- @namespace foundation.com
foundation_stdlib:require("lib/table.lua")

-- @spec metaref_merge_fields_from_table(MetaRef, Table): MetaRef
function foundation.com.metaref_merge_fields_from_table(meta, params)
  local base = meta:to_table()
  local new_fields = foundation.com.table_merge(base.fields, params)
  base.fields = new_fields
  meta:from_table(base)
  return meta
end

-- @spec metaref_dec_float(MetaRef, String, Float): Float
function foundation.com.metaref_dec_float(meta, name, amount)
  amount = amount or 1
  local n = meta:get_float(name)
  n = n - amount
  meta:set_float(name, n)
  return n
end

-- @spec metaref_dec_int(MetaRef, String, Integer): Integer
function foundation.com.metaref_dec_int(meta, name, amount)
  amount = amount or 1
  local n = meta:get_int(name)
  n = n - amount
  meta:set_int(name, n)
  return n
end

-- @spec metaref_inc_float(MetaRef, String, Float): Float
function foundation.com.metaref_inc_float(meta, name, amount)
  amount = amount or 1
  local n = meta:get_float(name)
  n = n + amount
  meta:set_float(name, n)
  return n
end

-- @spec metaref_inc_int(MetaRef, String, Integer): Integer
function foundation.com.metaref_inc_int(meta, name, amount)
  amount = amount or 1
  local n = meta:get_int(name)
  n = n + amount
  meta:set_int(name, n)
  return n
end

-- @spec metaref_int_list_to_table(
--   MetaRef,
--   prefix: String,
--   max: Integer
-- ): (count: Integer, result: Table)
function foundation.com.metaref_int_list_to_table(meta, prefix, max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  local result = {}

  if count > 0 then
    for i = 1,math.min(count, max) do
      result[i] = meta:get_int(prefix .. i)
    end
  end

  return count, result
end

-- @mutative
-- @spec metaref_int_list_pop(MetaRef, prefix: String, max: Integer): nil | Integer
function foundation.com.metaref_int_list_pop(meta, prefix, _max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count > 0 then
    local item = meta:get_int(prefix .. count)
    meta:set_int(count_key, count - 1)
    return item
  end

  return nil
end

-- @spec metaref_int_list_peek(MetaRef, prefix: String, max: Integer): nil | Integer
function foundation.com.metaref_int_list_peek(meta, prefix, _max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count > 0 then
    local item = meta:get_int(prefix .. count)
    return item
  end

  return nil
end

--
-- Pushes given item unto the list, if there is no space (i.e. exceeds max) nil is returned,
-- otherwise the index of the item added is returned instead
--
-- @mutative
-- @spec metaref_int_list_push(MetaRef, prefix: String, max: Integer, item: Integer): nil | Integer
function foundation.com.metaref_int_list_push(meta, prefix, max, item)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count < max then
    count = count + 1
    meta:set_int(prefix .. count, item)
    meta:set_int(count_key, count)
    return count
  end

  return nil
end

-- @mutative
-- @spec metaref_int_list_clear(MetaRef, prefix: String, max: Integer): void
function foundation.com.metaref_int_list_clear(meta, prefix, max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count > 0 then
    for i = 1,count do
      meta:set_int(prefix .. count, 0)
    end
  end
  meta:set_int(count_key, 0)
end

-- @mutative
-- @spec metaref_int_list_lazy_clear(MetaRef, prefix: String, max: Integer): void
function foundation.com.metaref_int_list_lazy_clear(meta, prefix, max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  meta:set_int(count_key, 0)
end

-- String

-- @spec metaref_int_list_to_table(
--   MetaRef,
--   prefix: String,
--   max: Integer
-- ): (count: Integer, result: Table)
function foundation.com.metaref_string_list_to_table(meta, prefix, max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  local result = {}

  if count > 0 then
    for i = 1,math.min(count, max) do
      result[i] = meta:get_string(prefix .. i)
    end
  end

  return count, result
end

-- @mutative
-- @spec metaref_string_list_pop(MetaRef, prefix: String, max: Integer): nil | String
function foundation.com.metaref_string_list_pop(meta, prefix, _max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count > 0 then
    local item = meta:get_string(prefix .. count)
    meta:set_int(count_key, count - 1)
    return item
  end

  return nil
end

-- @spec metaref_string_list_peek(MetaRef, prefix: String, max: Integer): nil | String
function foundation.com.metaref_string_list_peek(meta, prefix, _max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count > 0 then
    local item = meta:get_string(prefix .. count)
    return item
  end

  return nil
end

--
-- Pushes given item unto the list, if there is no space (i.e. exceeds max) nil is returned,
-- otherwise the index of the item added is returned instead
--
-- @mutative
-- @spec metaref_string_list_push(
--   MetaRef,
--   prefix: String,
--   max: Integer,
--   item: String
-- ): nil | Integer
function foundation.com.metaref_string_list_push(meta, prefix, max, item)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count < max then
    count = count + 1
    meta:set_string(prefix .. count, item)
    meta:set_int(count_key, count)
    return count
  end

  return nil
end

-- @mutative
-- @spec metaref_string_list_clear(MetaRef, prefix: String, max: Integer): void
function foundation.com.metaref_string_list_clear(meta, prefix, max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  if count > 0 then
    for i = 1,count do
      meta:set_string(prefix .. count, "")
    end
  end
  meta:set_int(count_key, 0)
end

-- @mutative
-- @spec metaref_string_list_lazy_clear(MetaRef, prefix: String, max: Integer): void
function foundation.com.metaref_string_list_lazy_clear(meta, prefix, max)
  local count_key = prefix .. "count"
  local count = meta:get_int(count_key)

  meta:set_int(count_key, 0)
end
