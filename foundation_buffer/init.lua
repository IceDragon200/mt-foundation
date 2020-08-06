local mod = foundation.new_module("foundation_buffer", "1.0.0")

mod:require("string_buffer.lua")

if foundation.com.Luna then
  mod:require("tests/string_buffer_test.lua")
end
