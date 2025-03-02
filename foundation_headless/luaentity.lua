--- @namespace foundation.com.headless

--- @class LuaEntity
local LuaEntity = foundation.com.headless.ObjectRef:extends("foundation.com.headless.LuaEntity")
do
  local ic = LuaEntity.instance_class

  function ic:initialize(luaentity, pos)
    ic._super.initialize(self)

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

  function ic:update_physics(dtime)
    self._velocity.x = self._velocity.x + self._acceleration.x * dtime
    self._velocity.y = self._velocity.y + self._acceleration.y * dtime
    self._velocity.z = self._velocity.z + self._acceleration.z * dtime
    ic._super.update_physics(self, dtime)
  end

  function ic:update(dtime)
    ic._super.update(self, dtime)
    if self._luaentity.on_step then
      self._luaentity:on_step(dtime, {})
    end
  end

  function ic:is_valid()
    return not self._removed
  end

  function ic:remove()
    self._removed = true
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
end

foundation.com.headless.LuaEntity = LuaEntity
