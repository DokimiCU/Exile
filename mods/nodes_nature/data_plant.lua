
--[[
# 7 on the list
param2
Currently the following meshes are choosable:
  * 0 = a "x" shaped plant (ordinary plant)
  * 1 = a "+" shaped plant (just rotated 45 degrees)
  * 2 = a "*" shaped plant with 3 faces instead of 2
  * 3 = a "#" shaped plant with 4 faces instead of 2
  * 4 = a "#" shaped plant with 4 faces that lean
]]

-- Internationalization
local S = nodes_nature.S

--how long it takes seeds to mature (number of ticks down i.e. timer X bg = time)
--18000 per season?
plant_base_growth = 500
plant_base_timer = 40


plantlist = {
	{"moss", S("Moss"),{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, 1, "crumbly", "nodebox", nil, S("Moss Spores"), "nodes_nature_spores.png", plant_base_growth *3, 1, "green"},
	{"gitiri", "Gitiri", nil, 1.2, "woody_plant", nil, 2, nil, nil, plant_base_growth * 2, 1, "green"},
	{"sari", "Sari", nil, 1, "fibrous_plant", nil, 2, nil, nil, plant_base_growth *0.5, 1, "yellow"},
	{"tanai", "Tanai", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth*1.5, 1, "crimson"},
	{"bronach", "Bronach", nil, 1.5, "woody_plant", nil, 3, nil, nil, plant_base_growth * 2, 1, "crimson"},
	{"thoka", "Thoka", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth * 2, 1},
	{"alaf", "Alaf", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth * 2, 1, "yellow"},
	{"damo", "Damo", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth, 1, "green"},
	{"vansano", "Vansano", nil, 1, "herbaceous_plant", nil, 2, nil, nil, plant_base_growth * 1.2, 1, "green"},
	{"anperla", "Anperla", nil, 1, "herbaceous_plant", nil, 3, S('Anperla Tuber'), 'nodes_nature_tuber.png', plant_base_growth * 2, 1, "green"},
	{"tashvish", "Tashvish", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth*1.5},
	{"jogalan", "Jogalan", nil, 1, "woody_plant", nil, 0, nil, nil, plant_base_growth * 2, 1, "black"},

	--artifact
	{"reshedaar", "Reshedaar", {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, 1, "crumbly", "nodebox", nil, S("Reshedaar Spores"), "nodes_nature_spores.png", plant_base_growth *3, 1, "indigo"},
	{"mahal", "Mahal", {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, 1, "crumbly", "nodebox", nil, S("Mahal Spores"), "nodes_nature_spores.png", plant_base_growth *3, 1},
	{"lambakap", "Lambakap", {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, 1, "mushroom", "nodebox", 0, S("Lambakap Spores"), "nodes_nature_spores.png", plant_base_growth *3, 1, "red"},
--Consumables
  --drugs
	{"tikusati", "Tikusati", nil, 1, "herbaceous_plant", nil, 2,  nil, nil, plant_base_growth, nil, "yellow"},
	--toxic
	{"nebiyi", "Nebiyi", nil, 1, "mushroom", nil, 1, nil, nil, plant_base_growth, 1, "indigo"},
	{"marbhan", "Marbhan", nil, 1, "mushroom", nil, 2, nil, nil, plant_base_growth*2, 1, "red"},
  --medicine
  {"hakimi", "Hakimi", nil, 1, "herbaceous_plant", nil, 0, nil, nil, plant_base_growth * 2, 1, "blue"},
	{"merki", "Merki", nil, 1, "mushroom", nil, 0, nil, nil, plant_base_growth * 2, 1, "blue"},
	--food and water
	{"wiha", "Wiha", nil, 1, "herbaceous_plant", nil, 4, nil, nil, plant_base_growth * 2, 1, "red"},
	{"zufani", "Zufani", nil, 1, "mushroom", nil, 2, nil, nil, plant_base_growth * 2, 1, "yellow"},
	{"galanta", "Galanta", nil, 1, "herbaceous_plant", nil, 4, nil, nil, plant_base_growth *0.8, 1, "green"},
	{"momo", "Momo", nil, 1, "herbaceous_plant", nil, 2, nil, nil, plant_base_growth *2, 1, "red"},
	--No function/decorative (when new features get added, consider using these for something)
	{"orom", "Orom", nil, 1, "herbaceous_plant", nil, 1, nil, nil, plant_base_growth *2, 1, "black"},
	{"veke", "Veke", nil, 1, "herbaceous_plant", nil, 0, nil, nil, plant_base_growth *2, 1, "black"},

}

--Underwater Rooted plants
searooted_list = {
	---
	{"kelp",
	 "Riraemu",
	 {-2/16, 0.5, -2/16, 2/16, 3.5, 2/16},
	 "seaweed", "nodes_nature:gravel_wet_salty",
	 "nodes_nature_gravel.png^nodes_nature_mud.png",
	 nodes_nature.node_sound_gravel_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
	 4,6, true},
	 ---
	{"seagrass",
	 "Opaeko",
	 {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
	 "seaweed", "nodes_nature:sand_wet_salty",
	 "nodes_nature_sand.png^nodes_nature_mud.png",
	 nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
	 1,1, false},
	 ---
	{"sea_lettuce",
	 "Aongao",
	 {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
	 "seaweed", "nodes_nature:silt_wet_salty",
	 "nodes_nature_silt.png^nodes_nature_mud.png",
	 nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
	 1,1, false},
	 ---
	{"nagaeo",
	 "Nagaeo",
	 {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
	 "seaweed", "nodes_nature:silt_wet_salty",
	 "nodes_nature_silt.png^nodes_nature_mud.png",
	 nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
	 1,1, false},
	 ---
	 {"koaeako",
		"Koaeako",
		{-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
		"seaweed", "nodes_nature:sand_wet_salty",
		"nodes_nature_sand.png^nodes_nature_mud.png",
		nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
		1,1, false},
		---
		{"imoaru",
		 "Imoaru",
		 {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
		 "seaweed", "nodes_nature:gravel_wet_salty",
		 "nodes_nature_gravel.png^nodes_nature_mud.png",
		 nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
		 1,1, false},


}


tree_base_tree_growth = 31000
tree_base_leaf_growth = 21000
tree_base_fruit_growth = 19000

--name, Desc, fruit name, fruit desc, p2 fruit,selbox_fruit, wood hardness, hardwood, dyecandidate, dye
tree_list = {
	{"maraka", "Maraka Tree", "maraka_nut", S("Maraka Nut"), 1, {-0.2, 0.2, -0.2, 0.2, 0.5, 0.2},1, true, 1, "black"},
	{"tangkal", "Tangkal Tree", "tangkal_fruit", S("Tangkal Fruit"), 1, {-0.1, 0.1, -0.1, 0.1, 0.5, 0.1},2, false, 1, "crimson"},
	{"sasaran", "Sasaran Tree", "sasaran_cone", S("Sasaran Cone"), 1, {-0.1, -0.5, -0.1, 0.1, -0.1, 0.1},2, false, 1, "yellow"},
	{"kagum", "Kagum Tree", "kagum_pod", S("Kagum Pod"), 1, {-0.1, -0.1, -0.1, 0.1, 0.5, 0.1},2, false, 1},
	{"panasee", "Panasee Tree", "panasee_fruit", S("Panasee Fruit"), 2, {-0.1, -0.2, -0.1, 0.1, 0.5, 0.1},1, true, 1, "yellow"},
	{"amma", "Amma Tree", "amma_nut", S("Amma nut"), 1, {-0.2, 0.2, -0.2, 0.2, 0.5, 0.2},2, false, 1, "black"},
	{"daoja", "Daoja Tree", "daoja_berry", S("Daoja Berry"), 1, {-0.1, -0.5, -0.1, 0.1, -0.3, 0.1},1, true, 1, "crimson"},
}
