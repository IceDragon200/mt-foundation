local mod = foundation_xml

--- @namespace foundation.com.XML
local XML = {}
foundation_xml.XML = XML

mod:require("xml/node.lua")

mod:require("xml/lexer.lua")
--- @spec tokenize(String): (Boolean, TokenBuffer, String)
XML.tokenize = XML.Lexer.tokenize

mod:require("xml/decoder.lua")
--- @spec decode(String): (Boolean, Table | nil, String)
XML.decode = XML.Decoder.decode

mod:require("xml/encoder.lua")
--- @spec encode(Table): String
XML.encode = XML.Encoder.encode

foundation.com.XML = XML
