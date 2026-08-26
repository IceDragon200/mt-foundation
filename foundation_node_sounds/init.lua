---
--- Foundation Node Sounds
---
--- @namespace foundation_node_sounds
local mod = foundation.new_module("foundation_node_sounds", "1.3.0")

mod:require("node_sounds.lua")

--- @namespace foundation.com
--- @const compat_node_sounds: foundation.com.NodeSoundsRegistry
foundation.com.node_sounds =
  foundation.com.NodeSoundsRegistry:new("foundation_node_sounds:node_sounds_registry")

--- @namespace foundation.com.compat_node_sounds
foundation.com.compat_node_sounds = {}
local m = foundation.com.compat_node_sounds
do
  -- Note, do NOT alias the foundation.com.node_sounds for the below functions
  -- the node_sounds may change depending on the environment

  --- @spec node_sound_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_defaults(subject)
    return foundation.com.node_sounds:build("default", { sounds = subject })
  end

  --- @spec node_sound_stone_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_stone_defaults(subject)
    return foundation.com.node_sounds:build("stone", { sounds = subject })
  end

  --- @spec node_sound_dirt_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_dirt_defaults(subject)
    return foundation.com.node_sounds:build("dirt", { sounds = subject })
  end

  --- @spec node_sound_sand_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_sand_defaults(subject)
    return foundation.com.node_sounds:build("sand", { sounds = subject })
  end

  --- @spec node_sound_gravel_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_gravel_defaults(subject)
    return foundation.com.node_sounds:build("gravel", { sounds = subject })
  end

  --- @spec node_sound_wood_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_wood_defaults(subject)
    return foundation.com.node_sounds:build("wood", { sounds = subject })
  end

  --- @spec node_sound_leaves_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_leaves_defaults(subject)
    return foundation.com.node_sounds:build("leaves", { sounds = subject })
  end

  --- @spec node_sound_glass_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_glass_defaults(subject)
    return foundation.com.node_sounds:build("glass", { sounds = subject })
  end

  --- @spec node_sound_ice_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_ice_defaults(subject)
    return foundation.com.node_sounds:build("ice", { sounds = subject })
  end

  --- @spec node_sound_metal_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_metal_defaults(subject)
    return foundation.com.node_sounds:build("metal", { sounds = subject })
  end

  --- @spec node_sound_water_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_water_defaults(subject)
    return foundation.com.node_sounds:build("water", { sounds = subject })
  end

  --- @spec node_sound_snow_defaults(subject: NodeSounds): NodeSounds
  function m.node_sound_snow_defaults(subject)
    return foundation.com.node_sounds:build("snow", { sounds = subject })
  end
end
