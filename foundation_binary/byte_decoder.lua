--
-- Little Endian - Byte Decoder
--
local bit = assert(foundation.com.bit)
local ceil = assert(math.ceil)
local floor = assert(math.floor)
local string_byte = assert(string.byte)

local FLT_TABLE = {}
for k, v in pairs(bit.BIT_TABLE) do
  FLT_TABLE[k] = v
end
for k = -64,-1 do
  FLT_TABLE[k] = 2 ^ k
end

local INT_MAX = {
  [0] = 1,
  [1] = floor(2 ^ 8),
  [2] = floor(2 ^ 16),
  [3] = floor(2 ^ 24),
  [4] = floor(2 ^ 32),
  [5] = floor(2 ^ 40),
  [6] = floor(2 ^ 48),
  [7] = floor(2 ^ 56),
  [8] = floor(2 ^ 64),
}

--- @namespace foundation.com.E
local E = {}
do
  --- Floating Point Values - IEEE754
  --- http://eng.umb.edu/~cuckov/classes/engin341/Reference/IEEE754.pdf
  --- http://sandbox.mc.edu/~bennet/cs110/flt/ftod.html
  --- http://sandbox.mc.edu/~bennet/cs110/flt/dtof.html
  ---
  --- @spec #d_fv(bytes: String, exponent_bits: Integer, mantissa_bits: Integer):
  ---   (flt: Number, len: Integer)
  function E:d_fv(bytes, exponent_bits, mantissa_bits)
    local total_bits = 1 + exponent_bits + mantissa_bits
    local len = ceil(total_bits / 8)

    local mantissa_size = FLT_TABLE[mantissa_bits]
    local exponent_size = FLT_TABLE[exponent_bits]

    local n = self:d_iv(bytes, len)
    if n == 0 then
      return n, len
    end
    local mantissa = n % mantissa_size
    n = floor(n / mantissa_size)
    local biased_exponent = n % exponent_size
    n = floor(n / exponent_size)
    local sign = n % 2

    local bias = FLT_TABLE[exponent_bits - 1] - 1

    local flt
    if biased_exponent == 0 then
      if mantissa == 0 then
        flt = 0.0
      else
        local fraction = mantissa / mantissa_size
        flt = fraction * FLT_TABLE[1 - bias]
      end
    elseif biased_exponent == exponent_size - 1 then
      if mantissa == 0 then
        flt = math.huge
      else
        flt = 0/0
      end
    else
      local exponent = floor(biased_exponent - bias)
      local fraction = 1.0 + (mantissa / mantissa_size)
      flt = fraction * (FLT_TABLE[exponent] or (2 ^ exponent))
    end

    -- Apply the sign bit marker
    if sign == 1 then
      flt = -flt
    end

    return flt, len
  end

  --- @spec &d_iv(String, len: Integer): (result: Integer, len: Integer)
  function E:d_iv(bytes, len)
    local result = self:d_uv(bytes, len)

    if result >= FLT_TABLE[(8 * len) - 1] then
      return result - INT_MAX[len], len
    else
      return result, len
    end
  end

  function E:d_i64(bytes)
    return self:d_iv(bytes, 8)
  end

  function E:d_i56(bytes)
    return self:d_iv(bytes, 7)
  end

  function E:d_i48(bytes)
    return self:d_iv(bytes, 6)
  end

  function E:d_i40(bytes)
    return self:d_iv(bytes, 5)
  end

  function E:d_i32(bytes)
    return self:d_iv(bytes, 4)
  end

  function E:d_i24(bytes)
    return self:d_iv(bytes, 3)
  end

  function E:d_i16(bytes)
    return self:d_iv(bytes, 2)
  end

  function E:d_i8(bytes)
    return self:d_iv(bytes, 1)
  end

  function E:d_u64(bytes)
    return self:d_uv(bytes, 8)
  end

  function E:d_u56(bytes)
    return self:d_uv(bytes, 7)
  end

  function E:d_u48(bytes)
    return self:d_uv(bytes, 6)
  end

  function E:d_u40(bytes)
    return self:d_uv(bytes, 5)
  end

  function E:d_u32(bytes)
    return self:d_uv(bytes, 4)
  end

  function E:d_u24(bytes)
    return self:d_uv(bytes, 3)
  end

  function E:d_u16(bytes)
    return self:d_uv(bytes, 2)
  end

  function E:d_u8(bytes)
    return self:d_uv(bytes, 1)
  end

  function E:d_f16(bytes)
    return self:d_fv(bytes, 5, 10)
  end

  function E:d_f24(bytes)
    return self:d_fv(bytes, 7, 15)
  end

  function E:d_f32(bytes)
    return self:d_fv(bytes, 8, 23)
  end

  function E:d_f64(bytes)
    return self:d_fv(bytes, 11, 52)
  end
end

-- Little Endian - Encoder
local LE = {}
do
  setmetatable(LE, { __index = E })

  --- @spec &d_uv(String, len: Integer): (result: Integer, len: Integer)
  function LE:d_uv(bytes, len)
    local result = 0
    for i = 1,len do
      result = result + string_byte(bytes, i) * INT_MAX[i - 1]
    end
    return result, len
  end
end

-- Big Endian - Encoder
local BE = {}
do
  setmetatable(BE, { __index = E })

  --- @spec &d_uv(String, len: Integer): (result: Integer, len: Integer)
  function BE:d_uv(bytes, len)
    local result = 0
    for i = 1,len do
      result = result + string_byte(bytes, i) * INT_MAX[len - i]
    end
    return result, len
  end
end

foundation.com.ByteDecoder = {
  BE = BE,
  LE = LE,
}
