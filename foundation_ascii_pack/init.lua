local mod = foundation.new_module("foundation_ascii_pack", "1.0.0")

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
-- f float32
-- F float64
--
-- A array
--
-- M map
--
-- S string
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
  return "n"..term
end

function mod.pack_nint8(term)
  return "b"..term
end

function mod.pack_nint16(term)
  return "s"..term
end

function mod.pack_nint32(term)
  return "i"..term
end

function mod.pack_nint64(term)
  return "l"..term
end

function mod.pack_pint4(term)
  return "N"..term
end

function mod.pack_pint8(term)
  return "B"..term
end

function mod.pack_pint16(term)
  return "S"..term
end

function mod.pack_pint32(term)
  return "I"..term
end

function mod.pack_pint64(term)
  return "L"..term
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

  return "S"..mod.pack_int(len)..term
end

function mod.pack_array(term, depth)
  depth = depth or 0
  local len = #term

  local elements = {}
  for i, item in ipairs(term) do
    elements[i] = mod.pack(term, depth + 1)
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

  return "M"..pack_int(i)..table.concat(elements)
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

function mod.pack(term, depth)
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

function foundation.com.ascii_pack(term, options, depth)
  return mod.pack(term, depth)
end

function foundation.com.ascii_unpack()
end
