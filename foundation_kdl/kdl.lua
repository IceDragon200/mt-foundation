local mod = foundation_kdl

--- @namespace foundation.com.KDL
local KDL = {}
foundation_kdl.KDL = KDL

mod:require("kdl/node.lua")

mod:require("kdl/lexer.lua")
--- @spec tokenize(String): (Boolean, TokenBuffer, String)
KDL.tokenize = KDL.Lexer.tokenize

mod:require("kdl/decoder.lua")
--- @spec decode(String): (Boolean, Table | nil, String)
KDL.decode = KDL.Decoder.decode

mod:require("kdl/encoder.lua")
--- @spec encode(Table): String
KDL.encode = KDL.Encoder.encode

foundation.com.KDL = KDL
