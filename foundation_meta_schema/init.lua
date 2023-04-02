local mod = foundation.new_module("foundation_meta_schema", "1.1.0")

mod:require("meta_schema.lua")

if foundation.com.Luna then
  mod:require("tests/meta_schema_test.lua")
end
