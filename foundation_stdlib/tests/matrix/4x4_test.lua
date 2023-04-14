local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.Matrix4x4)

local case = Luna:new("foundation.com.Matrix4x4")

case:describe("&new/16", function (t2)
  t2:test("can initialize a new matrix", function (t3)
    local mat4x4 = subject.new(
      1, 2, 3, 4,
      5, 6, 7, 8,
      9, 10, 11, 12,
      13, 14, 15, 16
    )

    t3:assert_table_eq({
      1, 2, 3, 4,
      5, 6, 7, 8,
      9, 10, 11, 12,
      13, 14, 15, 16
    }, mat4x4)
  end)
end)

--
-- Module Functions
--

case:describe("add/3", function (t2)
  t2:test("can add to matrices together", function (t3)
    local mat3x3a = subject.random(-100, 100)
    local mat3x3b = subject.random(-100, 100)
    local mat3x3d = subject.zero()

    subject.add(mat3x3d, mat3x3a, mat3x3b)

    for i = 1,16 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3a[i]) + assert(mat3x3b[i]))
    end
  end)
end)

case:describe("subtract/3", function (t2)
  t2:test("can subtract one matrix from another", function (t3)
    local mat3x3a = subject.random(-100, 100)
    local mat3x3b = subject.random(-100, 100)
    local mat3x3d = subject.zero()

    subject.subtract(mat3x3d, mat3x3a, mat3x3b)

    for i = 1,16 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3a[i]) - assert(mat3x3b[i]))
    end
  end)
end)

case:describe("hadamard_multiply/3", function (t2)
  t2:test("can multiply two matrices using hadamard method", function (t3)
    local mat3x3a = subject.random(-100, 100)
    local mat3x3b = subject.random(-100, 100)
    local mat3x3d = subject.zero()

    subject.hadamard_multiply(mat3x3d, mat3x3a, mat3x3b)

    for i = 1,16 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3a[i]) * assert(mat3x3b[i]))
    end
  end)
end)

--
-- instance methods
--

case:describe("#+/2", function (t2)
  t2:test("can add to matrices together", function (t3)
    local mata = subject.random(-100, 100)
    local matb = subject.random(-100, 100)
    local matd = mata + matb

    for i = 1,16 do
      t3:assert_eq(assert(matd[i]), assert(mata[i]) + assert(matb[i]))
    end
  end)
end)

case:describe("#-/2", function (t2)
  t2:test("can subtract one matrix from another", function (t3)
    local mata = subject.random(-100, 100)
    local matb = subject.random(-100, 100)
    local matd = mata - matb

    for i = 1,16 do
      t3:assert_eq(assert(matd[i]), assert(mata[i]) - assert(matb[i]))
    end
  end)
end)

case:describe("#*/2", function (t2)
  t2:test("can multiply matrices", function (t3)
    local mata = subject.random(-100, 100)
    local matb = subject.random(-100, 100)
    local matd = mata * matb

    local mate = subject.zero()
    -- so basically compare the implementations (in reality * calls multiply, so they should be
    -- the same result)
    subject.multiply(mate, mata, matb)

    for i = 1,16 do
      t3:assert_eq(assert(matd[i]), assert(mate[i]))
    end
  end)
end)

case:describe("#//2", function (t2)
  t2:test("can divide matrices", function (t3)
    local mata = subject.random(1, 100)
    local matb = subject.random(1, 100)
    local matd = mata / matb

    local mate = subject.zero()
    -- so basically compare the implementations (in reality * calls multiply, so they should be
    -- the same result)
    subject.divide(mate, mata, matb)

    for i = 1,16 do
      t3:assert_eq(assert(matd[i]), assert(mate[i]))
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
