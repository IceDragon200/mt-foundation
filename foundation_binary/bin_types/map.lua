local ByteBuf = assert(foundation.com.ByteBuf.little)
local ScalarTypes = assert(foundation.com.binary_types.Scalars)
local table_length = assert(foundation.com.table_length)

--- @namespace foundation.com.binary_types

--- @class Map
local MapType = foundation.com.Class:extends("Map")
do
  local ic = MapType.instance_class

  function ic:initialize(key_type, value_type)
    ic._super.initialize(self)
    self.key_type = ScalarTypes.normalize_type(key_type)
    self.value_type = ScalarTypes.normalize_type(value_type)
    assert(self.key_type, "expected key type to be set")
    assert(self.value_type, "expected value type to be set")
  end

  --- @spec #size(): Number
  function ic:size()
    return 4
  end

  function ic:write(byte_buf, stream, data)
    local len = table_length(data)
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:w_u32(stream, len)
    abw = abw + bw
    if err then
      return abw, err
    end
    for k,v in pairs(data) do
      bw, err = self.key_type:write(byte_buf, stream, k)
      abw = abw + bw
      if err then
        return abw, err
      end
      bw, err = self.value_type:write(byte_buf, stream, v)
      abw = abw + bw
      if err then
        return abw, err
      end
    end
    return abw, nil
  end

  function ic:read(byte_buf, stream)
    local abr = 0
    local br
    local len
    len, br = byte_buf:r_u32(stream)
    abr = abr + br
    if len then
      local result = {}
      local k
      local v
      for _ = 1,len do
        k, br = self.key_type:read(byte_buf, stream)
        abr = abr + br
        v, br = self.value_type:read(byte_buf, stream)
        abr = abr + br
        result[k] = v
      end
      return result, abr
    else
      return nil, abr
    end
  end
end

foundation.com.binary_types.Map = MapType
