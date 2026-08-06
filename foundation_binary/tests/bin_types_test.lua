local Luna = assert(foundation.com.Luna)
local StringBuffer = assert(foundation.com.StringBuffer)
local MarshallValue = assert(foundation.com.binary_types.MarshallValue.V2)
local ByteBuf = assert(foundation.com.ByteBuf)
local M = assert(foundation.com.BinSchema)
local Limits = assert(foundation.com.LIMITS)

local case = Luna:new("foundation.com.binary_types")

local mv = MarshallValue:new()
local BB = ByteBuf.LE

case:describe("&new/1", function (t2)
  t2:test("can initialize a new BinSchema", function (t3)
    local s = M:new("TestSchema", {
      8,

      { "u8", "u8" },
      { "u16", "u16" },
      { "u24", "u24" },
      { "u32", "u32" },
      { "u40", "u40" },
      { "u48", "u48" },

      { "i8", "i8" },
      { "i16", "i16" },
      { "i24", "i24" },
      { "i32", "i32" },
      { "i40", "i40" },
      { "i48", "i48" },

      { "u8bool", "u8bool" },
      { "u8s", "u8string" },
      { "u16s", "u16string" },
      { "u24s", "u24string" },
      { "u32s", "u32string" },

      { "vvarray", "*array", mv },
      { "v4array", "array", mv, 4 },
      { "u8s_map", "map", "u8string", mv },
    })

    t3:assert(s:size() > 8)

    local stream = StringBuffer:new("", "w")
    local a = {
      u8 = Limits.UMIN[8],
      u16 = Limits.UMIN[16],
      u24 = Limits.UMIN[24],
      u32 = Limits.UMIN[32],
      u40 = Limits.UMIN[40],
      u48 = Limits.UMIN[48],

      i8 = Limits.IMIN[8],
      i16 = Limits.IMIN[16],
      i24 = Limits.IMIN[24],
      i32 = Limits.IMIN[32],
      i40 = Limits.IMIN[40],
      i48 = Limits.IMIN[48],

      u8bool = false,
      u8s = "abc",
      u16s = "xyz",
      u24s = "something",
      u32s = "something longer",

      vvarray = { "This", "is", "a", "variable", "length", "array", -1, true, {} },
      v4array = { 0, false, {}, "Hello" },
      u8s_map = {
        int = 0,
        bool = true,
        str = "Hello, World"
      },
    }
    local b = {
      u8 = Limits.UMAX[8],
      u16 = Limits.UMAX[16],
      u24 = Limits.UMAX[24],
      u32 = Limits.UMAX[32],
      u40 = Limits.UMAX[40],
      u48 = Limits.UMAX[48],

      i8 = Limits.IMAX[8],
      i16 = Limits.IMAX[16],
      i24 = Limits.IMAX[24],
      i32 = Limits.IMAX[32],
      i40 = Limits.IMAX[40],
      i48 = Limits.IMAX[48],

      u8bool = true,
      u8s = "abc",
      u16s = "xyz",
      u24s = "something",
      u32s = "something longer",

      vvarray = { "This", "is", "a", "variable", "length", "array", Limits.IMAX[48], false, { a = "z" } },
      v4array = { 122222, true, { 0, 1, 2 }, "Goodbye" },
      u8s_map = {
        int = -1,
        bool = false,
        str = "Goodbye, Universe"
      },
    }

    s:write(BB, stream, a)
    s:write(BB, stream, b)

    stream:reopen("r")

    t3:assert_deep_eq(a, s:read(BB, stream))
    t3:assert_deep_eq(b, s:read(BB, stream))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()

