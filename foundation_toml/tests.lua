local case = foundation.com.Luna:new("foundation_toml")

case:describe("TOML", function (t2)
  t2:describe("encode/1", function (t3)
    t3:test("encodes a simple object", function (t4)
      local result =
        m.TOML.encode({
          a = "hello",
          b = "world",
          c = true,
          d = false,
          e = 12,
        })

      t4:assert_eq([[
a = "hello"
b = "world"
c = true
d = false
e = 12
]], result)
    end)

    t3:test("encodes a nested object", function (t4)
      local result =
        m.TOML.encode({
          root = {
            a = "hello",
            b = "world",
            c = true,
            d = false,
            e = 12,
          },
        })

      t4:assert_eq([[
[root]
a = "hello"
b = "world"
c = true
d = false
e = 12
]], result)
    end)

    t3:test("encodes a object with a unsafe key", function (t4)
      local result =
        m.TOML.encode({
          ["root:other_thing"] = {
            a = "hello",
            b = "world",
            c = true,
            d = false,
            e = 12,
          },
        })

      t4:assert_eq([[
["root:other_thing"]
a = "hello"
b = "world"
c = true
d = false
e = 12
]], result)
    end)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
