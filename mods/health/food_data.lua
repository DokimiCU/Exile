--food_data.lua
--
--Contains data for all the predefined foods in Exile

--[[
Some notes:

Calculating sensible values for food:
(intervals/day) * hunger_rate = daily basal food needs
i.e. 20min/1min * 2 = 40 units per day

Therefore 40 units = 2000 calories.
calories -> units = 2000/40 = 50 cal/unit

Sugar 3900 cal/kg = 78 units/kg  172 per lb.
Bread 2600 cal/kg = 52 units/kg  115 per lb.
Potato. 750 cal/kg = 15 u/kg     33 per lb.
Meat 2000 cal/kg = 40 u/kg       88 per lb.
cabbage 240 cal/kg = 4.8 u/kg    10.5 per lb.
]]--

food_table = {
   --name	     	      	       hp      thr    hngr   energy  temp, replacewithitem (not implemented yet)
["tech:maraka_bread_cooked"]        = {0,      0,    24,     14,     0},
["tech:maraka_bread_burned"]        = {0,      0,    12,      7,     0},
["tech:peeled_anperla_cooked"]      = {0,      4,    24,     14,     0},
--example: burned anperla tubers are inedible, so no entry
["tech:mashed_anperla_cooked"]      = {0,     24,   144,    84,     0},
["tech:mashed_anperla_burned"]      = {0,     12,    72,    42,     0},
["nodes_nature:sea_lettuce"]        = {0,      0,     5,   -10,     0},
["nodes_nature:sea_lettuce_cooked"] = {0,      0,     5,     0,     0},
["nodes_nature:vansano_seed"]       = {0,      0,     1,     0,     0},
["nodes_nature:tikusati_seed"]      = {0,      0,    -2,     2,     0},
--                                    hp,th,hu,en,te
--food and water
["nodes_nature:wiha"]               = { 0,3,1,0,0 },
["nodes_nature:zufani"]             = { 0,0,4,0,0 },
["nodes_nature:galanta"]            = { 0,1,3,0,0 },
["nodes_nature:lambakap"]           = { 0,10,10,0,0},
["nodes_nature:tangkal_fruit"]      = { 0,5,10,10,0},
--drugs
["nodes_nature:tikusati"]           = { 0,0,-2,2,0 },
--toxic
["nodes_nature:nebiyi"]             = { 0,0,0,0,0 },
["nodes_nature:marbhan"]            = { 0, 0, 0, 0, 0 },
--maraka nut is dangerous poisonous until processed,
-- causes photosensitivity, risk of hepatotoxicity
--you can eat it raw if you want to take the risk... famine food for the despera
["nodes_nature:maraka_nut"]         = { 0, 0, 5, 5, 0 },
--medicine
["nodes_nature:hakimi"]             = { 0,0,0,0,0 },
["nodes_nature:merki"]              = { 0,0,0,0,0 },
}

bake_table = {
   --name                        temp, duration, optional food value?
["tech:maraka_bread"]        = { 160,  10 },
["tech:peeled_anperla"]      = { 100,  7  },
["tech:mashed_anperla"]      = { 100,  35 },
}

food_harm_table = {
   --name                     { {tag, chance, severity}, {t, c, s}, etc }
["tech:maraka_bread_cooked"]     = { { "Food Poisoning", 0.001, 1} },
["tech:maraka_bread_burned"]     = { { "Food Poisoning", 0.001, 1} },
["tech:peeled_anperla_cooked"]   = { { "Food Poisoning", 0.002, 1} },
["tech:mashed_anperla_cooked"]   = { { "Food Poisoning", 0.002, 1} },
["tech:mashed_anperla_burned"]   = { { "Food Poisoning", 0.002, 1} },
["nodes_nature:sea_lettuce"]     = { { "Food Poisoning", 0.05,  1},
                                     {"Intestinal Parasites", 0.01} },
["nodes_nature:vansano_seed"]    = { { "Food Poisoning", 0.001, 1} },
["nodes_nature:tikusati_seed"]   = { { "Food Poisoning", 0.001, 1} },

["nodes_nature:tikusati"]        = { { "Food Poisoning", 0.001, 1} },
["nodes_nature:nebiyi"]          = { { "Food Poisoning", 0.001, 1} },
["nodes_nature:marbhan"]         = { { "Food Poisoning", 0.001, 1} },
["nodes_nature:hakimi"]          = { { "Food Poisoning", 0.001, 1} },
["nodes_nature:merki"]           = { { "Food Poisoning", 0.001, 1} },
["nodes_nature:wiha"]            = { { "Food Poisoning", 0.005, 1} },
["nodes_nature:zufani"]          = { { "Food Poisoning", 0.010, 1} },
["nodes_nature:galanta"]         = { { "Food Poisoning", 0.008, 1} },
["nodes_nature:maraka_nut"]      = { { "Food Poisoning", 0.001, 1},
			           { "Hepatotoxicity", 0.005, math.floor(math.random(1,4)) },
			           {"Photosensitivity", 0.3, 1} },
["nodes_nature:tangkal_fruit"]   = { { "Food Poisoning", 0.001, 1},
                                   { "Drunk", 0.005, 1} }
}
