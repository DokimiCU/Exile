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
   --name	     	      	       hp  thr hngr energy temp
["tech:maraka_bread_cooked"]        = {0,  0,  24,  14,    0},
["tech:maraka_bread_burned"]        = {0,  0,  12,  7,     0},
["tech:peeled_anperla_cooked"]      = {0,  4,  24,  14,    0},
--example: burned anperla tubers are inedible
["tech:mashed_anperla_cooked"]      = {0,  24, 144, 84,    0},
["tech:mashed_anperla_burned"]      = {0,  12, 72,  42,    0},
}

bake_table = {
   --name                        temp, duration, cooked, burned
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
}
