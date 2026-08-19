--- @namespace foundation.com.headless

--- @class LuaEntity
local LuaEntity = foundation.com.headless.ObjectRef:extends("foundation.com.headless.LuaEntity")
do
  local ic = LuaEntity.instance_class

  --- @spec #initialize(luaentity: Table, guid: String, pos: Vector3): void
  function ic:initialize(luaentity, guid, pos)
    ic._super.initialize(self)

    self._guid = guid

    if pos then
      self._pos = vector.copy(pos)
    end

    self._luaentity = luaentity
    if self._luaentity then
      assert(self._luaentity.name, "expected luaentity to have a name")
    end

    self._texture_mod = ""
    self._removed = false
    self._acceleration = vector.new(0, 0, 0)
    self._rotation = vector.new(0, 0, 0)
  end

  --- @override
  --- @spec #get_guid(): String
  function ic:get_guid()
    if self._removed then
      return nil
    end
    return self._guid
  end

  function ic:update_physics(dtime)
    self._velocity.x = self._velocity.x + self._acceleration.x * dtime
    self._velocity.y = self._velocity.y + self._acceleration.y * dtime
    self._velocity.z = self._velocity.z + self._acceleration.z * dtime
    ic._super.update_physics(self, dtime)
  end

  --- @spec #update(dtime: Number): void
  function ic:update(dtime)
    ic._super.update(self, dtime)
    if self._luaentity.on_step then
      self._luaentity:on_step(dtime, nil)
    end
  end

  --- @override
  --- @spec #is_valid(): Boolean
  function ic:is_valid()
    return not self._removed
  end

  --- @spec #remove(): void
  function ic:remove()
    if self._removed then
      return
    end
    -- ensure the lua entity can't remove itself again, while it's already being removed
    self._removed = true
    if type(self._luaentity.on_deactivate) == "function" then
      self._luaentity:on_deactivate(true)
    end
    ic._super.remove(self)
  end

  function ic:set_hp(hp, reason)
    ic._super.set_hp(self, hp, reason)
    if self:is_valid() and self._hp <= 0 then
      local killer = reason and reason.object or nil
      if type(self._luaentity.on_death) == "function" then
        self._luaentity:on_death(killer)
      end
      self:remove()
    end
  end

  function ic:set_velocity(vec)
    self._velocity = vector.copy(vec)
  end

  function ic:set_acceleration(vec)
    self._acceleration = vector.copy(vec)
  end

  function ic:get_acceleration()
    return vector.copy(self._acceleration)
  end

  function ic:set_rotation(vec)
    self._rotation = vector.copy(vec)
  end

  function ic:get_rotation()
    return vector.copy(self._rotation)
  end

  function ic:set_yaw(val)
    self._rotation.y = val
  end

  function ic:get_yaw()
    return self._rotation.y
  end

  function ic:set_texture_mod(val)
    self._texture_mod = val
  end

  function ic:get_texture_mod()
    return self._texture_mod
  end

  function ic:set_sprite(start_frame, num_frames, frame_length, select_x_by_camera)
    -- body
  end

  function ic:get_luaentity()
    return self._luaentity
  end

  function ic:get_entity_name()
    return self._luaentity.name
  end

  function ic:_get_staticdata()
    local callback = self._luaentity.get_staticdata
    if type(callback) == "function" then
      local result = callback(self._luaentity)
      assert(type(result) == "string", "get_staticdata must return a string")
      return result
    end

    return ""
  end
end

foundation.com.headless.LuaEntity = LuaEntity
