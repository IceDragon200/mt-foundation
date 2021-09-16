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
