--- @namespace foundation.com.assertions
local m = assert(foundation.com.assertions)

--- @private.spec default_type_message(value: Any, expected_type: String): String
local function default_type_message(value, expected_type)
  return "expected a " .. expected_type .. " (got " .. type(value) .. " instead)"
end

--- Asserts that the given value is a string, if true the string is returned as is.
--- If the value is not a string, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assertions.is_string(value)
---
--- @spec is_string(value: Any, message: String): (value: String)
function m.is_string(value, message)
  if type(value) ~= "string" then
    error(message or default_type_message(value, "string"))
  end
  return value
end

--- Asserts that the given value is a boolean, if true the boolean is returned as is.
--- If the value is not a boolean, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assertions.is_boolean(value)
---
--- @spec is_boolean(value: Any, message: String): (value: Boolean)
function m.is_boolean(value, message)
  if type(value) ~= "boolean" then
    error(message or default_type_message(value, "boolean"))
  end
  return value
end

--- Asserts that the given value is a number, if true the number is returned as is.
--- If the value is not a number, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assertions.is_number(value)
---
--- @spec is_number(value: Any, message: String): (value: Number)
function m.is_number(value, message)
  if type(value) ~= "number" then
    error(message or default_type_message(value, "number"))
  end
  return value
end

--- Asserts that the given value is a table, if true the table is returned as is.
--- If the value is not a table, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assertions.is_table(value)
---
--- @spec is_table(value: Any, message: String): (value: Table)
function m.is_table(value, message)
  if type(value) ~= "table"  then
    error(message or default_type_message(value, "table"))
  end
  return value
end

--- Asserts that the given value is a table, that it's either empty or has a pair keyed by `1`.
--- If the value is not a table, or does not have a key `1`, an assertion error is raised instead.
---
--- As scanning the entire table to ensure it only contains contigous integers, this assertion
--- does not guarantee that the value is truly an array-like table.
---
--- Usage:
---
---    foundation.com.assertions.is_array(value)
---
--- @spec is_array(value: Any, message: String): (value: Table)
function m.is_array(value, message)
  assert(type(value) == "table", message or "expected a table (array)")
  if not next(value) then
    --- if the table is empty, it can double as an empty array
    return value
  end
  -- we're just checking if there is an element 1, which is good enough generally
  assert(value[1] ~= nil, message or "expected at least the first element of array")
  return value
end

--- Asserts that the given value is a function, if true the function is returned as is.
--- If the value is not a table, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assertions.is_function(value)
---
--- @since "1.1.0"
--- @spec is_function(value: Any, message: String): (value: Function)
function m.is_function(value, message)
  if type(value) ~= "function" then
    error(message or default_type_message(value, "function"))
  end
  return value
end
