local KDL = foundation_kdl.KDL

local List = assert(foundation.com.List)

local SLASHDASH = {}

local Decoder = {}

local function unfold_leading_tokens(state)
  local tokens = state.tokens

  while not tokens:isEOB() do
    if tokens:is_next_token('space') or tokens:is_next_token('nl') then
      tokens:walk(1)
    else
      break
    end
  end
end

local function decode_default(state)
  local tokens = state.tokens
  local token
  local token_name
  local annotations

  while not tokens:isEOB() do
    token = tokens:next_token()
    token_name = token[1]

    if token_name == 'annotation' then
      state.annotations:push(token[2])
    elseif token_name == 'slashdash' then
      state.acc:push(SLASHDASH)
    elseif token_name == 'comment' then
      -- nothing to do here
    elseif token_name == 'fold' then
      unfold_leading_tokens(state)
    elseif token_name == 'sc' then
      -- loose semi-colon
    elseif token_name == 'nl' then
      -- leading newlines
    elseif token_name == 'space' then
      -- leading spaces
    elseif token_name == 'term' or
           token_name == 'dquote_string' or
           token_name == 'raw_string' then
      -- node start
      annotations = state.annotations:data()
      state.annotations:clear()
      state.data = {
        name = token[2],
        annotations = annotations,
        children = {},
        attributes = {},
        acc = List:new(),
      }
      state.name = 'node'
      break
    else
      error("unexpected token " .. token_name)
    end
  end
end

local function decode_node(state)
  local tokens = state.tokens
  local token
  local token_name
  local annotations

  while not tokens:isEOB() do
    token = tokens:next_token()
    token_name = token[1]

    if token_name == ''
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
    ok = true
    tokens = blob
  else
    return false, nil, "invalid blob"
  end

  local state = {
    name = 'default',
    tokens = tokens,
    annotations = List:new(),
    acc = List:new(),
    stack = List:new(),
    data = nil,
  }

  decode_all(state)
end

KDL.Decoder = Decoder
