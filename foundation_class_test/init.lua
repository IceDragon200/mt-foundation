--
-- Because of the circular depedency, this mod exists to
-- test foundation.com.Class.
--
local mod = foundation.new_module("foundation_class_test", "1.0.0")

mod:require("tests.lua")
