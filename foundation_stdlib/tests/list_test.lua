local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.list_*")

case:describe("list_crawford_base32_le_rolling_encode_table/*", function (t2)
  t2:test("can encode a list of integers as base32", function (t3)
    ---t3:assert_eq(m.list_crawford_base32_le_rolling_encode_table())
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
