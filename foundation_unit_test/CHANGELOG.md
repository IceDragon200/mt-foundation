# `1.1.0`

* Exposed Reporter module `foundation.com.Luna.DefaultReporter`
* Added NullReporter module `foundation.com.Luna.NullReporter`
* Luna's default configuration can be set using `Luna.default_config` at the moment only the reporter can be changed.
* Added `Luna#initialize/2`, which allows passing the config as a second parameter

```lua
Luna:new("Case name", { reporter = Luna.NullReporter })
```

# `1.0.0`

* Initial version
