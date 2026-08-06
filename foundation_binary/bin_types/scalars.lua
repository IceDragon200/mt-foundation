--- @namespace foundation.com.binary_types
local ByteBuf = assert(foundation.com.ByteBuf.little)

local function mksize(len)
  return function ()
    return len
  end
end

local ScalarTypes = {
  -- Signed Integers
  i8 = {size=mksize(1)},
  i16 = {size=mksize(2)},
  i24 = {size=mksize(3)},
  i32 = {size=mksize(4)},
  i40 = {size=mksize(5)},
  i48 = {size=mksize(6)},
  i64 = {size=mksize(8)},
  -- Unsigned Integers
  u8 = {size=mksize(1)},
  u16 = {size=mksize(2)},
  u24 = {size=mksize(3)},
  u32 = {size=mksize(4)},
  u40 = {size=mksize(5)},
  u48 = {size=mksize(6)},
  u64 = {size=mksize(8)},
  -- Floating-Point Numbers
  f16 = {size=mksize(2)},
  f24 = {size=mksize(3)},
  f32 = {size=mksize(4)},
  f40 = {size=mksize(5)},
  f48 = {size=mksize(6)},
  f64 = {size=mksize(8)},
  -- Special types
  u8bool = {size=mksize(1)},
  -- Strings, size is based on the minimum size
  u8string = {size=mksize(1)},
  u16string = {size=mksize(2)},
  u24string = {size=mksize(3)},
  u32string = {size=mksize(4)},
}

function ScalarTypes.i8:write(byte_buf, file, data)
  return byte_buf:w_i8(file, data)
end
function ScalarTypes.i16:write(byte_buf, file, data)
  return byte_buf:w_i16(file, data)
end
function ScalarTypes.i24:write(byte_buf, file, data)
  return byte_buf:w_i24(file, data)
end
function ScalarTypes.i32:write(byte_buf, file, data)
  return byte_buf:w_i32(file, data)
end
function ScalarTypes.i40:write(byte_buf, file, data)
  return byte_buf:w_i40(file, data)
end
function ScalarTypes.i48:write(byte_buf, file, data)
  return byte_buf:w_i48(file, data)
end
function ScalarTypes.i64:write(byte_buf, file, data)
  return byte_buf:w_i64(file, data)
end

function ScalarTypes.u8:write(byte_buf, file, data)
  return byte_buf:w_u8(file, data)
end
function ScalarTypes.u16:write(byte_buf, file, data)
  return byte_buf:w_u16(file, data)
end
function ScalarTypes.u24:write(byte_buf, file, data)
  return byte_buf:w_u24(file, data)
end
function ScalarTypes.u32:write(byte_buf, file, data)
  return byte_buf:w_u32(file, data)
end
function ScalarTypes.u40:write(byte_buf, file, data)
  return byte_buf:w_u40(file, data)
end
function ScalarTypes.u48:write(byte_buf, file, data)
  return byte_buf:w_u48(file, data)
end
function ScalarTypes.u64:write(byte_buf, file, data)
  return byte_buf:w_u64(file, data)
end

function ScalarTypes.f16:write(byte_buf, file, data)
  return byte_buf:w_f16(file, data)
end
function ScalarTypes.f24:write(byte_buf, file, data)
  return byte_buf:w_f24(file, data)
end
function ScalarTypes.f32:write(byte_buf, file, data)
  return byte_buf:w_f32(file, data)
end
function ScalarTypes.f64:write(byte_buf, file, data)
  return byte_buf:w_f64(file, data)
end

function ScalarTypes.u8bool:write(byte_buf, file, data)
  return byte_buf:w_u8bool(file, data)
end

function ScalarTypes.u8string:write(byte_buf, file, data)
  return byte_buf:w_u8string(file, data)
end
function ScalarTypes.u16string:write(byte_buf, file, data)
  return byte_buf:w_u16string(file, data)
end
function ScalarTypes.u24string:write(byte_buf, file, data)
  return byte_buf:w_u24string(file, data)
end
function ScalarTypes.u32string:write(byte_buf, file, data)
  return byte_buf:w_u32string(file, data)
end

function ScalarTypes.i8:read(byte_buf, file)
  return byte_buf:r_i8(file)
end
function ScalarTypes.i16:read(byte_buf, file)
  return byte_buf:r_i16(file)
end
function ScalarTypes.i24:read(byte_buf, file)
  return byte_buf:r_i24(file)
end
function ScalarTypes.i32:read(byte_buf, file)
  return byte_buf:r_i32(file)
end
function ScalarTypes.i40:read(byte_buf, file)
  return byte_buf:r_i40(file)
end
function ScalarTypes.i48:read(byte_buf, file)
  return byte_buf:r_i48(file)
end
function ScalarTypes.i64:read(byte_buf, file)
  return byte_buf:r_i64(file)
end

function ScalarTypes.u8:read(byte_buf, file)
  return byte_buf:r_u8(file)
end
function ScalarTypes.u16:read(byte_buf, file)
  return byte_buf:r_u16(file)
end
function ScalarTypes.u24:read(byte_buf, file)
  return byte_buf:r_u24(file)
end
function ScalarTypes.u32:read(byte_buf, file)
  return byte_buf:r_u32(file)
end
function ScalarTypes.u40:read(byte_buf, file)
  return byte_buf:r_u40(file)
end
function ScalarTypes.u48:read(byte_buf, file)
  return byte_buf:r_u48(file)
end
function ScalarTypes.u64:read(byte_buf, file)
  return byte_buf:r_u64(file)
end

function ScalarTypes.f16:read(byte_buf, file)
  return byte_buf:r_f16(file)
end
function ScalarTypes.f24:read(byte_buf, file)
  return byte_buf:r_f24(file)
end
function ScalarTypes.f32:read(byte_buf, file)
  return byte_buf:r_f32(file)
end
function ScalarTypes.f64:read(byte_buf, file)
  return byte_buf:r_f64(file)
end

function ScalarTypes.u8bool:read(byte_buf, file)
  return byte_buf:r_u8bool(file)
end

function ScalarTypes.u8string:read(byte_buf, file)
  return byte_buf:r_u8string(file)
end
function ScalarTypes.u16string:read(byte_buf, file)
  return byte_buf:r_u16string(file)
end
function ScalarTypes.u24string:read(byte_buf, file)
  return byte_buf:r_u24string(file)
end
function ScalarTypes.u32string:read(byte_buf, file)
  return byte_buf:r_u32string(file)
end

function ScalarTypes.normalize_type(t)
  if type(t) == "string" then
    local scalar_type = ScalarTypes[t]
    assert(scalar_type, "expected a scalar type")
    return scalar_type
  elseif type(t) == "table" then
    assert(t.write, "expected write/3")
    assert(t.read, "expected read/2")
    return t
  else
    error("unexpected type " .. type(t))
  end
end

foundation.com.binary_types.Scalars = ScalarTypes
