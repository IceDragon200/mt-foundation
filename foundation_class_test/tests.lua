local M = assert(foundation.com.Class)

local case = foundation.com.Luna:new("foundation.com.Class")

case:describe("class methods", function (kc)
  kc:describe("&extends/1", function (t2)
    t2:test("creates a new class from base class", function (t3)
      M:extends("test.a")
    end)

    t2:test("can create an inheritance chain", function (t3)
      local a = M:extends("test.a")
      local b = a:extends("test.b")
      local c = b:extends("test.c")

      t3:assert_table_eq({ c, b, a, M }, c:ancestors())
      t3:assert_table_eq({ b, a, M }, b:ancestors())
      t3:assert_table_eq({ a, M }, a:ancestors())
      t3:assert_table_eq({ M }, M:ancestors())
    end)

    t2:test("can inherit functions from parent", function (t3)
      local a = M:extends("test.a")

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

  kc:describe("&is_child_of/1", function (t2)
    t2:test("can determine if class is descendant of another class or itself", function (t3)
      local a = M:extends("test.a")

      t3:assert(M:is_child_of(M))
      t3:assert(a:is_child_of(M))
      t3:assert(a:is_child_of(a))
    end)
  end)
end)

case:describe("instance methods", function (kc)
  kc:describe("inspect", function (t2)
    t2:test("reports object properties", function (t3)
      local a = M:new()
      local b = M:new()
      local c = M:new()
      a.b = b
      a.x = "Hello"
      a.y = false
      a.w = true
      a.z = 12
      b.c = c
      b.x = { "A", "B", "C" }
      c.a = a
      c.x = {
        x = 1,
        y = 2,
        z = 3,
      }
      local str = a:inspect()
      -- For now it's a bit hard to validate the string
      t3:assert_eq(type(str), "string")
    end)
  end)

  kc:describe("to_string", function (t2)
    t2:test("converts the object to a string", function (t3)
      local instance = M:new()
      local child_class = M:extends("test_child")
      local child_instance = child_class:new()

      t3:assert_eq(M.__mt.__tostring(M), tostring(M))
      t3:assert_eq(child_class.__mt.__tostring(child_class), tostring(child_class))
      t3:assert_eq(M.__imt.__tostring(instance), tostring(instance))
      t3:assert_eq(child_class.__imt.__tostring(child_instance), tostring(child_instance))
    end)
  end)

  kc:describe("equality", function (t2)
    t2:test("can check for object equality", function (t3)
      local a = M:new()
      local b = M:new()

      --- They should NOT be the same object
      t3:refute_raw_eq(a, b)
      -- These should be equal
      t3:assert_raw_eq(a, a)
      t3:assert_raw_eq(b, b)
      t3:assert_eq(a, b)
    end)
  end)

  kc:describe("#copy/0", function (t2)
    t2:test("can copy an object", function (t3)
      local a = M:new()
      a.x = 1
      a.y = "hi"
      a.z = { a = "Other" }
      local b = a:copy()

      t3:refute_raw_eq(a, b)
      t3:assert_eq(a, b)
    end)
  end)

  kc:describe("#matches/1", function (t2)
    t2:test("can pattern match an object", function (t3)
      local a = M:new()

      t3:assert(a:matches({}))
      t3:refute(a:matches({ a = 1 }))
      a.a = 1
      t3:assert(a:matches({ a = 1 }))
    end)
  end)

  kc:describe("#tap/1+", function (t2)
    t2:test("can tap into an object to execute callback", function (t3)
      local a = M:new()

      local c = 0
      a:tap(function (z)
        t3:assert(rawequal(a, z), "expected tap to return self")
        c = 1
      end)

      t3:assert_eq(c, 1)
    end)
  end)

  kc:describe("#method/1", function (t2)
    t2:test("can create a detached function", function (t3)
      local a = M:new()

      local func = a:method("to_string")

      t3:assert_eq(func(), a:to_string())
    end)
  end)

  kc:describe("#is_instance_of/1", function (t2)
    t2:test("can correctly determine if an object is an instance of a class", function (t3)
      local object = M:new()

      t3:assert(object:is_instance_of(M))
    end)

    t2:test("can correctly determine if an object is an instance of an ancestor", function (t3)
      local a = M:extends("test.a")
      local object = a:new()

      t3:assert(object:is_instance_of(M))
      t3:assert(object:is_instance_of(a))
    end)
  end)
end)

case:describe("is_object/1", function (t2)
  t2:test("can determine if a value is a class instance", function (t3)
    t3:refute(M.is_object(0))
    t3:refute(M.is_object('abc'))
    t3:refute(M.is_object({}))
    t3:refute(M.is_object(M)) -- well yes, but no

    local a = M:new()
    t3:assert(M.is_object(a))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
