--- @namespace foundation.com.assert
local m = assert(foundation.com.assert)

--- Asserts that the given value is a string, if true the string is returned as is.
--- If the value is not a string, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assert.is_string(value)
---
--- @spec is_string(value: Any, message: String): (value: String)
function m.is_string(value, message)
  assert(type(value) == "string", message)
  return value
end

--- Asserts that the given value is a boolean, if true the boolean is returned as is.
--- If the value is not a boolean, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assert.is_boolean(value)
---
--- @spec is_boolean(value: Any, message: String): (value: Boolean)
function m.is_boolean(value, message)
  assert(type(value) == "boolean", message)
  return value
end

--- Asserts that the given value is a number, if true the number is returned as is.
--- If the value is not a number, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assert.is_number(value)
---
--- @spec is_number(value: Any, message: String): (value: Number)
function m.is_number(value, message)
  assert(type(value) == "number", message)
  return value
end

--- Asserts that the given value is a table, if true the table is returned as is.
--- If the value is not a table, an assertion error is raised instead.
---
--- Usage:
---
---    foundation.com.assert.is_table(value)
---
--- @spec is_table(value: Any, message: String): (value: Table)
function m.is_table(value, message)
  assert(type(value) == "table", message)
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
---    foundation.com.assert.is_array(value)
---
--- @spec is_array(value: Any, message: String): (value: Table)
function m.is_array(value, message)
  assert(type(value) == "table", message)
  if not next(value) then
    --- if the table is empty, it can double as an empty array
    return value
  end
  -- we're just checking if there is an element 1, which is good enough generally
  assert(value[1] ~= nil, message)
  return value
end
