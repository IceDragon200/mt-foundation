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

case:execute()
case:display_stats()
case:maybe_error()
