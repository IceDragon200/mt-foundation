local KDL = foundation_kdl.KDL
local utf8 = assert(foundation.com.utf8)
local table_merge = assert(foundation.com.table_merge)
local StringBuffer = assert(foundation.com.StringBuffer)
local TokenBuffer = assert(foundation.com.TokenBuffer)
local List = assert(foundation.com.List)

local Lexer = {}

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

local NON_IDENTIFITER_CHARACTER = table_merge(SPACE_CHARACTER, NEWLINE_CHARACTER, {
  -- rest
  ['='] = true,
  ['\\'] = true,
  ['<'] = true,
  ['>'] = true,
  ['{'] = true,
  ['}'] = true,
  [';'] = true,
  ['['] = true,
  [']'] = true,
  ['('] = true,
  [')'] = true,
  [','] = true,
  ['"'] = true,
})

local function try_tokenize_raw_string_start(state)
  local buffer = state.buffer

  local char = buffer:peek_utf8_codepoint()

  if char == '"' then
    buffer:skip_utf8_codepoint() -- consume '"'
    state.name = "raw_string"
    state.data = '"'
    return true, state

  elseif char == '#' then
    local cursor = buffer:tell()

    state.name = "raw_string"
    state.data = '"' .. buffer:scan_while('#') -- consume all leading '#'
    if buffer:read_utf8_codepoint() == '"' then -- consume '"'
      return true, state
    else
      -- abort and rewind
      buffer:seek(cursor)
    end
  end

  return false, state, "invalid raw string, expected `\"`"
end

local function tokenize_raw_string_body(state)
  local buffer = state.buffer
  local char
  local len

  while not buffer:isEOF() do
    char, len = buffer:peek_utf8_codepoint() -- consume char

    if char == '"' then
      local cursor = buffer:tell() -- remember original position, we'll need to read a lot here
      local other = ''
      local other_len = 0
      local expected_len = string.len(state.data)
      local nc
      local bytes_read

      while other_len < expected_len do
        nc, bytes_read = buffer:read_utf8_codepoint()
        if nc then
          other_len = other_len + bytes_read
          other = other .. nc
        else
          break
        end
      end

      -- check for terminator
      if other == state.data then
        state.tokens:push_token("raw_string", state.acc)
        state.acc = ''
        state.data = nil
        state.name = "default"
        break

      else
        buffer:seek(cursor) -- go back to original position
        buffer:skip_utf8_codepoint() -- consume char like normal
        state.acc = state.acc .. char
      end
    else
      buffer:walk(len)
      state.acc = state.acc .. char
    end
  end
end

local function tokenize_dquote_string_body(state)
  local buffer = state.buffer
  local char
  local len

  while not buffer:isEOF() do
    char = buffer:read_utf8_codepoint() -- consume char

    if char == '"' then
      state.tokens:push_token("dquote_string", state.acc)
      state.acc = ''
      state.name = 'default'
      break

    elseif char == '\\' then
      char, len = buffer:peek_utf8_codepoint()

      if char == '\\' then
        buffer:walk(len)
        state.acc = state.acc .. '\\'

      elseif char == '"' then
        buffer:walk(len)
        state.acc = state.acc .. '"'

      elseif char == 'r' then
        buffer:walk(len)
        state.acc = state.acc .. '\r'

      elseif char == 'n' then
        buffer:walk(len)
        state.acc = state.acc .. '\n'

      elseif char == 'b' then
        buffer:walk(len)
        state.acc = state.acc .. '\b'

      elseif char == 'f' then
        buffer:walk(len)
        state.acc = state.acc .. '\f'

      elseif char == 's' then
        buffer:walk(len)
        state.acc = state.acc .. ' '

      elseif char == 't' then
        buffer:walk(len)
        state.acc = state.acc .. '\t'

      elseif char == '/' then
        buffer:walk(len)
        state.acc = state.acc .. '/'

      else
        return false, state, "unexpected escaped character `" .. char .. "`"
      end
    else
      state.acc = state.acc .. char
    end
  end

  return true, state, nil
end

local function tokenize_multline_comment_c_body(state)
  local buffer = state.buffer

  local char
  local len

  while not buffer:isEOF() do
    char = buffer:read_utf8_codepoint() -- consume char

    -- check if the char is a *
    if char == '*' then
      char, len = buffer:peek_utf8_codepoint()
      -- then check if the next char is the closing slash
      if char == '/' then
        -- skip this char in the buffer, since we peeked at it
        buffer:walk(len)

        if state.depth > 0 then
          -- decrement the depth instead
          state.depth = state.depth - 1
          state.acc = state.acc .. '*/'

        else
          -- retrieve the comment chars
          state.tokens:push_token("comment_multiline_c", state.acc)
          state.acc = ''
          state.name = 'default'
          break
        end
      else
        -- push the '*' as is, and move on
        state.acc = state.acc .. '*'
      end

    elseif char == '/' then
      char, len = buffer:peek_utf8_codepoint()
      if char == '*' then
        buffer:walk(len)
        -- nested comment
        state.depth = state.depth + 1
        state.acc = state.acc .. '/*'

      else
        state.acc = state.acc .. '/'
      end

    else
      -- otherwise push the char as is unto the list
      state.acc = state.acc .. char
    end
  end
end

local function tokenize_term_body(state)
  local buffer = state.buffer
  local char
  local len

  while not buffer:isEOF() do
    char, len = buffer:peek_utf8_codepoint()

    --                                            "\u{10FFFF}"
    if NON_IDENTIFITER_CHARACTER[char] or char >= "\xF4\x8F\xBF\xBF" then
      state.tokens:push_token("term", state.acc)
      state.acc = ''
      state.name = 'default'
      break

    else
      buffer:walk(len) -- consume char
      state.acc = state.acc .. char

    end
  end
end

local function tokenize_default(state)
  local buffer = state.buffer
  local char
  local len

  while not buffer:isEOF() do
    if state.name ~= 'default' then
      break
    end

    char = buffer:read_utf8_codepoint()

    if char == '(' then
      local annotation = buffer:scan_upto(")")
      if annotation then
        if buffer:read_utf8_codepoint() == ')' then -- consume ")
          state.tokens:push_token('annotation', annotation)
        else
          return false, false, state, "cannot parse annotation"
        end
      else
        return false, false, state, "cannot parse annotation"
      end

    elseif char == '{' then
      state.tokens:push_token('open_block', true)

    elseif char == '}' then
      state.tokens:push_token('close_block', true)

    elseif char == '/' then
      char, len = buffer:peek_utf8_codepoint()

      -- /- | slashdash
      if char == '-' then
        buffer:walk(len) -- consume '-'
        state.tokens:push_token("slashdash", 0)

      -- /* | multiline c-style comment
      elseif char == '*' then
        buffer:walk(len) -- consume '*'
        state.name = "comment_multiline_c"
        -- clear the accumulator to prepare to extract the comment
        state.acc = ''
      elseif char == '/' then
        buffer:walk(len) -- consume '/'

        local comment = buffer:scan_upto("\n")
        if not comment then
          comment = buffer:read()
        end

        state.tokens:push_token('comment_c', comment)
      else
        return false, false, state, "unexpected character after /, `" .. char .. "`"
      end

    elseif char == '"' then
      state.name = "dquote_string"
      state.acc = ''

    -- spaces
    elseif SPACE_CHARACTER[char] then
      local _space = buffer:scan_while(char)
      state.tokens:push_token("space", true)

    -- newlines
    elseif char == '\r' then
      char, len = buffer:peek_utf8_codepoint()
      if char == '\n' then
        buffer:walk(len) -- consume '\n'
      end
      state.tokens:push_token('nl', true)

    elseif NEWLINE_CHARACTER[char] then
      state.tokens:push_token('nl', true)

    elseif char == '=' then
      state.tokens:push_token('=', true)

    elseif char == ';' then
      state.tokens:push_token('sc', true)

    elseif char == 'r' then
      local ok, _state, _err = try_tokenize_raw_string_start(state)
      if ok then
        -- nothing to do, the tokenizer has entered the raw string state
      else
        -- try regular term parsing instead
        state.name = 'term'
        state.acc = char
      end

    elseif char == '\\' then
      state.tokens:push_token('fold', true)

    elseif NON_IDENTIFITER_CHARACTER[char] then
      -- end
      return false, true, state, "cannot parse any further"

    else
      state.name = 'term'
      state.acc = char

    end
  end

  return true, true, state, nil
end

local function tokenize_all(state)
  local buffer = state.buffer
  local char
  local ok
  local err
  local should_continue

  while not buffer:isEOF() do
    if state.name == "default" then
      should_continue, ok, state, err = tokenize_default(state)

      if not should_continue then
        return ok, state, err
      end

    elseif state.name == "comment_multiline_c" then
      tokenize_multline_comment_c_body(state)

    elseif state.name == "dquote_string" then
      ok, state, err = tokenize_dquote_string_body(state)
      if not ok then
        return ok, state, err
      end

    elseif state.name == "raw_string" then
      tokenize_raw_string_body(state)

    elseif state.name == "term" then
      tokenize_term_body(state)

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

function Lexer.tokenize(blob)
  local buffer = StringBuffer:new(blob, 'r')

  local state = {
    name = "default",
    data = nil,
    buffer = buffer,
    depth = 0,
    acc = '',
    tokens = TokenBuffer:new(),
  }

  state.tokens:open('w')
  local ok, state, err = tokenize_all(state)
  state.tokens:open('r')

  if ok then
    return true, state.tokens, state.buffer:read()
  else
    return false, nil, err
  end
end

KDL.Lexer = Lexer
