--- @namespace foundation.com

--- @private.spec pad_number(number: Number, len: Number): String
local function pad_number(number, len)
  local str = tostring(number)
  -- the naive approach
  while #str < len do
    str = "0" .. str
  end
  return str
end

--- @type Prefix: { [1]: (si_prefix: String), [2]: (si_code: String), [3]: Number }

foundation.com.BINARY_PREFIXES = {
  {"yobi", "Yi", math.pow(2, 80)},
  {"zebi", "Zi", math.pow(2, 70)},
  {"exbi", "Ei", math.pow(2, 60)},
  {"pebi", "Pi", math.pow(2, 50)},
  {"tebi", "Ti", math.pow(2, 40)},
  {"gibi", "Gi", math.pow(2, 30)},
  {"mebi", "Mi", math.pow(2, 20)},
  {"kibi", "Ki", math.pow(2, 10)},
  {"", "", 1},
}

--- @const ALL_PREFIXES: Prefix[]
foundation.com.ALL_PREFIXES = {
  {"yotta", "Y", 1e+24},
  {"zetta", "Z", 1e+21},
  {"exa",   "E", 1e+18},
  {"peta",  "P", 1e+15},
  {"tera",  "T", 1e+12},
  {"giga",  "G", 1e+9},
  {"mega",  "M", 1e+6},
  {"kilo",  "k", 1e+3},
  {"hecto", "h", 1e+2},
  {"deca",  "da",1e+1},
  {"",      "",  1e0},
  {"deci",  "d", 1e-1},
  {"centi", "c", 1e-2},
  {"milli", "m", 1e-3},
  {"micro", "μ", 1e-6},
  {"nano",  "n", 1e-9},
  {"pico",  "p", 1e-12},
  {"femto", "f", 1e-15},
  {"atto",  "a", 1e-18},
  {"zepto", "z", 1e-21},
  {"yocto", "y", 1e-24},
}

--- @const COMMON_PREFIXES: Prefix[]
foundation.com.COMMON_PREFIXES = {
  {"yotta", "Y", 1e+24},
  {"zetta", "Z", 1e+21},
  {"exa",   "E", 1e+18},
  {"peta",  "P", 1e+15},
  {"tera",  "T", 1e+12},
  {"giga",  "G", 1e+9},
  {"mega",  "M", 1e+6},
  {"kilo",  "k", 1e+3},
  {"",      "",  1e0},
  {"milli", "m", 1e-3},
  {"micro", "μ", 1e-6},
  {"nano",  "n", 1e-9},
  {"pico",  "p", 1e-12},
  {"femto", "f", 1e-15},
  {"atto",  "a", 1e-18},
  {"zepto", "z", 1e-21},
  {"yocto", "y", 1e-24},
}

---
--- Attempts to pretty format the given value, usually a number.
--- prefixes allows overwriting the prefix table tha should be used
---
--- Usage:
---
---    foundation.com.format_pretty_unit(10, 's') -- => 10s
---    foundation.com.format_pretty_unit(10000, 'l') -- => 10kl
---
--- @spec format_pretty_unit(
---   value: Number,
---   unit?: String,
---   prefixes?: Prefix[]
--- ): String
function foundation.com.format_pretty_unit(value, unit, prefixes)
  prefixes = prefixes or foundation.com.COMMON_PREFIXES
  unit = unit or ""
  local result = tostring(value)
  local num
  for _,row in ipairs(prefixes) do
    -- until the unit is less than the value
    if row[3] <= value then
      num = value / row[3]
      result = string.format("%.2f", num) .. row[2]
      break
    end
  end
  return result .. unit
end

---
--- Pretty formats the given integer as a timestamp, usually used for durations
---
--- @spec format_pretty_time(value: String): String
function foundation.com.format_pretty_time(value)
  value = math.floor(value)
  local hours = math.floor(value / 60 / 60)
  local minutes = math.floor(value / 60) % 60
  local seconds = math.floor(value % 60)

  if hours > 0 then
    return pad_number(hours, 2) .. ":" .. pad_number(minutes, 2) .. ":" .. pad_number(seconds, 2)
  elseif minutes > 0 then
    return pad_number(minutes, 2) .. ":" .. pad_number(seconds, 2)
  else
    return pad_number(seconds, 2)
  end
end
