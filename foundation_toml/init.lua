local mod = foundation.new_module("foundation_toml", "1.0.0")

mod:require("toml.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
