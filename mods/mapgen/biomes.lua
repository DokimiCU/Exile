--[[ Register Biomes ]]--
--[[ Local Variables ]]--

	--- Range Limits
		local upper_limit          =  31000
		local lower_limit          = -31000
	--- Promontory Altitudes
		local highland_max         =    200
		local upland_max           =    100
		local lowland_max          =     50
		local coastal_max          =     10
	--- Marine Altitudes
		local beach_max            =      5
		local beach_min            =    -10
		local shallow_ocean_min    =    -30
		local deep_ocean_min       =   -120
		local undercity_min        =  -1500
		local crust_max            = -28000
	--- Climate Ranges
		local extreme_high         =     95
		local high                 =     75
		local middle               =     50
		local low                  =     25
		local extreme_low          =      5
	--- Misc Nodes
		local air              = "air"
		local potable          = "nodes_nature:freshwater_source"
		local lava             = "nodes_nature:lava_source"
	---Top Soil Nodes
		local forest           = "nodes_nature:forest_soil"
		local forest_wet       = "nodes_nature:forest_soil_wet"
		local woodl            = "nodes_nature:woodland_soil"
		local woodl_wet        = "nodes_nature:woodland_soil_wet"
		local up_forest        = "nodes_nature:upland_forest_soil"
		local up_forest_wet    = "nodes_nature:upland_forest_soil_wet"
		local up_woodl         = "nodes_nature:upland_woodland_soil"
		local up_woodl_wet     = "nodes_nature:upland_woodland_soil_wet"
		local marsh_wet        = "nodes_nature:marshland_soil_wet"
		local sw_forest_wet    = "nodes_nature:swamp_forest_soil_wet"
		local c_grland         = "nodes_nature:coastal_grassland_soil"
		local grland           = "nodes_nature:grassland_soil"
		local grland_wet       = "nodes_nature:grassland_soil_wet"
		local c_shland         = "nodes_nature:coastal_shrubland_soil"
		local shland           = "nodes_nature:shrubland_soil"
		local shland_wet       = "nodes_nature:shrubland_soil_wet"
		local barren           = "nodes_nature:barrenland_soil"
		local dune             = "nodes_nature:duneland_soil"
		local hland            = "nodes_nature:highland_soil"
	---Soil Nodes
		local sand             = "nodes_nature:sand"
		local sand_wet         = "nodes_nature:sand_wet"
		local sand_ws          = "nodes_nature:sand_wet_salty"
		local silt             = "nodes_nature:silt"
		local silt_wet         = "nodes_nature:silt_wet"
		local silt_ws          = "nodes_nature:silt_wet_salty"
		local loam             = "nodes_nature:loam"
		local gravel           = "nodes_nature:gravel"
		local gravel_w         = "nodes_nature:gravel_wet"
		local gravel_ws        = "nodes_nature:gravel_wet_salty"
		local clay             = "nodes_nature:clay"
		local clay_wet         = "nodes_nature:clay_wet"
	---Stone
		local limestone        = "nodes_nature:limestone"
		local granite          = "nodes_nature:granite"
		local gneiss           = "nodes_nature:gneiss"


--[[ Biomes ]]--[[
	01.	Coastal Forest
	02. Coastal Woodland
	03. Lowland Forest
	04. Lowland Woodland
	05. Upland Forest
	06. Upland Woodland
	07.	Swamp Forest
	08. Marshland
	09. Coastal Shrubland
	10. Coastal Grassland
	11. Lowland Shrubland
	12. Lowland Grassland
	13. Upland Shrubland
	14. Upland Grassland
	15. Coastal Barrenland
	16. Coastal Duneland
	17. Lowland Barrenland
	18. Lowland Duneland
	19. Upland Barrenland
	20. Upland Duneland
	21. Highland
	22. Highland Scree
	23. Highland Rock
	24. Sandy Beach
	25. Silty Beach
	26. Gravel Beach
	27. Sandy Coast
	28. Silty Coast
	29. Gravel Coast
	30. Shallow Water
	31. Deep Water
	32. Underground
	33. Deep Underground
	34. Mantle
]]

--[[Define Biomes Table]]--
local biome_list = {
	--                                                                                                 node   depth  node                       depth
	--                                  node        node     depth    node        depth    node        water  water  river      node            river    cave        vert                                             heat             humidity
	--          name                    dust        top      top      filler      filler   stone       top    top    water      riverbed        bed      liquid     blend     y_max               y_min               point            point
	--Forests & Woodland
	--[[01]]  { "Coastal Forest"    ,   nil,        forest,    1,        silt,     3,       limestone,   nil,   nil,  air     ,  silt_wet       ,   2,    {potable},   5,      coastal_max       ,  beach_max          ,  extreme_low   ,  high              ,  },
	--[[02]]  { "Coastal Woodland"  ,   nil,         woodl,    1,        silt,     2,       limestone,   nil,   nil,  air     ,  silt_wet       ,   2,    {potable},   5,      coastal_max       ,  beach_max          ,  high          ,  high              ,  },
	--[[03]]  { "Lowland Forest"    ,   nil,        forest,    1,        silt,     3,       limestone,   nil,   nil,  air     ,  forest_wet     ,   1,    {potable},   5,      lowland_max       ,  coastal_max        ,  extreme_low   ,  extreme_high      ,  },
	--[[04]]  { "Lowland Woodland"  ,   nil,         woodl,    1,        silt,     2,       limestone,   nil,   nil,  air     ,  woodl_wet      ,   1,    {potable},   5,      lowland_max       ,  coastal_max        ,  middle        ,  extreme_high      ,  },
	--[[05]]  { "Upland Forest"     ,   nil,     up_forest,    1,        clay,     2,       limestone,   nil,   nil,  air     ,  up_forest_wet  ,   1,    {potable},   25,      upland_max       ,  lowland_max        ,  extreme_low   ,  extreme_high      ,  },
	--[[06]]  { "Upland Woodland"   ,   nil,      up_woodl,    1,        clay,     2,       limestone,   nil,   nil,  air     ,  up_woodl_wet   ,   1,    {potable},   25,      upland_max       ,  lowland_max        ,  middle        ,  extreme_high      ,  },

	--Wetlands
	--[[07]]  { "Swamp Forest"      ,   nil, sw_forest_wet,    1,    silt_wet,     3,       limestone,   nil,   nil,   air    ,  clay_wet       ,   3,    {potable},   5,      coastal_max+5     ,  beach_max          ,  extreme_low   ,  extreme_high+5    ,  },
	--[[08]]  { "Marshland"         ,   nil,     marsh_wet,    1,    silt_wet,     3,       limestone,   nil,   nil,   air    ,  clay_wet       ,   3,    {potable},   5,      coastal_max+8     ,  beach_max          ,  middle        ,  extreme_high+5    ,  },

	--Shrublands & Grasslands
	--[[09]]  { "Coastal Shrubland" ,   nil,      c_shland,    1,        silt,     2,       limestone,   nil,   nil,  air     ,  gravel_w       ,   2,    {potable},   5,      coastal_max       ,  beach_max          ,  low           ,  middle             ,  },
	--[[10]]  { "Coastal Grassland" ,   nil,      c_grland,    1,        clay,     2,       limestone,   nil,   nil,  air     ,  gravel_w       ,   2,    {potable},   5,      coastal_max       ,  beach_max          ,  high          ,  middle             ,  },
	--[[11]]  { "Lowland Shrubland" ,   nil,        shland,    1,        clay,     3,       limestone,   nil,   nil,  air     ,  shland         ,   1,    {potable},   5,      lowland_max       ,  coastal_max        ,  low           ,  middle             ,  },
	--[[12]]  { "Lowland Grassland" ,   nil,        grland,    1,        clay,     2,       limestone,   nil,   nil,  air     ,  grland         ,   1,    {potable},   5,      lowland_max       ,  coastal_max        ,  high          ,  middle             ,  },
	--[[13]]  { "Upland Shrubland"  ,   nil,        shland,    1,        clay,     2,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upland_max       ,  lowland_max        ,  low           ,  middle             ,  },
	--[[14]]  { "Upland Grassland"  ,   nil,        grland,    1,        clay,     1,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upland_max       ,  lowland_max        ,  high          ,  middle             ,  },

	--Barrenlands & Dunelands
	--[[15]]  { "Coastal Barrenland",   nil,        barren,    1,      gravel,     2,       limestone,   nil,   nil,  air     ,  gravel_w       ,   2,    {potable},   5,      coastal_max       ,  beach_max          ,  middle-10      ,  extreme_low        ,  },
	--[[16]]  { "Coastal Duneland"  ,   nil,          dune,    1,        sand,     2,       limestone,   nil,   nil,  air     ,  gravel_w       ,   2,    {potable},   5,      coastal_max       ,  beach_max          ,  middle+10      ,  extreme_low        ,  },
	--[[17]]  { "Lowland Barrenland",   nil,        barren,    1,      gravel,     3,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   5,      lowland_max       ,  coastal_max        ,  middle-10      ,  extreme_low        ,  },
	--[[18]]  { "Lowland Duneland"  ,   nil,          dune,    1,        sand,     3,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   5,      lowland_max       ,  coastal_max        ,  middle+10      ,  extreme_low        ,  },
	--[[19]]  { "Upland Barrenland" ,   nil,        barren,    1,      gravel,     1,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upland_max       ,  lowland_max        ,  middle-10      ,  extreme_low        ,  },
	--[[20]]  { "Upland Duneland"   ,   nil,          dune,    1,        sand,     1,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upland_max       ,  lowland_max        ,  middle+10      ,  extreme_low        ,  },

	--Highland
	--[[21]]  { "Highland"          ,   nil,         hland,    1,      gravel,     1,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upper_limit      ,  upland_max         ,  middle         ,  middle             ,  },
	--[[22]]  { "Highland Scree"    ,   nil,        gravel,    1,        silt,     1,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upper_limit      ,  upland_max         ,  extreme_low    ,  low                ,  },
	--[[23]]  { "Highland Rock"    ,   nil,            air,    1,       gravel,    2,       limestone,   nil,   nil,  air     ,  gravel         ,   1,    {potable},   25,      upper_limit      ,  upland_max         ,  extreme_high   ,  low                ,  },

	--Coasts
	--[[24]]  { "Sandy Beach"       ,   nil,          sand,    3,     sand_ws,     1,       limestone,   nil,   nil,  air     ,  sand_ws        ,   2,    {potable},   1,      beach_max          ,  2                 ,  high          ,  middle            ,  },
	--[[25]]  { "Silty Beach"       ,   nil,          silt,    3,     silt_ws,     1,       limestone,   nil,   nil,  air     ,  silt_ws        ,   2,    {potable},   1,      beach_max          ,  2                 ,  middle        ,  high              ,  },
	--[[26]]  { "Gravel Beach"      ,   nil,        gravel,    3,   gravel_ws,     1,       limestone,   nil,   nil,  air     ,  gravel_ws      ,   2,    {potable},   1,      beach_max          ,  2                 ,  low           ,  middle            ,  },
	--[[27]]  { "Sandy Coast"       ,   nil,       sand_ws,    1,     sand_ws,     2,       limestone,   nil,   nil,  air     ,  sand_ws        ,   3,    {potable},   2,      1                  ,  beach_min         ,  high          ,  low               ,  },
	--[[28]]  { "Silty Coast"       ,   nil,       silt_ws,    1,     silt_ws,     2,       limestone,   nil,   nil,  air     ,  silt_ws        ,   3,    {potable},   2,      1                  ,  beach_min         ,  middle        ,  high              ,  },
	--[[29]]  { "Gravel Coast"      ,   nil,     gravel_ws,    1,   gravel_ws,     2,       limestone,   nil,   nil,  air     ,  gravel_ws      ,   3,    {potable},   2,      1                  ,  beach_min         ,  low           ,  low               ,  },

	--Depths
	--[[30]]  { "Shallow Water"      ,   nil,      sand_ws,    1,     sand_ws,     3,       limestone,   nil,   nil,  nil     ,    sand_ws      ,    2,   {potable},   1,      beach_min          ,  shallow_ocean_min ,  middle         ,  middle           ,  },
	--[[31]]  { "Deep Water"         ,   nil,      silt_ws,    1,     silt_ws,     3,         granite,   nil,   nil,  nil     ,    sand_ws      ,    2,   {potable},  10,      shallow_ocean_min  ,  deep_ocean_min    ,  middle         ,  middle           ,  },
	--[[32]]  { "Underground"        ,   nil,          nil,  nil,         nil,   nil,         granite,   nil,   nil,  nil     ,    nil          ,  nil,   {potable},  20,      deep_ocean_min     ,  undercity_min     ,  middle         ,  middle           ,  },
	--[[33]]  { "Deep Underground"   ,   nil,          nil,  nil,         nil,   nil,          gneiss,   nil,   nil,  nil     ,    nil          ,  nil,      {lava}, 100,      undercity_min      ,  crust_max         ,  middle         ,  middle           ,  },
	--[[34]]  { "Mantle"             ,   nil,          nil,  nil,         nil,   nil,            lava,   nil,   nil,  nil     ,    nil          ,  nil,      {lava}, 100,      crust_max          ,  lower_limit       ,  middle         ,  middle           ,  },


	}



--[[Loop to Iterate for Registrations]]--
for i in pairs(biome_list) do

   minetest.register_biome({
	 name               = biome_list[i][01],
	 node_dust          = biome_list[i][02],
	 node_top           = biome_list[i][03],
	 depth_top          = biome_list[i][04],
	 node_filler        = biome_list[i][05],
	 depth_filler       = biome_list[i][06],
	 node_stone         = biome_list[i][07],
	 node_water_top     = biome_list[i][08],
	 depth_water_top    = biome_list[i][09],
	 node_river_water   = biome_list[i][10],
	 node_riverbed      = biome_list[i][11],
	 depth_riverbed     = biome_list[i][12],
	 node_cave_liquid   = biome_list[i][13],
	 vertical_blend     = biome_list[i][14],
	 y_max              = biome_list[i][15],
	 y_min              = biome_list[i][16],
	 heat_point         = biome_list[i][17],
	 humidity_point     = biome_list[i][18],
   })
end
