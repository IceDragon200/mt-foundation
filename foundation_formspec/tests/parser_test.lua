local fspec = assert(foundation.com.formspec.api)
local subject = foundation.com.formspec.parser

if not subject then
  return
end
local case = foundation.com.Luna:new("foundation.com.formspec.parser")

case:describe(".parse/1", function (t2)
  t2:test("can parse a simple formspec", function (t3)
    local formspec =
      fspec.formspec_version(6)
      .. fspec.list("current_player", "main", 0, 0, 10, 4)

    local list = subject.parse(formspec)

    local item = list:get(1)
    local attrs
    t3:assert_eq(item.name, "formspec_version")
    attrs = item.attrs
    t3:assert_eq(attrs:size(), 1)
    t3:assert_eq(attrs:get(1):get(1), "6")

    item = list:get(2)
    t3:assert_eq(item.name, "list")
    attrs = item.attrs
    t3:assert_eq(attrs:size(), 5) -- fspec.list adds the offset as 0
    t3:assert_eq(attrs:get(1):get(1), "current_player")
    t3:assert_eq(attrs:get(2):get(1), "main")
    t3:assert_eq(attrs:get(3):get(1), "0")
    t3:assert_eq(attrs:get(3):get(2), "0")
    t3:assert_eq(attrs:get(4):get(1), "10")
    t3:assert_eq(attrs:get(4):get(2), "4")
    t3:assert_eq(attrs:get(5):get(1), "0")
  end)

  t2:test("will preserve empty tuples", function (t3)
    local formspec =
      "item[;;]"

    local list = subject.parse(formspec)

    t3:assert_eq(list:size(), 1)

    local item = list:get(1)
    local attrs
    t3:assert_eq(item.name, "item")
    attrs = item.attrs
    t3:assert_eq(attrs:size(), 3)
    t3:assert_eq(attrs:get(1):size(), 0)
    t3:assert_eq(attrs:get(2):size(), 0)
    t3:assert_eq(attrs:get(3):size(), 0)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
