--
-- Byte Encoder
--
local bit = assert(foundation.com.bit)
local SC = assert(foundation.com.BYTE2CHAR)
local ceil = assert(math.ceil)
local floor = assert(math.floor)
local string_pack = string.pack
local table_concat = assert(table.concat)

local WMAX = {}
for i = 1,8 do
  WMAX[i] = floor(256 ^ i)
end

-- Base module
local E = {}
do
  --- Floating Point Values - IEEE754
  --- http://eng.umb.edu/~cuckov/classes/engin341/Reference/IEEE754.pdf
  --- http://sandbox.mc.edu/~bennet/cs110/flt/ftod.html
  --- http://sandbox.mc.edu/~bennet/cs110/flt/dtof.html
  ---
  --- @spec #e_fv(exponent_bits: Number, mantissa_bits: Number, flt: Number): String
  function E:e_fv(exponent_bits, mantissa_bits, flt)
    local total_bits = 1 + exponent_bits + mantissa_bits
    local len = ceil(total_bits / 8)

    if flt == 0 then
      return self:e_iv(len, 0)
    end

    local sign = 0
    if flt < 0 then
      sign = 1
      flt = -flt
    end

    local fractional_part, exponent = math.frexp(flt)

    fractional_part = fractional_part * 2
    exponent = exponent - 1

    local bias = bit.BIT_TABLE[exponent_bits - 1] - 1
    local biased_exponent = exponent + bias

    fractional_part = fractional_part - 1

    local mantissa_payload = 0
    for i = 1, mantissa_bits do
      fractional_part = fractional_part * 2
      if fractional_part >= 1 then
        fractional_part = fractional_part - 1
        mantissa_payload = mantissa_payload + bit.BIT_TABLE[mantissa_bits - i]
      end
    end

    local int = sign
    int = int * bit.BIT_TABLE[exponent_bits] + biased_exponent
    int = int * bit.BIT_TABLE[mantissa_bits] + mantissa_payload

    return self:e_iv(len, int)
  end

  -- Signed Integers
  function E:e_iv(len, r)
    if r < 0 then
      r = WMAX[len] + r
    end

    return self:e_uv(len, r)
  end

  function E:e_i64(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(8, int)
  end

  function E:e_i56(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(7, int)
  end

  function E:e_i48(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(6, int)
  end

  function E:e_i40(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(5, int)
  end

  function E:e_i32(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(4, int)
  end

  function E:e_i24(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(3, int)
  end

  function E:e_i16(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(2, int)
  end

  function E:e_i8(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_iv(1, int)
  end

  function E:e_u64(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(8, int)
  end

  function E:e_u56(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(7, int)
  end

  function E:e_u48(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(6, int)
  end

  function E:e_u40(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(5, int)
  end

  function E:e_u32(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(4, int)
  end

  function E:e_u24(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(3, int)
  end

  function E:e_u16(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(2, int)
  end

  function E:e_u8(int)
    assert(type(int) == "number", "expected an integer")
    return self:e_uv(1, int)
  end

  --- @spec #e_f16(flt: Float): (bytes_written: Integer, err: Error)
  function E:e_f16(flt)
    return self:e_fv(5, 10, flt)
  end

  --- @spec #e_f24(flt: Float): (bytes_written: Integer, err: Error)
  function E:e_f24(flt)
    return self:e_fv(7, 15, flt)
  end

  --- @spec #e_f32(flt: Float): (bytes_written: Integer, err: Error)
  function E:e_f32(flt)
    return self:e_fv(8, 23, flt)
  end

  --- @spec #e_f64(flt: Float): (bytes_written: Integer, err: Error)
  function E:e_f64(flt)
    return self:e_fv(11, 52, flt)
  end
end

-- Little Endian - Encoder
local BE = {}
do
  setmetatable(BE, { __index = E })

  if string_pack then
    function BE:e_s8(int)
      return string_pack(">b", int)
    end

    function BE:e_s16(int)
      return string_pack(">h", int)
    end

    function BE:e_s32(int)
      return string_pack(">i4", int)
    end

    function BE:e_u8(int)
      return string_pack(">B", int)
    end

    function BE:e_u16(int)
      return string_pack(">H", int)
    end

    function BE:e_u32(int)
      return string_pack(">I4", int)
    end
  end

  -- Unsigned Integers
  function BE:e_uv(len, int)
    assert(int >= 0, "expected integer to be greater than or equal to 0")

    local r = int
    local result = {}
    for i = 1, len do
      result[len - i + 1] = SC[r % 256]
      r = floor(r / 256)
    end
    return table_concat(result)
  end
end


-- Little Endian - Encoder
local LE = {}
do
  setmetatable(LE, { __index = E })

  --
  if string_pack then
    function LE:e_s8(int)
      return string_pack("<b", int)
    end

    function LE:e_s16(int)
      return string_pack("<h", int)
    end

    function LE:e_s32(int)
      return string_pack("<i4", int)
    end

    function LE:e_u8(int)
      return string_pack("<B", int)
    end

    function LE:e_u16(int)
      return string_pack("<H", int)
    end

    function LE:e_u32(int)
      return string_pack("<I4", int)
    end
  end

  -- Unsigned Integers
  function LE:e_uv(len, int)
    assert(int >= 0, "expected integer to be greater than or equal to 0")
    local r = int
    local result = {}

    for i = 1,len do
      result[i] = SC[r % 256]
      r = floor(r / 256)
    end
    return table_concat(result)
  end
end

foundation.com.ByteEncoder = {
  BE = BE,
  LE = LE,
}
