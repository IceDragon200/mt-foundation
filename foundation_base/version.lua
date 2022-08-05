-- @namespace foundation.com.Version

--
-- Version Helper for parsing semantic versions
--
local version = {
  -- Greater Than
  GT = 1,
  -- Less Than
  LT = -1,
  -- Equal
  EQ = 0,
}

local function string_starts_with(str, expected)
  return expected == "" or string.sub(str, 1, #expected) == expected
end

local function string_trim_leading_space(str)
  while #str > 0 do
    if string.sub(str, 1, 1) == " " then
      str = string.sub(str, 2, -1)
    else
      break
    end
  end
  return str
end

-- Parses a string into a version table
--
-- @spec #parse(str: String): Table
function version:parse(str)
  local parts = string.split(str, ".")

  return {
    major = tonumber(parts[1]),
    minor = tonumber(parts[2]),
    patch = tonumber(parts[3]),
  }
end

-- Attempts to convert given value into a version table
--
-- @spec #cast(value: String | Table): Table
function version:cast(value)
  local typename = type(value)
  if typename == "table" then
    return value
  elseif typename == "string" then
    return self:parse(value)
  else
    error("expected a table or string (got " .. typename .. ")")
  end
end

-- Compares given 2 versions, the versions can either be tables or strings
--
-- @spec #compare(a: Term, b: Term): version.GT | version.LT | version.EQ
function version:compare(a, b)
  a = self:cast(a)
  b = self:cast(b)

  if a.major > b.major then
    return self.GT
  elseif a.major < b.major then
    return self.LT
  else
    -- major versions are equal, try minor now
    if a.minor > b.minor then
      return self.GT
    elseif a.minor < b.minor then
      return self.LT
    else
      -- minor versions are equal, try patch now
      if a.patch > b.patch then
        return self.GT
      elseif a.patch < b.patch then
        return self.LT
      else
        return self.EQ
      end
    end
  end
end

function version:test(ver, test_term)
  if type(test_term) == "string" then
    test_term = {test_term}
  end

  ver = self:cast(ver)

  local result = false
  for _,test_str in ipairs(test_term) do
    -- fuzzy match
    if string_starts_with(test_str, "~>") then
      test_str = string.sub(test_str, 3)
      local test_ver = self:parse(string_trim_leading_space(test_str))
      if test_ver.patch then
        -- can only fuzzy match at patch; major and minor must be equal
        if ver.major == test_ver.major and
           ver.minor == test_ver.minor and
           ver.patch >= test_ver.patch then
          -- all is well
          result = true
          break
        end
      elseif test_ver.minor then
        -- can only fuzzy match at minor; major must be equal
        if ver.major == test_ver.major and
           ver.minor >= test_ver.minor then
          -- all is well
          result = true
          break
        end
      else
        -- can only fuzzy match at major
        if ver.major >= test_ver.major then
          -- all is well
          result = true
          break
        end
      end
    elseif string_starts_with(test_str, ">=") then
      test_str = string.sub(test_str, 3)
      local test_ver = self:parse(string_trim_leading_space(test_str))

      if self:compare(ver, test_ver) ~= self.LT then
        result = true
        break
      end
    elseif string_starts_with(test_str, "<=") then
      test_str = string.sub(test_str, 3)
      local test_ver = self:parse(string_trim_leading_space(test_str))

      if self:compare(ver, test_ver) ~= self.GT then
        result = true
        break
      end
    elseif string_starts_with(test_str, ">") then
      test_str = string.sub(test_str, 2)
      local test_ver = self:parse(string_trim_leading_space(test_str))

      if self:compare(ver, test_ver) == self.GT then
        result = true
        break
      end
    elseif string_starts_with(test_str, "<") then
      test_str = string.sub(test_str, 2)
      local test_ver = self:parse(string_trim_leading_space(test_str))

      if self:compare(ver, test_ver) == self.LT then
        result = true
        break
      end
    else
      if self:compare(ver, test_str) == self.EQ then
        result = true
        break
      end
    end
  end

  return result
end

if foundation.self_test then
  local ver = version:parse("0.0.0")

  assert(ver.major == 0)
  assert(ver.minor == 0)
  assert(ver.patch == 0)

  local ver = version:parse("2020.7.1")

  assert(ver.major == 2020)
  assert(ver.minor == 7)
  assert(ver.patch == 1)

  -- Cast tests
  local ver = version:cast("2020.7.1")

  assert(ver.major == 2020)
  assert(ver.minor == 7)
  assert(ver.patch == 1)

  local ver = version:cast({ major = 2020, minor = 7, patch = 1 })

  assert(ver.major == 2020)
  assert(ver.minor == 7)
  assert(ver.patch == 1)

  -- Compare tests
  assert(version:compare("0.0.0", "0.0.0") == version.EQ)

  assert(version:compare("1.0.0", "0.0.0") == version.GT)
  assert(version:compare("0.1.0", "0.0.0") == version.GT)
  assert(version:compare("0.0.1", "0.0.0") == version.GT)

  assert(version:compare("1.2.0", "0.22.0") == version.GT)

  assert(version:compare("0.0.0", "1.0.0") == version.LT)
  assert(version:compare("0.0.0", "0.1.0") == version.LT)
  assert(version:compare("0.0.0", "0.0.1") == version.LT)

  assert(version:compare("0.22.0", "1.2.0") == version.LT)

  -- test tests (ha)
  assert(version:test("1.0.0", "1.0.0") == true)

  assert(version:test("1.4.4", "~> 1.4.2") == true)
  assert(version:test("1.4.0", "~> 1.4.2") == false)

  assert(version:test("1.4.0", "~> 1.2") == true)
  assert(version:test("1.1.0", "~> 1.2") == false)

  assert(version:test("1.1.0", "~> 1") == true)
  assert(version:test("1.1.0", "~> 2") == false)

  assert(version:test("1.1.0", ">= 1.0.0") == true)
  assert(version:test("1.1.0", ">= 1.1.0") == true)
  assert(version:test("1.1.0", ">= 1.2.0") == false)

  assert(version:test("1.1.0", "<= 1.2.0") == true)
  assert(version:test("1.1.0", "<= 1.1.0") == true)
  assert(version:test("1.1.0", "<= 1.0.0") == false)

  assert(version:test("1.1.0", "> 1.0.0") == true)
  assert(version:test("1.1.0", "> 1.1.0") == false)
  assert(version:test("1.1.0", "> 1.2.0") == false)

  assert(version:test("1.1.0", "< 1.2.0") == true)
  assert(version:test("1.1.0", "< 1.1.0") == false)
  assert(version:test("1.1.0", "< 1.0.0") == false)
end

foundation.com.Version = version
