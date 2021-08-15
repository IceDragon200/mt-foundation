-- @namespace foundation.com

local STRING_POOL16 = "ABCDEF0123456789"
local STRING_POOL32 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
local STRING_POOL36 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local STRING_POOL62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

function foundation.com.random_string(length, pool)
  pool = pool or STRING_POOL62
  local pool_size = #pool
  local result = {}
  for i = 1,length do
    local pos = math.random(pool_size - 1)
    result[i] = assert(string.sub(pool, pos, pos))
  end
  return table.concat(result)
end

function foundation.com.random_string16(length)
  return foundation.com.random_string(length, STRING_POOL16)
end

function foundation.com.random_string32(length)
  return foundation.com.random_string(length, STRING_POOL32)
end

function foundation.com.random_string36(length)
  return foundation.com.random_string(length, STRING_POOL36)
end

function foundation.com.random_string62(length)
  return foundation.com.random_string(length, STRING_POOL62)
end
