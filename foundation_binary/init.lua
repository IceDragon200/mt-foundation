local mod = foundation.new_module("foundation_binary", "1.0.0")

local insec = minetest.request_insecure_environment()
if insec then
  foundation.com.native_bit = insec.require("bit")
  foundation.com.ffi = insec.require("ffi")
else
  minetest.log("warn", "foundation_binary requested an insecure environment but got nothing, some modules may be unavailable.")
end

mod:require("bit.lua")
mod:require("byte_encoder.lua")
mod:require("byte_decoder.lua")
mod:require("byte_buf.lua")
mod:require("bin_schema.lua")
mod:require("bin_types.lua")
mod:require("binary_buffer.lua")

mod:require("tests.lua")

foundation.com.ffi = nil
foundation.com.native_bit = nil
