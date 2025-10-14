local XML = foundation_xml.XML
local table_merge = assert(foundation.com.table_merge)
local StringBuffer = assert(foundation.com.StringBuffer)
local TokenBuffer = assert(foundation.com.TokenBuffer)

--- @namespace foundation_kdl.XML.Lexer
local Lexer = {}

local SPACE_CHARACTER = {
  -- spaces
  ['\x09'] = true, -- tab
  ['\x0A'] = true, -- newline
  ['\x0D'] = true, -- carriage-return
  ['\x20'] = true, -- space
}

--[[
Names and Tokens
[4]  NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6]
                     | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D]
                     | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF]
                     | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
[4a] NameChar      ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
[5]  Name          ::= NameStartChar (NameChar)*
[6]  Names         ::= Name (#x20 Name)*
[7]  Nmtoken       ::= (NameChar)+
[8]  Nmtokens      ::= Nmtoken (#x20 Nmtoken)*
]]
--- https://www.w3.org/TR/2006/REC-xml11-20060816/#NT-Name
--- @private.spec read_name(state: Table): (String, Integer) | (nil, nil)
local function read_name(state)
  local buffer = state.buffer
  local char
  local len
  local i = 0
  local rlen = 0
  local result = {}

  local scalar = buffer:peek_utf8_codepoint_scalar()

  if scalar == 0x3A -- ":"
     or (scalar >= 0x41 and scalar <= 0x5A)
     or scalar == 0x5F -- "_"
     or (scalar >= 0x61 and scalar <= 0x7A)
     or (scalar >= 0xC0 and scalar <= 0xD6)
     or (scalar >= 0xD8 and scalar <= 0xF6)
     or (scalar >= 0xF8 and scalar <= 0x02FF)
     or (scalar >= 0x0370 and scalar <= 0x037D)
     or (scalar >= 0x037F and scalar <= 0x1FFF)
     or (scalar >= 0x200C and scalar <= 0x200D)
     or (scalar >= 0x2070 and scalar <= 0x218F)
     or (scalar >= 0x2C00 and scalar <= 0x2FEF)
     or (scalar >= 0x3001 and scalar <= 0xD7FF)
     or (scalar >= 0xF900 and scalar <= 0xFDCF)
     or (scalar >= 0xFDF0 and scalar <= 0xFFFD)
     or (scalar >= 0x10000 and scalar <= 0xEFFFF) then
    i = i + 1
    char, len = buffer:read_utf8_codepoint()
    rlen = rlen + len
    result[i] = char
  else
    return nil, nil
  end

  while true do
    scalar = buffer:peek_utf8_codepoint_scalar()
    if not scalar then
      break
    end
    if scalar == 0x2D -- "-"
       or scalar == 0x2E -- "."
       or (scalar >= 0x30 and scalar <= 0x39)
       or scalar == 0x3A -- ":"
       or (scalar >= 0x41 and scalar <= 0x5A)
       or scalar == 0x5F -- "_"
       or (scalar >= 0x61 and scalar <= 0x7A)
       or scalar == 0xB7
       or (scalar >= 0xC0 and scalar <= 0xD6)
       or (scalar >= 0xD8 and scalar <= 0xF6)
       or (scalar >= 0xF8 and scalar <= 0x02FF)
       or (scalar >= 0x0300 and scalar <= 0x037D)
       or (scalar >= 0x037F and scalar <= 0x1FFF)
       or (scalar >= 0x200C and scalar <= 0x200D)
       or (scalar >= 0x203F and scalar <= 0x2040)
       or (scalar >= 0x2070 and scalar <= 0x218F)
       or (scalar >= 0x2C00 and scalar <= 0x2FEF)
       or (scalar >= 0x3001 and scalar <= 0xD7FF)
       or (scalar >= 0xF900 and scalar <= 0xFDCF)
       or (scalar >= 0xFDF0 and scalar <= 0xFFFD)
       or (scalar >= 0x10000 and scalar <= 0xEFFFF) then
      i = i + 1
      char, len = buffer:read_utf8_codepoint()
      rlen = rlen + len
      result[i] = char
    else
      break
    end
  end

  return table.concat(result), rlen
end

--- @private.spec tokenize_spaces(state: Table):
---   (should_continue: Boolean, okay: Boolean, state: Table, err: String)
local function tokenize_spaces(state)
  local buffer = state.buffer
  local char
  local len

  local i = 0
  local acc = {}
  local opos = buffer:tell()

  while true do
    char, len = buffer:peek_utf8_codepoint()
    if char and SPACE_CHARACTER[char] then
      buffer:walk(len)
      i = i + 1
      acc[i] = char
    else
      break
    end
  end
  if i > 0 then
    state.tokens:push_token("space", table.concat(acc))
    return true, true, state, nil
  end

  buffer:seek(opos)
  return false, false, state, "no spaces"
end

local function tokenize_cdata_body(state)
  local buffer = state.buffer
  local char
  local len
  local pos
  local i = 0
  local acc = {}
  -- "]]>"
  local org_pos = buffer:tell()

::check_closing::
  pos = buffer:tell()
  char, len = buffer:peek_utf8_codepoint()
  if char == "]" then
    buffer:walk(len)
    char, len = buffer:read_utf8_codepoint()
    if char == "]" then
      char, len = buffer:read_utf8_codepoint()
      if char == ">" then
        state.tokens:push_token("cdata_body", table.concat(acc))
        state.tokens:push_token("cdata_close", true)
        return true, true, state, nil
      end
    end
    buffer:seek(pos)
  end
::add_character::
  if char then
    buffer:skip_utf8_codepoint()
    i = i + 1
    acc[i] = char
    goto check_closing
  end
::abort::
  buffer:seek(org_pos)
  return false, false, state, "aborted cdata body"
end

local function tokenize_comment_body(state)
  local buffer = state.buffer
  local char
  local last_char
  local len
  local pos
  local i = 0
  local acc = {}
  -- "-->"
  local org_pos = buffer:tell()

::check_closing::
  pos = buffer:tell()
  char, len = buffer:peek_utf8_codepoint()
  if char == "-" then
    buffer:walk(len)
    char, len = buffer:read_utf8_codepoint()
    if char == "-" then
      char, len = buffer:read_utf8_codepoint()
      if char == ">" then
        state.tokens:push_token("comment_body", table.concat(acc))
        state.tokens:push_token("comment_close", true)
        return true, true, state, nil
      end
    end
    buffer:seek(pos)
  end
::add_character::
  if char then
    buffer:skip_utf8_codepoint()
    i = i + 1
    acc[i] = char
    last_char = char
    goto check_closing
  end
::abort::
  buffer:seek(org_pos)
  return false, false, state, "aborted comment body"
end

local function tokenize_char_data(state)
  local buffer = state.buffer
  local char
  local len
  local pos
  local i = 0
  local acc = {}
  -- "]]>"
  local org_pos = buffer:tell()

::add_character::
  char, len = buffer:peek_utf8_codepoint()
  if char then
    if char == "" or char == "<" or char == "&" then
      --
      state.tokens:push_token("chardata", table.concat(acc))
      return true, true, state, nil
    end
    buffer:walk(len)
    i = i + 1
    acc[i] = char
    goto add_character
  end

::abort::
  buffer:seek(org_pos)
  return false, false, state, "aborted chardata body"
end

local function tokenize_default(state)
  local buffer = state.buffer
  local char
  local len

  while not buffer:isEOF() do
    if state.name ~= 'default' then
      break
    end

    char, len = buffer:peek_utf8_codepoint()

    if SPACE_CHARACTER[char] then
      tokenize_spaces(state)
    elseif char == "<" then
      buffer:walk(len)
      char, len = buffer:peek_utf8_codepoint()
      if char == "!" then
        -- could be a comment or CDATA
        buffer:walk(len)
        char, len = buffer:peek_utf8_codepoint()
        if char == "-" then
          buffer:walk(len)
          char, len = buffer:peek_utf8_codepoint()
          if char == "-" then
            buffer:walk(len)
            state.tokens:push_token("comment_open", true)
            state.name = "comment"
          else
            return false, false, state, "malformed element"
          end
        elseif char == "[" then
          if buffer:skip("[CDATA[") then
            state.tokens:push_token("cdata_open", true)
            state.name = "cdata"
          else
            return false, false, state, "malformed element"
          end
        end
      elseif char == "?" then
        -- processor instruction
        buffer:walk(len)
        state.tokens:push_token("processor_ins_open", true)
        state.name = "processor_ins"
      elseif char == "/" then
        buffer:walk(len)
        state.tokens:push_token("etag_open", true)
        local name = read_name(state)
        if name then
          state.tokens:push_token("name", name)
          tokenize_spaces(state)
          char, len = buffer:peek_utf8_codepoint()
          if char == ">" then
            buffer:walk(len)
            state.tokens:push_token("etag_close", true)
          else
            return false, false, state, "invalid etag sequence"
          end
        else
          return false, false, state, "invalid etag name"
        end
      else
        state.tokens:push_token("stag_open", true)
        state.name = "element"
      end
    else
      local should_continue, okay, state, err = tokenize_char_data(state)
      if not okay then
        return false, false, state, err
      end
    end
  end

  return true, true, state, nil
end

local function tokenize_attribute_value(state)
  local buffer = state.buffer
  local char
  local len

  char, len = buffer:read_utf8_codepoint()

  local data
  if char == "'" then
    data = buffer:scan_until("'")
  elseif char == "\"" then
    data = buffer:scan_until("\"")
  end

  if data then
    state.tokens:push_token("attr_value", data)
    return true, true, state, nil
  end

  return false, false, state, "invalid attribute value"
end

local function tokenize_element(state)
  local buffer = state.buffer
  local char
  local len

  local opos = buffer:tell()

  local result = {
    name = "",
  }

  -- first thing is the name
  local name = read_name(state)

  if name then
    state.tokens:push_token("name", name)
  else
    return false, false, state, "invalid STag sequence"
  end

  local should_continue, okay, err
  while not buffer:isEOF() do
    tokenize_spaces(state)
    name = read_name(state)
    if name then
      state.tokens:push_token("name", name)
      tokenize_spaces(state)
      char, len = buffer:peek_utf8_codepoint()
      if char == "=" then
        buffer:walk(len)
        state.tokens:push_token("eq", true)
        tokenize_spaces(state)
        should_continue, okay, state, err = tokenize_attribute_value(state)
        if not okay then
          return false, false, state, err
        end
      else
        return false, false, state, "inavlid attribute sequence"
      end
    else
      break
    end
  end

  tokenize_spaces(state)
  char, len = buffer:peek_utf8_codepoint()
  if char == "/" then
    buffer:walk(len)
    char, len = buffer:peek_utf8_codepoint()
    if char == ">" then
      buffer:walk(len)
      state.tokens:push_token("empty_stag_close", true)
      return true, true, state, nil
    end
  elseif char == ">" then
    buffer:walk(len)
    state.tokens:push_token("stag_close", true)
    return true, true, state, nil
  end
  return false, false, state, "invalid element sequence"
end

local function tokenize_processor_ins(state)
  local buffer = state.buffer
  local char
  local last_char
  local len
  local pos
  local i = 0
  local acc
  -- "-->"
  local org_pos = buffer:tell()

::check_closing::
  pos = buffer:tell()
  char, len = buffer:peek_utf8_codepoint()
  if char == "?" then
    buffer:walk(len)
    char, len = buffer:read_utf8_codepoint()
    if char == ">" then
      state.tokens:push_token("processor_ins_body", table.concat(acc))
      state.tokens:push_token("processor_ins_close", true)
      return true, true, state, nil
    end
    buffer:seek(pos)
  end
::add_character::
  if char then
    buffer:skip_utf8_codepoint()
    i = i + 1
    acc[i] = char
    last_char = char
    goto check_closing
  end
::abort::
  buffer:seek(org_pos)
  return false, false, state, "aborted processor instruction body"
end

local function tokenize_all(state)
  local buffer = state.buffer
  local ok
  local err
  local should_continue

  while not buffer:isEOF() do
    if state.name == "default" then
      should_continue, ok, state, err = tokenize_default(state)
      if not should_continue then
        return ok, state, err
      end

    elseif state.name == "cdata" then
      should_continue, ok, state, err = tokenize_cdata_body(state)
      if not should_continue then
        return ok, state, err
      end
      state.name = "default"

    elseif state.name == "comment" then
      should_continue, ok, state, err = tokenize_comment_body(state)
      if not should_continue then
        return ok, state, err
      end
      state.name = "default"

    elseif state.name == "element" then
      should_continue, ok, state, err = tokenize_element(state)
      if not should_continue then
        return ok, state, err
      end
      state.name = "default"

    elseif state.name == "processor_ins" then
      should_continue, ok, state, err = tokenize_processor_ins(state)
      if not should_continue then
        return ok, state, err
      end
      state.name = "default"

    else
      return false, state, "unexpected state `" .. state.name .. "`"
    end
  end

  if state.name == 'term' then
    state.tokens:push_token("term", state.acc)
    state.acc = ''
    state.name = 'default'
  end

  return true, state
end

--- @spec tokenize(blob: String): (Boolean, TokenBuffer, rest: String)
function Lexer.tokenize(blob)
  local buffer = StringBuffer:new(blob, "r")

  local state = {
    name = "default",
    data = nil,
    buffer = buffer,
    depth = 0,
    acc = "",
    tokens = TokenBuffer:new(),
  }
  local ok
  local err

  state.tokens:open('w')
  ok, state, err = tokenize_all(state)
  state.tokens:open('r')

  if ok then
    return true, state.tokens, state.buffer:read()
  else
    return false, nil, err
  end
end

XML.Lexer = Lexer
