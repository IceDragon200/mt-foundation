--- @namespace foundation.com
local format_pretty_unit = assert(foundation.com.format_pretty_unit)

---
--- A limited implementation of OpenTrace for benchmarking code paths
---
--- @class Trace
local Trace = foundation.com.Class:extends("foundation.com.Trace")
do
  local ic = Trace.instance_class

  local g_span_id = 0

  --- @spec &sum_traces(traces: Trace[], acc: Trace[]): Table
  function Trace:sum_traces(traces, acc)
    acc = acc or {}

    local map = {}
    local stack = {}
    local top = 0

    for _, trace in ipairs(traces) do
      top = top + 1
      stack[top] = trace
      top = top + 1
      stack[top] = nil
    end

    local current_trace
    local parent_trace
    local entry
    local entry_name

    while top > 0 do
      parent_trace = stack[top]
      top = top - 1
      current_trace = stack[top]
      top = top - 1

      entry_name = current_trace.name
      entry = map[entry_name]

      if not entry then
        entry = self:new(entry_name)
        map[entry_name] = entry
      end

      if entry.d then
        entry.d = entry.d + current_trace.d
      else
        entry.d = current_trace.d
      end

      if entry.s then
        if current_trace.s < entry.s then
          entry.s = current_trace.s
        end
      else
        entry.s = current_trace.s
      end

      if entry.e then
        if current_trace.e < entry.e then
          entry.e = current_trace.e
        end
      else
        entry.e = current_trace.e
      end

      for _, span in ipairs(current_trace.spans) do
        top = top + 1
        stack[top] = span
        top = top + 1
        stack[top] = current_trace
      end
    end

    local result = {}
    local i = 0
    for _,trace in pairs(map) do
      i = i + 1
      result[i] = trace
    end
    return result
  end

  --- @spec #initialize(name: String): void
  function ic:initialize(name)
    g_span_id = g_span_id + 1
    self.id = g_span_id
    self.name = assert(name, "expected a name for trace")
    self.span_index = 0
    self.spans = {}
    self.s = minetest.get_us_time()
    self.e = nil
    self.d = nil
  end

  --- @spec #clear(): void
  function ic:clear()
    self.spans = {}
    self.span_index = 0
  end

  --- @spec #span_start(name: String): Trace
  function ic:span_start(name)
    assert(name, "expected a span name")
    local span = Trace:new(name)
    self.span_index = self.span_index + 1
    self.spans[self.span_index] = span
    return span
  end

  --- @spec #span_end(): void
  function ic:span_end()
    self.e = minetest.get_us_time()
    self.d = self.e - self.s
  end

  --- @spec #span(name: String, callback: Function/0): void
  function ic:span(name, callback)
    local span = self:span_start(name)
    callback()
    span:span_end()
  end

  --- @spec #format_traces(prefix: String, acc: String[]): String[]
  function ic:format_traces(prefix, acc)
    acc = acc or {}
    local d = '_'

    if self.d then
      d = format_pretty_unit(self.d / 1000000, "sec")
    end

    prefix = prefix or ''
    table.insert(acc, prefix)
    table.insert(acc, self.id)
    table.insert(acc, ": ")
    table.insert(acc, self.name)
    table.insert(acc, " (")
    table.insert(acc, d)
    table.insert(acc, ")\n")

    local subprefix = prefix .. "  "
    for _, span in ipairs(self.spans) do
      span:format_traces(subprefix, acc)
    end

    return acc
  end

  --- @spec #inspect(prefix: String, acc?: String[]): String
  function ic:inspect(prefix, acc)
    acc = self:format_traces(prefix, acc or {})
    return table.concat(acc)
  end
end

foundation.com.Trace = Trace
