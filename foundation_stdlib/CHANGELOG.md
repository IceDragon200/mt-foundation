# 1.43.0

* Added `foundation.com.random_addr16/{2,3,4}` for generating hex-like addresses for other mods.

# 1.42.0

* Added `foundation.com.Color.from_rgba_f/4`
* Added `foundation.com.Color.from_rgb_hsl_f/3`
* Added `foundation.com.Color.from_cmyk_f/4`

# 1.41.0

* Added `foundation.com.string_ascii_iequals/2`
* Added `foundation.com.string_ascii_icontains/2`

# 1.40.1

* Added `foundation.com.BINARY_PREFIXES` for `foudation.com.format_pretty_unit/3`

# 1.40.0

* Added `Quaternion.dot/2` and `Quaternion#dot/1`
* Added `Quaternion.slerp/4` and `Quaternion#slerp/3`
* Added `Vector2.normalize/2` and `Vector2#normalize/1`
* Added `Vector3.normalize/2` and `Vector3#normalize/1`
* Added `Vector4.normalize/2` and `Vector4#normalize/1`
* Added `Vector2.slerp/4` and `Vector2#slerp/3`
* Added `Vector3.slerp/4` and `Vector3#slerp/3`
* Added `Vector4.slerp/4` and `Vector4#slerp/3`
* Added optional `places` argument to `Vector2.round/2` making it `Vector2.round/3`
* Added optional `places` argument to `Vector3.round/2` making it `Vector3.round/3`
* Added optional `places` argument to `Vector4.round/2` making it `Vector4.round/3`
* Added optional `places` argument to `number_round/1` making it `number_round/2`

# 1.39.0

The following were typoed, thanks to autocompletion, they weren't noticed until now.

* Renamed `integer_crawford_base32_be_encode/3` > `integer_crockford_base32_be_encode/3`
* Renamed `integer_crawford_base32_le_encode/3` > `integer_crockford_base32_le_encode/3`

# 1.38.0

* Added `foundation.com.value_inspect/1`

# 1.37.0

* Added `foundation.com.number_sign/1`
* Added `foundation.com.plot_line2/5`
* Added `foundation.com.plot_line3/7`

# 1.36.1

* Added `foundation.com.ansi_move_cursor_home/0`
* Added `foundation.com.ansi_move_cursor_up/1`
* Added `foundation.com.ansi_move_cursor_down/1`
* Added `foundation.com.ansi_move_cursor_right/1`
* Added `foundation.com.ansi_move_cursor_left/1`
* Added `foundation.com.ansi_move_cursor_to/2`

# 1.36.0

New ANSI helper functions and updated ansi_format functions:
* Renamed `foundation.com.ansi_start/1` to `foundation.com.ansi_format_start/1`
* Renamed `foundation.com.ansi_end/0` to `foundation.com.ansi_format_end/0`
* Added `foundation.com.ansi_clear_line_trailing/0`
* Added `foundation.com.ansi_clear_line_leading/0`
* Added `foundation.com.ansi_clear_line/0`
* Added `foundation.com.ansi_clear_screen_trailing/0`
* Added `foundation.com.ansi_clear_screen_leading/0`
* Added `foundation.com.ansi_clear_screen/0`

# 1.35.0

* Added `ansi_format/2` for decorating a string with ansi escape sequences

# 1.34.0

* Added `string_each_char/2` for iterating over a string's characters

# 1.33.0

* Moved `metaref_*` functions to `foundation_mt` since they are minetest specific.
* Moved `item_stack_*` functions to `foundation_mt` since they are minetest specific.
* Moved `inventory_*` functions to `foundation_mt` since they are minetest specific.

# 1.32.0

* Added `list_bsearch/2`
* Added `list_bsearch_by/2`

# 1.31.0

* Added `table_find/2` which iterates over each pair in the table and returns the matching pair based on a given predicate.
* Added `list_find/2` see `table_find/2` as well, as they do the same thing, just with arguments reversed.

# 1.30.0

* Implemented parts of `Quaternion` module:
  * `is_quaternion/1`
  * `new/4`
  * `copy/1`
  * `from_vector4`
  * `unwrap/1`
  * `unit/0`
  * `to_string/{1,2}`
  * `inspect/{1,2}`
  * `equals/2`
  * `length/1`
  * `conjugate/2`
  * `inverse/2`
  * `normalize/2`
  * `add/3`
  * `subtract/3`
  * `hadamard_multiply/3`
  * `multiply/3`
  * `divide/3`
  * `to_euler/1`
  * `dump_data/1`
  * `load_data/1`

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
