local table_freeze = assert(foundation.com.table_freeze)
local math_floor = assert(math.floor)

---
--- Foundation bit module
---
--- In case the ffi bit is available, then this module acts as a wrapper around it
--- Otherwise it will try it's best to implement the module in plain lua.
---
--- @namespace foundation.com.bit
foundation.com.bit = {}

local BITS = 32
local UINT32_MAX = 0xFFFFFFFF
local INT32_MAX = 0x7FFFFFFF
-- local INT32_MIN = -0x80000000

-- Lowercase Hex Table
local LHEX_TABLE = {
  [0] = "0",
  [1] = "1",
  [2] = "2",
  [3] = "3",
  [4] = "4",
  [5] = "5",
  [6] = "6",
  [7] = "7",
  [8] = "8",
  [9] = "9",
  [10] = "a",
  [11] = "b",
  [12] = "c",
  [13] = "d",
  [14] = "e",
  [15] = "f",
}

-- Uppercase Hex Table
local UHEX_TABLE = {
  [0] = "0",
  [1] = "1",
  [2] = "2",
  [3] = "3",
  [4] = "4",
  [5] = "5",
  [6] = "6",
  [7] = "7",
  [8] = "8",
  [9] = "9",
  [10] = "A",
  [11] = "B",
  [12] = "C",
  [13] = "D",
  [14] = "E",
  [15] = "F",
}

-- Only 32 bit operations to mirror the luajit one
-- Maps the bit position to the power of 2
local BIT_TABLE = {}

for i = 0,64 do
  BIT_TABLE[i] = math_floor(2 ^ i)
end

-- Only 32 bit operations to mirror the luajit one
table_freeze(BIT_TABLE)

local function to_u32(value)
  if value < 0 then
    return UINT32_MAX + value + 1
  else
    return value
  end
end

local function to_i32(value)
  if value > INT32_MAX then
    return value - UINT32_MAX - 1
  else
    return value
  end
end

local function to_u32_list(list)
  local result = {}
  for i, v in ipairs(list) do
    result[i] = to_u32(v)
  end
  return result
end

do
  local res
  res = to_u32(-1)
  assert(res == 0xFFFFFFFF, "expected " .. res .. " to be equal to 0xFFFFFFFF")

  res = to_u32(-2)
  assert(res == 0xFFFFFFFE, "expected " .. res .. " to be equal to 0xFFFFFFFE")

  res = to_i32(0xFFFFFFFF)
  assert(res == -1, "expected " .. res .. " to be equal to -1")
  res = to_i32(0xFFFFFFFE)
  assert(res == -2, "expected " .. res .. " to be equal to -2")
end

-- so you've chosen the hard way, good luck.
local function tohex(x, b)
  b = b or 8
  local ht = LHEX_TABLE
  if b < 0 then
    b = -b
    ht = UHEX_TABLE
  end
  local y = to_u32(x)
  local result = {}
  for i = 1,math_floor(b/2) do
    local byte = y % 256
    local lo = byte % 16
    local hi = math_floor(byte / 16)
    y = math_floor(y / 256)

    result[b - i * 2 + 1] = ht[hi]
    result[b - i * 2 + 2] = ht[lo]
  end
  return table.concat(result)
end

local function uarshift(x, n)
  error("I have no idea how to do this, sorry")
end

local function uband(...)
  local result = 0
  local v = to_u32_list({...})
  local j = #v
  local base
  local b

  for bit_index = 0,(BITS-1) do
    base = v[1] % 2
    v[1] = math_floor(v[1] / 2)
    for i = 2,j do
      if base > 0 then
        b = v[i] % 2
        if b == 0 then
          base = 0
        end
      end
      v[i] = math_floor(v[i] / 2)
    end
    if base > 0 then
      result = result + BIT_TABLE[bit_index]
    end
  end
  return result
end

local function ubnot(x)
  local result = 0
  local y = to_u32(x)
  local base
  for bit_index = 0,(BITS-1) do
    base = y % 2
    y = math_floor(y / 2)
    if base == 0 then
      result = result + BIT_TABLE[bit_index]
    end
  end
  return result
end

local function ubor(...)
  local result = 0
  local v = to_u32_list({...})
  local j = #v
  local base
  local b

  for bit_index = 0,(BITS-1) do
    base = v[1] % 2
    v[1] = math_floor(v[1] / 2)
    for i = 2,j do
      if base == 0 then
        b = v[i] % 2
        if b > 0 then
          base = 1
        end
      end
      v[i] = math_floor(v[i] / 2)
    end
    if base > 0 then
      result = result + BIT_TABLE[bit_index]
    end
  end

  return result
end

local function ubxor(...)
  local result = 0
  local v = to_u32_list({...})
  local j = #v
  local base
  local b

  for bit_index = 0,(BITS-1) do
    base = v[1] % 2
    v[1] = math_floor(v[1] / 2)
    for i = 2,j do
      b = v[i] % 2
      if base ~= b then
        base = 1
      else
        base = 0
      end
      v[i] = math_floor(v[i] / 2)
    end
    if base > 0 then
      result = result + BIT_TABLE[bit_index]
    end
  end

  return result
end

local function ulshift(x, n)
  assert(n >= 0)
  if n >= 32 then
    return 0
  end
  local result = to_u32(x) * BIT_TABLE[n]
  return result % 0x100000000
end

local function urshift(x, n)
  assert(n >= 0)
  if n >= 32 then
    return 0
  end
  return math.floor(to_u32(x) / BIT_TABLE[n])
end

local function urol(x, n)
  assert(n >= 0)
  local y = to_u32(x)
  local result = 0
  local b
  for bit_index = 0,(BITS-1) do
    b = y % 2
    if b > 0 then
      result = result + BIT_TABLE[(bit_index + n) % BITS]
    end
    y = math_floor(y / 2)
  end
  return result
end

local function uror(x, n)
  assert(n >= 0)
  local y = to_u32(x)
  local result = 0
  local b
  for bit_index = 0,(BITS-1) do
    b = y % 2
    if b > 0 then
      result = result + BIT_TABLE[(bit_index - n) % BITS]
    end
    y = math_floor(y / 2)
  end
  return result
end

local function ubswap(x)
  local a, b, c, d
  local y = to_u32(x)
  a = y % 256
  y = math_floor(y / 256)
  b = y % 256
  y = math_floor(y / 256)
  c = y % 256
  y = math_floor(y / 256)
  d = y % 256

  return ulshift(a, 24) + ulshift(b, 16) + ulshift(c, 8) + d
end

local function arshift(x, n)
  assert(n >= 0)
  if n == 0 then
    return to_signed(x)
  end
  if n >= 32 then
    n = 31
  end

  local y = to_u32(x)

  local result = math.floor(y / BIT_TABLE[n])

  if y >= 0x80000000 then
    local padding = 0xFFFFFFFF - (BIT_TABLE[32 - n] - 1)
    result = result + padding
  end

  return to_signed(result)
end

local function band(...)
  return to_i32(uband(...))
end

local function bnot(x)
  return to_i32(ubnot(x))
end

local function bor(...)
  return to_i32(ubor(...))
end

local function bxor(...)
  return to_i32(ubxor(...))
end

local function lshift(x, n)
  return to_i32(ulshift(x, n))
end

local function rshift(x, n)
  return to_i32(urshift(x, n))
end

local function rol(x, n)
  return to_i32(urol(x, n))
end

local function ror(x, n)
  return to_i32(uror(x, n))
end

local function bswap(x)
  return to_i32(ubswap(x))
end

foundation.com.local_bit = {}

-- Store the local implementation in case we need it
foundation.com.local_bit.BIT_TABLE = BIT_TABLE
foundation.com.local_bit.tohex = tohex
foundation.com.local_bit.arshift = arshift
foundation.com.local_bit.band = band
foundation.com.local_bit.bnot = bnot
foundation.com.local_bit.bor = bor
foundation.com.local_bit.bswap = bswap
foundation.com.local_bit.bxor = bxor
foundation.com.local_bit.lshift = lshift
foundation.com.local_bit.rol = rol
foundation.com.local_bit.ror = ror
foundation.com.local_bit.rshift = rshift

foundation.com.bit.BIT_TABLE = BIT_TABLE

if foundation_binary.native_bit then
  core.log("info", "using native bit module")
  -- native bit module is available, wrapper that mofo up
  foundation.com.bit.tohex = foundation_binary.native_bit.tohex
  foundation.com.bit.arshift = foundation_binary.native_bit.arshift
  foundation.com.bit.band = foundation_binary.native_bit.band
  foundation.com.bit.bnot = foundation_binary.native_bit.bnot
  foundation.com.bit.bor = foundation_binary.native_bit.bor
  foundation.com.bit.bswap = foundation_binary.native_bit.bswap
  foundation.com.bit.bxor = foundation_binary.native_bit.bxor
  foundation.com.bit.lshift = foundation_binary.native_bit.lshift
  foundation.com.bit.rol = foundation_binary.native_bit.rol
  foundation.com.bit.ror = foundation_binary.native_bit.ror
  foundation.com.bit.rshift = foundation_binary.native_bit.rshift
else
  core.log("info", "using local bit module")
  foundation.com.bit.tohex = foundation.com.local_bit.tohex
  foundation.com.bit.arshift = foundation.com.local_bit.arshift
  foundation.com.bit.band = foundation.com.local_bit.band
  foundation.com.bit.bnot = foundation.com.local_bit.bnot
  foundation.com.bit.bor = foundation.com.local_bit.bor
  foundation.com.bit.bswap = foundation.com.local_bit.bswap
  foundation.com.bit.bxor = foundation.com.local_bit.bxor
  foundation.com.bit.lshift = foundation.com.local_bit.lshift
  foundation.com.bit.rol = foundation.com.local_bit.rol
  foundation.com.bit.ror = foundation.com.local_bit.ror
  foundation.com.bit.rshift = foundation.com.local_bit.rshift
end
