local Luna = foundation.com.Luna
local m = foundation.com.Deque

local case = Luna:new("balm.s.Deque")

case:describe("#initialize/0", function (t2)
  t2:test("can initialize without arguments", function (t3)
    local s = m:new()

    t3:assert_eq(s:is_empty(), true)
    t3:assert_eq(s:size(), 0)

    s:push(1)

    t3:assert_eq(s:is_empty(), false)
    t3:assert_eq(s:size(), 1)

    s:unshift(2)

    t3:assert_eq(s:is_empty(), false)
    t3:assert_eq(s:size(), 2)

    t3:assert_eq(s:pop(), 1)
    t3:assert_eq(s:is_empty(), false)
    t3:assert_eq(s:size(), 1)

    t3:assert_eq(s:shift(), 2)
    t3:assert_eq(s:is_empty(), true)
    t3:assert_eq(s:size(), 0)
  end)
end)

case:describe("#initialize/1", function (t2)
  t2:test("can initialize with a POLT", function (t3)
    local s = m:new({ 1, 2, 3, 4, 5 })

    t3:assert_eq(s:is_empty(), false)
    t3:assert_eq(s:size(), 5)

    t3:assert_eq(s:pop(), 5)
    t3:assert_eq(s:shift(), 1)
    t3:assert_eq(s:shift(), 2)
    t3:assert_eq(s:shift(), 3)
    t3:assert_eq(s:pop(), 4)

    t3:assert_eq(s:is_empty(), true)
    t3:assert_eq(s:size(), 0)
  end)

  t2:test("can shift all values off queue", function (t3)
    local s = m:new({ 1, 2, 3, 4, 5 })

    t3:assert_eq(s:is_empty(), false)
    t3:assert_eq(s:size(), 5)

    t3:assert_eq(s:shift(), 1)
    t3:assert_eq(s:shift(), 2)
    t3:assert_eq(s:shift(), 3)
    t3:assert_eq(s:shift(), 4)
    t3:assert_eq(s:shift(), 5)

    t3:assert_eq(s:is_empty(), true)
    t3:assert_eq(s:size(), 0)
  end)
end)

case:describe("#clear/0", function (t2)
  t2:test("can clear a deque", function (t3)
    local s = m:new({ 1, 2, 3, 4, 5 })

    t3:assert_eq(s:is_empty(), false)
    t3:assert_eq(s:size(), 5)

    s:clear()

    t3:assert_eq(s:is_empty(), true)
    t3:assert_eq(s:size(), 0)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
