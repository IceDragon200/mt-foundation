local InvRef = assert(foundation.com.headless.InvRef)

local case = foundation.com.Luna:new("foundation.com.headless.InvRef")

case:describe("#initialize/0", function (t2)
  t2:test("can initialize a new inventory reference", function (t3)
    local inv = InvRef:new()
  end)
end)

case:describe("#set_size/2", function (t2)
  t2:test("can set the size of an inventory list initially", function (t3)
    local inv = InvRef:new()

    inv:set_size("main", 10)

    t3:assert(inv:get_stack("main", 1))
    t3:assert(inv:get_stack("main", 9))
    t3:assert(inv:get_stack("main", 10))
  end)

  t2:test("can resize an existing inventory list", function (t3)
    local inv = InvRef:new()

    inv:set_size("main", 5)
    t3:assert(inv:get_stack("main", 1))
    t3:assert(inv:get_stack("main", 5))

    inv:set_size("main", 10)
    t3:assert(inv:get_stack("main", 1))
    t3:assert(inv:get_stack("main", 10))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
