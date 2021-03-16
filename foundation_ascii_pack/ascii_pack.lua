local mod = foundation_ascii_pack

--
-- Negative Integers
-- n nint4
-- b nint8
-- s nint16
-- i nint32
-- l nint64
--
-- Positive Integers
-- N pint4
-- B pint8
-- S pint16
-- I pint32
-- L pint64
--
-- F float32
-- D float64
--
-- A array
--
-- M map
--
-- G string
--
-- 0 nil
--
-- Y true
-- Z false
--
function mod.pack_float(term)
  error("TODO: pack_float")
end

function mod.pack_nint4(term)
  return "n"..term.."#"
end

function mod.pack_nint8(term)
  return "b"..term.."#"
end

function mod.pack_nint16(term)
  return "s"..term.."#"
end

function mod.pack_nint32(term)
  return "i"..term.."#"
end

function mod.pack_nint64(term)
  return "l"..term.."#"
end

function mod.pack_pint4(term)
  return "N"..term.."#"
end

function mod.pack_pint8(term)
  return "B"..term.."#"
end

function mod.pack_pint16(term)
  return "S"..term.."#"
end

function mod.pack_pint32(term)
  return "I"..term.."#"
end

function mod.pack_pint64(term)
  return "L"..term.."#"
end

function mod.pack_int4(term)
  if term >= 0 then
    return mod.pack_pint4(term)
  else
    return mod.pack_nint4(-term)
  end
end

function mod.pack_int8(term)
  if term >= 0 then
    return mod.pack_pint8(term)
  else
    return mod.pack_nint8(-term)
  end
end

function mod.pack_int16(term)
  if term >= 0 then
    return mod.pack_pint16(term)
  else
    return mod.pack_nint16(-term)
  end
end

function mod.pack_int32(term)
  if term >= 0 then
    return mod.pack_pint32(term)
  else
    return mod.pack_nint32(-term)
  end
end

function mod.pack_int64(term)
  if term >= 0 then
    return mod.pack_pint64(term)
  else
    return mod.pack_nint64(-term)
  end
end

function mod.pack_int(term)
  if term >= 0 then
    if term > 0xFFFFFFFF then
      return mod.pack_int64(term)
    elseif term > 0xFFFF then
      return mod.pack_int32(term)
    elseif term > 0xFF then
      return mod.pack_int16(term)
    elseif term > 0xF then
      return mod.pack_int8(term)
    else
      return mod.pack_int4(term)
    end
  else
    if term < -0xFFFFFFFF then
      return mod.pack_int64(term)
    elseif term < -0xFFFF then
      return mod.pack_int32(term)
    elseif term < -0xFF then
      return mod.pack_int16(term)
    elseif term < -0xF then
      return mod.pack_int8(term)
    else
      return mod.pack_int4(term)
    end
  end
end

function mod.pack_string(term)
  local len = #term

  return "G"..mod.pack_int(len)..term.."#"
end

function mod.pack_array(term, depth)
  depth = depth or 0
  local len = #term

  local elements = {}
  for i, item in ipairs(term) do
    elements[i] = mod.pack(item, depth + 1)
  end
  return "A"..mod.pack_int(len)..table.concat(elements).."#"
end

function mod.pack_map(term, depth)
  depth = depth or 0
  local elements = {}
  local i = 0
  for key, item in pairs(term) do
    i = i + 1
    elements[i] = mod.pack(key, depth + 1)..mod.pack(item, depth + 1)
  end

  return "M"..mod.pack_int(i)..table.concat(elements).."#"
end

function mod.pack_boolean(term)
  if term then
    return "Y#"
  else
    return "Z#"
  end
end

function mod.pack_nil(_)
  return "0#"
end

function mod.pack(term, options, depth)
  depth = depth or 0
  options = options or {}
  local ty = type(term)

  if ty == "number" then
    if math.floor(term) == term then
      return mod.pack_int(term)
    else
      return mod.pack_float(term)
    end
  elseif ty == "string" then
    return mod.pack_string(term)
  elseif ty == "table" then
    local len = 0
    for _key, _item in pairs(term) do
      len = len + 1
    end
    if #term == len then
      return mod.pack_array(term, depth + 1)
    else
      return mod.pack_map(term, depth + 1)
    end
  elseif ty == "boolean" then
    return mod.pack_boolean(term)
  elseif ty == "nil" then
    return mod.pack_nil(term)
  else
    error("cannot pack type="..ty)
  end
end

function mod.extract_value(term)
  -- skip the type code
  term = string.sub(term, 2)
  local s = string.find(term, "#")

  if s then
    local blob = string.sub(term, 1, s-1)
    term = string.sub(term, s+1)
    return blob, term
  else
    error("cannot extract value")
  end
end

function mod.unpack_int(term)
  local ty = string.sub(term, 1, 1)
  local neg = false

  if ty == "n" then
    neg = true
  elseif ty == "N" then
    neg = false
  elseif ty == "b" then
    neg = true
  elseif ty == "B" then
    neg = false
  elseif ty == "s" then
    neg = true
  elseif ty == "S" then
    neg = false
  elseif ty == "i" then
    neg = true
  elseif ty == "I" then
    neg = false
  elseif ty == "l" then
    neg = true
  elseif ty == "L" then
    neg = false
  else
    error("cannot unpack int")
  end

  local value, term = mod.extract_value(term)

  value = tonumber(value)

  if neg then
    return -value, term
  else
    return value, term
  end
end

function mod.unpack_string(term)
  local ty = string.sub(term, 1, 1)

  if ty == "G" then
    term = string.sub(term, 2)
    local len, term = mod.unpack_int(term)

    local str = string.sub(term, 1, len)

    local tail = string.sub(term, len + 1, len + 1)
    assert(tail == "#", "expected string to end with #")
    term = string.sub(term, len + 2)

    return str, term
  else
    error("cannot unpack string expected type=G got " .. ty)
  end
end

function mod.unpack_array(term)
  local ty = string.sub(term, 1, 1)

  if ty == "A" then
    term = string.sub(term, 2)
    local len, term = mod.unpack_int(term)

    local array = {}

    if len > 0 then
      for i = 1,len do
        local elem
        elem, term = mod.unpack(term)
        array[i] = elem
      end
    end

    local tail = string.sub(term, 1, 1)
    assert(tail == "#", "expected array to end with #")

    return array, string.sub(term, 2)
  else
    error("cannot unpack array")
  end
end

function mod.unpack_map(term)
  local ty = string.sub(term, 1, 1)

  if ty == "M" then
    term = string.sub(term, 2)
    local len, term = mod.unpack_int(term)

    local map = {}

    if len > 0 then
      local key, value
      for i = 1,len do
        key, term = mod.unpack(term)
        value, term = mod.unpack(term)
        map[key] = value
      end
    end

    local tail = string.sub(term, 1, 1)
    assert(tail == "#", "expected map to end with #")

    return map, string.sub(term, 2)
  else
    error("cannot unpack map")
  end
end

function mod.unpack_boolean(term)
  local val = string.sub(term, 1, 2)

  if val == "Y#" then
    return true, string.sub(term, 3)
  elseif val == "Z#" then
    return false, string.sub(term, 3)
  else
    error("cannot unpack boolean")
  end
end

function mod.unpack_nil(term)
  local val = string.sub(term, 1, 2)
  if val == "0#" then
    return nil, string.sub(term, 3)
  else
    error("cannot unpack nil")
  end
end

function mod.unpack(term)
  local ty = string.sub(term, 1, 1)

  if ty == "Y" or ty == "Z" then
    return mod.unpack_boolean(term)
  elseif ty == "0" then
    return mod.unpack_nil(term)
  elseif ty == "M" then
    return mod.unpack_map(term)
  elseif ty == "A" then
    return mod.unpack_array(term)
  elseif ty == "G" then
    return mod.unpack_string(term)
  elseif ty == "n" or ty == "b" or ty == "s" or ty == "i" or ty == "l" or
         ty == "N" or ty == "B" or ty == "S" or ty == "I" or ty == "L" then
    return mod.unpack_int(term)
  elseif ty == "F" or ty == "D" then
    return mod.unpack_float(term)
  else
    error("cannot unpack type="..ty)
  end
end

function foundation.com.ascii_pack(term, options, depth)
  return mod.pack(term, options, depth)
end

function foundation.com.ascii_unpack(term)
  return mod.unpack(term)
end

function foundation.com.ascii_file_pack(stream, term, options, depth)
  local value = foundation.com.ascii_pack(term, options, depth)
  local success, err = stream:write(value)

  if success then
    return #value, nil
  else
    return 0, err
  end
end

local function read_number_from_file(stream)
  local acc = {}
  local i = 0
  local b
  local br = 0

  while true do
    b = stream:read(1)
    br = br + 1

    if b == "" then
      error("stream finished, but end marker not found")
    elseif b == "#" then
      break
    elseif b then
      i = i + 1
      acc[i] = b
    else
      error("nothing read")
    end
  end

  return tonumber(table.concat(acc)), br
end

function mod.ascii_file_unpack(stream)
  local bytes_read = 0
  local br

  local ty, br = stream:read(1)
  bytes_read = bytes_read + 1

  if ty == "Y" then
    assert("#" == stream:read(1))
    bytes_read = bytes_read + 1
    return true, bytes_read
  elseif ty == "Z" then
    assert("#" == stream:read(1))
    bytes_read = bytes_read + 1
    return false, bytes_read
  elseif ty == "0" then
    assert("#" == stream:read(1))
    bytes_read = bytes_read + 1
    return nil, bytes_read
  elseif ty == "M" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    local map = {}
    if len > 0 then
      local key, value
      for _ = 1,len do
        key, br = mod.ascii_file_unpack(stream)
        bytes_read = bytes_read + br
        value, br = mod.ascii_file_unpack(stream)
        bytes_read = bytes_read + br
        map[key] = value
      end
    end
    assert("#" == stream:read(1))
    bytes_read = bytes_read + 1
    return map, bytes_read
  elseif ty == "A" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    local array = {}
    if len > 0 then
      local elem
      for i = 1,len do
        elem, br = mod.ascii_file_unpack(stream)
        bytes_read = bytes_read + br
        array[i] = elem
      end
    end
    assert("#" == stream:read(1))
    bytes_read = bytes_read + 1
    return array, bytes_read
  elseif ty == "G" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    local body, br = stream:read(len)
    bytes_read = bytes_read + len
    assert("#" == stream:read(1))
    bytes_read = bytes_read + 1
    return body, bytes_read
  elseif ty == "n" or ty == "b" or ty == "s" or ty == "i" or ty == "l" then
    local num, br = read_number_from_file(stream)
    bytes_read = bytes_read + br
    return -num, bytes_read
  elseif ty == "N" or ty == "B" or ty == "S" or ty == "I" or ty == "L" then
    local num, br = read_number_from_file(stream)
    bytes_read = bytes_read + br
    return num, bytes_read
  elseif ty == "F" or ty == "D" then
    local num, br = read_number_from_file(stream)
    bytes_read = bytes_read + br
    return num, bytes_read
  else
    error("cannot unpack type="..ty)
  end
end

function foundation.com.ascii_file_unpack(stream)
  return mod.ascii_file_unpack(stream)
end
