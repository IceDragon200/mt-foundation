--
-- Experimental Library for implementing processes like erlang
--
local mod = foundation.new_module("foundation_process", "1.0.0")

mod:require("process_runner.lua")

mod:require("tests.lua")
