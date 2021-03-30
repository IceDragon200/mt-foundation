local mod = foundation_ascii_pack

local NUM_TO_HEX = {
  [0] = "0",
  [1] = "1",
  [2] = "2",
  [3] = "3",
  [4] = "4",
  [5] = "5",
  [6] = "6",
  [7] = "7",
  [8] = "8",
  [9] = "9",
  [10] = "A",
  [11] = "B",
  [12] = "C",
  [13] = "D",
  [14] = "E",
  [15] = "F",
}

local HEX_TO_NUM = {}
for num,hex in pairs(NUM_TO_HEX) do
  HEX_TO_NUM[hex] = num
end
HEX_TO_NUM["a"] = HEX_TO_NUM["A"]
HEX_TO_NUM["b"] = HEX_TO_NUM["B"]
HEX_TO_NUM["c"] = HEX_TO_NUM["C"]
HEX_TO_NUM["d"] = HEX_TO_NUM["D"]
HEX_TO_NUM["e"] = HEX_TO_NUM["E"]
HEX_TO_NUM["f"] = HEX_TO_NUM["F"]

local function nibble_to_hex(byte)
  local nibble = byte % 16
  return NUM_TO_HEX[nibble]
end

local function hex_to_nibble(hex)
  return tonumber(hex, 16) -- good news we can cheat!
end

local function byte_to_hex(byte)
  local hi = math.floor(byte / 16)
  local lo = byte % 16

  return NUM_TO_HEX[hi] .. NUM_TO_HEX[lo]
end

local function hex_to_byte(hex2)
  return tonumber(hex2, 16)
end

local function vint_to_hex(length, int)
  local bytes = {}
  local r = int
  for i = 1,length do
    bytes[i] = r % 256
    r = math.floor(r / 256)
  end
  -- bytes are currently ordered in little-endian
  -- but for the ascii-pack it needs to be in big-endian
  local result = {}
  for i = 1,length do
    result[i] = byte_to_hex(bytes[1 + length - i])
  end
  return table.concat(result)
end

local function hex_to_vint(_length, value)
  return tonumber(value, 16)
end

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
  -- FIXME: proper encoding one day
  local blob = tostring(term)
  return "D"..mod.pack_int(#blob)..blob
end

function mod.pack_nint4(term)
  return "n"..nibble_to_hex(term)
end

function mod.pack_nint8(term)
  return "b"..byte_to_hex(term)
end

function mod.pack_nint16(term)
  return "s"..vint_to_hex(2, term)
end

function mod.pack_nint32(term)
  return "i"..vint_to_hex(4, term)
end

function mod.pack_nint64(term)
  return "l"..vint_to_hex(8, term)
end

function mod.pack_pint4(term)
  return "N"..nibble_to_hex(term)
end

function mod.pack_pint8(term)
  return "B"..byte_to_hex(term)
end

function mod.pack_pint16(term)
  return "S"..vint_to_hex(2, term)
end

function mod.pack_pint32(term)
  return "I"..vint_to_hex(4, term)
end

function mod.pack_pint64(term)
  return "L"..vint_to_hex(8, term)
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

  return "G"..mod.pack_int(len)..term
end

function mod.pack_array(term, depth)
  depth = depth or 0
  local len = #term

  local elements = {}
  for i, item in ipairs(term) do
    elements[i] = mod.pack(item, depth + 1)
  end
  return "A"..mod.pack_int(len)..table.concat(elements)
end

function mod.pack_map(term, depth)
  depth = depth or 0
  local elements = {}
  local i = 0
  for key, item in pairs(term) do
    i = i + 1
    elements[i] = mod.pack(key, depth + 1)..mod.pack(item, depth + 1)
  end

  return "M"..mod.pack_int(i)..table.concat(elements)
end

function mod.pack_boolean(term)
  if term then
    return "Y"
  else
    return "Z"
  end
end

function mod.pack_nil(_)
  return "0"
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

function mod.unpack_float(term)
  local ty = string.sub(term, 1, 1)

  if ty == "D" or ty == "F" then
    term = string.sub(term, 2)
    local size
    size, term = mod.unpack_int(term)
    local blob = string.sub(term, 1, size)
    term = string.sub(term, size + 1)
    return tonumber(blob), term
  else
    error("cannot unpack as float")
  end
end

function mod.unpack_int(term)
  local ty = string.sub(term, 1, 1)
  term = string.sub(term, 2)
  local neg = false
  local bs -- byte size
  local len

  if ty == "n" then
    neg = true
    bs = "half"
    len = 1
  elseif ty == "N" then
    neg = false
    bs = "half"
    len = 1
  elseif ty == "b" then
    neg = true
    bs = 1
    len = 2
  elseif ty == "B" then
    neg = false
    bs = 1
    len = 2
  elseif ty == "s" then
    neg = true
    bs = 2
    len = 4
  elseif ty == "S" then
    neg = false
    bs = 2
    len = 4
  elseif ty == "i" then
    neg = true
    bs = 4
    len = 8
  elseif ty == "I" then
    neg = false
    bs = 4
    len = 8
  elseif ty == "l" then
    neg = true
    bs = 8
    len = 16
  elseif ty == "L" then
    neg = false
    bs = 8
    len = 16
  else
    error("cannot unpack type=" .. ty .. " as int")
  end

  local blob = string.sub(term, 1, len)
  local value = hex_to_vint(bs, blob)
  term = string.sub(term, len + 1)

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

    return str, string.sub(term, len + 1)
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

    return array, term
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

    return map, term
  else
    error("cannot unpack map")
  end
end

function mod.unpack_boolean(term)
  local val = string.sub(term, 1, 1)

  if val == "Y" then
    return true, string.sub(term, 2)
  elseif val == "Z" then
    return false, string.sub(term, 2)
  else
    error("cannot unpack boolean")
  end
end

function mod.unpack_nil(term)
  local val = string.sub(term, 1, 1)
  if val == "0" then
    return nil, string.sub(term, 2)
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

foundation.com.ascii_pack = mod.pack
foundation.com.ascii_unpack = mod.unpack

function foundation.com.ascii_file_pack(stream, term, options, depth)
  local value = foundation.com.ascii_pack(term, options, depth)
  local success, err = stream:write(value)

  if success then
    return #value, nil
  else
    return 0, err
  end
end

function mod.ascii_file_unpack(stream)
  local bytes_read = 0
  local br

  local ty = stream:read(1)
  bytes_read = bytes_read + 1

  if ty == "Y" then
    return true, bytes_read
  elseif ty == "Z" then
    return false, bytes_read
  elseif ty == "0" then
    return nil, bytes_read
  elseif ty == "M" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    local map = {}
    assert(len >= 0, "expected positive map size")
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
    return map, bytes_read
  elseif ty == "A" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    local array = {}
    assert(len >= 0, "expected positive array size")
    if len > 0 then
      local elem
      for i = 1,len do
        elem, br = mod.ascii_file_unpack(stream)
        bytes_read = bytes_read + br
        array[i] = elem
      end
    end
    return array, bytes_read
  elseif ty == "G" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    assert(len >= 0, "expected positive string size")
    if len > 0 then
      local body, br = stream:read(len)
      bytes_read = bytes_read + len
      return body, bytes_read
    else
      return "", bytes_read
    end
  elseif ty == "n" then
    local num = tonumber(stream:read(1), 16)
    bytes_read = bytes_read + 1
    return -num, bytes_read
  elseif ty == "b" then
    local num = tonumber(stream:read(2), 16)
    bytes_read = bytes_read + 2
    return -num, bytes_read
  elseif ty == "s" then
    local num = tonumber(stream:read(4), 16)
    bytes_read = bytes_read + 4
    return -num, bytes_read
  elseif ty == "i" then
    local num = tonumber(stream:read(8), 16)
    bytes_read = bytes_read + 8
    return -num, bytes_read
  elseif ty == "l" then
    local num = tonumber(stream:read(16), 16)
    bytes_read = bytes_read + 16
    return -num, bytes_read
  elseif ty == "N" then
    local num = tonumber(stream:read(1), 16)
    bytes_read = bytes_read + 1
    return num, bytes_read
  elseif ty == "B" then
    local num = tonumber(stream:read(2), 16)
    bytes_read = bytes_read + 2
    return num, bytes_read
  elseif ty == "S" then
    local num = tonumber(stream:read(4), 16)
    bytes_read = bytes_read + 4
    return num, bytes_read
  elseif ty == "I" then
    local num = tonumber(stream:read(8), 16)
    bytes_read = bytes_read + 8
    return num, bytes_read
  elseif ty == "L" then
    local num = tonumber(stream:read(16), 16)
    bytes_read = bytes_read + 16
    return num, bytes_read
  elseif ty == "F" or ty == "D" then
    local len, br = mod.ascii_file_unpack(stream)
    bytes_read = bytes_read + br
    local body, br = stream:read(len)
    bytes_read = bytes_read + len
    return tonumber(body), bytes_read
  else
    error("cannot unpack type="..ty)
  end
end

function foundation.com.ascii_file_unpack(stream)
  return mod.ascii_file_unpack(stream)
end
