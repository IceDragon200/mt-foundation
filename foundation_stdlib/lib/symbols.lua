-- @namespace foundation.com

--
-- Symbols are strings mapped to an integer, for... reasons
--
local Symbols = {
  m_ids = 0,
  m_id_to_symbol = {},
  m_symbol_to_id = {},
}

function Symbols:alloc_symbol(symbol)
  if self.m_symbol_to_id[symbol] then
    error("symbol already allocated `" .. sym .. "`")
  end

  self.m_ids = self.m_ids + 1
  local id = self.m_ids
  self.m_symbol_to_id[symbol] = id
  self.m_id_to_symbol[id] = symbol
  return id
end

function Symbols:maybe_id_to_symbol(id)
  return self.m_id_to_symbol[id]
end

function Symbols:maybe_symbol_to_id(symbol)
  return self.m_symbol_to_id[symbol]
end

function Symbols:symbol_to_id(symbol)
  return self:maybe_symbol_to_id(symbol) or
         self:alloc_symbol(symbol)
end

foundation.com.Symbols = Symbols
