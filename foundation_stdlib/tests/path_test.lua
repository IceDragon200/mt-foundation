local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.path_*")

case:describe("path_dirname/1", function (t2)
  t2:test("returns the dirname of the specified path", function (t3)
    t3:assert_eq("/a/b", m.path_dirname("/a/b/"))
    t3:assert_eq("/a", m.path_dirname("/a/b"))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()

error("fail")
