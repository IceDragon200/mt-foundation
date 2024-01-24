--
-- UTF-8 Utility module
--
--   For dealing with utf-8 strings and converting codepoints
--
-- https://www.ietf.org/rfc/rfc3629.txt
local mod = foundation.new_module("foundation_utf8", "1.2.0")

--- @namespace foundation.com.utf8

local utf8 = {}

--- Returns the length of the next codepoint, only the first character is
--- analyzed, so this can be used in parsing to determine the number of bytes
--- that should be parsed next.
---
--- If the string has no bytes then `nil` is returned for the length instead.
---
--- @spec next_codepoint_length(str: String, start: Integer): Integer | nil
function utf8.next_codepoint_length(str, start)
  start = start or 1
  local byte = string.byte(str, start)
  if byte then
    local len = 1
    if byte >= 0xF0 and byte <= 0xF7 then
      -- 0001 0000-0010 FFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
      len = 4
    elseif byte >= 0xE0 and byte <= 0xEF then
      -- 0000 0800-0000 FFFF | 1110xxxx 10xxxxxx 10xxxxxx
      len = 3
    elseif byte >= 0xC0 and byte <= 0xDF then
      -- 0000 0080-0000 07FF | 110xxxxx 10xxxxxx
      len = 2
    end
    return len
  end
  return nil
end

--- Returns the next codepoints start and tail position so the character can be
--- extracted or just to determine if it actually exists
--- The length of the character can be determined by subtracting the start from the tail + 1
---
--- @spec next_codepoint_pos(str: String, start: Integer): (Integer, Integer) | (nil, nil)
function utf8.next_codepoint_pos(str, start)
  start = start or 1
  local len = utf8.next_codepoint_length(str, start)
  if len then
    return start, start + len - 1
  end
  return nil, nil
end

--- Returns the next codepoint in the string, the start position can be
--- specified to allow reading from an arbitrary position.
---
--- @spec next_codepoint(str: String, start?: Integer): (String, Integer) | (nil, Integer)
function utf8.next_codepoint(str, start)
  local tail
  start, tail = utf8.next_codepoint_pos(str, start)

  if start and tail then
    return string.sub(str, start, tail), tail
  end

  return nil, nil
end

--- Returns a table with all the codepoints in the string
---
--- @spec each_codepoint(str: String, callback: (char: String, start: Integer, tail: Integer) => void, start: Integer): String[]
function utf8.each_codepoint(str, callback, start)
  local codepoint
  local tail
  local i = 0

  start = start or 1
  codepoint, tail = utf8.next_codepoint(str, start)
  while codepoint do
    i = i + 1
    callback(codepoint, start, tail)
    codepoint, tail = utf8.next_codepoint(str, tail + 1)
  end
end

--- Returns a table with all the codepoints in the string
---
--- @spec codepoints(str: String, start: Integer): String[]
function utf8.codepoints(str, start)
  local codepoint
  local tail
  local result = {}
  local i = 0

  start = start or 1
  codepoint, tail = utf8.next_codepoint(str, start)
  while codepoint do
    i = i + 1
    result[i] = codepoint
    codepoint, tail = utf8.next_codepoint(str, tail + 1)
  end

  return result
end

--- Reports the length of the string in terms of characters (not byte size)
---
--- @spec size(str: String): Integer
function utf8.size(str)
  local start
  local tail
  local size = 0
  start, tail = utf8.next_codepoint_pos(str)
  while start do
    size = size + 1
    start, tail = utf8.next_codepoint_pos(str, tail + 1)
  end
  return size
end

--- @alias len = size
utf8.len = utf8.size

--- @alias byte_size = .string.len
utf8.byte_size = string.len

--- @alias byte_len = byte_size
utf8.byte_len = string.len

foundation.com.utf8 = utf8

if foundation.com.Luna then
  mod:require("tests.lua")
end
