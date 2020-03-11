------------------------------------------------------
local grassland_on = {"nodes_nature:grassland_soil", "nodes_nature:grassland_soil_wet"}
local marshland_on = {"nodes_nature:marshland_soil", "nodes_nature:marshland_soil_wet"}
local highland_on = {"nodes_nature:highland_soil", "nodes_nature:highland_soil_wet"}
local duneland_on = {"nodes_nature:duneland_soil", "nodes_nature:duneland_soil_wet"}
local woodland_on = {"nodes_nature:woodland_soil", "nodes_nature:woodland_soil_wet"}
local all_soils_on = {
  "nodes_nature:marshland_soil",
  "nodes_nature:marshland_soil_wet",
  "nodes_nature:grassland_soil",
  "nodes_nature:grassland_soil_wet",
  "nodes_nature:highland_soil",
  "nodes_nature:highland_soil_wet",
  "nodes_nature:duneland_soil",
  "nodes_nature:duneland_soil_wet",
  "nodes_nature:woodland_soil",
  "nodes_nature:woodland_soil_wet"
}

local lowland_ymax = 600
local lowland_ymin = 1




--------------------------------------
--Schematics
local s1 = { name = "nodes_nature:gemedi", param2 = 2 }
local gemedi = {
  size = {y = 7, x = 1, z = 1},
  data = {
    s1, s1, s1, s1, s1, s1, s1
    },
  yslice_prob = {
    {ypos = 0, prob = 255},
		{ypos = 1, prob = 245},
		{ypos = 2, prob = 225},
    {ypos = 3, prob = 205},
    {ypos = 4, prob = 155},
    {ypos = 5, prob = 55},
    {ypos = 6, prob = 35},
  },
}

local s2 = { name = "nodes_nature:cana", param2 = 2 }
local cana = {
  size = {y = 7, x = 1, z = 1},
  data = {
    s2, s2, s2, s2, s2, s2, s2
    },
  yslice_prob = {
    {ypos = 0, prob = 255},
		{ypos = 1, prob = 255},
		{ypos = 2, prob = 255},
    {ypos = 3, prob = 255},
    {ypos = 4, prob = 230},
    {ypos = 5, prob = 155},
    {ypos = 6, prob = 105},
  },
}


-----------------------------------------------------
--OCEANS

--kelp
minetest.register_decoration({
	name = "nodes_nature:kelp",
	deco_type = "simple",
	place_on = {"nodes_nature:gravel", "nodes_nature:gravel_wet_salty"},
	place_offset_y = -1,
	sidelen = 16,
	noise_params = {
		offset = -0.04,
		scale = 0.3,
		spread = {x = 64, y = 64, z = 64},
		seed = 82112,
		octaves = 3,
		persist = 0.8
	},
	y_max = -7,
	y_min = -15,
	flags = "force_placement",
	decoration = "nodes_nature:kelp",
	param2 = 48,
	param2_max = 96,
})

--seagrass
minetest.register_decoration({
	name = "nodes_nature:seagrass",
	deco_type = "simple",
	place_on = {"nodes_nature:sand", "nodes_nature:sand_wet_salty"},
	place_offset_y = -1,
	sidelen = 16,
  noise_params = {
		offset = 0,
    scale = 0.4,
		spread = {x = 32, y = 32, z = 32},
		seed = 11312,
		octaves = 3,
		persist = 0.8
	},
	y_max = -2,
	y_min = -5,
	flags = "force_placement",
	decoration = "nodes_nature:seagrass",
  param2 = 16,
})

--sea lettuce
minetest.register_decoration({
	name = "nodes_nature:sea_lettuce",
	deco_type = "simple",
	place_on = {"nodes_nature:silt", "nodes_nature:silt_wet_salty"},
	place_offset_y = -1,
	sidelen = 16,
  noise_params = {
		offset = 0,
		scale = 0.4,
		spread = {x = 32, y = 32, z = 32},
		seed = 84322,
		octaves = 3,
		persist = 0.8
	},
	y_max = -2,
	y_min = -5,
	flags = "force_placement",
	decoration = "nodes_nature:sea_lettuce",
  param2 = 16,
})







-----------------------------------------------------
--maraka in grassland
minetest.register_decoration({
	name = "nodes_nature:maraka_tree",
	deco_type = "schematic",
	place_on = grassland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.0007,
		spread = {x = 250, y = 250, z = 250},
		seed = 222,
		octaves = 3,
		persist = 0.7
	},
  y_max = 22,
  y_min = lowland_ymin,
	schematic = minetest.get_modpath("mapgen") .. "/schematics/maraka_tree.mts",
  place_offset_y = -3,
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

--maraka in woodland
minetest.register_decoration({
	name = "nodes_nature:maraka_tree2",
	deco_type = "schematic",
	place_on =woodland_on,
  sidelen = 80,
	fill_ratio = 0.005,
  y_max = 40,
  y_min = lowland_ymin,
	schematic = minetest.get_modpath("mapgen") .. "/schematics/maraka_tree.mts",
  place_offset_y = -3,
	flags = "place_center_x, place_center_z",
	rotation = "random",
})



--tangkal in grassland
minetest.register_decoration({
	name = "nodes_nature:tangkal_tree",
	deco_type = "schematic",
	place_on = grassland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.000001,
		spread = {x = 250, y = 250, z = 250},
		seed = 3322,
		octaves = 3,
		persist = 0.7
	},
  y_max = 25,
  y_min = lowland_ymin,
	schematic = minetest.get_modpath("mapgen") .. "/schematics/tangkal_tree.mts",
  place_offset_y = -5,
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

--tangkal in woodland
minetest.register_decoration({
	name = "nodes_nature:tangkal_tree2",
	deco_type = "schematic",
	place_on =woodland_on,
  sidelen = 80,
	fill_ratio = 0.0018,
  y_max = 25,
  y_min = lowland_ymin,
	schematic = minetest.get_modpath("mapgen") .. "/schematics/tangkal_tree.mts",
  place_offset_y = -5,
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

-------------------------------
--Fills

-- Sediment

minetest.register_decoration({
  name = "nodes_nature:gravel",
	deco_type = "simple",
	place_on = {"group:sand", "nodes_nature:silt"},
  sidelen = 4,
		noise_params = {
			offset = -0.8,
			scale = 2.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 53995,
			octaves = 3,
			persist = 1.0
		},
	y_max = 1,
	y_min = -1,
	decoration = "nodes_nature:gravel",
	spawn_by = "group:water",
	num_spawn_by = 1,
  place_offset_y = -1,
	flags = "force_placement",
})

--wet sediments in low points
minetest.register_decoration({
  name = "nodes_nature:loam_wet",
	deco_type = "simple",
	place_on = {"nodes_nature:loam"},
  sidelen = 4,
		noise_params = {
			offset = -0.4,
			scale = 3.0,
			spread = {x = 32, y = 32, z = 32},
			seed = 7995,
			octaves = 3,
			persist = 1.0
		},
	y_max = 9,
	y_min = 0,
	decoration = "nodes_nature:loam_wet",
  place_offset_y = -1,
	flags = "force_placement",
})

minetest.register_decoration({
  name = "nodes_nature:clay_wet",
	deco_type = "simple",
	place_on = {"nodes_nature:clay"},
  sidelen = 4,
		noise_params = {
			offset = -0.4,
			scale = 3.0,
			spread = {x = 32, y = 32, z = 32},
			seed = 7995,
			octaves = 3,
			persist = 1.0
		},
	y_max = 9,
	y_min = 0,
	decoration = "nodes_nature:clay_wet",
  place_offset_y = -1,
	flags = "force_placement",
})

minetest.register_decoration({
  name = "nodes_nature:silt_wet",
	deco_type = "simple",
	place_on = {"nodes_nature:silt"},
  sidelen = 4,
		noise_params = {
			offset = -0.4,
			scale = 3.0,
			spread = {x = 32, y = 32, z = 32},
			seed = 7995,
			octaves = 3,
			persist = 1.0
		},
	y_max = 9,
	y_min = 0,
	decoration = "nodes_nature:silt_wet",
  place_offset_y = -1,
	flags = "force_placement",
})


minetest.register_decoration({
  name = "nodes_nature:sand_wet",
	deco_type = "simple",
	place_on = {"nodes_nature:sand"},
  sidelen = 4,
		noise_params = {
			offset = -0.4,
			scale = 3.0,
			spread = {x = 32, y = 32, z = 32},
			seed = 7995,
			octaves = 3,
			persist = 1.0
		},
	y_max = 9,
	y_min = 0,
	decoration = "nodes_nature:sand_wet",
  place_offset_y = -1,
	flags = "force_placement",
})

minetest.register_decoration({
  name = "nodes_nature:gravel_wet",
	deco_type = "simple",
	place_on = {"nodes_nature:gravel"},
  sidelen = 4,
		noise_params = {
			offset = -0.4,
			scale = 3.0,
			spread = {x = 32, y = 32, z = 32},
			seed = 7995,
			octaves = 3,
			persist = 1.0
		},
	y_max = 9,
	y_min = 0,
	decoration = "nodes_nature:gravel_wet",
  place_offset_y = -1,
	flags = "force_placement",
})



------------------------------
--Multiple biomes

minetest.register_decoration({
  name = "nodes_nature:moss",
	deco_type = "simple",
	place_on = all_soils_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.005,
		spread = {x = 100, y = 100, z = 100},
		seed = 1000,
		octaves = 3,
		persist = 0.9
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:moss",
})

--denser moss in marsh
minetest.register_decoration({
  name = "nodes_nature:moss",
	deco_type = "simple",
	place_on =  {
    "nodes_nature:marshland_soil",
    "nodes_nature:marshland_soil_wet",
    "nodes_nature:highland_soil",
    "nodes_nature:highland_soil_wet",
    "nodes_nature:woodland_soil",
    "nodes_nature:woodland_soil_wet"
  },
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.09,
		spread = {x = 16, y = 16, z = 16},
		seed = 1640,
		octaves = 3,
		persist = 0.8
	},
	y_max = 31000,
	y_min = 1,
	decoration = "nodes_nature:moss",
})



------------------------------
--Grassland


minetest.register_decoration({
	name = "nodes_nature:gemedi",
	deco_type = "schematic",
	place_on = grassland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 1,
		spread = {x = 128, y = 128, z = 128},
		seed = 998,
		octaves = 3,
		persist = 0.8
	},
  y_max = 10,
  y_min = lowland_ymin,
	schematic = gemedi,
})

minetest.register_decoration({
	name = "nodes_nature:sari",
	deco_type = "simple",
	place_on = grassland_on,
  sidelen = 80,
	fill_ratio = 0.2,
  y_max = lowland_ymax,
  y_min = lowland_ymin,
	decoration = "nodes_nature:sari",
  param2 = 2,
})


minetest.register_decoration({
	name = "nodes_nature:gitiri",
	deco_type = "simple",
	place_on = grassland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.08,
		spread = {x = 32, y = 32, z = 32},
		seed = 1001,
		octaves = 3,
		persist = 0.6
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:gitiri",
  param2 = 2,
})


minetest.register_decoration({
	name = "nodes_nature:tikusati",
	deco_type = "simple",
	place_on = grassland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.001,
		spread = {x = 100, y = 100, z = 100},
		seed = 1002,
		octaves = 3,
		persist = 0.5
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:tikusati",
  param2 = 2,
})


minetest.register_decoration({
	name = "nodes_nature:wiha",
	deco_type = "simple",
	place_on = grassland_on,
	sidelen = 16,
  noise_params = {
		offset = 0,
		scale = 0.002,
		spread = {x = 32, y = 32, z = 32},
		seed = 1003,
		octaves = 3,
		persist = 0.5
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:wiha",
  param2 = 4,
})

minetest.register_decoration({
	name = "nodes_nature:hakimi",
	deco_type = "simple",
	place_on = grassland_on,
	sidelen = 16,
  noise_params = {
		offset = 0,
		scale = 0.001,
		spread = {x = 100, y = 100, z = 100},
		seed = 1004,
		octaves = 3,
		persist = 0.5
	},
  max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:hakimi",
  param2 = 3,
})

minetest.register_decoration({
	name = "nodes_nature:nebiyi",
	deco_type = "simple",
	place_on = grassland_on,
	sidelen = 16,
  noise_params = {
		offset = 0,
		scale = 0.001,
		spread = {x = 100, y = 100, z = 100},
		seed = 1005,
		octaves = 3,
		persist = 0.5
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:nebiyi",
  param2 = 1,
})

minetest.register_decoration({
	name = "nodes_nature:zufani",
	deco_type = "simple",
	place_on = grassland_on,
	sidelen = 16,
  noise_params = {
		offset = 0,
    scale = 0.002,
		spread = {x = 32, y = 32, z = 32},
		seed = 1006,
		octaves = 3,
		persist = 0.5
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:zufani",
  param2 = 2,
})


------------------------------
--Marshland


minetest.register_decoration({
	name = "nodes_nature:cana",
	deco_type = "schematic",
	place_on = marshland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 1,
		spread = {x = 16, y = 16, z = 16},
		seed = 578,
		octaves = 3,
		persist = 0.7
	},
  y_max = 5,
  y_min = lowland_ymin,
	schematic = cana,
})


minetest.register_decoration({
	name = "nodes_nature:tanai",
	deco_type = "simple",
	place_on = marshland_on,
  sidelen = 80,
	fill_ratio = 0.3,
  y_max = lowland_ymax,
  y_min = lowland_ymin,
	decoration = "nodes_nature:tanai",
  param2 = 4,
})


minetest.register_decoration({
	name = "nodes_nature:galanta",
	deco_type = "simple",
	place_on = marshland_on,
	sidelen = 16,
  noise_params = {
		offset = 0,
    scale = 0.002,
		spread = {x = 32, y = 32, z = 32},
		seed = 153,
		octaves = 3,
		persist = 0.5
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:galanta",
  param2 = 4,
})

minetest.register_decoration({
	name = "nodes_nature:marbhan",
	deco_type = "simple",
	place_on = marshland_on,
	sidelen = 16,
  noise_params = {
		offset = 0,
		scale = 0.001,
		spread = {x = 100, y = 100, z = 100},
		seed = 5505,
		octaves = 3,
		persist = 0.5
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:marbhan",
  param2 = 2,
})


minetest.register_decoration({
	name = "nodes_nature:bronach",
	deco_type = "simple",
	place_on = marshland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.06,
		spread = {x = 16, y = 16, z = 16},
		seed = 1707,
		octaves = 3,
		persist = 0.9
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:bronach",
  param2 = 3,
})


------------------------------
--duneland


minetest.register_decoration({
	name = "nodes_nature:alaf",
	deco_type = "simple",
	place_on = duneland_on,
  sidelen = 80,
	fill_ratio = 0.1,
  y_max = lowland_ymax + 20,
  y_min = lowland_ymin,
	decoration = "nodes_nature:alaf",
  param2 = 4,
})

minetest.register_decoration({
	name = "nodes_nature:anperla",
	deco_type = "simple",
	place_on = duneland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.001,
		spread = {x = 32, y = 32, z = 32},
		seed = 1112,
		octaves = 3,
		persist = 0.8
	},
	y_max = lowland_ymax + 20,
	y_min = lowland_ymin,
	decoration = "nodes_nature:anperla",
  param2 = 3,
})

------------------------------
--Highland

minetest.register_decoration({
	name = "nodes_nature:thoka",
	deco_type = "simple",
	place_on = highland_on,
  sidelen = 80,
	fill_ratio = 0.3,
  y_max = 31000,
  y_min = lowland_ymin,
	decoration = "nodes_nature:thoka",
  param2 = 4,
})

minetest.register_decoration({
	name = "nodes_nature:merki",
	deco_type = "simple",
	place_on = highland_on,
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.002,
		spread = {x = 32, y = 32, z = 32},
		seed = 1112,
		octaves = 3,
		persist = 0.8
	},
	y_max = lowland_ymax,
	y_min = lowland_ymin,
	decoration = "nodes_nature:merki",
  param2 = 2,
})


------------------------------
--woodland


minetest.register_decoration({
	name = "nodes_nature:damo",
	deco_type = "simple",
	place_on = woodland_on,
  sidelen = 80,
	fill_ratio = 0.1,
  y_max = lowland_ymax + 50,
  y_min = lowland_ymin,
	decoration = "nodes_nature:damo",
  param2 = 4,
})


minetest.register_decoration({
	name = "nodes_nature:vansano",
	deco_type = "simple",
	place_on = woodland_on,
  sidelen = 80,
	fill_ratio = 0.01,
  y_max = lowland_ymax + 50,
  y_min = lowland_ymin,
	decoration = "nodes_nature:vansano",
  param2 = 2,
})

------------------------------
--Boulders

minetest.register_decoration({
	name = "nodes_nature:granite_boulder",
	deco_type = "simple",
	place_on = "nodes_nature:granite",
  sidelen = 80,
	fill_ratio = 0.05,
  y_max = 31000,
  y_min = -31000,
	decoration = "nodes_nature:granite_boulder",
  flags = "all_floors",
})

minetest.register_decoration({
	name = "nodes_nature:limestone_boulder",
	deco_type = "simple",
	place_on = "nodes_nature:limestone",
  sidelen = 80,
	fill_ratio = 0.05,
  y_max = 31000,
  y_min = -31000,
	decoration = "nodes_nature:limestone_boulder",
  flags = "all_floors",
})

minetest.register_decoration({
	name = "nodes_nature:basalt_boulder",
	deco_type = "simple",
	place_on = "nodes_nature:basalt",
  sidelen = 80,
	fill_ratio = 0.05,
  y_max = 31000,
  y_min = -31000,
	decoration = "nodes_nature:basalt_boulder",
  flags = "all_floors",
})


--ironstone..dense on deposits
minetest.register_decoration({
	name = "nodes_nature:ironstone_boulder",
	deco_type = "simple",
	place_on = "nodes_nature:ironstone",
  sidelen = 80,
	fill_ratio = 0.6,
  y_max = 31000,
  y_min = -31000,
	decoration = "nodes_nature:ironstone_boulder",
  flags = "all_floors",
})


-----------------------------------------------------
--Animal eggs
--gundu_eggs
minetest.register_decoration({
	name = "animals:gundu_eggs",
	deco_type = "simple",
	place_on = {"nodes_nature:silt", "nodes_nature:silt_wet_salty", "nodes_nature:sand", "nodes_nature:sand_wet_salty"},
  sidelen = 80,
	fill_ratio = 0.0005,
	y_max = -7,
	y_min = -25,
	flags = "force_placement",
	decoration = "animals:gundu_eggs",
})

--sarkamos egg
minetest.register_decoration({
	name = "animals:sarkamos_eggs",
	deco_type = "simple",
	place_on = {"nodes_nature:silt", "nodes_nature:silt_wet_salty", "nodes_nature:sand", "nodes_nature:sand_wet_salty"},
  sidelen = 80,
	fill_ratio = 0.00005,
	y_max = -10,
	y_min = -35,
	flags = "force_placement",
	decoration = "animals:sarkamos_eggs",
})

--kubwakubwa_eggs
minetest.register_decoration({
	name = "animals:kubwakubwa_eggs",
	deco_type = "simple",
	place_on = {
    "nodes_nature:granite",
    "nodes_nature:basalt",
    "nodes_nature:limestone",
    "nodes_nature:sandstone",
    "nodes_nature:siltstone",
    "nodes_nature:claystone"},
  sidelen = 80,
	fill_ratio = 0.0005,
	y_max = lowland_ymax,
	y_min = -1000,
	decoration = "animals:kubwakubwa_eggs",
  flags = "all_floors",
})


-----------------------------------
--Start node timers
-- get decoration IDs
local gundu_eggs = minetest.get_decoration_id("animals:gundu_eggs")
local sarkamos_eggs = minetest.get_decoration_id("animals:sarkamos_eggs")
local kubwakubwa_eggs = minetest.get_decoration_id("animals:kubwakubwa_eggs")

minetest.set_gen_notify({decoration = true}, {gundu_eggs, sarkamos_eggs, kubwakubwa_eggs})

-- start nodetimers
minetest.register_on_generated(function(minp, maxp, blockseed)
	local gennotify = minetest.get_mapgen_object("gennotify")
	local poslist = {}

	for _, pos in ipairs(gennotify["decoration#"..gundu_eggs] or {}) do
		local gundu_eggs_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		table.insert(poslist, gundu_eggs_pos)
	end

  for _, pos in ipairs(gennotify["decoration#"..sarkamos_eggs] or {}) do
    local sarkamos_eggs_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
    table.insert(poslist, sarkamos_eggs_pos)
  end

  for _, pos in ipairs(gennotify["decoration#"..kubwakubwa_eggs] or {}) do
    local kubwakubwa_eggs_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
    table.insert(poslist, kubwakubwa_eggs_pos)
  end

	if #poslist ~= 0 then
		for i = 1, #poslist do
			local pos = poslist[i]
			minetest.get_node_timer(pos):start(1)
		end
	end
end)
