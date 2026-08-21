local Luna = assert(foundation.com.Luna)

local bit_modules = {}
for _, bit_module_name in ipairs({"bit", "native_bit", "local_bit"}) do
  local m = foundation.com[bit_module_name] or foundation_binary[bit_module_name]
  if m then
    bit_modules[bit_module_name] = m
  else
    core.log("warning", "foundation.com." .. bit_module_name .. " is not available for testing")
  end
end

for bit_module_name, m in pairs(bit_modules) do
  local case = Luna:new("foundation.com." .. bit_module_name)

  case:describe("tohex/1", function (t2)
    t2:test("can convert a 32bit integer to a hex string", function (t3)
      t3:assert_eq("deadbeef", m.tohex(0xDEADBEEF))
      t3:assert_eq("fedcba98", m.tohex(0xFEDCBA98))
      t3:assert_eq("ffffffff", m.tohex(-1))
      t3:assert_eq("FFFFFFFF", m.tohex(-1, -8))
    end)
  end)

  case:describe("band/2", function (t2)
    t2:test("can bitwise AND 2 numbers", function (t3)
      t3:assert_eq(0, m.band(0, 0))
      t3:assert_eq(0, m.band(0, 1))
      t3:assert_eq(1, m.band(1, 1))
      t3:assert_eq(0xFF, m.band(0xAAFF, 0xFF))
      t3:assert_eq(0xEF, m.band(0xAAEF, 0xFF))
      t3:assert_eq(0xAA00, m.band(0xAAEF, 0xFF00))
    end)
  end)

  case:describe("bor/2", function (t2)
    t2:test("can bitwise OR 2 numbers", function (t3)
      t3:assert_eq(0, m.bor(0, 0))
      t3:assert_eq(1, m.bor(0, 1))
      t3:assert_eq(1, m.bor(1, 1))
    end)
  end)

  case:describe("bxor/2", function (t2)
    t2:test("can bitwise XOR 2 numbers", function (t3)
      t3:assert_eq(0, m.bxor(0, 0))
      t3:assert_eq(1, m.bxor(0, 1))
      t3:assert_eq(0, m.bxor(1, 1))
    end)
  end)

  case:describe("bnot/1", function (t2)
    t2:test("can bitwise NOT a number", function (t3)
      t3:assert_eq(-1, m.bnot(0))
      t3:assert_eq(0, m.bnot(-1))
    end)
  end)

  case:describe("bswap/2", function (t2)
    t2:test("can swap the byte order of a number", function (t3)
      --t3:assert_eq(-0xDEADBEEF, m.bswap(0xEFBEADDE))
      --t3:assert_eq(0xEFBEADDE, m.bswap(0xDEADBEEF))
      t3:assert_eq(-0x21524111, m.bswap(0xEFBEADDE))
      t3:assert_eq(-0x10415222, m.bswap(0xDEADBEEF))
      t3:assert_eq(-0x10415222, m.bswap(-0x21524111))
    end)
  end)

  case:describe("rshift/2", function (t2)
    t2:test("can bitwise left shift a number", function (t3)
      t3:assert_eq(0, m.rshift(0x0, 1))
      t3:assert_eq(0, m.rshift(0x1, 1))
      t3:assert_eq(1, m.rshift(0x2, 1))
      t3:assert_eq(2, m.rshift(0x4, 1))
      t3:assert_eq(4, m.rshift(0x8, 1))
      t3:assert_eq(8, m.rshift(0x10, 1))
    end)
  end)

  case:describe("lshift/2", function (t2)
    t2:test("can bitwise right shift a number", function (t3)
      t3:assert_eq(0, m.lshift(0x0, 1))
      t3:assert_eq(2, m.lshift(0x1, 1))
      t3:assert_eq(4, m.lshift(0x2, 1))
      t3:assert_eq(8, m.lshift(0x4, 1))
      t3:assert_eq(16, m.lshift(0x8, 1))
      t3:assert_eq(32, m.lshift(0x10, 1))
    end)
  end)

  case:describe("rol/2", function (t2)
    t2:test("can bitwise rotate-left a number", function (t3)
      t3:assert_eq(0x2, m.rol(0x1, 1))
      t3:assert_eq(0x4, m.rol(0x2, 1))
      t3:assert_eq(0x1, m.rol(0x80000000, 1))
    end)
  end)

  case:describe("ror/2", function (t2)
    t2:test("can bitwise rotate-right a number", function (t3)
      t3:assert_eq(0x1, m.ror(0x2, 1))
      t3:assert_eq(0x2, m.ror(0x4, 1))
      t3:assert_eq(-0x80000000, m.ror(0x1, 1))
    end)
  end)

  case:execute()
  case:display_stats()
  case:maybe_error()
end

if bit_modules.native_bit and bit_modules.local_bit then
  local case = Luna:new("foundation.com.local_bit parity")
  local native = bit_modules.native_bit
  local fallback = bit_modules.local_bit
  local values = {
    0, 1, 2, 0x7F, 0x80, 0xFF, 0x12345678,
    0x7FFFFFFF, -0x80000000, -2, -1,
  }

  case:describe("plain Lua implementation", function (t2)
    t2:test("matches native operations over representative signed values", function (t3)
      for _, a in ipairs(values) do
        t3:assert_eq(native.bnot(a), fallback.bnot(a))
        t3:assert_eq(native.bswap(a), fallback.bswap(a))
        for _, b in ipairs(values) do
          t3:assert_eq(native.band(a, b), fallback.band(a, b))
          t3:assert_eq(native.bor(a, b), fallback.bor(a, b))
          t3:assert_eq(native.bxor(a, b), fallback.bxor(a, b))
        end
        for n = 0,31 do
          t3:assert_eq(native.lshift(a, n), fallback.lshift(a, n))
          t3:assert_eq(native.rshift(a, n), fallback.rshift(a, n))
          t3:assert_eq(native.arshift(a, n), fallback.arshift(a, n))
          t3:assert_eq(native.rol(a, n), fallback.rol(a, n))
          t3:assert_eq(native.ror(a, n), fallback.ror(a, n))
        end
      end
    end)

    t2:test("matches native variadic operations", function (t3)
      t3:assert_eq(native.band(-1, 0x12345678, 0x00FFFF00),
                   fallback.band(-1, 0x12345678, 0x00FFFF00))
      t3:assert_eq(native.bor(0x12000000, 0x00340000, 0x00005678),
                   fallback.bor(0x12000000, 0x00340000, 0x00005678))
      t3:assert_eq(native.bxor(-1, 0xAAAAAAAA, 0x55555555),
                   fallback.bxor(-1, 0xAAAAAAAA, 0x55555555))
    end)
  end)

  case:execute()
  case:display_stats()
  case:maybe_error()
end
