---
---
--- @namespace foundation.com.Matrix4x4

local m
m = {
  metatable = {
    __index = function (v, key)
      return m[key]
    end,
  },
}

--- @since "1.29.0"
--- @spec is_matrix4x4(obj: Any): Boolean
function m.is_matrix4x4(obj)
  return getmetatable(obj) == m.metatable
end

--- @since "1.29.0"
--- @mutative
--- @spec from_table(Table): Matrix4x4
function m.from_table(tab)
  assert(#tab == 16, "expected table to contain 16 elements")
  return setmetatable(tab, m.metatable)
end

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

--- Primarily used for testing matrices, generates a matrix with random values between -1 and 1.
--- The low and high ranges can be set to generate between low and high instead
---
--- @spec random(low?: Number, high?: Number): Matrix4x4
function m.random(low, high)
  low = low or -1
  high = high or 1

  assert(low < high, "expected low to be less than high")

  local size = high - low

  local mat = {}
  for i = 1,16 do
    mat[i] = math.random(size) + low
  end

  return m.from_table(mat)
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

--- @since "1.29.0"
--- @spec to_string(m1: Matrix4x4): String
function m.to_string(m1)
  return table.concat(m1, ",")
end

--- @since "1.29.0"
--- @spec inspect(m1: Matrix4x4): String
function m.inspect(m1)
  return "[" .. table.concat(m1, ",") .. "]"
end

--- @since "1.29.0"
--- @spec equals(m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.equals(m1, m2)
  return m1[1] == m2[1] and
    m1[2] == m2[2] and
    m1[3] == m2[3] and
    m1[4] == m2[4] and
    m1[5] == m2[5] and
    m1[6] == m2[6] and
    m1[7] == m2[7] and
    m1[8] == m2[8] and
    m1[9] == m2[9] and
    m1[10] == m2[10] and
    m1[11] == m2[11] and
    m1[12] == m2[12] and
    m1[13] == m2[13] and
    m1[14] == m2[14] and
    m1[15] == m2[15] and
    m1[16] == m2[16]
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

--- @since "1.29.0"
--- @mutative dest
--- @spec idivide(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.idivide(dest, m1, m2)
  dest[1] = math.floor(m1[1] / m2[1])
  dest[2] = math.floor(m1[2] / m2[2])
  dest[3] = math.floor(m1[3] / m2[3])
  dest[4] = math.floor(m1[4] / m2[4])
  dest[5] = math.floor(m1[5] / m2[5])
  dest[6] = math.floor(m1[6] / m2[6])
  dest[7] = math.floor(m1[7] / m2[7])
  dest[8] = math.floor(m1[8] / m2[8])
  dest[9] = math.floor(m1[9] / m2[9])
  dest[10] = math.floor(m1[10] / m2[10])
  dest[11] = math.floor(m1[11] / m2[11])
  dest[12] = math.floor(m1[12] / m2[12])
  dest[13] = math.floor(m1[13] / m2[13])
  dest[14] = math.floor(m1[14] / m2[14])
  dest[15] = math.floor(m1[15] / m2[15])
  dest[16] = math.floor(m1[16] / m2[16])
  return dest
end

--- @mutative dest
--- @spec add_vec4(dest: Matrix4x4, m1: Matrix4x4, v2: Vector4): Matrix4x4
function m.add_vec4(dest, m1, v2)
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
--- @spec subtract_vec4(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.subtract_vec4(dest, m1, v2)
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
--- @spec multiply_vec4(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.multiply_vec4(dest, m1, v2)
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
--- @spec divide_vec4(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.divide_vec4(dest, m1, v2)
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

--- @since "1.29.0"
--- @mutative dest
--- @spec idivide_vec4(dest: Matrix4x4, m1: Matrix4x4, m2: Matrix4x4): Matrix4x4
function m.idivide_vec4(dest, m1, v2)
  local v2x = v2.x
  local v2y = v2.y
  local v2z = v2.z
  local v2w = v2.w
  dest[1] = math.floor(m1[1] / v2x)
  dest[2] = math.floor(m1[2] / v2y)
  dest[3] = math.floor(m1[3] / v2z)
  dest[4] = math.floor(m1[4] / v2w)
  dest[5] = math.floor(m1[5] / v2x)
  dest[6] = math.floor(m1[6] / v2y)
  dest[7] = math.floor(m1[7] / v2z)
  dest[8] = math.floor(m1[8] / v2w)
  dest[9] = math.floor(m1[9] / v2x)
  dest[10] = math.floor(m1[10] / v2y)
  dest[11] = math.floor(m1[11] / v2z)
  dest[12] = math.floor(m1[12] / v2w)
  dest[13] = math.floor(m1[13] / v2x)
  dest[14] = math.floor(m1[14] / v2y)
  dest[15] = math.floor(m1[15] / v2z)
  dest[16] = math.floor(m1[16] / v2w)
  return dest
end

--- @since "1.29.0"
--- @mutative dest
--- @spec add_scalar(dest: Matrix4x4, m1: Matrix4x4, value: Number): Matrix4x4
function m.add_scalar(dest, m1, value)
  dest[1] = m1[1] + value
  dest[2] = m1[2] + value
  dest[3] = m1[3] + value
  dest[4] = m1[4] + value
  dest[5] = m1[5] + value
  dest[6] = m1[6] + value
  dest[7] = m1[7] + value
  dest[8] = m1[8] + value
  dest[9] = m1[9] + value
  dest[10] = m1[10] + value
  dest[11] = m1[11] + value
  dest[12] = m1[12] + value
  dest[13] = m1[13] + value
  dest[14] = m1[14] + value
  dest[15] = m1[15] + value
  dest[16] = m1[16] + value
  return dest
end

--- @since "1.29.0"
--- @mutative dest
--- @spec subtract_scalar(dest: Matrix4x4, m1: Matrix4x4, value: Number): Matrix4x4
function m.subtract_scalar(dest, m1, value)
  dest[1] = m1[1] - value
  dest[2] = m1[2] - value
  dest[3] = m1[3] - value
  dest[4] = m1[4] - value
  dest[5] = m1[5] - value
  dest[6] = m1[6] - value
  dest[7] = m1[7] - value
  dest[8] = m1[8] - value
  dest[9] = m1[9] - value
  dest[10] = m1[10] - value
  dest[11] = m1[11] - value
  dest[12] = m1[12] - value
  dest[13] = m1[13] - value
  dest[14] = m1[14] - value
  dest[15] = m1[15] - value
  dest[16] = m1[16] - value
  return dest
end

--- @since "1.29.0"
--- @mutative dest
--- @spec multiply_scalar(dest: Matrix4x4, m1: Matrix4x4, value: Number): Matrix4x4
function m.multiply_scalar(dest, m1, value)
  dest[1] = m1[1] * value
  dest[2] = m1[2] * value
  dest[3] = m1[3] * value
  dest[4] = m1[4] * value
  dest[5] = m1[5] * value
  dest[6] = m1[6] * value
  dest[7] = m1[7] * value
  dest[8] = m1[8] * value
  dest[9] = m1[9] * value
  dest[10] = m1[10] * value
  dest[11] = m1[11] * value
  dest[12] = m1[12] * value
  dest[13] = m1[13] * value
  dest[14] = m1[14] * value
  dest[15] = m1[15] * value
  dest[16] = m1[16] * value
  return dest
end

--- @since "1.29.0"
--- @mutative dest
--- @spec divide_scalar(dest: Matrix4x4, m1: Matrix4x4, value: Number): Matrix4x4
function m.divide_scalar(dest, m1, value)
  dest[1] = m1[1] / value
  dest[2] = m1[2] / value
  dest[3] = m1[3] / value
  dest[4] = m1[4] / value
  dest[5] = m1[5] / value
  dest[6] = m1[6] / value
  dest[7] = m1[7] / value
  dest[8] = m1[8] / value
  dest[9] = m1[9] / value
  dest[10] = m1[10] / value
  dest[11] = m1[11] / value
  dest[12] = m1[12] / value
  dest[13] = m1[13] / value
  dest[14] = m1[14] / value
  dest[15] = m1[15] / value
  dest[16] = m1[16] / value
  return dest
end

--- @since "1.29.0"
--- @mutative dest
--- @spec idivide_scalar(dest: Matrix4x4, m1: Matrix4x4, value: Number): Matrix4x4
function m.idivide_scalar(dest, m1, value)
  dest[1] = math.floor(m1[1] / value)
  dest[2] = math.floor(m1[2] / value)
  dest[3] = math.floor(m1[3] / value)
  dest[4] = math.floor(m1[4] / value)
  dest[5] = math.floor(m1[5] / value)
  dest[6] = math.floor(m1[6] / value)
  dest[7] = math.floor(m1[7] / value)
  dest[8] = math.floor(m1[8] / value)
  dest[9] = math.floor(m1[9] / value)
  dest[10] = math.floor(m1[10] / value)
  dest[11] = math.floor(m1[11] / value)
  dest[12] = math.floor(m1[12] / value)
  dest[13] = math.floor(m1[13] / value)
  dest[14] = math.floor(m1[14] / value)
  dest[15] = math.floor(m1[15] / value)
  dest[16] = math.floor(m1[16] / value)
  return dest
end

m.sub = assert(m.subtract)
m.mul = assert(m.multiply)
m.div = assert(m.divide)
m.idiv = assert(m.idivide)

m.sub_vec4 = assert(m.subtract_vec4)
m.mul_vec4 = assert(m.multiply_vec4)
m.div_vec4 = assert(m.divide_vec4)
m.idiv_vec4 = assert(m.idivide_vec4)

m.sub_scalar = assert(m.subtract_scalar)
m.mul_scalar = assert(m.multiply_scalar)
m.div_scalar = assert(m.divide_scalar)
m.idiv_scalar = assert(m.idivide_scalar)

--- @since "1.29.0"
--- @spec metatable.__tostring(Matrix4x4): String
m.metatable.__tostring = assert(m.to_string)

--- @since "1.29.0"
--- @spec metatable.__eq(Matrix4x4, Matrix4x4): Boolean
--- @spec #==(Matrix4x4, Matrix4x4): Boolean
m.metatable.__eq = assert(m.equals)

--- @since "1.29.0"
--- @spec m.metatable.__unm(Matrix4x4): Matrix4x4
--- @spec #~-(Matrix4x4): Matrix4x4
function m.metatable.__unm(m1)
  return m.new(
    -m1[0],
    -m1[1],
    -m1[2],
    -m1[3],
    -m1[4],
    -m1[5],
    -m1[6],
    -m1[7],
    -m1[8],
    -m1[9],
    -m1[10],
    -m1[11],
    -m1[12],
    -m1[13],
    -m1[14],
    -m1[15],
    -m1[16]
  )
end

--- @since "1.29.0"
--- @spec metatable.__add(Matrix4x4, Matrix4x4): Matrix4x4
--- @spec #+(Matrix4x4, Matrix4x4): Matrix4x4
function m.metatable.__add(a, b)
  local res = m.zero()

  if type(b) == "table" then
    if m.is_matrix4x4(b) then
      return m.add(res, a, b)
    end
    return m.add_vec4(res, a, b)
  end

  return m.add_scalar(res, a, b)
end

--- @since "1.29.0"
--- @spec metatable.__sub(Matrix4x4, Matrix4x4): Matrix4x4
--- @spec #-(Matrix4x4, Matrix4x4): Matrix4x4
function m.metatable.__sub(a, b)
  local res = m.zero()

  if type(b) == "table" then
    if m.is_matrix4x4(b) then
      return m.subtract(res, a, b)
    end
    return m.subtract_vec4(res, a, b)
  end

  return m.subtract_scalar(res, a, b)
end

--- @since "1.29.0"
--- @spec metatable.__mul(Matrix4x4, Matrix4x4): Matrix4x4
--- @spec #*(Matrix4x4, Matrix4x4): Matrix4x4
function m.metatable.__mul(a, b)
  local res = m.zero()

  if type(b) == "table" then
    if m.is_matrix4x4(b) then
      return m.multiply(res, a, b)
    end
    return m.multiply_vec4(res, a, b)
  end

  return m.multiply_scalar(res, a, b)
end

--- @since "1.29.0"
--- @spec metatable.__div(Matrix4x4, Matrix4x4): Matrix4x4
--- @spec #/(Matrix4x4, Matrix4x4): Matrix4x4
function m.metatable.__div(a, b)
  local res = m.zero()

  if type(b) == "table" then
    if m.is_matrix4x4(b) then
      return m.divide(res, a, b)
    end
    return m.divide_vec4(res, a, b)
  end

  return m.divide_scalar(res, a, b)
end

foundation.com.Matrix4x4 = m
