--
-- Various utilities for dealing with inventories
--
local mod = foundation.new_module("foundation_inv", "2.0.0")

mod:require("inventory_serializer.lua")
mod:require("inventory_packer.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
  --mod:require("benchmarks.lua")
end
