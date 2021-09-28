local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.iodata_*")

case:describe("iodata_to_string/1", function (t2)
  t2:test("can return a string given a string", function (t3)
    t3:assert_eq("abc", m.iodata_to_string("abc"))
  end)

  t2:test("can return a string given a table of strings", function (t3)
    t3:assert_eq("abc def", m.iodata_to_string({"abc", " ", "def"}))
  end)

  t2:test("can return a string given a table of mixed tables and strings", function (t3)
    t3:assert_eq("node key=value key2=\"Digital Age\"", m.iodata_to_string({
      "node", " ", {"key", "=", "value"},
              " ", {"key2", "=", {"\"", "Digital Age", "\""}}
    }))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
