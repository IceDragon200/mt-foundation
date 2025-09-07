# 2.5.0

* Added `foundation.com.StringBuffer#fill/2`
* Added `foundation.com.StringBuffer#fill_bytes/2`
* Added `foundation.com.StringBuffer#peek_byte/0`
* Added `foundation.com.TokenBuffer#peek_token/1`
* Added `foundation.com.TokenBuffer#scan_raw/1` - a non-prefixed version of scan for time-critical uses

# 2.4.0

* Added `foundation.com.StringBuffer#truncate/0`

# 2.3.0

* Added `foundation.com.StringBuffer#flush/0`
* Added `foundation.com.StringBuffer#can_read/0`
* Added `foundation.com.StringBuffer#check_readable/0`
* Added `foundation.com.StringBuffer#maybe_close/0`
* Added `foundation.com.StringBuffer#reopen/1`

# 2.2.0

* Added `foundation.com.FileBuffer` a wrapper class around a lua file handle

# 2.1.0

* Added `foundation.com.StringBuffer#peek_utf8_codepoint/0`
* Added `foundation.com.StringBuffer#skip_utf8_codepoint/0`
* Added `foundation.com.TokenBuffer#is_next_token/1`
* Added `foundation.com.TokenBuffer#next_token/0`
* Added `foundation.com.TokenBuffer#peek_token/0`

# 2.0.0

* Added `foundation.com.TokenBuffer`
* Added `foundation.com.StringBuffer#read_utf8_codepoint/0`

# 1.0.0

Initial Version
