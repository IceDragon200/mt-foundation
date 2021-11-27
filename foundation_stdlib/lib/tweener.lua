-- @namespace foundation.com.Tweener

-- @type EaserFunction: function(Number) => Number

local Tweener = {}

-- @spec get_easer(easer: String | Function): Function
function Tweener.get_easer(easer)
  if type(easer) == "string" then
    return assert(foundation.com.Easers[easer])
  end
  return easer
end

-- Returns a tween application function, calling it will make changes
-- fo the provided object.
--
-- from is a table that contains the initial property values that should be tweened 'from'.
-- to is a table that contains the expected end values to tween 'to'
--
-- @spec new(object: Table,
--           from: Table,
--           to: Table,
--           easer: String | EaserFunction): function(Float) => void
function Tweener.new(object, from, to, easer)
  local easer_fun = Tweener.get_easer(easer)
  assert(easer_fun, "expected an easer function")
  return function (t)
    local b
    local d
    for key,a in pairs(from) do
      b = to[key]
      d = b - a
      object[key] = a + d * easer_fun(t)
    end
  end
end

foundation.com.Tweener = Tweener
