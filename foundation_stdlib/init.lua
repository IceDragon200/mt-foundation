local mod = foundation.new_module("foundation_stdlib", "1.9.0")

mod:require("lib/encoding_tables.lua")

mod:require("lib/color.lua")
mod:require("lib/cuboid.lua")
mod:require("lib/direction.lua")
mod:require("lib/inventory_list.lua")
mod:require("lib/iodata.lua")
mod:require("lib/item_stack.lua")
mod:require("lib/list.lua")
mod:require("lib/meta_ref.lua")
mod:require("lib/node_timer.lua")
mod:require("lib/number.lua")
mod:require("lib/string.lua")
mod:require("lib/path.lua")
mod:require("lib/pretty_units.lua")
mod:require("lib/random.lua")
mod:require("lib/table.lua")
mod:require("lib/time.lua")
mod:require("lib/type_conversion.lua")
mod:require("lib/value.lua")
mod:require("lib/vector.lua")
mod:require("lib/rect.lua")
mod:require("lib/symbols.lua")

mod:require("lib/waves.lua")
mod:require("lib/easers.lua")
mod:require("lib/tweener.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
