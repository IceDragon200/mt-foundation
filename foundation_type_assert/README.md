# Foundation Type Assert

Data type assertion functions.

## Summary

If you've ever found yourself writing code like this:

```lua
assert(obj)
assert(type(obj) == "string")
```

Then you probably want type assertions:

```lua
foundation.com.assert.is_string(obj)
```
