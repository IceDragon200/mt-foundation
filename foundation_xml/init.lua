--
-- Foundation XML
--
local mod = foundation.new_module("foundation_xml", "0.0.0")

mod:require("xml.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
