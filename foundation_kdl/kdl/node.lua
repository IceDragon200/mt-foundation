-- @namespace foundation.com.KDL
local List = foundation.com.List

-- @class Node
local Node = foundation.com.Class:extends("foundation.com.KDL.Node")
local ic = Node.instance_class

-- @spec #initialize(name: String, options: Table): void
function ic:initialize(name, options)
  self.name = name
  -- contains both arguments and properties
  self.attributes = options.attributes or List:new()
  self.children = options.children
  self.annotations = options.annotations or {}
end

-- @spec #to_table(): Table
function ic:to_table()
  local children
  if self.children then
    children = self.children:map(function (node)
      return node:to_table()
    end):data()
  end

  return {
    name = self.name,
    attributes = self.attributes:map(function (arg_or_prop)
      return arg_or_prop:to_table()
    end):data(),
    children = children,
    annotations = self.annotations,
  }
end

-- @class Node.Argument
Node.Argument = foundation.com.Class:extends("foundation.com.KDL.Node.Argument")
ic = Node.Argument.instance_class

-- @spec #initialize(options: Table): void
function ic:initialize(options)
  self.type = options.type
  self.annotations = options.annotations or {}
  self.value = options.value
  self.format = options.format or 'plain'
end

-- @spec #to_table(): Table
function ic:to_table()
  return {
    type = self.type,
    annotations = self.annotations,
    value = self.value,
    format = self.format,
  }
end

-- @class Node.Property
Node.Property = foundation.com.Class:extends("foundation.com.KDL.Node.Property")
ic = Node.Property.instance_class

-- @spec #initialize(key: Node.Argument, value: Node.Argument): void
function ic:initialize(key, value)
  self.key = key
  self.value = value
end

-- @spec #to_table(): Table
function ic:to_table()
  return {
    key = self.key:to_table(),
    value = self.value:to_table(),
  }
end

foundation_kdl.KDL.Node = Node
