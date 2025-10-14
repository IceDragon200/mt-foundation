local XML = assert(foundation_xml.XML)
local Element = assert(XML.Element)
local List = assert(foundation.com.List)

local Decoder = {}

local function skip_comments(state)
  local tokens = state.tokens
  local i = 0
::skip_space::
  if tokens:scan_one("comment_open") then
    i = i + 1
    tokens:scan_one("comment_body")
    tokens:scan_one("comment_close")
    goto skip_space
  end
  return i > 0
end

local function skip_spaces(state)
  local tokens = state.tokens
  local i = 0

::skip_space::
  if tokens:scan_one("space") then
    i = i + 1
    goto skip_space
  end
  return i > 0
end

local function skip_spaces_and_comments(state)
  while true do
    if not (skip_comments(state) or skip_spaces(state)) then
      break
    end
  end
end

local function decode_default(state)
  local tokens = state.tokens
  local name
  local token
  local token2
  local pos
  local stack = List.new({ state.root })

  while not tokens:isEOB() do
    skip_spaces_and_comments(state)

    if tokens:match_tokens("stag_open", "name") then
      local element = Element:new()
      tokens:scan_one("stag_open")
      token = tokens:scan_one("name")
      element.name = token[2]
      if skip_spaces(state) then
        while not buffer:isEOB() do
          pos = buffer:tell()
          token = tokens:scan_one("name")
          if token then
            skip_spaces(state)
            if tokens:scan_one("eq") then
              skip_spaces(state)
              token2 = tokens:scan_one("attr_value")
              element.attributes:push({
                name = token[2],
                value = token2[2],
              })
            else
              return false, "invalid attribute sequence"
            end
          else
            break
          end
        end
      end

      skip_spaces(state)
      if tokens:match_tokens("stag_close") then
        tokens:scan_one("stag_close")
        stack:last().children:push(element)
        stack:push(element)
      elseif tokens:match_tokens("empty_stag_close") then
        tokens:scan_one("empty_stag_close")
        stack:last().children:push(element)
      else
        return false, "invalid STag element"
      end
    elseif tokens:match_tokens("etag_open", "name") then
      if stack:size() > 1 then
        tokens:scan_one("stag_open")
        token = tokens:scan_one("name")
        name = token[2]
        if stack:last().name == name then
          stack:pop()
        else
          return false, "mismatch closing element (expected " .. stack:last().name .. " got " .. name .. ")"
        end
      else
        return false, "unexpected end element"
      end
    end
  end

  return true
end

local function decode_all(state)
  local tokens = state.tokens
  local okay
  local err

  while not tokens:isEOB() do
    if state.name == "default" then
      okay, err = decode_default(state)
      if not okay then
        return false, err
      end
    elseif state.name == "node" then
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
    ok, tokens, err = XML.tokenize(blob)

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
    root = Element:new(),
  }

  decode_all(state)

  return true, state.root:data()
end

XML.Decoder = Decoder
