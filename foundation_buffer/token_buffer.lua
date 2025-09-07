--
-- Token Buffer is a utility class for parsing tokens
-- That is, list-like tables with the first element being the name of the token

--- @namespace foundation.com

local table_copy = assert(foundation.com.table_copy)
local list_slice = assert(foundation.com.list_slice)

local function tokens_match(token, matcher)
  return token[1] == matcher
end

local function match_tokens(tokens, start, stop, token_matchers)
  local i = 1
  local len = #tokens

  local matched = false
  local j = start
  while j <= len and i <= stop do
    if tokens[j] then
      local token = tokens[j]
      local matcher_token = token_matchers[i]

      if tokens_match(token, matcher_token) then
        matched = true
      else
        return false
      end
    else
      return false
    end
    i = i + 1
    j = j + 1
  end

  return matched
end

--- @class TokenBuffer
local TokenBuffer = foundation.com.Class:extends("TokenBuffer")
do
  local ic = TokenBuffer.instance_class

  local function _check_readable(self)
    assert(self.m_mode == "r" or self.m_mode == "rw", "expected buffer to be in read mode")
  end

  local function _check_writable(self)
    if self.m_mode ~= "w" and self.m_mode ~= "rw" and self.m_mode ~= "a" then
      error("expected TokenBuffer to be in some kind of write mode")
    end
  end

  --- @spec #initialize(tokens: Table, mode: String): void
  function ic:initialize(tokens, mode)
    ic._super.initialize(self)
    self.m_mode = mode
    self.m_data = tokens or {}
    self:open(mode)
  end

  --- @since "2.5.0"
  --- @spec #initialize_copy(other: TokenBuffer): void
  function ic:initialize_copy(other)
    self.m_mode = other.m_mode
    self.m_cursor = other.m_cursor
    self.m_data = table_copy(other.m_data)
  end

  --- @since "2.5.0"
  --- @spec #copy(): TokenBuffer
  function ic:copy()
    local other = TokenBuffer:alloc()
    other:initialize_copy(self)
    return other
  end

  --- @since "2.5.0"
  --- @spec #tell(): Integer
  function ic:tell()
    return self.m_cursor
  end

  function ic:seek(cursor)
    self.m_cursor = cursor
    return self
  end

  function ic:isEOB()
    return self.m_cursor > #self.m_data
  end

  function ic:to_list()
    return table_copy(self.m_data)
  end

  function ic:reopen(mode)
    return self:open(mode)
  end

  function ic:open(mode)
    self.m_cursor = 1
    self.m_mode = mode or "r"
    -- append
    if self.m_mode == "a" then
      self.m_cursor = 1 + #self.m_data
    end
    return self
  end

  function ic:walk(distance)
    _check_readable(self)
    self.m_cursor = self.m_cursor + distance
    return self
  end

  function ic:push(token)
    _check_writable(self)
    self.m_data[self.m_cursor] = token
    self.m_cursor = self.m_cursor + 1
    return self
  end

  --- @spec push_token(token_name: String, data: Any, debug?: Any): self
  function ic:push_token(token_name, data, debug)
    return self:push({token_name, data, debug})
  end

  --- Returns true if the next token was the specified token type and could be skipped.
  --- Returns false if the token could not be skipped otherwise.
  ---
  --- @spec #skip(token_name: String): Boolean
  function ic:skip(token_name)
    _check_readable(self)
    if not self:isEOB() then
      local token = self.m_data[self.m_cursor]
      if tokens_match(token, token_name) then
        self.m_cursor = self.m_cursor + 1
        return true
      end
    end
    return false
  end

  --- Peeks at the next `count` tokens and returns a table with them.
  ---
  --- @spec #peek(count: Integer): Token[]
  function ic:peek(count)
    return list_slice(self.m_data, self.m_cursor, count)
  end

  --- @since "2.5.0"
  --- @spec #rest(): Token[]
  function ic:rest()
    local len = #self.m_data
    local tokens = list_slice(self.m_data, self.m_cursor, len - self.m_cursor)
    self.m_cursor = len
    return tokens
  end

  --- Returns a list of the matched tokens, or nil if no match
  ---
  --- @spec #scan(...token_names: [String]): [Token] | nil
  function ic:scan(...)
    _check_readable(self)
    local token_matchers = {...}
    local token_matchers_len = #token_matchers

    local i = 1
    local len = #self.m_data

    local tokens = {}

    local j = self.m_cursor
    while j <= len and i <= token_matchers_len do
      if self.m_data[j] then
        local token = self.m_data[j]
        local matcher_token = token_matchers[i]

        if tokens_match(token, matcher_token) then
          table.insert(tokens, token)
        else
          return nil
        end
      else
        return nil
      end
      i = i + 1
      j = j + 1
    end
    self.m_cursor = j
    return tokens
  end

  function ic:scan_one(token_name)
    local tokens = self:scan(token_name)
    if tokens then
      return tokens[1]
    end
    return nil
  end

  function ic:scan_until(token_name)
    _check_readable(self)
    local len = #self.m_data
    local tokens = {}

    local j = self.m_cursor
    while j <= len do
      if self.m_data[j] then
        table.insert(tokens, self.m_data[j])
        if tokens_match(self.m_data[j], token_name) then
          break
        end
      else
        break
      end
      j = j + 1
    end
    self.m_cursor = j

    return tokens
  end

  function ic:scan_upto(token_name)
    _check_readable(self)
    local len = #self.m_data
    local tokens = {}

    local j = self.m_cursor
    while j <= len do
      if self.m_data[j] then
        if tokens_match(self.m_data[j], token_name) then
          break
        else
          table.insert(tokens, self.m_data[j])
        end
      else
        break
      end
      j = j + 1
    end
    self.m_cursor = j

    return tokens
  end

  --- @since "2.1.0"
  --- @spec #is_next_token(String): Boolean
  function ic:is_next_token(token_name)
    _check_readable(self)

    if self.m_cursor <= #self.m_data then
      local token = self.m_data[self.m_cursor]
      return token[1] == token_name
    end

    return false
  end

  --- Returns the next token in the buffer or if offset is provided the token from the current
  --- position at the offset.
  --- The cursor will not be incremented.
  ---
  --- @since "2.1.0"
  --- @spec #peek_token(): Token
  --- @since "2.5.0"
  --- @spec #peek_token(offset: Integer): Token
  function ic:peek_token(offset)
    _check_readable(self)

    offset = offset or 0
    if self.m_cursor <= #self.m_data then
      local token = self.m_data[self.m_cursor + offset]
      return token
    end

    return nil
  end

  --- @since "2.1.0"
  --- @spec #next_token(): Token
  function ic:next_token()
    _check_readable(self)

    if self.m_cursor <= #self.m_data then
      local token = self.m_data[self.m_cursor]
      self.m_cursor = self.m_cursor + 1
      return token
    end

    return nil
  end

  --- Checks if all the given token names match the current tokens
  ---
  --- @spec #match_tokens(...tokens: [String]): Boolean
  function ic:match_tokens(...)
    _check_readable(self)
    local token_matchers = {...}
    local token_matchers_len = #token_matchers
    return match_tokens(self.m_data, self.m_cursor, token_matchers_len, token_matchers)
  end

  TokenBuffer.match_tokens = match_tokens
end

foundation.com.TokenBuffer = TokenBuffer
