local Luna = assert(foundation.com.Luna)
local StringBuffer = assert(foundation.com.StringBuffer)
local bit = assert(foundation.com.bit)
local Limits = assert(foundation.com.LIMITS)
local ByteBuf = assert(foundation.com.ByteBuf)

local case = Luna:new("foundation.com.ByteBuf")
for _, E in ipairs({ "BE", "LE" }) do
  local M = ByteBuf[E]

  case:describe(E, function (e_case)
    e_case:describe("#write/2", function (t2)
      t2:test("can write a byte", function (t3)
        local stream = StringBuffer:new("", "w")
        local bw, err
        bw, err = M:write(stream, 0)
        t3:assert(bw > 0)
        t3:refute(err)
        bw, err = M:write(stream, 128)
        t3:assert(bw > 0)
        t3:refute(err)
        bw, err = M:write(stream, 255)
        t3:assert(bw > 0)
        t3:refute(err)
        stream:reopen("r")
        t3:assert_eq(M:read(stream, 1), "\0")
        t3:assert_eq(M:read(stream, 1), "\128")
        t3:assert_eq(M:read(stream, 1), "\255")
      end)

      t2:test("will refuse to write a negative byte", function (t3)
        local stream = StringBuffer:new("", "w")
        local bw, err
        bw, err = M:write(stream, -1)
        t3:assert(bw == 0)
        t3:assert(err)
      end)
    end)

    for _, bits in ipairs({ 8, 16, 24, 32, 40, 48 }) do
      e_case:describe("#w_u"..bits.."/2", function (t2)
        t2:test("can write an unsigned number", function (t3)
          local wfn = "w_u"..bits
          local rfn = "r_u"..bits
          local stream = StringBuffer:new("", "w")
          local bw, err
          bw, err = M[wfn](M, stream, 0)
          t3:assert(bw > 0)
          t3:refute(err)

          -- N-1
          bw, err = M[wfn](M, stream, bit.BIT_TABLE[bits - 1])
          t3:assert(bw > 0)
          t3:refute(err)

          -- Maximum
          bw, err = M[wfn](M, stream, bit.BIT_TABLE[bits] - 1)
          t3:assert(bw > 0)
          t3:refute(err)

          stream:reopen("r")

          t3:assert_eq(M[rfn](M, stream), 0)
          t3:assert_eq(M[rfn](M, stream), bit.BIT_TABLE[bits - 1])
          t3:assert_eq(M[rfn](M, stream), bit.BIT_TABLE[bits] - 1)
        end)

        t2:test("can write an unsigned number stream", function (t3)
          local bytes = 1024
          local data = {}

          local wfn = "w_u"..bits
          local rfn = "r_u"..bits
          local stream = StringBuffer:new("", "w")
          local bw, err
          local b
          for i = 1,bytes do
            b = math.random(0, bit.BIT_TABLE[bits] - 1)
            data[i] = b
            bw, err = M[wfn](M, stream, b)
            t3:assert(bw > 0)
            t3:refute(err)
          end

          stream:reopen("r")

          local br
          local d
          for i = 1,bytes do
            d, br = M[rfn](M, stream)
            t3:assert_eq(br, math.floor(bits / 8))
            t3:assert_eq(d, data[i])
          end
        end)
      end)

      e_case:describe("#w_i"..bits.."/2", function (t2)
        t2:test("can write an signed number", function (t3)
          -- local w = math.floor(bits / 8)
          local wfn = "w_i"..bits
          local rfn = "r_i"..bits
          local stream = StringBuffer:new("", "w")
          local bw, err
          bw, err = M[wfn](M, stream, 0)
          t3:assert(bw > 0)
          t3:refute(err)

          -- Max
          bw, err = M[wfn](M, stream, bit.BIT_TABLE[bits - 1] - 1)
          t3:assert(bw > 0)
          t3:refute(err)

          -- Min
          bw, err = M[wfn](M, stream, -bit.BIT_TABLE[bits - 1])
          t3:assert(bw > 0)
          t3:refute(err)

          stream:reopen("r")

          t3:assert_eq(M[rfn](M, stream), 0)
          t3:assert_eq(M[rfn](M, stream), bit.BIT_TABLE[bits - 1] - 1)
          t3:assert_eq(M[rfn](M, stream), -bit.BIT_TABLE[bits - 1])
        end)

        t2:test("can write an signed number stream", function (t3)
          local bytes = 1024
          local data = {}

          local wfn = "w_i"..bits
          local rfn = "r_i"..bits
          local stream = StringBuffer:new("", "w")
          local bw, err
          local b
          for i = 1,bytes do
            b = math.random(-bit.BIT_TABLE[bits - 1], bit.BIT_TABLE[bits - 1] - 1)
            data[i] = b
            bw, err = M[wfn](M, stream, b)
            t3:assert(bw > 0)
            t3:refute(err)
          end

          stream:reopen("r")

          local br
          local d
          for i = 1,bytes do
            d, br = M[rfn](M, stream)
            t3:assert_eq(br, math.floor(bits / 8))
            t3:assert_eq(d, data[i])
          end
        end)
      end)
    end

    for _, bits in ipairs({ 32, 64 }) do
      e_case:describe("#w_f"..bits.."/2", function (t2)
        t2:test("can write a floating-point number", function (t3)
          -- local w = math.floor(bits / 8)
          local wfn = assert(M["w_f"..bits])
          local rfn = assert(M["r_f"..bits])
          local stream = StringBuffer:new("", "w")
          local bw, err
          bw, err = wfn(M, stream, 0)
          t3:assert(bw > 0)
          t3:refute(err)

          local mx = Limits.IMAX[17]
          local mn = Limits.IMIN[17]
          -- Max
          -- bw, err = wfn(M, stream, Limits.FMAX[bits])
          bw, err = wfn(M, stream, mx)
          t3:assert(bw > 0)
          t3:refute(err)

          -- Min
          -- bw, err = wfn(M, stream, Limits.FMIN[bits])
          bw, err = wfn(M, stream, mn)
          t3:assert(bw > 0)
          t3:refute(err)

          stream:reopen("r")

          t3:assert_feq(rfn(M, stream), 0)
          t3:assert_feq(rfn(M, stream), mx)
          t3:assert_feq(rfn(M, stream), mn)
        end)

        t2:test("can write floats to a number stream", function (t3)
          local bytes = 1024
          local data = {}

          local wfn = assert(M["w_f"..bits])
          local rfn = assert(M["r_f"..bits])
          local stream = StringBuffer:new("", "w")
          local bw, err
          local b
          for i = 1,bytes do
            b = math.floor(math.random(Limits.IMIN[17], Limits.IMAX[17]) + math.random() * 10000) / 10000
            data[i] = b
            bw, err = wfn(M, stream, b)
            t3:assert(bw > 0)
            t3:refute(err)
          end

          stream:reopen("r")

          local br
          local d
          for i = 1,bytes do
            d, br = rfn(M, stream)
            t3:assert_eq(br, math.floor(bits / 8))
            t3:assert_feq(d, data[i])
          end
        end)
      end)
    end

    e_case:describe("#w_u8bool", function (t2)
      t2:test("can encode a boolean", function (t3)
        local stream = StringBuffer:new("", "w")
        local v
        local bw
        local br
        bw = M:w_u8bool(stream, true)
        t3:assert_eq(bw, 1)
        bw = M:w_u8bool(stream, false)
        t3:assert_eq(bw, 1)
        stream:reopen("r")
        v, br = M:r_u8bool(stream)
        t3:assert_eq(br, 1)
        t3:assert_eq(v, true)
        v, br = M:r_u8bool(stream)
        t3:assert_eq(br, 1)
        t3:assert_eq(v, false)
      end)
    end)

    for _, bits in pairs({ 8, 16, 24, 32 }) do
      e_case:describe("#w_u"..bits.."string/2", function (t2)
        local wfn = assert(M["w_u"..bits.."string"])
        local rfn = assert(M["r_u"..bits.."string"])

        t2:test("can write a string", function (t3)
          local stream = StringBuffer:new("", "w")

          local str = "\0Hello\0World"

          local len = math.ceil(bits / 8) + #str

          local bw, err = wfn(M, stream, str)
          t3:assert_eq(bw, len)
          t3:refute(err)

          stream:reopen("r")

          local nstr, br = rfn(M, stream)
          t3:assert_eq(br, len)
          t3:assert_eq(str, nstr)
        end)
      end)
    end
  end)
end

case:execute()
case:display_stats()
case:maybe_error()
