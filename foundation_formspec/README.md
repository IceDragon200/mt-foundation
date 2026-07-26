# Foundation Formspec

Helper functions for preparing formspec elements.

## Usage

```lua
local fspec = foundation.com.formspec.api

fspec.formspec_version(7)
.. fspec.label(0, 0, "Hello, World")
.. fspec.list("detached", "my_inventory", 0, 32, 4, 4)
```
