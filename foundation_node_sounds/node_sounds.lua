--
-- The node sounds registry allows registering, well node sounds,
-- these sounds are a table that can extend another node sound set.
--
local table_copy = assert(foundation.com.table_copy)
local table_merge = assert(foundation.com.table_merge)

--- @namespace foundation.com

--- @class NodeSoundsRegistry
local NodeSoundsRegistry = foundation.com.Class:extends("NodeSoundsRegistry")
do
  local ic = NodeSoundsRegistry.instance_class

  --- @override
  --- @spec #initialize(name: String): void
  function ic:initialize(name)
    ic._super.initialize(self)
    self.name = assert(name, "a name is required for node sound registries")
    self.registered = {}
  end

  --- @override
  --- @spec #initialize_copy(other: NodeSoundsRegistry)
  function ic:initialize_copy(other)
    ic._super.initialize_copy(self, other)
    self.registered = table_copy(other.registered)
  end

  ---
  --- Clear the registry
  ---
  --- @spec #clear(): self
  function ic:clear()
    self.registered = {}
    return self
  end

  --- See luanti's node sounds for details on NodeSounds
  ---
  --- A SoundSet contains 2 fields, extends, which is a list of names that the sound set should
  --- extend from and then its sounds table which equivalent to what luanti will return.
  --- @type SoundSet: {
  ---   extends?: String[],
  ---   sounds: NodeSounds
  --- }

  ---
  --- Register a base node sound set
  ---
  --- @spec #register(name: String, SoundSet): self
  function ic:register(name, sound_set)
    self.registered[name] = {
      extends = sound_set.extends or {},
      sounds = sound_set.sounds or {},
    }

    return self
  end

  ---
  --- Register a base node sound set (if it doesn't already exist)
  ---
  --- @spec #register_new(name: String, SoundSet): self
  function ic:register_new(name, sound_set)
    if not self.registered[name] then
      return self:register(name, sound_set)
    end

    return self
  end

  ---
  --- Returns true if the specified node name set exists in the registry,
  --- false otherwise.
  ---
  --- @spec #is_registered(name: String): boolean
  function ic:is_registered(name)
    return self.registered[name] ~= nil
  end

  ---
  --- Retrieve a soundset by name
  ---
  --- @spec #get(name: String): SoundSet |nil
  function ic:get(name)
    return self.registered[name]
  end

  ---
  --- Retrieve a soundset by name
  --- Will error if the soundset does not exist
  ---
  --- @spec #fetch(name: String): SoundSet
  function ic:fetch(name)
    local sound_set = self:get(name)
    if sound_set then
      return sound_set
    else
      error(self.name .. ": expected sound_set name='" .. name .. "' to exist")
    end
  end

  ---
  --- Build a node sounds table by name and optionally a custom soundset over it.
  ---
  --- @spec #build(name: String, sound_set?: SoundSet): NodeSounds
  function ic:build(name, sound_set)
    sound_set = sound_set or {}

    local super_sound_set = self:fetch(name)
    local base = self:_build_node_sounds_from_sound_set(super_sound_set)
    local top = self:_build_node_sounds_from_sound_set(sound_set)

    return table_merge(base, top)
  end

  --- @spec _build_node_sounds_from_sound_set(sound_set: SoundSet): NodeSounds
  function ic:_build_node_sounds_from_sound_set(sound_set)
    local base = {}
    if sound_set.extends then
      for _, mixin_name in pairs(sound_set.extends) do
        for key, value in pairs(self:build(mixin_name)) do
          base[key] = value
        end
      end
    end

    if sound_set.sounds then
      for key, value in pairs(sound_set.sounds) do
        base[key] = value
      end
    end

    return base
  end
end

foundation.com.NodeSoundsRegistry = NodeSoundsRegistry
