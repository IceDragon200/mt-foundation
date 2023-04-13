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

case:execute()
case:display_stats()
case:maybe_error()
