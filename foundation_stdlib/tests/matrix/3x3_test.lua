local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.Matrix3x3)

local case = Luna:new("foundation.com.Matrix3x3")

case:describe("&new/9", function (t2)
  t2:test("can initialize a new matrix", function (t3)
    local mat3x3 = subject.new(
      1, 2, 3,
      4, 5, 6,
      7, 8, 9
    )

    t3:assert_table_eq({
      1, 2, 3,
      4, 5, 6,
      7, 8, 9
    }, mat3x3)
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

    for i = 1,9 do
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

    for i = 1,9 do
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

    for i = 1,9 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3a[i]) * assert(mat3x3b[i]))
    end
  end)
end)

--
-- instance methods
--

case:describe("#+/2", function (t2)
  t2:test("can add to matrices together", function (t3)
    local mat3x3a = subject.random(-100, 100)
    local mat3x3b = subject.random(-100, 100)
    local mat3x3d = mat3x3a + mat3x3b

    for i = 1,9 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3a[i]) + assert(mat3x3b[i]))
    end
  end)
end)

case:describe("#-/2", function (t2)
  t2:test("can subtract one matrix from another", function (t3)
    local mat3x3a = subject.random(-100, 100)
    local mat3x3b = subject.random(-100, 100)
    local mat3x3d = mat3x3a - mat3x3b

    for i = 1,9 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3a[i]) - assert(mat3x3b[i]))
    end
  end)
end)

case:describe("#*/2", function (t2)
  t2:test("can multiply matrices", function (t3)
    local mat3x3a = subject.random(-100, 100)
    local mat3x3b = subject.random(-100, 100)
    local mat3x3d = mat3x3a * mat3x3b

    local mat3x3e = subject.zero()
    -- so basically compare the implementations (in reality * calls multiply, so they should be
    -- the same result)
    subject.multiply(mat3x3e, mat3x3a, mat3x3b)

    for i = 1,9 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3e[i]))
    end
  end)
end)

case:describe("#//2", function (t2)
  t2:test("can divide matrices", function (t3)
    local mat3x3a = subject.random(1, 100)
    local mat3x3b = subject.random(1, 100)
    local mat3x3d = mat3x3a / mat3x3b

    local mat3x3e = subject.zero()
    -- so basically compare the implementations (in reality * calls multiply, so they should be
    -- the same result)
    subject.divide(mat3x3e, mat3x3a, mat3x3b)

    for i = 1,9 do
      t3:assert_eq(assert(mat3x3d[i]), assert(mat3x3e[i]))
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
