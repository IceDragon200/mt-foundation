all:
	make -C foundation_native

.PHONY : luacheck
luacheck:
	luacheck .
