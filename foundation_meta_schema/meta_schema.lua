-- @namespace foundation.com

--
-- Structured metadata, because sometimes you need to know just what the f*** you're doing
--
-- Optionally, the MetaSchema can be compiled with a fixed name to reduce some of the overhead
--
-- @class MetaSchema
local MetaSchema = foundation.com.Class:extends("MetaSchema")
local m = assert(MetaSchema.instance_class)

-- Initialize a new instance of the MetaSchema
--
-- @spec #initialize(name: String, prefix: String, schema: Table): void
function m:initialize(name, prefix, schema)
  -- The name is used to help identify the schema
  self.name = name
  -- A string to prefix any fields in the schema with when writing.
  self.prefix = prefix
  self.type = "schema"
  self.schema = schema
end

local function make_setter(entry, field_name)
  if entry.type == "string" then
    return function (self, meta, value)
      meta:set_string(field_name, value)
      return self
    end
  elseif entry.type == "number" or entry.type == "float" then
    return function (self, meta, value)
      meta:set_float(field_name, value)
      return self
    end
  elseif entry.type == "integer" then
    return function (self, meta, value)
      meta:set_int(field_name, value)
      return self
    end
  else
    error("unhandled setter of type " .. dump(entry.type))
  end
end

local function make_getter(entry, field_name)
  if entry.type == "string" then
    return function (self, meta)
      return meta:get_string(field_name)
    end
  elseif entry.type == "number" or entry.type == "float" then
    return function (self, meta)
      return meta:get_float(field_name)
    end
  elseif entry.type == "integer" then
    return function (self, meta)
      return meta:get_int(field_name)
    end
  else
    error("unhandled setter of type " .. dump(entry.type))
  end
end

-- Compiles a given meta schema with a fixed basename
--
-- The returned schema will have getters and setters of their entries.
--
-- Args:
-- * `basename` - a basename to give the field names
--
-- Returns:
-- * Compiled schema
--
-- @spec #compile(String): Table
function m:compile(basename)
  assert(basename, "expected a basename")
  local schema = {
    keys = {}
  }

  local prefix = (self.prefix or "") .. basename
  for key, entry in pairs(self.schema) do
    local field_name = prefix .. "_" .. key
    local setter_name = "set_" .. key
    local getter_name = "get_" .. key
    schema[key] = {
      field_name = field_name,
      type = entry.type,
      setter_name = setter_name,
      getter_name = getter_name,
    }

    if entry.type == "schema" then
      local sub_schema = entry.schema:compile(field_name)
      schema["schema_" .. key] = sub_schema
      schema[setter_name] = function (myself, meta, value)
        sub_schema:set(meta, value)
        return myself
      end
      schema[getter_name] = function (myself, meta)
        return sub_schema:get()
      end
    else
      schema[setter_name] = make_setter(entry, field_name)
      schema[getter_name] = make_getter(entry, field_name)
    end
  end

  function schema.set(myself, meta, t)
    for key,value in pairs(t) do
      local entry = schema.keys[key]
      if entry then
        myself[entry.setter_name](myself, meta, value)
      end
    end
    return myself
  end

  function schema.get(myself, meta)
    local result = {}
    for key,entry in pairs(myself.keys) do
      result[key] = myself[entry.getter_name](myself, meta)
    end
    return result
  end

  return schema
end

--
-- Args:
-- * `meta` - a NodeMetaRef
-- * `buffer` - a buffer instance
--
-- @spec #set_field(MetaRef, basename: String, key: String, value: Any): void
function m:set_field(meta, basename, key, value)
  assert(meta, "expected a meta")
  if self.schema[key] then
    local entry = self.schema[key]
    local field_name = (self.prefix or "") .. basename .. "_" .. key

    if entry.type == "string" then
      meta:set_string(field_name, value)
    elseif entry.type == "number" then
      meta:set_float(field_name, value)
    elseif entry.type == "integer" then
      meta:set_int(field_name, value)
    elseif entry.type == "float" then
      meta:set_float(field_name, value)
    elseif entry.type == "schema" then
      entry.schema:set(meta, field_name, value)
    end
  end
end

-- @spec #set(MetaRef, basename: String, params: Table): void
function m:set(meta, basename, params)
  assert(meta, "expected a metaref")
  for key,value in pairs(params) do
    self:set_field(meta, basename, key, value)
  end
end

-- @spec #get_field(MetaRef, basename: String, key: String): Any
function m:get_field(meta, basename, key)
  if self.schema[key] then
    local entry = self.schema[key]
    local field_name = (self.prefix or "") .. basename .. "_" .. key

    if entry.type == "string" then
      return meta:get_string(field_name)
    elseif entry.type == "number" then
      return meta:get_float(field_name)
    elseif entry.type == "integer" then
      return meta:get_int(field_name)
    elseif entry.type == "float" then
      return meta:get_float(field_name)
    elseif entry.type == "schema" then
      return entry.schema:get(meta, field_name)
    end
  end
  return nil
end

--
-- @spec #get(meta: MetaRef, basename: String): Table
function m:get(meta, basename)
  assert(meta, "expected a meta")
  assert(basename, "expected a basename")
  local result = {}
  for key,_ in pairs(self.schema) do
    result[key] = self:get_field(meta, basename, key)
  end
  return result
end

foundation.com.MetaSchema = MetaSchema
