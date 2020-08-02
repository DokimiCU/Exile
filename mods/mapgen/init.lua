-- Load files
local path = minetest.get_modpath("mapgen")


minetest.set_mapgen_setting("mg_flags", "caves, nodungeons, light, decorations, biomes", true)
minetest.set_mapgen_setting("mgvalleys_spflags", "altitude_chill, humid_rivers, vary_river_depth, altitude_dry", true)





--
-- Aliases for map generators
--

-- ESSENTIAL node aliases
-- Basic nodes

minetest.register_alias("mapgen_stone", "nodes_nature:conglomerate")
minetest.register_alias("mapgen_water_source", "nodes_nature:salt_water_source")
minetest.register_alias("mapgen_river_water_source", "nodes_nature:freshwater_source")





dofile(path.."/biomes.lua")
dofile(path.."/ores.lua")
dofile(path.."/deco.lua")


---------------------------------------------

--[[

minetest.register_alias("mapgen_dirt", "nodes_nature:silt")
minetest.register_alias("mapgen_dirt_with_grass", "nodes_nature:grassland_soil")
minetest.register_alias("mapgen_sand", "nodes_nature:sand")

minetest.register_alias("mapgen_water_source", "nodes_nature:salt_water_source")
--minetest.register_alias("mapgen_river_water_source", "nodes_nature:freshwater_source")
minetest.register_alias("mapgen_river_water_source", "air")


minetest.register_alias("mapgen_lava_source", "nodes_nature:lava_source")
minetest.register_alias("mapgen_gravel", "nodes_nature:gravel")
minetest.register_alias("mapgen_desert_stone", "nodes_nature:siltstone")
minetest.register_alias("mapgen_desert_sand", "nodes_nature:sand")
minetest.register_alias("mapgen_dirt_with_snow", "nodes_nature:highland_soil")
minetest.register_alias("mapgen_snowblock", "nodes_nature:snow_block")
minetest.register_alias("mapgen_snow", "nodes_nature:snow")
minetest.register_alias("mapgen_ice", "nodes_nature:ice")
minetest.register_alias("mapgen_sandstone", "nodes_nature:sandstone")



-- Flora

minetest.register_alias("mapgen_tree", "nodes_nature:tangkal_tree")
minetest.register_alias("mapgen_leaves", "nodes_nature:tangkal_leaves")
minetest.register_alias("mapgen_apple", "nodes_nature:tangkal_fruit")
minetest.register_alias("mapgen_jungletree", "nodes_nature:tangkal_tree")
minetest.register_alias("mapgen_jungleleaves", "nodes_nature:tangkal_leaves")
minetest.register_alias("mapgen_junglegrass", "nodes_nature:damo")
minetest.register_alias("mapgen_pine_tree", "nodes_nature:tangkal_tree")
minetest.register_alias("mapgen_pine_needles", "nodes_nature:tangkal_leaves")

-- Dungeons


minetest.register_alias("mapgen_cobble", "nodes_nature:limestone_brick")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_limestone_block")

minetest.register_alias("mapgen_mossycobble", "nodes_nature:limestone_brick")
minetest.register_alias("mapgen_stair_desert_stone", "stairs:stair_limestone_block")
minetest.register_alias("mapgen_sandstonebrick", "nodes_nature:limestone_brick")
minetest.register_alias("mapgen_stair_sandstone_block", "stairs:stair_limestone_block")
]]
