local Luna = assert(foundation.com.Luna)
local m = foundation.com.Waves

local case = Luna:new("foundation.com.Waves")

case:describe("sine/1", function (t2)
  t2:test("can produce a triangle wave given input over time", function (t3)
    for i = 1,100 do
      t3:assert_in_range(m.sine(i / 100), -1, 1)
    end
  end)
end)

case:describe("triangle/1", function (t2)
  t2:test("can produce a triangle wave given input over time", function (t3)
    for i = 1,100 do
      t3:assert_in_range(m.triangle(i / 100), -1, 1)
    end
  end)
end)

case:describe("saw/1", function (t2)
  t2:test("can produce a sawtooth wave given input over time", function (t3)
    for i = 1,100 do
      t3:assert_in_range(m.saw(i / 100), -1, 1)
    end
  end)
end)

case:describe("square/1", function (t2)
  t2:test("can produce a square wave given input over time", function (t3)
    for i = 1,100 do
      t3:assert_in_range(m.square(i / 100), -1, 1)
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
