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
