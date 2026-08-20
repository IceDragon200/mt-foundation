local noise_fractal_2d = assert(foundation.com.noise_fractal_2d)
local noise_fractal_3d = assert(foundation.com.noise_fractal_3d)

--- @namespace foundation.com

--- @class ValueNoise
local ValueNoise = foundation.com.Class:extends("foundation.com.headless.ValueNoise")
do
  local ic = ValueNoise.instance_class

  --- @override
  --- @mutative params
  --- @spec #initialize(params: Table): void
  function ic:initialize(params)
    ic._super.initialize(self)
    self.params = foundation.com.prepare_noise_params(params or {})
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
