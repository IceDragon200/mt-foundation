local m = assert(foundation.com.RingBuffer)
local Luna = assert(foundation.com.Luna)

local case = Luna:new("foundation.com.RingBuffer")

case:describe("&new/0", function (t2)
  t2:test("can create a new ring buffer with default max size", function (t3)
    local rb = m:new()
    t3:assert_eq(rb:max_size(), 0xFFFFFFFF)
    t3:assert(rb:is_empty())
  end)
end)

case:describe("&new/1", function (t2)
  t2:test("can create a new ring buffer with specified max size", function (t3)
    local rb = m:new(5)
    t3:assert_eq(rb:max_size(), 5)
    t3:assert(rb:is_empty())
  end)
end)

case:describe("&safe_push/1", function (t2)
  t2:test("can safely push values unto a ring buffer (under max_size)", function (t3)
    local rb = m:new()

    for i = 1,10 do
      t3:assert(rb:safe_push(i))
    end

    t3:assert_eq(rb:size(), 10)

    for i = 1,10 do
      t3:assert_eq(rb:pop(), i)
    end
  end)

  t2:test("can safely push values unto a ring buffer (wrap around)", function (t3)
    local rb = m:new(5)

    for i = 1,10 do
      t3:assert(rb:safe_push(i))
      t3:assert_eq(rb:pop(), i)
    end
  end)

  t2:test("will not push new values if the buffer is full", function (t3)
    local rb = m:new(5)
    t3:assert(rb:is_empty())
    for i = 1,5 do
      t3:assert(rb:safe_push(i))
    end
    t3:assert_eq(rb:size(), 5)
    t3:assert(rb:is_full())

    t3:refute(rb:safe_push(6))
  end)
end)

case:describe("&pop/0", function (t2)
  t2:test("cannot over pop a buffer", function (t3)
    local rb = m:new()
    t3:assert_eq(rb:size(), 0)
    t3:refute(rb:pop())
    t3:assert_eq(rb:size(), 0)
  end)
end)

case:describe("&peek/0", function (t2)
  t2:test("can peek at next value in buffer", function (t3)
    local rb = m:new()
    rb:safe_push(1)
    rb:safe_push(2)

    t3:assert_eq(rb:size(), 2)

    t3:assert_eq(rb:peek(), 1)
    t3:assert_eq(rb:peek(), 1)

    rb:pop()

    t3:assert_eq(rb:peek(), 2)
    t3:assert_eq(rb:peek(), 2)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
