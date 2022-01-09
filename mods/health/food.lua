--food.lua
--handles the intake of food and drink

--Modding info:
--[[
 To add new foods, define a node, then pass a table with its info to
exile_add_food(table). Its on_use will be set automatically.

 For cookable things, define the node, and a name_cooked/name_burned version,
then pass the cooking data to exile_add_bake(table). Its on_construct and
on_timer will be set automatically.  Then add the cooked version to the
food table.
 If the burned version is not also added to foods, it will be inedible.

 If a food can only be cooked in a pot, don't define a name_cooked node,
but add it to the food table anyway. The cooking pot will make a soup using
the food table's data, but the food will not be able to bake in an oven or
over a fire.
#TODO: Test this ^^ after the cooking pot supports both tables
]]--

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

local cook_rate = 6   -- speed of the cook timer; tenth of a minute seems fine

bake_table = {
   --name                        temp, duration, cooked, burned
["tech:maraka_bread"]        = { 160,  10 },
["tech:peeled_anperla"]      = { 100,  7  },
["tech:mashed_anperla"]      = { 100,  35 },
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
      minetest.chat_send_player(user:get_player_name(),
				"This is inedible.")
      return
   end
   local t = food_table[name]
   return HEALTH.use_item(itemstack, user, t[1], t[2], t[3], t[4], t[5], t[6])
end

function exile_add_food(table)
   --Add new foods, mod must send a table in the above format
   for k, v in pairs(table) do
      food_table[k] = v
   end
end
function exile_add_bake(table)
   --Add new bakables, mod must send a table in the above format
   for k, v in pairs(table) do
      bake_table[k] = v
   end
end

-- Table node setup
--Sets the on_construct/on_timer for registered foods

minetest.after(1, function() -- don't run overrides until after registration
   local eat_redef = { on_use = function(itemstack, user, pointed_thing)
			  --TODO: add risk of fpois, parasites, etc
			  return exile_eatdrink(itemstack, user)
		     end}
   local bake_redef = {  on_construct = function(...)
			exile_start_bake(...)
		 end,
		     on_timer = function(...)
			return exile_bake(...)
		 end}
   minetest.log("info", "Finalized list of food_table entries:")
   for k, v in pairs(food_table) do
      if not minetest.registered_nodes[k] then
	 minetest.log("error", "Food table contains an unknown node: "..k)
      else
	 minetest.log("info",k)
	 minetest.override_item(k, eat_redef)
      end
   end
   minetest.log("info","-------")
   minetest.log("info", "Finalized list of bake_table entries:")
   for k, v in pairs(bake_table) do
      if not minetest.registered_nodes[k] then
	 minetest.log("error", "Bake table contains an undefined node: "..k)
      else
	 if minetest.registered_nodes[k.."_cooked"] then
	    minetest.log("info",k)
	    minetest.override_item(k, bake_redef)
	    if minetest.registered_nodes[k.."_burned"] then
	       minetest.override_item(k.."_cooked", bake_redef)
	    end
	 else
	    minetest.log("info", "undefined (cooking pot-only) node: "..
			    k.."_cooked")
	 end
      end
   end
   minetest.log("info","-------")
end)

function exile_start_bake(pos)
   local selfname = minetest.get_node(pos).name
   local meta = minetest.get_meta(pos)
   selfname = selfname:gsub("_cooked","") -- ensure we have the base name
   meta:set_int("baking",bake_table[selfname][2])
   minetest.get_node_timer(pos):start(cook_rate)
end

function exile_bake(pos, elapsed)
   local selfname = minetest.get_node(pos).name
   selfname = selfname:gsub("_cooked","") -- ensure we have the base name
   local name_cooked = selfname.."_cooked"
   local name_burned = selfname.."_burned"
   local heat = bake_table[selfname][1]
   local length = bake_table[selfname][2]
   local meta = minetest.get_meta(pos)
   local baking = meta:get_int("baking")

   --check if wet, stop
   if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
      return true
   end

   --exchange accumulated heat
   climate.heat_transfer(pos, selfname)

   --check if above firing temp
   local temp = climate.get_point_temp(pos)
   local fire_temp = heat
   if temp == nil then
      return
   elseif baking == 0 then
      --finished firing
      minetest.swap_node(pos, {name = name_cooked})
      minetest.check_for_falling(pos) 
      meta:set_int("baking", -1) -- prepare to burn it
      minetest.get_node_timer(pos):start(cook_rate)
      return true
   elseif temp < fire_temp then
      --not lit yet
      return true
   elseif temp > fire_temp * 2  or baking < (length / 2 * -1) then
      if minetest.registered_nodes[name_burned] then
	 --too hot or too long on the fire, burn
	 minetest.set_node(pos, {name = name_burned})
      else
	 minetest.set_node(pos, {name = "air"})
      end
      --Smoke
      minetest.sound_play("tech_fire_small",{pos=pos, max_hear_distance = 10, loop=false, gain=0.1})
      minetest.add_particlespawner({
	    amount = 2,
	    time = 0.5,
	    minpos = {x = pos.x - 0.1, y = pos.y, z = pos.z - 0.1},
	    maxpos = {x = pos.x + 0.1, y = pos.y + 0.5, z = pos.z + 0.1},
	    minvel = {x= 0, y= 0, z= 0},
	    maxvel = {x= 0.01, y= 0.06, z= 0.01},
	    minacc = {x= 0, y= 0, z= 0},
	    maxacc = {x= 0.01, y= 0.1, z= 0.01},
	    minexptime = 3,
	    maxexptime = 10,
	    minsize = 1,
	    maxsize = 4,
	    collisiondetection = true,
	    vertical = true,
	    texture = "tech_smoke.png",
      })
      return false
   elseif temp >= fire_temp then
      --do firing
      meta:set_int("baking", baking - 1)
      return true
   end

end
