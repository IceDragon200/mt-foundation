# 2.1.0

* Started tracking changes
* Ported [balm's Object](https://github.com/IceDragon200/balm/blob/10938ae0df5fe082b38e0385b5e8cab66bd50bad/object.lua) class over to foundation, as balm originally started as a fork of foundation's object.
  * This brings nice things such as
    * `#inspect/0`
    * `#copy/0`
      * `#initialize_copy/1` which is used by copy to initialize itself
    * `#to_string/0`
    * `#equals/0`
    * `#matches/1` for partially matching one value against another
    * metamethod inheritance (with some caveats, these are only inherited once upon extends, if the parent changes its metamethods afterwards, the children will be unaffected)
