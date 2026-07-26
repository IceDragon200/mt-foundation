local fspec = assert(foundation.com.formspec.api)
local subject = foundation.com.formspec.api

local case = foundation.com.Luna:new("foundation.com.formspec.api")

case:describe("label/3", function (t2)
  t2:test("can prepapre a label given its x, y and label", function (t3)
    t3:assert_eq("label[0,1;Hello\\, World]", subject.label(0, 1, "Hello, World"))
  end)
end)

case:describe("label/5", function (t2)
  t2:test("can prepapre a label given its x, y, w, h and label", function (t3)
    t3:assert_eq("label[0,1;2,3;Hello\\, World]", subject.label(0, 1, 2, 3, "Hello, World"))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
