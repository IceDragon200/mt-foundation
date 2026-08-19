local noise_fractal_2d = assert(foundation.com.noise_fractal_2d)
local noise_fractal_3d = assert(foundation.com.noise_fractal_3d)

--- @namespace foundation.com
local function prepare_noise_params(options)
  options.offset = options.offset or 0.0
  options.scale = options.scale or 1.0
  options.spread = options.spread or vector.new(250, 250, 250)
  options.seed = options.seed or 12345
  options.octaves = options.octaves or 3
  options.persist = options.persist or 0.6
  options.lacunarity = options.lacunarity or 2.0

  if not options.eased and not options.absvalue then
    options.defaults = true
  end
  return options
end

--- @class ValueNoise
local ValueNoise = foundation.com.Class:extends("foundation.com.headless.ValueNoise")
do
  local ic = ValueNoise.instance_class

  --- @override
  --- @mutative params
  --- @spec #initialize(params: Table): void
  function ic:initialize(params)
    ic._super.initialize(self)
    self.params = prepare_noise_params(params or {})
  end

  --- @spec #get_2d(pos: Vector3): Number
  function ic:get_2d(pos)
    return noise_fractal_2d(self.params, pos.x, pos.y, 0)
  end

  --- @spec #get_3d(pos: Vector3): Number
  function ic:get_3d(pos)
    return noise_fractal_2d(self.params, pos.x, pos.y, pos.z, 0)
  end
end

foundation.com.headless.ValueNoise = ValueNoise
