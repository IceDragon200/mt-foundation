local function table_merge(...)
  local result = {}
  for _,t in ipairs({...}) do
    for key,value in pairs(t) do
      result[key] = value
    end
  end
  return result
end

local function table_keys(t)
  local keys = {}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

local TOML = {}

local function format_prefix(prefix)
  local result = {}
  for _, value in ipairs(prefix) do
    if string.match(value, "^[%w_]+$") then
      table.insert(result, value)
    else
      table.insert(result, "\"" .. string.gsub(value, "\n", "\\n") .. "\"")
    end
  end
  return table.concat(result, ".")
end

function TOML.encode_iodata(object, prefix, result)
  result = result or {}

  local other_objects = {}
  -- in order to have some assertable data, keys are sorted
  local keys = table_keys(object)
  table.sort(keys)
  for _, key in ipairs(keys) do
    local value = object[key]
    local t = type(value)
    if t == "table" then
      other_objects[key] = value
    elseif t == "string" then
      table.insert(result, key .. " = \"" .. string.gsub(value, "\n", "\\n") .. "\"")
    elseif t == "number" then
      table.insert(result, key .. " = " .. value)
    elseif t == "boolean" then
      if value then
        table.insert(result, key .. " = true")
      else
        table.insert(result, key .. " = false")
      end
    else
      error("unexpected type " .. t)
    end
  end

  for key, value in pairs(other_objects) do
    if not prefix then
      prefix = {}
    end

    local current_prefix = table_merge(prefix)
    table.insert(current_prefix, key)
    table.insert(result, "[" .. format_prefix(current_prefix) .. "]")
    TOML.encode_iodata(value, current_prefix, result)
  end
  if result[#result] ~= "" then
    table.insert(result, "")
  end

  return result
end

function TOML.encode(object)
  return table.concat(TOML.encode_iodata(object), "\n")
end

function TOML.write(stream, object)
  local body = TOML.encode(object)

  stream:write(body)
end

foundation.com.TOML = TOML
