# Foundation Base

Foundation Base contains the module creation and version checking code of foundation.

As its name implies it will be required by every foundation mod.

## Interface

__Methods__

The following methods are available on a module:

```
-- Helper function for quickly creating item names by prefixing the local_name
-- with the mod name
#make_name(local_name: String): String

-- Helper functions for registering their respective item
#register_node(name: String, entry: Table): Void
#register_craftitem(name: String, entry: Table): Void
#register_tool(name: String, entry: Table): Void

-- Helper function that reimplements a simple 'require' system for the module
-- internally it uses dofile like any other mod would do normally.
#require(filename: String): Any
```

__Attributes__

The follow attributes are available on modules:

```
-- The given name of the mod (e.g. "your_mod_name")
_name: String

-- Will always be true for modules created by foundation
_is_foundation_module: Boolean = true

-- The given version string (e.g. "0.0.0")
VERSION: String

-- An instance of the minetest translator object for the mod
S: Translator

-- The root path to the mod, used by the require function
modpath: String

-- A table containing all the files loaded by require, may be empty since
-- standard mod files do not return anything on execution
loaded_files: Table<String, Any>
```

## Usage

### Public Module

To create a globally available foundation module, use:

```lua
-- new_module(name, version, default)
local mod = foundation.new_module("your_mod_name", "0.0.0")
```

Note that the version must be a valid semantic version that is:

```
MAJOR.MINOR.PATCH
```

__Example__

```
1.10.2
```

### Private Module

To create a private module use:

```lua
local mod = foundation.new_private_module("your_mod_name", "0.0.0")
```

Note that by creating a private module, `is_module_present/1+` will not be able to report its presence, since it expects the module to be globally available via `rawset(_G, name, mod)`.
