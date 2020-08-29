local Luna = assert(foundation.com.Luna)

do
  local case = Luna:new("foundation.com.ByteEncoder.LE")
  local mod = assert(foundation.com.ByteEncoder.LE)

  -- Signed Integers
  case:describe("e_i8", function (t2)
    t2:test("can encode an integer as a signed value", function (t3)
      t3:assert_eq("\x00", mod:e_i8(0))
      t3:assert_eq("\x01", mod:e_i8(1))
      t3:assert_eq("\x7F", mod:e_i8(127))
      t3:assert_eq("\x81", mod:e_i8(-127))
      t3:assert_eq("\x80", mod:e_i8(-128))
      t3:assert_eq("\xFF", mod:e_i8(-1))
    end)
  end)

  case:describe("e_i16", function (t2)
    t2:test("can encode an integer as a signed value", function (t3)
      t3:assert_eq("\x00\x00", mod:e_i16(0))
      t3:assert_eq("\x01\x00", mod:e_i16(1))
      t3:assert_eq("\xFF\x00", mod:e_i16(255))
      t3:assert_eq("\x00\x01", mod:e_i16(256))
      t3:assert_eq("\xFF\x7F", mod:e_i16(32767))
      t3:assert_eq("\x00\x80", mod:e_i16(-32768))
      t3:assert_eq("\xFF\xFF", mod:e_i16(-1))
    end)
  end)

  case:describe("e_i24", function (t2)
    t2:test("can encode an integer as a signed value", function (t3)
      t3:assert_eq("\x00\x00\x00", mod:e_i24(0))
      t3:assert_eq("\x01\x00\x00", mod:e_i24(1))
      t3:assert_eq("\xFF\x00\x00", mod:e_i24(255))
      t3:assert_eq("\xFF\xFF\x7F", mod:e_i24(8388607))
      t3:assert_eq("\x00\x00\x80", mod:e_i24(-8388608))
      t3:assert_eq("\xFF\xFF\xFF", mod:e_i24(-1))
    end)
  end)

  case:describe("e_i32", function (t2)
    t2:test("can encode an integer as a signed value", function (t3)
      t3:assert_eq("\xFF\xFF\xFF\xFF", mod:e_i32(-1))
    end)
  end)

  case:describe("e_i40", function (t2)
    t2:xtest("can encode an integer as a signed value", function (t3)
    end)
  end)

  case:describe("e_i48", function (t2)
    t2:xtest("can encode an integer as a signed value", function (t3)
    end)
  end)

  case:describe("e_i56", function (t2)
    t2:xtest("can encode an integer as a signed value", function (t3)
    end)
  end)

  case:describe("e_i64", function (t2)
    t2:xtest("can encode an integer as a signed value", function (t3)
    end)
  end)

  -- Unsigned Integers
  case:describe("e_u8", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00", mod:e_u8(0))
      t3:assert_eq("\x01", mod:e_u8(1))
      t3:assert_eq("\x7F", mod:e_u8(127))
      t3:assert_eq("\x80", mod:e_u8(128))
      t3:assert_eq("\xFF", mod:e_u8(255))
    end)
  end)

  case:describe("e_u16", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00\x00", mod:e_u16(0))
      t3:assert_eq("\x01\x00", mod:e_u16(1))
      t3:assert_eq("\x00\x01", mod:e_u16(256))
    end)
  end)

  case:describe("e_u24", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00\x00\x00", mod:e_u24(0))
      t3:assert_eq("\x01\x00\x00", mod:e_u24(1))
      t3:assert_eq("\x00\x01\x00", mod:e_u24(256))
      t3:assert_eq("\x00\x00\x01", mod:e_u24(65536))
    end)
  end)

  case:describe("e_u32", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00\x00\x00\x00", mod:e_u32(0))
      t3:assert_eq("\x01\x00\x00\x00", mod:e_u32(1))
      t3:assert_eq("\x00\x01\x00\x00", mod:e_u32(256))
      t3:assert_eq("\x00\x00\x01\x00", mod:e_u32(65536))
      t3:assert_eq("\x00\x00\x00\x01", mod:e_u32(16777216))
    end)
  end)

  case:describe("e_u40", function (t2)
    t2:xtest("can encode an integer as an unsigned value", function (t3)
    end)
  end)

  case:describe("e_u48", function (t2)
    t2:xtest("can encode an integer as an unsigned value", function (t3)
    end)
  end)

  case:describe("e_u56", function (t2)
    t2:xtest("can encode an integer as an unsigned value", function (t3)
    end)
  end)

  case:describe("e_u64", function (t2)
    t2:xtest("can encode an integer as an unsigned value", function (t3)
    end)
  end)

  case:execute()
  case:display_stats()
  case:maybe_error()
end

do
  local case = Luna:new("foundation.com.ByteEncoder.BE")
  local mod = assert(foundation.com.ByteEncoder.BE)

  -- Signed Integers
  case:describe("e_i8", function (t2)
    t2:test("can encode an integer as a signed value", function (t3)
      t3:assert_eq("\x00", mod:e_i8(0))
      t3:assert_eq("\x01", mod:e_i8(1))
      t3:assert_eq("\x7F", mod:e_i8(127))
      t3:assert_eq("\x81", mod:e_i8(-127))
      t3:assert_eq("\x80", mod:e_i8(-128))
      t3:assert_eq("\xFF", mod:e_i8(-1))
    end)
  end)

  case:describe("e_i16", function (t2)
    t2:test("can encode an integer as a signed value", function (t3)
      t3:assert_eq("\x00\x00", mod:e_i16(0))
      t3:assert_eq("\x00\x01", mod:e_i16(1))
      t3:assert_eq("\x00\xFF", mod:e_i16(255))
      t3:assert_eq("\x01\x00", mod:e_i16(256))
      t3:assert_eq("\x7F\xFF", mod:e_i16(32767))
      t3:assert_eq("\x80\x00", mod:e_i16(-32768))
      t3:assert_eq("\xFF\xFF", mod:e_i16(-1))
    end)
  end)

  case:describe("e_i24", function (t2)

  end)

  case:describe("e_i32", function (t2)
  end)

  case:describe("e_i40", function (t2)
  end)

  case:describe("e_i48", function (t2)
  end)

  case:describe("e_i56", function (t2)
  end)

  case:describe("e_i64", function (t2)
  end)

  -- Unsigned Integers
  case:describe("e_u8", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00", mod:e_u8(0))
      t3:assert_eq("\x01", mod:e_u8(1))
      t3:assert_eq("\x7F", mod:e_u8(127))
      t3:assert_eq("\x80", mod:e_u8(128))
      t3:assert_eq("\xFF", mod:e_u8(255))
    end)
  end)

  case:describe("e_u16", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00\x00", mod:e_u16(0))
      t3:assert_eq("\x00\x01", mod:e_u16(1))
      t3:assert_eq("\x01\x00", mod:e_u16(256))
    end)
  end)

  case:describe("e_u24", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00\x00\x00", mod:e_u24(0))
      t3:assert_eq("\x00\x00\x01", mod:e_u24(1))
      t3:assert_eq("\x00\x01\x00", mod:e_u24(256))
      t3:assert_eq("\x01\x00\x00", mod:e_u24(65536))
    end)
  end)

  case:describe("e_u32", function (t2)
    t2:test("can encode an integer as an unsigned value", function (t3)
      t3:assert_eq("\x00\x00\x00\x00", mod:e_u32(0))
      t3:assert_eq("\x00\x00\x00\x01", mod:e_u32(1))
      t3:assert_eq("\x00\x00\x01\x00", mod:e_u32(256))
      t3:assert_eq("\x00\x01\x00\x00", mod:e_u32(65536))
      t3:assert_eq("\x01\x00\x00\x00", mod:e_u32(16777216))
    end)
  end)

  case:describe("e_u40", function (t2)
  end)

  case:describe("e_u48", function (t2)
  end)

  case:describe("e_u56", function (t2)
  end)

  case:describe("e_u64", function (t2)
  end)

  case:execute()
  case:display_stats()
  case:maybe_error()
end
