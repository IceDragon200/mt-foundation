local BinaryBuffer = foundation.com.BinaryBuffer
if not BinaryBuffer then
  print "BinaryBuffer is not available skipping tests"
  return
end

local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.BinaryBuffer")

case:describe(":new", function (t2)
  t2:test("can create a new binary buffer", function (t3)
    local binbuf = BinaryBuffer:new("data:yep", "r")
    local blob = binbuf:read(4)

    t3:assert_eq("data", blob)

    blob = binbuf:read(1)
    t3:assert_eq(":", blob)

    blob = binbuf:read(3)
    t3:assert_eq("yep", blob)

    t3:refute(binbuf:read(1))
  end)
end)

case:describe("#blob", function (t2)
  t2:describe("can retrieve all written data as a blob", function (t3)
    local binbuf = BinaryBuffer:new("", "rw")

    t3:assert_eq("", binbuf:blob())
    binbuf:write("Hello")
    t3:assert_eq("Hello", binbuf:blob())
    binbuf:write(",")
    t3:assert_eq("Hello,", binbuf:blob())
    binbuf:write("World")
    t3:assert_eq("Hello,World", binbuf:blob())
  end)
end)

case:describe("#write", function (t2)
  t2:test("can write data to a buffer", function (t3)
    local binbuf = BinaryBuffer:new("", "w")

    t3:assert(binbuf:write("SAVE\x00\x01\x02\x03"))
    t3:assert(binbuf:write("DATA\x10\x20\x30\x40"))

    binbuf:close()
    binbuf:open("r")

    local blob = binbuf:read(4)
    t3:assert_eq("SAVE", blob)

    blob = binbuf:read(4)
    t3:assert_eq("\x00\x01\x02\x03", blob)

    blob = binbuf:read(4)
    t3:assert_eq("DATA", blob)

    blob = binbuf:read(4)
    t3:assert_eq("\x10\x20\x30\x40", blob)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
