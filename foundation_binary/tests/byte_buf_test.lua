local ByteBuf = foundation.com.ByteBuf
if not ByteBuf then
  print "ByteBuf is not available skipping tests"
  return
end

local StringBuffer = assert(foundation.com.StringBuffer)
local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.ByteBuf")

local subject = assert(ByteBuf.little, "expected little endian instance of byte buffer")

case:describe("sanity check", function (t2)
  t2:test("little is instance of ByteBuf.Base", function (t3)
    t3:assert(subject:is_instance_of(ByteBuf.Base))
  end)

  t2:test("little is instance of ByteBuf.Little", function (t3)
    t3:assert(subject:is_instance_of(ByteBuf.Little))
  end)
end)

case:describe("#write/1", function (t2)
  t2:test("can write a string to given stream or buffer", function (t3)
    local buf = StringBuffer:new("", "w")

    subject:write(buf, "Hello, World")

    buf:reopen("r")

    t3:assert_eq("Hello, World", buf:blob())
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
