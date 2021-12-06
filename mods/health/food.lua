--food.lua
--handles the intake of food and drink

--[[
Some notes:

Calculating sensible values for food:
(intervals/day) * hunger_rate = daily basal food needs
i.e. 20min/1min * 2 = 40 units per day

Therefore 40 units = 2000 calories.
calories -> units = 2000/40 = 50 cal/unit

Sugar 3900 cal/kg = 78 units/kg
Bread 2600 cal/kg = 52 units/kg
Potato. 750 cal/kg = 15 u/kg
Meat 2000 cal/kg = 40 u/kg
cabbage 240 cal/kg = 4.8 u/kg
]]--

food_table = {
   --name	     	      	       hp  thr hngr energy temp replaceitem
["tech:maraka_cake"]                = {0,  0,  24,  14,    0},
["tech:maraka_cake_burned"]         = {0,  0,  12,  7,     0},
["tech:anperla_tuber_cooked"]       = {0,  4,  24,  14,    0},
["tech:mashed_anperla_cooked"]      = {0,  24, 144, 84,    0},
["tech:mashed_anperla_burned"]      = {0,  12, 72,  42,    0},

}

function exile_eatdrink_playermade(itemstack, user)
   local imeta = itemstack:get_meta()
   local pname = user:get_player_name()
   local t = minetest.deserialize(imeta:get_string("eat_value"))
   if t == nil then minetest.log("warning", pname..
				    " ate an invalid food of type "..
				    itemstack:get_name())
      return
   end
   return HEALTH.use_item(itemstack, user, t[1], t[2], t[3], t[4], t[5], t[6])
end

function exile_eatdrink(itemstack, user)
   local name = itemstack:get_name()
   if not food_table[name] then
      minetest.log("error","Oh noes! Could not find ",name," in food table!")
      return
   end
   local t = food_table[name]
   return HEALTH.use_item(itemstack, user, t[1], t[2], t[3], t[4], t[5], t[6])
end
