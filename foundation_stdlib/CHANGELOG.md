# 1.29.0

* `Matrix3x3` now has a metatable with limited arithmetic support
* Additional `Matrix3x3` functions:
  * `add_scalar/3`
  * `subtract_scalar/3`
  * `multiply_scalar/3`
  * `divide_scalar/3`
  * `idivide_scalar/3`
  * `is_matrix3x3/1`
  * `from_table/1`
  * `random/2`
  * `to_string/1`
  * `inspect/1`
  * `equals/2`
  * `idivide/3`
  * `idivide_vec3/3`
* `Matrix4x4` now has a metatable with limited arithmetic support
* Additional `Matrix4x4` functions:
  * `add_scalar/3`
  * `subtract_scalar/3`
  * `multiply_scalar/3`
  * `divide_scalar/3`
  * `idivide_scalar/3`
  * `is_matrix4x4/1`
  * `from_table/1`
  * `random/2`
  * `to_string/1`
  * `inspect/1`
  * `equals/2`
  * `idivide/3`
  * `idivide_vec4/3`
* Additional `Vector2` functions:
  * `is_vector2/1` to determine if the given table has a Vector2 metatable
  * `inspect/1` returns a string representation of the vector (e.g. `(1, 2)`)
  * `length/1`
* Additional `Vector3` functions:
  * `is_vector3/1` to determine if the given table has a Vector3 metatable (not minetest vector fyi)
  * `inspect/1` returns a string representation of the vector (e.g. `(1, 2, 3)`)
  * `length/1`
* Additional `Vector4` functions:
  * `is_vector4/1` to determine if the given table has a Vector4 metatable
  * `inspect/1` returns a string representation of the vector (e.g. `(1, 2, 3, 4)`)
  * `length/1`

# 1.28.0

* Fixed `Vector4.idivide/3` being overwritten by the `Vector4.apply/3` function
* Added `Vector2.apply/3` and `Vector3.apply/3`
* Added `Matrix3x3` and `Matrix4x4`

# 1.27.0

* Vector2, Vector3, and Vector4 all have a metatable, keep in mind that foundation's vectors typically expect the destination vector first for `add/3`, `subtract/3`, `divide/3`, and `multiply/3`.

```lua
local v2 = foundation.com.Vector2.new(0, 0)
--- mutates v2 in place
v2:add(a, b)

--- will return a new vector each time
local c = v2 + a + b

--- operations could be chained as well
v2:add(a, b):multiply(a2, b2)
```

# 1.26.0

* Added `foundation.com.list_sort_by/2`

# 1.25.0

* Added `foundation.com.list_filter/2`
* Added `foundation.com.list_reject/2`
* Added `foundation.com.table_filter/2`
* Added `foundation.com.table_reject/2`

# 1.24.0

* Added `foundation.com.InventoryList.copy/1`
* Added `foundation.com.InventoryList.add_items/2`
* Added `foundation.com.InventoryList.fits_all_items/2`

# 1.23.1

* luacheckrc fixups

# 1.23.0

* Added `foundation.com.Color.lerp/3`
* Added `foundation.com.Color.maybe_to_color/1`
* Added `foundation.com.metaref_int_list_to_table/3`
* Added `foundation.com.metaref_int_list_index_of/3`
* Added `foundation.com.metaref_int_list_pop/3`
* Added `foundation.com.metaref_int_list_peek/3`
* Added `foundation.com.metaref_int_list_push/3`
* Added `foundation.com.metaref_int_list_clear/3`
* Added `foundation.com.metaref_int_list_lazy_clear/3`
* Added `foundation.com.metaref_string_list_to_table/3`
* Added `foundation.com.metaref_string_list_index_of/3`
* Added `foundation.com.metaref_string_list_pop/3`
* Added `foundation.com.metaref_string_list_peek/3`
* Added `foundation.com.metaref_string_list_push/3`
* Added `foundation.com.metaref_string_list_clear/3`
* Added `foundation.com.metaref_string_list_lazy_clear/3`
* Added `foundation.com.Vector2.distance/2`
* Added `foundation.com.Vector3.distance/2`
* Added `foundation.com.Vector4.distance/2`

# 1.22.0

* Added `foundation.com.Color.maybe_to_colorstring/1`

# 1.21.0

* Added `foundation.com.list_sort/1`

# 1.20.0

* Added `foundation.com.Color.blend_overlay/2`
* Added `foundation.com.Color.blend_hard_light/2`
* Added `foundation.com.Color.blend_multiply/2`
* Added `foundation.com.Color.to_grayscale_value/1`
* Added `foundation.com.Color.to_grayscale/1`

# 1.19.0

* Added `foundation.com.Color.NAMED` table contains all named colors according to minetest's lua_api.txt
* Added `foundation.com.Color.from_colorstring` because for some reason minetest didn't have one?
* Added `foundation.com.string_hex_nibble_to_byte`

# 1.18.0

* `foundation.com.format_pretty_unit/3` now available, this version of format_pretty_unit will now accept a prefix table.

# 1.17.2

* `foundation.com.Symbol&alloc_symbol/1` now checks symbol name is a string
* Added `foundation.com.InventoryList.new/1` function for creating an inventory list

# 1.17.1

* Fixed some linter warnings

# 1.17.0

__Added Functions__

* `foundation.com.table_sample` returns a random key-value pair in the given table

# 1.16.0

__Added Functions__

* `foundation.com.number_interpolate` to replace number_moveto

__Alias Functions__

* `foundation.com.number_moveto = foundation.com.number_interpolate` provided for compatability, will be removed a future date.

__Deprecated Functions__

* `foundation.com.number_moveto` please use `foundation.com.number_interpolate` instead

# 1.15.0

__Added Functions__

* `foundation.com.table_freeze/1` - disables assignments on the specified table

# 1.14.0

__Added Functions__

* `foundation.com.itemstack_deep_equals/2` - compares 2 itemstacks and their meta

__Modified Functions__

* `foundation.com.iodata_to_string/1` - uses a modified internal implementation to utilize a table for concat

# 1.13.0

__Added Functions__

* `foundation.com.Vector2`
  * `equals/2`
* `foundation.com.Vector3`
  * `equals/2`
* `foundation.com.Vector4`
  * `equals/2`

# 1.12.0

__Added Functions__

* `foundation.com.list_split/2` can split a list-like table into 2 tables specifying the length of the first
* `foundation.com.InventoryList.is_empty/1` can determine if a inventory itemstack list is empty

# 1.11.1

* `foundation.com.table_equals/2` can now handle nils for both arguments

# 1.11.0

__Added Functions__

* `foundation.com.table_deep_copy/1`
* `foundation.com.Vector2`
  * `ceil/2`
* `foundation.com.Vector3`
  * `ceil/2`
* `foundation.com.Vector4`
  * `ceil/2`

# 1.10.0

Stuff changed

# 1.9.0

__Added Functions__

* `foundation.com.Vector2`
  * `dump_data/1`
  * `load_data/1`
* `foundation.com.Vector3`
  * `dump_data/1`
  * `load_data/1`
* `foundation.com.Vector4`
  * `dump_data/1`
  * `load_data/1`

# 1.8.0

__Added Functions__

* `foundation.com.path_components/1`
* `foundation.com.path_basename/1`
* `foundation.com.path_dirname/1`

# 1.7.0

__Added Functions__

* `foundation.com.Vector2.copy/1`
* `foundation.com.Vector3.copy/1`
* `foundation.com.Vector4.copy/1`
* `foundation.com.Vector4.to_string/2` updated to match other vector to_string/2
* `foundation.com.Vector4.idivide/3`
* `foundation.com.Vector4.idiv/3` aliased from `foundation.com.Vector4.idivide/3`

# 1.6.0

__Added Functions__

* `foundation.com.list_crawford_base32_le_rolling_encode_table/*` for converting a list of integers and strings into a base32 digest
* `foundation.com.integer_be_encode/2` for converting integers into big-endian binary strings
* `foundation.com.integer_le_encode/2` for converting integers into little-endian binary strings
* `foundation.com.integer_hex_be_encode/2` for converting integers into hex encoded byte pairs
* `foundation.com.integer_base16_be_encode/2` for encoding integers as base16 with big-endian ordering
* `foundation.com.integer_base16_le_encode/2` for encoding integers as base16 with little-endian ordering
* `foundation.com.integer_crawford_base32_be_encode/2` for encoding integers as crawford base32 in big-endian ordering
* `foundation.com.integer_crawford_base32_le_encode/2` for encoding integers as crawford base32 in little-endian ordering

__Added Constants__

* `foundation.com.HEX_UPPERCASE_ENCODE_TABLE`
* `foundation.com.HEX_TO_DEC`
* `foundation.com.HEX_BYTE_TO_DEC`
* `foundation.com.CROCKFORD_BASE32_ENCODE_TABLE`
* `foundation.com.CROCKFORD_BASE32_DECODE_TABLE`

# 1.5.0

__Added Functions__

* `foundation.com.append_itemstack_meta_description/2` for appending additional details to an existing description meta.

# 1.1.0

__Added__

* `foundation.com.Symbols` a symbol registry, for converting between allocated ids and strings, can be used for systems that only allow numbers but for friendly reasons needs a string.
