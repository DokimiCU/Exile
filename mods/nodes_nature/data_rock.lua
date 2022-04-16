-- Internationalization
local S = nodes_nature.S

--sedimentary rocks can be deconstructed into sediment, but not reformed
--sedimentary rocks are of the weakly consolidated soft variety

stone_list = {
	{"sandstone", S("Sandstone"),3, "sediment", "nodes_nature:sand",},
	{"siltstone", S("Siltstone"), 3, "sediment", "nodes_nature:silt",},
	{"claystone", S("Claystone"), 3, "sediment", "nodes_nature:clay",},
	{"conglomerate", S("Conglomerate"), 3,  "sediment", "nodes_nature:gravel",},
}
rock_list = {
	{"limestone", S("Limestone"), 3},
	{"ironstone", S("Ironstone"), 3},
  {"granite", S("Granite"), 1},
	{"basalt", S("Basalt"), 2},
	{"gneiss", S("Gneiss"), 1},
	{"jade", S("Jade"), 1},

}

sed_list = {
	{"sand", S("Sand"), 3, "sand"},
	{"silt", S("Silt"), 3, "silt" },
	{"clay", S("Clay"), 2, "clay"},
	{"gravel", S("Gravel"), 2, "gravel"},
	{"loam", S("Loam"), 3, "loam"},


}


soil_list = {
	{"grassland_soil", S("Grassland Soil"), 2, "clay", "clay"},
	{"marshland_soil", S("Marshland Soil"), 3, "silt", "silt"},
	{"duneland_soil", S("Duneland Soil"), 3, "sand", "sand"},
	{"highland_soil", S("Highland Soil"), 2, "gravel", "gravel"},
	{"woodland_soil", S("Woodland Soil"), 3, "loam", "loam"},
	{"grassland_barren_soil", S("Barren Grassland Soil"), 3, "gravel", "gravel"},
	{"woodland_dry_soil", S("Dry Woodland Soil"), 3, "silt", "silt"},

}


agri_soil_list = {
	{"clay_agricultural_soil", S("Clay Agricultural Soil"), 2, "nodes_nature:clay", "clay"},
	{"silt_agricultural_soil", S("Silty Agricultural Soil"), 3, "nodes_nature:silt", "silt"},
	{"sand_agricultural_soil", S("Sandy Agricultural Soil"), 3, "nodes_nature:sand", "sand"},
	{"gravel_agricultural_soil", S("Stony Agricultural Soil"), 3, "nodes_nature:gravel", "gravel"},
	{"loam_agricultural_soil", S("Loamy Agricultural Soil"), 3, "nodes_nature:loam", "loam"},
}
