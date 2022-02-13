
--food_data.lua
--Contains data for all the predefined foods in Exile.
--[[Some notes:
	Calculating sensible values for food:
	(intervals/day) * hunger_rate = daily basal food needs
	i.e. 20 min/1 min * 2 = 40 units per day

	Therefore 40 units = 2,000 Calories.
	 calories -> units = 2,000/40 = 50 kcal/unit

	Sugar   3,900 kcal/kg = 78.0 units/kg  172.0 per lb.
	Bread   2,600 kcal/kg = 52.0 units/kg  115.0 per lb.
	Potato    750 kcal/kg = 15.0 units/kg   33.0 per lb.
	Meat    2,000 kcal/kg = 40.0 units/kg   88.0 per lb.
	cabbage   240 kcal/kg =  4.8 units/kg   10.5 per lb.
	]]--

food_table = {
	--name	     	      	               hp  th  hu   en  temp, replacewithitem (not implemented yet)
	["tech:maraka_bread_cooked"]        = { 0,  0,  24, 14,  0 },
	["tech:maraka_bread_burned"]        = { 0,  0,  12,  7,  0 },
	["tech:peeled_anperla_cooked"]      = { 0,  4,  24, 14,  0 },
	--example: burned anperla tubers are inedible, so no entry
	["tech:mashed_anperla_cooked"]      = { 0, 24, 144, 84,  0 },
	["tech:mashed_anperla_burned"]      = { 0, 12,  72, 42,  0 },
	["nodes_nature:sea_lettuce"]        = { 0,  0,   5,-10,  0 },
	["nodes_nature:sea_lettuce_cooked"] = { 0,  0,   5,  0,  0 },
	["nodes_nature:vansano_seed"]       = { 0,  0,   1,  0,  0 },
	["nodes_nature:tikusati_seed"]      = { 0,  0,  -2,  2,  0 },
	--food and water                       hp  th   hu  en  te
	["nodes_nature:wiha"]               = { 0,  3,   1,  0,  0 },
	["nodes_nature:zufani"]             = { 0,  0,   4,  0,  0 },
	["nodes_nature:galanta"]            = { 0,  1,   3,  0,  0 },
	["nodes_nature:lambakap"]           = { 0, 10,  10,  0,  0 },
	["nodes_nature:tangkal_fruit"]      = { 0,  5,  10, 10,  0 },
	["nodes_nature:momo"]               = { 0,  1,  12,  0,  0 },
	--meat
     ["animals:carcass_invert_small"]       = { 0,  0,   2, -2,  0 },
     ["animals:carcass_invert_small_cooked"]= { 0,  0,   4,  1,  0 },
     ["animals:carcass_invert_small_burned"]= { 0, -1,   1, -3,  0 },
     ["animals:carcass_invert_large"]       = { 0,  1,   6, -6,  0 },
     ["animals:carcass_invert_large_cooked"]= { 0,  1,  12,  3,  0 },
     ["animals:carcass_invert_large_burned"]= { 0, -1,   2, -7,  0 },
     ["animals:carcass_bird_small"]         = { 0,  1 , 10, -4,  0 },
     ["animals:carcass_bird_small_cooked"]  = { 0,  1,  20,  2,  0 },
     ["animals:carcass_bird_small_burned"]  = { 0, -1,   3, -5,  0 },
     ["animals:carcass_fish_small"]         = { 0,  1,  10, -4,  0 },
     ["animals:carcass_fish_small_cooked"]  = { 0,  2,  20,  2,  0 },
     ["animals:carcass_fish_small_burned"]  = { 0, -1,   3, -5,  0 },
     ["animals:carcass_fish_large"]         = { 0,  3,  30,-12,  0 },
     ["animals:carcass_fish_large_cooked"]  = { 0,  3,  60,  6,  0 },
     ["animals:carcass_fish_large_burned"]  = { 0, -1,   8,-13,  0 },
	--eggs
	["animals:darkasthaan_eggs"]        = { 0,  1,  10,  0,  0 },
	["animals:gundu_eggs"]              = { 0, 10,  40,  0,  0 },
	["animals:impethu_eggs"]            = { 0,  0,   4,  0,  0 },
	["animals:kubwakubwa_eggs"]         = { 0,  0,   6,  0,  0 },
	["animals:pegasun_eggs"]            = { 0,  0,  10,  0,  0 },
	["animals:sarkamos_eggs"]           = { 0, 10,  40,  0,  0 },
	["animals:sneachan_eggs"]           = { 0,  0,   3,  0,  0 },
	--drugs
	["nodes_nature:tikusati"]           = { 0,  0,  -2,  2,  0 },
	--toxic
	["nodes_nature:nebiyi"]             = { 0,  0,   0,  0,  0 },
	["nodes_nature:marbhan"]            = { 0,  0,   0,  0,  0 },
	-- Maraka nut is dangerous poisonous until processed,
	-- causes photosensitivity, and risk of hepatotoxicity.
	-- You can eat it raw if you want to take the risk... famine food for the desperate.
	["nodes_nature:maraka_nut"]         = { 0,  0,   5,  5,  0 },
	--medicine
	["nodes_nature:hakimi"]             = { 0,  0,   0,  0,  0 },
	["nodes_nature:merki"]              = { 0,  0,   0,  0,  0 },
	}

bake_table = {
	--name                          temp, duration, optional food value?
   ["tech:maraka_bread"]              = { 160,  10 },
   ["tech:peeled_anperla"]            = { 100,   7 },
   ["tech:mashed_anperla"]            = { 100,  35 },
   ["animals:carcass_invert_small"]   = { 100,   1 },
   ["animals:carcass_invert_large"]   = { 100,   3 },
   ["animals:carcass_bird_small"]     = { 100,   6 },
   ["animals:carcass_fish_small"]     = { 100,   6 },
   ["animals:carcass_fish_large"]     = { 100,  18 },
}

food_harm_table = {
	--name                     { {tag, chance, severity}, {t, c, s}, etc }
	["tech:maraka_bread_cooked"]     = { { "Food Poisoning",      0.001, 1} },
	["tech:maraka_bread_burned"]     = { { "Food Poisoning",      0.001, 1} },
	["tech:peeled_anperla_cooked"]   = { { "Food Poisoning",      0.002, 1} },

	["tech:mashed_anperla_cooked"]   = { { "Food Poisoning",      0.002, 1} },
	["tech:mashed_anperla_burned"]   = { { "Food Poisoning",      0.002, 1} },
	["nodes_nature:sea_lettuce"]     = { { "Food Poisoning",      0.050, 1},
	                                     {"Intestinal Parasites", 0.010   } },
	["nodes_nature:vansano_seed"]    = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:tikusati_seed"]   = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:tikusati"]        = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:nebiyi"]          = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:marbhan"]         = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:hakimi"]          = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:merki"]           = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:wiha"]            = { { "Food Poisoning",      0.005, 1} },
	["nodes_nature:zufani"]          = { { "Food Poisoning",      0.010, 1} },
	["nodes_nature:galanta"]         = { { "Food Poisoning",      0.008, 1} },
	["nodes_nature:momo"]            = { { "Food Poisoning",      0.001, 1} },
	["nodes_nature:maraka_nut"]      = { { "Food Poisoning",      0.001, 1},
	                                     { "Hepatotoxicity",      0.005, math.floor(math.random(1,4)) },
	                                     { "Photosensitivity",    0.300, 1} },
	--Tangkal Fruit is good food, but bulky, contains small amounts of alcohol.
	["nodes_nature:tangkal_fruit"]   = { { "Food Poisoning",      0.001, 1},
	                                     { "Drunk",               0.005, 1} },
	--meat
	["animals:carcass_invert_small"] = { { "Food Poisoning",      0.1,   1},
	                                     { "Intestinal Parasites",0.01,  1} },
	["animals:carcass_invert_large"] = { { "Food Poisoning",      0.2,   1},
	                                     { "Intestinal Parasites",0.02,  1} },
	["animals:carcass_bird_small"]   = { { "Food Poisoning",      0.05,  1},
	                                     { "Intestinal Parasites",0.02,  1} },
	["animals:carcass_fish_small"]   = { { "Food Poisoning",      0.05,  1},
	                                     { "Intestinal Parasites",0.02,  1} },
	["animals:carcass_fish_large"]   = { { "Food Poisoning",      0.1,   1},
	                                     { "Intestinal Parasites",0.04,  1} },
	--eggs
	["animals:darkasthaan_eggs"]     = { { "Food Poisoning",      0.1,
					       math.floor(math.random(1,4))},
	                                     { "Intestinal Parasites",0.01, 1} },
	["animals:gundu_eggs"]           = { { "Food Poisoning",      0.05,
					       math.floor(math.random(1,4))},
	                                     { "Intestinal Parasites",0.1,  1} },
	["animals:impethu_eggs"]         = { { "Food Poisoning",      0.1,
					       math.floor(math.random(1,4))},
	                                     { "Intestinal Parasites",0.1,  1} },
	["animals:kubwakubwa_eggs"]      = { { "Food Poisoning",      0.1,
					       math.floor(math.random(1,4))},
	                                     { "Intestinal Parasites",0.01, 1} },
	["animals:pegasun_eggs"]         = { { "Food Poisoning",      0.02,
					       math.floor(math.random(1,2))},
	                                     { "Intestinal Parasites",0.005, 1} },
	["animals:sarkamos_eggs"]       = { { "Food Poisoning",      0.3,
					       math.floor(math.random(1,4))},
	                                     { "Intestinal Parasites",0.05, 1} },
	["animals:sneachan_eggs"]       = { { "Food Poisoning",      0.5,
					       math.floor(math.random(1,4))},
	                                     { "Intestinal Parasites",0.5, 1} },
	}
