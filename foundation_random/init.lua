--
-- Foundation Random
--
--   Various utilities for generating randomness, or for obtaining randomness.
--
local mod = foundation.new_module("foundation_random", "1.1.0")

mod:require("lib/weighted_list.lua")
mod:require("lib/ulid.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
--mod:require("benchmarks.lua")
