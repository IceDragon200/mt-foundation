-- @namespace foundation.com.schematic_helpers
foundation.com.schematic_helpers = {}

--
-- @type YSliceSchematic: {
--   size = Vector3,
--   data = {
--     { name = String, param1 = Integer, param2 = Integer, prob = Integer, force_place = Boolean }
--   },
--   yslice_prob = {
--     { ypos = Integer, prob = Integer }
--   }
-- }
--

-- It's like the same schematic format, but the data is down bottom up
-- that is y,z,x.
-- While minetest's schematics expect z,y,x
--
-- @spec from_y_slices(YSliceSchematic): Schematic
function foundation.com.schematic_helpers.from_y_slices(schematic)
  local result = {}
  result.size = schematic.size
  result.data = {}
  result.yslice_prob = schematic.yslice_prob

  local source_layer_size = result.size.z * result.size.x
  local target_layer_size = result.size.y * result.size.x

  for index,value in ipairs(schematic.data) do
    local i = index - 1
    local y = math.floor(i / source_layer_size)
    local x = i % result.size.x
    local z = math.floor(i / result.size.x) % result.size.z

    local new_index = target_layer_size * z + y * result.size.x + x

    result.data[1 + new_index] = value
  end

  assert(#result.data == #schematic.data, "data size mismatch expected=" .. #schematic.data .. " got=" .. #result.data)

  return result
end

--
-- The Builder is a more progmatic way to build structures that can be converted to a schematic
-- you don't have to calculate the size upfront as that can be calculated at the end,
-- so you can build to your hearts content and then cry about the data usage afterwards.
--
local Builder = {}
Builder.instance_class = {}

local function table_merge(...)
  local result = {}
  for _,t in ipairs({...}) do
    for key,value in pairs(t) do
      result[key] = value
    end
  end
  return result
end

local function table_equals(a, b)
  local merged = table_merge(a, b)
  for key,_ in pairs(merged) do
    if a[key] ~= b[key] then
      return false
    end
  end
  return true
end

--
-- Create a new Builder instance
--
-- @spec .new(): Builder
function Builder:new(...)
  local obj = {}
  setmetatable(obj, { __index = Builder.instance_class })
  obj:initialize(...)
  return obj
end

local ic = Builder.instance_class

--
-- Initialize a builder's state
--
-- @spec #initialize(): void
function ic:initialize()
  self.palette_index = 0
  self.palette = {}

  self.data = {}
end

--
-- Clears any written data in the builder.
-- This is normally used for recycling the same builder with it's palette intact.
--
-- @spec #clear_data(): self
function ic:clear_data()
  self.data = {}
  return self
end

--
-- Clears all data and palette information in the builder.
--
-- @spec #clear(): self
function ic:clear()
  self:clear_data()
  self.palette = {}
  self.palette_index = 0
  return self
end

--
-- Calculates and retrieves the size and extents of the builder's data.
--
-- @spec #get_size(): (Vector3, Extents)
function ic:get_size()
  local x1 = 0
  local x2 = 0
  local y1 = 0
  local y2 = 0
  local z1 = 0
  local z2 = 0

  for node_id,_swatch_id in pairs(self.data) do
    local pos = minetest.get_position_from_hash(node_id)

    if x1 > pos.x then
      x1 = pos.x
    end

    if pos.x > x2 then
      x2 = pos.x
    end

    if y1 > pos.y then
      y1 = pos.y
    end

    if pos.y > y2 then
      y2 = pos.y
    end

    if z1 > pos.z then
      z1 = pos.z
    end

    if pos.z > z2 then
      z2 = pos.z
    end
  end

  return {
    x = x2 - x1 + 1,
    y = y2 - y1 + 1,
    z = z2 - z1 + 1,
  }, {
    x1 = x1,
    x2 = x2,
    y1 = y1,
    y2 = y2,
    z1 = z1,
    z2 = z2,
  }
end

--
-- Add the given node to the palette and return a swatch_id
-- The swatch_id is then used by add_node and it's derivitives to
-- add nodes to the builder data.
--
-- @spec #add_palette_node(node: NodeDef): (swatch_id: Integer)
function ic:add_palette_node(node)
  self.palette_index = self.palette_index + 1
  local swatch_id = self.palette_index
  return self:put_palette_node(swatch_id, node)
end

--
-- Add or replace an existing swatch with the given node data
--
-- @spec #put_palette_node(swatch_id: Integer, node: NodeDef): (swatch_id: Integer)
function ic:put_palette_node(swatch_id, node)
  self.palette[swatch_id] = node
  return swatch_id
end

--
-- Retrieve the node or nil registered at the specific swatch_id
--
-- @spec #get_palette_node(swatch_id: Integer): NodeDef | nil
function ic:get_palette_node(swatch_id)
  return self.palette[swatch_id]
end

--
-- Maybe add a palette node if a matching one can't be found
--
-- @spec #find_or_add_palette_node(node: NodeDef): (swatch_id: Integer)
function ic:find_or_add_palette_node(node)
  for swatch_id,other_node in pairs(self.palette) do
    if table_equals(node, other_node) then
      return swatch_id
    end
  end
  return self:add_palette_node(node)
end

--
-- Place a swatch in the builder's data at the specified position
--
-- @spec #put_node(pos: Vector3, swatch_id: Integer): self
function ic:put_node(pos, swatch_id)
  if swatch_id then
    assert(self.palette[swatch_id], "expected node to be registered for swatch")
    self.data[minetest.hash_node_position(pos)] = swatch_id
  else
    self.data[minetest.hash_node_position(pos)] = nil
  end
  return self
end

--
-- Retrieve swatch_id at specifed position
--
-- @spec #get_swatch_at(pos: Vector3): (swatch_id: Integer | nil)
function ic:get_swatch_at(pos)
  return self.data[minetest.hash_node_position(pos)]
end

local function calculate_range(pos1, pos2)
  local x1 = math.min(pos1.x, pos2.x)
  local x2 = math.max(pos1.x, pos2.x)
  local y1 = math.min(pos1.y, pos2.y)
  local y2 = math.max(pos1.y, pos2.y)
  local z1 = math.min(pos1.z, pos2.z)
  local z2 = math.max(pos1.z, pos2.z)

  return x1, x2, y1, y2, z1, z2
end

--
-- Fill all nodes within the specified range with swatch_id
--
-- @spec #fill_range(pos1: Vector3, pos2: Vector3, swatch_id: Integer | nil): self
function ic:fill_range(pos1, pos2, swatch_id)
  local x1, x2, y1, y2, z1, z2 = calculate_range(pos1, pos2)

  for y = y1,y2 do
    for z = z1,z2 do
      for x = x1,x2 do
        self:put_node({x=x,y=y,z=z}, swatch_id)
      end
    end
  end
  return self
end

--
-- Copy data from one builder into the current at specified position (pos)
-- Optionally a range can be specified (sel_pos1 and sel_pos2) to pick a specific
-- section of data to copy
--
-- @spec #blit(pos: Vector3, builder: Builder, sel_pos1: Vector3 | nil, sel_pos2: Vector3 | nil): self
function ic:blit(pos, builder, sel_pos1, sel_pos2)
  local other_swatch_map = {}

  if sel_pos1 and sel_pos2 then
    local x1, x2, y1, y2, z1, z2 = calculate_range(sel_pos1, sel_pos2)

    for y = y1,y2 do
      for z = z1,z2 do
        for x = x1,x2 do
          local swatch_id = builder:get_node({x=x,y=y,z=z})

          if swatch_id then
            if not other_swatch_map[swatch_id] then
              other_swatch_map[swatch_id] = self:find_or_add_palette_node(builder.palette[swatch_id])
            end

            local old_pos = minetest.get_position_from_hash(node_id)
            -- adjust selected position
            old_pos.x = old_pos.x - x1
            old_pos.y = old_pos.y - y1
            old_pos.z = old_pos.z - z1

            local new_pos = vector.add(pos, old_pos)

            self:put_node(new_pos, other_swatch_map[swatch_id])
          end
        end
      end
    end
  else
    -- no specific selection was denoted, so assuming all the data should be copied
    for node_id,swatch_id in builder.data do
      if not other_swatch_map[swatch_id] then
        other_swatch_map[swatch_id] = self:find_or_add_palette_node(builder.palette[swatch_id])
      end

      local old_pos = minetest.get_position_from_hash(node_id)

      local new_pos = vector.add(pos, old_pos)

      self:put_node(new_pos, other_swatch_map[swatch_id])
    end
  end
  return self
end

--
-- Converts the built data to a y-slice style schematic
--
-- @spec #to_yslice_schematic(): YSliceSchematic
function ic:to_yslice_schematic()
  -- first up we need the size and extents
  -- the extents are used to loop over the data and filling in air
  -- while the size is placed into the schematic
  local size, extents = self:get_size()

  -- air node
  local air = {name = "air", prob = 0}

  -- the resulting y_slice_schematic
  local result = {
    size = size,
    data = {},
  }

  -- start looping from y first
  for y = extents.y1,extents.y2 do
    -- then z
    for z = extents.z1,extents.z2 do
      -- finally x
      for x = extents.x1,extents.x2 do
        -- create the position vector
        local pos = {x=x,y=y,z=z}
        -- retrieve the swatch entry, if any
        local swatch_id = self:get_node(pos)

        -- calculate the data index
        -- add 1 to deal with lua's annoying 1 index
        -- also it needs to normalize the position back to the 0 coord
        local data_index = 1 + (pos.y - extents.y1) * size.z * size.x +
                               (pos.z - extents.z1) * size.x +
                               (pos.x - extents.x1)

        assert(data_index > 0)

        if swatch_id then
          -- the swatch exists, take the node from the palette
          result.data[data_index] = assert(self.palette[swatch_id])
        else
          -- otherwise set the data to air
          result.data[data_index] = air
        end
      end
    end
  end

  return result
end

--
-- Converts the builder data to a minetest schematic
--
-- @spec #to_schematic(): Schematic
function ic:to_schematic()
  local y_slice_schematic = self:to_yslice_schematic()

  return foundation.com.schematic_helpers.from_y_slices(y_slice_schematic)
end

foundation.com.schematic_helpers.Builder = Builder

--
-- Creates a new builder instance
--
-- @spec build(): Builder
function foundation.com.schematic_helpers.build()
  return foundation.com.schematic_helpers.Builder:new()
end
