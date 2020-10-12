--
-- A set of easing functions, can be used directly or through the tweener module.
--
local Easers = {}

function Easers.linear(k)
  return k
end

function Easers.quad_in(k)
  return k * k
end

function Easers.quad_out(k)
  return k * (2 - k)
end

function Easers.in_out(k)
  k = k * 2
  if k < 1 then
    return 0.5 * k * k;
  end
  k = k - 1
  return -0.5 * (k * (k - 2) - 1)
end

function Easers.cube_in(k)
  return k * k * k
end

function Easers.cube_out(k)
  k = k - 1
  return k * k * k + 1
end

function Easers.cube_in_out(k)
  k = k * 2
  if k < 1 then
    return 0.5 * k * k * k
  end
  k = k - 2
  return 0.5 * (k * k * k + 2)
end

function Easers.quart_in(k)
  return k * k * k * k
end

function Easers.quart_out(k)
  k = k - 1
  return 1 - (k * k * k * k)
end

function Easers.quart_in_out(k)
  k = k * 2
  if k < 1 then
    return 0.5 * k * k * k * k
  end
  k = k - 2
  return -0.5 * (k * k * k * k - 2)
end

function Easers.quint_in(k)
  return k * k * k * k * k
end

function Easers.quint_out(k)
  k = k - 1
  return k * k * k * k * k + 1
end

function Easers.quint_in_out(k)
  k = k * 2
  if k < 1 then
    return 0.5 * k * k * k * k * k
  end
  k = k - 2
  return 0.5 * (k * k * k * k * k + 2)
end

function Easers.sine_in(k)
  return 1 - math.sin(k * math.pi / 2)
end

function Easers.sine_out(k)
  return math.sin(k * math.pi / 2)
end

function Easers.sine_in_out(k)
  return 0.5 * (1 - math.cos(math.pi * 2))
end

function Easers.expo_in(k)
  if k == 0 then
    return 0
  else
    return math.pow(1024, k - 1)
  end
end

function Easers.expo_out(k)
  if k == 1 then
    return 1
  else
    return 1 - math.pow(2, -10 * k)
  end
end

function Easers.expo_in_out(k)
  if k == 0 then
    return 0
  end

  if k == 1 then
    return 1
  end
  k = k * 2
  if k < 1 then
    return 0.5 * Math.pow(1024, k - 1)
  end

  return 0.5 * (-math.pow(2, -10 * (k - 1)) + 2)
end

function Easers.circ_in(k)
  return 1 - math.sqrt(1 - k * k)
end

function Easers.circ_out(k)
  k = k - 1
  return math.sqrt(1 - k * k)
end

function Easers.circ_in_out(k)
  k = k * 2
  if k < 1 then
    return -0.5 * (math.sqrt(1 - k * k) - 1)
  end
  k = k - 2
  return 0.5 * (math.sqrt(1 - k * k) + 1)
end

function Easers.elastic_in(k)
  if k == 0 then
    return 0
  end

  if k == 1 then
    return 1
  end

  return -math.pow(2, 10 * (k - 1)) * math.sin((k - 1.1) * 5 * math.pi)
end

function Easers.elastic_out(k)
  if k == 0 then
    return 0
  end

  if k == 1 then
    return 1
  end

  return math.pow(2, -10 * k) * math.sin((k - 0.1) * 5 * math.pi) + 1
end

function Easers.elastic_in_out(k)
  if k == 0 then
    return 0
  end

  if k == 1 then
    return 1
  end

  k = k * 2

  if k < 1 then
    return -0.5 * math.pow(2, 10 * (k - 1)) * math.sin((k - 1.1) * 5 * math.pi)
  end

  return 0.5 * math.pow(2, -10 * (k - 1)) * math.sin((k - 1.1) * 5 * math.pi) + 1
end

function Easers.back_in(k)
  local s = 1.70158
  return k * k * ((s + 1) * k - s)
end

function Easers.back_out(k)
  local s = 1.70158
  k = k - 1
  return k * k * ((s + 1) * k + s) + 1
end

function Easers.back_in_out(k)
  local s = 1.70158 * 1.525
  k = k * 2
  if k < 1 then
    return 0.5 * (k * k * ((s + 1) * k - s))
  end
  k = k - 2
  return 0.5 * (k * k * ((s + 1) * k + s) + 2)
end

function Easers.bounce_in(k)
  return 1 - Easers.bounce_out(1 - k)
end

function Easers.bounce_out(k)
  if k < (1 / 2.75) then
    return 7.5625 * k * k
  elseif k < (2 / 2.75) then
    k = k - (1.5 / 2.75)
    return 7.5625 * k * k + 0.75
  elseif k < (2.5 / 2.75) then
    k = k - (2.25 / 2.75)
    return 7.5625 * k * k + 0.9375
  else
    k = k - (2.625 / 2.75)
    return 7.5625 * k * k + 0.984375
  end
end

function Easers.bounce_in_out(k)
  if k < 0.5 then
    return Easers.bounce_in(k * 2) * 0.5
  end
  return Easers.bounce_out(k * 2 - 1) * 0.5 + 0.5
end

foundation.com.Easers = Easers
