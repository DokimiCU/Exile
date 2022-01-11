--how long it takes seeds to mature (number of ticks down i.e. timer X bg = time)
--18000 per season?
plant_base_growth = 500
plant_base_timer = 40


plantlist = {
	{"moss", "Moss",{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, 1, "crumbly", "nodebox", nil, "Moss Spores", "nodes_nature_spores.png", plant_base_growth *3},
  {"gitiri", "Gitiri", nil, 1.2, "woody_plant", nil, 2, nil, nil, plant_base_growth * 2},
	{"sari", "Sari", nil, 1, "fibrous_plant", nil, 2, nil, nil, plant_base_growth *0.5},
	{"tanai", "Tanai", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth*1.5},
	{"bronach", "Bronach", nil, 1.5, "woody_plant", nil, 3, nil, nil, plant_base_growth * 2},
	{"thoka", "Thoka", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth * 2},
	{"alaf", "Alaf", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth * 2},
	{"damo", "Damo", nil, 1, "fibrous_plant", nil, 4, nil, nil, plant_base_growth},
	{"vansano", "Vansano", nil, 1, "herbaceous_plant", nil, 2, nil, nil, plant_base_growth * 1.2},
	{"anperla", "Anperla", nil, 1, "herbaceous_plant", nil, 3, 'Anperla Tuber', 'nodes_nature_tuber.png', plant_base_growth * 2},
	--artifact
	{"reshedaar", "Reshedaar", {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, 1, "crumbly", "nodebox", nil, "Reshedaar Spores", "nodes_nature_spores.png", plant_base_growth *3},
	{"mahal", "Mahal", {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, 1, "crumbly", "nodebox", nil, "Mahal Spores", "nodes_nature_spores.png", plant_base_growth *3},
--Consumables
  --drugs
	{"tikusati", "Tikusati", nil, 1, "herbaceous_plant", nil, 2,  nil, nil, plant_base_growth},
	--toxic
	{"nebiyi", "Nebiyi", nil, 1, "mushroom", nil, 1, nil, nil, plant_base_growth},
	{"marbhan", "Marbhan", nil, 1, "mushroom", nil, 2, nil, nil, plant_base_growth*2},
  --medicine
  {"hakimi", "Hakimi", nil, 1, "herbaceous_plant", nil, 0, nil, nil, plant_base_growth * 2},
	{"merki", "Merki", nil, 1, "mushroom", nil, 0, nil, nil, plant_base_growth * 2},
	--food and water
	{"wiha", "Wiha", nil, 1, "herbaceous_plant", nil, 4, nil, nil, plant_base_growth * 2},
	{"zufani", "Zufani", nil, 1, "mushroom", nil, 2, nil, nil, plant_base_growth * 2},
	{"galanta", "Galanta", nil, 1, "herbaceous_plant", nil, 4, nil, nil, plant_base_growth *0.8},
	--artifact
	{"lambakap", "Lambakap", {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, 1, "crumbly", "nodebox", 0, "Lambakap Spores", "nodes_nature_spores.png", plant_base_growth *3},

}

--Underwater Rooted plants
searooted_list = {
	{"kelp",
	 "Kelp",
	 {-2/16, 0.5, -2/16, 2/16, 3.5, 2/16},
	 "seaweed", "nodes_nature:gravel_wet_salty",
	 "nodes_nature_gravel.png^nodes_nature_mud.png",
	 nodes_nature.node_sound_gravel_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
	 4,6, true},
	 {"seagrass",
 	 "Seagrass",
 	 {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
 	 "seaweed", "nodes_nature:sand_wet_salty",
 	 "nodes_nature_sand.png^nodes_nature_mud.png",
 	 nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
 	 1,1, false},
	 {"sea_lettuce",
 	 "Sea Lettuce",
 	 {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4},
 	 "seaweed", "nodes_nature:silt_wet_salty",
 	 "nodes_nature_silt.png^nodes_nature_mud.png",
 	 nodes_nature.node_sound_dirt_defaults({	dig = {name = "default_dig_snappy", gain = 0.2}, dug = {name = "default_grass_footstep", gain = 0.25},}),
 	 1,1, false}

}


tree_base_tree_growth = 31000
tree_base_leaf_growth = 21000
tree_base_fruit_growth = 19000


tree_list = {
	{"maraka", "Maraka Tree", "maraka_nut", "Maraka Nut", 1, {-0.2, 0.2, -0.2, 0.2, 0.5, 0.2},1},
	{"tangkal", "Tangkal Tree", "tangkal_fruit", "Tangkal Fruit", 1, {-0.1, 0.1, -0.1, 0.1, 0.5, 0.1},2},
}
