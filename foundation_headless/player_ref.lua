--- @namespace foundation.com.headless

--- @class PlayerRef
local PlayerRef = foundation.com.Class:extends("foundation.com.headless.PlayerRef")
do
  local ic = PlayerRef.instance_class

  function ic:initialize(name)
    self._listeners = {}
    self.hp = 20
    self.breath = 20
    self.name = name
    self.hotbar_index = 1
    self.inventory = foundation.com.headless.InvRef:new()
    self.meta = foundation.com.headless.MetaDataRef:new()
    self.hud_id = 0
    self.hud = {}
    self.hud_flags = {}
    self.physics_overrides = {}
    self.armor_groups = {}
    self.lighting = {}
    self.properties = {
      eye_height = 1.625,
    }
    self.look_dir = vector.new(0, 0, 0)
    self.pos = vector.new(0, 0, 0)

    self.inventory:set_size("main", 8)
  end

  -- Callbacks, only used for the mock
  function ic:_on(name, callback)
    if not self._listeners[name] then
      self._listeners[name] = {}
    end

    self._listeners[name][callback] = true

    return callback
  end

  function ic:_off(name, callback)
    if self._listeners[name] then
      self._listeners[name] = {}
      self._listeners[name][callback] = nil
    end

    return callback
  end

  function ic:get_meta()
    return self.meta
  end

  function ic:get_inventory()
    return self.inventory
  end

  function ic:set_inventory_formspec(formspec)
    minetest.log("info", "set_inventory_formspec/1 name=" .. self.name)
    self.inventory_formspec = formspec

    local listeners = self._listeners["set_inventory_formspec"]

    if listeners then
      for callback, _ in pairs(listeners) do
        callback(self, self.inventory_formspec)
      end
    end
  end

  function ic:get_inventory_formspec()
    return self.inventory_formspec
  end

  function ic:hud_set_hotbar_image(image)
    self.hotbar_image = image
  end

  function ic:hud_set_hotbar_selected_image(image)
    self.hotbar_selected_image = image
  end

  function ic:hud_set_hotbar_itemcount(count)
    self.hotbar_itemcount = count
  end

  function ic:get_player_name()
    return self.name
  end

  function ic:hud_add(def)
    --print("TODO: hud_add", dump(def))
    self.hud_id = self.hud_id + 1
    self.hud[self.hud_id] = def
    return self.hud_id
  end

  function ic:hud_get_flags()
    return self.hud_flags
  end

  function ic:hud_set_flags(flags)
    self.hud_flags = flags
  end

  function ic:set_physics_override(physics_overrides)
    self.physics_overrides = physics_overrides
  end

  function ic:get_physics_override()
    return self.physics_overrides
  end

  function ic:get_hp()
    return self.hp
  end

  function ic:set_hp(hp)
    self.hp = assert(hp)
  end

  function ic:get_breath()
    return self.breath
  end

  function ic:get_armor_groups()
    return self.armor_groups
  end

  function ic:get_properties()
    return self.properties
  end

  function ic:set_properties(properties)
    for key, value in pairs(properties) do
      self.properties[key] = value
    end
  end

  function ic:get_pos()
    return vector.copy(self.pos)
  end

  function ic:get_look_dir()
    return vector.copy(self.look_dir)
  end

  function ic:get_wielded_item()
    return self.inventory:get_stack("main", self.hotbar_index)
  end

  function ic:set_lighting(object)
    self.lighting = object
  end
end

foundation.com.headless.PlayerRef = PlayerRef
