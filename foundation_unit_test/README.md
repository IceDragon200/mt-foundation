# Foundation Unit Test (Luna)

A basic unit testing framework for foundation.

## Usage

```lua
local case = foundation.com.Luna:new("YourCaseNameHere")

-- case is the top-level instance of the Luna testing module
case:describe("a description of what is being tested", function (t2)
  -- t2 is another instance of the testing module
  t2:test("it does something that it is suppose to", function (t3)
    -- yet another instance
    t3:assert(1 == 1)
  end)
end)

case:execute() -- runs the actual unit tests
case:display_stats() -- displays the results using the reporter configured
case:maybe_error() -- if any test had failed, this will error() and (hopefully) stop execution
```
