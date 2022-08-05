--
-- KDL Module
--  https://github.com/kdl-org/kdl
local mod = foundation.new_module("foundation_kdl", "0.0.1")

mod:require("kdl.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
