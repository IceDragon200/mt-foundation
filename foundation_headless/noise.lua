local bit = assert(foundation.com.bit)
local band = assert(bit.band)
local rshift = assert(bit.rshift)
local bxor = assert(bit.bxor)
local floor = assert(math.floor)
local abs = assert(math.abs)

--- @namespace foundation.com
local NOISE_MAGIC_X = 1619
local NOISE_MAGIC_Y = 31337
local NOISE_MAGIC_Z = 52591
-- Unsigned magic seed prevents undefined behavior.
local NOISE_MAGIC_SEED = 1013

--- Ported from Luanti's noise.cpp
--- @spec noise2d(x: Integer, y: Integer, seed: Number): Number
function foundation.com.noise2d(x, y, seed)
  local n = band(NOISE_MAGIC_X * x + NOISE_MAGIC_Y * y + NOISE_MAGIC_SEED * seed, 0x7fffffff)
  n = bxor(rshift(n, 13), n)
  n = band(n * (n * n * 60493 + 19990303) + 1376312589, 0x7fffffff)
  return 1.0 - n / 0x40000000
end

--- Ported from Luanti's noise.cpp
--- @spec noise3d(x: Integer, y: Integer, z: Integer, seed: Number): Number
function foundation.com.noise3d(x, y, z, seed)
  local n = band(NOISE_MAGIC_X * x + NOISE_MAGIC_Y * y + NOISE_MAGIC_Z * z + NOISE_MAGIC_SEED * seed, 0x7fffffff)
  n = bxor(rshift(n, 13), n)
  n = band(n * (n * n * 60493 + 19990303) + 1376312589, 0x7fffffff)
  return 1.0 - n / 0x40000000
end

--- Ported from Luanti's noise.cpp
--- @spec linear_interpolation(v0: Number, v1: Number, t: Number)
function foundation.com.linear_interpolation(v0, v1, t)
  return v0 + (v1 - v0) * t
end

--- Ported from Luanti's noise.cpp
--- @spec ease_curve(t: Number): Number
function foundation.com.ease_curve(t)
  return t * t * t * (t * (6 * t - 15) + 10)
end

local linear_interpolation = foundation.com.linear_interpolation
local ease_curve = foundation.com.ease_curve

--- Ported from Luanti's noise.cpp
--- @spec bilinear_interpolation(v00: Number, v10: Number, v01: Number, v11: Number, x: Number, y: Number, eased: Boolean): Number
function foundation.com.bilinear_interpolation(v00, v10, v01, v11, x, y, eased)
  -- Inlining will optimize this branch out when possible
  if eased then
    x = ease_curve(x)
    y = ease_curve(y)
  end
  local u = linear_interpolation(v00, v10, x)
  local v = linear_interpolation(v01, v11, x)
  return linear_interpolation(u, v, y)
end

--- Ported from Luanti's noise.cpp
--- @spec trilinear_interpolation(
---   v000: Number, v100: Number, v010: Number, v110: Number,
---   v001: Number, v101: Number, v011: Number, v111: Number,
---   x: Number, y: Number, z: Number,
---   eased: Boolean
--- ): Number
function foundation.com.trilinear_interpolation(
  v000, v100, v010, v110,
  v001, v101, v011, v111,
  x, y, z,
  eased
)
  -- Inlining will optimize this branch out when possible
  if eased then
    x = ease_curve(x)
    y = ease_curve(y)
    z = ease_curve(z)
  end
  local u = bilinear_interpolation(v000, v100, v010, v110, x, y, false)
  local v = bilinear_interpolation(v001, v101, v011, v111, x, y, false)
  return linear_interpolation(u, v, z)
end

local noise2d = foundation.com.noise2d
local noise3d = foundation.com.noise3d
local bilinear_interpolation = foundation.com.bilinear_interpolation
local trilinear_interpolation = foundation.com.trilinear_interpolation

--- Ported from Luanti's noise.cpp
--- @spec noise2d_value(x: Number, y: Number, seed: Integer, bool: Boolean): Number
function foundation.com.noise2d_value(x, y, seed, eased)
  -- Calculate the integer coordinates
  local x0 = floor(x)
  local y0 = floor(y)
  -- Calculate the remaining part of the coordinates
  local xl = x - x0
  local yl = y - y0
  -- Get values for corners of square
  local v00 = noise2d(x0, y0, seed)
  local v10 = noise2d(x0+1, y0, seed)
  local v01 = noise2d(x0, y0+1, seed)
  local v11 = noise2d(x0+1, y0+1, seed)
  -- Interpolate
  return bilinear_interpolation(v00, v10, v01, v11, xl, yl, eased)
end

--- Ported from Luanti's noise.cpp
--- @spec noise3d_value(x: Number, y: Number, z: Number, seed: Integer, eased: Boolean): Number
function foundation.com.noise3d_value(x, y, z, seed, eased)
  -- Calculate the integer coordinates
  local x0 = floor(x)
  local y0 = floor(y)
  local z0 = floor(z)
  -- Calculate the remaining part of the coordinates
  local xl = x - x0
  local yl = y - y0
  local zl = z - z0
  -- Get values for corners of cube
  local v000 = noise3d(x0,     y0,     z0,     seed)
  local v100 = noise3d(x0 + 1, y0,     z0,     seed)
  local v010 = noise3d(x0,     y0 + 1, z0,     seed)
  local v110 = noise3d(x0 + 1, y0 + 1, z0,     seed)
  local v001 = noise3d(x0,     y0,     z0 + 1, seed)
  local v101 = noise3d(x0 + 1, y0,     z0 + 1, seed)
  local v011 = noise3d(x0,     y0 + 1, z0 + 1, seed)
  local v111 = noise3d(x0 + 1, y0 + 1, z0 + 1, seed)
  -- Interpolate
  return trilinear_interpolation(
    v000, v100, v010, v110,
    v001, v101, v011, v111,
    xl, yl, zl,
    eased
  )
end

local noise2d_value = foundation.com.noise2d_value
local noise3d_value = foundation.com.noise3d_value

--- @spec noise_fractal_2d(np: Table, x: Number, y: Number, seed: Integer): Number
function foundation.com.noise_fractal_2d(np, x, y, seed)
  local a = 0
  local f = 1.0
  local g = 1.0

  x = x / np.spread.x
  y = x / np.spread.y
  seed = seed + np.seed

  local lacunarity = np.lacunarity
  local persist = np.persist
  local eased = np.defaults or np.eased
  local absvalue = np.absvalue
  if np.octaves > 0 then
    local noiseval
    for i = 0,np.octaves-1 do
      noiseval = noise2d_value(x * f, y * f, seed + i, eased)

      if absvalue then
        noiseval = abs(noiseval)
      end

      a = a + g * noiseval
      f = f * lacunarity
      g = g * persist
    end
  end

  return np.offset + a * np.scale
end

--- @spec noise_fractal_3d(np: Table, x: Number, y: Number, z: Number, seed: Integer): Number
function foundation.com.noise_fractal_3d(np, x, y, z, seed)
  local a = 0
  local f = 1.0
  local g = 1.0

  x = x / np.spread.x
  y = y / np.spread.y
  z = z / np.spread.z
  seed = seed + np.seed

  local lacunarity = np.lacunarity
  local persist = np.persist
  local eased = np.eased
  local absvalue = np.absvalue

  if np.octaves > 0 then
    local noiseval
    for i = 0,np.octaves-1 do
      noiseval = noise3d_value(x * f, y * f, z * f, seed + i, np.eased)

      if absvalue then
        noiseval = abs(noiseval)
      end

      a = a + g * noiseval
      f = f * lacunarity
      g = g * persist
    end
  end

  return np.offset + a * np.scale
end
