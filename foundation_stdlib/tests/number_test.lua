local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.number")

case:describe("integer_be_encode/2", function (t2)
  t2:test("can encode a single byte into a binary string", function (t3)
    t3:assert_eq("\x00", m.integer_be_encode(0, 1))
    t3:assert_eq("\x05", m.integer_be_encode(5, 1))
    t3:assert_eq("\x0F", m.integer_be_encode(15, 1))
    t3:assert_eq("\xFF", m.integer_be_encode(255, 1))
  end)

  t2:test("can encode a multi byte into a binary string", function (t3)
    -- 32 bit
    t3:assert_eq("\x00\x00\x00\x00", m.integer_be_encode(0, 4))
    t3:assert_eq("\xDE\xAD\xBE\xEF", m.integer_be_encode(0xDEADBEEF, 4))
    t3:assert_eq("\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFF, 4))
  end)

  t2:test("can encode a 48 bit integer into a binary string", function (t3)
    -- 48 bit
    t3:assert_eq("\x00\x00\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFF, 6))
    t3:assert_eq("\xFF\xFF\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFFFFFF, 6))
  end)

  t2:xtest("can encode a 56 bit integer into a binary string", function (t3)
    -- 56 bit
    t3:assert_eq("\x00\x00\x00\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFF, 7))
    t3:assert_eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFFFFFFFF, 7))
  end)

  t2:xtest("can encode a 64 bit integer into a binary string", function (t3)
    -- 64 bit
    t3:assert_eq("\x00\x00\x00\x00\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFF, 8))
    t3:assert_eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF", m.integer_be_encode(0xFFFFFFFFFFFFFFFF, 8))
  end)
end)

case:describe("integer_le_encode/2", function (t2)
  t2:test("can encode a single byte into a binary string", function (t3)
    t3:assert_eq("\x00", m.integer_le_encode(0, 1))
    t3:assert_eq("\x05", m.integer_le_encode(5, 1))
    t3:assert_eq("\x0F", m.integer_le_encode(15, 1))
    t3:assert_eq("\x10", m.integer_le_encode(16, 1))
    t3:assert_eq("\xFF", m.integer_le_encode(255, 1))
  end)

  t2:test("can encode a 32 bit integer into a binary string", function (t3)
    t3:assert_eq("\x00\x00\x00\x00", m.integer_le_encode(0, 4))
    t3:assert_eq("\xEF\xBE\xAD\xDE", m.integer_le_encode(0xDEADBEEF, 4))
    t3:assert_eq("\xFF\xFF\xFF\xFF", m.integer_le_encode(0xFFFFFFFF, 4))
  end)

  t2:test("can encode a 48 bit integer into a binary string", function (t3)
    -- 48 bits
    t3:assert_eq("\xFF\xFF\xFF\xFF\x00\x00", m.integer_le_encode(0xFFFFFFFF, 6))
    t3:assert_eq("\xFF\xFF\xFF\xFF\xFF\xFF", m.integer_le_encode(0xFFFFFFFFFFFF, 6))
  end)

  t2:xtest("can encode a 56 bit integer into a binary string", function (t3)
    -- 56 bits
    t3:assert_eq("\xFF\xFF\xFF\xFF\x00\x00\x00", m.integer_le_encode(0xFFFFFFFF, 7))
    t3:assert_eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF", m.integer_le_encode(0xFFFFFFFFFFFFFF, 7))
  end)

  t2:xtest("can encode a 64 bit integer into a binary string", function (t3)
    -- 64 bits
    t3:assert_eq("\xFF\xFF\xFF\xFF\x00\x00\x00\x00", m.integer_le_encode(0xFFFFFFFF, 8))
    t3:assert_eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF", m.integer_le_encode(0xFFFFFFFFFFFFFFFF, 8))
  end)
end)

case:describe("integer_hex_be_encode/2", function (t2)
  t2:test("can encode a single byte into a hex pair", function (t3)
    t3:assert_eq("00", m.integer_hex_be_encode(0, 1))
    t3:assert_eq("05", m.integer_hex_be_encode(5, 1))
    t3:assert_eq("0F", m.integer_hex_be_encode(15, 1))
    t3:assert_eq("10", m.integer_hex_be_encode(16, 1))
    t3:assert_eq("FF", m.integer_hex_be_encode(255, 1))
  end)

  t2:test("can encode a 32 bit integer as a hex string", function (t3)
    t3:assert_eq("00000000", m.integer_hex_be_encode(0, 4))
    t3:assert_eq("DEADBEEF", m.integer_hex_be_encode(0xDEADBEEF, 4))
    t3:assert_eq("FFFFFFFF", m.integer_hex_be_encode(0xFFFFFFFF, 4))
  end)

  t2:test("can encode a 48 bit integer as a hex string", function (t3)
    t3:assert_eq("0000FFFFFFFF", m.integer_hex_be_encode(0xFFFFFFFF, 6))
  end)

  t2:xtest("can encode a 56 bit integer as a hex string", function (t3)
    t3:assert_eq("000000FFFFFFFF", m.integer_hex_be_encode(0xFFFFFFFF, 7))
    t3:assert_eq("FFFFFFFFFFFFFF", m.integer_hex_be_encode(0xFFFFFFFFFFFFFF, 7))
  end)

  t2:xtest("can encode a 64 bit integer as a hex string", function (t3)
    t3:assert_eq("00000000FFFFFFFF", m.integer_hex_be_encode(0xFFFFFFFF, 8))
    t3:assert_eq("FFFFFFFFFFFFFFFF", m.integer_hex_be_encode(0xFFFFFFFFFFFFFFFF, 8))
  end)
end)

case:describe("integer_crawford_base32_be_encode/2", function (t2)
  t2:test("can encode an integer as base32", function (t3)
    t3:assert_eq("00", m.integer_crawford_base32_be_encode(0, 1))
    t3:assert_eq("0F", m.integer_crawford_base32_be_encode(15, 1))
    t3:assert_eq("0000", m.integer_crawford_base32_be_encode(0, 2))
    t3:assert_eq("00000", m.integer_crawford_base32_be_encode(0, 3))
    t3:assert_eq("3FAVFQF", m.integer_crawford_base32_be_encode(0xDEADBEEF, 4))
    t3:assert_eq("0XSNJG0", m.integer_crawford_base32_be_encode(1000000000, 4))
  end)
end)

case:describe("integer_crawford_base32_le_encode/2", function (t2)
  t2:test("can encode an integer as base32", function (t3)
    t3:assert_eq("00", m.integer_crawford_base32_le_encode(0, 1))
    t3:assert_eq("F0", m.integer_crawford_base32_le_encode(15, 1))
    t3:assert_eq("0000", m.integer_crawford_base32_le_encode(0, 2))
    t3:assert_eq("00000", m.integer_crawford_base32_le_encode(0, 3))
    t3:assert_eq("FQFVAF3", m.integer_crawford_base32_le_encode(0xDEADBEEF, 4))
    t3:assert_eq("0GJNSX0", m.integer_crawford_base32_le_encode(1000000000, 4))
  end)
end)

case:describe("number_lerp/3", function (t2)
  t2:test("will perform a linear interpolation between 2 points", function (t3)
    t3:assert_eq(5, m.number_lerp(0, 10, 0.5))
    t3:assert_eq(80, m.number_lerp(0, 100, 0.8))
    t3:assert_eq(25, m.number_lerp(20, 30, 0.5))
  end)
end)

case:describe("number_moveto/3", function (t2)
  t2:test("will apply given amount to first value to eventually match second value", function (t3)
    t3:assert_eq(5, m.number_moveto(0, 10, 5))
    t3:assert_eq(5, m.number_moveto(10, 0, 5))
    t3:assert_eq(6, m.number_moveto(2, 20, 4))
    t3:assert_eq(16, m.number_moveto(20, 2, 4))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
