---
---
--- @namespace foundation.com.Matrix4x4

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
---   w1: Number,
---   x2: Number,
---   y2: Number,
---   z2: Number,
---   w2: Number,
---   x3: Number,
---   y3: Number,
---   z3: Number,
---   w3: Number,
---   x4: Number,
---   y4: Number,
---   z4: Number,
---   w4: Number
--- ): Matrix4x4
function m.new(x1, y1, z1, w1, x2, y2, z2, w2, x3, y3, z3, w3, x4, y4, z4, w4)
  ---  1  2  3  4
  ---  5  6  7  8
  ---  9 10 11 12
  --- 13 14 15 16
  return setmetatable({
    x1, y1, z1, w1,
    x2, y2, z2, w2,
    x3, y3, z3, w3,
    x4, y4, z4, w4
  }, m.metatable)
end

--- @spec zero(): Matrix4x4
function m.zero()
  return m.new(
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0
  )
end

--- @spec copy(m1: Matrix4x4): Matrix4x4
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
    m1[9],
    m1[10],
    m1[11],
    m1[12],
    m1[13],
    m1[14],
    m1[15],
    m1[16]
  )
end

--- @mutative dest
--- @spec add(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
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
  dest[10] = m1[10] + m2[10]
  dest[11] = m1[11] + m2[11]
  dest[12] = m1[12] + m2[12]
  dest[13] = m1[13] + m2[13]
  dest[14] = m1[14] + m2[14]
  dest[15] = m1[15] + m2[15]
  dest[16] = m1[16] + m2[16]
  return dest
end

--- @mutative dest
--- @spec subtract(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
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
  dest[10] = m1[10] - m2[10]
  dest[11] = m1[11] - m2[11]
  dest[12] = m1[12] - m2[12]
  dest[13] = m1[13] - m2[13]
  dest[14] = m1[14] - m2[14]
  dest[15] = m1[15] - m2[15]
  dest[16] = m1[16] - m2[16]
  return dest
end

--- Hadamard Product of 2 matrices
--- https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
---
--- @mutative dest
--- @spec hadamard_multiply(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
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
  dest[10] = m1[10] * m2[10]
  dest[11] = m1[11] * m2[11]
  dest[12] = m1[12] * m2[12]
  dest[13] = m1[13] * m2[13]
  dest[14] = m1[14] * m2[14]
  dest[15] = m1[15] * m2[15]
  dest[16] = m1[16] * m2[16]
  return dest
end

--- Matrix Product of 2 matrices
--- https://en.wikipedia.org/wiki/Matrix_multiplication
---
--- @mutative dest
--- @spec multiply(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.multiply(dest, m1, m2)
  --- And I thought 3x3 was a headache, heh
  dest[1]  = m1[1]  * m2[1] + m1[2]  * m2[5] + m1[3]  * m2[9]  + m1[4]  * m2[13]
  dest[2]  = m1[1]  * m2[2] + m1[2]  * m2[6] + m1[3]  * m2[10] + m1[4]  * m2[14]
  dest[3]  = m1[1]  * m2[3] + m1[2]  * m2[7] + m1[3]  * m2[11] + m1[4]  * m2[15]
  dest[4]  = m1[1]  * m2[4] + m1[2]  * m2[8] + m1[3]  * m2[12] + m1[4]  * m2[16]
  dest[5]  = m1[5]  * m2[1] + m1[6]  * m2[5] + m1[7]  * m2[9]  + m1[8]  * m2[13]
  dest[6]  = m1[5]  * m2[2] + m1[6]  * m2[6] + m1[7]  * m2[10] + m1[8]  * m2[14]
  dest[7]  = m1[5]  * m2[3] + m1[6]  * m2[7] + m1[7]  * m2[11] + m1[8]  * m2[15]
  dest[8]  = m1[5]  * m2[4] + m1[6]  * m2[8] + m1[7]  * m2[12] + m1[8]  * m2[16]
  dest[9]  = m1[9]  * m2[1] + m1[10] * m2[5] + m1[11] * m2[9]  + m1[12] * m2[13]
  dest[10] = m1[9]  * m2[2] + m1[10] * m2[6] + m1[11] * m2[10] + m1[12] * m2[14]
  dest[11] = m1[9]  * m2[3] + m1[10] * m2[7] + m1[11] * m2[11] + m1[12] * m2[15]
  dest[12] = m1[9]  * m2[4] + m1[10] * m2[8] + m1[11] * m2[12] + m1[12] * m2[16]
  dest[13] = m1[13] * m2[1] + m1[14] * m2[5] + m1[15] * m2[9]  + m1[16] * m2[13]
  dest[14] = m1[13] * m2[2] + m1[14] * m2[6] + m1[15] * m2[10] + m1[16] * m2[14]
  dest[15] = m1[13] * m2[3] + m1[14] * m2[7] + m1[15] * m2[11] + m1[16] * m2[15]
  dest[16] = m1[13] * m2[4] + m1[14] * m2[8] + m1[15] * m2[12] + m1[16] * m2[16]
  return dest
end

--- @mutative dest
--- @spec divide(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
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
  dest[10] = m1[10] / m2[10]
  dest[11] = m1[11] / m2[11]
  dest[12] = m1[12] / m2[12]
  dest[13] = m1[13] / m2[13]
  dest[14] = m1[14] / m2[14]
  dest[15] = m1[15] / m2[15]
  dest[16] = m1[16] / m2[16]
  return dest
end

--- @mutative dest
--- @spec add_vec(dest: Matrix4x4, m1: Matrix4x4, v2: Vector4): Matrix4x4
function m.add_vec(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  local v2w = v2.w
  dest[1] = m1[1] + v2x
  dest[2] = m1[2] + v2y
  dest[3] = m1[3] + v2z
  dest[4] = m1[4] + v2w
  dest[5] = m1[5] + v2x
  dest[6] = m1[6] + v2y
  dest[7] = m1[7] + v2z
  dest[8] = m1[8] + v2w
  dest[9] = m1[9] + v2x
  dest[10] = m1[10] + v2y
  dest[11] = m1[11] + v2z
  dest[12] = m1[12] + v2w
  dest[13] = m1[13] + v2x
  dest[14] = m1[14] + v2y
  dest[15] = m1[15] + v2z
  dest[16] = m1[16] + v2w
  return dest
end

--- @mutative dest
--- @spec subtract_vec(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.subtract_vec(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  local v2w = v2.w
  dest[1] = m1[1] - v2x
  dest[2] = m1[2] - v2y
  dest[3] = m1[3] - v2z
  dest[4] = m1[4] - v2w
  dest[5] = m1[5] - v2x
  dest[6] = m1[6] - v2y
  dest[7] = m1[7] - v2z
  dest[8] = m1[8] - v2w
  dest[9] = m1[9] - v2x
  dest[10] = m1[10] - v2y
  dest[11] = m1[11] - v2z
  dest[12] = m1[12] - v2w
  dest[13] = m1[13] - v2x
  dest[14] = m1[14] - v2y
  dest[15] = m1[15] - v2z
  dest[16] = m1[16] - v2w
  return dest
end

--- @mutative dest
--- @spec multiply_vec(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.multiply_vec(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  local v2w = v2.w
  dest[1] = m1[1] * v2x
  dest[2] = m1[2] * v2y
  dest[3] = m1[3] * v2z
  dest[4] = m1[4] * v2w
  dest[5] = m1[5] * v2x
  dest[6] = m1[6] * v2y
  dest[7] = m1[7] * v2z
  dest[8] = m1[8] * v2w
  dest[9] = m1[9] * v2x
  dest[10] = m1[10] * v2y
  dest[11] = m1[11] * v2z
  dest[12] = m1[12] * v2w
  dest[13] = m1[13] * v2x
  dest[14] = m1[14] * v2y
  dest[15] = m1[15] * v2z
  dest[16] = m1[16] * v2w
  return dest
end

--- @mutative dest
--- @spec divide_vec(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.divide_vec(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  local v2w = v2.w
  dest[1] = m1[1] / v2x
  dest[2] = m1[2] / v2y
  dest[3] = m1[3] / v2z
  dest[4] = m1[4] / v2w
  dest[5] = m1[5] / v2x
  dest[6] = m1[6] / v2y
  dest[7] = m1[7] / v2z
  dest[8] = m1[8] / v2w
  dest[9] = m1[9] / v2x
  dest[10] = m1[10] / v2y
  dest[11] = m1[11] / v2z
  dest[12] = m1[12] / v2w
  dest[13] = m1[13] / v2x
  dest[14] = m1[14] / v2y
  dest[15] = m1[15] / v2z
  dest[16] = m1[16] / v2w
  return dest
end

foundation.com.Matrix4x4 = m
