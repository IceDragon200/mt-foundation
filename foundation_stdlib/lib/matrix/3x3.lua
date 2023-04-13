---
---
--- @namespace foundation.com.Matrix3x3

local m = {
  metatable = {
    __index = function (v, key)
      return rawget(v, xy[key]) or vector2[key]
    end,

    __newindex = function (v, key, value)
      rawset(v, xy[key] or key, value)
    end,
  },
}

--- @spec new(
---   x1: Number,
---   y1: Number,
---   z1: Number,
---   x2: Number,
---   y2: Number,
---   z2: Number,
---   x3: Number,
---   y3: Number,
---   z3: Number
--- ): Matrix3x3
function m.new(x1, y1, z1, x2, y2, z2, x3, y3, z3)
  --- 1 2 3
  --- 4 5 6
  --- 7 8 9
  return setmetatable({
    x1, y1, z1,
    x2, y2, z2,
    x3, y3, z3
  }, m.metatable)
end

--- @spec zero(): Matrix3x3
function m.zero()
  return m.new(
    0, 0, 0,
    0, 0, 0,
    0, 0, 0
  )
end

--- @spec copy(m1: Matrix3x3): Matrix3x3
function m.copy(m1)
  return m.new(
    m1[1],
    m1[2],
    m1[3],
    m1[4],
    m1[5],
    m1[6],
    m1[7],
    m1[8],
    m1[9]
  )
end

--- @mutative dest
--- @spec add(dest: Matrix3x3, m1: Matrix3x3, m2: Matrix3x3): Matrix3x3
function m.add(dest, m1, m2)
  dest[1] = m1[1] + m2[1]
  dest[2] = m1[2] + m2[2]
  dest[3] = m1[3] + m2[3]
  dest[4] = m1[4] + m2[4]
  dest[5] = m1[5] + m2[5]
  dest[6] = m1[6] + m2[6]
  dest[7] = m1[7] + m2[7]
  dest[8] = m1[8] + m2[8]
  dest[9] = m1[9] + m2[9]
  return dest
end

--- @mutative dest
--- @spec subtract(dest: Matrix3x3, m1: Matrix3x3, m2: Matrix3x3): Matrix3x3
function m.subtract(dest, m1, m2)
  dest[1] = m1[1] - m2[1]
  dest[2] = m1[2] - m2[2]
  dest[3] = m1[3] - m2[3]
  dest[4] = m1[4] - m2[4]
  dest[5] = m1[5] - m2[5]
  dest[6] = m1[6] - m2[6]
  dest[7] = m1[7] - m2[7]
  dest[8] = m1[8] - m2[8]
  dest[9] = m1[9] - m2[9]
  return dest
end

--- Hadamard Product of 2 matrices
--- https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
---
--- @mutative dest
--- @spec hadamard_multiply(dest: Matrix3x3, m1: Matrix3x3, m2: Matrix3x3): Matrix3x3
function m.hadamard_multiply(dest, m1, m2)
  dest[1] = m1[1] * m2[1]
  dest[2] = m1[2] * m2[2]
  dest[3] = m1[3] * m2[3]
  dest[4] = m1[4] * m2[4]
  dest[5] = m1[5] * m2[5]
  dest[6] = m1[6] * m2[6]
  dest[7] = m1[7] * m2[7]
  dest[8] = m1[8] * m2[8]
  dest[9] = m1[9] * m2[9]
  return dest
end

--- Matrix Product of 2 matrices
--- https://en.wikipedia.org/wiki/Matrix_multiplication
---
--- @mutative dest
--- @spec multiply(dest: Matrix3x3, m1: Matrix3x3, m2: Matrix3x3): Matrix3x3
function m.multiply(dest, m1, m2)
  --- Matrices make my head hurt!
  dest[1] = m1[1] * m2[1] + m1[2] * m2[4] + m1[3] * m2[7]
  dest[2] = m1[1] * m2[2] + m1[2] * m2[5] + m1[3] * m2[8]
  dest[3] = m1[1] * m2[3] + m1[2] * m2[6] + m1[3] * m2[9]
  dest[4] = m1[4] * m2[1] + m1[5] * m2[4] + m1[6] * m2[7]
  dest[5] = m1[4] * m2[2] + m1[5] * m2[5] + m1[6] * m2[8]
  dest[6] = m1[4] * m2[3] + m1[5] * m2[6] + m1[6] * m2[9]
  dest[7] = m1[7] * m2[1] + m1[8] * m2[4] + m1[9] * m2[7]
  dest[8] = m1[7] * m2[2] + m1[8] * m2[5] + m1[9] * m2[8]
  dest[9] = m1[7] * m2[3] + m1[8] * m2[6] + m1[9] * m2[9]
  return dest
end

--- @mutative dest
--- @spec divide(dest: Matrix3x3, m1: Matrix3x3, m2: Matrix3x3): Matrix3x3
function m.divide(dest, m1, m2)
  dest[1] = m1[1] / m2[1]
  dest[2] = m1[2] / m2[2]
  dest[3] = m1[3] / m2[3]
  dest[4] = m1[4] / m2[4]
  dest[5] = m1[5] / m2[5]
  dest[6] = m1[6] / m2[6]
  dest[7] = m1[7] / m2[7]
  dest[8] = m1[8] / m2[8]
  dest[9] = m1[9] / m2[9]
  return dest
end

--- @mutative dest
--- @spec add_vec3(dest: Matrix3x3, m1: Matrix3x3, v2: Vector3): Matrix3x3
function m.add_vec3(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  dest[1] = m1[1] + v2x
  dest[2] = m1[2] + v2y
  dest[3] = m1[3] + v2z
  dest[4] = m1[4] + v2x
  dest[5] = m1[5] + v2y
  dest[6] = m1[6] + v2z
  dest[7] = m1[7] + v2x
  dest[8] = m1[8] + v2y
  dest[9] = m1[9] + v2z
  return dest
end

--- @mutative dest
--- @spec subtract_vec3(dest: Matrix3x3, m1: Matrix3x3, v2: Vector3): Matrix3x3
function m.subtract_vec3(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  dest[1] = m1[1] - v2x
  dest[2] = m1[2] - v2y
  dest[3] = m1[3] - v2z
  dest[4] = m1[4] - v2x
  dest[5] = m1[5] - v2y
  dest[6] = m1[6] - v2z
  dest[7] = m1[7] - v2x
  dest[8] = m1[8] - v2y
  dest[9] = m1[9] - v2z
  return dest
end

--- @mutative dest
--- @spec multiply_vec3(dest: Matrix3x3, m1: Matrix3x3, v2: Vector3): Matrix3x3
function m.multiply_vec3(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  dest[1] = m1[1] * v2x
  dest[2] = m1[2] * v2y
  dest[3] = m1[3] * v2z
  dest[4] = m1[4] * v2x
  dest[5] = m1[5] * v2y
  dest[6] = m1[6] * v2z
  dest[7] = m1[7] * v2x
  dest[8] = m1[8] * v2y
  dest[9] = m1[9] * v2z
  return dest
end

--- @mutative dest
--- @spec divide_vec3(dest: Matrix3x3, m1: Matrix3x3, v2: Vector3): Matrix3x3
function m.divide_vec3(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  dest[1] = m1[1] / v2x
  dest[2] = m1[2] / v2y
  dest[3] = m1[3] / v2z
  dest[4] = m1[4] / v2x
  dest[5] = m1[5] / v2y
  dest[6] = m1[6] / v2z
  dest[7] = m1[7] / v2x
  dest[8] = m1[8] / v2y
  dest[9] = m1[9] / v2z
  return dest
end

foundation.com.Matrix3x3 = m
