# `1.3.0`

* Added `#assert_matches/{2,3}` this performs a partial match of the first parameter with the second as a pattern of sorts, at the moment, only tables are partially matched, all other values are treated as opaque
* Added `#refute_matches/{2,3}` does the opposite of assert_matches, if the objects do not match it is considered passed
* Added `#refute_deep_eq/{2,3}` opposite of `#assert_deep_eq/{2,3}`
* Added `#refute_table_eq/{2,3}` opposite of `#assert_table_eq/{2,3}`

# `1.2.0`

* `assert/1+` returns value that was passed in to mimic lua's assert
* `refute/1+` returns value that was passed in to mimic lua's assert

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
