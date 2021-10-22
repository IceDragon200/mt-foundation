local mod = foundation_kdl

-- @namespace foundation.com.KDL
local KDL = {}
foundation_kdl.KDL = KDL

mod:require("kdl/lexer.lua")
-- @spec tokenize(String): (true, Table) | (false, Table, String)
KDL.tokenize = KDL.Lexer.tokenize

mod:require("kdl/decoder.lua")
-- @spec decode(String): (Boolean, Table | nil, String)
KDL.decode = KDL.Decoder.decode

mod:require("kdl/encoder.lua")
-- @spec encode(Table): String
function KDL.encode(node)
end

foundation.com.KDL = KDL
