--
-- Foundation Struct
--
-- Adds wrapper classes for some basic structures
local mod = foundation.new_module("foundation_struct", "1.5.0")

mod:require("struct/list.lua")
mod:require("struct/linked_list.lua")
mod:require("struct/ring_buffer.lua")

mod:require("type_casts.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
