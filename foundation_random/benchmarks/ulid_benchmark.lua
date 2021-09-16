local mod = foundation.com.ULID
local m = foundation.com
local Luna = assert(m.Luna)

local case = Luna:new("foundation.com.ULID benchmark")

case:describe("generate/0", function (t2)
  t2:test("1'000'000 generations", function (t3)
    for _ = 1,1000000 do
      mod.generate(1631810705)
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
