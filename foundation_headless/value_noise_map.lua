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

--- TODO
--- @class ValueNoiseMap
local ValueNoiseMap = foundation.com.Class:extends("foundation.com.headless.ValueNoiseMap")
do
  local ic = ValueNoiseMap.instance_class

  --- @override
  --- @mutative params
  --- @spec #initialize(params: Table): void
  function ic:initialize(params)
    ic._super.initialize(self)
    self.params = foundation.com.prepare_noise_params(params or {})
  end

  --- @spec #get_2d_map(pos: Vector3): Table
  function ic:get_2d_map(pos)
    return {}
  end

  --- @spec #get_3d_map(pos: Vector3): Table
  function ic:get_3d_map(pos)
    return {}
  end

  --- @spec #get_2d_map_flat(pos: Vector3, buffer: Table): Table
  function ic:get_2d_map_flat(pos, buffer)
    buffer = buffer or {}
    return buffer
  end

  --- @spec #get_3d_map_flat(pos: Vector3, buffer: Table): Table
  function ic:get_3d_map_flat(pos, buffer)
    buffer = buffer or {}
    return buffer
  end

  --- @spec #calc_2d_map(pos: Vector3): void
  function ic:calc_2d_map(pos)

  end

  --- @spec #calc_3d_map(pos: Vector3): void
  function ic:calc_3d_map(pos)
  end

  --- @spec #get_map_slice(slice_offset: Table, slice_size: Table. buffer: Table): Table
  function ic:get_map_slice(slice_offset, slice_size, buffer)
    return {}
  end
end

foundation.com.headless.ValueNoiseMap = ValueNoiseMap
