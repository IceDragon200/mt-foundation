local table_freeze = assert(foundation.com.table_freeze)
local string_char = assert(string.char)

--- @namespace foundation.com

local IMIN = {}
local IMAX = {}
local UMIN = {}
local UMAX = {}
local FMIN = {}
local FMAX = {}

for i = 1,54 do
  if i > 1 then
    IMIN[i] = -(2 ^ (i - 1))
    IMAX[i] = (2 ^ (i - 1)) - 1
  end
  UMIN[i] = 0
  UMAX[i] = (2 ^ i) - 1
end

FMAX[32] = (2 - (2 ^ -23)) * (2 ^ 127)
FMAX[64] = (2 - (2 ^ -52)) * (2 ^ 1023)
FMIN[32] = -FMAX[32]
FMIN[64] = -FMAX[64]

--- @const foundation.com.LIMITS: {
---   IMIN = { [bits: Number]: Number },
---   IMAX = { [bits: Number]: Number },
---   UMIN = { [bits: Number]: Number },
---   UMAX = { [bits: Number]: Number },
---   FMIN = { [bits: Number]: Number },
---   FMAX = { [bits: Number]: Number },
--- }
foundation.com.LIMITS = table_freeze({
  IMIN = table_freeze(IMIN),
  IMAX = table_freeze(IMAX),
  UMIN = table_freeze(UMIN),
  UMAX = table_freeze(UMAX),
  FMIN = table_freeze(FMIN),
  FMAX = table_freeze(FMAX),
})

--- @const BYTE2CHAR: { [byte: Number]: String }
foundation.com.BYTE2CHAR = {}
for i = 0,255 do
  foundation.com.BYTE2CHAR[i] = string_char(i)
end
table_freeze(foundation.com.BYTE2CHAR)

--- @const HEX_UPPERCASE_ENCODE_TABLE: { [Integer]: String }
foundation.com.HEX_UPPERCASE_ENCODE_TABLE = table_freeze({
  [0] = "0",
  [1] = "1",
  [2] = "2",
  [3] = "3",
  [4] = "4",
  [5] = "5",
  [6] = "6",
  [7] = "7",
  [8] = "8",
  [9] = "9",
  [10] = "A",
  [11] = "B",
  [12] = "C",
  [13] = "D",
  [14] = "E",
  [15] = "F",
})

--- @alias HEX_TABLE = HEX_UPPERCASE_ENCODE_TABLE
foundation.com.HEX_TABLE = foundation.com.HEX_UPPERCASE_ENCODE_TABLE

--- @const HEX_TO_DEC: { [String]: Integer }
foundation.com.HEX_TO_DEC = {}
for dec, hex in pairs(foundation.com.HEX_UPPERCASE_ENCODE_TABLE) do
  foundation.com.HEX_TO_DEC[hex] = dec
end
foundation.com.HEX_TO_DEC["a"] = 10
foundation.com.HEX_TO_DEC["b"] = 11
foundation.com.HEX_TO_DEC["c"] = 12
foundation.com.HEX_TO_DEC["d"] = 13
foundation.com.HEX_TO_DEC["e"] = 14
foundation.com.HEX_TO_DEC["f"] = 15
table_freeze(foundation.com.HEX_TO_DEC)

--- @const HEX_BYTE_TO_DEC: { [Integer]: Integer }
foundation.com.HEX_BYTE_TO_DEC = {}
for hex_char, dec in pairs(foundation.com.HEX_TO_DEC) do
  foundation.com.HEX_BYTE_TO_DEC[string.byte(hex_char, 1, 1)] = dec
end
table_freeze(foundation.com.HEX_BYTE_TO_DEC)

--- @const CROCKFORD_BASE32_ENCODE_TABLE: { [Integer]: String }
foundation.com.CROCKFORD_BASE32_ENCODE_TABLE = table_freeze({
  [0] = "0",
  [1] = "1",
  [2] = "2",
  [3] = "3",
  [4] = "4",
  [5] = "5",
  [6] = "6",
  [7] = "7",
  [8] = "8",
  [9] = "9",
  [10] = "A",
  [11] = "B",
  [12] = "C",
  [13] = "D",
  [14] = "E",
  [15] = "F",
  [16] = "G",
  [17] = "H",
  [18] = "J",
  [19] = "K",
  [20] = "M",
  [21] = "N",
  [22] = "P",
  [23] = "Q",
  [24] = "R",
  [25] = "S",
  [26] = "T",
  [27] = "V",
  [28] = "W",
  [29] = "X",
  [30] = "Y",
  [31] = "Z",
})

--- @const CROCKFORD_BASE32_DECODE_TABLE: { [String]: Integer }
foundation.com.CROCKFORD_BASE32_DECODE_TABLE = table_freeze({
  ["0"] = 0,
  ["O"] = 0,
  ["o"] = 0,
  ["1"] = 1,
  ["I"] = 1,
  ["i"] = 1,
  ["L"] = 1,
  ["l"] = 1,
  ["2"] = 2,
  ["3"] = 3,
  ["4"] = 4,
  ["5"] = 5,
  ["6"] = 6,
  ["7"] = 7,
  ["8"] = 8,
  ["9"] = 9,
  ["A"] = 10,
  ["a"] = 10,
  ["B"] = 11,
  ["b"] = 11,
  ["C"] = 12,
  ["c"] = 12,
  ["D"] = 13,
  ["d"] = 13,
  ["E"] = 14,
  ["e"] = 14,
  ["F"] = 15,
  ["f"] = 15,
  ["G"] = 16,
  ["g"] = 16,
  ["H"] = 17,
  ["h"] = 17,
  ["J"] = 18,
  ["j"] = 18,
  ["K"] = 19,
  ["k"] = 19,
  ["M"] = 20,
  ["m"] = 20,
  ["N"] = 21,
  ["n"] = 21,
  ["P"] = 22,
  ["p"] = 22,
  ["Q"] = 23,
  ["q"] = 23,
  ["R"] = 24,
  ["r"] = 24,
  ["S"] = 25,
  ["s"] = 25,
  ["T"] = 26,
  ["t"] = 26,
  ["V"] = 27,
  ["v"] = 27,
  ["W"] = 28,
  ["w"] = 28,
  ["X"] = 29,
  ["x"] = 29,
  ["Y"] = 30,
  ["y"] = 30,
  ["Z"] = 31,
  ["z"] = 31,
})
