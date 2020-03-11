-- Load files
local path = minetest.get_modpath("mapgen")


dofile(path.."/biomes.lua")
dofile(path.."/ores.lua")
dofile(path.."/deco.lua")




--
-- Aliases for map generators
--

minetest.register_alias("mapgen_stone", "nodes_nature:conglomerate")
minetest.register_alias("mapgen_dirt", "nodes_nature:silt")
minetest.register_alias("mapgen_dirt_with_grass", "nodes_nature:grassland_soil")
minetest.register_alias("mapgen_sand", "nodes_nature:sand")

minetest.register_alias("mapgen_water_source", "nodes_nature:salt_water_source")
--minetest.register_alias("mapgen_river_water_source", "nodes_nature:freshwater_source")
minetest.register_alias("mapgen_lava_source", "nodes_nature:lava_source")
minetest.register_alias("mapgen_gravel", "nodes_nature:gravel")
--minetest.register_alias("mapgen_desert_stone", "default:desert_stone")
--minetest.register_alias("mapgen_desert_sand", "default:desert_sand")
--minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
--minetest.register_alias("mapgen_snowblock", "default:snowblock")
--minetest.register_alias("mapgen_snow", "default:snow")
--minetest.register_alias("mapgen_ice", "default:ice")
minetest.register_alias("mapgen_sandstone", "nodes_nature:sandstone")

-- Flora
--[[
minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_pine_tree", "default:pine_tree")
minetest.register_alias("mapgen_pine_needles", "default:pine_needles")
]]
-- Dungeons

--[[
minetest.register_alias("mapgen_cobble", "nodes_nature:limestone_brick")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_limestone_block")

minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_stair_desert_stone", "stairs:stair_desert_stone")
minetest.register_alias("mapgen_sandstonebrick", "default:sandstonebrick")
minetest.register_alias("mapgen_stair_sandstone_block", "stairs:stair_sandstone_block")
]]
