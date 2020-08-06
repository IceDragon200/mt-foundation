--
-- A limited implementation of OpenTrace for benchmarking code paths
--
local Trace = {}
local g_span_id = 0

function Trace.new(name)
  g_span_id = g_span_id + 1
  return {
    id = g_span_id,
    name = name,
    spans = {},
    s = minetest.get_us_time(),
    e = nil,
    d = nil,
  }
end

function Trace.clear(instance)
  instance.spans = {}
end

function Trace.span_start(instance, name)
  local span = Trace.new(name)
  table.insert(instance.spans, span)
  return span
end

function Trace.span_end(span)
  span.e = minetest.get_us_time()
  span.d = span.e - span.s
end

function Trace.span(instance, name, work)
  local span = Trace.span_start(instance, name)
  work()
  Trace.span_end(span)
end

function Trace.inspect(instance, prefix)
  assert(instance)
  prefix = prefix or ''
  print(prefix .. instance.id .. ": " .. instance.name .. " (" .. (instance.d or '_') .. " usec)")
  local subprefix = prefix .. "  "
  for _, span in ipairs(instance.spans) do
    Trace.inspect(span, subprefix)
  end
end

foundation.com.Trace = Trace
