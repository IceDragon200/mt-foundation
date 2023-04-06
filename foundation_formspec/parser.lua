--- @namespace foundation.com.formspec.api
local StringBuffer = assert(foundation.com.StringBuffer)
local List = assert(foundation.com.List)

foundation.com.formspec = foundation.com.formspec or {}

local SPACE_CHARACTER = {
  -- spaces
  ['\x20'] = true, -- space
  -- because unicode escapes do not work in luajit
  ["\xC2\xA0"] = true, -- "\u{00A0}"
  ["\xE1\x9A\x80"] = true, -- "\u{1680}"
  ["\xE2\x80\x80"] = true, -- "\u{2000}"
  ["\xE2\x80\x81"] = true, -- "\u{2001}"
  ["\xE2\x80\x82"] = true, -- "\u{2002}"
  ["\xE2\x80\x83"] = true, -- "\u{2003}"
  ["\xE2\x80\x84"] = true, -- "\u{2004}"
  ["\xE2\x80\x85"] = true, -- "\u{2005}"
  ["\xE2\x80\x86"] = true, -- "\u{2006}"
  ["\xE2\x80\x87"] = true, -- "\u{2007}"
  ["\xE2\x80\x88"] = true, -- "\u{2008}"
  ["\xE2\x80\x89"] = true, -- "\u{2009}"
  ["\xE2\x80\x8A"] = true, -- "\u{200A}"
  ["\xE2\x80\xAF"] = true, -- "\u{202F}"
  ["\xE2\x81\x9F"] = true, -- "\u{205F}"
  ["\xE3\x80\x80"] = true, -- "\u{3000}"
}

local NEWLINE_CHARACTER = {
  -- newlines
  ['\f'] = true,
  ['\n'] = true,
  ['\r'] = true,
  ["\xE2\x80\xA8"] = true, -- "\u{2028}"
  ["\xE2\x80\xA9"] = true, -- "\u{2029}"
  ["\xC2\x85"] = true, -- "\u{0085}"
}

local parser = {}

local STATE_DEFAULT = 0
local STATE_ATTRS = 1

--- @type Item: {
---   name: String,
---   attrs: List<String>
--- }

--- @spec parse_buffer(buffer: StringBuffer): List<Item>
function parser.parse_buffer(buffer)
  local char
  local state = STATE_DEFAULT

  local result = List:new()
  local current_token
  local current_attrs
  local current_term

  while not buffer:isEOF() do
    char = buffer:read_utf8_codepoint()

    if state == STATE_DEFAULT then
      if SPACE_CHARACTER[char] then
        --
      elseif NEWLINE_CHARACTER[char] then
        --
      elseif char == "[" then
        current_token = {
          name = current_term,
          attrs = List:new()
        }
        current_term = nil
        current_attrs = List:new()
        state = STATE_ATTRS
      else
        if current_term then
          current_term = current_term .. char
        else
          current_term = char
        end
      end
    elseif state == STATE_ATTRS then
      if char == ']' then
        if current_term then
          current_attrs:push(current_term)
          current_term = nil
        end
        current_token.attrs:push(current_attrs:copy())
        current_attrs:clear()
        result:push(current_token)
        current_token = nil
        state = STATE_DEFAULT
      elseif char == ',' then
        current_attrs:push(current_term)
        current_term = nil
      elseif char == ';' then
        if current_term then
          current_attrs:push(current_term)
          current_term = nil
        end
        current_token.attrs:push(current_attrs:copy())
        current_attrs:clear()
      else
        if current_term then
          current_term = current_term .. char
        else
          current_term = char
        end
      end
    end
  end

  return result
end

--- @spec parse(formspec: String): List<Item>
function parser.parse(formspec)
  return parser.parse_buffer(StringBuffer:new(formspec, "r"))
end

foundation.com.formspec.parser = parser
