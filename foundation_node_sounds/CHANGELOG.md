# 1.3.0

* Added compat table `compat_node_sounds` which should work as a drop-in replacement for default's node sound functions.

# 1.2.0

* `NodeSoundsRegistry&new/1` now requires that registries are named

# 1.1.0

* Added `NodeSoundsRegistry#register_new/2` method, does the same thing as register, but will only register if the name isn't already inuse
