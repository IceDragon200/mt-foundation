--- @namespace foundation.com
local string_format = assert(string.format)
local table_concat = assert(table.concat)
local setmetatable = setmetatable

local inherited_metamethods = {
  "__tostring",
  -- Math
  "__add",
  "__sub",
  "__mul",
  "__div",
  "__unm",
  "__mod",
  "__pow",
  "__idiv", -- 5.3
  -- Logical Operators
  "__eq",
  "__lt",
  "__gt",
  -- Misc
  "__concat",
  "__len",
  -- Invocation
  "__call",
}

--- @class Object
local Object = {
  _super = nil,
  _is_class = true,
  _name = "Object",
  __mt = {},
  __imt = {},
  VERSION = foundation_class.VERSION,
  instance_class = {
    _is_instance_class = true,
  }
}

setmetatable(Object, Object.__mt)

Object.instance_class._class = Object
Object.__imt.__index = Object.instance_class

local function inspect_write(self, x)
  self.i = self.i + 1
  self.data[self.i] = x
end

---
--- @since "2026.5.9"
--- @spec inspect(root: Any, ctx: Any, is_raw: Boolean): String
local function inspect(root, ctx, is_raw)
  if not ctx then
    ctx = {
      ref_id = 0,
      refs = {},
    }
  end

  local buf = {
    i = 0,
    data = {},
    write = inspect_write,
  }

  local function maybe_ref_write(value)
    local ref_id = ctx.refs[value]
    if ref_id == nil then
      ctx.ref_id = ctx.ref_id + 1
      ctx.refs[value] = ctx.ref_id
      buf:write("<&")
      buf:write(ctx.ref_id)
      buf:write(">")
      buf:write(inspect(value, ctx))
    else
      buf:write("*")
      buf:write(ref_id)
    end
  end

  local ty = type(root)
  if "userdata" == ty then
    return string_format("<$%q>", root)
  elseif "table" == ty  then
    if not is_raw and type(root.inspect) == "function" then
      return root:inspect(ctx)
    end

    local idx = 0
    buf:write("{")
    for key, value in pairs(root) do
      if idx > 0 then
        buf:write(",")
      end
      idx = idx + 1
      if type(key) == "table" then
        maybe_ref_write(key)
      else
        buf:write(inspect(key, ctx))
      end
      buf:write("=")
      if type(value) == "table" then
        maybe_ref_write(value)
      else
        buf:write(inspect(value, ctx))
      end
    end
    buf:write("}")
    return table_concat(buf.data, "")
  elseif ty == "function" then
    return string_format("%s", root)
  elseif ty == "number" then
    local is_int = (root - math.floor(root)) == 0
    if is_int and root >= -4503599627370496 and root <= 4503599627370495 then
      return string_format("%d", root)
    else
      return string_format("%f", root)
    end
  elseif ty == "string" then
    return string_format("%q", root)
  else
    return tostring(root)
  end
end

Object.inspect = inspect

local default_inspect
local default_class_to_string
local default_instance_to_string

local has_string_format_p = pcall(function ()
  string.format("%p", {})
  return true
end)

if has_string_format_p then
  --- @since "2026.5.9"
  function default_inspect(self, ctx)
    return string_format("#<%s:%p %s>", self._class._name, self, inspect(self, ctx, true))
  end

  --- @since "2026.5.9"
  function default_class_to_string(self)
    return string_format("Class<%s:%p>", self._name, self)
  end

  --- @since "2026.5.9"
  function default_instance_to_string(self)
    return string_format("#<%s:%p>", self._class._name, self)
  end
else
  --- @since "2026.5.9"
  function default_inspect(self, ctx)
    return string_format("#<%s:X %s>", self._class._name, inspect(self, ctx, true))
  end

  --- @since "2026.5.9"
  function default_class_to_string(self)
    return string_format("Class<%s:X>", self._name)
  end

  --- @since "2026.5.9"
  function default_instance_to_string(self)
    return string_format("#<%s:X>", self._class._name)
  end
end

local rawmatches

--- @since "2026.5.9"
--- @private:spec matches(lhv: Any, pattern: Any): Boolean
local function matches(lhv, pattern)
  if rawequal(lhv, pattern) then
    return true
  end
  if type(lhv) == "table" then
    if type(lhv.matches) == "function" then
      return lhv:matches(pattern)
    elseif lhv.matches == false then
      -- always return false
      return false
    end

    return rawmatches(lhv, pattern)
  end
  return false
end

--- @since "2026.5.9"
--- @private:spec rawmatches(lhv: Any, pattern: Any): Boolean
local function rawmatches(lhv, pattern)
  if type(pattern) == "table" then
    for key, rhp in pairs(pattern) do
      if not matches(lhv[key], rhp) then
        return false
      end
    end
    return true
  end
  return false
end

Object.matches = matches
Object.rawmatches = rawmatches

do
  --- @since "2026.5.9"
  --- @spec &%__tostring(): String
  Object.__mt.__tostring = default_class_to_string

  --- @since "2026.5.9"
  --- @spec %__tostring(): String
  function Object.__imt:__tostring()
    if type(self.__tostring) == "function" then
      return self:__tostring()
    elseif type(self.to_string) == "function" then
      return self:to_string()
    end
    return default_instance_to_string(self)
  end

  --- @since "2026.5.9"
  --- @spec %__eq(): Boolean
  function Object.__imt:__eq(other)
    if type(self.equals) == "function" then
      return self:equals(other)
    end
    return false
  end
end

do
  local ic = Object.instance_class

  --- @overridable
  --- @spec #initialize(...): void
  function ic:initialize()
    --
  end

  --- Called when an object is to be copied, the `other` will be the original object that is being
  --- copied.
  ---
  --- @overridable
  --- @spec #initialize_copy(other: self): void
  function ic:initialize_copy(other)
    for key, value in pairs(other) do
      rawset(self, key, value)
    end
  end

  --- Creates a copy of the object.
  ---
  --- @spec #copy(): self
  function ic:copy()
    local other = self._class:alloc()
    other:initialize_copy(self)
    return other
  end

  --- Compares two objects and attempts a simple equality test.
  --- This is just a least effort equality check and can be incorrect.
  --- When in doubt, override this function yourself.
  --- @overridable
  --- @spec #equals(other): Boolean
  function ic:equals(other)
    if rawequal(self, other) then
      return true
    end
    if Object.is_object(other, self._class) then
      for key, value in pairs(other) do
        if self[key] ~= value then
          return false
        end
      end
      return true
    end
    return false
  end

  --- Compares two objects and attempts a simple equality test.
  --- This is just a least effort equality check and can be incorrect.
  --- When in doubt, override this function yourself.
  --- @overridable
  --- @spec #matches(pattern): Boolean
  ic.matches = rawmatches

  --- Helper function for returning the object as a string
  --- Reports the class name by default, can be overriden
  --- @since "2026.5.9"
  --- @spec #to_string(): String
  ic.to_string = default_instance_to_string

  --- @spec #inspect(): String
  ic.inspect = default_inspect

  --- Invokes callback and passes self as the first argument
  ---
  --- @spec tap(callback :: (self) => void, ...args) :: self
  function ic:tap(callback, ...)
    callback(self, ...)
    return self
  end

  --- @spec #method(name): Function
  function ic:method(name)
    local func = self[name]
    if type(func) == "function" then
      local target = self
      return function (...)
        return func(target, ...)
      end
    else
      error("expected a function named `" .. name .. "` (got a `" .. type(func) .. "` instead)")
    end
  end

  --- Determines if the object is an instance of the given class
  ---
  --- @spec #is_instance_of(expected_class: Object): Boolean
  function ic:is_instance_of(expected_class)
    return self._class:is_child_of(expected_class)
  end
end

--- Determines if this class inherits from ancestor, or is the same class.
--- Returns true if the class is inherits from ancestor, or is the same class.
--- Returns false otherwise.
---
--- @spec &is_child_of(ancestor: Object): Boolean
function Object:is_child_of(ancestor)
  local klass = self
  while klass do
    if klass == ancestor then
      return true
    end
    klass = klass._super
  end
  return false
end

--- @spec &ancestors(): Object[]
function Object:ancestors()
  local klass = self
  local result = {}
  local i = 0
  while klass do
    i = i + 1
    result[i] = klass
    klass = klass._super
  end
  return result
end

--- @spec &extends(String): Object
function Object.extends(super_class, name)
  local klass = {
    _name = name,
    _super = super_class,
    __mt = {},
    __imt = {},
    instance_class = {},
  }

  klass.instance_class._super = super_class.instance_class
  klass.instance_class._class = klass

  for _, mm in ipairs(inherited_metamethods) do
    rawset(klass.__mt, mm, rawget(super_class.__mt, mm))
  end
  klass.__mt.__index = super_class

  for _, mm in ipairs(inherited_metamethods) do
    rawset(klass.__imt, mm, rawget(super_class.__imt, mm))
  end
  klass.__imt.__index = klass.instance_class

  setmetatable(klass, klass.__mt)
  setmetatable(klass.instance_class, super_class.__imt)

  return klass
end

--- @spec &bind_metatable(instance: Table): Any
function Object:bind_metatable(instance)
  setmetatable(instance, self.__imt)
  return instance
end

--- @spec &alloc(): Any
function Object:alloc()
  local instance = {}
  setmetatable(instance, self.__imt)
  return instance
end

-- @spec &new(): Any
function Object:new(...)
  local instance = self:alloc()
  if instance.initialize then
    instance:initialize(...)
  end
  return instance
end

--- @spec &tap(): Any
function Object:tap(callback)
  callback(self)
  return self
end

-- Determines if the given object is some kind of instance class object.
-- Optionally the class can be specified as well to perform an is_instance_of/1
-- check as well.
--
-- @spec is_object(Any, klass?: Object): Boolean
function Object.is_object(object, klass)
  if type(object) == "table" then
    if object._class then
      if klass then
        return object:is_instance_of(klass)
      end
      return true
    end
  end

  return false
end

foundation.com.Object = Object

--- @alias Class = Object
foundation.com.Class = Object
