local Vector3 = assert(foundation.com.Vector3)
local abs = assert(math.abs)

--- @namespace foundation.com.headless

--- @class VoxelLineIterator
local VoxelLineIterator = foundation.com.Class:extends("VoxelLineIterator")
do
  local ic = assert(VoxelLineIterator.instance_class)

  local function float_to_int(p, d)
    local dx
    local dy
    local dz
    if p.x > 0 then
      dx = d / 2
    else
      dx = -d / 2
    end

    if p.y > 0 then
      dy = d / 2
    else
      dy = -d / 2
    end

    if p.z > 0 then
      dz = d / 2
    else
      dz = -d / 2
    end

    return vector.new(
      (p.x + dx) / d,
      (p.y + dy) / d,
      (p.z + dz) / d
    )
  end

  --- @spec #initialize(start_position: Vector3, line_vector: Vector3): void
  function ic:initialize(start_position, line_vector)
    ic._super.initialize(self)
    self.m_current_index = 0
    self.m_start_position = vector.copy(start_position)
    self.m_line_vector = vector.copy(line_vector)
    self.m_current_node_pos = float_to_int(self.m_start_position, 1)
    self.m_start_node_pos = self.m_current_node_pos:copy()
    self.m_last_index = self.get_index(
      float_to_int(vector.add(self.m_start_position, self.m_line_vector), 1)
    )

    self.m_step_directions = vector.new(1, 1, 1)
    self.m_intersection_multi_inc = vector.new(10000, 10000, 10000)
    self.m_next_intersection_multi = vector.new(10000, 10000, 10000)
    if (self.m_line_vector.x > 0) then
      self.m_next_intersection_multi.x = (self.m_current_node_pos.x + 0.5 - m_start_position.x) /
        self.m_line_vector.x
      self.m_intersection_multi_inc.x = 1 / self.m_line_vector.x
    elseif (self.m_line_vector.x < 0) then
      self.m_next_intersection_multi.x = (self.m_current_node_pos.x - 0.5 - m_start_position.x) /
        self.m_line_vector.x
      self.m_intersection_multi_inc.x = -1 / self.m_line_vector.x
      self.m_step_directions.x = -1
    end

    if (self.m_line_vector.y > 0) then
      self.m_next_intersection_multi.y = (self.m_current_node_pos.y + 0.5 - m_start_position.y) /
        self.m_line_vector.y
      self.m_intersection_multi_inc.y = 1 / self.m_line_vector.y
    elseif (self.m_line_vector.y < 0) then
      self.m_next_intersection_multi.y = (self.m_current_node_pos.y - 0.5 - m_start_position.y) /
        self.m_line_vector.y
      self.m_intersection_multi_inc.y = -1 / self.m_line_vector.y
      self.m_step_directions.y = -1
    end

    if (self.m_line_vector.z > 0) then
      self.m_next_intersection_multi.z = (self.m_current_node_pos.z + 0.5 - m_start_position.z) /
        self.m_line_vector.z
      self.m_intersection_multi_inc.z = 1 / self.m_line_vector.z
    elseif (self.m_line_vector.z < 0) then
      self.m_next_intersection_multi.z = (self.m_current_node_pos.z - 0.5 - m_start_position.z) /
        self.m_line_vector.z
      self.m_intersection_multi_inc.z = -1 / self.m_line_vector.z
      self.m_step_directions.z = -1
    end
  end

  function ic:next()
    self.m_current_index = self.m_current_index + 1

    if (self.m_next_intersection_multi.x < self.m_next_intersection_multi.y) and
       (self.m_next_intersection_multi.x < self.m_next_intersection_multi.z) then
      self.m_next_intersection_multi.x = self.m_next_intersection_multi.x +
        m_intersection_multi_inc.x
      self.m_current_node_pos.x = self.m_current_node_pos.x + self.m_step_directions.x
    elseif (self.m_next_intersection_multi.y < self.m_next_intersection_multi.z) then
      self.m_next_intersection_multi.y = self.m_next_intersection_multi.y +
        m_intersection_multi_inc.y
      self.m_current_node_pos.y = self.m_current_node_pos.y + self.m_step_directions.y
    else
      self.m_next_intersection_multi.z = self.m_next_intersection_multi.z +
        m_intersection_multi_inc.z
      self.m_current_node_pos.z = self.m_current_node_pos.z + self.m_step_directions.z
    end
  end

  function ic:has_next()
    return self.m_current_index < self.m_last_index
  end

  --- @spec #get_index(p: Vector3): Number
  function ic:get_index(p)
    return abs(p.x - self.start_node_pos.x) +
      abs(p.y - self.start_node_pos.y) +
      abs(p.z - self.start_node_pos.z)
  end
end
foundation.com.headless.VoxelLineIterator = VoxelLineIterator
