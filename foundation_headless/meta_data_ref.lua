--- @namespace foundation.com.headless

local table_equals = assert(foundation.com.table_equals)
local Class = assert(foundation.com.Class)

--[[

* `contains(key)`: Returns true if key present, otherwise false.
    * Returns `nil` when the MetaData is inexistent.
* `get(key)`: Returns `nil` if key not present, else the stored string.
* `set_string(key, value)`: Value of `""` will delete the key.
* `get_string(key)`: Returns `""` if key not present.
* `set_int(key, value)`
* `get_int(key)`: Returns `0` if key not present.
* `set_float(key, value)`
* `get_float(key)`: Returns `0` if key not present.
* `to_table()`: returns `nil` or a table with keys:
    * `fields`: key-value storage
    * `inventory`: `{list1 = {}, ...}}` (NodeMetaDataRef only)
* `from_table(nil or {})`
    * Any non-table value will clear the metadata
    * See [Node Metadata] for an example
    * returns `true` on success
* `equals(other)`
    * returns `true` if this metadata has the same key-value pairs as `other`

]]

--- @class MetaDataRef
local MetaDataRef = Class:extends("MetaDataRef")
do
  local ic = MetaDataRef.instance_class

  --- @spec #initialize(data: Table): void
  function ic:initialize(data)
    ic._super.initialize(self)
    self.m_data = data or {}

    assert(type(self.m_data) == "table", "expected data to be a table")
  end

  --- @spec #__copy()
  function ic:__copy()
    local other = MetaDataRef:new()

    for key, value in pairs(self.m_data) do
      other.m_data[key] = value
    end

    if self.m_inventory then
      other.m_inventory = self.m_inventory:__copy()
    end

    return other
  end

  --- @spec #contains(key: String): Boolean
  function ic:contains(key)
    return self.m_data[key] ~= nil
  end

  --- @spec #get(key: String): Any
  function ic:get(key)
    return self.m_data[key]
  end

  --- @spec #set_string(key: String, value: String): self
  function ic:set_string(key, value)
    value = tostring(value)
    if value == "" then
      self.m_data[key] = nil
    else
      self.m_data[key] = value
    end
    return self
  end

  --- @spec #get_string(key: String): String
  function ic:get_string(key)
    local d = self.m_data[key]
    if d ~= nil then
      return tostring(d)
    else
      return ""
    end
  end

  --- @spec #set_int(key: String, value: Integer): self
  function ic:set_int(key, value)
    self.m_data[key] = math.floor(tonumber(value))
    return self
  end

  --- @spec #get_int(key: String): Integer
  function ic:get_int(key)
    return math.floor(tonumber(self.m_data[key] or 0))
  end

  --- @spec #set_float(key: String, value: Float): self
  function ic:set_float(key, value)
    self.m_data[key] = tonumber(value) * 1.0
    return self
  end

  --- @spec #get_float(String): Float
  function ic:get_float(key)
    return tonumber(self.m_data[key] or 0.0) * 1.0
  end

  --- @spec #to_table(): Table
  function ic:to_table()
    local result = {
      fields = {},
      inventory = {},
    }

    for key, value in pairs(self.m_data) do
      result.fields[key] = value
    end

    if self.m_inventory then
      for name, inv in pairs(self.m_inventory) do
        result.inventory[name] = {}
      end
    end

    return result
  end

  --- @spec #from_table(Table): Boolean
  function ic:from_table(value)
    if type(value) == "table" then
      local result = {}
      local ty
      if value.fields then
        for key, val in pairs(value.fields) do
          ty = type(val)

          if ty == "string" or ty == "number" or ty == "boolean" then
            result[key] = val
          else
            return false
          end
        end
        self.m_data = result
      end
      return true
    end
    self.m_data = {}
    self.m_inventory = nil
    return false
  end

  --- @spec #equals(MetaDataRef, MetaDataRef): Boolean
  function ic:equals(other)
    if Class.is_object(other, MetaDataRef) then
      return table_equals(self.m_data, other.m_data)
    elseif other.to_table then
      other = other:to_table()
      return table_equals(self.m_data, other.fields)
    end
    return false
  end

  --- @spec #get_inventory(): InvRef
  function ic:get_inventory()
    if not self.m_inventory then
      self.m_inventory = foundation.com.headless.InvRef:new()
    end
    return self.m_inventory
  end
end

foundation.com.headless.MetaDataRef = MetaDataRef
