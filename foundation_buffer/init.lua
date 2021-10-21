local mod = foundation.new_module("foundation_buffer", "2.0.0")

mod:require("string_buffer.lua")
mod:require("token_buffer.lua")

if foundation.com.Luna then
  mod:require("tests/string_buffer_test.lua")
end
