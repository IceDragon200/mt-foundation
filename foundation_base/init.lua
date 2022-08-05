--
-- Base module for foundation
--
-- Provides mod registration, taken from the nokore base
-- @namespace foundation
foundation = rawget(_G, "foundation") or {}

local FoundationModule = {}

local function string_trim_leading(str, expected)
  if string.sub(str, 1, #expected) == expected then
    return string.sub(str, 1 + #expected, -1)
  else
    return str
  end
end

local function string_trim_trailing(str, expected)
  if string.sub(str, -#expected) == expected then
    return string.sub(str, 1, -(1 + #expected) )
  else
    return str
  end
end

local function path_join(a, b)
  a = string_trim_trailing(a, "/")
  b = string_trim_leading(b, "/")

  return a .. "/" .. b
end

-- Helper function for quickly creating a full mod name for items or other
-- registrations.
--
-- @spec #make_name(local_name: String): String
function FoundationModule:make_name(local_name)
  return self._name .. ":" .. local_name
end

-- Helper function for registering a node under the parent mod
--
-- @spec #register_node(name: String, entry: Table): Table
function FoundationModule:register_node(name, entry)
  return minetest.register_node(self:make_name(name), entry)
end

-- Helper function for registering a craftitem under the parent mod
--
-- @spec #register_craftitem(name: String, entry: Table): Table
function FoundationModule:register_craftitem(name, entry)
  return minetest.register_craftitem(self:make_name(name), entry)
end

-- Helper function for registering a tool under the parent mod
--
-- @spec #register_tool(name: String, entry: Table): Table
function FoundationModule:register_tool(name, entry)
  return minetest.register_tool(self:make_name(name), entry)
end

-- Helper function for performing a dofile with the mod's path
--
-- @spec #require(Path): Any
function FoundationModule:require(basename)
  local filename = path_join(self.modpath, basename)
  if self.loaded_files[filename] then
    -- nothing to do
  else
    self.loaded_files[filename] = dofile(filename)
  end

  return self.loaded_files[filename]
end

--
-- Creates a new module without setting it globally
--
-- @since 0.3.0
-- @spec new_private_module(name: String, version: String, default: Table)
function foundation.new_private_module(name, version, default)
  assert(name, "expected a name")
  assert(version, "expected a version")

  local mod = default or {}
  mod._name = name
  mod._is_foundation_module = true
  mod.VERSION = version
  mod.S = minetest.get_translator(name)
  mod.modpath = minetest.get_modpath(minetest.get_current_modname())
  mod.loaded_files = {}
  setmetatable(mod, { __index = FoundationModule })

  print("New Foundation Module: " .. mod._name .. " " .. mod.VERSION)
  return mod
end

--
-- Creates or retrieves an existing mod's module
-- The modpath is automatically set on call
--
-- @spec new_module(name: String, default: Table): FoundationModule
function foundation.new_module(name, version, default)
  local mod = foundation.new_private_module(
    name,
    version,
    rawget(_G, name) or default
  )

  rawset(_G, name, mod)

  return mod
end

--
-- Determines if specified module exists (public-only)
--
-- @spec is_module_present(name: String, optional_version: String): Boolean
function foundation.is_module_present(name, optional_version)
  local value = rawget(_G, name)

  if type(value) == "table" then
    if optional_version then
      return foundation.com.Version:test(value.VERSION, optional_version)
    else
      return true
    end
  end
  return false
end

-- Bootstrap itself
foundation.new_module("foundation", "0.3.1", foundation)

-- hardcoded for now, trigger the self tests
foundation.self_test = true

-- foundation common module, all exported modules end up here
foundation.com = {}

dofile(foundation.modpath .. "/version.lua")

if foundation.self_test then
  assert(foundation.is_module_present("foundation"), "expected foundation itself to be present")
  assert(foundation.is_module_present("foundation", "0.3.1"), "expected its own version to match")
end

