--- @namespace foundation.com

local UTF8 = foundation.com.utf8
local string_split = assert(foundation.com.string_split)

--- Token type from parse_chat_command_params/1
--- @type ChatCommandToken: {
---   (type: String),
---   (value: Any),
---   { pos = Integer }
--- }

local DQUOTE_ESCAPES = {
  s = " ",
  n = "\n",
  r = "\r",
}

local function parse_dquote(i, len, codepoints)
  local s = i
  local e
  local c
  local r = {}
  local ri = 0

  assert(codepoints[i] == "\"")
  while i <= len do
    i = i + 1
    c = codepoints[i]
    if c == "\"" then
      i = i + 1
      return table.concat(r), i
    elseif "\\" then
      i = i + 1
      c = codepoints[i]
      e = DQUOTE_ESCAPES[c]
      if not e then
        e = c
      end
      ri = ri + 1
      r[ri] = e
    else
      ri = ri + 1
      r[ri] = c
    end
  end

  return nil, s
end

local function parse_squote(i, len, codepoints)
  local s = i
  local e
  local c
  local r = {}
  local ri = 0

  assert(codepoints[i] == "'")
  while i <= len do
    i = i + 1
    c = codepoints[i]
    if c == "'" then
      i = i + 1
      return table.concat(r), i
    else
      ri = ri + 1
      r[ri] = c
    end
  end

  return nil, s
end

local function parse_atom(i, len, codepoints)
  local s = i
  local c

  while i <= len do
    c = codepoints[i]
    if c == " " or c == "," or c == "'" or c == "\"" then
      break
    else
      i = i + 1
    end
  end

  if i > s then
    return table.concat(codepoints, "", s, i - 1), i
  end

  return nil, i
end

--- Foundation's helper function for general chat command parsing.
--- Note that is does not automatically handle numeric items, you will need to cast them yourself.
---
--- @since "3.1.0"
--- @spec parse_chat_command_params(params: String): ChatCommandToken[]
function foundation.com.parse_chat_command_params(params)
  local codepoints
  if UTF8 then
    codepoints = UTF8.codepoints(params)
  else
    -- try your damn hardest not to rely on utf8 at this point
    codepoints = string_split(params, "")
  end

  -- now just a disclaimer, if for some reason you did not have UTF8, you're getting
  -- quite the mess of characters, but well assume we're dealing with ascii, otherwise
  -- this is completely botched.

  -- So, what are our rules of chat parameters?
  -- Chat parameters typically space delimited, where tuples are comma seperated
  -- otherwise everything else is just an atom/word component, which includes numbers
  -- output is strictly strings, it's up the user to cast the components as needed.
  local i = 1
  local e = 0
  local len = #codepoints
  local c
  local result = {}
  local result_i = 0
  local v
  local tuple = {}
  local tuple_i = 0

  while i <= len do
    c = codepoints[i]
    if c == " " or c == "\n" or c == "\r" then
      -- we can safely skip spaces
      if tuple_i > 0 then
        result_i = result_i + 1
        result[result_i] = { size = tuple_i, data = tuple }
        tuple = {}
        tuple_i = 0
      end
      i = i + 1
    elseif c == "," then
      -- keep going
      if tuple_i < 1 then
        tuple = { nil }
        tuple_i = 1
      end
      i = i + 1
    else
      if c == "\"" then
        v, e = parse_dquote(i, len, codepoints)
        if not v then
          break
        end
      elseif c == "'" then
        v, e = parse_squote(i, len, codepoints)
        if not v then
          break
        end
      else
        v, e = parse_atom(i, len, codepoints)
      end
      tuple_i = tuple_i + 1
      tuple[tuple_i] = v
      i = e
    end
  end

  if tuple_i > 0 then
    result_i = result_i + 1
    result[result_i] = { size = tuple_i, data = tuple }
    tuple = {}
    tuple_i = 0
  end

  local rest

  if i > 0 then
    rest = table.concat(codepoints, "", i)
  else
    rest = ""
  end

  return result, rest
end

--- Helper function for recovering some amount of hp
---
--- It will return the amount that was actually recovered
---
--- A return of 0 means nothing was recovered
---
--- @mutative entity
--- @spec recover_hp(entity: ObjectRef, amount: Integer, reason: Any): Integer
function foundation.com.recover_hp(entity, amount, reason)
  local hp = entity:get_hp()
  local hp_max = entity:get_properties().hp_max

  local used_amount = math.min(hp + amount, hp_max) - hp
  if used_amount > 0 then
    entity:set_hp(hp + used_amount, reason)
  end
  return used_amount
end

--- A copy of luanti default's get_inventory_drops
---
--- Adds an inventory's items to a given drops list
---
--- @mutative drops
--- @spec get_inventory_drops(pos: Vector3, inventory: InventoryRef, drops: ItemStack[]): void
function foundation.com.get_inventory_drops(pos, inventory, drops)
  local meta = tetra.get_meta(pos)
  local inv = meta:get_inventory()
  local n = #drops
  for i = 1, inv:get_size(inventory) do
    local stack = inv:get_stack(inventory, i)
    if stack:get_count() > 0 then
      n = n + 1
      drops[n] = stack:to_table()
    end
  end
end

--- Copies a NodeRef, you could also just use table_copy, but this guarantees only the NodeRef
--- fields are being copied and set.
---
--- @since "2.1.0"
--- @spec copy_node(node: NodeRef): NodeRef
function foundation.com.copy_node(node)
  return {
    name = node.name,
    param1 = node.param1,
    param2 = node.param2,
  }
end

--- Formats a NodeRef as a string for logging purposes
---
--- @since "2.1.0"
--- @spec node_to_string(node?: NodeRef): String
function foundation.com.node_to_string(node)
  if node then
    return node.name .. "," .. (node.param1 or "N/A") .. "," .. (node.param2 or "N/A")
  else
    return "N/A,N/A,N/A"
  end
end
