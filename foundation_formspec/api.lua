--
-- This is a helper API for creating formspec elements, sometimes it gets confusing
-- interpolating items into a formspec element and you start missing commas,
-- semi-colons or even brackets in larger formspecs.
--

local Color = assert(foundation.com.Color)

--- @namespace foundation.com.formspec.api
foundation.com.formspec = foundation.com.formspec or {}

local api = {}
local vector2 = foundation.com.Vector2

-- @type Raw<T>: {
--   __raw: T,
-- }
--

local LIST_SPACING = 0.25

local function to_bool(item)
  -- a hack to quickly get a boolean from a normal value
  -- in languages that have ! for not, it looks like this !!item
  return tostring(not not item)
end

local function to_color(item)
  if type(item) == "table" then
    if item.a then
      return Color.to_string32(item)
    end
    return Color.to_string24(item)
  elseif type(item) == "function" then
    return item()
  else
    return item
  end
end

-- @private.spec to_text(String | Number | Boolean | Table | Function/0): String
local function to_text(item)
  if item == nil then
    return ""
  end

  if type(item) == "table" then
    if item.__raw then
      return item.__raw
    end
  elseif type(item) == "function" then
    return item()
  end
  return minetest.formspec_escape(tostring(item))
end

-- @private.spec maybe_rect_to_args(Table | Any): String
local function maybe_rect_to_args(arg)
  if type(arg) == "table" then
    if arg.w and arg.h then
      return arg.x .. "," .. arg.y .. "," .. arg.w .. "," .. arg.h
    elseif arg.x and arg.y then
      return arg.x .. "," .. arg.y
    else
      return arg.x
    end
  else
    return arg
  end
end

-- @spec calc_inventory_offset(size: Integer): Integer
function api.calc_inventory_offset(size)
  return size + LIST_SPACING * math.max(size, 0)
end

-- @spec calc_inventory_size(size: Integer): Integer
function api.calc_inventory_size(size)
  return size + LIST_SPACING * math.max(size - 1, 0)
end

-- Calculates the size[] that a form needs to be to contain the given inventory
-- The inventory is specified by its size (cols and rows) a vector2 is returned
-- where x is the width of the form and y is the height.
-- Note that this does not compensate for margins outside the inventory.
--
-- @spec calc_form_inventory_size(cols: Integer, rows: Integer): Vector2
function api.calc_form_inventory_size(cols, rows)
  return vector2.new(
    cols + LIST_SPACING * math.max(cols - 1, 0),
    rows + LIST_SPACING * math.max(rows - 1, 0)
  )
end

-- Utility function for specifying a text element that should be interpolated
-- raw and not escaped
--
-- @spec raw(T): Raw<T>
function api.raw(item)
  return {__raw=item}
end

-- Tells the API that the value should be replaced with whatever its expected default is
function api.default()
  return {__default=true}
end

-- @spec formspec_version(Integer): String
function api.formspec_version(version)
  return "formspec_version["..version.."]"
end

-- @spec size(w: Number, h: Number, fixed_size?: Boolean): String
function api.size(w, h, fixed_size)
  if fixed_size == nil then
    return "size["..w..","..h.."]"
  else
    return "size["..w..","..h..","..to_bool(fixed_size).."]"
  end
end

-- @spec position(x: Number, y: Number): String
function api.position(x, y)
  return "position["..x..","..y.."]"
end

-- @spec anchor(x: Number, y: Number): String
function api.anchor(x, y)
  return "anchor["..x..","..y.."]"
end

-- @spec no_prepend(): String
function api.no_prepend()
  return "no_prepend[]"
end

-- @spec real_coordinates(Boolean): String
function api.real_coordinates(is_enabled)
  return "real_coordinates["..to_bool(is_enabled).."]"
end

-- @spec container(x: Number, y: Number, Function/0): String
function api.container(x, y, callback)
  local result = "container["..x..","..y.."]"
  if callback then
    return result .. callback() .. api.container_end()
  else
    return result
  end
end

-- @spec container_end(): String
function api.container_end()
  return "container_end[]"
end

--
-- Params:
-- * `orientation` [String] - "vertical" or "horizontal"
--
-- @spec scroll_container(
--   x: Number,
--   y: Number,
--   w: Number,
--   h: Number,
--   scrollbar_id: String,
--   orientation: String,
--   scroll_factor: Number,
--   callback?: Function/0
-- ): String
function api.scroll_container(x, y, w, h, scollbar_id, orientation, scroll_factor, callback)
  scroll_factor = scroll_factor or 0.1

  local result = "scroll_container["..x..","..y..
                                 ";"..w..","..h..
                                 ";"..scollbar_id..
                                 ";"..orientation..
                                 ";"..scroll_factor.."]"

  if callback then
    return result .. callback() .. api.scroll_container_end()
  else
    return result
  end
end

function api.scroll_container_end()
  return "scroll_container_end[]"
end

function api.list(inventory_location, list_name, x, y, w, h, start_index)
  start_index = start_index or 0

  return "list["..inventory_location..
             ";"..list_name..
             ";"..x..","..y..
             ";"..w..","..h..
             ";"..start_index.."]"
end

function api.list_ring(inventory_location, list_name)
  if inventory_location and list_name then
    return "listring["..inventory_location..
                   ";"..list_name.."]"
  else
    return "listring[]"
  end
end

api.listring = api.list_ring

function api.list_colors(
  slot_bg_normal,
  slot_bg_hover,
  slot_border,
  tooltip_bgcolor,
  tooltip_fontcolor
)
  local args = to_color(slot_bg_normal)..";"..to_color(slot_bg_hover)
  if slot_border then
    args = args .. ";" .. to_color(slot_border)

    if tooltip_bgcolor then
      args = args .. ";" .. to_color(tooltip_bgcolor)

      if tooltip_fontcolor then
        args = args .. ";" .. to_color(tooltip_fontcolor)
      end
    end
  end
  return "listcolors["..args.."]"
end

api.listcolors = api.list_colors

function api.tooltip_element(gui_element_name, tooltip_text, bgcolor, fontcolor)
  local args = gui_element_name..";"..to_text(tooltip_text)

  if bgcolor then
    args = args .. ";" .. to_color(bgcolor)
    if fontcolor then
      args = args .. ";" .. to_color(fontcolor)
    end
  end

  return "tooltip["..args.."]"
end

--
--
-- @spec tooltip_area(
--   x: Number,
--   y: Number,
--   w: Number,
--   h: Number,
--   tooltip_text: String,
--   bgcolor?: Color,
--   frontcolor?: Color
-- ): String
function api.tooltip_area(x, y, w, h, tooltip_text, bgcolor, fontcolor)
  local args = x..","..y..";"..w..","..h..";"..to_text(tooltip_text)

  if bgcolor then
    args = args .. ";" .. to_color(bgcolor)
    if fontcolor then
      args = args .. ";" .. to_color(fontcolor)
    end
  end

  return "tooltip["..args.."]"
end

-- @spec image(
--   x: Number,
--   y: Number,
--   w: Number,
--   h: Number,
--   texture_name: String,
--   middle: Number | Rect
-- ): String
function api.image(x, y, w, h, texture_name, middle)
  local args = x..","..y..";"..w..","..h..";"..to_text(texture_name)

  if middle then
    args = args .. ";" .. maybe_rect_to_args(middle)
  end

  return "image[" .. args .. "]"
end

--
-- @spec animated_image(
--   x: Number,
--   y: Number,
--   w: Number,
--   h: Number,
--   name: String,
--   texture_name: String,
--   frame_count: Number,
--   frame_duration: Number,
--   frame_start: Number
-- ): String
function api.animated_image(
  x,
  y,
  w,
  h,
  name,
  texture_name,
  frame_count,
  frame_duration,
  frame_start
)
  frame_start = frame_start or 1

  return "animated_image["..x..","..y..
                       ";"..w..","..h..
                       ";"..name..
                       ";"..to_text(texture_name)..
                       ";"..frame_count..
                       ";"..frame_duration..
                       ";"..frame_start.."]"
end

-- @spec item_image(x: Number, y: Number, w: Number, h: Number, item_name: String): String
function api.item_image(x, y, w, h, item_name)
  local args =
    x..","..y..";"..
    w..","..h..";"..
    to_text(item_name)

  return "item_image["..args.."]"
end

-- @spec bg_color(bgcolor: ColorSpec, fullscreen: Boolean, fbgcolor: ColorSpec): String
function api.bg_color(bgcolor, fullscreen, fbgcolor)
  local args = to_color(bgcolor)
  if fullscreen == nil then
    args = args..";"
  else
    args = args..";"..to_bool(fullscreen)
  end
  if fbgcolor then
    args = args..";"..to_color(fbgcolor)
  else
    args = args..";"
  end
  return "bgcolor["..args.."]"
end

api.bgcolor = api.bg_color

function api.background(x, y, w,  h, texture_name, auto_clip)
  local args = x..","..y..";"..w..","..h..";"..to_text(texture_name)

  if auto_clip ~= nil then
    args = args..";"..to_bool(auto_clip)
  end
  return "background["..args.."]"
end

function api.background9(x, y, w,  h, texture_name, auto_clip, middle)
  local args = x..","..y..";"..w..","..h..";"..to_text(texture_name)

  if auto_clip == nil then
    args = args..";"
  else
    args = args..";"..to_bool(auto_clip)
  end

  if middle then
    args = args..";"..maybe_rect_to_args(middle)
  end
  return "background9["..args.."]"
end

function api.pwdfield(x, y, w, h, name, label)
  local args = x..","..y..";"..w..","..h..";"..name..";"..to_text(label)

  return "pwdfield["..args.."]"
end

function api.field_area(x, y, w, h, name, label, default)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(label)..
    ";"..to_text(default or "")

  return "field["..args.."]"
end

function api.field_simple(name, label, default)
  local args = name..
    ";"..to_text(label)..
    ";"..to_text(default or "")

  return "field["..args.."]"
end

function api.field_close_on_enter(name, should_close_on_enter)
  return "field_close_on_enter["..name..";"..to_bool(should_close_on_enter).."]"
end

-- @spec textarea(x: Number,
--                y: Number,
--                w: Number,
--                h: Number,
--                name?: String,
--                label: String,
--                default: Any): String
function api.textarea(x, y, w, h, name, label, default)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..(name or "")..
    ";"..to_text(label)..
    ";"..to_text(default or "")

  return "textarea["..args.."]"
end

function api.label(x, y, label)
  local args = x..","..y..";"..to_text(label)
  return "label["..args.."]"
end

--- @spec hypertext(x: Number, y: Number, w: Number, h: Number, name: String, text: String): String
function api.hypertext(x, y, w, h, name, text)
  local args =
    x..","..y..
    ";"..w..","..h..
    ";"..to_text(name)..
    ";"..to_text(text)

  return "hypertext["..args.."]"
end

--- @spec vertlabel(x: Number, y: Number, label: String): String
function api.vertlabel(x, y, label)
  local args = x..","..y..";"..to_text(label)
  return "vertlabel["..args.."]"
end

--- @spec button(x: Number, y: Number, w: Number, h: Number, name: String, label: String): String
function api.button(x, y, w, h, name, label)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..to_text(name)..
    ";"..to_text(label)

  return "button["..args.."]"
end

function api.image_button(
  x,
  y,
  w,
  h,
  texture_name,
  name,
  label,
  noclip,
  drawborder,
  pressed_texture_name
)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..to_text(texture_name)..
    ";"..name..
    ";"..to_text(label)

  args = args..";"
  if noclip ~= nil then
    args = args..to_bool(noclip)
  end

  args = args..";"
  if drawborder ~= nil then
    args = args..to_bool(drawborder)
  end

  args = args..";"
  if pressed_texture_name ~= nil then
    args = args..to_text(pressed_texture_name)
  end

  return "image_button["..args.."]"
end

function api.item_image_button(x, y, w, h, item_name, name, label)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..to_text(item_name)..
    ";"..name..
    ";"..to_text(label)

  return "item_image_button["..args.."]"
end

function api.button_exit(x, y, w, h, name, label)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(label)

  return "button_exit["..args.."]"
end

function api.image_button_exit(x, y, w, h, texture_name, name, label)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..to_text(texture_name)..
    ";"..name..
    ";"..to_text(label)

  return "image_button_exit["..args.."]"
end

function api.textlist(x, y, w, h, name, listitems, selected_index, is_transparent)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..name..";"

  local items = {}
  for _,item in ipairs(listitems) do
    table.insert(items, to_text(item))
  end

  args = args..table.concat(items, ",")..";"
  if selected_index then
    args = args..selected_index
  end

  args = args..";"
  if is_transparent ~= nil then
    args = args..to_bool(is_transparent)
  end

  return "textlist["..args.."]"
end

--- @spec tabheader(
---   x: Integer,
---   y: Integer,
---   w?: Integer,
---   h?: Integer,
---   name: String,
---   captions: [String],
---   current_tab_index: Integer,
---   is_transparent: Boolean,
---   draw_border: Boolean
--- ): String
function api.tabheader(x, y, w, h, name, captions, current_tab_index, is_transparent, draw_border)
  local args = x..","..y

  if w and h then
    args = args..";"..w..","..h
  elseif h then
    args = args..";"..h
  end

  args = args..";"..name

  local items = {}
  for _,item in ipairs(captions) do
    table.insert(items, to_text(item))
  end

  args = args..";"..table.concat(items, ",")..";"..current_tab_index

  args = args..";"
  if is_transparent ~= nil then
    args = args..to_bool(is_transparent)
  end

  args = args..";"
  if draw_border ~= nil then
    args = args..to_bool(draw_border)
  end

  return "tabheader["..args.."]"
end

--- @spec box(x: Number, y: Number, w: Number, h: Number, color: Color): String
function api.box(x, y, w, h, color)
  local args = x..","..y..
    ";"..w..","..h

  if color then
    args = args..";"..to_color(color)
  end

  return "box["..args.."]"
end

function api.dropdown(x, y, w, h, name, dropdown_items, selected_index, use_index_event)
  local args = x..","..y

  if w and h then
    args = args..";"..w..","..h
  else
    args = args..";"..assert(h, "expected height")
  end

  args = args..";"..name

  local items = {}
  for _,item in ipairs(dropdown_items) do
    table.insert(items, to_text(item))
  end

  args = args..";"..table.concat(items, ",")..";"..selected_index

  if use_index_event ~= nil then
    args = args..";"..to_bool(use_index_event)
  end

  return "dropdown["..args.."]"
end

function api.checkbox(x, y, name, label, is_selected)
  local args = x..","..y..
    ";"..name..
    ";"..to_text(label)

  if is_selected ~= nil then
    args = args..";"..to_bool(is_selected)
  end

  return "checkbox["..args.."]"
end

function api.scrollbar(x, y, w, h, orientation, name, value)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..orientation..
    ";"..name..
    ";"

  if value then
    args = args .. value
  end

  return "scrollbar["..args.."]"
end

function api.scrollbar_options(options)
  local args = ""

  local items = {}
  for key,value in pairs(options) do
    table.insert(items, key.."="..value)
  end
  args = args..table.concat(items,";")

  return "scrollbaroptions["..args.."]"
end

api.scrollbaroptions = api.scrollbar_options

function api.table(x, y, w, h, name, cells, selected_index)
  local args = x..","..y..
    ";"..w..","..h..
    ";"..name

  local items = {}
  for _,item in ipairs(cells) do
    table.insert(items, to_text(item))
  end

  args = args..table.concat(items, ",")..";"..selected_index

  return "table["..args.."]"
end

function api.table_options(options)
  local args = ""

  local items = {}
  for key,value in pairs(options) do
    if key == "color" or
       key == "background" or
       key == "highlight" or
       key == "highlight_text" then
      table.insert(items, key.."="..to_color(value))
    else
      table.insert(items, key.."="..value)
    end
  end
  args = args..table.concat(items,";")

  return "tableoptions["..args.."]"
end

api.tableoptions = api.table_options

function api.tablecolumns(types_and_options)
  local args = ""

  local items = {}
  for type_name,options in pairs(types_and_options) do
    local options_items = {type_name}
    for key,value in pairs(options) do
      table.insert(options_items, key.."="..to_color(value))
    end
    table.insert(items, table.concat(options_items, ","))
  end

  args = args..table.concat(items,";")

  return "tablecolumns["..args.."]"
end

local function build_style_args(selectors, properties)
  local selector_items = {}
  for name,states in pairs(selectors) do
    if foundation.com.is_table_empty(states) then
      table.insert(selector_items, name)
    else
      table.insert(selector_items, name..":"..table.concat(states,"+"))
    end
  end

  local selector = table.concat(selector_items, ",")

  local properties_items = {}
  for name, value in pairs(properties) do
    table.insert(properties_items, name.."="..value)
  end

  local props = table.concat(properties_items, ";")

  return selector..";"..props
end

function api.style(selectors, properties)
  return "style["..build_style_args(selectors, properties).."]"
end

function api.style_type(selectors, properties)
  return "style_type["..build_style_args(selectors, properties).."]"
end

function api.set_focus(name, forced)
  return "set_focus["..name..";"..to_bool(forced).."]"
end

foundation.com.formspec.api = api
