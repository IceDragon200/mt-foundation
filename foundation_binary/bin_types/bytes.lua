local assertions = assert(foundation.com.assertions)
local ByteBuf = assert(foundation.com.ByteBuf.little)

--- @namespace foundation.com.binary_types

--- @class Bytes
local Bytes = foundation.com.Class:extends("foundation.com.binary_types.Bytes")
do
  local ic = Bytes.instance_class

  function ic:initialize(length)
    ic._super.initialize(self)
    self.length = length
  end

  --- @spec #size(): void
  function ic:size()
    return self.length
  end

  --- @spec #write(byte_buf: ByteBuf, File, data: String | nil): (Integer, err: String | nil)
  function ic:write(byte_buf, stream, data)
    assert(stream, "expected a stream")
    data = data or ""
    local payload = string.sub(data, 1, self.length)
    local actual_length = #payload
    local padding_needed = self.length - actual_length
    assert(padding_needed >= 0, "length error")
    local bytes_written, err = byte_buf:write(stream, payload)
    if err then
      return bytes_written, err
    end
    for _ = 1,padding_needed do
      byte_buf:w_u8(stream, 0)
    end
    return self.length, nil
  end

  function ic:read(byte_buf, stream)
    return byte_buf:read(stream, self.length)
  end
end

foundation.com.binary_types.Bytes = Bytes
