-- @namespace foundation.com

local ByteBuf = assert(foundation.com.ByteBuf.little)
local list_map = assert(foundation.com.list_map)

-- @class BinSchema
local BinSchema = foundation.com.Class:extends("BinSchema")
local ic = BinSchema.instance_class

--
-- @type IType: {
--   write: function(self, Stream, data: Any) => (bytes_written: Integer, Error),
--   read: function(self, Stream) => (any, bytes_read: Integer)
-- }
--

-- Scalar Types:
--   "u8" |
--   "u16" |
--   "u24" |
--   "u32" |
--   "i8" |
--   "i16" |
--   "i24" |
--   "i32" |
--   "f16" |
--   "f24" |
--   "f32" |
--   "f64" |
--   "u8bool" |
--   "u8string" |
--   "u16string" |
--   "u24string" |
--   "u32string"
-- @type ScalarTypeName: String
--

-- @type ElementType: ScalarTypeName | IType.t

-- Schema Definition:
--   Integer | -- Padding
--   [name: String, "*array", ElementType} | -- Variable length array
--   [name: String, "array", ElementType, length: Integer} | -- Fixed length array
--   [name: String, "map", key_type, value_type} | -- Map
--   [name: String, ElementType} | -- Any other type
-- @type SchemaDefinition: Any[]

-- @spec #initialize(name: String, SchemaDefinition): void
function ic:initialize(name, definition)
  ic._super.initialize(self)
  assert(definition, "expected a definition list")

  self.m_name = assert(name)
  self.m_definition = list_map(definition, function (element)
    if type(element) == "number" then
      return {type = 0, length = element}
    elseif type(element) == "table" then
      local elem_name = element[1]
      local t = element[2]
      assert(t, "expected a type")
      if type(t) == "string" then
        -- variable length array
        if t == "*array" then
          local value_type = element[3]
          assert(value_type, "expected a value_type")
          return {
            name = elem_name,
            type = foundation.com.binary_types.Array:new(value_type, -1)
          }
        -- fixed length array
        elseif t == "array" then
          local value_type = element[3]
          assert(value_type, "expected a value_type")
          local len = element[4]
          assert(len, "expected a length")
          return {
            name = elem_name,
            type = foundation.com.binary_types.Array:new(value_type, len)
          }
        elseif t == "map" then
          local kt = element[3]
          assert(kt, "expected a key type")
          local vt = element[4]
          assert(vt, "expected a value type")
          return {
            name = elem_name,
            type = foundation.com.binary_types.Map:new(kt, vt)
          }
        elseif foundation.com.binary_types.Scalars[t] then
          return {
            name = elem_name,
            type = foundation.com.binary_types.Scalars[t]
          }
        else
          error("unexpected type " .. t)
        end
      elseif type(t) == "table" then
        assert(t.write, elem_name .. "; expected write/3")
        assert(t.read, elem_name .. "; expected write/2")
        assert(t.size, elem_name .. "; expected size/0")
        return {
          name = elem_name,
          type = t
        }
      else
        error("expected a named type or type table")
      end
    else
      error("expected a number or table")
    end
  end)
end

-- @spec #size(): Integer
function ic:size()
  return foundation.com.list_reduce(self.m_definition, 0, function (block, current_size)
    -- Padding
    if block.type == 0 then
      return current_size + block.length
    else
      if block.type.size then
        return current_size + block.type:size()
      else
        error("field " .. block.name .. "; type has no `size` function")
      end
    end
  end)
end

-- @spec #write(Stream, blob: String): Integer
function ic:write(stream, data)
  return foundation.com.list_reduce(self.m_definition, 0, function (block, all_bytes_written)
    if block.type == 0 then
      for _ = 1,block.length do
        local bytes_written, err = ByteBuf:w_u8(stream, 0)
        all_bytes_written = all_bytes_written + bytes_written
        if err then
          error(err)
        end
      end
    else
      local item = data[block.name]
      local bytes_written, err = block.type:write(stream, item)
      all_bytes_written = all_bytes_written + bytes_written
      if err then
        error(err)
      end
    end
    return all_bytes_written
  end), nil
end

-- @spec #read(Stream, target: Table): Integer
function ic:read(stream, target)
  target = target or {}
  return target, foundation.com.list_reduce(self.m_definition, 0, function (block, all_bytes_read)
    if block.type == 0 then
      local _, bytes_read = ByteBuf:read(stream, block.length)
      all_bytes_read = all_bytes_read + bytes_read
    else
      local value, bytes_read = block.type:read(stream)
      all_bytes_read = all_bytes_read + bytes_read
      target[block.name] = value
    end
    return all_bytes_read
  end)
end

foundation.com.BinSchema = BinSchema
