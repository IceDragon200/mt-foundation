-- @namespace foundation.com

--
-- Symbols are strings mapped to an integer, for... reasons
-- If you notice that the return type is Any for id functions, that is intended.
-- Symbols should be treated as opaque values, their underlying type should not matter.
--
local Symbols = {
  m_ids = 0,
  m_id_to_symbol = {},
  m_symbol_to_id = {},
}

-- @spec &alloc_symbol(symbol: String): Any
function Symbols:alloc_symbol(symbol)
  assert(type(symbol) == "string", "expected symbol to be a string")
  if self.m_symbol_to_id[symbol] then
    error("symbol already allocated `" .. symbol .. "`")
  end

  self.m_ids = self.m_ids + 1
  local id = self.m_ids
  self.m_symbol_to_id[symbol] = id
  self.m_id_to_symbol[id] = symbol
  return id
end

-- @spec &maybe_id_to_symbol(id: Any): String
function Symbols:maybe_id_to_symbol(id)
  return self.m_id_to_symbol[id]
end

-- @spec &maybe_symbol_to_id(symbol: String): Any
function Symbols:maybe_symbol_to_id(symbol)
  return self.m_symbol_to_id[symbol]
end

-- @spec &symbol_to_id(symbol: String): Any
function Symbols:symbol_to_id(symbol)
  return self:maybe_symbol_to_id(symbol) or
         self:alloc_symbol(symbol)
end

foundation.com.Symbols = Symbols
