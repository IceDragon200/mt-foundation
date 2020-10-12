local Tweener = {}

function Tweener.get_easer(easer)
  local easer_fun = easer
  if type(easer) == "string" then
    easer_fun = foundation.com.Easers[easer]
  end
  return easer_fun
end

-- Returns a tween application function, calling it will make changes
-- fo the provided object.
--
-- from is a table that contains the initial property values that should be tweened 'from'.
-- to is a table that contains the expected end values to tween 'to'
--
-- @spec new(table, table, table, string|function) :: (float) => void
function Tweener.new(object, from, to, easer)
  local easer_fun = Tweener.get_easer(easer)
  assert(easer_fun, "expected an easer function")
  return function (t)
    for key,a in pairs(from) do
      local b = to[key]
      local d = b - a
      object[key] = a + d * easer_fun(t)
    end
  end
end

foundation.com.Tweener = Tweener
