# 1.1.0

* Corrected behaviour of `#set_string/2` when given an empty string
* `#equals/1` now checks if the other object is a FakeMetaRef, or if the object implements `#to_table/0`
* `#from_table/1` now returns true when given a table to overwrite data and false otherwise.
