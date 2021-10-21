local Class = assert(foundation.com.Class)

local case = foundation.com.Luna:new("foundation.com.Class")

case:describe(":extends/1", function (t2)
  t2:test("creates a new class from base class", function (t3)
    local a = Class:extends("test.a")
  end)

  t2:test("can create an inheritance chain", function (t3)
    local a = Class:extends("test.a")
    local b = a:extends("test.b")
    local c = b:extends("test.c")

    t3:assert_table_eq({ c, b, a, Class }, c:ancestors())
    t3:assert_table_eq({ b, a, Class }, b:ancestors())
    t3:assert_table_eq({ a, Class }, a:ancestors())
    t3:assert_table_eq({ Class }, Class:ancestors())
  end)
end)

case:describe("#is_instance_of/1", function (t2)
  t2:test("can correctly determine if an object is an instance of a class", function (t3)
    local object = Class:new()

    t3:assert(object:is_instance_of(Class))
  end)

  t2:test("can correctly determine if an object is an instance of an ancestor", function (t3)
    local a = Class:extends("test.a")
    local object = a:new()

    t3:assert(object:is_instance_of(Class))
    t3:assert(object:is_instance_of(a))
  end)
end)

case:describe("#is_child_of/1", function (t2)
  t2:test("can determine if class is descendant of another class or itself", function (t3)
    local a = Class:extends("test.a")

    t3:assert(Class:is_child_of(Class))
    t3:assert(a:is_child_of(Class))
    t3:assert(a:is_child_of(a))
  end)
end)

case:describe("is_object/1", function (t2)
  t2:test("can determine if a value is a class instance", function (t3)
    t3:refute(Class.is_object(0))
    t3:refute(Class.is_object('abc'))
    t3:refute(Class.is_object({}))
    t3:refute(Class.is_object(Class)) -- well yes, but no

    local a = Class:new()
    t3:assert(Class.is_object(a))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
