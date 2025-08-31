local Raycast = foundation.com.Class:extends("Raycast")

do
  local ic = assert(Raycast.instance_class)

  --- @spec #initialize(
  ---   pos1: Vector3,
  ---   pos2: Vector3,
  ---   objects: Boolean,
  ---   liquids: Boolean,
  ---   pointabilities: Boolean
  --- ): void
  function ic:initialize(pos1, pos2, objects, liquids, pointabilities)
    ic._super.initialize(self)
    self.pos1 = pos1
    self.pos2 = pos2
    self.objects = objects
    self.liquids = liquids
    self.pointabilities = pointabilities
  end

  --- @spec #next(): PointedThing
  function ic:next()
    return nil
  end
end

foundation.com.headless.Raycast = Raycast
