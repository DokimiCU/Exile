--
ncrafting = {
 base_firing = 25,
 firing_int = 10,
 cook_rate = 6   -- cook timer; tenth of a minute seems fine
}

--
--Pottery firing functions
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

function ncrafting.start_bake(pos, result)
   local meta = minetest.get_meta(pos)
   meta:set_int("baking", result)
   minetest.get_node_timer(pos):start(ncrafting.cook_rate)
end

function ncrafting.do_bake(pos, elapsed, heat, length)
   local selfname = minetest.get_node(pos).name
   selfname = selfname:gsub("_cooked","") -- ensure we have the base name
   local name_cooked = selfname.."_cooked"
   local name_burned = selfname.."_burned"
   local burntime = math.floor( length * .40 + 10 ) * -1
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
      minetest.get_node_timer(pos):start(ncrafting.cook_rate)
      return true
   elseif temp < fire_temp then
      --not lit yet
      return true
   elseif temp > fire_temp * 2  or baking < burntime then
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
