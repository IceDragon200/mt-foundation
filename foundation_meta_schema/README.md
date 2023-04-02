# Foundation - MetaSchema

Provides a utility class for defining typed schemas, meant to be used with any MetaRef*

It is intended for structured data which uses the MetaRef as a backend.

## Usage

```lua
local MySchema = foundation.com.MetaSchema:new("MySchema", nil, {
  name = {
    type = "string",
  },
  amount = {
    type = "integer",
  },
  is_something = {
    type = "boolean",
  }
})

do
  --- some meta somehow
  local meta = minetest.get_node(pos)

  MySchema:set_field(meta, "my_schema", "name", "Egg")
  MySchema:set(meta, "my_schema", {
    amount = 12,
    is_something = true,
  })
  local name = MySchema:get_field(meta, "my_schema", "name")
  assert(name == "Egg")

  local fields = MySchema:get(meta, "my_schema", "name")
  assert(fields.name == "Egg")
  assert(fields.amount == 12)
  assert(fields.is_something == true)
end
```
