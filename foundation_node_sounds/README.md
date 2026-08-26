# Foundation - Node Sounds

Defines a NodeSoundRegistry class that can be used to register node sounds for use by other mods.

## API

### NodeSoundRegistry

By default, foundation_node_sounds provides its default registry via `foundation.com.node_sounds`.

First, sound sets can be registered via:

```lua
local ns = foundation.com.node_sounds

-- #register, give it a name and then a table with sounds or extends
ns:register("my_sound_set", {
  -- extends informs the registry that the sound set "extends" or builds upon another soundset
  -- these are evaluated during #build/2, so the parent sound sets can change during the lifetime
  -- of the registry.
  extends = { "optional_base_sound_set" },
  sounds = {
    -- This is where your usual node sounds go
  }
})

-- Later one can build node sounds table by calling #build/{1,2}
local sounds = ns:build("my_sound_set")

-- Optionally a SoundSet can be provided to add an additional base atop the requested sound set
-- extends does what you would expect, it adds another soundset atop the first, sounds
-- allows overriding individual items in the table.
-- This function returns the node sounds as a result.
local sounds2 = ns:build("my_sound_set", {
  extends = { "other" },
  sounds = {
    -- overrides
  }
})
```


### Drop-In

Drop-in for `default`:

```lua
local cns = foundation.com.compat_node_sounds
cns.node_sound_defaults({})
cns.node_sound_stone_defaults({})
cns.node_sound_dirt_defaults({})
cns.node_sound_sand_defaults({})
cns.node_sound_gravel_defaults({})
cns.node_sound_wood_defaults({})
cns.node_sound_leaves_defaults({})
cns.node_sound_glass_defaults({})
cns.node_sound_ice_defaults({})
cns.node_sound_metal_defaults({})
cns.node_sound_water_defaults({})
cns.node_sound_snow_defaults({})
```
