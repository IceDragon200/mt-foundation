local bit = assert(foundation.com.bit)
local ByteD = foundation.com.ByteDecoder
local ByteE = foundation.com.ByteEncoder

local case = foundation.com.Luna:new("foundation.com.Byte_(De|En)coder")

for _, E in ipairs({ "BE", "LE" }) do
  local MD = assert(ByteD[E])
  local ME = assert(ByteE[E])

  case:describe(E, function (e_case)
    for _, bits in ipairs({ 8, 16, 24, 32, 40, 48 }) do
      e_case:describe("integer " .. bits .. "-bits", function (t2)
        t2:test("can encode/decode signed numbers", function (t3)
          local dfn = assert(MD["d_i" .. bits])
          local efn = assert(ME["e_i" .. bits])

          for _, i in ipairs({ -bit.BIT_TABLE[bits - 1], 0, bit.BIT_TABLE[bits - 1] - 1 }) do
            t3:assert_eq(dfn(MD, efn(ME, i)), i)
          end
        end)

        t2:test("can encode/decode unsigned numbers", function (t3)
          local dfn = assert(MD["d_u" .. bits])
          local efn = assert(ME["e_u" .. bits])

          for _, i in ipairs({ 0, bit.BIT_TABLE[bits - 1], bit.BIT_TABLE[bits] - 1 }) do
            t3:assert_eq(dfn(MD, efn(ME, i)), i)
          end
        end)
      end)
    end

    for _, bits in ipairs({ 32, 64 }) do
      e_case:describe("float " .. bits .. "-bits", function (t2)
        t2:test("can encode/decode whole numbers", function (t3)
          local dfn = assert(MD["d_f" .. bits])
          local efn = assert(ME["e_f" .. bits])

          for _ = 1,1024 do
            local i = math.random(-0x00FFFFFF, 0x00FFFFFF)
            t3:assert_feq(dfn(MD, efn(ME, i)), i)
          end
        end)

        t2:test("can encode/decode decimal numbers", function (t3)
          local dfn = assert(MD["d_f" .. bits])
          local efn = assert(ME["e_f" .. bits])

          for _ = 1,1024 do
            local i = math.random(-10000000, 10000000) / 10000000
            local n = dfn(MD, efn(ME, i))
            t3:assert_feq(n, i)
          end
        end)
      end)
    end
  end)
end

case:execute()
case:display_stats()
case:maybe_error()
