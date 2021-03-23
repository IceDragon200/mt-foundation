--
-- Utility functions for generating wave shapes.
--
local Waves = {}

function Waves.sine(t)
  return math.sin(math.pi * 2 * t)
end

function Waves.triangle(t)
  return 2 * math.abs(t * 2 - 1) - 1
end

function Waves.saw(t)
  return t * 2 - 1
end

function Waves.square(t)
  if t < 0.5 then
    return -1
  else
    return 1
  end
end

foundation.com.Waves = Waves
