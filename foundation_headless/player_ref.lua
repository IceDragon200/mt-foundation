--- @namespace foundation.com.headless

--- @class PlayerRef
local PlayerRef = foundation.com.headless.ObjectRef:extends("foundation.com.headless.PlayerRef")
do
  local ic = PlayerRef.instance_class

  function ic:initialize(name)
    ic._super.initialize(self)

    self._breath = core.PLAYER_MAX_BREATH_DEFAULT
    self._name = name
    self._hotbar_index = 1
    self._inventory = foundation.com.headless.InvRef:new()
    self._meta = foundation.com.headless.MetaDataRef:new()
    self._hud_id = 0
    self._hud = {}
    self._hud_flags = {}
    self._physics_overrides = {}
    self._armor_groups = {}
    self._lighting = {}
    self._properties = {
      eye_height = 1.625,
      breath_max = core.PLAYER_MAX_BREATH_DEFAULT,
    }
    self._look_dir = vector.new(0, 0, 0)

    self._inventory:set_size("main", 8)
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
    return self._meta
  end

  function ic:get_inventory()
    return self._inventory
  end

  function ic:set_inventory_formspec(formspec)
    minetest.log("info", "set_inventory_formspec/1 name=" .. self._name)
    self._inventory_formspec = formspec

    local listeners = self._listeners["set_inventory_formspec"]

    if listeners then
      for callback, _ in pairs(listeners) do
        callback(self, self._inventory_formspec)
      end
    end
  end

  function ic:get_inventory_formspec()
    return self._inventory_formspec
  end

  function ic:hud_set_hotbar_image(image)
    self._hotbar_image = image
  end

  function ic:hud_set_hotbar_selected_image(image)
    self._hotbar_selected_image = image
  end

  function ic:hud_set_hotbar_itemcount(count)
    self._hotbar_itemcount = count
  end

  function ic:get_player_name()
    return self._name
  end

  function ic:hud_add(def)
    --print("TODO: hud_add", dump(def))
    self._hud_id = self._hud_id + 1
    self._hud[self._hud_id] = def
    return self._hud_id
  end

  function ic:hud_get_flags()
    return self._hud_flags
  end

  function ic:hud_set_flags(flags)
    self._hud_flags = flags
  end

  function ic:set_physics_override(physics_overrides)
    self._physics_overrides = physics_overrides
  end

  function ic:get_physics_override()
    return self._physics_overrides
  end

  function ic:get_breath()
    return self._breath
  end

  function ic:get_armor_groups()
    return self._armor_groups
  end

  function ic:get_look_dir()
    return vector.copy(self._look_dir)
  end

  function ic:get_wielded_item()
    return self._inventory:get_stack("main", self._hotbar_index)
  end

  function ic:set_lighting(object)
    self._lighting = object
  end

  function ic:is_player()
    return true
  end
end

foundation.com.headless.PlayerRef = PlayerRef
