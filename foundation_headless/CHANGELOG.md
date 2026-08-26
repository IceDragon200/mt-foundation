# 3.5.1

* Corrected CraftRegistry
  * Craft results now appropriately return their item names instead of stacks
  * Fuel recipes are indexed under the empty string index

# 3.5.0

* Stub `ValueNoiseMap`

# 3.4.0

* LuaEntities now have guid
  * Added `#get_guid/0`
  * `#on_step/2` now receives proper nil for move result
  * `#remove/0` now calls the lua entity's `#on_deactivate/1` if available
  * `#set_hp/1` now accounts for entity's that are killed
* Added ValueNoise fallback implementation
  * Do not use this if you care about performance, it is provided as-is as a pure lua backfill

# 3.3.0

* Added `foundation.com.headless.CraftRegistry` which re-implements the crafts system.
* Fixed `InvRef#get_list/1` not correctly returning item stacks

# 3.2.0

* Added `tetra.sound_play/{2,3}`

# 3.1.1

* Added missing `World#remove_node/1`

# 3.1.0

* Added `tetra.get_objects_inside_radius/2`
* Added `tetra.objects_inside_radius/2`

# 3.0.0

* Added `tetra` namespace, this mirrors parts of the core node space functions, allowing a fourth dimension to the positional vectors.

# 2.3.1

* Added `ObjectRef#is_valid`

# 2.3.0

* Implement `ObjectRef` which is now a base for players and lua entities.

# 2.2.1

* Set `breath_max` in player properties

# 2.2.0

* Added `foundation.com.headless.World` class, which is a minimal implementation of the core `get_node/set_node` functions.

# 2.1.1

* Bug fix for `InvRef#set_size/2` not correctly resizing inventory lists if it existed previously
* Bug fix for `ItemStack#equals/1` not checking wear
* Bug fix for `PlayerRef#set_inventory_formspec/1` using `core.log/2` incorrectly

# 2.1.0

* Added `foundation.com.PlayerRef`

# 2.0.0

* New dedicated namespace `foundation.com.headless`
* `foundation.com.FakeMetaRef` moved to `foundation.com.headless.MetaDataRef`

# 1.2.0

* `#from_table/1` now correctly checks the type of values being set, and will return true on failure

# 1.1.0

* Corrected behaviour of `#set_string/2` when given an empty string
* `#equals/1` now checks if the other object is a FakeMetaRef, or if the object implements `#to_table/0`
* `#from_table/1` now returns true when given a table to overwrite data and false otherwise.
