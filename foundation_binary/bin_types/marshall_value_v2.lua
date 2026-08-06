local Limits = assert(foundation.com.LIMITS)

local floor = assert(math.floor)

--- @namespace foundation.com.binary_types

---
--- Marshall values can be a specific scalar type, annotated by a letter code
---
--- * `f` for f32
--- * `d` for f64
--- * `b` for i8 integers
--- * `B` for u8 integers
--- * `s` for i16 integers
--- * `S` for u16 integers
--- * `i` for i32 integers
--- * `I` for u32 integers
--- * `t` for i48 integers (t = triple, i.e. triple-word, triple-short)
--- * `T` for u48 integers
---
--- * `0` for nil
--- * `$` for u32 strings
--- * `?` for u8 booleans
--- * `{` for tables
---
--- @class MarshallValue.V2
local MarshallValue = foundation.com.Class:extends("MarshallValue")
do
  local ic = MarshallValue.instance_class

  --- @override
  --- @spec #initialize(): void
  function ic:initialize()
    ic._super.initialize(self)
  end

  function ic:size()
    return 0
  end

  function ic:write_i48(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "t")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i48(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_u48(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "T")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i48(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_i32(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "i")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i32(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_u32(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "I")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i32(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_i16(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "s")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i16(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_u16(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "S")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i16(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_i8(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "b")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i8(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_u8(byte_buf, stream, data)
    -- integer, only integers are supported.
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "B")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_i8(stream, data)
    abw = abw + bw
    return abw, err
  end

  --- @spec #write_integer(byte_buf: ByteBuf, stream: Stream, data: Integer):
  function ic:write_integer(byte_buf, stream, data)
    if data >= Limits.IMIN[8] and data <= Limits.IMAX[8] then
      return self:write_i8(byte_buf, stream, data)
    elseif data >= Limits.UMIN[8] and data <= Limits.UMAX[8] then
      return self:write_u8(byte_buf, stream, data)
    elseif data >= Limits.IMIN[16] and data <= Limits.IMAX[16] then
      return self:write_i16(byte_buf, stream, data)
    elseif data >= Limits.UMIN[16] and data <= Limits.UMAX[16] then
      return self:write_u16(byte_buf, stream, data)
    elseif data >= Limits.IMIN[32] and data <= Limits.IMAX[32] then
      return self:write_i32(byte_buf, stream, data)
    elseif data >= Limits.UMIN[32] and data <= Limits.UMAX[32] then
      return self:write_u32(byte_buf, stream, data)
    elseif data >= Limits.IMIN[48] and data <= Limits.IMAX[48] then
      return self:write_i48(byte_buf, stream, data)
    elseif data >= Limits.UMIN[48] and data <= Limits.UMAX[48] then
      return self:write_u48(byte_buf, stream, data)
    else
      -- For everything else, just dump the floating point
      return self:write_f64(byte_buf, stream, data)
    end
  end

  function ic:write_f32(byte_buf, stream, data)
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "f")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_f32(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_f64(byte_buf, stream, data)
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "d")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_f64(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_string(byte_buf, stream, data)
    -- String
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "$")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_u32string(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_boolean(byte_buf, stream, data)
    local abw = 0
    local bw
    local err
    bw, err = byte_buf:write(stream, "?")
    abw = abw + bw
    if err then
      return abw, err
    end
    bw, err = byte_buf:w_u8bool(stream, data)
    abw = abw + bw
    return abw, err
  end

  function ic:write_table(byte_buf, stream, data)
    local abw = 0
    local bw
    local err
    -- Write value identifier
    bw, err = byte_buf:write(stream, "{")
    abw = abw + bw

    if err then
      return abw, err
    end

    -- Determine table size
    local len = 0
    for _,_ in pairs(data) do
      len = len + 1
    end

    -- Write its length
    bw, err = byte_buf:w_i32(stream, len)
    abw = abw + bw

    if err then
      return abw, err
    end

    for key,value in pairs(data) do
      bw, err = self:write(byte_buf, stream, key)
      abw = abw + bw

      if err then
        return abw, err
      end

      bw, err = self:write(byte_buf, stream, value)
      abw = abw + bw

      if err then
        return abw, err
      end
    end

    return abw, nil
  end

  --- @spec #write(byte_buf: ByteBuf, stream: Stream, data: Any): (bytes_written: Number, err: Any)
  function ic:write(byte_buf, stream, data)
    assert(byte_buf, "expected a byte buffer")
    local ty = type(data)
    if ty == "nil" then
      return byte_buf:write(stream, "0")
    elseif ty == "number" then
      if floor(data) == data then
        return self:write_integer(byte_buf, stream, data)
      else
        if data >= Limits.FMAX[32] then
          return self:write_f64(byte_buf, stream, data)
        else
          return self:write_f32(byte_buf, stream, data)
        end
      end
    elseif ty == "string" then
      return self:write_string(byte_buf, stream, data)
    elseif ty == "boolean" then
      return self:write_boolean(byte_buf, stream, data)
    elseif ty == "table" then
      return self:write_table(byte_buf, stream, data)
    else
      error("unexpcted type " .. ty)
    end
  end

  function ic:do_read_table(byte_buf, stream)
    -- Read the number of key-value pairs present
    local result = {}
    local abr = 0

    local num_pairs = byte_buf:r_i32(stream)

    local key
    local value
    local br
    for i = 1,num_pairs do
      key, br = self:read(byte_buf, stream)
      abr = abr + br

      value, br = self:read(byte_buf, stream)
      abr = abr + br

      result[key] = value
    end

    return result, abr
  end

  --- @spec #read(byte_buf: ByteBuf, stream: Stream): (Any, bytes_read: Number)
  function ic:read(byte_buf, stream)
    local abr = 0
    local value
    local br
    local type_code
    type_code, br = byte_buf:read(stream, 1)
    abr = abr + br
    if type_code == "0" then
      return nil, abr
    elseif type_code == "f" then
      value, br = byte_buf:r_f32(stream)
      return value, abr + br
    elseif type_code == "d" then
      value, br = byte_buf:r_f64(stream)
      return value, abr + br
    elseif type_code == "b" then
      value, br = byte_buf:r_i8(stream)
      return value, abr + br
    elseif type_code == "B" then
      value, br = byte_buf:r_u8(stream)
      return value, abr + br
    elseif type_code == "s" then
      value, br = byte_buf:r_i16(stream)
      return value, abr + br
    elseif type_code == "S" then
      value, br = byte_buf:r_u16(stream)
      return value, abr + br
    elseif type_code == "i" then
      value, br = byte_buf:r_i32(stream)
      return value, abr + br
    elseif type_code == "I" then
      value, br = byte_buf:r_u32(stream)
      return value, abr + br
    elseif type_code == "t" then
      value, br = byte_buf:r_i48(stream)
      return value, abr + br
    elseif type_code == "T" then
      value, br = byte_buf:r_u48(stream)
      return value, abr + br
    elseif type_code == "$" then
      value, br = byte_buf:r_u32string(stream)
      return value, abr + br
    elseif type_code == "?" then
      value, br = byte_buf:r_u8bool(stream)
      return value, abr + br
    elseif type_code == "{" then
      value, br = self:do_read_table(byte_buf, stream)
      return value, abr + br
    else
      error("unexpected type_code `" .. type_code .. "`")
    end
  end
end

foundation.com.binary_types.MarshallValue.V2 = MarshallValue
