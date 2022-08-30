local mod = foundation.com.ULID
local m = foundation.com
local Luna = assert(m.Luna)

local case = Luna:new("foundation.com.ULID")

case:describe("format_le_binary/4", function (t2)
  t2:test("can format a ulid given its components", function (t3)
    t3:assert_eq(
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
      mod.format_le_binary(0, 0, 0, 0)
    )
  end)
end)

case:describe("format_be_binary/4", function (t2)
  t2:test("can format a ulid given its components", function (t3)
    t3:assert_eq(
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
      mod.format_be_binary(0, 0, 0, 0)
    )
  end)
end)

case:describe("generate/0", function (t2)
  t2:test("can generate", function (t3)
    local ulid = mod.generate(1631810705)
    t3:assert_eq(26, string.len(ulid))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
