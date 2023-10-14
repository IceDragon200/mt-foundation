# 2.1.1

* Bug fix for `InvRef#set_size/2` not correctly resizing inventory lists if it existed previously
* Bug fix for `ItemStack#equals/1` not checking wear
* Bug fix for `PlayerRef#set_inventory_formspec/1` using minetest.log incorrectly

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
