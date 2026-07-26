# Foundation Class/Object

A versatile object system styled around ruby.

## Usage

```lua
--- Traditionally, foundation provided Class, but Object is also an alias
local MyClass = foundation.com.Class:extends("MyClass")
do
  --- Class separates its instance from its class object
  --- Whenever you call MyClass:new, you receive an object whose metatable uses
  --- the instance_class.
  local ic = MyClass.instance_class

  --- @override
  --- @spec #initialize(): void
  function ic:initialize()
    --- super is provided as the parent classes instance_class
    ic._super.initialize(self)
  end

  --- When using instance:copy(), this function is called on the newly allocated
  --- copy of the object to effectively initialize itself from the other.
  --- By default, class will simply copy everything in the class to other (just by assigning it)
  --- @override
  --- @spec #initialize_copy(other: self): void
  function ic:initialize_copy(other)
    ic._super.initialize_copy(self, other)
  end
end
```
