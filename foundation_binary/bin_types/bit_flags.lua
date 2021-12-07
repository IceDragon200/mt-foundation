-- @namespace foundation.com.binary_types
local bit = assert(foundation.com.bit)
local ByteBuf = assert(foundation.com.ByteBuf.little)

-- @class BitFlags
local BitFlags = foundation.com.Class:extends("foundation.com.binary_types.BitFlags")
local ic = BitFlags.instance_class

function ic:initialize(size, mapping)
  self.m_size = size
  self.m_mapping = mapping
end

function ic:size()
  return self.m_size
end

function ic:read(stream)
  local int, bytes_read = ByteBuf:r_uv(stream, self.m_size)
  local result = {}
  for key,mask in pairs(self.m_mapping) do
    result[key] = bit.band(int, mask)
  end
  return result, bytes_read
end

function ic:write(stream, map)
  local result = 0
  for key,mask in pairs(self.m_mapping) do
    result = bit.bor(result, bit.band(map[key], mask))
  end
  return ByteBuf:w_uv(stream, self.m_size, result)
end

foundation.com.binary_types.BitFlags = BitFlags
