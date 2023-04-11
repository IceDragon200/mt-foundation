--- @namespace foundation.com

-- Minetest has pos_to_string, but I believe that floors the vector coords
-- and adds brackets around it this function is intended to keep the
-- decimal places and only create a csv
function foundation.com.vector_to_string(vec)
  return vec.x .. "," .. vec.y .. "," .. vec.z
end

foundation_stdlib:require("lib/vector/2.lua")
foundation_stdlib:require("lib/vector/3.lua")
foundation_stdlib:require("lib/vector/4.lua")
