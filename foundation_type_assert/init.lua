--[[

  Foundation Type Assert

]]
local mod = foundation.new_module("foundation_type_assert", "1.2.0")

--- @namespace foundation.com.assert
foundation.com.assert = foundation.com.assert or {}
--- @alias assertions = assert
foundation.com.assertions = foundation.com.assert

mod:require("api.lua")
