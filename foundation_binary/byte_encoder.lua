--
-- Byte Encoder
--
local bit = assert(foundation.com.bit)

-- Base module
local E = {}

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

-- Little Endian - Encoder
local LE = {}
setmetatable(LE, { __index = E })

-- Signed Integers
function LE:e_iv(len, int)
  local r = int
  local i = 0
  local result = {}
  for j = 1,(len - 1) do
    i = j
    local byte = bit.band(r, 255)
    result[i] = byte
    r = bit.rshift(r, 8)
  end
  i = i + 1
  if int < 0 then
    -- set last bit to 1, meaning it's negative
    result[i] = bit.bor(bit.band(r, 127), 128)
  else
    result[i] = bit.band(r, 127)
  end
  return string.char(unpack(result))
end

-- Unsigned Integers
function LE:e_uv(len, int)
  assert(int >= 0, "expected integer to be greater than or equal to 0")
  local r = int
  local result = {}

  for i = 1,len do
    local byte = bit.band(r, 255)
    result[i] = byte
    r = bit.rshift(r, 8)
  end
  return string.char(unpack(result))
end

-- Little Endian - Encoder
local BE = {}
setmetatable(BE, { __index = E })

-- Signed Integers
function BE:e_iv(len, int)
  local r = int
  local i = len
  local result = {}
  for j = 1,(len - 1) do
    local byte = bit.band(r, 255)
    result[i] = byte
    i = i - 1
    r = bit.rshift(r, 8)
  end
  if int < 0 then
    -- set last bit to 1, meaning it's negative
    result[i] = bit.bor(bit.band(r, 127), 128)
  else
    result[i] = bit.band(r, 127)
  end
  return string.char(unpack(result))
end

-- Unsigned Integers
function BE:e_uv(len, int)
  assert(int >= 0, "expected integer to be greater than or equal to 0")
  local r = int
  local result = {}

  local j = len
  for i = 1,len do
    local byte = bit.band(r, 255)
    -- 1+ is to compensate for lua's array offset
    result[j] = byte
    j = j - 1
    r = bit.rshift(r, 8)
  end
  return string.char(unpack(result))
end

foundation.com.ByteEncoder = {
  LE = LE,
  BE = BE,
}
