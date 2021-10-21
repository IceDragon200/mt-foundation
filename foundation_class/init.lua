--
-- A minimal object class system.
--
-- Please don't abuse classes, use them sparingly.
--
local mod = foundation.new_module("foundation_class", "2.0.0")

mod:require("class.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
