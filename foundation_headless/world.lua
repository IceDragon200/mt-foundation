--- @namespace foundation.com.headless

local DNR_VALUES = {
  {4250.0 + 125.0, 175.0},
  {4500.0 + 125.0, 175.0},
  {4750.0 + 125.0, 250.0},
  {5000.0 + 125.0, 350.0},
  {5250.0 + 125.0, 500.0},
  {5500.0 + 125.0, 675.0},
  {5750.0 + 125.0, 875.0},
  {6000.0 + 125.0, 1000.0},
  {6250.0 + 125.0, 1000.0},
}

local function time_to_daynight_ratio(time_of_day, smooth)
  local t = time_of_day
  if t < 0.0 then
    t = t + (math.floor(-t) / 24000) * 24000.0
  end

  if t >= 24000.0 then
    t = t - (math.floor(t) / 24000) * 24000.0;
  end

  if t > 12000.0 then
    t = 24000.0 - t
  end

  if not smooth then
    local lastt = DNR_VALUES[1][1]
    local t0
    local switch_t
    for i = 2, 9 do
      t0 = DNR_VALUES[i][1]
      switch_t = (t0 + lastt) / 2.0
      lastt = t0
      if switch_t > t then
        return DNR_VALUES[i][2]
      end
    end

    return 1000
  end

  if t <= 4625.0 then -- 4500 + 125
    return DNR_VALUES[0][2]
  elseif t >= 6125.0 then -- 6000 + 125
    return 1000
  end

  local td0
  local f
  for i = 1, 9 do
    if DNR_VALUES[i][1] > t then
      td0 = DNR_VALUES[i][1] - DNR_VALUES[i - 1][1]
      f = (t - DNR_VALUES[i - 1][1]) / td0
      return f * DNR_VALUES[i][2] + (1.0 - f) * DNR_VALUES[i - 1][2]
    end
  end

  return 1000
end

local function pretty_node(node)
  return node.name .. "[" .. (node.param1 or "nil") .. "," .. (node.param2 or "nil") .. "]"
end

local function pretty_vec3(vec3)
  return "(" .. vec3.x .. "," .. vec3.y .. "," .. vec3.z .. ")"
end

--- @class World
local World = foundation.com.Class:extends("foundation.com.headless.World")
do
  local ic = World.instance_class

  function ic:initialize()
    self.g_object_id = 0

    self._removed_saos = {}
    self.saos = {}
    self.data = {}
  end

  function ic:set_node(pos, node)
    assert(pos, "expected position")
    assert(node, "expected node")

    -- print("core.set_node", pretty_vec3(pos), pretty_node(node))

    local node_id = core.hash_node_position(pos)
    local old_entry = self.data[node_id]

    if old_entry then
      local name = core.get_name_from_content_id(old_entry.id)
      local nodedef
      if name then
        nodedef = core.registered_items[name]

        if nodedef then
          if nodedef.on_destruct then
            nodedef.on_destruct(vector.copy(pos))
          end
        end
      end

      self.data[node_id] = nil

      if nodedef then
        if nodedef.after_destruct then
          local old_node = {
            name = name,
            param1 = old_entry.param1,
            param2 = old_entry.param2,
          }
          nodedef.after_destruct(vector.copy(pos), old_node)
        end
      end
    end

    local entry = {
      id = core.get_content_id(node.name),
      param1 = node.param1 or 0,
      param2 = node.param2 or 0,
      meta = MetaDataRef(),
      light = 15,
    }

    -- if node.name ~= core.get_name_from_content_id(entry.id) then
    --   error("sanity check failed, content id did not resolve to expected name expected=" .. node.name .. " got=" .. core.get_name_from_content_id(entry.id))
    -- end

    self.data[node_id] = entry

    local nodedef = core.registered_items[node.name]
    if nodedef then
      if nodedef.on_construct then
        nodedef.on_construct(vector.copy(pos))
      end
    else
      core.log("warning", "node=" .. node.name .. " does not exist")
    end
  end

  ic.add_node = ic.set_node

  --- @spec bulk_set_node(Vector3[], node: NodeRef): void
  function ic:bulk_set_node(positions, node)
    for i,pos in ipairs(positions) do
      self:set_node(pos, node)
    end
  end

  function ic:swap_node(pos, node)
    -- print("core.swap_node", pretty_vec3(pos), pretty_node(node), debug.traceback())
    local entry = self.data[core.hash_node_position(pos)]
    if not entry then
      entry = {
        id = core.get_content_id("air"),
        param1 = 0,
        param2 = 0,
        meta = MetaDataRef(),
        light = 15
      }
    end

    if node.name then
      entry.id = core.get_content_id(node.name)
    end

    if node.param1 then
      entry.param1 = node.param1
    end

    if node.param2 then
      entry.param2 = node.param2
    end
  end

  function ic:get_biome_data(pos)
    return {
      biome = 0,
      heat = 0,
      humidity = 0,
    }
  end

  --- @spec #get_node_raw(x: Number, y: Number, z: Number):
  ---   (content_id: Number, param1: Number, param2: Number, pos_ok: Boolean)
  function ic:get_node_raw(x, y, z)
    local entry = self.data[core.hash_node_position({ x = x, y = y, z = z })]

    if entry then
      return entry.id, entry.param1, entry.param2, true
    end
    return 127, 0, 0, false
  end

  --- @spec #get_node(Vector3): NodeRef
  function ic:get_node(pos)
    local entry = self.data[core.hash_node_position(pos)]

    if entry then
      return {
        name = assert(core.get_name_from_content_id(entry.id)),
        param1 = entry.param1,
        param2 = entry.param2,
      }
    end

    return { name = "ignore", param1 = 0, param2 = 0 }
  end

  --- @spec #get_node_or_nil(Vector3): NodeRef | nil
  function ic:get_node_or_nil(pos)
    local node = self:get_node(pos)

    if node.name == "ignore" then
      return nil
    end

    return node
  end

  function ic:get_meta(pos)
    local entry = self.data[core.hash_node_position(pos)]

    if entry then
      return entry.meta
    end

    error("get_meta/1: undefined behaviour")
  end

  function ic:get_node_light(pos, timeofday)
    local entry = self.data[core.hash_node_position(pos)]

    if entry then
      return entry.light
    end

    return 0
  end

  function ic:get_natural_light(pos, timeofday)
    local entry = self.data[core.hash_node_position(pos)]

    if entry then
      local daylight = entry.param1 % 0xf
      if daylight ~= 0 then
        local time_of_day
        if timeofday then
          time_of_day = math.floor(24000 * timeofday) % 24000
        else
          time_of_day = 12000
        end

        local dnr = time_to_daynight_ratio(time_of_day, true)

        if daylight == math.floor(entry.param1 / 16) then
          --- @TODO actually calculate some daylight
          daylight = 12
        end

        return math.floor(dnr * daylight / 1000)
      end
    end

    return 0
  end

  function ic:update(dtime)
    local pos
    local pos2
    local pos3
    local dir
    local node
    local nodedef
    for id, sao in pairs(self.saos) do
      if sao.removed then
        self._removed_saos[id] = true
      else
        pos = sao:get_pos()
        sao:update_physics(dtime)
        pos2 = sao:get_pos()
        dir = vector.direction(pos, pos2)

        if dir.y > 0 then
          --- entity is ascending
        elseif dir.y < 0 then
          --- entity is descending
          pos3 = vector.copy(pos2)
          node = self:get_node_or_nil(pos3)
          if node then
            nodedef = core.registered_nodes[node.name]
            if nodedef.collision_box then
              -- TODO
            end
          end
        end
        sao:update(dtime)
      end

      if sao.removed then
        self._removed_saos[id] = true
      end
    end

    if next(self._removed_saos) then
      for id, _ in pairs(self._removed_saos) do
        self.saos[id] = nil
      end
      self._removed_saos = {}
    end
  end

  local INITIAL_PROPERTY_KEY = {
    "hp_max",
    "breath_max",
    "physical",
    "collide_with_objects",
    "collisionbox",
    "selectionbox",
    "pointable",
    "visual",
    "mesh",
    "visual_size",
    "textures",
    "colors",
    "spritediv",
    "initial_sprite_basepos",
    "is_visible",
    "makes_footstep_sound",
    "stepheight",
    "eye_height",
    "automatic_rotate",
    "automatic_face_movement_dir",
    "backface_culling",
    "glow",
    "nametag",
    "nametag_color",
    "automatic_face_movement_max_rotation_per_sec",
    "infotext",
    "static_save",
    "wield_item",
    "zoom_fov",
    "use_texture_alpha",
    "shaded",
    "damage_texture_modifier",
    "show_on_minimap",
  }

  function ic:add_entity(pos, name, staticdata)
    staticdata = staticdata or ""
    assert(type(name) == "string", "expected a name")
    self.g_object_id = self.g_object_id + 1
    local id = self.g_object_id
    local lua_entity_def = core.registered_entities[name]
    local entity = setmetatable({}, { __index = lua_entity_def })
    local sao = foundation.com.headless.LuaEntity:new(entity, pos)
    entity.object = sao
    self.saos[id] = sao

    for _, key in ipairs(INITIAL_PROPERTY_KEY) do
      if lua_entity_def[key] then
        print("WARN: lua entity name=" .. name .. " contains key=" .. key .. " which is an initial property")
        sao._properties[key] = lua_entity_def[key]
      end
    end

    if lua_entity_def.initial_properties then
      sao._properties = foundation.com.table_merge(
        sao._properties,
        lua_entity_def.initial_properties
      )
    end

    if lua_entity_def.on_activate then
      lua_entity_def.on_activate(entity, staticdata, 0)
    end
    return sao
  end

  function ic:get_objects_inside_radius(center, radius)
    local result = {}
    local i = 0
    for _id, sao in pairs(self.saos) do
      if vector.distance(center, sao._pos) <= radius then
        i = i + 1
        result[i] = sao
      end
    end
    return result
  end
end

foundation.com.headless.World = World
