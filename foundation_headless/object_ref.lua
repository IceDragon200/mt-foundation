--- @namespace foundation.com.headless

--- @class ObjectRef
local ObjectRef = foundation.com.Class:extends("foundation.com.headless.ObjectRef")
do
  local ic = ObjectRef.instance_class

  function ic:initialize()
    ic._super.initialize(self)

    self._tracked = false

    self._attachment = nil
    self._children = {}
    self._listeners = {}
    self._armor_groups = {}
    self._hp = 20
    self._pos = vector.new(0, 0, 0)
    self._velocity = vector.new(0, 0, 0)
    self._animation = {
      frame_range = nil,
      frame_speed = nil,
      frame_blend = nil,
      frame_loop = nil,
    }
    self._properties = {}
    self._nametag_attributes = {}
  end

  function ic:update_physics(dtime)
    self._pos.x = self._pos.x + self._velocity.x * dtime
    self._pos.y = self._pos.y + self._velocity.y * dtime
    self._pos.z = self._pos.z + self._velocity.z * dtime
  end

  function ic:update(dtime)
    if self._tracked then
      print(dump(self))
    end
  end

  function ic:get_pos()
    return vector.copy(self._pos)
  end

  function ic:set_pos(vec)
    self._pos = vector.copy(vec)
  end

  function ic:add_pos(vec)
    self._pos = vector.add(self._pos, vec)
  end

  function ic:get_velocity()
    return vector.copy(self._velocity)
  end

  function ic:add_velocity(vec)
    self._velocity = vector.add(self._velocity, vec)
  end

  function ic:move_to(pos, continuous)
    self._pos = vector.copy(pos)
  end

  function ic:punch(puncher, time_from_last_punch, tool_capabilties, dir)
    ---
  end

  function ic:right_click(clicker)
  end

  function ic:get_hp()
    return self._hp
  end

  function ic:set_hp(hp)
    self._hp = assert(hp)
  end

  function ic:get_inventory()
    return nil
  end

  function ic:get_wield_list()
    return nil
  end

  function ic:get_wield_index()
    return nil
  end

  function ic:get_wielded_item()
    return nil
  end

  function ic:set_wielded_item(item)
    ---
  end

  function ic:get_armor_groups()
    return table.copy(self._armor_groups)
  end

  function ic:set_armor_groups(groups)
    self._armor_groups = table.copy(groups)
  end

  function ic:set_animation(frame_range, frame_speed, frame_blend, frame_loop)
    self._animation = {
      frame_range = frame_range,
      frame_speed = frame_speed,
      frame_blend = frame_blend,
      frame_loop = frame_loop,
    }
  end

  function ic:get_animation()
    return self._animation.frame_range,
      self._animation.frame_speed,
      self._animation.frame_blend,
      self._animation.frame_loop
  end

  function ic:set_animation_frame_speed(frame_speed)
    self._animation.frame_speed = frame_speed
  end

  function ic:set_attach(parent, bone, position, rotation, forced_visible)
    self._attachment = {
      parent = parent,
      bone = bone,
      position = position,
      rotation = rotation,
      forced_visible = forced_visible,
    }
    table.insert(parent._children, self._attachment)
  end

  function ic:get_attach()
    if self._attachment then
      return self._attachment.parent,
        self._attachment.bone,
        self._attachment.position,
        self._attachment.rotation,
        self._attachment.forced_visible
    end
    return nil
  end

  function ic:get_children()
    return self._children
  end

  function ic:set_detach()
    if self._attachment then
      local parent = self._attachment.parent
      local v, i =
        foundation.com.list_find(self._attachment.parent._children, function (value)
          return value == self._attachment
        end)

      if i then
        table.remove(self._attachment.parent._children, i)
      end
      self._attachment = nil
    end
  end

  function ic:set_bone_position(bone, position, rotation)

  end

  function ic:get_bone_position(bone)

  end

  function ic:set_bone_override(bone, overrides)
  end

  function ic:get_bone_override(bone)
    return nil
  end

  function ic:get_properties()
    return self._properties
  end

  function ic:set_properties(properties)
    for key, value in pairs(properties) do
      self._properties[key] = value
    end
  end

  function ic:set_observers(observers)
    for player_name, value in pairs(observers) do
      ---
    end
  end

  function ic:get_observers()

  end

  function ic:get_effective_observers()
  end

  function ic:is_player()
    return false
  end

  function ic:get_nametag_attributes()
    return self._nametag_attributes
  end

  function ic:set_nametag_attributes(nametag_attributes)
    self._nametag_attributes = nametag_attributes
  end

  function ic:get_player_name()
    return ""
  end

  function ic:remove()
    ---
  end

  function ic:get_luaentity()
    return nil
  end
end

foundation.com.headless.ObjectRef = ObjectRef
