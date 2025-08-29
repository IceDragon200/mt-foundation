--
-- Foundation Headless
--
local mod = foundation.new_module("foundation_headless", "2.3.1")

--- @namespace foundation.com.headless
foundation.com.headless = foundation.com.headless or {}

mod:require("voxel_line_iterator.lua")
mod:require("meta_data_ref.lua")
mod:require("item_stack.lua")
mod:require("inv_ref.lua")
mod:require("object_ref.lua")
mod:require("player_ref.lua")
mod:require("luaentity.lua")

mod:require("world.lua")
mod:require("raycast.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
