local modules = {
  foundation.com.BinaryBuffer,
  foundation.com.LuaBinaryBuffer,
  foundation.com.FFIBinaryBuffer
}

local Luna = assert(foundation.com.Luna)

local function random_binary(len)
  local result = {}

  for i = 1,len do
    result[i] = string.char(math.random(256) - 1)
  end

  return table.concat(result)
end

for _, M in pairs(modules) do
  local case = Luna:new(M._name)

  case:describe("&new/1", function (t2)
    t2:test("can create a new binary buffer", function (t3)
      local binbuf = M:new("data:yep", "r")
      local blob
      local br
      blob, br = binbuf:read(4)
      t3:assert_eq(br, 4)

      t3:assert_eq(binbuf:size(), 8)
      t3:assert_eq(binbuf:allocated_size(), binbuf.BLOCK_SIZE)
      t3:assert_eq("data", blob)

      blob, br = binbuf:read(1)
      t3:assert_eq(br, 1)
      t3:assert_eq(":", blob)

      blob, br = binbuf:read(3)
      t3:assert_eq(br, 3)
      t3:assert_eq("yep", blob)

      blob, br = binbuf:read(1)
      t3:refute(blob)
    end)
  end)

  case:describe("#blob/0", function (t2)
    t2:test("can retrieve all preloaded data in a buffer", function (t3)
      local s = M:new("Hello, World", "rw")
      t3:assert_eq("Hello, World", s:blob())
    end)

    t2:test("can handle retrieving all data from large buffer", function (t3)
      local bs = M.instance_class.BLOCK_SIZE
      local s = M:new(string.rep("A", bs * 2), "rw")

      t3:assert_eq(bs * 2, s:size())
      t3:assert_eq(bs * 2, s:allocated_size())

      local b = s:blob()
      t3:assert_eq(bs * 2, #b)
      t3:assert_eq(string.rep("A", bs * 2), b)
    end)

    t2:test("can retrieve all written data as a blob", function (t3)
      local binbuf = M:new("", "rw")
      local bs = binbuf.BLOCK_SIZE

      t3:assert_eq(0, binbuf:size())
      t3:assert_eq(0, binbuf:allocated_size())
      t3:assert_eq("", binbuf:blob())

      binbuf:write("Hello")
      t3:assert_eq(5, binbuf:size())
      t3:assert_eq(binbuf.BLOCK_SIZE, binbuf:allocated_size())
      t3:assert_eq("Hello", binbuf:blob())

      binbuf:write(",")
      t3:assert_eq(6, binbuf:size())
      t3:assert_eq(binbuf.BLOCK_SIZE, binbuf:allocated_size())
      t3:assert_eq("Hello,", binbuf:blob())

      binbuf:write("World")
      t3:assert_eq(11, binbuf:size())
      t3:assert_eq(binbuf.BLOCK_SIZE, binbuf:allocated_size())
      t3:assert_eq("Hello,World", binbuf:blob())
    end)
  end)

  case:describe("#write/1", function (t2)
    t2:test("can write data to a buffer", function (t3)
      local binbuf = M:new("", "w")

      t3:assert(binbuf:write("SAVE\x00\x01\x02\x03"))
      t3:assert(binbuf:write("DATA\x10\x20\x30\x40"))

      binbuf:reopen("r")

      local blob = binbuf:read(4)
      t3:assert_eq("SAVE", blob)

      blob = binbuf:read(4)
      t3:assert_eq("\x00\x01\x02\x03", blob)

      blob = binbuf:read(4)
      t3:assert_eq("DATA", blob)

      blob = binbuf:read(4)
      t3:assert_eq("\x10\x20\x30\x40", blob)
    end)

    t2:test("FUZZ linear-write", function (t3)
      local binbuf = M:new("", "w")

      local result = {}
      for i = 1,100 do
        result[i] = random_binary(1 + math.random(4095))
        binbuf:write(result[i])
      end

      t3:assert_eq(table.concat(result), binbuf:blob())
    end)
  end)

  case:execute()
  case:display_stats()
  case:maybe_error()
end
