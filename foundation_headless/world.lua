--- @namespace foundation.com.headless

--- @class World
local World = foundation.com.Class:extends("foundation.com.headless.World")
do
  local ic = World.instance_class

  function ic:initialize()
    self.data = {}
  end

  function ic:set_node(pos, node)
    assert(pos, "expected position")
    assert(node, "expected node")

    --print("core.set_node", pretty_vec3(pos), pretty_node(node))

    local node_id = core.hash_node_position(pos)
    local old_entry = self.data[node_id]

    if old_entry then
      local name = core.get_name_from_content_id(old_entry.id)
      local nodedef
      if name then
        nodedef = core.registered_items[name]

        if nodedef then
          if nodedef.on_destruct then
            nodedef.on_destruct(pos)
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
          nodedef.after_destruct(pos, old_node)
        end
      end
    end

    self.data[node_id] = {
      id = core.get_content_id(node.name),
      param1 = node.param1 or 0,
      param2 = node.param2 or 0,
      meta = MetaDataRef(),
      light = 15,
    }

    local nodedef = core.registered_items[node.name]
    if nodedef then
      if nodedef.on_construct then
        nodedef.on_construct(pos)
      end
    else
      print("WARNING: node=" .. node.name .. " does not exist")
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

  function ic:get_node_light(pos)
    local entry = self.data[core.hash_node_position(pos)]

    if entry then
      return entry.light
    end
  end
end

foundation.com.headless.World = World
