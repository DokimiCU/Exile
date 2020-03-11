--
-- Register biomes
--
local upper_limit = 31000
local lower_limit = -31000

local mountain_min = 170
local alpine_min = 140
local highland_min = 100
local upland_min = 90
local lowland_max = 9

local beach_max = 5
local beach_min = -10
local shallow_ocean_min = -30
local deep_ocean_min = -120

---
local extreme_high = 95
local high = 75
local middle = 50
local low = 25
local extreme_low = 5



----------------------
-- Grassland
--clay, open, yellow

minetest.register_biome({
	name = "grassland",
	node_top = "nodes_nature:grassland_soil",
	depth_top = 1,
	node_filler = "nodes_nature:clay",
	depth_filler = 2,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:woodland_soil_wet",
	depth_riverbed = 1,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 5,
	y_max = upland_min,
	y_min = beach_max,
	heat_point = middle,
	humidity_point = middle,
})

--upland grassland
minetest.register_biome({
	node_dust = "nodes_nature:snow",
	name = "upland_grassland",
	node_top = "nodes_nature:grassland_soil",
	depth_top = 1,
	node_filler = "nodes_nature:clay",
	depth_filler = 2,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:grassland_soil_wet",
	depth_riverbed = 1,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 5,
	y_max = highland_min,
	y_min = upland_min,
	heat_point = middle,
	humidity_point = middle,
})

----------------------
-- marshland
--silt, dense reeds, red

minetest.register_biome({
	name = "marshland",
	node_top = "nodes_nature:marshland_soil_wet",
	depth_top = 1,
	node_filler = "nodes_nature:silt_wet",
	depth_filler = 6,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:silt_wet",
	depth_riverbed = 5,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 2,
	y_max = lowland_max,
	y_min = beach_max,
	heat_point = high,
	humidity_point = extreme_high,
})


----------------------
-- highland
--gravel, dense grasses, purple

minetest.register_biome({
	name = "highland",
	node_dust = "nodes_nature:snow",
	node_top = "nodes_nature:highland_soil",
	depth_top = 1,
	node_filler = "nodes_nature:gravel",
	depth_filler = 1,
	node_stone = "nodes_nature:limestone",
	node_river_water = "nodes_nature:snow_block",
	node_riverbed = "nodes_nature:gravel_wet",
	depth_riverbed = 3,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 5,
	y_max = mountain_min,
	y_min = highland_min,
	heat_point = low + 10,
	humidity_point = high -10,
})


----------------------
-- duneland
--sand, barren, orange

minetest.register_biome({
	name = "duneland",
	node_top = "nodes_nature:duneland_soil",
	depth_top = 1,
	node_filler = "nodes_nature:sand",
	depth_filler = 5,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:grassland_soil_wet",
	depth_riverbed = 1,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 2,
	y_max = lowland_max + 10,
	y_min = beach_max,
	heat_point = middle,
	humidity_point = extreme_low,
})


----------------------
-- woodland
--loam, trees, green

minetest.register_biome({
	name = "woodland",
	node_top = "nodes_nature:woodland_soil",
	depth_top = 1,
	node_filler = "nodes_nature:loam",
	depth_filler = 3,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:marshland_soil_wet",
	depth_riverbed = 1,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 2,
	y_max = lowland_max + 20,
	y_min = beach_max,
	heat_point = low,
	humidity_point = high,
})


----------------------
-- Mountains
--frozen places up high


--snowcap
minetest.register_biome({
	name = "snowcap",
	node_dust = "nodes_nature:snow",
	node_top = "nodes_nature:snow_block",
	depth_top = 2,
	node_filler = "nodes_nature:gravel",
	depth_filler = 2,
	node_stone = "nodes_nature:limestone",
	node_water_top = "nodes_nature:ice",
	depth_water_top = 2,
	node_river_water = "nodes_nature:ice",
	node_riverbed = "nodes_nature:gravel",
	depth_riverbed = 2,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "tech:drystack",
	node_dungeon_stair = "stairs:stair_drystack",
	vertical_blend = 5,
	y_max = upper_limit,
	y_min = mountain_min,
	heat_point = low,
	humidity_point = high,
})



---------------------
--Coasts and oceans

minetest.register_biome({
	name = "silty_beach",
	node_top = "nodes_nature:silt",
	depth_top = 1,
	node_filler = "nodes_nature:silt_wet_salty",
	depth_filler = 2,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:silt_wet",
	depth_riverbed = 4,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "nodes_nature:limestone_brick",
	node_dungeon_stair = "stairs:stair_limestone_block",
	vertical_blend = 1,
	y_max = beach_max,
	y_min = beach_min,
	heat_point = middle,
	humidity_point = high,
})


minetest.register_biome({
	name = "sandy_beach",
	node_top = "nodes_nature:sand",
	depth_top = 1,
	node_filler = "nodes_nature:sand_wet_salty",
	depth_filler = 2,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:sand_wet",
	depth_riverbed = 4,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "nodes_nature:limestone_brick",
	node_dungeon_stair = "stairs:stair_limestone_block",
	vertical_blend = 1,
	y_max = beach_max,
	y_min = beach_min,
	heat_point = middle,
	humidity_point = middle,
})


minetest.register_biome({
	name = "gravel_beach",
	node_top = "nodes_nature:gravel",
	depth_top = 1,
	node_filler = "nodes_nature:gravel_wet_salty",
	depth_filler = 2,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:gravel_wet",
	depth_riverbed = 4,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "nodes_nature:limestone_brick",
	node_dungeon_stair = "stairs:stair_limestone_block",
	vertical_blend = 1,
	y_max = beach_max,
	y_min = beach_min,
	heat_point = extreme_low,
	humidity_point = middle,
})

minetest.register_biome({
	name = "shallow_ocean",
	node_top = "nodes_nature:sand_wet_salty",
	depth_top = 1,
	node_filler = "nodes_nature::sand_wet_salty",
	depth_filler = 3,
	node_stone = "nodes_nature:limestone",
	node_river_water = "",
	node_riverbed = "nodes_nature:sand_wet_salty",
	depth_riverbed = 2,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "nodes_nature:limestone_brick",
	node_dungeon_stair = "stairs:stair_limestone_block",
	vertical_blend = 1,
	y_max = beach_min,
	y_min = shallow_ocean_min,
	heat_point = middle,
	humidity_point = middle,
})

minetest.register_biome({
	name = "deep_ocean",
	node_top = "nodes_nature:silt_wet_salty",
	depth_top = 1,
	node_filler = "nodes_nature::silt_wet_salty",
	depth_filler = 3,
	node_stone = "nodes_nature:granite",
	node_river_water = "",
	node_riverbed = "nodes_nature:sand_wet_salty",
	depth_riverbed = 2,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "nodes_nature:granite_brick",
	node_dungeon_stair = "stairs:stair_granite_block",
	vertical_blend = 10,
	y_max = shallow_ocean_min,
	y_min = deep_ocean_min,
	heat_point = middle,
	humidity_point = middle,
})


-------------------------
--underground
minetest.register_biome({
	name = "underground",
	node_stone = "nodes_nature:granite",
	node_dungeon = "nodes_nature:granite_brick",
	node_dungeon_stair = "stairs:stair_granite_block",
	vertical_blend = 20,
	node_cave_liquid = {"nodes_nature:freshwater_source"},
	node_dungeon = "nodes_nature:basalt_brick",
	node_dungeon_stair = "stairs:stair_basalt_block",
	y_max = deep_ocean_min,
	y_min = -1000,
	heat_point = middle,
	humidity_point = middle,
})

--underground
minetest.register_biome({
	name = "deep_underground",
	node_stone = "nodes_nature:granite",
	vertical_blend = 20,
	node_cave_liquid = {"nodes_nature:freshwater_source", "nodes_nature:lava_source"},
	y_max = -1000,
	y_min = lower_limit,
	heat_point = middle,
	humidity_point = middle,
})
