local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.random_*")

case:describe("random_addr16/4", function (t2)
  t2:test("can generate a nibble address", function (t3)
    m.random_addr16(4, 4, ".")
    m.random_addr16(8, 4, ".")
    m.random_addr16(16, 8, ":")
    m.random_addr16(32, 16, ":")
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
