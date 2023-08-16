local mod = foundation.com.utf8
local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.utf8")

case:describe("next_codepoint/1", function (t2)
  t2:test("reports the next codepoint in an empty string", function (t3)
    t3:assert_eq(nil, mod.next_codepoint(""))
  end)

  t2:test("reports the next codepoint in an ASCII string", function (t3)
    t3:assert_eq("H", mod.next_codepoint("Hello"))
  end)

  t2:test("reports the next codepoint in an UTF-8 string", function (t3)
    t3:assert_eq("さ", mod.next_codepoint("さよなら"))
  end)

  t2:test("correctly reports the next codepoint position in ASCII string", function (t3)
    local subject = "Hello"
    local codepoint, tail = mod.next_codepoint(subject)
    t3:assert_eq("H", codepoint)
    codepoint, tail = mod.next_codepoint(subject, tail + 1)
    t3:assert_eq("e", codepoint)
    codepoint, tail = mod.next_codepoint(subject, tail + 1)
    t3:assert_eq("l", codepoint)
    codepoint, tail = mod.next_codepoint(subject, tail + 1)
    t3:assert_eq("l", codepoint)
    codepoint, tail = mod.next_codepoint(subject, tail + 1)
    t3:assert_eq("o", codepoint)
    codepoint, tail = mod.next_codepoint(subject, tail + 1)
    t3:assert_eq(nil, codepoint)
    t3:assert_eq(nil, tail)
  end)
end)

case:describe("each_codepoint/2", function (t2)
  t2:test("can iterate over each character in a string", function (t3)
    local idx = 0
    local result = {}
    mod.each_codepoint("さよなら", function (char)
      idx = idx + 1
      result[idx] = char
    end)

    t3:assert_table_eq(result, {"さ", "よ", "な", "ら"})
  end)
end)

case:describe("codepoints/1", function (t2)
  t2:test("correctly returns all codepoints in an empty string", function (t3)
    t3:assert_table_eq({}, mod.codepoints(""))
  end)

  t2:test("correctly returns all codepoints in an ASCII string", function (t3)
    t3:assert_table_eq({"H", "e", "l", "l", "o"}, mod.codepoints("Hello"))
  end)

  t2:test("correctly returns all codepoints in a UTF-8 (Hiragana) string", function (t3)
    t3:assert_table_eq({"さ", "よ", "な", "ら"}, mod.codepoints("さよなら"))
  end)
end)

case:describe("size/1", function (t2)
  t2:test("correctly reports size of empty string", function (t3)
    t3:assert_eq(0, mod.size(""))
  end)

  t2:test("correctly reports size of ASCII string", function (t3)
    t3:assert_eq(5, mod.size("Hello"))
  end)

  t2:test("correctly reports size of UTF-8 (Hiragana) string", function (t3)
    t3:assert_eq(4, mod.size("さよなら"))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
