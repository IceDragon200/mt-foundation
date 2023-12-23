--- @namespace foudation_kdl.KDL.Decoder
local KDL = foundation_kdl.KDL

local List = assert(foundation.com.List)
local string_starts_with = assert(foundation.com.string_starts_with)
local string_trim_leading = assert(foundation.com.string_trim_leading)

--
-- local NULL = {}
local SLASHDASH = {}

local Decoder = {}

local function term_to_binary_int(term)
  local sign = 1
  local rest = term

  if string_starts_with(rest, "+") then
    rest = string_trim_leading(rest, "+")
  elseif string_starts_with(rest, "-") then
    sign = -1
    rest = string_trim_leading(rest, "-")
  end

  rest = string_trim_leading(rest, "0b")
  local ri = 0
  local result = {}

  local i = 0
  local len = #rest
  local char

  while i < len do
    i = i + 1
    char = string.sub(rest, i, i)

    if char == '0' or char == '1' then
      ri = ri + 1
      result[ri] = char
    elseif char == '_' then
      if i <= 1 then
        error("cannot lead binary int with an underscore")
      end
    else
      error("unexpected char " .. char)
    end
  end

  return assert(tonumber(table.concat(result), 2) * sign)
end

local function term_to_octal_int(term)
  local sign = 1
  local rest = term

  if string_starts_with(rest, "+") then
    rest = string_trim_leading(rest, "+")
  elseif string_starts_with(rest, "-") then
    sign = -1
    rest = string_trim_leading(rest, "-")
  end

  rest = string_trim_leading(rest, "0o")
  local ri = 0
  local result = {}

  local i = 0
  local len = #rest
  local char

  while i < len do
    i = i + 1
    char = string.sub(rest, i, i)

    if char >= '0' and char <= '7' then
      ri = ri + 1
      result[ri] = char
    elseif char == '_' then
      if i <= 1 then
        error("cannot lead octal int with an underscore")
      end
    else
      error("unexpected char " .. char)
    end
  end

  return assert(tonumber(table.concat(result), 8) * sign)
end

local function term_to_hex_int(term)
  local sign = 1
  local rest = term

  if string_starts_with(rest, "+") then
    rest = string_trim_leading(rest, "+")
  elseif string_starts_with(rest, "-") then
    sign = -1
    rest = string_trim_leading(rest, "-")
  end

  rest = string_trim_leading(rest, "0x")
  local ri = 0
  local result = {}

  local i = 0
  local len = #rest
  local char

  while i < len do
    i = i + 1
    char = string.sub(rest, i, i)

    if (char >= '0' and char <= '9') or
       (char >= 'A' and char <= 'F') or
       (char >= 'a' and char <= 'f') then
      ri = ri + 1
      result[ri] = char
    elseif char == '_' then
      if i <= 1 then
        error("cannot lead hex int with an underscore")
      end
    else
      error("unexpected char " .. char)
    end
  end

  return assert(tonumber(table.concat(result), 16) * sign)
end

local function term_to_number(term)
  local ty = 'integer'

  local sign = 1
  local rest = term

  if string_starts_with(rest, "+") then
    rest = string_trim_leading(rest, "+")
  elseif string_starts_with(rest, "-") then
    sign = -1
    rest = string_trim_leading(rest, "-")
  end

  local ri = 0
  local result = {}

  local i = 0
  local dp_i
  local exp_i
  local len = #rest
  local char

  while i < len do
    i = i + 1
    char = string.sub(rest, i, i)

    if char >= '0' and char <= '9' then
      ri = ri + 1
      result[ri] = char
    elseif ty == 'float' and (char == 'e' or char == 'E') then
      exp_i = i
      ri = ri + 1
      result[ri] = char
    elseif ty == 'integer' and char == '.' then
      dp_i = i
      ty = 'float'
      ri = ri + 1
      result[ri] = char
    elseif (exp_i and (exp_i - i) == 1) and (char == '+' or char == '-') then
      ri = ri + 1
      result[ri] = char
    elseif char == '_' then
      local cond = i > 1 or (dp_i and (dp_i - i) > 1)
      if not cond then
        error("cannot lead decimal int with an underscore")
      end
    else
      error("unexpected char " .. char)
    end
  end

  return ty, assert(tonumber(table.concat(result)) * sign), 'plain'
end

local function term_to_value(term)
  if term == 'true' then
    return 'boolean', true, 'plain'

  elseif term == 'false' then
    return 'boolean', false, 'plain'

  elseif term == 'null' then
    return 'null', nil, 'plain'

  elseif string_starts_with(term, "0b") or
         string_starts_with(term, "+0b") or
         string_starts_with(term, "-0b") then
    -- binary
    return 'integer', term_to_binary_int(term), 'binary'

  elseif string_starts_with(term, "0o") or
         string_starts_with(term, "+0o") or
         string_starts_with(term, "-0o") then
    -- octal
    return 'integer', term_to_octal_int(term), 'octal'

  elseif string_starts_with(term, "0x") or
         string_starts_with(term, "+0x") or
         string_starts_with(term, "-0x") then
    -- hex
    return 'integer', term_to_hex_int(term), 'hex'

  else
    local char = string.sub(term, 1, 1)
    local char2 = string.sub(term, 2, 2)
    if (char >= '0' and char <= '9') or
       ((char == '+' or char == '-') and
        (char2 >= '0' and char2 <= '9')) then
      return term_to_number(term)
    end
    return 'id', term, 'plain'
  end
end

local function token_to_argument(token, annotations)
  if token[1] == "term" then
    -- either an ident / key
    local ty, value, format = term_to_value(token[2])
    return KDL.Node.Argument:new{
      type = ty,
      value = value,
      format = format,
      annotations = annotations,
    }

  elseif token[1] == "dquote_string" then
    return KDL.Node.Argument:new{
      type = 'string',
      value = token[2],
      annotations = annotations,
    }

  elseif token[1] == "raw_string" then
    return KDL.Node.Argument:new{
      type = 'string',
      value = token[2],
      format = 'raw',
      annotations = annotations,
    }

  else
    error("unexpected token `" .. token[1] .. "`")

  end
end

local function unfold_leading_tokens(state, remaining)
  remaining = remaining or 1
  local tokens = state.tokens

  while not tokens:isEOB() do
    if tokens:is_next_token('space') then
      tokens:walk(1)
    elseif tokens:is_next_token('nl') and remaining > 0 then
      remaining = remaining - 1
      tokens:walk(1)
    elseif tokens:is_next_token('fold') then
      remaining = remaining + 1
      tokens:walk(1)
    else
      break
    end
  end
end

local function read_leading_annotations(state)
  local tokens = state.tokens
  local token

  while not tokens:isEOB() do
    if tokens:is_next_token('annotation') then
      token = tokens:next_token()
      state.data.annotations:push(token[2])
    else
      break
    end
  end
end

local function return_state(state)
  local entry = state.stack:pop()

  state.name = entry.name
  state.data = entry.data
  state.prev_acc = state.acc
  state.acc = entry.acc
end

local function commit_node(state)
  -- TODO: handle data acc to place attributes into node
  local item
  local node
  local i
  local acc

  if state.data then
    node = state.data.node

    i = 0

    -- the node's accumulator only contains attributes
    acc = state.acc
    if acc:size() > 0 then
      while i < acc:size() do
        i = i + 1
        item = acc:get(i)
        if item == SLASHDASH then
          -- skip the next token
          i = i + 1
        else
          node.attributes:push(item)
        end
      end
    end
    state.acc:clear()

    -- the prev_acc contains the children of the node
    if state.prev_acc then
      if node.children then
        node.children:concat(state.prev_acc)
      else
        assert(
          state.prev_acc:size() == 0,
          "previous accumulator has items, but the node didn't expect any"
        )
      end
    end

    -- push itself unto the accumulator so it can be picked up by the parent
    state.acc:push(node)
  else
    error("nothing to commit")
  end
end

local function handle_close_block(state)
  commit_node(state)
  return_state(state)
end

local function decode_no_op(_tokens, _token, _state)
  -- nothing to do here
  return false
end

local function decode_node_start(_tokens, token, state)
  -- node start

  -- push current state unto stack
  state.stack:push({
    name = 'default',
    acc = state.acc:copy()
  })
  -- wipe it so the node can use it next
  state.acc:clear()

  local annotations = state.annotations:data()
  state.annotations:clear()
  state.data = {
    node = KDL.Node:new(token[2], { annotations = annotations }),
    annotations = List:new(),
  }

  -- switch to the node state
  state.name = 'node'
  return true
end

local function decode_node_close_block(tokens, _token, state)
  -- return to previous state to handle close block
  tokens:walk(-1) -- step back cursor
  return_state(state)
  return true
end

local TOKEN_DECODER_DEFAULT = {
  annotation = function (_tokens, token, state)
    state.annotations:push(token[2])
    return false
  end,

  slashdash = function (_tokens, _token, state)
    state.acc:push(SLASHDASH)
    return false
  end,

  comment_multiline_c = decode_no_op,

  comment_c = decode_no_op,

  fold = function (_tokens, _token, state)
    unfold_leading_tokens(state)
    return false
  end,

  sc = decode_no_op,
  nl = decode_no_op,
  space = decode_no_op,

  term = decode_node_start,
  dquote_string = decode_node_start,
  raw_string = decode_node_start,

  close_block = decode_node_close_block,
}

local function decode_default(state)
  local tokens = state.tokens
  local token
  local token_name
  local func

  if state.prev_acc then
    -- unroll the previous accumulator unto the current one
    state.acc:concat(state.prev_acc)
    state.prev_acc = nil
  end

  while not tokens:isEOB() do
    token = tokens:next_token()
    token_name = token[1]

    func = TOKEN_DECODER_DEFAULT[token_name]

    if func then
      if func(tokens, token, state) then
        break
      end
    else
      error("unexpected token while in default state `" .. token_name .. "`")
    end
  end
end

local function decode_commit(_tokens, _token, state)
  -- newline or semicolon to terminate current node
  commit_node(state)
  return_state(state)
  return true
end

local function decode_node_node_start(tokens, token, state)
  -- attributes
  local key_annotations = state.data.annotations:data()
  state.data.annotations:clear()

  local key = token_to_argument(token, key_annotations)

  -- unfold as if it was just spaces and handling any potential folds
  unfold_leading_tokens(state, 0)

  if tokens:is_next_token('=') then
    -- this is a property
    tokens:next_token() -- skip '='
    unfold_leading_tokens(state, 0) -- try unfolding again

    read_leading_annotations(state)
    local value_annotations = state.data.annotations:data()
    state.data.annotations:clear()

    local nt = tokens:next_token()

    local value = token_to_argument(nt, value_annotations)

    state.acc:push(KDL.Node.Property:new(key, value))
  else
    state.acc:push(key)
  end
end

local TOKEN_DECODER_NODE = {
  slashdash = TOKEN_DECODER_DEFAULT.slashdash,

  comment_multiline_c = decode_no_op,
  comment_c = decode_no_op,
  space = decode_no_op,

  fold = TOKEN_DECODER_DEFAULT.fold,

  nl = decode_commit,
  sc = decode_commit,

  open_block = function (_tokens, _token, state)
    state.data.node.children = List:new()

    state.stack:push({
      name = 'node',
      data = state.data,
      acc = state.acc:copy(),
    })
    state.acc:clear()
    state.data = nil
    state.name = 'default'
    return true
  end,

  close_block = function (_tokens, _token, state)
    handle_close_block(state)
    return true
  end,

  annotation = function (_tokens, token, state)
    state.data.annotations:push(token[2])
    return false
  end,

  term = decode_node_node_start,
  dquote_string = decode_node_node_start,
  raw_string = decode_node_node_start,
}

local function decode_node(state)
  local tokens = state.tokens
  local token
  local token_name
  local func

  while not tokens:isEOB() do
    token = tokens:next_token()
    token_name = token[1]

    func = TOKEN_DECODER_NODE[token_name]

    if func then
      if func(tokens, token, state) then
        break
      end
    else
      error("unexpected token in node state `" .. token_name .. "`")
    end
  end
end

local function decode_all(state)
  local tokens = state.tokens

  while not tokens:isEOB() do
    if state.name == 'default' then
      decode_default(state)
    elseif state.name == 'node' then
      decode_node(state)
    else
      error("unexpected state " .. state.name)
    end
  end
end

--- Decodes a given string or list of tokens into a KDL document (list of nodes)
---
--- @spec decode(String | Token[]): (Boolean, Node[])
function Decoder.decode(blob)
  local tokens
  local err
  local ok

  if type(blob) == 'string' then
    ok, tokens, err = KDL.tokenize(blob)

    if not ok then
      return false, tokens, err
    end
  elseif type(blob) == 'table' then
    -- ok = true
    tokens = blob
  else
    return false, nil, "invalid blob"
  end

  local state = {
    line = 1,
    name = 'default',
    tokens = tokens,
    annotations = List:new(),
    acc = List:new(),
    stack = List:new(),
    data = nil,
  }

  decode_all(state)

  return true, state.acc:data()
end

KDL.Decoder = Decoder
