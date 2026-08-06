# 3.0.0

* Refactored most modules using balm's versions instead, this does introduce breaking changes in the BinSchema family of modules.

# 2.1.0

* Added `BinaryBuffer#reopen/1`

# 2.0.0

* ByteBuf is now a module that has different implementations
* ByteBuf.little is effectively the original ByteBuf but must be invoked using the method syntax (i.e. `little:w_uv(stream, uint)` instead of `little.w_uv(stream, uint)`)

# 1.0.0

* Initial version
