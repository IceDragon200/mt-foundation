local List = assert(foundation.com.List)

local apak = foundation.com.apak

local pack_list
local unpack_list
local ascii_pack_list
local ascii_unpack_list
local ascii_pack_list_state
local ascii_unpack_list_state

local function build_pack_state()
  return {
    length = 0,
    -- item
    item_id = 0,
    --- used by pack
    item_name_to_id = {},
    --- used by unpack
    id_to_item_name = {},
    -- meta
    meta_id = 0,
    --- used by pack
    meta_field_name_to_id = {},
    --- used by unpack
    id_to_meta_field_name = {},
    -- stacks
    ids = {},
    counts = {},
    wears = {},
    meta_fields = {}, -- just the key-value fields
    inventories = {}, -- unused currently
  }
end

-- @spec pack_list(ItemStack[]): InventoryPackerState
function pack_list(list)
  local state = build_pack_state()

  local item_name
  local item_id
  local meta
  local meta_table
  local meta_fields
  local meta_field_id

  for index, item_stack in pairs(list) do
    state.length = state.length + 1

    if not item_stack:is_empty() then
      meta = item_stack:get_meta()
      item_name = item_stack:get_name()

      if not state.item_name_to_id[item_name] then
        state.item_id = state.item_id + 1
        state.item_name_to_id[item_name] = state.item_id
        state.id_to_item_name[state.item_name_to_id[item_name]] = item_name
      end

      item_id = state.item_name_to_id[item_name]

      state.ids[index] = item_id
      state.counts[index] = item_stack:get_count()
      state.wears[index] = item_stack:get_wear()

      meta_table = meta:to_table()

      if next(meta_table.fields) then
        meta_fields = {}

        for key, value in pairs(meta_table.fields) do
          if not state.meta_field_name_to_id[key] then
            state.meta_id = state.meta_id + 1
            state.meta_field_name_to_id[key] = state.meta_id
            state.id_to_meta_field_name[state.meta_field_name_to_id[key]] = key
          end

          meta_field_id = state.meta_field_name_to_id[key]

          meta_fields[meta_field_id] = value
        end

        state.meta_fields[index] = meta_fields
      end
    else
      state.counts[index] = 0
    end
  end

  return state
end

-- @spec unpack_list(InventoryPackerState): ItemStack[]
function unpack_list(state)
  assert(state, "expected inventory pack state")

  local list = {}
  local item_id
  local item_stack
  local meta
  local meta_fields
  local field_name

  if state.length > 0 then
    for index = 1,state.length do
      if state.counts[index] > 0 then
        item_id = state.ids[index]

        item_stack = ItemStack({
          name = state.id_to_item_name[item_id],
          count = state.counts[index],
          wear = state.wears[index],
        })

        meta_fields = {}

        if state.meta_fields[index] then
          for id, value in pairs(state.meta_fields[index]) do
            field_name = state.id_to_meta_field_name[id]
            meta_fields[field_name] = value
          end
        end

        meta = item_stack:get_meta()
        meta:from_table({
          fields = meta_fields,
        })
        list[index] = item_stack
      else
        list[index] = ItemStack()
      end
    end
  end

  return list
end

if apak then
  local ascii_pack = assert(apak.pack)
  local pack_array = assert(apak.pack_array)
  local pack_int = assert(apak.pack_int)
  local pack_nil = assert(apak.pack_nil)

  -- @spec ascii_pack_list_state(InventoryPackerState): String
  function ascii_pack_list_state(state)
    local list = List:new()

    list:push("APAK") -- header
    list:push(pack_int(1)) -- version
    list:push("INAM")
    list:push(pack_array(state.id_to_item_name)) -- pack the item names
    list:push("MNAM")
    list:push(pack_array(state.id_to_meta_field_name)) -- pack the meta field names
    list:push("LIST")
    list:push(pack_int(state.length)) -- length

    list:push("ids_")
    if state.length > 0 then
      local item_id

      for index = 1,state.length do
        item_id = state.ids[index]

        if item_id then
          list:push(pack_int(item_id))
        else
          list:push(pack_nil(nil))
        end
      end
    end

    list:push("cnt_")
    if state.length > 0 then
      local count

      for index = 1,state.length do
        count = state.counts[index]

        if count then
          list:push(pack_int(count))
        else
          list:push(pack_nil(nil))
        end
      end
    end

    list:push("wear")
    if state.length > 0 then
      local wear

      for index = 1,state.length do
        wear = state.wears[index]

        if wear then
          list:push(pack_int(wear))
        else
          list:push(pack_nil(nil))
        end
      end
    end

    list:push("mtfl")
    if state.length > 0 then
      local fields

      for index = 1,state.length do
        fields = state.meta_fields[index]

        if fields then
          list:push(ascii_pack(fields))
        else
          list:push(pack_nil(nil))
        end
      end
    end

    return list:flatten_iodata():join()
  end

  function ascii_pack_list(list)
    return ascii_pack_list_state(pack_list(list))
  end

  local ascii_file_unpack = assert(foundation.com.ascii_file_unpack)
  local StringBuffer = assert(foundation.com.StringBuffer)

  function ascii_unpack_list_state(blob)
    local buffer = StringBuffer:new(blob, 'r')
    local state = build_pack_state()

    assert(buffer:read(4) == 'APAK', "expected APAK header")
    assert(ascii_file_unpack(buffer) == 1, "expected to be version 1")
    assert(buffer:read(4) == 'INAM', "expected id names section")
    state.id_to_item_name = ascii_file_unpack(buffer)
    assert(buffer:read(4) == 'MNAM', "expected meta field names section")
    state.id_to_meta_field_name = ascii_file_unpack(buffer)
    assert(buffer:read(4) == 'LIST', "expected list section")
    state.length = ascii_file_unpack(buffer)
    assert(buffer:read(4) == 'ids_', "expected ids_ section")
    if state.length > 0 then
      for index = 1,state.length do
        state.ids[index] = ascii_file_unpack(buffer)
      end
    end

    assert(buffer:read(4) == 'cnt_', "expected cnt_ section")
    if state.length > 0 then
      for index = 1,state.length do
        state.counts[index] = ascii_file_unpack(buffer)
      end
    end

    assert(buffer:read(4) == 'wear', "expected wear section")
    if state.length > 0 then
      for index = 1,state.length do
        state.wears[index] = ascii_file_unpack(buffer)
      end
    end

    assert(buffer:read(4) == 'mtfl', "expected mtfl section")
    if state.length > 0 then
      for index = 1,state.length do
        state.meta_fields[index] = ascii_file_unpack(buffer)
      end
    end

    return state
  end

  function ascii_unpack_list(blob)
    return unpack_list(ascii_unpack_list_state(blob))
  end
end

foundation.com.InventoryPacker = {
  pack_list = pack_list,
  unpack_list = unpack_list,
  ascii_pack_list = ascii_pack_list,
  ascii_unpack_list = ascii_unpack_list,
  ascii_pack_list_state = ascii_pack_list_state,
  ascii_unpack_list_state = ascii_unpack_list_state,
}
