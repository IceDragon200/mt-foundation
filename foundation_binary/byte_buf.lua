-- @namespace foundation.com.ByteBuf
local ByteDecoder = assert(foundation.com.ByteDecoder)
local bit = assert(foundation.com.bit, "expected bit module")

local ByteBuf = {}
local ic

-- @class Base
ByteBuf.Base = foundation.com.Class:extends("ByteBuf.Base")
do
  ic = ByteBuf.Base.instance_class
  --
  -- Writer functions
  --
  -- @spec write(Stream, data: Any): (Integer, error: String | nil)
  function ic:write(stream, data)
    local t = type(data)
    local num_bytes = 0
    local err

    -- Arrays, not maps
    if t == "table" then
      local bytes_written
      for _, chunk in ipairs(data) do
        bytes_written, err = self:write(stream, chunk)
        num_bytes = num_bytes + bytes_written
        if err then
          return num_bytes, err
        end
      end
    -- Strings woot!
    elseif t == "string" then
      local success
      success, err = stream:write(data)
      if success then
        num_bytes = num_bytes + #data
      else
        return num_bytes, err
      end
    -- Bytes, woot!
    elseif t == "number" then
      if data > 255 then
        return num_bytes, "byte overflow"
      elseif data < -128 then
        return num_bytes, "byte overflow"
      end
      local success
      success, err = stream:write(string.char(data))
      if success then
        num_bytes = num_bytes + 1
      else
        return num_bytes, err
      end
    else
      return num_bytes, "unexpected type " .. t
    end
    return num_bytes, nil
  end

  -- Signed Integers

  -- @spec #w_i64(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_i64(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_iv(stream, 8, int)
  end

  -- @spec #w_i32(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_i32(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_iv(stream, 4, int)
  end

  -- @spec #w_i24(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_i24(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_iv(stream, 3, int)
  end

  -- @spec #w_i16(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_i16(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_iv(stream, 2, int)
  end

  -- @spec #w_i8(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_i8(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_iv(stream, 1, int)
  end

  -- Unsigned Integers
  --

  -- @spec #w_u64(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_u64(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_uv(stream, 8, int)
  end

  -- @spec #w_u32(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_u32(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_uv(stream, 4, int)
  end

  -- @spec #w_u24(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_u24(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_uv(stream, 3, int)
  end

  -- @spec #w_u16(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_u16(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_uv(stream, 2, int)
  end

  -- @spec #w_u8(Stream, int: Integer): (Integer, error: String | nil)
  function ic:w_u8(stream, int)
    local type = type(int)
    if type ~= "number" then
      error("expected an integer (got "..type..")")
    end
    return self:w_uv(stream, 1, int)
  end

  -- Floating Point Values - IEEE754
  -- http://eng.umb.edu/~cuckov/classes/engin341/Reference/IEEE754.pdf
  -- http://sandbox.mc.edu/~bennet/cs110/flt/ftod.html
  -- http://sandbox.mc.edu/~bennet/cs110/flt/dtof.html
  -- TODO: still a work in progress
  --
  -- @spec #w_fv(Stream, exponent_bits: Integer, mantissa_bits: Integer, flt: Float):
  --   (Integer, error: String | nil)
  function ic:w_fv(stream, exponent_bits, mantissa_bits, flt)
    -- local sign = 0
    -- if flt < 0 then
    --   sign = 1
    -- end

    local int = math.floor(flt)
    flt = flt - int

    local mantissa_fract = 0

    local m = flt
    for i = 0,mantissa_bits do
      m = m * 2
      if m >= 1 then
        m = m - 1
        mantissa_fract = bit.bor(mantissa_fract, bit.lshift(1, i))
      end
    end

    local e = int
    local exponent = 1
    while e > 1 do
      e = bit.rshift(e, 1)
      exponent = exponent + 1
    end
  end

  -- @spec #w_f16(Stream, flt: Float): (bytes_written: Integer, err: Error)
  function ic:w_f16(stream, flt)
    return self:w_fv(stream, 5, 10, flt)
  end

  -- @spec #w_f24(Stream, flt: Float): (bytes_written: Integer, err: Error)
  function ic:w_f24(stream, flt)
    return self:w_fv(stream, 5, 10, flt)
  end

  -- @spec #w_f32(Stream, flt: Float): (bytes_written: Integer, err: Error)
  function ic:w_f32(stream, flt)
    return self:w_fv(stream, 8, 23, flt)
  end

  -- @spec #w_f64(Stream, flt: Float): (bytes_written: Integer, err: Error)
  function ic:w_f64(stream, flt)
    return self:w_fv(stream, 11, 52, flt)
  end

  --function ic:w_f128(stream, flt)
  --  return self:w_fv(stream, 15, 112, flt)
  --end
  --
  --function ic:w_f256(stream, flt)
  --  return self:w_fv(stream, 19, 237, flt)
  --end

  -- Helpers
  -- @spec w_u8bool(Stream, Boolean): (Integer, error: String | nil)
  function ic:w_u8bool(stream, bool)
    if bool then
      return self:w_u8(stream, 1)
    else
      return self:w_u8(stream, 0)
    end
  end

  -- Null-Terminated string
  --
  -- @spec w_cstring(Stream, String): (Integer, error: String | nil)
  function ic:w_cstring(stream, str)
    local num_bytes
    local err
    local nbytes

    num_bytes, err = self:write(stream, str)
    if err then
      return num_bytes, err
    end
    nbytes, err = self:w_u8(stream, 0)
    return num_bytes + nbytes, err
  end

  -- @spec #w_u8string(Stream, String): (Integer, error: String | nil)
  function ic:w_u8string(stream, data)
    assert(data, "expected a string of some kind")
    -- length
    local len = #data
    if len > 255 then
      error("string is too long")
    end
    local num_bytes
    local written
    local err

    num_bytes, err  = self:w_u8(stream, len)
    if err then
      return num_bytes, err
    end
    written, err = self:write(stream, data)

    return num_bytes + written, err
  end

  -- @spec #w_u16string(Stream, String): (Integer, error: String | nil)
  function ic:w_u16string(stream, data)
    -- length
    local len = #data
    if len > 65535 then
      error("string is too long")
    end
    local num_bytes
    local written
    local err

    num_bytes, err = self:w_u16(stream, len)
    if err then
      return num_bytes, err
    end
    written, err = self:write(stream, data)

    return num_bytes + written, err
  end

  -- @spec #w_u32string(Stream, String): (Integer, error: String | nil)
  function ic:w_u32string(stream, data)
    -- length
    local len = #data
    if len > 4294967295 then
      error("string is too long")
    end
    local num_bytes
    local written
    local err

    num_bytes, err = self:w_u32(stream, len)
    if err then
      return num_bytes, err
    end
    written, err = self:write(stream, data)

    return num_bytes + written, err
  end

  -- @spec #w_u64string(Stream, String): (Integer, error: String | nil)
  function ic:w_u64string(stream, data)
    -- length
    local len = #data
    if len > 4294967295 then
      error("string is too long")
    end
    local num_bytes
    local written
    local err

    num_bytes, err = self:w_u32(stream, len)
    if err then
      return num_bytes, err
    end
    written, err = self:write(stream, data)

    return num_bytes + written, err
  end

  -- @spec #w_map(
  --   Stream,
  --   key_type: String,
  --   value_type: String,
  --   Table
  -- ): (Integer, error: String | nil)
  function ic:w_map(stream, key_type, value_type, data)
    -- length
    local len = foundation.com.table_length(data)
    -- number of items in the map
    local num_bytes = self:w_u32(stream, len)
    local writer_name = "w_" .. value_type
    local key_writer_name = "w_" .. key_type
    local bytes_written
    local err

    for key, item in pairs(data) do
      bytes_written, err = self[key_writer_name](self, stream, key)
      num_bytes = num_bytes + bytes_written
      if err then
        return num_bytes, err
      end

      bytes_written, err = self[writer_name](self, stream, item)
      num_bytes = num_bytes + bytes_written
      if err then
        return num_bytes, err
      end
    end

    return num_bytes, nil
  end

  -- @spec #w_varray(
  --   Stream,
  --   type: String,
  --   data: Any[],
  --   len: Integer
  -- ): (Integer, error: String | nil)
  function ic:w_varray(stream, type, data, len)
    local writer_name = "w_" .. type
    local all_bytes_written = 0
    local item
    local bytes_written
    local err

    for i = 1,len do
      item = data[i]
      bytes_written, err = self[writer_name](self, stream, item)
      all_bytes_written = all_bytes_written + bytes_written
      if err then
        return all_bytes_written, err
      end
    end

    return all_bytes_written, nil
  end

  -- @spec #w_array(Stream, type: String, data: Any[]): (Integer, error: String | nil)
  function ic:w_array(stream, type, data)
    -- length
    local len = #data
    -- number of items in the array
    local all_bytes_written = self:w_u32(stream, len)
    local bytes_written, err = self:w_varray(stream, type, data, len)

    return all_bytes_written + bytes_written, err
  end

  --
  -- Reader
  --

  -- @spec #read(Stream, len: Integer): (String, bytes_read: Integer)
  function ic:read(stream, len)
    local blob = stream:read(len)
    local bytes_read = 0
    if blob then
      bytes_read = #blob
    end
    return blob, bytes_read
  end

  -- local INT_MAX = {
  --   [1] = math.floor(math.pow(2, 8)),
  --   [2] = math.floor(math.pow(2, 16)),
  --   [3] = math.floor(math.pow(2, 24)),
  --   [4] = math.floor(math.pow(2, 32)),
  --   [8] = math.floor(math.pow(2, 64)),
  -- }

  -- @spec #r_i64(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_i64(stream)
    return self:r_iv(stream, 8)
  end

  -- @spec #r_i32(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_i32(stream)
    return self:r_iv(stream, 4)
  end

  -- @spec #r_i24(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_i24(stream)
    return self:r_iv(stream, 3)
  end

  -- @spec #r_i16(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_i16(stream)
    return self:r_iv(stream, 2)
  end

  -- @spec #r_i8(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_i8(stream)
    return self:r_iv(stream, 1)
  end

  -- @spec #r_u64(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_u64(stream)
    return self:r_uv(stream, 8)
  end

  -- @spec #r_u32(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_u32(stream)
    return self:r_uv(stream, 4)
  end

  -- @spec #r_u24(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_u24(stream)
    return self:r_uv(stream, 3)
  end

  -- @spec #r_u16(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_u16(stream)
    return self:r_uv(stream, 2)
  end

  -- @spec #r_u8(Stream): (result: Integer, bytes_read: Integer)
  function ic:r_u8(stream)
    return self:r_uv(stream, 1)
  end

  -- @spec #r_u8bool(Stream): (result: Boolean, bytes_read: Integer)
  function ic:r_u8bool(stream, bool)
    local result, bytes_read = self:r_u8(stream)
    if bytes_read > 0 then
      return result ~= 0, bytes_read
    else
      return nil, bytes_read
    end
  end

  -- @spec #r_cstring(Stream): (result: String, bytes_read: Integer)
  function ic:r_cstring(stream)
    local bytes_read = 0
    local result = ''
    local c

    while true do
      c = self:read(stream, 1)
      bytes_read = bytes_read + 1
      if c == '\0' then
        result = result .. '\0'
        break
      elseif c == '' then
        error("unexpected termination")
      else
        result = result .. c
      end
    end

    return result, bytes_read
  end

  -- @spec #r_u8string(Stream): (result: String | nil, bytes_read: Integer)
  function ic:r_u8string(stream)
    local len, all_bytes_read = self:r_u8(stream)
    if all_bytes_read > 0 then
      local str, bytes_read = self:read(stream, len)
      return str, all_bytes_read + bytes_read
    else
      return nil, all_bytes_read
    end
  end

  -- @spec #r_u16string(Stream): (result: String | nil, bytes_read: Integer)
  function ic:r_u16string(stream)
    local len, all_bytes_read = self:r_u16(stream)
    if all_bytes_read > 0 then
      local str, bytes_read = self:read(stream, len)
      return str, all_bytes_read + bytes_read
    else
      return nil, all_bytes_read
    end
  end

  -- @spec #r_u24string(Stream): (result: String | nil, bytes_read: Integer)
  function ic:r_u24string(stream)
    local len, all_bytes_read = self:r_u24(stream)
    if all_bytes_read > 0 then
      local str, bytes_read = self:read(stream, len)
      return str, all_bytes_read + bytes_read
    else
      return nil, all_bytes_read
    end
  end

  -- @spec #r_u32string(Stream): (result: String | nil, bytes_read: Integer)
  function ic:r_u32string(stream)
    local len, all_bytes_read = self:r_u32(stream)
    if all_bytes_read > 0 then
      local str, bytes_read = self:read(stream, len)
      return str, all_bytes_read + bytes_read
    else
      return nil, all_bytes_read
    end
  end

  -- @spec #r_map(Stream, key_type: String, value_type: String):
  --   (result: Table<Any, Any> | nil, bytes_read: Integer)
  function ic:r_map(stream, key_type, value_type)
    local reader_key = "r_" .. key_type
    local reader_value_key = "r_" .. value_type
    local element_count, all_bytes_read = self:r_u32(stream)
    local result = {}

    if element_count then
      local reader = ByteBuf[reader_key]
      local key
      local value
      local bytes_read

      for _ = 1,element_count do
        key, bytes_read = reader(stream)
        all_bytes_read = all_bytes_read + bytes_read
        value, bytes_read = ByteBuf[reader_value_key](stream)
        all_bytes_read = all_bytes_read + bytes_read
        result[key] = value
      end
      return result, all_bytes_read
    else
      return nil, all_bytes_read
    end
  end

  -- @spec #r_varray(Stream, value_type: String, len: Integer): (result: Any[], bytes_read: Integer)
  function ic:r_varray(stream, value_type, len)
    local result = {}
    local reader_key = "r_" .. value_type
    local reader = ByteBuf[reader_key]
    local all_bytes_read = 0
    local bytes_read
    local value

    for i = 1,len do
      value, bytes_read = reader(stream)
      all_bytes_read = all_bytes_read + bytes_read
      result[i] = value
    end
    return result, all_bytes_read
  end

  -- @spec #r_array(Stream, value_type: String): (result: Any[], bytes_read: Integer)
  function ic:r_array(stream, value_type)
    local len, all_bytes_read = self:r_u32(stream)
    if len then
      local value, bytes_read = self:r_varray(stream, value_type, len)
      return value, all_bytes_read + bytes_read
    else
      return nil, all_bytes_read
    end
  end
end

-- @class Little extends ByteBuf.Base
ByteBuf.Little = ByteBuf.Base:extends("ByteBuf.Little")
do
  ic = ByteBuf.Little.instance_class

  -- @spec #w_iv(Stream, len: Integer, int: Integer): (bytes_written: Integer, error?: Error)
  function ic:w_iv(stream, len, int)
    local r = int
    local num_bytes = 0
    local byte
    local bytes_written
    local err

    for _ = 1,(len - 1) do
      byte = bit.band(r, 255)
      bytes_written, err = self:write(stream, byte)
      if err then
        return num_bytes, err
      end
      r = bit.rshift(r, 8)
      num_bytes = num_bytes + bytes_written
    end

    if int < 0 then
      -- set last bit to 1, meaning it's negative
      bytes_written, err = self:write(stream, bit.bor(bit.band(r, 127), 128))
      if err then
        return num_bytes, err
      end
      num_bytes = num_bytes + bytes_written
    else
      bytes_written, err = self:write(stream, bit.band(r, 127))
      if err then
        return num_bytes, err
      end
      num_bytes = num_bytes + bytes_written
    end

    return num_bytes
  end

  -- @spec #w_uv(Stream, len: Integer, int: Integer): (Integer, error: String | nil)
  function ic:w_uv(stream, len, int)
    local type = type(int)
    if type ~= "number" then
      error("expected value to be an integer (got "..type..")")
    end
    assert(int >= 0, "expected integer to be greater than or equal to 0")
    local r = int
    local num_bytes = 0
    local byte
    local bytes_written
    local err

    for _ = 1,len do
      byte = bit.band(r, 255)
      bytes_written, err = self:write(stream, byte)
      if err then
        return num_bytes, err
      end
      r = bit.rshift(r, 8)
      num_bytes = num_bytes + bytes_written
    end
    return num_bytes
  end

  -- @spec #r_iv(Stream, len: Integer): (result: Integer, bytes_read: Integer)
  function ic:r_iv(stream, len)
    local bytes, read_len = self:read(stream, len)
    if read_len < len then
      return nil, read_len, "read underflow"
    end

    return ByteDecoder:d_iv(bytes, len)
  end

  -- @spec #r_uv(Stream, len: Integer): (result: Integer, bytes_read: Integer)
  function ic:r_uv(stream, len)
    local bytes, read_len = self:read(stream, len)
    if read_len < len then
      return nil, read_len, "read underflow"
    end
    return ByteDecoder:d_uv(bytes, len)
  end
end

foundation.com.ByteBuf = ByteBuf
-- @const little: Little
foundation.com.ByteBuf.little = ByteBuf.Little:new()
