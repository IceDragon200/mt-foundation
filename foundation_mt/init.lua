--
-- Foundation MT, contains some various utilities for general luanti stuff
--
local mod = foundation.new_module("foundation_mt", "3.1.0")

--- @namespace foundation.com
mod:require("helpers.lua")
mod:require("groups.lua")
mod:require("schematic_helpers.lua")
mod:require("lib/meta_ref.lua")
mod:require("lib/item_stack.lua")
mod:require("lib/inventory_list.lua")
mod:require("lib/node_timer.lua")
mod:require("lib/direction.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
