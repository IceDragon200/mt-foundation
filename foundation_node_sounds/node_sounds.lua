--
-- The node sounds registry allows registering, well node sounds,
-- these sounds are a table that can extend another node sound set.
--

-- @namespace foundation.com
local table_merge = assert(foundation.com.table_merge)

-- @class NodeSoundsRegistry
local NodeSoundsRegistry = foundation.com.Class:extends("NodeSoundsRegistry")
local ic = NodeSoundsRegistry.instance_class

-- @spec #initialize(): void
function ic:initialize()
  self.registered = {}
end

--
-- Clear the registry
--
-- @spec #clear(): self
function ic:clear()
  self.registered = {}
  return self
end

-- See minetest's node sounds for details on NodeSounds
--
-- @type SoundSet: {
--   extends: {
--     name: String,
--     ...
--   },
--   sounds: NodeSounds
-- }

--
-- Register a base node sound set
--
-- @spec #register(name: String, SoundSet): self
function ic:register(name, sound_set)
  self.registered[name] = {
    extends = sound_set.extends or {},
    sounds = sound_set.sounds or {},
  }

  return self
end

--
-- Register a base node sound set (if it doesn't already exist)
--
-- @spec #register_new(name: String, SoundSet): self
function ic:register_new(name, sound_set)
  if not self.registered[name] then
    return self:register(name, sound_set)
  end

  return self
end

--
-- Returns true if the specified node name set exists in the registry,
-- false otherwise.
--
-- @spec #is_registered(name: String): boolean
function ic:is_registered(name)
  return self.registered[name] ~= nil
end

--
-- Retrieve a soundset by name
--
-- @spec #get(name: String): SoundSet |nil
function ic:get(name)
  return self.registered[name]
end

--
-- Retrieve a soundset by name
-- Will error if the soundset does not exist
--
-- @spec #fetch(name: String): SoundSet
function ic:fetch(name)
  local sound_set = self:get(name)
  if sound_set then
    return sound_set
  else
    error("expected sound_set name='" .. name .. "' to exist")
  end
end

--
-- Build a node sounds table by name and optionally a custom soundset over it.
--
-- @spec #build(name: String, sound_set: SoundSet | nil): NodeSounds
function ic:build(name, sound_set)
  sound_set = sound_set or {}
  sound_set.extends = sound_set.extends or {}
  sound_set.sounds = sound_set.sounds or {}

  local super_sound_set = self:fetch(name)
  local base = self:_build_sound_set(super_sound_set)
  local top = self:_build_sound_set(sound_set)

  return table_merge(base, top)
end

function ic:_build_sound_set(sound_set)
  local base = {}

  for _, mixin_name in ipairs(sound_set.extends) do
    base = table_merge(base, self:build(mixin_name))
  end

  return base
end

foundation.com.NodeSoundsRegistry = NodeSoundsRegistry
