--- @namespace foundation.com
local get_node_timer = assert(tetra.get_node_timer)

--- @spec maybe_start_node_timer(pos: Vector3, duration: Number): void
function foundation.com.maybe_start_node_timer(pos, duration)
  local timer = get_node_timer(pos)

  if not timer:is_started() then
    timer:start(duration)
  end
end
