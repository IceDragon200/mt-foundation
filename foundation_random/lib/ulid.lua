--
-- ULID
-- https://github.com/ulid/spec
-- @namespace foundation.com.ULID
local integer_le_encode = assert(foundation.com.integer_le_encode)
local integer_be_encode = assert(foundation.com.integer_be_encode)
local integer_hex_be_encode = assert(foundation.com.integer_hex_be_encode)
local list_crawford_base32_le_rolling_encode_table = assert(foundation.com.list_crawford_base32_le_rolling_encode_table)
local ULID = {}

local secrand = SecureRandom()

-- Formats the given integers as a ULID binary (little-endian)
--
-- @spec format_le_binary(time48: U48, random_a48: U48, random_b32: U32): String
local function format_le_binary(time48, random_a48, random_b32)
  return integer_le_encode(time48, 6) ..
         integer_le_encode(random_a48, 6) ..
         integer_le_encode(random_b32, 4)
end

-- Formats the given integers as a ULID binary (big-endian)
--
-- @spec format_le_binary(time48: U48, random_a32: U32, random_b32: U32): String
local function format_be_binary(time48, random_a48, random_b32)
  return integer_be_encode(time48, 6) ..
         integer_be_encode(random_a48, 6) ..
         integer_be_encode(random_b32, 4)
end

local function format_hex_be_string(time48, random_a48, random_b32)
  return integer_hex_be_encode(time48, 6) ..
         integer_hex_be_encode(random_a48, 6) ..
         integer_hex_be_encode(random_b32, 4)
end

local function right_unroll_table(target, source, i, len)
  local l = #source

  for _ = 1,len do
    target[i] = source[l]
    i = i + 1
    l = l - 1
  end

  return i, target
end

-- @spec format_string(time48: Integer, random_a48: Integer | String, random_b32: Integer | String): String
local function format_string(time48, random_a48, random_b32)
  local result = list_crawford_base32_le_rolling_encode_table(6, time48, 6, random_a48, 4, random_b32)
  local i = #result

  if i < 26 then
    i = i + 1
    for x = i,26 do
      result[x] = "0"
    end
  elseif i > 26 then
    while i > 26 do
      result[i] = nil
      i = i - 1
    end
  end

  return table.concat(result)
end

local sequence

-- @spec sequence(time48: Integer): String
if secrand then
  minetest.log("info", "secure random is available, using that for random instead")
  sequence = function (time48)
    local a = secrand:next_bytes(6)
    local b = secrand:next_bytes(4)
    return format_string(time48, a, b)
  end
else
  sequence = function (time48)
    local a = math.random(0xFFFFFFFFFFFF)
    local b = math.random(0xFFFFFFFF)
    return format_string(time48, a, b)
  end
end

-- Generates a ULID string, note however it uses minetest.get_gametime/0
-- internally, this function will return nil during load process.
-- Optionally a timestamp can be provided to generate using that instead of
-- minetest.get_gametime/0, this can be useful for use with custom timers.
--
-- @spec generate(time48?: Integer): String
local function generate(time48)
  local time =
    time48 or
    math.floor(minetest.get_us_time() / 1000)

  -- ULIDs expect milliseconds
  return sequence(time)
end

foundation.com.ULID = {
  format_le_binary = format_le_binary,
  format_be_binary = format_be_binary,
  format_hex_be_string = format_hex_be_string,
  format_string = format_string,
  sequence = sequence,
  generate = generate,
}
