local ascii_pack = foundation.com.ascii_pack
local ascii_unpack = foundation.com.ascii_unpack
local ascii_file_pack = foundation.com.ascii_file_pack
local ascii_file_unpack = foundation.com.ascii_file_unpack

local function cycle_pack(term)
  local blob = ascii_pack(term)
  local result, rest = ascii_unpack(blob)
  assert(rest == "", "expected remaining string to be empty, got (" .. dump(rest) .. ")")
  return result, rest
end

local function cycle_file_pack(term)
  local dirname = core.get_worldpath() .. "/tmp"
  local filename = dirname .. "/test.apack"
  core.mkdir(dirname)

  local stream = io.open(filename, "w")
  ascii_file_pack(stream, term)
  io.close(stream)

  stream = io.open(filename, "r")
  local result = ascii_file_unpack(stream)
  io.close(stream)
  return result
end

local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.ASCIIPack")

case:describe("ascii_file_[un]pack/3", function (t2)
  t2:test("can handle nil", function (t3)
    t3:assert_eq(cycle_file_pack(nil), nil)
  end)

  t2:test("can handle booleans", function (t3)
    t3:assert_eq(cycle_file_pack(true), true)
    t3:assert_eq(cycle_file_pack(false), false)
  end)

  t2:test("can handle positive integers", function (t3)
    t3:assert_eq(cycle_file_pack(0), 0)
    t3:assert_eq(cycle_file_pack(127), 127)
    t3:assert_eq(cycle_file_pack(255), 255)

    t3:assert_eq(cycle_file_pack(256), 256)
    t3:assert_eq(cycle_file_pack(0x7FFF), 0x7FFF)
    t3:assert_eq(cycle_file_pack(0xFFFF), 0xFFFF)

    t3:assert_eq(cycle_file_pack(0x10000), 0x10000)
    t3:assert_eq(cycle_file_pack(0x7FFFFFFF), 0x7FFFFFFF)
    t3:assert_eq(cycle_file_pack(0xFFFFFFFF), 0xFFFFFFFF)

    -- 64-bit
    --t3:assert_eq(cycle_file_pack(0x100000000), 0x100000000)
    --t3:assert_eq(cycle_file_pack(0x7FFFFFFFFFFFFFFF), 0x7FFFFFFFFFFFFFFF)
    --t3:assert_eq(cycle_file_pack(0xFFFFFFFFFFFFFFFF), 0xFFFFFFFFFFFFFFFF)
  end)

  t2:test("can handle negative integers", function (t3)
    t3:assert_eq(cycle_file_pack(-0), -0)
    t3:assert_eq(cycle_file_pack(-127), -127)
    t3:assert_eq(cycle_file_pack(-255), -255)

    t3:assert_eq(cycle_file_pack(-256), -256)
    t3:assert_eq(cycle_file_pack(-0x7FFF), -0x7FFF)
    t3:assert_eq(cycle_file_pack(-0xFFFF), -0xFFFF)

    t3:assert_eq(cycle_file_pack(-0x10000), -0x10000)
    t3:assert_eq(cycle_file_pack(-0x7FFFFFFF), -0x7FFFFFFF)
    t3:assert_eq(cycle_file_pack(-0xFFFFFFFF), -0xFFFFFFFF)

    -- 64-bit
    --t3:assert_eq(cycle_file_pack(-0x100000000), -0x100000000)
    --t3:assert_eq(cycle_file_pack(-0x7FFFFFFFFFFFFFFF), -0x7FFFFFFFFFFFFFFF)
    --t3:assert_eq(cycle_file_pack(-0xFFFFFFFFFFFFFFFF), -0xFFFFFFFFFFFFFFFF)
  end)

  t2:test("can pack floats", function (t3)
    t3:assert_eq(cycle_file_pack(-0.2), -0.2)
    t3:assert_eq(cycle_file_pack(0.2), 0.2)
  end)

  t2:test("can handle an empty string", function (t3)
    t3:assert_eq(cycle_file_pack(""), "") -- should be able to handle an empty string
  end)

  t2:test("can handle simple strings", function (t3)
    t3:assert_eq(cycle_file_pack("Hello"), "Hello")
    t3:assert_eq(cycle_file_pack("####"), "####") -- # is the termination character
    t3:assert_eq(cycle_file_pack("0123456789"), "0123456789")
    t3:assert_eq(
      cycle_file_pack("THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"),
      "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"
    )
    t3:assert_eq(
      cycle_file_pack("the quick brown fox jumps over the lazy dog"),
      "the quick brown fox jumps over the lazy dog"
    )
  end)

  t2:test("can handle arrays", function (t3)
    t3:assert_deep_eq(cycle_file_pack({}), {}) -- can handle empty arrays
    t3:assert_deep_eq(cycle_file_pack({1, 2, 3}), {1, 2, 3}) -- can handle empty arrays
    t3:assert_deep_eq(
      cycle_file_pack({{}, {}, {}}),
      {{}, {}, {}}
    ) -- can handle multi-dimensional empty arrays
    t3:assert_deep_eq(
      cycle_file_pack({{1, 2, 3}, {"a", "b", "c"}, {true, false, nil}}),
      {{1, 2, 3}, {"a", "b", "c"}, {true, false, nil}}
    ) -- can handle multi-dimensional arrays
  end)

  t2:test("can handle maps", function (t3)
    t3:assert_deep_eq(cycle_file_pack({}), {}) -- can handle empty maps
    t3:assert_deep_eq(cycle_file_pack({ a = 1, b = 2, c = 3 }), { a = 1, b = 2, c = 3 })
    t3:assert_deep_eq(
      cycle_file_pack({ a = {}, b = {}, c = {} }),
      { a = {}, b = {}, c = {} }
    ) -- multi-dimensional
    t3:assert_deep_eq(
      cycle_file_pack(
        {
          a = { d = "g", e = "h", f = "i" },
          b = { j = 1, k = 2, l = 3},
          c = { m = true, n = false }
        }
      ),
      {
        a = { d = "g", e = "h", f = "i" },
        b = { j = 1, k = 2, l = 3},
        c = { m = true, n = false }
      }
    ) -- multi-dimensional
  end)
end)

case:describe("ascii_[un]pack/3", function (t2)
  t2:test("can handle nil", function (t3)
    t3:assert_eq(cycle_pack(nil), nil)
  end)

  t2:test("can handle booleans", function (t3)
    t3:assert_eq(cycle_pack(true), true)
    t3:assert_eq(cycle_pack(false), false)
  end)

  t2:test("can handle positive integers", function (t3)
    t3:assert_eq(cycle_pack(0), 0)
    t3:assert_eq(cycle_pack(127), 127)
    t3:assert_eq(cycle_pack(255), 255)

    t3:assert_eq(cycle_pack(256), 256)
    t3:assert_eq(cycle_pack(0x7FFF), 0x7FFF)
    t3:assert_eq(cycle_pack(0xFFFF), 0xFFFF)

    t3:assert_eq(cycle_pack(0x10000), 0x10000)
    t3:assert_eq(cycle_pack(0x7FFFFFFF), 0x7FFFFFFF)
    t3:assert_eq(cycle_pack(0xFFFFFFFF), 0xFFFFFFFF)

    -- 64-bit
    --t3:assert_eq(cycle_pack(0x100000000), 0x100000000)
    --t3:assert_eq(cycle_pack(0x7FFFFFFFFFFFFFFF), 0x7FFFFFFFFFFFFFFF)
    --t3:assert_eq(cycle_pack(0xFFFFFFFFFFFFFFFF), 0xFFFFFFFFFFFFFFFF)
  end)

  t2:test("can handle negative integers", function (t3)
    t3:assert_eq(cycle_pack(-0), -0)
    t3:assert_eq(cycle_pack(-127), -127)
    t3:assert_eq(cycle_pack(-255), -255)

    t3:assert_eq(cycle_pack(-256), -256)
    t3:assert_eq(cycle_pack(-0x7FFF), -0x7FFF)
    t3:assert_eq(cycle_pack(-0xFFFF), -0xFFFF)

    t3:assert_eq(cycle_pack(-0x10000), -0x10000)
    t3:assert_eq(cycle_pack(-0x7FFFFFFF), -0x7FFFFFFF)
    t3:assert_eq(cycle_pack(-0xFFFFFFFF), -0xFFFFFFFF)

    -- 64-bit
    --t3:assert_eq(cycle_pack(-0x100000000), -0x100000000)
    --t3:assert_eq(cycle_pack(-0x7FFFFFFFFFFFFFFF), -0x7FFFFFFFFFFFFFFF)
    --t3:assert_eq(cycle_pack(-0xFFFFFFFFFFFFFFFF), -0xFFFFFFFFFFFFFFFF)
  end)

  t2:test("can handl floats", function (t3)
    t3:assert_eq(cycle_pack(-0.2), -0.2)
    t3:assert_eq(cycle_pack(0.2), 0.2)
  end)

  t2:test("can handle a simple string", function (t3)
    t3:assert_eq(cycle_pack(""), "") -- should be able to handle an empty string
    t3:assert_eq(cycle_pack("Hello"), "Hello")
    t3:assert_eq(cycle_pack("####"), "####") -- # is the termination character
    t3:assert_eq(cycle_pack("0123456789"), "0123456789")
    t3:assert_eq(
      cycle_pack("THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"),
      "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"
    )
    t3:assert_eq(
      cycle_pack("the quick brown fox jumps over the lazy dog"),
      "the quick brown fox jumps over the lazy dog"
    )
  end)

  t2:test("can handle arrays", function (t3)
    t3:assert_deep_eq(cycle_pack({}), {}) -- can handle empty arrays
    t3:assert_deep_eq(cycle_pack({1, 2, 3}), {1, 2, 3}) -- can handle empty arrays
    t3:assert_deep_eq(
      cycle_pack({{}, {}, {}}),
      {{}, {}, {}}
    ) -- can handle multi-dimensional empty arrays
    t3:assert_deep_eq(
      cycle_pack({{1, 2, 3}, {"a", "b", "c"}, {true, false, nil}}),
      {{1, 2, 3}, {"a", "b", "c"}, {true, false, nil}}
    ) -- can handle multi-dimensional arrays
  end)

  t2:test("can handle maps", function (t3)
    t3:assert_deep_eq(cycle_pack({}), {}) -- can handle empty maps
    t3:assert_deep_eq(cycle_pack({ a = 1, b = 2, c = 3 }), { a = 1, b = 2, c = 3 })
    t3:assert_deep_eq(
      cycle_pack({ a = {}, b = {}, c = {} }),
      { a = {}, b = {}, c = {} }
    ) -- multi-dimensional
    t3:assert_deep_eq(
      cycle_pack({
        a = { d = "g", e = "h", f = "i" },
        b = { j = 1, k = 2, l = 3},
        c = { m = true, n = false }
      }),
      {
        a = { d = "g", e = "h", f = "i" },
        b = { j = 1, k = 2, l = 3 },
        c = { m = true, n = false }
      }
    ) -- multi-dimensional
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
