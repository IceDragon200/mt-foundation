local assertions = assert(foundation.com.assertions)
local ByteBuf = assert(foundation.com.ByteBuf.little)
local list_map = assert(foundation.com.list_map)
local list_reduce = assert(foundation.com.list_reduce)

--- @namespace foundation.com

--- @class BinSchema
local BinSchema = foundation.com.Class:extends("BinSchema")
do
  local ic = BinSchema.instance_class

  ---
  --- @type IType: {
  ---   write: function(self, Stream, data: Any) => (bytes_written: Integer, Error),
  ---   read: function(self, Stream) => (any, bytes_read: Integer)
  --- }
  ---

  --- @type ScalarType:
  ---   "u8"
  ---   | "u16"
  ---   | "u24"
  ---   | "u32"
  ---   | "u40"
  ---   | "u48"
  ---   | "i8"
  ---   | "i16"
  ---   | "i24"
  ---   | "i32"
  ---   | "i40"
  ---   | "i48"
  ---   | "f16"
  ---   | "f24"
  ---   | "f32"
  ---   | "f64"
  ---   | "u8bool"
  ---   | "u8string"
  ---   | "u16string"
  ---   | "u24string"
  ---   | "u32string"

  --- @type ElementType: ScalarType | IType
  --- @type Element:
  ---   Integer -- Padding
  ---   | { [1] = (name: String), [2] = "*array", [3] = ElementType} -- Variable length array
  ---   | { [1] = (name: String), [2] = "array", [3] = ElementType, [4] = length: Integer} -- Fixed length array
  ---   | { [1] = (name: String), [2] = "map", [3] = key_type, [4] = value_type} -- Map
  ---   | { [1] = (name: String), [2] = ElementType} -- Any other type
  --- @type SchemaDefinition: Element[]

  --- @spec #initialize(name: String, SchemaDefinition): void
  function ic:initialize(name, definition)
    ic._super.initialize(self)
    assertions.is_string(name, "expected a name")
    assertions.is_table(definition, "expected a definition list")
    --- @member name: String
    self.name = name

    --- @member definition: Table[]
    self.definition = {}

    local ArrayType = foundation.com.binary_types.Array
    local MapType = foundation.com.binary_types.Map
    local ScalarTypes = foundation.com.binary_types.Scalars

    for i, element in ipairs(definition) do
      if type(element) == "number" then
        self.definition[i] = {type = 0, length = element}
      elseif type(element) == "table" then
        local name = element[1]
        local t = element[2]
        assert(t, "expected a type")
        if type(t) == "string" then
          -- variable length array
          if t == "*array" then
            local value_type = element[3]
            assert(value_type, "expected a value_type")
            self.definition[i] = {name = name, type = ArrayType:new(value_type, -1)}
          -- fixed length array
          elseif t == "array" then
            local value_type = element[3]
            assert(value_type, "expected a value_type")
            local len = element[4]
            assert(len, "expected a length")
            self.definition[i] = {name = name, type = ArrayType:new(value_type, len)}
          elseif t == "map" then
            local kt = element[3]
            assert(kt, "expected a key type")
            local vt = element[4]
            assert(vt, "expected a value type")
            self.definition[i] = {name = name, type = MapType:new(kt, vt)}
          elseif ScalarTypes[t] then
            self.definition[i] = {name = name, type = ScalarTypes[t]}
          else
            error("unexpected type " .. t)
          end
        elseif type(t) == "table" then
          assert(t.write, "expected write/3")
          assert(t.read, "expected write/2")
          self.definition[i] = {name = name, type = t}
        else
          error("expected a named type or type table")
        end
      else
        error("expected a number or table")
      end
    end
  end

  --- @since "3.0.0"
  --- @spec #find_field(name: String): Table | nil
  function ic:find_field(name)
    for i, field in ipairs(self.definition) do
      if field.name == name then
        return field
      end
    end
    return nil
  end

  --- @spec #size(): Integer
  function ic:size()
    local size = 0
    for _, block in ipairs(self.definition) do
      if block.type == 0 then
        size = size + block.length
      else
        if type(block.type.size) == "function" then
          size = size + block.type:size()
        else
          error("field " .. block.name .. "; type has no `size` function")
        end
      end
    end
    return size
  end

  --- @spec #write(byte_buf: ByteBuf, Stream, data: Any): (bytes_written: Integer, err: String)
  function ic:write(byte_buf, stream, data)
    assert(stream, "expected a stream")
    return list_reduce(self.definition, 0, function (block, abw)
      if block.type == 0 then
        local bw, err
        for _ = 1,block.length do
          bw, err = byte_buf:w_u8(stream, 0)
          abw = abw + bw
          if err then
            error(err)
          end
        end
      else
        local item = data[block.name]
        local bw, err = block.type:write(byte_buf, stream, item)
        abw = abw + bw
        if err then
          error(err)
        end
      end
      return abw
    end), nil
  end

  --- @spec #read(byte_buf: ByteBuf, Stream, target?: Table): (target: Table, bytes_read: Number)
  function ic:read(byte_buf, stream, target)
    target = target or {}
    return target, list_reduce(self.definition, 0, function (block, all_bytes_read)
      if block.type == 0 then
        local _, bytes_read = byte_buf:read(stream, block.length)
        all_bytes_read = all_bytes_read + bytes_read
      else
        local value, bytes_read = block.type:read(byte_buf, stream)
        all_bytes_read = all_bytes_read + bytes_read
        target[block.name] = value
      end
      return all_bytes_read
    end)
  end
end

foundation.com.BinSchema = BinSchema
