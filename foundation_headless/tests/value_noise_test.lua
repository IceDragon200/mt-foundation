local ValueNoise = assert(foundation.com.headless.ValueNoise)

local case = foundation.com.Luna:new("foundation.com.headless.ValueNoise")

case:describe("#get_2d/1", function (t2)
  t2:test("can return a random noise value for position", function (t3)
    local m = ValueNoise:new()

    local v
    for y = -16,16 do
      for x = -16,16 do
        v = m:get_2d({ x = x, y = y })
        t3:assert(v)
      end
    end
  end)
end)

case:describe("#get_3d/1", function (t2)
  t2:test("can return a random noise value for position", function (t3)
    local m = ValueNoise:new()

    local v
    for y = -16,16 do
      for z = -16,16 do
        for x = -16,16 do
          v = m:get_3d({ x = x, y = y, z = z })
          t3:assert(v)
        end
      end
    end
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
