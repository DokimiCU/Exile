----------------------------------------------------------
--ORES and ROCK STRATA

----------------------------------------------------------


----------------------------------------------------------
--SURFACE STRATA

--stratum layer
--LIME 140
--sand
--silt
--conglomerate
--clay
--sand
--silt
--clay
--conglomerate
--LIME -20

--1
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:conglomerate",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 10,
  y_min           = -30,
  noise_params    = {
    offset = 24,
    scale = 16,
    spread = {x = 128, y = 128, z = 128},
    seed = 6622,
    octaves = 1,
  },
  stratum_thickness = 30,
})

--2
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:claystone",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 30,
  y_min           = -10,
  noise_params    = {
    offset = 24,
    scale = 16,
    spread = {x = 128, y = 128, z = 128},
    seed = 91132,
    octaves = 1,
  },
  stratum_thickness = 30,
})

--3
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:siltstone",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 50,
  y_min           = 10,
  noise_params    = {
    offset = 24,
    scale = 16,
    spread = {x = 128, y = 128, z = 128},
    seed = 7822,
    octaves = 1,
  },
  stratum_thickness = 30,
})

--4
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:sandstone",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 70,
  y_min           = 30,
  noise_params    = {
    offset = 24,
    scale = 16,
    spread = {x = 128, y = 128, z = 128},
    seed = 1232,
    octaves = 1,
  },
  stratum_thickness = 30,
})

--5
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:claystone",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 90,
  y_min           = 50,
  noise_params    = {
    offset = 24,
    scale = 8,
    spread = {x = 64, y = 64, z = 64},
    seed = 88532,
    octaves = 1,
  },
  stratum_thickness = 30,
})


--6
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:conglomerate",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 110,
  y_min           = 70,
  noise_params    = {
    offset = 24,
    scale = 8,
    spread = {x = 64, y = 64, z = 64},
    seed = 10812,
    octaves = 1,
  },
  stratum_thickness = 30,
})

--7
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:siltstone",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 130,
  y_min           = 90,
  noise_params    = {
    offset = 24,
    scale = 8,
    spread = {x = 64, y = 64, z = 64},
    seed = 9222,
    octaves = 1,
  },
  stratum_thickness = 30,
})

--8
minetest.register_ore({
  ore_type        = "stratum",
  ore             = "nodes_nature:sandstone",
  wherein         = {"nodes_nature:limestone"},
  clust_scarcity  = 1,
  y_max           = 150,
  y_min           = 110,
  noise_params    = {
    offset = 24,
    scale = 8,
    spread = {x = 64, y = 64, z = 64},
    seed = 1111,
    octaves = 1,
  },
  stratum_thickness = 30,
})



----------------------------------------------------
--ORES AND INTRUSIONS

--ironstone
--iron rich sedimentary rock
minetest.register_ore({
		ore_type = "sheet",
		ore = "nodes_nature:ironstone",
		wherein = {"nodes_nature:claystone", "nodes_nature:siltstone", "nodes_nature:sandstone", "nodes_nature:conglomerate", "nodes_nature:limestone"},
		clust_size = 4,
		y_min = -31000,
		y_max = 31000,
		noise_threshold = 0.5,
		noise_params = {
			offset = 0, scale = 8, spread = {x = 150, y = 150, z = 150},
			seed = 8621, octaves = 2, persist = 0.60
		},
    column_height_min = 1,
    column_height_max = 4,
    column_midpoint_factor = 0.5
})


--Gneiss
--intrusions into granite, to blur the deep boudanry
minetest.register_ore({
		ore_type = "sheet",
		ore = "nodes_nature:gneiss",
		wherein = {"nodes_nature:granite"},
		clust_size = 4,
		y_min = -1500,
		y_max = -790,
		noise_threshold = 0.5,
		noise_params = {
			offset = 0, scale = 8, spread = {x = 150, y = 150, z = 150},
			seed = 9771, octaves = 2, persist = 0.60
		},
    column_height_min = 1,
    column_height_max = 4,
    column_midpoint_factor = 0.5
})


--Jade
--intrusions into gneiss
minetest.register_ore({
		ore_type = "sheet",
		ore = "nodes_nature:jade",
		wherein = {"nodes_nature:gneiss"},
		clust_size = 4,
		y_min = -31000,
		y_max = -790,
		noise_threshold = 0.5,
		noise_params = {
			offset = 0, scale = 8, spread = {x = 150, y = 150, z = 150},
			seed = 9041, octaves = 2, persist = 0.60
		},
    column_height_min = 1,
    column_height_max = 4,
    column_midpoint_factor = 0.5
})
