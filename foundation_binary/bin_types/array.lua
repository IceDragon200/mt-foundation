local assertions = assert(foundation.com.assertions)
local ByteBuf = assert(foundation.com.ByteBuf.little)
local ScalarTypes = assert(foundation.com.binary_types.Scalars)

--- @namespace foundation.com.binary_types

--- @class ArrayType
local ArrayType = foundation.com.Class:extends("Array")
do
  local ic = ArrayType.instance_class

  --- @spec #initialize(value_type: Any, length: Number): void
  function ic:initialize(value_type, length)
    ic._super.initialize(self)
    self.declared_value_type = value_type
    self.value_type = ScalarTypes.normalize_type(value_type)
    self.length = assertions.is_number(length)
  end

  --- Calculates the minimum size of the type.
  --- @spec #size(): Number
  function ic:size()
    local l = 4
    if self.length >= 0 then
      if type(self.value_type.size) == "function" then
        return l + self.value_type:size() * self.length
      elseif type(self.value_type.length) == "number" then
        return l + self.value_type.length * self.length
      else
        error("cannot determine array length as value_type does not have size nor length (got " .. dump(self.declared_value_type) .. ")")
      end
    else
      return l
    end
  end

  --- @spec #write(byte_buf: ByteBuf, stream: Stream, data: Number):
  ---   (bytes_written: Number, err: Any)
  function ic:write(byte_buf, stream, data)
    assert(data, "expected data")
    local abw = 0
    local bw
    local err
    local len
    if self.length >= 0 then
      len = self.length
    else
      len = #data
      bw, err = byte_buf:w_u32(stream, len)
      abw = abw + bw
      if err then
        return abw, err
      end
    end
    local item
    for i = 1,len do
      item = data[i]
      bw, err = self.value_type:write(byte_buf, stream, item)
      abw = abw + bw
      if err then
        return abw, err
      end
    end
    return abw, nil
  end

  --- @spec #read(byte_buf: ByteBuf, stream: Stream): (result: Any[], bytes_read: Number)
  function ic:read(byte_buf, stream)
    local abr = 0
    local br
    local len
    if self.length >= 0 then
      len = self.length
    else
      local v
      v, br = byte_buf:r_u32(stream)
      abr = abr + br
      len = v
    end
    local result = {}
    local item
    for i = 1,len do
      item, br = self.value_type:read(byte_buf, stream)
      abr = abr + br
      result[i] = item
    end
    return result, abr
  end
end

foundation.com.binary_types.Array = ArrayType
