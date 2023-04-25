--[[

  Luna is a test framework to replace knife.test,
  this has been extracted from my own personal project for use in minetest.

  You are free to copy and use this module/class

]]
-- @namespace foundation.com
local HEX_TABLE = {
  [0] = "0",
  [1] = "1",
  [2] = "2",
  [3] = "3",
  [4] = "4",
  [5] = "5",
  [6] = "6",
  [7] = "7",
  [8] = "8",
  [9] = "9",
  [10] = "A",
  [11] = "B",
  [12] = "C",
  [13] = "D",
  [14] = "E",
  [15] = "F",
}

local function byte_to_escaped_hex(byte)
  local hinibble = math.floor(byte / 16)
  local lonibble = byte % 16
  return "\\x" .. HEX_TABLE[hinibble] .. HEX_TABLE[lonibble]
end

local function string_hex_escape(str, mode)
  mode = mode or "non-ascii"

  local result = {}
  local bytes = {string.byte(str, 1, -1)}

  for i, byte in ipairs(bytes) do
    if mode == "non-ascii" then
      -- 92 \
      if byte == 92 then
        result[i] = "\\\\"
      elseif byte >= 32 and byte < 127  then
        result[i] = string.char(byte)
      else
        result[i] = byte_to_escaped_hex(byte)
      end
    else
      result[i] = byte_to_escaped_hex(byte)
    end
  end

  return table.concat(result)
end

--
-- Used to merge multiple map-like tables together, if you need to merge lists
-- use `list_concat/*` instead
--
local function table_merge(...)
  local result = {}
  for _,t in ipairs({...}) do
    for key,value in pairs(t) do
      result[key] = value
    end
  end
  return result
end

--
-- Makes a copy of the given table
--
local function table_copy(t)
  return table_merge(t)
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

local function deep_equals(a, b, depth)
  depth = depth or 0
  if depth > 20 then
    error("deep_equals depth exceeded")
  end

  if type(a) == type(b) then
    if type(a) == "table" then
      local keys = {}
      for k, _ in pairs(a) do
        keys[k] = true
      end
      for k, _ in pairs(b) do
        keys[k] = true
      end

      for k, _ in pairs(keys) do
        if not deep_equals(a[k], b[k], depth + 1) then
          return false
        end
      end
      return true
    else
      return a == b
    end
  else
    return false
  end
end

local function table_includes_value(t, expected)
  for _, value in pairs(t) do
    if value == expected then
      return true
    end
  end
  return false
end

local PREFIXES = {
  {"tera", "T", 1000000000000},
  {"giga", "G", 1000000000},
  {"mega", "M", 1000000},
  {"kilo", "k", 1000},
  {"", "", 1},
  {"milli", "m", 0.001},
  {"micro", "μ", 0.000001},
  {"nano", "n", 0.000000001},
}

local function format_pretty_unit(value, unit)
  unit = unit or ""
  local result = tostring(value)
  for _,row in ipairs(PREFIXES) do
    -- until the unit is less than the value
    if row[3] < value then
      result = string.format("%.2f", value / row[3]) .. row[2]
      break
    end
  end
  return result .. unit
end

local DefaultReporter = {}
function DefaultReporter:report(...)
  print(...)
  return self
end

local NullReporter = {}
function NullReporter:report(...)
  assert(...)
  return self
end

-- @class Luna
local Luna = foundation.com.Class:extends()
local ic = Luna.instance_class

Luna.NullReporter = NullReporter
Luna.DefaultReporter = DefaultReporter

local function format_message(message)
  if type(message) == "function" then
    return message()
  end
  return assert(message)
end

Luna.default_config = {
  reporter = DefaultReporter
}

-- @spec #initialize(name: String, config?: Table): void
function ic:initialize(name, config)
  self.name = name
  self.config = table_merge(Luna.default_config, config or {})
  self.reporter = self.config.reporter
  self.stats = {
    time_elapsed = 0.0,
    assertions_passed = 0,
    assertions_failed = 0,
    tests_passed = 0,
    tests_failed = 0,
  }
  self.tests = {}
  self.children = {}
  self.setup_callbacks = {}
  self.setup_all_callbacks = {}
  self.finalize_callbacks = {}
  self.finalize_all_callbacks = {}
end

function ic:setup(callback)
  table.insert(self.setup_callbacks, callback)
end

function ic:setup_all(callback)
  table.insert(self.setup_all_callbacks, callback)
end

function ic:finalize(callback)
  table.insert(self.finalize_callbacks, callback)
end

function ic:finalize_all(callback)
  table.insert(self.finalize_all_callbacks, callback)
end

function ic:describe(name, func)
  local luna = self._class:new(name)
  luna.reporter = self.reporter
  table.insert(self.tests, {"describe", name, luna})
  table.insert(self.children, luna)
  func(luna)
  return luna
end

function ic:xtest(name, func)
  table.insert(self.tests, {"xtest", name, func})
  return self
end

function ic:test(name, func)
  table.insert(self.tests, {"test", name, func})
  return self
end

function ic:assert(truth_value, message)
  message = message or "expected value to be truthy"
  if truth_value then
    self.stats.assertions_passed = self.stats.assertions_passed + 1
  else
    self.stats.assertions_failed = self.stats.assertions_failed + 1
    error("assertion failed: " .. format_message(message))
  end

  return truth_value
end

function ic:neat_dump(value)
  assert(self)
  local ty = type(value)
  if ty == "string" then
    return ty .. "<\"" .. string_hex_escape(value) .. "\">#" .. #value
  else
    return ty .. "; " .. dump(value)
  end
end

function ic:assert_eq(a, b, message)
  message = message or function ()
    return ("expected to be equal to:\n\t left: " .. self:neat_dump(a) ..
            "\n\tright: " .. self:neat_dump(b))
  end
  self:assert(a == b, message)
end

function ic:assert_neq(a, b, message)
  message = message or function ()
    return ("expected to not be equal to:\n\t left: " .. self:neat_dump(a) ..
            "\n\tright: " .. self:neat_dump(b))
  end
  self:assert(a ~= b, message)
end

function ic:assert_table_eq(a, b, message)
  message = message or function ()
    return ("expected to be equal to:\n\t left: " .. self:neat_dump(a) ..
            "\n\tright: " .. self:neat_dump(b))
  end
  self:assert(table_equals(a, b), message)
end

function ic:assert_deep_eq(a, b, message)
  message = message or function ()
    return ("expected to be equal to:\n\t left: " .. self:neat_dump(a) ..
            "\n\tright: " .. self:neat_dump(b))
  end

  self:assert(deep_equals(a, b), message)
end

function ic:assert_in_range(item, min, max, message)
  message = message or function ()
    return ("expected " .. self:neat_dump(item) .. " to be range of " ..
            self:neat_dump(min) .. ".." .. self:neat_dump(max))
  end
  self:assert(item >= min and item <= max, message)
end

function ic:assert_in(item, list, message)
  message = message or function ()
    return ("expected " .. self:neat_dump(item) .. " to be included in " ..
            self:neat_dump(list))
  end
  self:assert(table_includes_value(list, item), message)
end

function ic:refute(truth_value, message)
  message = message or function ()
    return ("expected " .. self:neat_dump(truth_value) .. " to be falsy")
  end
  self:assert(not truth_value, message)
  return truth_value
end

function ic:refute_eq(a, b, message)
  message = message or function ()
    return ("expected " .. self:neat_dump(a) .. " to not be equal to " .. self:neat_dump(b))
  end
  self:refute(a == b, message)
end

function ic:execute(depth, prefix, tags)
  tags = table_copy(tags or {})
  depth = depth or 0
  prefix = prefix or self.name
  for _,callback in ipairs(self.setup_all_callbacks) do
    tags = callback(tags)
  end
  for _,test in ipairs(self.tests) do
    local test_tags = table_copy(tags)
    for _,callback in ipairs(self.setup_callbacks) do
      test_tags = callback(test_tags)
    end
    if test[1] == "describe" then
      local prefix2 = prefix .. "  " .. test[2]
      test[3]:execute(depth + 1, prefix2, test_tags)
    elseif test[1] == "xtest" then
      self.reporter:report("* D " .. prefix, test[2], "DISABLED")
    elseif test[1] == "test" then
      local test_func = test[3]
      --self.reporter:report("* " .. prefix, test[2])
      local x_us = minetest.get_us_time()
      local success, err = xpcall(test_func, debug.traceback, self, test_tags)
      local y_us = minetest.get_us_time()
      local diff_us = y_us - x_us
      local diff = diff_us / 1000000.0
      local elapsed = format_pretty_unit(diff, "s")
      if success then
        self.reporter:report("* O " .. prefix, test[2], "OK", elapsed)
        self.stats.tests_passed = self.stats.tests_passed + 1
      else
        self.reporter:report("* X " .. prefix, test[2], "ERROR", elapsed, "\n\t" .. err)
        self.stats.tests_failed = self.stats.tests_failed + 1
      end
    end
    for _,callback in ipairs(self.finalize_callbacks) do
      callback(test_tags)
    end
  end
  for _,callback in ipairs(self.finalize_all_callbacks) do
    callback(tags)
  end
  return self
end

function ic:bake_stats()
  local stats = {
    assertions_passed = self.stats.assertions_passed,
    assertions_failed = self.stats.assertions_failed,
    tests_passed = self.stats.tests_passed,
    tests_failed = self.stats.tests_failed,
  }

  for _, luna in ipairs(self.children) do
    local baked_stats = luna:bake_stats()
    stats.assertions_passed = stats.assertions_passed + baked_stats.assertions_passed
    stats.assertions_failed = stats.assertions_failed + baked_stats.assertions_failed
    stats.tests_passed = stats.tests_passed + baked_stats.tests_passed
    stats.tests_failed = stats.tests_failed + baked_stats.tests_failed
  end

  return stats
end

function ic:display_stats()
  local stats = self:bake_stats()
  local total_tests = stats.tests_passed + stats.tests_failed
  local total_assertions =
    stats.assertions_passed +
    stats.assertions_failed

  self.reporter:report("\n")
  self.reporter:report(
    stats.tests_passed .. " passed",
    stats.tests_failed .. " failed",
    total_tests .. " total"
  )
  self.reporter:report(
    stats.assertions_passed .. " assertions passed",
    stats.assertions_failed .. " assertions failed",
    total_assertions .. " total assertions"
  )
  self.reporter:report("\n")
  return self
end

function ic:maybe_error()
  local stats = self:bake_stats()
  if stats.tests_failed > 0 then
    error("one or more tests have failed")
  end
  return self
end

foundation.com.Luna = Luna
