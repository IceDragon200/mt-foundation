# Foundation Instrumentation

Instrumentation modules, adds the trace class which can be used to benchmark and then log the result to the console.

## Usage

```lua
local Trace = assert(foundation.com.Trace)

-- Creating the trace context
local trace = Trace:new(context_name)
-- ... code here
trace:span_end()

-- Sub-contexts
local trace = Trace:new(context_name)
local span = trace:span_start(span_name)
-- ... code here
span:span_end()
trace:span_end()

-- Print the result to the console
trace:inspect()
```
