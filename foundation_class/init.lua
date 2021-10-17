--
-- A minimal object class system.
--
-- Please don't abuse classes, use them sparingly.
--
local mod = foundation.new_module("foundation_class", "1.0.0")

local Class = {
  VERSION = mod.VERSION,
  instance_class = {}
}

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

-- @spec &extends(String): Class
function Class:extends(name)
  local klass = {
    _super = self,
    name = name,
    instance_class = {},
  }
  klass.instance_class._super = klass._super.instance_class
  klass.instance_class._class = klass
  setmetatable(klass, { __index = self })
  setmetatable(klass.instance_class, { __index = self.instance_class })
  return klass
end

-- @spec &alloc(): Any
function Class:alloc()
  local instance = {}
  setmetatable(instance, { __index = self.instance_class })
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

foundation.com.Class = Class
