--- @namespace foundation.tetra
foundation.tetra = foundation.tetra or {}

---
--- Tetra does not support object refs at this time, only nodes
---
tetra = assert(foundation.tetra)
tetra.VERSION = assert(foundation_headless.VERSION)
tetra.is_foundation = true

--- @type WorldVector = Vector3 | Vector4

--- @spec is_protected(pos: WorldVector, name: String): Boolean
tetra.is_protected = assert(core.is_protected)
--- @spec set_node(pos: WorldVector, node: NodeRef): void
tetra.set_node = assert(core.set_node)
--- @spec add_node(pos: WorldVector, node: NodeRef): void
tetra.add_node = assert(core.add_node)
--- @spec bulk_set_node(positions: WorldVector[], node: NodeRef): void
tetra.bulk_set_node = assert(core.bulk_set_node)
--- @spec swap_node(pos: WorldVector, node: NodeRef): void
tetra.swap_node = assert(core.swap_node)
--- @spec bulk_swap_node(positions: WorldVector[], node: NodeRef): void
tetra.bulk_swap_node = assert(core.bulk_swap_node)
--- @spec remove_node(pos: WorldVector): void
tetra.remove_node = assert(core.remove_node)
--- @spec get_node(pos: WorldVector): NodeRef
tetra.get_node = assert(core.get_node)
--- @spec get_node_or_nil(pos: WorldVector): NodeRef
tetra.get_node_or_nil = assert(core.get_node_or_nil)
--- @spec get_node_raw(x: Integer, y: Integer, z: Integer, w?: Integer): NodeRef
tetra.get_node_raw = assert(core.get_node_raw)
--- @spec get_node_light(pos: WorldVector, time_of_day?: Float): Integer
tetra.get_node_light = assert(core.get_node_light)
--- @spec get_natural_light(pos: WorldVector, time_of_day?: Float): Integer
tetra.get_natural_light = assert(core.get_natural_light)
--- @spec place_node(pos: WorldVector, node: NodeRef): void
tetra.place_node = assert(core.place_node)
--- @spec dig_node(pos: WorldVector, digger: ObjectRef): void
tetra.dig_node = assert(core.dig_node)
--- @spec punch_node(pos: WorldVector, puncher: ObjectRef): void
tetra.punch_node = assert(core.punch_node)
--- @spec check_for_falling(pos: WorldVector): void
tetra.check_for_falling = assert(core.check_for_falling)
--- @spec spawn_falling_node(pos: WorldVector): void
tetra.spawn_falling_node = assert(core.spawn_falling_node)
--- @spec find_nodes_with_meta(pos1: WorldVector, pos2: WorldVector): WorldVector[]
tetra.find_nodes_with_meta = assert(core.find_nodes_with_meta)
--- @spec get_meta(pos: WorldVector): MetaRef
tetra.get_meta = assert(core.get_meta)
--- @spec get_node_timer(pos: WorldVector): NodeTimer
tetra.get_node_timer = assert(core.get_node_timer)
--- @spec find_node_near(
---   pos: WorldVector,
---   radius: Float,
---   nodenames: String[],
---   search_center: Boolean
--- ): WorldVector | nil
tetra.find_node_near = assert(core.find_node_near)
--- @spec find_nodes_in_area(
---   pos1: WorldVector,
---   pos2: WorldVector,
---   nodenames: String[],
---   grouped: Boolean
--- ): WorldVector | nil
tetra.find_nodes_in_area = assert(core.find_nodes_in_area)
--- @spec find_nodes_in_area_under_air(
---   pos1: WorldVector,
---   pos2: WorldVector,
---   nodenames: String[],
---   grouped: Boolean
--- ): WorldVector | nil
tetra.find_nodes_in_area_under_air = assert(core.find_nodes_in_area_under_air)
--- @spec get_voxel_manip(
---   pos1: WorldVector,
---   pos2: WorldVector
--- ): VoxelManip
tetra.get_voxel_manip = assert(core.get_voxel_manip)
--- @spec get_heat(
---   pos: WorldVector
--- ): Float
tetra.get_heat = assert(core.get_heat)
--- @spec get_humidity(
---   pos: WorldVector
--- ): Float
tetra.get_humidity = assert(core.get_humidity)
--- @spec get_biome_data(
---   pos: WorldVector
--- ): Float
tetra.get_biome_data = assert(core.get_biome_data)
--- @spec get_node_level(
---   pos: WorldVector
--- ): Float
tetra.get_node_level = assert(core.get_node_level)
--- @spec set_node_level(
---   pos: WorldVector,
---   level: Number
--- ): Float
tetra.set_node_level = assert(core.set_node_level)
--- @spec tetra(
---   pos1: WorldVector,
---   pos2: WorldVector,
---   objects: Boolean,
---   liquids: Boolean,
---   pointabilities: Boolean
--- ): Raycast
tetra.raycast = assert(core.raycast)
