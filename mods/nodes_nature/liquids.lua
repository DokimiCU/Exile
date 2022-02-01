---------------------------------------------------------
--LIQUIDS
--
local ran = math.random



--Water
local list = {
	{"salt_water", "Salt Water", 2, 230, 140, true},
	{"freshwater", "Freshwater", 1, 180, 100, false},

}


for i in ipairs(list) do
	local name = list[i][1]
	local desc = list[i][2]
	local water_g = list[i][3]
	local alpha = "blend" -- list[i][4]
	local post_alpha = list[i][5]
	local renew = list[i][6]





  minetest.register_node("nodes_nature:"..name.."_source", {
  	description = desc.." Source",
  	drawtype = "liquid",
  	tiles = {
  		{
  			name = "nodes_nature_"..name.."_source_animated.png",
  			backface_culling = false,
  			animation = {
  				type = "vertical_frames",
  				aspect_w = 16,
  				aspect_h = 16,
  				length = 2.0,
  			},
  		},
  		{
  			name = "nodes_nature_"..name.."_source_animated.png",
  			backface_culling = true,
  			animation = {
  				type = "vertical_frames",
  				aspect_w = 16,
  				aspect_h = 16,
  				length = 2.0,
  			},
  		},
  	},
	use_texture_alpha = alpha,
  	paramtype = "light",
  	walkable = false,
  	pointable = false,
  	diggable = false,
  	buildable_to = true,
  	is_ground_content = false,
  	drop = "",
  	drowning = 1,
  	liquidtype = "source",
  	liquid_alternative_flowing = "nodes_nature:"..name.."_flowing",
  	liquid_alternative_source = "nodes_nature:"..name.."_source",
  	liquid_viscosity = 1,
		liquid_range = 2,
		liquid_renewable = renew,
  	post_effect_color = {a = post_alpha, r = 30, g = 60, b = 90},
  	groups = {water = water_g, cools_lava = 1, puts_out_fire = 1},
  	sounds = nodes_nature.node_sound_water_defaults(),
  })


  minetest.register_node("nodes_nature:"..name.."_flowing", {
  	description = desc.." Flowing",
  	drawtype = "flowingliquid",
  	tiles = {"nodes_nature_"..name..".png"},
  	special_tiles = {
  		{
  			name = "nodes_nature_"..name.."_flowing_animated.png",
  			backface_culling = false,
  			animation = {
  				type = "vertical_frames",
  				aspect_w = 16,
  				aspect_h = 16,
  				length = 0.8,
  			},
  		},
  		{
  			name = "nodes_nature_"..name.."_flowing_animated.png",
  			backface_culling = true,
  			animation = {
  				type = "vertical_frames",
  				aspect_w = 16,
  				aspect_h = 16,
  				length = 0.8,
  			},
  		},
  	},
	use_texture_alpha = alpha,
  	paramtype = "light",
  	paramtype2 = "flowingliquid",
  	walkable = false,
  	pointable = false,
  	diggable = false,
  	buildable_to = true,
  	is_ground_content = false,
	liquid_move_physics = false,
	move_resistance = 0,
  	drop = "",
  	drowning = 1,
  	liquidtype = "flowing",
	liquid_range = 2,
  	liquid_alternative_flowing = "nodes_nature:"..name.."_flowing",
  	liquid_alternative_source = "nodes_nature:"..name.."_source",
  	liquid_viscosity = 1,
		liquid_renewable = renew,
  	post_effect_color = {a = post_alpha, r = 30, g = 60, b = 90},
  	groups = {water = water_g, not_in_creative_inventory = 1, puts_out_fire = 1, cools_lava = 1},
  	sounds = nodes_nature.node_sound_water_defaults(),
  })

end



-----------------------------
--Drink Liquids with weild hand

--make freshwater drinkable on click
minetest.override_item("nodes_nature:freshwater_source",{
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = clicker:get_meta()
		local thirst = meta:get_int("thirst")
		--only drink if thirsty
		if thirst < 100 then

			local water = 100
			thirst = thirst + water
			if thirst > 100 then
				thirst = 100
			end

			meta:set_int("thirst", thirst)
			--remove so don't get infinity water supply
			minetest.set_node(pos, {name = "air"})
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.25})

			--food poisoning
			local c = 0.005
			--parasites
			local c2 = 0.005

			--disease chance worse if water in a bad place (e.g. a muddy hole)
			local bad = minetest.find_node_near(pos, 1, {"group:sediment"})
			if bad then
				c = 0.15
				c2 = 0.15
			end

			--food poisoning
			if ran() < c then
				HEALTH.add_new_effect(clicker, {"Food Poisoning", 1})
			end

			--parasites
			if ran() < c2 then
				HEALTH.add_new_effect(clicker, {"Intestinal Parasites"})
			end

		end
	end
})

minetest.override_item("nodes_nature:salt_water_source",{
	color = "#90ff95",
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	   minetest.chat_send_player(clicker:get_player_name(),
				     "Salt water is not safe to drink.")
	end
})

minetest.override_item("nodes_nature:salt_water_flowing",{
			  color = "#99ff95",
})

----------------------------------------------------------
--SNOW AND ICE (yes I know this isn't a liquid...in this state)

--Snow

minetest.register_node("nodes_nature:snow", {
	description = "Snow",
	tiles = {"nodes_nature_snow.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	temp_effect = -2,
	temp_effect_max = 0,
	groups = {crumbly = 3, falling_node = 1, temp_effect = 1, temp_pass = 1, puts_out_fire = 1, fall_damage_add_percent = -25},
	sounds = nodes_nature.node_sound_snow_defaults(),
})

minetest.register_node("nodes_nature:snow_block", {
	description = "Snow Block",
	tiles = {"nodes_nature_snow.png"},
	stack_max = minimal.stack_max_bulky,
	temp_effect = -4,
	temp_effect_max = 0,
	groups = {crumbly = 3, falling_node = 1, temp_effect = 1, puts_out_fire = 1, cools_lava = 1, fall_damage_add_percent = -50},
	sounds = nodes_nature.node_sound_snow_defaults(),

})


crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:snow_block",
	items = {"nodes_nature:snow 2"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:snow 2",
	items = {"nodes_nature:snow_block"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:snow_block 2",
	items = {"nodes_nature:ice"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:ice",
	items = {"nodes_nature:snow_block 2"},
	level = 1,
	always_known = true,
})

--ice
minetest.register_node("nodes_nature:ice", {
	description = "Ice",
	tiles = {"nodes_nature_ice.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	use_texture_alpha = "blend",
	temp_effect = -4,
	temp_effect_max = 0,
	groups = {cracky = 3, crumbly = 1, cools_lava = 1, puts_out_fire = 1, slippery = 3, temp_effect = 1},
	sounds = nodes_nature.node_sound_snow_defaults(),
})


--sea ice
--for thawing, so it turns back into salt water
minetest.register_node("nodes_nature:sea_ice", {
	description = "Sea Ice",
	tiles = {"nodes_nature_ice.png"},
	paramtype = "light",
	drop = "nodes_nature:ice",
	use_texture_alpha = "blend",
	temp_effect = -4,
	temp_effect_max = 0,
	groups = {cracky = 3, crumbly = 1, cools_lava = 1, puts_out_fire = 1, slippery = 3, temp_effect = 1},
	sounds = nodes_nature.node_sound_snow_defaults(),
})


--------------------------------------------------------------------
--LAVA
local lava_light = 12
local lava_temp_effect = 60
local lava_heater = 1100

minetest.register_node("nodes_nature:lava_source", {
	description = "Lava Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "nodes_nature_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "nodes_nature_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = lava_light,
	temp_effect = lava_temp_effect,
	temp_effect_max = lava_heater,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "nodes_nature:lava_flowing",
	liquid_alternative_source = "nodes_nature:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {igniter = 1, temp_effect = 1},
})

minetest.register_node("nodes_nature:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"nodes_nature_lava.png"},
	special_tiles = {
		{
			name = "nodes_nature_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "nodes_nature_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = lava_light,
	temp_effect = lava_temp_effect,
	temp_effect_max = lava_heater,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "nodes_nature:lava_flowing",
	liquid_alternative_source = "nodes_nature:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {igniter = 1,	not_in_creative_inventory = 1, temp_effect = 1, temp_pass = 1},
})


--
-- Lavacooling, moving
--

--cool when next to a cooling node
local cool_lava = function(pos, node)
	minetest.set_node(pos, {name = "nodes_nature:basalt"})
	minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 16, gain = 0.25})
end

minetest.register_abm({
	label = "Lava cooling",
	nodenames = {"nodes_nature:lava_source", "nodes_nature:lava_flowing"},
	neighbors = {"group:cools_lava"},
	interval = 10,
	chance = 3,
	catch_up = false,
	action = function(...)
		cool_lava(...)
	end,
})

-----
-----

--plumes
local erupt = function(pos, aname)
	local height = 0
	print("erupt!")
	--erupt
	while (aname == "air" or aname == "climate:air_temp") and height < 7 do
		if ran()<0.8 then
			height = height + 1
			pos.y = pos.y + 1
			minetest.set_node(pos, {name = "nodes_nature:lava_flowing"})
			minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 16, gain = 0.25})
			local posa = 	{x = pos.x, y = pos.y+1, z = pos.z}
			aname = minetest.get_node(posa).name
		else
			break
		end
	end

end


--cools when exposed to air, melts solids, adds plumes
local lava_melt = function(pos, node)
	--add hot air
	climate.air_temp_source(pos, lava_temp_effect, lava_heater, 0.5, 15)

	--lava works it's way up through rocks and more, melting them as it goes
	--being on top of a magma chamber is now very dangerous
	local posa = 	{x = pos.x, y = pos.y+1, z = pos.z}
	local aname = minetest.get_node(posa).name
	local nodename = node.name

	--air above, cool or plume source
	if nodename == "nodes_nature:lava_source" then

		local aname = minetest.get_node(posa).name

		--space vs solid above
		if aname == "air" or aname == "climate:air_temp" then
			local c = ran()
			--cool vs erupt
			if c<0.5 then
				minetest.set_node(pos, {name = "nodes_nature:basalt"})
				minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 16, gain = 0.25})
				return
			elseif c<0.75 then
				erupt(pos, aname)
				--spread instability
				local spos = minetest.find_node_near(pos, 3, 'nodes_nature:lava_source')
				if spos then
					local pa = 	{x = pos.x, y = pos.y+1, z = pos.z}
					local an = minetest.get_node(pa).name
					if an == 'air' or an == 'climate:air_temp' then
						minetest.after(5, function()
		          erupt(spos, an)
		        end)
					end
				end

			else
				--no change
				return
			end
		elseif minetest.get_item_group(aname, "cracky") > 0 or minetest.get_item_group(aname, "crumbly") > 0 then
			--check it has "force" nearby
			local gpos = minetest.find_nodes_in_area(
				{x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
				{x = pos.x + 1, y = pos.y, z = pos.z + 1},
				{"nodes_nature:lava_source"})
			if #gpos < 9 then
				return
			end
			--melt above
			minetest.set_node(posa, {name = "nodes_nature:lava_source"})
			minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 16, gain = 0.25})
		end
	end


	--flowing only has air anywhere (so sides solidify)
	if nodename == "nodes_nature:lava_flowing" and minetest.find_node_near(pos, 1, {"air", "climate:air_temp"}) then
		local pos_under = {x = pos.x, y = pos.y-1, z = pos.z}
		local under_name = minetest.get_node(pos_under).name
		local nodedef = minetest.registered_nodes[under_name]
		local walkable = nodedef.walkable
		if not nodedef or not walkable then
			return
		end
		minetest.set_node(pos, {name = "nodes_nature:basalt"})
		minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 16, gain = 0.25})
		return
	end

end




minetest.register_abm({
	label = "Lava melt",
	nodenames = {"nodes_nature:lava_source", "nodes_nature:lava_flowing"},
	neighbors = {"group:stone", "group:soft_stone", 'air', 'climate:air_temp'},
	interval = 26,
	chance = 13,
	catch_up = false,
	action = function(...)
		lava_melt(...)
	end,
})
