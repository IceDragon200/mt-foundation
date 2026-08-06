--- @namespace foundation.com.binary_types

--
-- Marshall values can be a specific scalar type, annotated by a letter code
--
-- f for stringified floats
-- I for i32 integers
-- Q for u32 strings
-- B for u8 booleans
-- T for tables
--

--- @class MarshallValue
local MarshallValue = foundation.com.Class:extends("MarshallValue")
do
  local ic = MarshallValue.instance_class

  function ic:initialize()
    ic._super.initialize(self)
  end

  --- @spec #size(): Number
  function ic:size()
    -- Marshall's default size IS zero, as it doesn't have a fixed length
    return 0
  end

  function ic:write_integer(byte_buf, file, data)
    local all_bytes_written = 0
    local bytes_written
    local err

    bytes_written, err = byte_buf:write(file, "I")
    all_bytes_written = all_bytes_written + bytes_written
    if err then
      return all_bytes_written, err
    end
    bytes_written, err = byte_buf:w_i32(file, data)
    all_bytes_written = all_bytes_written + bytes_written
    return all_bytes_written, err
  end

  function ic:write_float(byte_buf, file, data)
    local all_bytes_written = 0
    local bytes_written
    local err

    bytes_written, err = byte_buf:write(file, "f")
    all_bytes_written = all_bytes_written + bytes_written
    if err then
      return all_bytes_written, err
    end
    bytes_written, err = byte_buf:w_u8string(file, tostring(data))
    all_bytes_written = all_bytes_written + bytes_written
    return all_bytes_written, err
  end

  function ic:write_string(byte_buf, file, data)
    -- String
    local all_bytes_written = 0
    local bytes_written
    local err

    bytes_written, err = byte_buf:write(file, "Q")
    all_bytes_written = all_bytes_written + bytes_written
    if err then
      return all_bytes_written, err
    end
    bytes_written, err = byte_buf:w_u32string(file, data)
    all_bytes_written = all_bytes_written + bytes_written
    return all_bytes_written, err
  end

  function ic:write_boolean(byte_buf, file, data)
    local all_bytes_written = 0
    local bytes_written
    local err

    bytes_written, err = byte_buf:write(file, "B")
    all_bytes_written = all_bytes_written + bytes_written
    if err then
      return all_bytes_written, err
    end
    bytes_written, err = byte_buf:w_u8bool(file, data)
    all_bytes_written = all_bytes_written + bytes_written
    return all_bytes_written, err
  end

  --- @spec #write_table(byte_buf: ByteBuf, file: Stream, data: Table): (Number, nil | Any)
  function ic:write_table(byte_buf, file, data)
    local abw = 0
    local bw
    local err

    -- Write value identifier
    bw, err = byte_buf:write(file, "T")
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
    bw, err = byte_buf:w_i32(file, len)
    abw = abw + bw

    if err then
      return abw, err
    end

    for key,value in pairs(data) do
      bw, err = self:write(byte_buf, file, key)
      abw = abw + bw

      if err then
        return abw, err
      end

      bw, err = self:write(byte_buf, file, value)
      abw = abw + bw

      if err then
        return abw, err
      end
    end

    return abw, nil
  end

  --- @spec #write(ByteBuf, file: Stream, data: Any): (Number, nil | Any)
  function ic:write(byte_buf, file, data)
    if type(data) == "nil" then
      return byte_buf:write(file, "0")
    elseif type(data) == "number" then
      if math.floor(data) == data then
        return self:write_integer(byte_buf, file, data)
      else
        return self:write_float(byte_buf, file, data)
      end
    elseif type(data) == "string" then
      return self:write_string(byte_buf, file, data)
    elseif type(data) == "boolean" then
      return self:write_boolean(byte_buf, file, data)
    elseif type(data) == "table" then
      return self:write_table(byte_buf, file, data)
    else
      error("unexpcted type " .. type(data))
    end
  end

  function ic:do_read_table(byte_buf, file)
    -- Read the number of key-value pairs present
    local result = {}
    local all_bytes_read = 0

    local num_pairs = byte_buf:r_i32(file)

    local key
    local value
    local bytes_read

    for i = 1,num_pairs do
      key, bytes_read = self:read(byte_buf, file)
      all_bytes_read = all_bytes_read + bytes_read

      value, bytes_read = self:read(byte_buf, file)
      all_bytes_read = all_bytes_read + bytes_read

      result[key] = value
    end

    return result, all_bytes_read
  end

  function ic:read(byte_buf, file)
    local value
    local all_bytes_read = 0
    local bytes_read
    local type_code
    type_code, bytes_read = byte_buf:read(file, 1)
    all_bytes_read = all_bytes_read + bytes_read

    if type_code == "0" then
      return nil, all_bytes_read
    elseif type_code == "f" then
      value, bytes_read = byte_buf:r_u8string(file)
      return tonumber(value), all_bytes_read + bytes_read
    elseif type_code == "I" then
      value, bytes_read = byte_buf:r_i32(file)
      return value, all_bytes_read + bytes_read
    elseif type_code == "Q" then
      value, bytes_read = byte_buf:r_u32string(file)
      return value, all_bytes_read + bytes_read
    elseif type_code == "B" then
      value, bytes_read = byte_buf:r_u8bool(file)
      return value, all_bytes_read + bytes_read
    elseif type_code == "T" then
      value, bytes_read = self:do_read_table(byte_buf, file)
      return value, all_bytes_read + bytes_read
    else
      error("unexpected type_code `" .. type_code .. "`")
    end
  end
end

foundation.com.binary_types.MarshallValue = MarshallValue
foundation.com.binary_types.MarshallValue.V1 = MarshallValue
