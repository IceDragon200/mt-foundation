--
-- A limited implementation of OpenTrace for benchmarking code paths
--
local Trace = foundation.com.Class:extends("foundation.com.Trace")
local ic = Trace.instance_class

local g_span_id = 0

function ic:initialize(name)
  g_span_id = g_span_id + 1
  self.id = g_span_id
  self.name = name
  self.span_index = 0
  self.spans = {}
  self.s = minetest.get_us_time()
  self.e = nil
  self.d = nil
end

function ic:clear()
  self.spans = {}
  self.span_index = 0
end

function ic:span_start(name)
  local span = Trace:new(name)
  self.span_index = self.span_index + 1
  self.spans[self.span_index] = span
  return span
end

function ic:span_end()
  self.e = minetest.get_us_time()
  self.d = self.e - self.s
end

function ic:span(name, callback)
  local span = self:span_start(name)
  callback()
  span:span_end()
end

function ic:format_traces(prefix, acc)
  acc = acc or {}

  prefix = prefix or ''
  table.insert(acc, prefix)
  table.insert(acc, self.id)
  table.insert(acc, ": ")
  table.insert(acc, self.name)
  table.insert(acc, " (")
  table.insert(acc, self.d or '_')
  table.insert(acc, " µsec)\n")

  local subprefix = prefix .. "  "
  for _, span in ipairs(self.spans) do
    span:format_traces(subprefix, acc)
  end

  return acc
end

function ic:inspect(prefix, acc)
  acc = self:format_traces(prefix, acc or {})
  print(table.concat(acc))
end

foundation.com.Trace = Trace
