local Class = assert(foundation.com.Class)

local case = foundation.com.Luna:new("foundation.com.Class")

case:describe("&extends/1", function (t2)
  t2:test("creates a new class from base class", function (t3)
    Class:extends("test.a")
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

  t2:test("can inherit functions from parent", function (t3)
    local a = Class:extends("test.a")

    function a.instance_class:abc()
      return 1
    end

    local b = a:extends("test.b")

    function b.instance_class:fgh()
      return 2
    end

    local aints = a:new()
    local bints = b:new()

    t3:assert(aints.abc, "expected a to have abc method")
    t3:refute(aints.fgh, "expected a to not have fgh method")

    t3:assert(bints.abc, "expected b to have abc method")
    t3:assert(bints.fgh, "expected b to have fgh method")
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
