
local height_min = -31000
local height_max = -256


minetest.register_ore({
	ore_type = "vein",
	ore = "nodes_nature:basalt",
	wherein = {
		"nodes_nature:granite",
		"nodes_nature:conglomerate",
		"nodes_nature:limestone",
	},
	column_height_min = 2,
	column_height_max = 6,
	y_min = height_min,
	y_max = height_max,
	noise_threshold = 0.85,
	noise_params = {
		offset = 0,
		scale = 3,
		spread = {x=400, y=800, z=400},
		seed = 66391,
		octaves = 4,
		persist = 0.5,
		flags = "eased",
	},
	random_factor = 0,
})


minetest.register_ore({
	ore_type = "vein",
	ore = "nodes_nature:lava_source",
	wherein = {
		"nodes_nature:granite",
		"nodes_nature:basalt",
		"nodes_nature:conglomerate",
		"nodes_nature:limestone",
	},
	column_height_min = 2,
	column_height_max = 6,
	y_min = height_min,
	y_max = height_max,
	noise_threshold = 0.95,
	noise_params = {
		offset = 0,
		scale = 3,
		spread = {x=400, y=800, z=400},
		seed = 66391,
		octaves = 4,
		persist = 0.5,
		flags = "eased",
	},
	random_factor = 0,
})
