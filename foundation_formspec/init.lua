--
-- Foundation Formspec
--
-- This module turns formspec elements into objects that can be reused and thrown around.
local mod = foundation.new_module("foundation_formspec", "1.6.1")

mod:require("api.lua")
mod:require("parser.lua")
mod:require("layout.lua")
mod:require("ui.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
