--- @namespace foundation.com.Directions
local Directions = foundation.com.Directions

--- @spec facedir_wallmount_after_place_node(
---   pos: WorldVector,
---   placer: PlayerRef,
---   item_stack: ItemStack,
---   pointed_thing: PointedThing
--- ): void
function Directions.facedir_wallmount_after_place_node(pos, _placer, _itemstack, pointed_thing)
  assert(pointed_thing, "expected a pointed thing")
  local above = pointed_thing.above
  local under = pointed_thing.under
  local dir = {
    x = above.x - under.x,
    y = above.y - under.y,
    z = above.z - under.z,
  }
  local node = tetra.get_node(pos)
  node.param2 = Directions.vdir_to_wallmounted_facedir(dir)
  tetra.swap_node(pos, node)
end
