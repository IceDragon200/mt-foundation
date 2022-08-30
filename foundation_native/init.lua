local mod = foundation.new_module("foundation_native", "1.0.0")

local insec = minetest.request_insecure_environment()
if insec then
  foundation.com.ffi = insec.require("ffi")
else
  minetest.log(
    "warn",
    "foundation_native requested an insecure environment to require ffi, but got nothing." ..
    " Some modules will be disabled or implemented in lua."
  )
end

mod:require("native.lua")

if foundation.com.native_utils then
  local native_utils = assert(foundation.com.native_utils)
  local ffi = assert(foundation.com.ffi)

  local spacer_buffer = ffi.new("char[4096]")

  function foundation.com.ffi_string_hex_decode(str)
    return foundation.com.ffi_encoder(str, function (pcursor, pstr, pbuffer)
      native_utils.foundation_string_hex_decode(pcursor, pstr, pbuffer)
    end)
  end

  function foundation.com.ffi_string_hex_encode(str, spacer)
    spacer = spacer or ""
    local spacer_len = #spacer
    ffi.copy(spacer_buffer, spacer, spacer_len)
    return foundation.com.ffi_encoder(str, function (pcursor, pstr, pbuffer)
      native_utils.foundation_string_hex_encode(pcursor, pstr, pbuffer, spacer_len, spacer_buffer)
    end)
  end

  function foundation.com.ffi_string_hex_escape(str, mode)
    mode = mode or "non-ascii"
    local mode_int = 0

    if mode ~= "non-ascii" then
      mode_int = 1
    end

    return foundation.com.ffi_encoder(str, function (pcursor, pstr, pbuffer)
      native_utils.foundation_string_hex_escape(pcursor, pstr, pbuffer, mode_int)
    end)
  end

  function foundation.com.ffi_string_hex_unescape(str)
    return foundation.com.ffi_encoder(str, function (pcursor, pstr, pbuffer)
      native_utils.foundation_string_hex_unescape(pcursor, pstr, pbuffer)
    end)
  end

  minetest.log("info", "using FFI string_hex functions")
  foundation.com.string_hex_decode = foundation.com.ffi_string_hex_decode
  foundation.com.string_hex_encode = foundation.com.ffi_string_hex_encode
  foundation.com.string_hex_escape = foundation.com.ffi_string_hex_escape
  foundation.com.string_hex_unescape = foundation.com.ffi_string_hex_unescape
end

foundation.com.ffi = nil
