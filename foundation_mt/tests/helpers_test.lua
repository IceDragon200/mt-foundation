local itemstack_deep_equals = assert(foundation.com.itemstack_deep_equals)

local Luna = assert(foundation.com.Luna)
local subject = assert(foundation.com.parse_chat_command_params)

local case = Luna:new("foundation.com.InventoryList")

case:describe("parse_chat_command_params/1", function (t2)
  t2:test("can parse an empty params", function (t3)
    local result, rest = subject("")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 0)
  end)

  t2:test("can parse a chat command params", function (t3)
    local result, rest = subject("@john 1,2,3 true false \"Hello, World\"")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 5)
    t3:assert_matches(result, {
      { size = 1, data = { "@john" } },
      { size = 3, data = { "1", "2", "3" } },
      { size = 1, data = { "true" } },
      { size = 1, data = { "false" } },
      { size = 1, data = { "Hello, World" } },
    })
  end)

  t2:test("can safely handle incomplete dquote string", function (t3)
    local result, rest = subject("\"abc ")
    t3:assert_eq(rest, "\"abc ")
    t3:assert_eq(#result, 0)
  end)

  t2:test("can safely handle incomplete squote string", function (t3)
    local result, rest = subject("'abc ")
    t3:assert_eq(rest, "'abc ")
    t3:assert_eq(#result, 0)
  end)

  t2:test("can handle a tuple", function (t3)
    local result, rest = subject("a,b,c")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 1)
    t3:assert_matches(result, {
      -- technically speaking, if you tried to do next on this, it would be nil too
      { size = 3, data = { "a", "b", "c" } },
    })
  end)

  t2:test("can handle multiple tuples", function (t3)
    local result, rest = subject("a,b,c 1,2,3,4 x,y,z,w,2")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 3)
    t3:assert_matches(result, {
      -- technically speaking, if you tried to do next on this, it would be nil too
      { size = 3, data = { "a", "b", "c" } },
      { size = 4, data = { "1", "2", "3", "4" } },
      { size = 5, data = { "x", "y", "z", "w", "2" } },
    })
  end)

  t2:test("can handle nil tuple", function (t3)
    local result, rest = subject(",")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 1)
    t3:assert_matches(result, {
      -- technically speaking, if you tried to do next on this, it would be nil too
      { size = 2, data = { nil, nil } },
    })
  end)

  t2:test("can handle mixed nil tuple (trailing)", function (t3)
    local result, rest = subject(",1")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 1)
    t3:assert_matches(result, {
      -- technically speaking, if you tried to do next on this, it would be nil too
      { size = 2, data = { nil, "1" } },
    })
  end)

  t2:test("can handle mixed nil tuple (leading)", function (t3)
    local result, rest = subject("1,")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 1)
    t3:assert_matches(result, {
      -- technically speaking, if you tried to do next on this, it would be nil too
      { size = 2, data = { "1", nil } },
    })
  end)

  t2:test("can handle larger nil tuple", function (t3)
    local result, rest = subject(",,,")
    t3:assert_eq(rest, "")
    t3:assert_eq(#result, 1)
    t3:assert_matches(result, {
      -- technically speaking, if you tried to do next on this, it would be nil too
      { size = 4, data = { nil, nil, nil, nil } },
    })
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()

error("would this pass eh?")
