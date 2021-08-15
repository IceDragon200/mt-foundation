-- @namespace foundation.com

--
-- Utility module for registering sounds for quick playback
--
local function table_merge(...)
  local result = {}
  for _,t in ipairs({...}) do
    for key,value in pairs(t) do
      result[key] = value
    end
  end
  return result
end

-- @class SoundsRegistry
local SoundsRegistry = foundation.com.Class:extends("SoundsRegistry")
local ic = SoundsRegistry.instance_class

function ic:initialize()
  self.registered = {}
end

-- @spec #register(name: String,
--                 filename: String,
--                 default_params: Table) :: self
function ic:register(name, filename, default_params)
  default_params = default_params or {}
  self.registered[name] = {
    filename = filename,
    params = table_merge({
      gain = 1.0,
      pitch = 1.0,
      loop = false,
      fade = 0.0,
      object = nil, -- ObjectRef
      player = nil, -- PlayerName
      pos = nil, -- Vector3
      ephemeral = true,
    }, default_params),
  }
  return self
end

--
--
-- @spec #play(name: String, params: Table) :: (boolean, SoundHandle)
function ic:play(name, params)
  local entry = self.registered[name]
  if entry then
    params = params or {}
    local sound_params = table_merge(entry.params, params)
    local spec = {
      name = entry.filename,
    }
    local pitch = sound_params.pitch or 1.0

    -- Pitch Variance
    local pv_min = 0
    local pv_max = 0

    if sound_params.pitch_variance then
      local pv = sound_params.pitch_variance
      pv_min = -pv
      pv_max = pv
    end

    if pv_min ~= 0 or pv_max ~= 0 then
      local variance_range = pv_max - pv_min
      pitch = math.max(pitch + pv_min + variance_range * math.random(), 0)
    end
    --

    local parameters = {
      gain = sound_params.gain or 1.0,
      pitch = pitch,
      loop = sound_params.loop,
      fade = sound_params.fade,
      object = sound_params.object,
      to_player = sound_params.to_player,
      pos = sound_params.pos,
      max_hear_distance = sound_params.max_hear_distance,
      exclude_player = sound_params.exclude_player,
    }
    local handle = minetest.sound_play(spec, parameters, entry.ephemeral)
    return true, handle
  end
  return false, nil
end

foundation.com.SoundsRegistry = SoundsRegistry
foundation.com.sounds = SoundsRegistry:new()
