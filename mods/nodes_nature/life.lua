---------------------------------------------------------
--LIFE
--living things e.g. plants

-- Internationalization
local S = nodes_nature.S

---------------------------------------
local random = math.random
local floor = math.floor

plant_base_growth = plant_base_growth
plant_base_timer = plant_base_timer
crop_rewind = crop_rewind
exile_add_food_hooks = exile_add_food_hooks
creative = creative

---------------------------
-- Dig upwards
--

local function dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end


------------------------------
-- Seeds/seedling soil timers
--if the soil quality changes under the seed it will slow/speed the timer
local function seed_soil_response(pos)

	local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
	local node_under = minetest.get_node(pos_under).name

	local sediment = minetest.get_item_group(node_under, "sediment")
	if sediment == 0 then
		return false
	end

	local wetness = minetest.get_item_group(node_under, "wet_sediment")
	local ag_soil = minetest.get_item_group(node_under, "agricultural_soil")
	local dep_ag_soil = minetest.get_item_group(node_under, "depleted_agricultural_soil")

	local timer_min = plant_base_timer


	--apply bonus or penalty by by soil type and wetness
	if wetness == 1 then
		--moisture is good
		timer_min = timer_min * 0.75
	elseif wetness == 2 then
		--salt water is very bad
		timer_min = timer_min * 1000
	end

	if sediment == 1 then
		--loam is best
		timer_min = timer_min * .80
	elseif sediment == 3 then
		--silt is nearly as good as loam
		timer_min = timer_min * .90
	elseif sediment == 2 then
		--clay is poor, needs to be broken up; i.e. into ag_soil
		timer_min = timer_min * 1.50
	elseif sediment == 4 or sediment == 5 then
		--sand and gravel are terrible
		timer_min = timer_min * 1.80
	end

	if ag_soil == 1 then
		--cultivation boom
		timer_min = timer_min * 0.60
	elseif dep_ag_soil == 1 then
		--lesser cultivation boom
		timer_min = timer_min * 0.80
	end

	local timer_max = timer_min * 1.1
	return timer_min, timer_max
end


-- Seeds growth
local function grow_seed(pos, seed_name, plant_name, place_p2, timer_avg, elapsed)

	local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
	local node_under = minetest.get_node(pos_under)
	local mushroom = false

	--if not on sediment abort
	if minetest.get_item_group(node_under.name, "sediment") == 0 then
		return
	end

	--cannot grow indoors (unless a mushroom)
	if minetest.get_item_group(plant_name, "mushroom") == 0 then
		local light = minetest.get_natural_light({x=pos.x, y=pos.y + 1, z=pos.z}, 0.5)
		if not light or light < 13 then
			return
		end
	else mushroom = true
	end

	--extreme temps will kill
	local temp = climate.get_point_temp(pos)
	if temp < -30 or temp > 60 then
	   minetest.remove_node(pos)
	   return true -- this plant's done
	end

	--
	local meta = minetest.get_meta(pos)
	local growth = meta:get_int("growth")
	--happens if they fall, no meta is set
	if growth == 0 then
		growth = plant_base_growth
	end

	--We've been away, let's catch up on missing growth
	if elapsed and elapsed > timer_avg then
	   if pos.y < -15 and  temp >= 0 or temp <= 40 then
	      if mushroom then
		 --This is an underground shroom, assume steady temp
		 growth = growth - ( elapsed / timer_avg )
	      else
		 -- underground plant, but we've got light so give it 50%
		 growth = growth - ( elapsed / timer_avg / 2)
	      end
	   else
	      local change = crop_rewind(elapsed, timer_avg, mushroom)
	      if change == -1 then
		 --Exteme heat or cold killed the plant
		 minetest.remove_node(pos)
		 return true
	      end
	      growth = growth - change
	   end
	end

	--after first cycle turn seeds into seedlings
	if seed_name ~= nil then
		if minetest.get_item_group(seed_name, "seed") == 1 then
			minetest.set_node(pos, {name = plant_name.."_seedling", param2= place_p2})
			meta:set_int("growth", growth)
			--return
		end
	end

	--semi-extreme temps stop growth
	if temp < 0 or temp > 40 then
	   return
	end
	-- new plant, or grow
	if growth <= 1 then
		minetest.set_node(pos, {name = plant_name, param2= place_p2})
		return true
	else
		--still growing
		--chance to deplete soil
		if minetest.get_item_group(node_under.name, "agricultural_soil") >= 1 then
			if math.random()<0.0001 then
				local deplete_name = node_under.name.."_depleted"
				minetest.set_node(pos_under, {name = deplete_name})
			end
		end
		--grow faster in rain
		if climate.get_rain(pos) then
			growth = growth - 4
			if growth < 1 then
				growth = 1
			end
			meta:set_int("growth", growth)
		else
			growth = growth - 1
			if growth < 1 then
				growth = 1
			end
			meta:set_int("growth", growth)
		end
	end
end

---------------------------
-- Save/restore seedling timers on dig/place
--
local on_dig_seedling = function(pos,node, digger)
   if not digger then return false end

   if minetest.is_protected(pos, digger:get_player_name()) then
      return false
   end
	local meta = minetest.get_meta(pos)
	local growth = meta:get_int("growth")
	if not growth then growth = plant_base_growth end

	local new_stack = ItemStack(node.name)
	local stack_meta = new_stack:get_meta()
	stack_meta:set_int("growth", growth)

	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new_stack) then
		player_inv:add_item("main", new_stack)
	else
		minetest.add_item(pos, new_stack)
	end
end
local after_place_seedling = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local stack_meta = itemstack:get_meta()
	local growth = stack_meta:get_int("growth")
	if growth == 0 then -- new seeds have no meta
	   growth = meta:get_int("growth") -- but it's set on the node already
	end
	if not growth then growth = plant_base_growth end
	meta:set_int("growth", growth)
end

---------------------------
-- Prevent placing seed anywhere but sediment
--
local on_place_seedling = function(itemstack, placer, pointed_thing)
   local ground = minetest.get_node(pointed_thing.under)
   local above = minetest.get_node(pointed_thing.above)
   if minetest.get_item_group(ground.name,"sediment") == 0
   or above.name ~= "air" then
      local udef = minetest.registered_nodes[ground.name]
      if udef and udef.on_rightclick and
	 not (placer and placer:is_player() and
	      placer:get_player_control().sneak) then
	    return udef.on_rightclick(pointed_thing.under, ground,
				      placer, itemstack,
				      pointed_thing) or itemstack
      else
	 return itemstack
      end
   end

   return minetest.item_place_node(itemstack,placer,pointed_thing)
end

-------------------------------------------------------------
--
--All regular plants
--


plantlist = plantlist
for i in ipairs(plantlist) do
	local plantname = plantlist[i][1]
	local plantdesc = plantlist[i][2]
	local selbox = plantlist[i][3]
	local vscale = plantlist[i][4]
	local type = plantlist[i][5]
	local draw = plantlist[i][6]
	local p2 = plantlist[i][7]  --param2
	local seed_desc = plantlist[i][8]
	local seed_image = plantlist[i][9]
	local growth = plantlist[i][10] --for seeds
	local dyecandidate = plantlist[i][11]
	local dominantcolor = plantlist[i][12]

	if selbox == nil then
		selbox = {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4}
	end

	local s = nodes_nature.node_sound_leaves_defaults()

	local g
	local gs = {snappy = 3, herbaceous_plant = 1, attached_node = 1,
		    flammable = 1, seedling = 1, temp_pass = 1} --seedlings
	local g_seed = {snappy = 3, dig_immediate = 2, flammable = 1,
			attached_node = 1, seed = 1, temp_pass = 1}

	if type == "crumbly" then		--moss, dirt mat-like things
	   g = {crumbly = 3, herbaceous_plant = 1, falling_node = 1,
		attached_node = 1, flammable = 1, flora = 1, temp_pass = 1}
	elseif type == "woody_plant" then
	   g = {choppy = 3, woody_plant = 1, attached_node = 1,
		flammable = 1, flora = 1, temp_pass = 1}
		s = nodes_nature.node_sound_wood_defaults()
	elseif type == "herbaceous_plant" then
	   g = {snappy = 3, herbaceous_plant = 1, attached_node = 1,
		flammable = 1, flora = 1, temp_pass = 1}
	elseif type == "fibrous_plant" then
	   g = {snappy = 3, fibrous_plant = 1, attached_node = 1,
		flammable = 1, flora = 1, temp_pass = 1}
	elseif type == "mushroom" then
	   g = {crumbly = 3, attached_node = 1, flammable = 1,
		mushroom = 1, temp_pass = 1}
	   gs = {crumbly = 3, attached_node = 1, flammable = 1,
		 mushroom = 1, seedling = 1, temp_pass = 1}
	   g_seed = {crumbly = 3, attached_node = 1, flammable = 1,
		     mushroom = 1, seed = 1, temp_pass = 1}
	else
	   g = {snappy = 3, attached_node = 1, flammable = 1,
		flora = 1, temp_pass = 1}
	end

	if dyecandidate then
	   g.ncrafting_dye_candidate = dyecandidate
	else
	   g.ncrafting_dye_candidate = 1
	end

	--singlenode bushes etc
	if draw == "nodebox" then
		minetest.register_node("nodes_nature:"..plantname, {
			description = plantdesc,
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {
					selbox,
				},
			},
			tiles = {"nodes_nature_"..plantname..".png"},
			stack_max = minimal.stack_max_medium,
			paramtype = "light",
			paramtype2 = "facedir",
			floodable = true,
			sunlight_propagates = false,
			is_ground_content = false,
			walkable = false,
			buildable_to = true,
			groups = g,
			sounds = s,
			_ncrafting_dye_dcolor = dominantcolor
		})

		--seedling
		minetest.register_node("nodes_nature:"..plantname.."_seedling", {
			description = S("Young @1", plantdesc),
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.2, -0.5, -0.2, 0.2, -0.3, 0.2},
				},
			},
			tiles = {"nodes_nature_"..plantname..".png"},
			stack_max = minimal.stack_max_medium,
			paramtype = "light",
			paramtype2 = "facedir",
			floodable = true,
			sunlight_propagates = true,
			is_ground_content = false,
			walkable = false,
			buildable_to = true,
			groups = gs,
			sounds = s,
			on_construct = function(pos)
				--set initial timer, growth rate depends on soil
				local timer_min, timer_max = seed_soil_response(pos)
				if timer_min then
					minetest.get_node_timer(pos):start(math.random(timer_min, timer_max))
				else
				   minetest.get_node_timer(pos):start(plant_base_timer)
				end
			end,

			on_timer = function(pos,elapsed)
			   local timer_min, timer_max = seed_soil_response(pos)
			   if not timer_min then
			      if minetest.get_node(pos).name ~= "ignore" then
				 return false -- not on soil anymore? Stop timer
			      else
				 return true -- it's unloaded, skip the timer
			      end
			   end
			   local timer_avg = timer_min + timer_max / 2
			   elapsed = elapsed - timer_max
			   if grow_seed(pos, nil, "nodes_nature:"..plantname, nil, timer_avg, elapsed) then
			      return false -- done
			   else
			      minetest.get_node_timer(pos):start(math.random(timer_min, timer_max))
			   end
			end,
			after_place_node = function(pos, placer, itemstack, pointed_thing)
			   after_place_seedling(pos, placer, itemstack, pointed_thing)
			end,
			on_dig = function(pos, node, digger)
			   on_dig_seedling(pos, node, digger)
			end,
		})


  else
    minetest.register_node("nodes_nature:"..plantname, {
      description = plantdesc,
      drawtype = draw or "plantlike",
      waving = 1,
      visual_scale = vscale,
      tiles = {"nodes_nature_"..plantname..".png"},
			stack_max = minimal.stack_max_medium,
      inventory_image = "nodes_nature_"..plantname..".png",
      wield_image = "nodes_nature_"..plantname..".png",
      paramtype = "light",
			paramtype2 = "meshoptions",
			place_param2 = p2 or 1,
			floodable = true,
      sunlight_propagates = true,
      walkable = false,
      buildable_to = true,
      groups = g,
      sounds = s,
      _ncrafting_dye_dcolor = dominantcolor,
      selection_box = {
        type = "fixed",
        fixed = selbox,
      },
    })

		--seedling
		minetest.register_node("nodes_nature:"..plantname.."_seedling", {
      description = S("Young @1", plantdesc),
      drawtype = draw or "plantlike",
      waving = 1,
      visual_scale = vscale,
      tiles = {"nodes_nature_"..plantname.."_seedling.png"},
      inventory_image = "nodes_nature_"..plantname.."_seedling.png",
      wield_image = "nodes_nature_"..plantname.."_seedling.png",
			stack_max = minimal.stack_max_medium,
      paramtype = "light",
			paramtype2 = "meshoptions",
			place_param2 = p2 or 1,
			floodable = true,
      sunlight_propagates = true,
      walkable = false,
      buildable_to = true,
      groups = gs,
      sounds = s,
      selection_box = {
        type = "fixed",
				fixed = {
					{-0.2, -0.5, -0.2, 0.2, -0.3, 0.2},
				},
      },
			on_construct = function(pos)
				--set initial timer, growth rate depends on soil
				local timer_min, timer_max = seed_soil_response(pos)
				if timer_min then
					minetest.get_node_timer(pos):start(math.random(timer_min, timer_max))
				else
				   minetest.get_node_timer(pos):start(plant_base_timer)
				end
			end,

			on_timer = function(pos,elapsed)
			   local timer_min, timer_max = seed_soil_response(pos)
			   if not timer_min then
			      if minetest.get_node(pos).name ~= "ignore" then
				 return false -- not on soil anymore? Stop timer
			      else
				 return true -- it's unloaded, skip the timer
			      end
			   end
			   local timer_avg = timer_min + timer_max / 2
			   elapsed = elapsed - timer_max
			   if grow_seed(pos, nil, "nodes_nature:"..plantname, p2, timer_avg, elapsed) then
			      return
			   else
			      minetest.get_node_timer(pos):start(math.random(timer_min, timer_max))
			   end
			end,
			after_place_node = function(pos, placer, itemstack, pointed_thing)
			   after_place_seedling(pos, placer, itemstack, pointed_thing)
			end,
			on_dig = function(pos, node, digger)
			   on_dig_seedling(pos, node, digger)
			end,
    })
	end

	minetest.register_craft({
		type = "fuel",
		recipe = "nodes_nature:"..plantname,
		burntime = 1,
	})


	--seeds and spores

	if not seed_image then
		if type == "mushroom" then
			seed_image = "nodes_nature_spores.png"
		else
			seed_image = "nodes_nature_seeds.png"
		end
	end

	if not seed_desc then
		if type == "mushroom" then
			seed_desc = S("@1 Spores", plantdesc)
		else
			seed_desc = S("@1 Seeds", plantdesc)
		end
	end

	minetest.register_node("nodes_nature:"..plantname.."_seed", {
		description = seed_desc,
		drawtype = "nodebox",
		tiles = {seed_image},
		inventory_image = seed_image,
		node_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3,  0.3, -0.48, 0.3},
		},
		stack_max = minimal.stack_max_light,
		use_texture_alpha = "clip",
		paramtype = "light",
		floodable = true,
		sunlight_propagates = true,
		is_ground_content = false,
		walkable = false,
		buildable_to = true,
		groups = g_seed,
		sounds = nodes_nature.node_sound_defaults(),
		on_construct = function(pos)
			--duration of growth, per species
			local meta = minetest.get_meta(pos)
			meta:set_int("growth", growth)
			--set initial timer, growth rate depends on soil
			local timer_min, timer_max = seed_soil_response(pos)
			if timer_min then
				minetest.get_node_timer(pos):start(math.random(timer_min, timer_max))
			else
			   minetest.get_node_timer(pos):start(plant_base_timer)
			end
		end,

		on_timer = function(pos,elapsed)
			   local timer_min, timer_max = seed_soil_response(pos)
			   if not timer_min then
			      if minetest.get_node(pos).name ~= "ignore" then
				 return false -- not on soil anymore? Stop timer
			      else
				 return true -- it's unloaded, skip the timer
			      end
			   end
			   local timer_avg = timer_min + timer_max / 2
			   elapsed = elapsed - timer_max
			   if grow_seed(pos, "nodes_nature:"..plantname.."_seed", "nodes_nature:"..plantname,
					p2, timer_avg, elapsed) then
			      return
			   else
			      minetest.get_node_timer(pos):start(math.random(timer_min, timer_max))
			   end
		end,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
		   after_place_seedling(pos, placer, itemstack, pointed_thing)
		end,
		on_dig = function(pos, node, digger)
		   on_dig_seedling(pos, node, digger)
		end,
		on_place = function(itemstack, placer, pointed_thing)
		   return on_place_seedling(itemstack, placer, pointed_thing)
		end,
	})


	--extract seeds
	crafting.register_recipe({
		type = "threshing_spot",
		output = "nodes_nature:"..plantname.."_seed 6",
		items = {"nodes_nature:"..plantname},
		level = 1,
		always_known = true,
	})

	exile_add_food_hooks("nodes_nature:"..plantname)


end

-----------------------------------------
---CANES

minetest.register_node("nodes_nature:gemedi", {
	description = "Gemedi",
	drawtype = "plantlike",
	tiles = {"nodes_nature_gemedi.png"},
	inventory_image = "nodes_nature_gemedi.png",
	wield_image = "nodes_nature_gemedi.png",
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 2,
	sunlight_propagates = true,
	walkable = false,
	--floodable = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
	},
	groups = {snappy = 3, fibrous_plant = 1, flammable = 1, flora = 1,
		  cane_plant = 1, temp_pass = 1, ncrafting_dye_candidate = 1},
	sounds = nodes_nature.node_sound_leaves_defaults(),
	_ncrafting_dye_dcolor = "yellow",

	after_dig_node = function(pos, node, metadata, digger)
		dig_up(pos, node, digger)
	end,
})

minetest.register_node("nodes_nature:cana", {
	description = S("Cana"),
	drawtype = "plantlike",
	tiles = {"nodes_nature_cana.png"},
	inventory_image = "nodes_nature_cana.png",
	wield_image = "nodes_nature_cana.png",
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 2,
	sunlight_propagates = true,
	walkable = false,
	--floodable = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
	},
	groups = {snappy = 3, fibrous_plant = 1, flammable = 1, flora = 1, cane_plant = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_leaves_defaults(),

	after_dig_node = function(pos, node, metadata, digger)
		dig_up(pos, node, digger)
	end,
})

minetest.register_node("nodes_nature:tiken", {
	description = "Tiken",
	drawtype = "plantlike",
	tiles = {"nodes_nature_tiken.png"},
	inventory_image = "nodes_nature_tiken.png",
	wield_image = "nodes_nature_tiken.png",
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 2,
	sunlight_propagates = true,
	walkable = false,
	damage_per_second = 1,
	climbable = true,
	--floodable = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
	},
	groups = {choppy = 3, woody_plant = 1, flammable = 1, flora = 1,
		  cane_plant = 1, temp_pass = 1, ncrafting_dye_candidate = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),

	after_dig_node = function(pos, node, metadata, digger)
		dig_up(pos, node, digger)
	end,
})


----------------------------------------------------------------------
--SEA LIFE

local function rooted_place(itemstack, placer, pointed_thing, node_name, substrate_name, height_min, height_max)
	-- Call on_rightclick if the pointed node defines it
	if pointed_thing.type == "node" and placer and
			not placer:get_player_control().sneak then
		local node_ptu = minetest.get_node(pointed_thing.under)
		local def_ptu = minetest.registered_nodes[node_ptu.name]
		if def_ptu and def_ptu.on_rightclick then
			return def_ptu.on_rightclick(pointed_thing.under, node_ptu, placer,
				itemstack, pointed_thing)
		end
	end

	local pos = pointed_thing.under
	if minetest.get_node(pos).name ~= substrate_name then
		return itemstack
	end

	local height = math.random(height_min, height_max)
	local pos_top = {x = pos.x, y = pos.y + height, z = pos.z}
	local node_top = minetest.get_node(pos_top)
	local def_top = minetest.registered_nodes[node_top.name]
	local player_name = ""
	if placer then
	   player_name = placer:get_player_name()
	end

	if def_top and def_top.liquidtype == "source" and
			minetest.get_item_group(node_top.name, "water") > 0 then
		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pos_top, player_name) then
			minetest.set_node(pos, {name = node_name,
				param2 = height * 16})
			if not (creative and creative.is_enabled_for
					and creative.is_enabled_for(player_name)) then
				itemstack:take_item()
			end
		else
			minetest.chat_send_player(player_name, "Node is protected")
			minetest.record_protection_violation(pos, player_name)
		end
	end

	return itemstack
end



--Underwater Rooted plants

searooted_list = searooted_list
for i in ipairs(searooted_list) do
	local name = searooted_list[i][1]
	local desc = searooted_list[i][2]
	local selbox = searooted_list[i][3]
	local type = searooted_list[i][4]
	local substrate = searooted_list[i][5]
	local substrate_tile = searooted_list[i][6]
	local sound_table = searooted_list[i][7]
	local height_min = searooted_list[i][8]
	local height_max = searooted_list[i][9]
	local pillar = searooted_list[i][10]
	local dyecandidate = searooted_list[i][11]
	local dominantcolor = searooted_list[i][12] or "green"

	local g = {snappy = 3, flora = 1, flora_sea = 1}
	--use seaweed as fertilizer
	if type == "seaweed" then
		g.fertilizer = 1
	end

	if dyecandidate then
	   g.ncrafting_dye_candidate = dyecandidate
	else
	   g.ncrafting_dye_candidate = 1
	end

	if pillar then
		minetest.register_node("nodes_nature:"..name, {
			description = desc,
			drawtype = "plantlike_rooted",
			waving = 1,
			tiles = {substrate_tile},
			special_tiles = {{name = "nodes_nature_"..name..".png", tileable_vertical = true}},
			inventory_image = "nodes_nature_"..name..".png",
			paramtype = "light",
			paramtype2 = "leveled",
			groups = g,
			selection_box = {
				type = "fixed",
				fixed = {
						{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
						selbox,
				},
			},
			stack_max = minimal.stack_max_medium,
			node_dig_prediction = substrate,
			node_placement_prediction = "",
			sounds = sound_table,
			_ncrafting_dye_dcolor = dominantcolor,

			on_place = function(itemstack, placer, pointed_thing)
				return rooted_place(itemstack, placer, pointed_thing, "nodes_nature:"..name, substrate, height_min, height_max)
			end,

			after_destruct  = function(pos, oldnode)
				minetest.set_node(pos, {name = substrate})
			end
		})

	else
		minetest.register_node("nodes_nature:"..name, {
			description = desc,
			drawtype = "plantlike_rooted",
			waving = 1,
			tiles = {substrate_tile},
			special_tiles = {{name = "nodes_nature_"..name..".png", tileable_vertical = true}},
			inventory_image = "nodes_nature_"..name..".png",
			paramtype = "light",
			groups = g,
			selection_box = {
				type = "fixed",
				fixed = {
						{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
						selbox,
				},
			},
			stack_max = minimal.stack_max_medium,
			node_dig_prediction = substrate,
			node_placement_prediction = "",
			sounds = sound_table,
			_ncrafting_dye_dcolor = dominantcolor,

			on_place = function(itemstack, placer, pointed_thing)
				return rooted_place(itemstack, placer, pointed_thing, "nodes_nature:"..name, substrate, height_min, height_max)
			end,

			after_destruct  = function(pos, oldnode)
				minetest.set_node(pos, {name = substrate})
			end,
		})
	end
	exile_add_food_hooks("nodes_nature:"..name)

end

--exile_experimental plants, need Exile v4 biomes to spawn?
minetest.register_node("nodes_nature:chalin", {
			  description = "Chalin",
			  drawtype = "plantlike",
			  tiles = {"nodes_nature_chalin.png"},
			  inventory_image = "nodes_nature_chalin.png",
			  wield_image = "nodes_nature_chalin.png",
			  stack_max = minimal.stack_max_medium,
			  paramtype = "light",
			  paramtype2 = "meshoptions",
			  place_param2 = 2,
			  sunlight_propagates = true,
			  walkable = false,
			  climbable = true,
			  --floodable = true,
			  selection_box = {
			     type = "fixed",
			     fixed = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			  },
			  groups = {choppy = 3, woody_plant = 1, flammable = 1,
				    flora = 1, cane_plant = 1, temp_pass = 1,
				    ncrafting_dye_candidate = 1},
			  sounds = nodes_nature.node_sound_wood_defaults(),

			  on_place = function(itemstack, placer, pointed_thing)
			     local under = pointed_thing.under
			     local node = minetest.get_node(under)
			     local udef = minetest.registered_nodes[node.name]

			     if node.name == "nodes_nature:chalin" then
				return
			     end
			     -- Run any on_rightclick function of pointed node
			     if udef and udef.on_rightclick and
                                not (placer and placer:is_player() and
				     placer:get_player_control().sneak) then
				return udef.on_rightclick(under, node, placer,
					itemstack, pointed_thing) or itemstack
			     end

			     local face = vector.direction(pointed_thing.above,
							   pointed_thing.under)
			     if face.y == -1 then
				minetest.item_place_node(itemstack, placer,
							 pointed_thing)
				return itemstack
			     else
				return itemstack
			     end
			  end,
			  after_dig_node = function(pos, node, metadata, digger)
			     dig_up(pos, node, digger)
			  end,
})

--a bit experimental, doesn't reproduce
minetest.register_node("nodes_nature:glow_worm", {
			  description = S("Glow Worm"),
			  drawtype = "plantlike",
			  waving = 1,
			  visual_scale = 1,
			  light_source = 2,
			  tiles = {"nodes_nature_glow_worm.png"},
			  stack_max = minimal.stack_max_medium,
			  inventory_image = "nodes_nature_glow_worm.png",
			  wield_image = "nodes_nature_glow_worm.png",
			  paramtype = "light",
			  paramtype2 = "meshoptions",
			  place_param2 = 3,
			  floodable = true,
			  sunlight_propagates = true,
			  walkable = false,
			  buildable_to = true,
			  groups = {snappy = 3, flammable = 1, temp_pass = 1, bioluminescent = 1},
			  sounds = nodes_nature.node_sound_leaves_defaults(),
			  selection_box = {
			     type = "fixed",
			     fixed = {-0.3, 0.5, -0.3, 0.3, 0.35, 0.3},
			     floodable = true,
			     sunlight_propagates = true,
			     walkable = false,
			     buildable_to = true,
			     groups = {snappy = 3, flammable = 1, temp_pass = 1, bioluminescent = 1},
			     sounds = nodes_nature.node_sound_leaves_defaults(),
			     selection_box = {
				type = "fixed",
				fixed = {-0.3, 0.5, -0.3, 0.3, 0.35, 0.3},
			     },
			  },
})


----------------------------------------------
--Extra effects

--glowing mushroom
minetest.override_item("nodes_nature:merki",{
	light_source = 2,
	groups = {crumbly = 3, attached_node = 1, flammable = 1, mushroom = 1, temp_pass = 1, bioluminescent= 1}
})


-- tuber
minetest.override_item("nodes_nature:anperla_seed",{
	tiles = {'nodes_nature_silt.png'},
	node_box = {
		type = "fixed",
		fixed = {-0.15, -0.5, -0.15,  0.15, -0.35, 0.15},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.15, -0.5, -0.15,  0.15, -0.35, 0.15},
	},
	stack_max = minimal.stack_max_medium,
	walkable = true,
})

--marbhan has a Neurotoxin
minetest.override_item("nodes_nature:marbhan",{
	on_use = function(itemstack, user, pointed_thing)
	   --Similar to hemlock, which tastes musty or like mouse urine
	   minetest.chat_send_player(user:get_player_name(),
				     "This plant has a foul musty flavor.")
		--food poisoning
		if random() < 0.001 then
			HEALTH.add_new_effect(user, {"Food Poisoning", 1})
		end

		--toxin
		if random() < 0.75 then
			HEALTH.add_new_effect(user, {"Neurotoxicity", floor(random(1,4))})
		end

		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 0, 1, -10, 0)
	end,
})


--nebiyi has a Hepatotoxin
minetest.override_item("nodes_nature:nebiyi",{
	on_use = function(itemstack, user, pointed_thing)
	   --Flowers look a bit like oleander; it causes intense stomach pain
	   minetest.chat_send_player(user:get_player_name(),
				     "Your stomach hurts terribly.")
		--food poisoning
		if random() < 0.001 then
			HEALTH.add_new_effect(user, {"Food Poisoning", 1})
		end

		--toxin
		if random() < 0.75 then
			HEALTH.add_new_effect(user, {"Hepatotoxicity", floor(random(1,4))})
		end

		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 0, 1, -10, 0)
	end,
})


--hakimi is antibacterial, antifungal
minetest.override_item("nodes_nature:hakimi",{
	on_use = function(itemstack, user, pointed_thing)

		--only cure mild
		if random()<0.75 then
			HEALTH.remove_new_effect(user, {"Food Poisoning", 1})
			HEALTH.remove_new_effect(user, {"Fungal Infection", 1})
			HEALTH.remove_new_effect(user, {"Dust Fever", 1})
		end

		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 1, 0, 0, -10, 0)
	end,
})

--merki is anti-parasitic
minetest.override_item("nodes_nature:merki",{
	on_use = function(itemstack, user, pointed_thing)

		if random()<0.15 then
			HEALTH.remove_new_effect(user, {"Intestinal Parasites"})
		end


		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 1, 0, 0, -10, 0)
	end,
})




--------------------------------------
--lambakap. is also a mushroom.
--slow growing food and water source, main crop for longterm underground living.
minetest.override_item("nodes_nature:lambakap",{
	light_source = 2,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, -0.375, 0.125},
			{-0.1875, -0.375, -0.1875, 0.1875, -0.1875, 0.1875},
			{-0.1875, -0.1875, -0.1875, -0.0625, 0, 0.1875},
			{0.0625, -0.1875, -0.1875, 0.1875, 0, 0.1875},
			{-0.0625, -0.1875, -0.1875, 0.0625, 0, -0.0625},
			{-0.0625, -0.1875, 0.0625, 0.0625, 0, 0.1875},
		}
	},
	groups = {crumbly = 3, mushroom = 1, falling_node = 1,
		  attached_node = 1, flammable = 1, flora = 1,
		  temp_pass = 1, bioluminescent = 1}
})

--reshedaar.  is also a mushroom.
--slow growing fibre mushroom, main fibre crop for longterm underground living.
--(can't be bioluminescent or conflicts with recipe)
minetest.override_item("nodes_nature:reshedaar",{
	--light_source = 2,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox1
			{-0.0625, -0.5, -0.1875, 0.0625, -0.0625, -0.125}, -- NodeBox2
			{-0.0625, -0.5, 0.125, 0.0625, -0.0625, 0.1875}, -- NodeBox3
			{-0.1875, -0.5, -0.0625, -0.125, -0.0625, 0.0625}, -- NodeBox4
			{0.125, -0.5, -0.0625, 0.1875, -0.0625, 0.0625}, -- NodeBox5
			{-0.125, -0.25, -0.125, -0.0625, 0.4375, -0.0625}, -- NodeBox9
			{-0.125, -0.25, 0.0625, -0.0625, 0.3125, 0.125}, -- NodeBox10
			{0.0625, -0.25, -0.125, 0.125, 0.3125, -0.0625}, -- NodeBox11
			{0.0625, -0.25, 0.0625, 0.125, 0.4375, 0.125}, -- NodeBox12
		}
	},
	groups = {snappy = 3, mushroom = 1, fibrous_plant = 1,
		  falling_node = 1, attached_node = 1,
		  flammable = 1, flora = 1, temp_pass = 1}
})

--Mahal. is also a mushroom.
--slow growing woody mushroom, main stick crop for longterm underground living.
minetest.override_item("nodes_nature:mahal",{
	light_source = 2,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox1
			{-0.0625, -0.3125, -0.0625, 0.0625, 0.3125, 0.0625}, -- NodeBox2
			{-0.125, 0.375, -0.125, 0.125, 0.5, 0.125}, -- NodeBox3
			{-0.1875, 0.3125, -0.1875, 0.1875, 0.375, 0.1875}, -- NodeBox4
		}
	},
	groups = {choppy = 3, mushroom = 1, woody_plant = 1,
		  falling_node = 1, attached_node = 1, flammable = 1,
		  flora = 1, temp_pass = 1, bioluminescent = 1}
})

--------------------------------
--Bulk recipes

--page spacing
for i = 1,3,1 do
crafting.register_recipe({
	type = "threshing_spot",
	output = "",
	items = {},
	level = 1,
	always_known = true,
})
end


--bulk recipes x6
for i in ipairs(plantlist) do
	local plantname = plantlist[i][1]
	crafting.register_recipe({
		type = "threshing_spot",
		output = "nodes_nature:"..plantname.."_seed 36",
		items = {"nodes_nature:"..plantname.." 6"},
		level = 1,
		always_known = true,
	})
end
