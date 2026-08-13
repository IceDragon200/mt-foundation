--
-- Extensions to StringBuffer adding binary helpers
--
local BB_LE = assert(foundation.com.ByteBuf.LE)
local BB_BE = assert(foundation.com.ByteBuf.BE)

--- @namespace foundation.com
--- @class StringBuffer
local StringBuffer = assert(foundation.com.StringBuffer)

do
  local ic = StringBuffer.instance_class

  --
  -- Big Endian
  --

  --- @since "3.2.0"
  --- @spec #read_be_u8(): Integer
  function ic:read_be_u8()
    return BB_BE:r_u8(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_u16(): Integer
  function ic:read_be_u16()
    return BB_BE:r_u16(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_u24(): Integer
  function ic:read_be_u24()
    return BB_BE:r_u24(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_u32(): Integer
  function ic:read_be_u32()
    return BB_BE:r_u32(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_u40(): Integer
  function ic:read_be_u40()
    return BB_BE:r_u40(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_u48(): Integer
  function ic:read_be_u48()
    return BB_BE:r_u48(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_u64(): Integer
  function ic:read_be_u64()
    return BB_BE:r_u64(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i8(): Integer
  function ic:read_be_i8()
    return BB_BE:r_i8(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i16(): Integer
  function ic:read_be_i16()
    return BB_BE:r_i16(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i24(): Integer
  function ic:read_be_i24()
    return BB_BE:r_i24(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i32(): Integer
  function ic:read_be_i32()
    return BB_BE:r_i32(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i40(): Integer
  function ic:read_be_i40()
    return BB_BE:r_i40(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i48(): Integer
  function ic:read_be_i48()
    return BB_BE:r_i48(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_i64(): Integer
  function ic:read_be_i64()
    return BB_BE:r_i64(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_f16(): Integer
  function ic:read_be_f16()
    return BB_BE:r_f16(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_f24(): Integer
  function ic:read_be_f24()
    return BB_BE:r_f24(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_f32(): Integer
  function ic:read_be_f32()
    return BB_BE:r_f32(self)
  end

  --- @since "3.2.0"
  --- @spec #read_be_f64(): Integer
  function ic:read_be_f64()
    return BB_BE:r_f64(self)
  end

  --
  -- Little Endian
  --

  --- @since "3.2.0"
  --- @spec #read_le_u8(): Integer
  function ic:read_le_u8()
    return BB_LE:r_u8(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_u16(): Integer
  function ic:read_le_u16()
    return BB_LE:r_u16(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_u24(): Integer
  function ic:read_le_u24()
    return BB_LE:r_u24(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_u32(): Integer
  function ic:read_le_u32()
    return BB_LE:r_u32(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_u40(): Integer
  function ic:read_le_u40()
    return BB_LE:r_u40(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_u48(): Integer
  function ic:read_le_u48()
    return BB_LE:r_u48(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_u64(): Integer
  function ic:read_le_u64()
    return BB_LE:r_u64(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i8(): Integer
  function ic:read_le_i8()
    return BB_LE:r_i8(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i16(): Integer
  function ic:read_le_i16()
    return BB_LE:r_i16(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i24(): Integer
  function ic:read_le_i24()
    return BB_LE:r_i24(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i32(): Integer
  function ic:read_le_i32()
    return BB_LE:r_i32(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i40(): Integer
  function ic:read_le_i40()
    return BB_LE:r_i40(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i48(): Integer
  function ic:read_le_i48()
    return BB_LE:r_i48(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_i64(): Integer
  function ic:read_le_i64()
    return BB_LE:r_i64(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_f16(): Integer
  function ic:read_le_f16()
    return BB_LE:r_f16(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_f24(): Integer
  function ic:read_le_f24()
    return BB_LE:r_f24(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_f32(): Integer
  function ic:read_le_f32()
    return BB_LE:r_f32(self)
  end

  --- @since "3.2.0"
  --- @spec #read_le_f64(): Integer
  function ic:read_le_f64()
    return BB_LE:r_f64(self)
  end
end
