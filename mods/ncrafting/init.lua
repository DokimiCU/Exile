--
local modpath = minetest.get_modpath('nodecrafting')

ncrafting = {
 base_firing = 25,
 firing_int = 10,
 cook_rate = 6   -- cook timer; tenth of a minute seems fine
}

dofile(modpath..'/dyes.lua')

local store = minetest.get_mod_storage()

function ncrafting.loadstore(name)
   return minetest.deserialize(store:get_string(name))
end
function ncrafting.savestore(name, table)
   store:set_string(name, minetest.serialize(table))
end
function ncrafting.loadstore64(name)
   local decodeme = minetest.decode_base64(store:get_string(name))
   return minetest.deserialize(decodeme)
end
function ncrafting.savestore64(name, table)
   local encodeme = minetest.serialize(table)
   store:set_string(name, minetest.encode_base64(encodeme))
end

-----------------------------------------------
-- Smoke particles

function ncrafting.particle_smokesmall(pos)
   return {
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
   }
end


-----------------------------------------------
-- Pottery firing functions

function ncrafting.set_firing(pos, length, interval)
	-- and firing count
	local meta = minetest.get_meta(pos)
	meta:set_int("firing", length)
	--check heat interval
	minetest.get_node_timer(pos):start(interval)
end

function ncrafting.fire_pottery(pos, selfname, name, length)
	local meta = minetest.get_meta(pos)
	local firing = meta:get_int("firing")

	--check if wet, falls to bits and thats it for your pot
	if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
		minetest.set_node(pos, {name = 'nodes_nature:clay'})
		return false
	end

	--exchange accumulated heat
	climate.heat_transfer(pos, selfname)

	--check if above firing temp
	local temp = climate.get_point_temp(pos)
	local fire_temp = 600

	if firing <= 0 then
		--finished firing
		minetest.set_node(pos, {name = name})
		return false
	elseif temp < fire_temp then
		if firing < length and temp < fire_temp/2 then
			--firing began but is now interupted
			--causes firing to fail
			minetest.set_node(pos, {name = "tech:broken_pottery"})
			return false
		else
			--no fire lit yet
			return true
		end
	elseif temp >= fire_temp then
		--do firing
		meta:set_int("firing", firing - 1)
		return true
	end

end


-----------------------------------------------
-- Baking functions

function ncrafting.start_bake(pos, result)
   local meta = minetest.get_meta(pos)
   meta:set_int("baking", result)
   minetest.get_node_timer(pos):start(ncrafting.cook_rate)
end

function ncrafting.do_bake(pos, elapsed, heat, length, cookname, burnname)
   local selfname = minetest.get_node(pos).name
   selfname = selfname:gsub("_cooked","") -- ensure we have the base name
   local name_cooked = cookname or selfname.."_cooked"
   local name_burned = burnname or selfname.."_burned"
   local burntime = math.floor( length * .40 + 10 ) * -1
   local meta = minetest.get_meta(pos)
   local baking = meta:get_int("baking")

   --check if wet, wait until dry
   if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
      return true
   end

   --exchange accumulated heat
   climate.heat_transfer(pos, selfname)

   --check if above firing temp
   local temp = climate.get_point_temp(pos)
   local fire_temp = heat
   if temp == nil then
      return true
   elseif baking == 0 then
      --finished firing
      minetest.swap_node(pos, {name = name_cooked})
      ncrafting.set_treatment(meta, "cook")
      minetest.check_for_falling(pos)
      meta:set_int("baking", -1) -- prepare to burn it
      minetest.get_node_timer(pos):start(ncrafting.cook_rate)
      return true
   elseif temp < fire_temp then
      --not lit yet
      return true
   elseif temp > fire_temp * 2  or baking < burntime then
      if minetest.registered_nodes[name_burned] then
	 --too hot or too long on the fire, burn
	 minetest.swap_node(pos, {name = name_burned})
	 ncrafting.set_treatment(meta, "burn")
      else
	 minetest.set_node(pos, {name = "air"})
      end
      --Smoke
      minetest.sound_play("tech_fire_small",{pos=pos, max_hear_distance = 10, loop=false, gain=0.1})
      minetest.add_particlespawner(ncrafting.particle_smokesmall(pos))
      return false
   elseif temp >= fire_temp then -- do baking
      meta:set_int("baking", baking - 1)
      return true
   end
end


-----------------------------------------------
-- Soaking/Retting functions

function ncrafting.start_soak(pos, length, interval)
   local meta = minetest.get_meta(pos)
   meta:set_int("soaking", length)
   minetest.get_node_timer(pos):start(interval)
end

function ncrafting.do_soak(pos, name, length)
   local meta = minetest.get_meta(pos)
   local soaking = meta:get_int("soaking")

   --check if wet,
   local node_a = minetest.get_node({x=pos.x, y=pos.y + 1, z=pos.z})
   if minetest.get_item_group(node_a.name, "water") > 0 then
      if soaking <= 0 then
	 --finished
	 minetest.swap_node(pos, {name = name})
	 ncrafting.set_treatment(meta, "soak")
	 return false
      else
	 --do soaking
	 meta:set_int("soaking", soaking - 1)
	 return true
      end
   else
      --no water
      return true
   end
end
