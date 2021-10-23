--
-- Foundation Struct
--
-- Adds wrapper classes for some basic structures
local mod = foundation.new_module("foundation_struct", "1.1.0")

mod:require("struct/list.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
