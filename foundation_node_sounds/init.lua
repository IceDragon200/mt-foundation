local mod = foundation.new_module("foundation_node_sounds", "1.1.0")

mod:require("node_sounds.lua")

foundation.com.node_sounds = foundation.com.NodeSoundsRegistry:new()
