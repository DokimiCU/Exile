--[[ Register Biomes ]]--
--[[ Local Variables ]]--
	--- Manage Testing of New Biomes
		local enable_experimentals = false
		local stable_biomes        = 17
	--- Range Limits
		local upper_limit          =  31000
		local lower_limit          = -31000
	--- Promontory Altitudes
		local mountain_min         =    170
		local alpine_min           =    140
		local highland_min         =    100
		local upland_min           =     90
		local lowland_max          =      9
	--- Marine Altitudes
		local beach_max            =      5
		local beach_min            =    -10
		local shallow_ocean_min    =    -30
		local deep_ocean_min       =   -120
	--- Climate Ranges
		local extreme_high         =     95
		local high                 =     75
		local middle               =     50
		local low                  =     25
		local extreme_low          =      5
	--- Nodes
		local air       = "air"
		local alpine    = "nodes_nature:highland_soil"
		local basalt    = "nodes_nature:basalt"
		local brick_gr  = "nodes_nature:granite_brick"
		local brick_ls  = "nodes_nature:limestone_brick"
		local clay      = "nodes_nature:clay"
		local clay_wet  = "nodes_nature:clay_wet"
		local drystack  = "tech:drystack"
		local duff      = "nodes_nature:woodland_soil"
		local duff_dry  = "nodes_nature:woodland_dry_soil"
		local duff_wet  = "nodes_nature:woodland_soil_wet"
		local dune      = "nodes_nature:duneland_soil"
		local gneiss    = "nodes_nature:gneiss"
		local granite   = "nodes_nature:granite"
		local grass_bar = "nodes_nature:grassland_barren_soil"
		local grass_wet = "nodes_nature:grassland_soil_wet"
		local gravel    = "nodes_nature:gravel"
		local gravel_w  = "nodes_nature:gravel_wet"
		local gravel_ws = "nodes_nature:gravel_wet_salty"
		local ice       = "nodes_nature:ice"
		local lava      = "nodes_nature:lava_source"
		local limestone = "nodes_nature:limestone"
		local loam      = "nodes_nature:loam"
		local marsh_wet = "nodes_nature:marshland_soil_wet"
		local potable   = "nodes_nature:freshwater_source"
		local prairie   = "nodes_nature:grassland_soil"
		local sand      = "nodes_nature:sand"
		local sand_wet  = "nodes_nature:sand_wet"
		local sand_ws   = "nodes_nature:sand_wet_salty"
		local silt      = "nodes_nature:silt"
		local silt_wet  = "nodes_nature:silt_wet"
		local silt_ws   = "nodes_nature:silt_wet_salty"
		local snow      = "nodes_nature:snow"
		local snow_b    = "nodes_nature:snow_block"
		local stair_ds  = "stairs:stair_drystack"
		local stair_gr  = "stairs:stair_granite_block"
		local stair_ls  = "stairs:stair_limestone_block"
--[[ Biome Descriptions ]]--[[
	01.	Grassland: clay, open, yellow
	02.	Upland Grassland
	03.	Marshland: silt, dense reeds, red
	04.	Highland: gravel, dense grasses, purple
	05.	Duneland: sand, barren, orange
	06.	Woodland: loam, trees, green
	07.	Mountain Snowcaps: frozen places up high
	08.	Coasts and Oceans: Silty Beach
	09.	Lower Silty Beach
	10.	Sandy Beach
	11.	Lower Sandy Beach
	12.	Gravel Beach
	13.	Lower Gravel Beach
	14.	Shallow Ocean
	15.	Deep Ocean
	16.	Underground
	17.	Deep Underground
	18.	Dry Grassland: clay, open, yellow, drier version of standard grassland
	19.	Wet Grassland: Wet version of standard grassland
	20.	Barren Grassland: pale colours
	21.	Upland Dry Grassland
	22.	Upland Barren Grassland
	23.	Barrenland: gravel, lifeless
	24.	Lavaland: cooled basalt and lava flows, totally lifeless
	25.	Hardpan Marshland: thin silt, dense reeds, red, clay layer underneath
	26.	Wet Woodland: loam, trees, green, over a layer of wet clay
	27.	Dry Woodland: arid forest
	28. Upland Woodland Dry
	29.	Highland Scree: gravel, unstable loose gravel fields
	30. Wet Highland Scree
	31.	Dry Highland: no snow version
	32.	Dry Nountain: bare rock, no snow
  ]]
-- 16. `underground` biome used to have basalt dungeon
-- 22. `upland_grassland_barren` remains disabled
-- 29. `highland_scree` and 30. `wet_highland_scree` had optional snow dusting

--[[Define Biomes Table]]--
local biome_list = {
	--                                                                                               node   depth  node                 depth                                                                                                                            
	--                                      node   node       depth  node        depth   node        water  water  river    node        river  cave        node       dungeon    vert                                           heat                humidity             
	--          name                        dust   top        top    filler      filler  stone       top    top    water    riverbed    bed    liquid      dungeon    stair      blend  y_max               y_min               point               point                
	--[[01]]  { "grassland"              ,   nil,  prairie  ,    1,  clay     ,     2,   limestone,   nil,   nil,  air   ,  duff_wet ,    1,   {potable},  drystack,  stair_ds,    5,   upland_min       ,  beach_max        ,  middle           ,  middle          ,  },
	--[[02]]  { "upland_grassland"       ,  snow,  prairie  ,    1,  clay     ,     2,   limestone,   nil,   nil,  air   ,  grass_wet,    1,   {potable},  drystack,  stair_ds,    5,   highland_min     ,  upland_min       ,  middle           ,  middle          ,  },
	--[[03]]  { "marshland"              ,   nil,  marsh_wet,    1,  silt_wet ,     6,   limestone,   nil,   nil,  air   ,  silt_wet ,    5,   {potable},  drystack,  stair_ds,    2,   lowland_max      ,  beach_max        ,  high             ,  extreme_high    ,  },
	--[[04]]  { "highland"               ,  snow,  alpine   ,    1,  gravel   ,     1,   limestone,   nil,   nil,  snow_b,  gravel_w ,    3,   {potable},  drystack,  stair_ds,    5,   mountain_min     ,  highland_min     ,  low + 10         ,  high - 10       ,  },
	--[[05]]  { "duneland"               ,   nil,  dune     ,    1,  sand     ,     5,   limestone,   nil,   nil,  air   ,  grass_wet,    1,   {potable},  drystack,  stair_ds,    2,   lowland_max + 10 ,  beach_max        ,  middle           ,  extreme_low     ,  },
	--[[06]]  { "woodland"               ,   nil,  duff     ,    1,  loam     ,     3,   limestone,   nil,   nil,  air   ,  marsh_wet,    1,   {potable},  drystack,  stair_ds,    2,   lowland_max + 20 ,  beach_max        ,  low              ,  high            ,  },
	--[[07]]  { "snowcap"                ,  snow,  snow_b   ,    2,  gravel   ,     2,   limestone,   ice,     2,  ice   ,  gravel   ,    2,   {potable},  drystack,  stair_ds,    5,   upper_limit      ,  mountain_min     ,  low              ,  high            ,  },
	--[[08]]  { "silty_beach"            ,   nil,  silt     ,    1,  silt_ws  ,     2,   limestone,   nil,   nil,  air   ,  silt_wet ,    4,   {potable},  brick_ls,  stair_ls,    1,   beach_max        ,  1                ,  middle           ,  high            ,  },
	--[[09]]  { "silty_beach_lower"      ,   nil,  silt_ws  ,    1,  silt_ws  ,     2,   limestone,   nil,   nil,  air   ,  silt_wet ,    4,   {potable},  brick_ls,  stair_ls,    1,   2                ,  beach_min        ,  middle           ,  high            ,  },
	--[[10]]  { "sandy_beach"            ,   nil,  sand     ,    1,  sand_ws  ,     2,   limestone,   nil,   nil,  air   ,  sand_wet ,    4,   {potable},  brick_ls,  stair_ls,    1,   beach_max        ,  1                ,  middle           ,  middle          ,  },
	--[[11]]  { "sandy_beach_lower"      ,   nil,  sand_ws  ,    1,  sand_ws  ,     2,   limestone,   nil,   nil,  air   ,  sand_wet ,    4,   {potable},  brick_ls,  stair_ls,    1,   2                ,  beach_min        ,  middle           ,  middle          ,  },
	--[[12]]  { "gravel_beach"           ,   nil,  gravel   ,    1,  gravel_ws,     2,   limestone,   nil,   nil,  air   ,  gravel_w ,    4,   {potable},  brick_ls,  stair_ls,    1,   beach_max        ,  1                ,  extreme_low      ,  middle          ,  },
	--[[13]]  { "gravel_beach_lower"     ,   nil,  gravel_ws,    1,  gravel_ws,     2,   limestone,   nil,   nil,  air   ,  gravel_w ,    4,   {potable},  brick_ls,  stair_ls,    1,   2                ,  beach_min        ,  extreme_low      ,  middle          ,  },
	--[[14]]  { "shallow_ocean"          ,   nil,  sand_ws  ,    1,  sand_ws  ,     3,   limestone,   nil,   nil,  air   ,  sand_ws  ,    2,   {potable},  brick_ls,  stair_ls,    1,   beach_min        ,  shallow_ocean_min,  middle           ,  middle          ,  },
	--[[15]]  { "deep_ocean"             ,   nil,  silt_ws  ,    1,  silt_ws  ,     3,   granite  ,   nil,   nil,  air   ,  sand_ws  ,    2,   {potable},  brick_gr,  stair_gr,   10,   shallow_ocean_min,  deep_ocean_min   ,  middle           ,  middle          ,  },
	--[[16]]  { "underground"            ,   nil,  nil      ,  nil,  nil      ,   nil,   granite  ,   nil,   nil,  nil   ,  nil      ,  nil,   {potable},  brick_gr,  stair_gr,   20,   deep_ocean_min   ,  -1500            ,  middle           ,  middle          ,  },
	--[[17]]  { "deep_underground"       ,   nil,  nil      ,  nil,  nil      ,   nil,   gneiss   ,   nil,   nil,  nil   ,  nil      ,  nil,   {lava   },  nil     ,  nil     ,  100,   -1500            ,  lower_limit      ,  middle           ,  middle          ,  },
	--[[18]]  { "grassland_dry"          ,   nil,  prairie  ,    1,  sand     ,     1,   limestone,   nil,   nil,  air   ,  prairie  ,    1,   {potable},  nil     ,  nil     ,    5,   upland_min       ,  beach_max        ,  extreme_high     ,  low             ,  },
	--[[19]]  { "grassland_wet"          ,   nil,  prairie  ,    1,  clay_wet ,     2,   limestone,   nil,   nil,  air   ,  marsh_wet,    1,   {potable},  nil     ,  nil     ,    5,   upland_min / 2   ,  beach_max        ,  high             ,  extreme_high    ,  },
	--[[20]]  { "grassland_barren"       ,   nil,  grass_bar,    1,  gravel   ,     2,   limestone,   nil,   nil,  air   ,  duff_dry ,    1,   {potable},  nil     ,  nil     ,    5,   upland_min       ,  beach_max        ,  low - 10         ,  low             ,  },
	--[[21]]  { "upland_grassland_dry"   ,   nil,  grass_bar,    1,  gravel   ,     1,   limestone,   nil,   nil,  air   ,  prairie  ,    1,   {potable},  nil     ,  nil     ,   10,   highland_min     ,  upland_min       ,  extreme_high     ,  low             ,  },
	--[[22]]--{ "upland_grassland_barren",  snow,  grass_bar,    1,  gravel   ,     1,   limestone,   nil,   nil,  snow_b,  gravel_w ,    1,   {potable},  nil     ,  nil     ,    5,   highland_min     ,  upland_min       ,  low - 10         ,  low             ,  },
	--[[23]]  { "barrenland"             ,   nil,  sand     ,    1,  gravel   ,     1,   limestone,   nil,   nil,  air   ,  silt     ,    3,   {potable},  nil     ,  nil     ,   10,   upland_min / 2   ,  beach_max        ,  extreme_low      ,  extreme_low     ,  },
	--[[24]]  { "lavaland"               ,   nil,  basalt   ,    1,  basalt   ,     1,   basalt   ,   nil,   nil,  basalt,  lava     ,    3,   {lava   },  nil     ,  nil     ,   10,   upland_min / 2   ,  0                ,  extreme_high + 10,  extreme_low - 20,  },
	--[[25]]  { "hardpan_marshland"      ,   nil,  marsh_wet,    1,  clay_wet ,     2,   limestone,   nil,   nil,  air   ,  marsh_wet,    1,   {potable},  nil     ,  nil     ,    2,   lowland_max      ,  beach_max        ,  low              ,  extreme_high    ,  },
	--[[26]]  { "woodland_wet"           ,   nil,  duff     ,    1,  clay_wet ,     2,   limestone,   nil,   nil,  air   ,  marsh_wet,    1,   {potable},  nil     ,  nil     ,    2,   lowland_max + 20 ,  beach_max        ,  low              ,  extreme_high    ,  },
	--[[27]]  { "woodland_dry"           ,   nil,  duff_dry ,    1,  silt     ,     2,   limestone,   nil,   nil,  air   ,  grass_wet,    1,   {potable},  nil     ,  nil     ,    2,   upland_min       ,  beach_max        ,  low - 10         ,  middle - 10     ,  },
	--[[28]]  { "upland_woodland_dry"    ,  snow,  duff_dry ,    1,  silt     ,     1,   limestone,   nil,   nil,  snow_b,  gravel_w ,    2,   nil      ,  nil     ,  nil     ,    6,   highland_min     ,  upland_min       ,  low - 10         ,  middle - 10     ,  },
	--[[29]]  { "dry_highland_scree"     ,   nil,  gravel   ,    1,  silt     ,     1,   limestone,   nil,   nil,  air   ,  silt     ,    2,   nil      ,  nil     ,  nil     ,   15,   mountain_min     ,  upland_min       ,  extreme_low      ,  low             ,  },
	--[[30]]  { "wet_highland_scree"     ,   nil,  gravel   ,    1,  silt     ,     1,   limestone,   nil,   nil,  snow_b,  silt_wet ,    2,   nil      ,  nil     ,  nil     ,   15,   mountain_min     ,  upland_min       ,  extreme_high     ,  high            ,  },
	--[[31]]  { "dry_highland"           ,   nil,  alpine   ,    1,  gravel   ,     1,   limestone,   nil,   nil,  air   ,  gravel_w ,    3,   nil      ,  nil     ,  nil     ,    5,   mountain_min     ,  highland_min     ,  extreme_high     ,  extreme_low     ,  },
	--[[32]]  { "dry_mountain"           ,   nil,  nil      ,  nil,  gravel   ,     2,   limestone,   nil,   nil,  air   ,  gravel   ,    2,   {potable},  nil     ,  nil     ,   10,   upper_limit      ,  mountain_min     ,  low - 10         ,  extreme_low     ,  },
	}

--Get experimental biome settings
--"use_exile_v4_biomes" is world-specific; it uses a separate name from
--the global UI setting "exile_v4_biomes" to any avoid possible conflicts
local biomes_enable = minetest.get_mapgen_setting("use_exile_v4_biomes")
local wp = minetest.get_worldpath()
if io.open(wp.."/env_meta.txt", "r") == nil then
   -- This is a hack to see if it's a new world; if so, apply global setting
   biomes_enable = minetest.settings:get_bool("exile_v4_biomes", false)
   minetest.set_mapgen_setting("use_exile_v4_biomes",
			       tostring(biomes_enable))
elseif biomes_enable == nil then -- pre-existing world, but with no setting?
   biomes_enable = false         -- set the default, then
   minetest.set_mapgen_setting("use_exile_v4_biomes", "false", true)
else                           -- get_mapgen_settings gives us a string, so:
   biomes_enable = biomes_enable == "true" -- convert it to a boolean
 end
if biomes_enable == true then
   minetest.log("action","Exile v4 experimental biomes enabled")
   enable_experimentals = true
elseif biomes_enable == false then
   minetest.log("action","Exile v4 experimental biomes disabled")
else
   minetest.log("action","v4 biomes setting is invalid!")
end

--[[Loop to Iterate for Registrations]]--
for i in pairs(biome_list) do
   if (enable_experimentals == false) and (i > stable_biomes) then
      break -- End the loop if further biomes are disabled as experimental.
   end
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
	 node_dungeon       = biome_list[i][14],
	 node_dungeon_stair = biome_list[i][15],
	 vertical_blend     = biome_list[i][16],
	 y_max              = biome_list[i][17],
	 y_min              = biome_list[i][18],
	 heat_point         = biome_list[i][19],
	 humidity_point     = biome_list[i][20],
   })
end
