local mod = foundation_stdlib
local m = foundation.com
local Luna = assert(m.Luna)

local case = Luna:new("foundation_stdlib")

case:describe("random_string/1", function (t2)
  t2:test("can generate random strings of specified length", function (t3)
    local s = m.random_string(16)

    t3:assert_eq(#s, 16)
  end)
end)

case:describe("format_pretty_time/1", function (t2)
  t2:test("can format a value greater than an hour", function (t3)
    local result = m.format_pretty_time(3 * 60 * 60 + 60 * 5 + 32)
    t3:assert_eq(result, "03:05:32")

    result = m.format_pretty_time(12 * 60 * 60 + 60 * 11 + 9)
    t3:assert_eq(result, "12:11:09")
  end)

  t2:test("can format a value greater than a minute", function (t3)
    local result = m.format_pretty_time(60 * 5 + 7)
    t3:assert_eq(result, "05:07")

    result = m.format_pretty_time(60 * 5 + 32)
    t3:assert_eq(result, "05:32")

    result = m.format_pretty_time(60 * 32 + 32)
    t3:assert_eq(result, "32:32")
  end)

  t2:test("can format a value less than a minute", function (t3)
    local result = m.format_pretty_time(32)
    t3:assert_eq(result, "32")

    result = m.format_pretty_time(5)
    t3:assert_eq(result, "05")
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()

mod:require("/tests/color_test.lua")
mod:require("/tests/direction_test.lua")
mod:require("/tests/iodata_test.lua")
mod:require("/tests/list_test.lua")
mod:require("/tests/number_test.lua")
mod:require("/tests/path_test.lua")
mod:require("/tests/rect_test.lua")
mod:require("/tests/string_test.lua")
mod:require("/tests/table_test.lua")
mod:require("/tests/value_test.lua")
mod:require("/tests/waves_test.lua")

--
mod:require("/tests/metaref_test.lua")
mod:require("/tests/item_stack_test.lua")
mod:require("/tests/inventory_list_test.lua")
