--
-- This is a helper API for creating formspec elements, sometimes it gets confusing
-- interpolating items into a formspec element and you start missing commas,
-- semi-colons or even brackets in larger formspecs.
--
foundation.com.formspec = {}

local api = {}

local function to_bool(item)
  -- a hack to quickly get a boolean from a normal value
  -- in languages that have ! for not, it looks like this !!item
  return not not item
end

local function to_color(item)
  if type(item) == "table" then
    -- TODO: find out what the expected format is for colours
  elseif type(item) == "function" then
    return item()
  else
    return item
  end
end

local function to_text(item)
  if type(item) == "table" then
    if item.__raw then
      return item.__raw
    end
  elseif type(item) == "function" then
    return item()
  end
  return minetest.formspec_escape(tostring(item))
end

-- Utility function for specifying a text element that should be interpolated
-- raw and not escaped
function api.raw(item)
  return {__raw=item}
end

-- Tells the API that the value should be replaced with whatever it's expected default is
function api.default()
  return {__default=true}
end

function api.formspec_version(version)
  return "formspec_version["..version.."]"
end

function api.size(w, h, fixed_size)
  if fixed_size == nil then
    return "size["..w..","..h.."]"
  else
    return "size["..w..","..h..","..to_bool(fixed_size).."]"
  end
end

function api.position(x, y)
  return "position["..x..","..y.."]"
end

function api.anchor(x, y)
  return "anchor["..x..","..y.."]"
end

function api.no_prepend()
  return "no_prepend[]"
end

function api.real_coordinates(is_enabled)
  return "real_coordinates["..to_bool(is_enabled).."]"
end

function api.container(x, y, callback)
  local result = "container["..x..","..y.."]"
  if callback then
    return result .. callback() .. api.container_end()
  else
    return result
  end
end

function api.container_end()
  return "container_end[]"
end

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

function api.list_colors(slot_bg_normal, slot_bg_hover, slot_border, tooltip_bgcolor, tooltip_fontcolor)
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

function api.image(x, y, w, h, texture_name)
  return "image["..x..","..y..";"..w..","..h..";"..to_text(texture_name).."]"
end

function api.animated_image(x, y, w, h, name, texture_name, frame_count, frame_duration, frame_start)
  frame_start = frame_start or 1

  return "animated_image["..x..","..y..
                       ";"..w..","..h..
                       ";"..name..
                       ";"..to_text(texture_name)..
                       ";"..frame_count..
                       ";"..frame_duration..
                       ";"..frame_start.."]"
end

function api.item_image(x, y, w, h, item_name)
  return "item_image["..x..","..y..
                   ";"..w..","..h..
                   ";"..to_text(item_name).."]"
end

function api.bg_color(bgcolor, fullscreen, fbgcolor)
  args = to_color(bgcolor)
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
  args = x..","..y..";"..w..","..h..";"..to_text(texture_name)

  if auto_clip ~= nil then
    args = args..";"..to_bool(auto_clip)
  end
  return "background["..args.."]"
end

function api.background9(x, y, w,  h, texture_name, auto_clip, middle)
  args = x..","..y..";"..w..","..h..";"..to_text(texture_name)

  if auto_clip == nil then
    args = args..";"
  else
    args = args..";"..to_bool(auto_clip)
  end

  if middle then
    -- TODO: actually process the argument, it can be a number
    --       or a table with x, x,y, or x,y,x2,y2
    args = args..";"..middle
  end
  return "background9["..args.."]"
end

function api.pwdfield(x, y, w, h, name, label)
  args = x..","..y..";"..w..","..h..";"..name..";"..to_text(label)

  return "pwdfield["..args.."]"
end

function api.field_area(x, y, w, h, name, label, default)
  args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(label)..
    ";"..to_text(default or "")

  return "field["..args.."]"
end

function api.field_simple(name, label, default)
  args = name..
    ";"..to_text(label)..
    ";"..to_text(default or "")

  return "field["..args.."]"
end

function api.field_close_on_enter(name, should_close_on_enter)
  return "field_close_on_enter["..name..";"..to_bool(should_close_on_enter).."]"
end

function api.textarea(x, y, w, h, name, label, default)
  args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(label)..
    ";"..to_text(default or "")

  return "textarea["..args.."]"
end

function api.label(x, y, label)
  args = x..","..y..";"..to_text(label)
  return "label["..args.."]"
end

function api.hypertext(x, y, w, h, name, text)
  args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(text)

  return "hypertext["..args.."]"
end

function api.vertlabel(x, y, label)
  args = x..","..y..";"..to_text(label)
  return "vertlabel["..args.."]"
end

function api.button(x, y, w, h, name, label)
  args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(label)

  return "button["..args.."]"
end

function api.image_button(x, y, w, h, texture_name, name, label, noclip, drawborder, pressed_texture_name)
  args = x..","..y..
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
  args = x..","..y..
    ";"..w..","..h..
    ";"..to_text(item_name)..
    ";"..name..
    ";"..to_text(label)

  return "item_image_button["..args.."]"
end

function api.button_exit(x, y, w, h, name, label)
  args = x..","..y..
    ";"..w..","..h..
    ";"..name..
    ";"..to_text(label)

  return "button_exit["..args.."]"
end

function api.image_button_exit(x, y, w, h, texture_name, name, label)
  args = x..","..y..
    ";"..w..","..h..
    ";"..to_text(texture_name)..
    ";"..name..
    ";"..to_text(label)

  return "image_button_exit["..args.."]"
end

function api.textlist(x, y, w, h, name, listitems, selected_index, is_transparent)
  args = x..","..y..
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

function api.tabheader(x, y, w, h, name, captions, current_tab_index, is_transparent, draw_border)
  args = x..","..y

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

  args = args..table.concat(items, ",")..";"..current_tab_index..";"

  if is_transparent ~= nil then
    args = args..is_transparent
  end

  args = args..";"
  if draw_border ~= nil then
    args = args..draw_border
  end

  return "tabheader["..args.."]"
end

function api.box(x, y, w, h, color)
  args = x..","..y..
    ";"..w..","..h

  if color then
    args = args..";"..to_color(color)
  end

  return "box["..args.."]"
end

function api.dropdown(x, y, w, h, name, dropdown_items, selected_index, use_index_event)
  args = x..","..y

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

  args = args..table.concat(items, ",")..";"..selected_index

  if use_index_event ~= nil then
    args = args..";"..to_bool(use_index_event)
  end

  return "dropdown["..args.."]"
end

function api.checkbox(x, y, name, label, is_selected)
  args = x..","..y..
    ";"..name..
    ";"..to_text(label)

  if is_selected ~= nil then
    args = args..";"..to_bool(is_selected)
  end

  return "checkbox["..args.."]"
end

function api.scrollbar(x, y, w, h, orientation, name, value)
  args = x..","..y..
    ";"..w..","..h..
    ";"..orientation..
    ";"..name..
    ";"..value

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
  args = x..","..y..
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
