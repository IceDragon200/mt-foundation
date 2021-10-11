local Luna = assert(foundation.com.Luna)
local m = foundation.com

local case = Luna:new("foundation.com.path_*")

case:describe("path_components/1", function (t2)
  t2:test("correctly reports path components", function (t3)
    t3:assert_table_eq({}, m.path_components(""))
    t3:assert_table_eq({""}, m.path_components("/"))
    t3:assert_table_eq({"a", "b", "c"}, m.path_components("a/b/c"))
    t3:assert_table_eq({"", "a", "b", "c"}, m.path_components("/a/b/c"))
    t3:assert_table_eq({"", "a", "b", "c", ""}, m.path_components("/a/b/c/"))
  end)
end)

case:describe("path_dirname/1", function (t2)
  t2:test("will return '.' for empty path", function (t3)
    t3:assert_eq(".", m.path_dirname(""))
  end)

  t2:test("returns the dirname of the specified path", function (t3)
    t3:assert_eq("/a/b", m.path_dirname("/a/b/"))
    t3:assert_eq("/a", m.path_dirname("/a/b"))
    t3:assert_eq("/", m.path_dirname("/a"))
    t3:assert_eq("/path/to", m.path_dirname("/path/to/file"))
  end)

  t2:test("trims excess slashes at end", function (t3)
    t3:assert_eq("/a/b/c", m.path_dirname("/a/b/c///////"))
  end)
end)

case:describe("path_basename/1", function (t2)
  t2:test("will return empty string for empty path", function (t3)
    t3:assert_eq("", m.path_basename(""))
  end)

  t2:test("will return a single path component", function (t3)
    t3:assert_eq("a", m.path_basename("/a"))
    t3:assert_eq("file", m.path_basename("/path/to/file"))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
