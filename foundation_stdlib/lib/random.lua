--- @namespace foundation.com

--- Any random number generator that exposes a next/{0,2} function.
---
--- @type RNG: {
---   next: (min?: Integer, max?: Integer) => Integer,
--- }

local STRING_POOL16 = "ABCDEF0123456789"
local STRING_POOL32 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
local STRING_POOL36 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local STRING_POOL62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

-- Only 32 bit operations to mirror the luajit one
-- Maps the bit position to the power of 2
local BIT_TABLE = {}
local BITS = 32

for i = 0,BITS do
  BIT_TABLE[i] = math.floor(math.pow(2, i))
end

--- @since "1.43.0"
--- @spec random_addr(
---   element_size: 1..32,
---   element_count: Integer,
---   seperator?: String,
---   rng?: RNG
--- ): String
function foundation.com.random_addr16(element_size, element_count, seperator, rng)
  assert(element_size <= BITS)
  local result = {}
  local ri = 0
  seperator = seperator or ":"
  local element_range = BIT_TABLE[element_size]
  -- how many divisions must be performed on an element
  local d = math.ceil(element_size / 4)
  local b = 0
  local e = 0
  for i = 1,element_count do
    if rng then
      e = rng.next(0, element_range - 1)
    else
      e = math.random(element_range - 1)
    end

    ri = ri + 1
    for j = 1,d do
      b = e % 16
      e = math.floor(e / 16)
      result[ri + d - j] = string.sub(STRING_POOL16, b + 1, b + 1)
    end
    ri = ri + d - 1

    if i < element_count then
      ri = ri + 1
      result[ri] = seperator
    end
  end

  return table.concat(result)
end

---
--- @spec random_string(length: Integer, pool: String, rng?: RNG): String
function foundation.com.random_string(length, pool, rng)
  pool = pool or STRING_POOL62
  local pool_size = #pool
  local result = {}
  local pos
  for i = 1,length do
    if rng then
      pos = rng.next(1, pool_size - 1)
    else
      pos = math.random(pool_size - 1)
    end
    result[i] = string.sub(pool, pos, pos)
  end
  return table.concat(result)
end

--- @spec random_string16(length: Integer, rng: RNG): String
function foundation.com.random_string16(length, rng)
  return foundation.com.random_string(length, STRING_POOL16, rng)
end

--- @spec random_string32(length: Integer, rng: RNG): String
function foundation.com.random_string32(length, rng)
  return foundation.com.random_string(length, STRING_POOL32, rng)
end

--- @spec random_string36(length: Integer, rng: RNG): String
function foundation.com.random_string36(length, rng)
  return foundation.com.random_string(length, STRING_POOL36, rng)
end

--- @spec random_string62(length: Integer, rng: RNG): String
function foundation.com.random_string62(length, rng)
  return foundation.com.random_string(length, STRING_POOL62, rng)
end
