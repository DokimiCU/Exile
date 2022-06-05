
local forest_on = {
  "nodes_nature:forest_soil", "nodes_nature:forest_soil_wet",
  "nodes_nature:upland_forest_soil", "nodes_nature:upland_forest_soil_wet",
}
local woodland_on = {
  "nodes_nature:woodland_soil", "nodes_nature:woodland_soil_wet",
  "nodes_nature:upland_woodland_soil", "nodes_nature:upland_woodland_soil_wet",
}
local rich_forest_on = {
  "nodes_nature:rich_forest_soil", "nodes_nature:rich_forest_soil_wet",
  "nodes_nature:rich_woodland_soil", "nodes_nature:rich_woodland_soil_wet",
}
local wetland_on = {
  "nodes_nature:swamp_forest_soil", "nodes_nature:swamp_forest_soil_wet",
  "nodes_nature:marshland_soil", "nodes_nature:marshland_soil_wet",
}
local swamp_forest_on = {
  "nodes_nature:swamp_forest_soil", "nodes_nature:swamp_forest_soil_wet",
}
local marshland_on = {
  "nodes_nature:marshland_soil", "nodes_nature:marshland_soil_wet",
}
local grassland_on = {
  "nodes_nature:coastal_grassland_soil", "nodes_nature:coastal_grassland_soil_wet",
  "nodes_nature:grassland_soil", "nodes_nature:grassland_soil_wet"
}
local shrubland_on = {
  "nodes_nature:coastal_shrubland_soil", "nodes_nature:coastal_shrubland_soil_wet",
  "nodes_nature:shrubland_soil", "nodes_nature:shrubland_soil_wet"
}
local grass_shrub_on = {
  "nodes_nature:coastal_grassland_soil", "nodes_nature:coastal_grassland_soil_wet",
  "nodes_nature:grassland_soil", "nodes_nature:grassland_soil_wet",
  "nodes_nature:coastal_shrubland_soil", "nodes_nature:coastal_shrubland_soil_wet",
  "nodes_nature:shrubland_soil", "nodes_nature:shrubland_soil_wet"
}
local duneland_on = {
  "nodes_nature:duneland_soil", "nodes_nature:duneland_soil_wet"
}
local barrenland_on = {
  "nodes_nature:barrenland_soil", "nodes_nature:barrenland_soil_wet"
}
local highland_on = {
  "nodes_nature:highland_soil", "nodes_nature:highland_soil_wet"
}
local all_barren_on = {
  "nodes_nature:duneland_soil", "nodes_nature:duneland_soil_wet",
  "nodes_nature:barrenland_soil", "nodes_nature:barrenland_soil_wet",
  "nodes_nature:highland_soil", "nodes_nature:highland_soil_wet"
}
local all_soils_on = {
  "nodes_nature:forest_soil", "nodes_nature:forest_soil_wet",
  "nodes_nature:upland_forest_soil", "nodes_nature:upland_forest_soil_wet",
  "nodes_nature:woodland_soil", "nodes_nature:woodland_soil_wet",
  "nodes_nature:upland_woodland_soil", "nodes_nature:upland_woodland_soil_wet",
  "nodes_nature:rich_forest_soil", "nodes_nature:rich_forest_soil_wet",
  "nodes_nature:rich_woodland_soil", "nodes_nature:rich_woodland_soil_wet",
  "nodes_nature:swamp_forest_soil", "nodes_nature:swamp_forest_soil_wet",
  "nodes_nature:marshland_soil", "nodes_nature:marshland_soil_wet",
  "nodes_nature:coastal_grassland_soil", "nodes_nature:coastal_grassland_soil_wet",
  "nodes_nature:grassland_soil", "nodes_nature:grassland_soil_wet",
  "nodes_nature:coastal_shrubland_soil", "nodes_nature:coastal_shrubland_soil_wet",
  "nodes_nature:shrubland_soil", "nodes_nature:shrubland_soil_wet",
  "nodes_nature:duneland_soil", "nodes_nature:duneland_soil_wet",
  "nodes_nature:barrenland_soil", "nodes_nature:barrenland_soil_wet",
  "nodes_nature:highland_soil", "nodes_nature:highland_soil_wet",
}
local glow_worm_on = {
  "nodes_nature:granite", "nodes_nature:gneiss", "nodes_nature:limestone", "nodes_nature:jade",
}
local gravel_on = {
  "nodes_nature:granite", "nodes_nature:limestone", "nodes_nature:gneiss", "nodes_nature:conglomerate",
}
local sand_on = {
  "nodes_nature:granite", "nodes_nature:limestone", "nodes_nature:gneiss", "nodes_nature:sandstone",
}
local silt_on = {
  "nodes_nature:granite", "nodes_nature:limestone", "nodes_nature:gneiss", "nodes_nature:siltstone",
}
local clay_on = {
  "nodes_nature:granite", "nodes_nature:limestone", "nodes_nature:gneiss", "nodes_nature:claystone",
}
local cave_mushrooms_on  = {
  "nodes_nature:silt", "nodes_nature:clay", "nodes_nature:sand", "nodes_nature:gravel",
  "nodes_nature:silt_wet", "nodes_nature:clay_wet", "nodes_nature:sand_wet", "nodes_nature:gravel_wet",
}
local fish_on = {
  "nodes_nature:silt_wet_salty", "nodes_nature:sand_wet_salty","nodes_nature:gravel_wet_salty",
}
local cave_egg_on = {
  "nodes_nature:granite", "nodes_nature:limestone", "nodes_nature:ironstone", "nodes_nature:gneiss",
  "nodes_nature:granite_boulder", "nodes_nature:limestone_boulder", "nodes_nature:ironstone_boulder", "nodes_nature:gneiss_boulder",
  "nodes_nature:sandstone", "nodes_nature:siltstone", "nodes_nature:claystone", "nodes_nature:conglomerate",
}

--altitudes
local land_max            =    600
local land_min            =      1
local highland_max         =    200
local upland_max           =    100
local lowland_max          =     50
local coastal_max          =     10
--- Marine Altitudes
local beach_max            =      5
local beach_min            =    -10
local shallow_ocean_min    =    -30


--Cane schematics
local canes_list   = { --- Schematics
	-- name                 y  x  z
	{"nodes_nature:gemedi", 7, 1, 1, 255, 245, 225, 205, 155,  55,  35 },
	{"nodes_nature:cana"  , 7, 1, 1, 255, 255, 255, 255, 230, 155, 105 },
	{"nodes_nature:tiken" , 7, 1, 1, 255, 255, 255, 255, 230, 155, 105 },
	{"nodes_nature:chalin", 7, 1, 1 ,255, 255, 255, 255, 230, 155, 105 }, --Exile v4 cane plant, found in dry woodlands
	}
local canes = {}
for i in ipairs(canes_list) do --
	local shape = { name = canes_list[i][1], param2 = 2 }
	canes[i]    = {
		size = {y = canes_list[i][2], x = canes_list[i][3], z = canes_list[i][4]},
		data = {shape, shape, shape, shape, shape, shape, shape},
		yslice_prob = {
			{ypos = 0, prob = canes_list[i][05]},
			{ypos = 1, prob = canes_list[i][06]},
			{ypos = 2, prob = canes_list[i][07]},
			{ypos = 3, prob = canes_list[i][08]},
			{ypos = 4, prob = canes_list[i][09]},
			{ypos = 5, prob = canes_list[i][10]},
			{ypos = 6, prob = canes_list[i][11]},
			},
		}
	end
local gemedi = canes[1]
local cana   = canes[2]
local tiken  = canes[3]
local chalin = canes[4]

--Tree schematic
function find(object)
	return minetest.get_modpath("mapgen").."/schematics/"..object..".mts"
end


--- Decoration ---
local decoration_list = {
	--         Description                               name                                  deco_type    place_on                          place_offset_y sidelen fill_ratio  noise_params                                                                                                          y_max             y_min         decoration                        spawn_by       num_spawn_by schematic              flags                            rotation   param2 param2_max

---- Wetlands
  { --[[ Trees: daoja forest upland              ]]    "swamp_daoja"                     , "schematic", swamp_forest_on                    ,  -2,           80,     0.012000,  nil                                                                                                              ,      upland_max,     beach_max, nil                                , nil          , nil,         find("daoja")        , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[wetland: cana                            ]]    "sf_nn:cana"                      , "schematic", wetland_on                         , nil,           80,     0.008000,  nil                                                                                                              ,      upland_max,     beach_max, nil                                , nil          , nil,         cana                 , nil                             ,      nil, nil,   nil, },
  { --[[ Marshland: cana                         ]]    "nodes_nature:cana"               , "schematic", marshland_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 2.0000, spread = {x =  16, y =  16, z =  16}, seed =    578, octaves = 3, persist = 0.7},     coastal_max+5,   beach_max, nil                                , nil          , nil,         cana                 , nil                             ,      nil, nil,   nil, },
  { --[[ Marshland: bronach                      ]]    "nodes_nature:bronach"            , "simple"   , marshland_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0700, spread = {x =  16, y =  16, z =  16}, seed =   1707, octaves = 2, persist = 0.9},     lowland_max,     beach_max, "nodes_nature:bronach"             , nil          , nil,         nil                  , nil                             ,      nil,   3,   nil, },
  { --[[ wetland: tanai                          ]]    "nodes_nature:tanai"              , "simple"   , wetland_on                         , nil,           80,     0.900000,  nil                                                                                                              ,     lowland_max,     beach_max, "nodes_nature:tanai"               , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
	{ --[[ wetland: galanta                        ]]    "nodes_nature:galanta"            , "simple"   , wetland_on                         , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0040, spread = {x =  32, y =  32, z =  32}, seed =    153, octaves = 2, persist = 0.8},     lowland_max,     beach_max, "nodes_nature:galanta"             , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
	{ --[[ wetland: marbhan                        ]]    "nodes_nature:marbhan"            , "simple"   , wetland_on                         , nil,           80,     0.001500,  nil                                                                                                              ,     lowland_max,     beach_max, "nodes_nature:marbhan"             , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[  wetland: denser moss in marsh          ]]    "wl_nn:moss"                      , "simple"   , wetland_on                         , nil,           16,     nil     ,  {offset =  0.00, scale = 0.4000, spread = {x =  16, y =  16, z =  16}, seed =   1640, octaves = 2, persist = 0.8},     lowland_max,     beach_max, "nodes_nature:moss"                , nil          , nil,         nil                  , nil                             ,      nil, nil,   nil, },

  ---- Forests & Woodlands
  { --[[  topsoil intrusions: rich               ]]    "nodes_nature:rich_forest_soil"   , "simple"   , forest_on                          ,  -1,           04,     nil     ,  {offset = -0.60, scale = 1.0000, spread = {x =  32, y =  32, z =  32}, seed =   1995, octaves = 2, persist = 1.0},      lowland_max,    beach_max, "nodes_nature:rich_forest_soil"    , nil          , nil,         nil                  , "force_placement"               ,      nil, nil,   nil, },
  { --[[  topsoil intrusions: rich               ]]    "nodes_nature:rich_woodland_soil" , "simple"   , woodland_on                        ,  -1,           04,     nil     ,  {offset = -0.60, scale = 1.0000, spread = {x =  32, y =  32, z =  32}, seed =   1995, octaves = 2, persist = 1.0},      lowland_max,    beach_max, "nodes_nature:rich_woodland_soil"  , nil          , nil,         nil                  , "force_placement"               ,      nil, nil,   nil, },
  { --[[ rich forest: damo                       ]]    "nodes_nature:damo"               , "simple"   , rich_forest_on                     , nil,           80,     0.900000,  nil                                                                                                              ,     highland_max,    beach_max, "nodes_nature:damo"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },

  { --[[ Trees: dominant amma forest             ]]    "amma_forest_ll"                  , "schematic", forest_on                          ,  -4,           80,     0.007000,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("amma")         , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: dominant amma forest upland      ]]    "amma_forest_upl"                 , "schematic", forest_on                          ,  -4,           80,     0.006000,  nil                                                                                                              ,      upland_max,   lowland_max, nil                                , nil          , nil,         find("amma")         , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: rare amma woodland               ]]    "amma_w_lland"                    , "schematic", woodland_on                        ,  -4,           80,     0.000600,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("amma")         , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: rare sasaran in forest           ]]    "sasaran_f_lland"                 , "schematic", forest_on                          ,  -4,           80,     0.000500,  nil                                                                                                              ,      upland_max,     beach_max, nil                                , nil          , nil,         find("sasaran1")     , "place_center_x, place_center_z", "random", nil,   nil, },
	{ --[[ Trees: dominant sasaran in woodland     ]]    "sasaran_w_lland"                 , "schematic", woodland_on                        ,  -4,           80,     0.005500,  nil                                                                                                              ,      upland_max,     beach_max, nil                                , nil          , nil,         find("sasaran1")     , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: common panasee in forest         ]]    "panasee_forest"                  , "schematic", forest_on                          ,  -1,           80,     0.000800,  nil                                                                                                              ,      upland_max,     beach_max, nil                                , nil          , nil,         find("panasee")      , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: rare panasee in woodland         ]]    "panasee_woodland"                , "schematic", woodland_on                        ,  -1,           80,     0.000100,  nil                                                                                                              ,      upland_max,     beach_max, nil                                , nil          , nil,         find("panasee")      , "place_center_x, place_center_z", "random", nil,   nil, },

  { --[[ forest Chalin                           ]]    "fr_nn:chalin"                    , "schematic", forest_on                          , nil,           80,     0.008000,  nil                                                                                                              ,    highland_max,     beach_max, nil                                , nil          , nil,         chalin               , nil                             ,      nil, nil,   nil, },
  { --[[ forest: damo                            ]]    "fr_nn:damo"                      , "simple"   , forest_on                          , nil,           80,     0.030000,  nil                                                                                                              ,    highland_max,     beach_max, "nodes_nature:damo"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[ forest: vansano                         ]]    "fr_nn:vansano"                   , "simple"   , forest_on                          , nil,           80,     0.010000,  nil                                                                                                              ,     lowland_max,   coastal_max, "nodes_nature:vansano"             , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
	{ --[[ forest: merki                           ]]    "fr_nn:merki"                     , "simple"   , forest_on                          , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0200, spread = {x =  32, y =  32, z =  32}, seed =   1112, octaves = 2, persist = 0.7},    highland_max,   lowland_max, "nodes_nature:merki"               , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[  forest: denser moss                    ]]    "fr_nn:moss"                      , "simple"   , forest_on                          , nil,           16,     nil     ,  {offset =  0.00, scale = 0.6000, spread = {x =  16, y =  16, z =  16}, seed =   1640, octaves = 2, persist = 0.7},     lowland_max,     beach_max, "nodes_nature:moss"                , nil          , nil,         nil                  , nil                             ,      nil, nil,   nil, },
  { --[[ forest:   Momo                          ]]    "fr_nn:momo"                      , "simple"   , forest_on                          , nil,           80,     0.003000,  nil                                                                                                              ,    highland_max,   coastal_max, "nodes_nature:momo"                , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ forest: zufani                          ]]    "fr_nn:zufani"                    , "simple"   , forest_on                          , nil,           80,     0.000500,  nil                                                                                                              ,    highland_max,     beach_max, "nodes_nature:zufani"              , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },


  { --[[ woodland Chalin clumps                  ]]    "wl_nn:chalin"                    , "schematic", woodland_on                        , nil,           16,     nil     ,  {offset =  0.00, scale = 0.1000, spread = {x =  16, y =  16, z =  16}, seed =   1881, octaves = 2, persist = 1}  ,      upland_max,     beach_max, nil                                , nil          , nil,         chalin               , nil                             ,      nil, nil,   nil, },
  { --[[ woodland: damo                          ]]    "wl_nn:damo"                      , "simple"   , woodland_on                        , nil,           80,     0.300000,  nil                                                                                                              ,     lowland_max,     beach_max, "nodes_nature:damo"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[ woodland: damo  upland                  ]]    "wl_ul_nn:damo"                   , "simple"   , woodland_on                        , nil,           80,     0.050000,  nil                                                                                                              ,     coastal_max,     beach_max, "nodes_nature:damo"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[ woodland: sari                          ]]    "wl_nn:sari"                      , "simple"   , woodland_on                        , nil,           80,     0.200000,  nil                                                                                                              ,    highland_max,   lowland_max, "nodes_nature:sari"                , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ woodland: vansano                       ]]    "wl_nn:vansano"                   , "simple"   , woodland_on                        , nil,           80,     0.001000,  nil                                                                                                              ,     lowland_max,   coastal_max, "nodes_nature:vansano"             , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ woodland: hakimi                        ]]    "wl_nn:hakimi"                    , "simple"   , woodland_on                        , nil,           80,     0.001000,  nil                                                                                                              ,     lowland_max,     beach_max, "nodes_nature:hakimi"              , nil          , nil,         nil                  , nil                             ,      nil,   3,   nil, },
	{ --[[ woodland:   Momo                        ]]    "wl_nn:momo"                      , "simple"   , woodland_on                        , nil,           80,     0.001000,  nil                                                                                                              ,    highland_max,   coastal_max, "nodes_nature:momo"                , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ woodland: nebiyi                        ]]    "wl_nn:nebiyi"                    , "simple"   , woodland_on                        , nil,           80,     0.001000,  nil                                                                                                              ,    highland_max,   lowland_max, "nodes_nature:nebiyi"              , nil          , nil,         nil                  , nil                             ,      nil,   1,   nil, },
  { --[[ woodland: zufani                        ]]    "wl_nn:zufani"                    , "simple"   , woodland_on                        , nil,           80,     0.000500,  nil                                                                                                              ,    highland_max,     beach_max, "nodes_nature:zufani"              , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },

  ---- Shrubland & Grassland
  { --[[ Trees: old tangkal in grassland         ]]    "grass_tangkal_tree_old"          , "schematic", grassland_on                       ,  -5,           80,     0.000010,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("tangkal_old")  , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: adult tangkal in grassland       ]]    "grass_tangkal_tree"              , "schematic", grassland_on                       ,  -5,           80,     0.000020,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("tangkal_tree") , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: young tangkal in grassland       ]]    "grass_tangkal_tree_young"        , "schematic", grassland_on                       ,  -3,           80,     0.000010,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("tangkal_young"), "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: maraka in grassland              ]]    "grass_maraka_tree"               , "schematic", grassland_on                       ,  -3,           16,     nil     ,  {offset =  0.00, scale = 0.0005, spread = {x = 250, y = 250, z = 250}, seed =    222, octaves = 2, persist = 0.8},      upland_max,     beach_max, nil                                , nil          , nil,         find("maraka_tree")  , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Grassland: gemedi                       ]]    "nodes_nature:gemedi"             , "schematic", grassland_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 1.0000, spread = {x = 128, y = 128, z = 128}, seed =    998, octaves = 2, persist = 0.8},     coastal_max,     beach_max, nil                                , nil          , nil,         gemedi               , nil                             ,      nil, nil,   nil, },
  { --[[ Grassland: sari                         ]]    "gr_nn:sari"                      , "simple"   , grassland_on                       , nil,           80,     0.500000,  nil                                                                                                              ,    highland_max,     beach_max, "nodes_nature:sari"                , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ Grassland: gitiri                       ]]    "gr_nn:gitiri"                    , "simple"   , grassland_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0500, spread = {x =  32, y =  32, z =  32}, seed =   1001, octaves = 2, persist = 0.6},    highland_max,     beach_max, "nodes_nature:gitiri"              , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },

  { --[[ Trees: old tangkal in shrubland         ]]    "shrub_tangkal_tree_old"          , "schematic", shrubland_on                       ,  -5,           80,     0.000030,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("tangkal_old")  , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: adult tangkal in shrubland       ]]    "shrub_tangkal_tree"              , "schematic", shrubland_on                       ,  -5,           80,     0.000050,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("tangkal_tree") , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: young tangkal in shrubland       ]]    "shrub_tangkal_tree_young"        , "schematic", shrubland_on                       ,  -3,           80,     0.000030,  nil                                                                                                              ,     lowland_max,     beach_max, nil                                , nil          , nil,         find("tangkal_young"), "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: maraka in shrubland              ]]    "shrub_maraka_tree"               , "schematic", shrubland_on                       ,  -3,           16,     nil     ,  {offset =  0.00, scale = 0.0009, spread = {x = 250, y = 250, z = 250}, seed =    222, octaves = 2, persist = 0.6},      upland_max,     beach_max, nil                                , nil          , nil,         find("maraka_tree")  , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[ Trees: rare panasee in shrubland        ]]    "panasee_shrubland"               , "schematic", shrubland_on                       ,  -1,           80,     0.000030,  nil                                                                                                              ,     coastal_max,     beach_max, nil                                , nil          , nil,         find("panasee")      , "place_center_x, place_center_z", "random", nil,   nil, },

  { --[[ Shrubland Chalin clumps                 ]]    "sh_nn:chalin"                    , "schematic", shrubland_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 0.1000, spread = {x =  16, y =  16, z =  16}, seed =   1881, octaves = 3, persist = 1}  ,      upland_max,     beach_max, nil                               , nil          , nil,         chalin                , nil                             ,      nil, nil,   nil, },
  { --[[ Shrubland: sari                         ]]    "sh_nn:sari"                      , "simple"   , shrubland_on                       , nil,           80,     0.250000,  nil                                                                                                              ,    highland_max,     beach_max, "nodes_nature:sari"                , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ Shrubland: gitiri                       ]]    "sh_nn:gitiri"                    , "simple"   , shrubland_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 0.2000, spread = {x =  32, y =  32, z =  32}, seed =   1001, octaves = 2, persist = 0.6},    highland_max,     beach_max, "nodes_nature:gitiri"              , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ shrubland: nebiyi                       ]]    "sh_nn:nebiyi"                    , "simple"   , shrubland_on                       , nil,           80,     0.001000,  nil                                                                                                              ,    highland_max,   coastal_max, "nodes_nature:nebiyi"              , nil          , nil,         nil                  , nil                             ,      nil,   1,   nil, },
  { --[[ shrubland: damo                         ]]    "sh_nn:damo"                      , "simple"   , shrubland_on                       , nil,           80,     0.200000,  nil                                                                                                              ,     coastal_max,     beach_max, "nodes_nature:damo"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },

  { --[[ Grass & Shrub: tikusati                 ]]    "nodes_nature:tikusati"           , "simple"   , grass_shrub_on                     , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0010, spread = {x = 100, y = 100, z = 100}, seed =   1002, octaves = 2, persist = 0.7},    highland_max,   lowland_max, "nodes_nature:tikusati"            , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },
  { --[[ Grass & Shrub: wiha                     ]]    "nodes_nature:wiha"               , "simple"   , grass_shrub_on                     , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0020, spread = {x =  32, y =  32, z =  32}, seed =   1003, octaves = 2, persist = 0.7},    highland_max,   coastal_max, "nodes_nature:wiha"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[ Grass & Shrub: hakimi                   ]]    "gs_nn:hakimi"                    , "simple"   , grass_shrub_on                     , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0010, spread = {x = 100, y = 100, z = 100}, seed =   1004, octaves = 2, persist = 0.8},     lowland_max,     beach_max, "nodes_nature:hakimi"              , nil          , nil,         nil                  , nil                             ,      nil,   3,   nil, },
  { --[[ Grass & Shrub: zufani                   ]]    "gs_nn:zufani"                    , "simple"   , grass_shrub_on                     , nil,           80,     0.001000,  nil                                                                                                              ,    highland_max,     beach_max, "nodes_nature:zufani"              , nil          , nil,         nil                  , nil                             ,      nil,   2,   nil, },

 ---- Barrenland & Duneland
  { --[[  Duneland: alaf                         ]]    "nodes_nature:alaf"               , "simple"   , duneland_on                        , nil,           80,     0.100000,  nil                                                                                                              ,      upland_max,     beach_max, "nodes_nature:alaf"                , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[  Duneland: anperla                      ]]    "nodes_nature:anperla"            , "simple"   , duneland_on                        , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0010, spread = {x =  32, y =  32, z =  32}, seed =   1112, octaves = 2, persist = 0.8},     lowland_max,     beach_max, "nodes_nature:anperla"             , nil          , nil,         nil                  , nil                             ,      nil,   3,   nil, },
	{ --[[  Duneland: tiken                        ]]    "nodes_nature:tiken"              , "schematic", duneland_on                        , nil,           16,     nil     ,  {offset =  0.00, scale = 1.0000, spread = {x =  64, y =  64, z =  64}, seed =    998, octaves = 2, persist = 0.9},    beach_max +3,     beach_max, nil                                , nil          , nil,         tiken                , nil                             ,      nil, nil,   nil, },
	{ --[[ Barrenland: Tashvish                    ]]    "nodes_nature:tashvish"           , "simple"   , barrenland_on                      , nil,           80,     0.200000,  nil                                                                                                              ,     highland_max,     beach_max, "nodes_nature:tashvish"           , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[ all barren: Jogalan                     ]]    "nodes_nature:jogalan"            , "simple"   , all_barren_on                      , nil,           80,     0.000150,  nil                                                                                                              ,     highland_max,     beach_max, "nodes_nature:jogalan"            , nil          , nil,         nil                  , nil                             ,      nil,   0,   nil, },
  { --[[ all barren:   Orom                      ]]    "nodes_nature:orom"               , "simple"   , all_barren_on                      , nil,           80,     0.000100,  nil                                                                                                              ,      lowland_max,   coastal_max, "nodes_nature:orom"               , nil          , nil,         nil                  , nil                             ,      nil,   1,   nil, },

---Highland
  { --[[  Highland: thoka                        ]]    "nodes_nature:thoka"              , "simple"   , highland_on                        , nil,           80,     0.300000,  nil                                                                                                              ,           31000,     upland_max, "nodes_nature:thoka"              , nil          , nil,         nil                  , nil                             ,      nil,   4,   nil, },
  { --[[ all barren:   veke                      ]]    "nodes_nature:veke"               , "simple"   , all_barren_on                      , nil,           80,     0.000100,  nil                                                                                                              ,           31000,     upland_max, "nodes_nature:veke"               , nil          , nil,         nil                  , nil                             ,      nil,   0,   nil, },

----Water
  { --[[Trees: kagum on salt silt                ]]    "nodes_nature:kagum_tree"         , "schematic", "nodes_nature:silt_wet_salty"      ,   0,           80,     nil     ,  {offset =  0.00, scale = 0.0450, spread = {x = 128, y = 128, z = 128}, seed =  51122, octaves = 3, persist = 0.6},                 1,           -1, nil                               , nil          , nil,         find("kagum1")       , "place_center_x, place_center_z", "random", nil,   nil, },
  { --[[    Oceans: kelp                         ]]    "nodes_nature:kelp"               , "simple"   , "nodes_nature:gravel_wet_salty"    ,  -1,           16,     nil     ,  {offset =  0.00, scale = 0.6000, spread = {x =  64, y =  64, z =  64}, seed =  82112, octaves = 3, persist = 0.9},                -7,          -15, "nodes_nature:kelp"               , nil          , nil,         nil                  , "force_placement"               ,      nil,  48,    96, },
	{ --[[    Oceans: seagrass                     ]]    "nodes_nature:seagrass"           , "simple"   , "nodes_nature:sand_wet_salty"      ,  -1,           16,     nil     ,  {offset =  0.00, scale = 0.5000, spread = {x =  32, y =  32, z =  32}, seed =  11312, octaves = 3, persist = 0.6},                -1,           -6, "nodes_nature:seagrass"           , nil          , nil,         nil                  , "force_placement"               ,      nil,  16,   nil, },
	{ --[[    Oceans: sea lettuce                  ]]    "nodes_nature:sea_lettuce"        , "simple"   , "nodes_nature:silt_wet_salty"      ,  -1,           16,     nil     ,  {offset =  0.00, scale = 0.5000, spread = {x =  32, y =  32, z =  32}, seed =  84322, octaves = 3, persist = 0.6},                -1,           -7, "nodes_nature:sea_lettuce"        , nil          , nil,         nil                  , "force_placement"               ,      nil,  16,   nil, },
  { --[[    Oceans: nagaeo                       ]]    "nodes_nature:nagaeo"             , "simple"   , "nodes_nature:silt_wet_salty"      ,  -1,           16,     nil     ,  {offset =  0.00, scale = 0.5000, spread = {x =  16, y =  16, z =  16}, seed =  99310, octaves = 2, persist = 0.7},                -5,          -15, "nodes_nature:nagaeo"             , nil          , nil,         nil                  , "force_placement"               ,      nil,  16,   nil, },
  { --[[    Oceans: koaeako                      ]]    "nodes_nature:koaeako"            , "simple"   , "nodes_nature:sand_wet_salty"      ,  -1,           16,     nil     ,  {offset =  0.00, scale = 0.5000, spread = {x =  64, y =  64, z =  64}, seed =  80012, octaves = 2, persist = 0.7},                -3,          -10, "nodes_nature:koaeako"            , nil          , nil,         nil                  , "force_placement"               ,      nil,  16,   nil, },
  { --[[    Oceans: imoaru                       ]]    "nodes_nature:imoaru"             , "simple"   , "nodes_nature:gravel_wet_salty"    ,  -1,           16,     nil     ,  {offset =  0.00, scale = 0.7000, spread = {x =  16, y =  16, z =  16}, seed =  77512, octaves = 2, persist = 0.9},                -1,          -15, "nodes_nature:imoaru"             , nil          , nil,         nil                  , "force_placement"               ,      nil,  16,   nil, },


---Caves
	{ --[[ Underground: Cave worms on cave roof    ]]    "nodes_nature:glow_worm"          , "simple"   , glow_worm_on                       , nil,           16,     nil     ,  {offset = -0.04, scale = 0.4000, spread = {x= 64,y= 64,z= 64}, seed=11002, octaves = 2, persist = 0.9}            ,               -15,        -1000, "nodes_nature:glow_worm"         , nil          , nil,         nil                  , "all_ceilings"                  ,      nil,   3,   nil, },
  { --[[  Boulders: granite boulder              ]]    "nodes_nature:granite_boulder"    , "simple"   , "nodes_nature:granite"             , nil,           80,     0.050000,  nil                                                                                                               ,             31000,       -31000, "nodes_nature:granite_boulder"   , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[  Boulders: limestone boulder            ]]    "nodes_nature:limestone_boulder"  , "simple"   , "nodes_nature:limestone"           , nil,           80,     0.050000,  nil                                                                                                               ,             31000,       -31000, "nodes_nature:limestone_boulder" , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[  Boulders: basalt boulder               ]]    "nodes_nature:basalt_boulder"     , "simple"   , "nodes_nature:basalt"              , nil,           80,     0.050000,  nil                                                                                                               ,             31000,       -31000, "nodes_nature:basalt_boulder"    , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[  Boulders: ironstone, dense on deposits ]]    "nodes_nature:ironstone_boulder"  , "simple"   , "nodes_nature:ironstone"           , nil,           80,     0.600000,  nil                                                                                                               ,             31000,       -31000, "nodes_nature:ironstone_boulder" , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[  Boulders: gneiss boulder               ]]    "nodes_nature:gneiss_boulder"     , "simple"   , "nodes_nature:gneiss"              , nil,           80,     0.050000,  nil                                                                                                               ,             31000,       -31000, "nodes_nature:gneiss_boulder"    , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[  Boulders: jade boulder                 ]]    "nodes_nature:jade_boulder"       , "simple"   , "nodes_nature:jade"                , nil,           80,     0.400000,  nil                                                                                                               ,             31000,       -31000, "nodes_nature:jade_boulder"      , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[ Sediments: cave gravel                  ]]    "cave_gravel"                     , "simple"   , gravel_on                          ,  -1,           04,     nil     ,  {offset = -0.50, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed = 873515, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:gravel"            , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave sand                    ]]    "cave_sand"                       , "simple"   , sand_on                            ,  -1,           04,     nil     ,  {offset = -0.50, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed = 795515, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:sand"              , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave clay                    ]]    "cave_clay"                       , "simple"   , clay_on                            ,  -1,           04,     nil     ,  {offset = -0.50, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed =  87005, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:clay"              , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave silt                    ]]    "cave_silt"                       , "simple"   , silt_on                            ,  -1,           04,     nil     ,  {offset = -0.50, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed =  87005, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:silt"              , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave gravel wet              ]]    "cave_gravel_w"                   , "simple"   , gravel_on                          ,  -1,           04,     nil     ,  {offset = -0.70, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed = 174415, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:gravel_wet"        , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave sand wet                ]]    "cave_sand_w"                     , "simple"   , sand_on                            ,  -1,           04,     nil     ,  {offset = -0.70, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed = 796565, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:sand_wet"          , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave clay wet                ]]    "cave_clay_w"                     , "simple"   , clay_on                            ,  -1,           04,     nil     ,  {offset = -0.70, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed =  87005, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:clay_wet"          , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Sediments: cave silt wet                ]]    "cave_silt_w"                     , "simple"   , silt_on                            ,  -1,           04,     nil     ,  {offset = -0.70, scale = 3.0000, spread = {x =  32, y =  32, z =  32}, seed =  85025, octaves = 2, persist = 0.9},              31000,       -31000, "nodes_nature:silt_wet"          , nil          , nil,         nil                  , "all_floors, force_placement"   ,      nil, nil,   nil, },
  { --[[ Mushrooms: lambakap  (food and water)   ]]    "nodes_nature:lambakap"           , "simple"   , cave_mushrooms_on                  , nil,           80,     0.010000,  nil                                                                                                              ,                -80,         -950, "nodes_nature:lambakap"          , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[ Mushrooms: reshedaar (wood source)      ]]    "nodes_nature:reshedaar"          , "simple"   , cave_mushrooms_on                  , nil,           80,     0.010000,  nil                                                                                                              ,                -80,         -950, "nodes_nature:reshedaar"         , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[ Mushrooms: mahal     (fibre source)     ]]    "nodes_nature:mahal"              , "simple"   , cave_mushrooms_on                  , nil,           80,     0.010000,  nil                                                                                                              ,                -80,         -950, "nodes_nature:mahal"             , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },

----All Soils
  { --[[  all: moss                              ]]    "all_nn:moss"                     , "simple"   , all_soils_on                       , nil,           80,     0.001000,  nil                                                                                                              ,       highland_max,     beach_max, "nodes_nature:moss"             , nil          , nil,         nil                  , nil                             ,      nil, nil,   nil, },

----Eggs
  { --[[   Animals: gundu                        ]]    "animals:gundu_eggs"              , "simple"   , fish_on                            , nil,           80,     0.000500,  nil                                                                                                              ,                -3,          -25, "animals:gundu_eggs"              , nil          , nil,         nil                  , "force_placement"               ,      nil, nil,   nil, },
	{ --[[   Animals: sarkamos                     ]]    "animals:sarkamos_eggs"           , "simple"   , fish_on                            , nil,           80,     0.000070,  nil                                                                                                              ,                -5,          -35, "animals:sarkamos_eggs"           , nil          , nil,         nil                  , "force_placement"               ,      nil, nil,   nil, },
	{ --[[   Animals: impethu                      ]]    "animals:impethu_eggs"            , "simple"   , cave_egg_on                        , nil,           80,     0.005000,  nil                                                                                                              ,       lowland_max,         -950, "animals:impethu_eggs"            , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[   Animals: kubwakubwa                   ]]    "animals:kubwakubwa_eggs"         , "simple"   , cave_egg_on                        , nil,           80,     0.001500,  nil                                                                                                              ,       lowland_max,         -150, "animals:kubwakubwa_eggs"         , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[   Animals: kubwakubwa forest            ]]    "animals:kubwakubwa_eggs_forest"  , "simple"   , forest_on                          , nil,           80,     0.000500,  nil                                                                                                              ,      highland_max,  coastal_max, "animals:kubwakubwa_eggs"         , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
  { --[[   Animals: darkasthaan                  ]]    "animals:darkasthaan_eggs"        , "simple"   , cave_egg_on                        , nil,           80,     0.002000,  nil                                                                                                              ,              -130,         -950, "animals:darkasthaan_eggs"        , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
	{ --[[   Animals: pegasun                      ]]    "animals:pegasun_eggs"            , "simple"   , all_soils_on                       , nil,           16,     nil     ,  {offset =  0.00, scale = 0.0030, spread = {x = 64, y = 64, z = 64}, seed =   1882, octaves = 2, persist = 2},             upland_max,    beach_max, "animals:pegasun_eggs"            , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },
	{ --[[   Animals: sneachan                     ]]    "animals:sneachan_eggs"           , "simple"   , all_soils_on                       , nil,           80,     0.002000,  nil                                                                                                              ,      highland_max,    beach_max, "animals:sneachan_eggs"           , nil          , nil,         nil                  , "all_floors"                    ,      nil, nil,   nil, },

}

----Register----
for i in ipairs(decoration_list) do
	minetest.register_decoration(
		{
			name           = decoration_list[i][01],
			deco_type      = decoration_list[i][02],
			place_on       = decoration_list[i][03],
			place_offset_y = decoration_list[i][04],
			sidelen        = decoration_list[i][05],
			fill_ratio     = decoration_list[i][06],
			noise_params   = decoration_list[i][07],
			y_max          = decoration_list[i][08],
			y_min          = decoration_list[i][09],
			decoration     = decoration_list[i][10],
			spawn_by       = decoration_list[i][11],
			num_spawn_by   = decoration_list[i][12],
			schematic      = decoration_list[i][13],
			flags          = decoration_list[i][14],
			rotation       = decoration_list[i][15],
			param2         = decoration_list[i][16],
			param2_max     = decoration_list[i][17],
		}
	)
end


---- Start node timers ----
local egg_names = {  -- list of strings
	"gundu_eggs",
	"sarkamos_eggs",
	"impethu_eggs",
	"kubwakubwa_eggs",
  "kubwakubwa_eggs_forest",
	"darkasthaan_eggs",
	"pegasun_eggs",
	"sneachan_eggs",
	}

local eggs_nearby = {}  -- list of decoration IDs
for i in ipairs(egg_names) do -- get decoration IDs
	table.insert(eggs_nearby, minetest.get_decoration_id("animals:"..egg_names[i])) -- add the current egg found
	end
minetest.set_gen_notify({decoration = true}, eggs_nearby)
minetest.register_on_generated(
	function(minp, maxp, blockseed) -- start node timers
		local gennotify = minetest.get_mapgen_object("gennotify")
		local poslist = {}
		for i in ipairs(egg_names) do -- iterate across the list of strings
			for j, pos in ipairs(gennotify["decoration#"..eggs_nearby[i]] or {}) do -- iterate across the
				local eggs_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
				table.insert(poslist, eggs_pos) -- append this position to the list
				end
			end
		if #poslist ~= 0 then
			for i = 1, #poslist do
				local pos = poslist[i] -- grab this position from the list
				minetest.get_node_timer(pos):start(1) -- start the node timer for this egg
				end
			end
		end
	)
