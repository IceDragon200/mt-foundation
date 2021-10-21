local Class = {
  _super = nil,
  _is_class = true,
  _name = "Class",
  __mt = {},
  __imt = {},
  VERSION = foundation_class.VERSION,
  instance_class = {
    _is_instance_class = true,
  }
}

Class.instance_class._class = Class
Class.__imt.__index = Class.instance_class

-- @spec #initialize(...): void
function Class.instance_class:initialize()
  --
end

-- @spec #method(name): Function
function Class.instance_class:method(name)
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

-- Determines if the object is an instance of the given class
--
-- @spec #is_instance_of(expected_class: Class): Boolean
function Class.instance_class:is_instance_of(expected_class)
  return self._class:is_child_of(expected_class)
end

-- Determines if this class inherits from ancestor, or is the same class.
-- Returns true if the class is inherits from ancestor, or is the same class.
-- Returns false otherwise.
--
-- @spec &is_child_of(ancestor: Class): Boolean
function Class:is_child_of(ancestor)
  local klass = self
  while klass do
    if klass == ancestor then
      return true
    end
    klass = klass._super
  end
  return false
end

function Class:ancestors()
  local klass = self
  local result = {}
  while klass do
    table.insert(result, klass)
    klass = klass._super
  end
  return result
end

-- @spec &extends(String): Class
function Class.extends(super_class, name)
  local klass = {
    _super = super_class,
    __mt = {},
    __imt = {},
    name = name,
    instance_class = {},
  }

  klass.instance_class._super = super_class.instance_class
  klass.instance_class._class = klass

  klass.__mt.__index = super_class
  klass.__imt.__index = klass.instance_class

  setmetatable(klass, klass.__mt)
  setmetatable(klass.instance_class, super_class.__imt)

  return klass
end

-- @spec &alloc(): Any
function Class:alloc()
  local instance = {}
  setmetatable(instance, self.__imt)
  return instance
end

-- @spec &new(): Any
function Class:new(...)
  local instance = self:alloc()
  if instance.initialize then
    instance:initialize(...)
  end
  return instance
end

-- Determines if the given object is some kind of instance class object.
-- Optionally the class can be specified as well to perform an is_instance_of/1
-- check as well.
--
-- @spec is_object(Any, klass?: Class): Boolean
function Class.is_object(object, klass)
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

foundation.com.Class = Class
