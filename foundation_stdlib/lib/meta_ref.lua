foundation_stdlib:require("lib/table.lua")

function foundation.com.metaref_merge_fields_from_table(meta, params)
  local base = meta:to_table()
  local new_fields = foundation.com.table_merge(base.fields, params)
  base.fields = new_fields
  meta:from_table(base)
  return meta
end

function foundation.com.metaref_dec_float(meta, name, amount)
  amount = amount or 1
  local n = meta:get_float(name)
  n = n - amount
  meta:set_float(name, n)
  return n
end

function foundation.com.metaref_dec_int(meta, name, amount)
  amount = amount or 1
  local n = meta:get_int(name)
  n = n - amount
  meta:set_int(name, n)
  return n
end

function foundation.com.metaref_inc_float(meta, name, amount)
  amount = amount or 1
  local n = meta:get_float(name)
  n = n + amount
  meta:set_float(name, n)
  return n
end

function foundation.com.metaref_inc_int(meta, name, amount)
  amount = amount or 1
  local n = meta:get_int(name)
  n = n + amount
  meta:set_int(name, n)
  return n
end
