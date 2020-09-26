-- torch.lua

--interval
local base_burn_rate = 6
--how much to burn
local base_fuel = 60
--brightness
local light_power = 9
local temp = 2
local heat = 450




-------------------------------------------
--save usage into inventory, to prevent infinite torch supply
local on_dig = function(pos, node, digger)

	if not digger then return false end
	
	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end

	local meta = minetest.get_meta(pos)
	local fuel = meta:get_int("fuel")

	local new_stack = ItemStack("tech:torch")
	local stack_meta = new_stack:get_meta()
	stack_meta:set_int("fuel", fuel)


	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new_stack) then
		player_inv:add_item("main", new_stack)
	else
		minetest.add_item(pos, new_stack)
	end
end


-------------------------------------------
--set saved fuel
local after_place_node = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local stack_meta = itemstack:get_meta()
	local fuel = stack_meta:get_int("fuel")
	if fuel >0 then
		meta:set_int("fuel", fuel)
	end
end


-------------------------------------------
--converts flaming torch into ash
local function can_burn_air(pos, meta, ash_name)
	--extinguish
	if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
		minetest.set_node(pos, {name = ash_name})
		minetest.check_for_falling(pos)
		return false
	end

	--check for the presence of air
	if minetest.find_node_near(pos, 1, {"air"}) then
		return true
	else
		--go out
		minetest.set_node(pos, {name = ash_name})
		return false
	end
end

--Particle Effects
local function torch_fire_on(pos)
	if math.random()<0.8 then
		minetest.sound_play("tech_fire_small",{pos=pos, max_hear_distance = 10, loop=false, gain=0.1})
		--Smoke
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
	end
end



-------------------------------------------

local function on_flood(pos, oldnode, newnode)
	minetest.add_item(pos, ItemStack("tech:torch 1"))
	-- Play flame-extinguish sound if liquid is not an 'igniter'
					--[[
	local nodedef = minetest.registered_items[newnode.name]
	if not (nodedef and nodedef.groups and
			nodedef.groups.igniter and nodedef.groups.igniter > 0) then
		minetest.sound_play(
			"default_cool_lava",
			{pos = pos, max_hear_distance = 16, gain = 0.1}
		)
	end
			]]
	-- Remove the torch node
	return false
end


-------------------------------------------

minetest.register_node("tech:torch", {
	description = "Torch",
	drawtype = "mesh",
	mesh = "torch_floor.obj",
	inventory_image = "tech_torch_on_floor.png",
	wield_image = "tech_torch_on_floor.png",
	tiles = {{
		    name = "tech_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	liquids_pointable = false,
	light_source = light_power,
	temp_effect = temp,
	temp_effect_max = heat,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, torch=1, ingniter = 1, temp_effect = 1, temp_pass = 1},
	drop = "tech:torch",
	selection_box = {
		type = "wallmounted",
		wall_bottom = {-1/8, -1/2, -1/8, 1/8, 2/16, 1/8},
	},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_dig = function(pos, node, digger)
		on_dig(pos, node, digger)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local def = minetest.registered_nodes[node.name]
		if def and def.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
			return def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local above = pointed_thing.above
		local wdir = minetest.dir_to_wallmounted(vector.subtract(under, above))
		local fakestack = itemstack
		if wdir == 0 then
			fakestack:set_name("tech:torch_ceiling")
		elseif wdir == 1 then
			fakestack:set_name("tech:torch")
		else
			fakestack:set_name("tech:torch_wall")
		end

		itemstack = minetest.item_place(fakestack, placer, pointed_thing, wdir)
		itemstack:set_name("tech:torch")

		return itemstack
	end,
	floodable = true,
	on_flood = on_flood,
	on_construct = function(pos)
		--duration of burn
		local meta = minetest.get_meta(pos)
		meta:set_int("fuel", base_fuel)
		--fire effects..
		minetest.get_node_timer(pos):start(math.random(base_burn_rate-1,base_burn_rate+1))
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_node(pos, placer, itemstack, pointed_thing)
	end,
	on_timer =function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local fuel = meta:get_int("fuel")
		if fuel < 1 then
			minetest.set_node(pos, {name = "tech:wood_ash"})
			minetest.check_for_falling(pos)
			return false
		elseif can_burn_air(pos, meta, "tech:wood_ash" ) then
			torch_fire_on(pos)
			meta:set_int("fuel", fuel - 1)
			-- Restart timer
			return true
		end
	end,
})

minetest.register_node("tech:torch_wall", {
	drawtype = "mesh",
	mesh = "torch_wall.obj",
	tiles = {{
		    name = "tech_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = light_power,
	temp_effect = temp,
	temp_effect_max = heat,
	groups = {choppy=2, dig_immediate=3, flammable=1, not_in_creative_inventory=1, attached_node=1, torch=1, ingniter = 1, temp_effect = 1, temp_pass = 1},
	drop = "tech:torch",
	selection_box = {
		type = "wallmounted",
		wall_side = {-1/2, -1/2, -1/8, -1/8, 1/8, 1/8},
	},
	sounds = nodes_nature.node_sound_wood_defaults(),
	floodable = true,
	on_flood = on_flood,
	on_dig = function(pos, node, digger)
		on_dig(pos, node, digger)
	end,
	on_construct = function(pos)
		--duration of burn
		local meta = minetest.get_meta(pos)
		meta:set_int("fuel", base_fuel)
		--fire effects..
		minetest.get_node_timer(pos):start(math.random(base_burn_rate-1,base_burn_rate+1))
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_node(pos, placer, itemstack, pointed_thing)
	end,
	on_timer =function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local fuel = meta:get_int("fuel")
		if fuel < 1 then
			minetest.set_node(pos, {name = "tech:wood_ash"})
			minetest.check_for_falling(pos)
			return false
		elseif can_burn_air(pos, meta, "tech:wood_ash" ) then
			torch_fire_on(pos)
			meta:set_int("fuel", fuel - 1)
			-- Restart timer
			return true
		end
	end,
})

minetest.register_node("tech:torch_ceiling", {
	drawtype = "mesh",
	mesh = "torch_ceiling.obj",
	tiles = {{
		    name = "tech_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = light_power,
	temp_effect = temp,
	temp_effect_max = heat,
	groups = {choppy=2, dig_immediate=3, flammable=1, not_in_creative_inventory=1, attached_node=1, torch=1, ingniter = 1, temp_effect = 1, temp_pass = 1},
	drop = "tech:torch",
	selection_box = {
		type = "wallmounted",
		wall_top = {-1/8, -1/16, -5/16, 1/8, 1/2, 1/8},
	},
	sounds = nodes_nature.node_sound_wood_defaults(),
	floodable = true,
	on_flood = on_flood,
	on_dig = function(pos, node, digger)
		on_dig(pos, node, digger)
	end,
	on_construct = function(pos)
		--duration of burn
		local meta = minetest.get_meta(pos)
		meta:set_int("fuel", base_fuel)
		--fire effects..
		minetest.get_node_timer(pos):start(math.random(base_burn_rate-1,base_burn_rate+1))
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_node(pos, placer, itemstack, pointed_thing)
	end,
	on_timer =function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local fuel = meta:get_int("fuel")
		if fuel < 1 then
			minetest.set_node(pos, {name = "tech:wood_ash"})
			minetest.check_for_falling(pos)
			return false
		elseif can_burn_air(pos, meta, "tech:wood_ash" ) then
			torch_fire_on(pos)
			meta:set_int("fuel", fuel - 1)
			-- Restart timer
			return true
		end
	end,
})


------------------------------------------
--Recipe
--
--Hand crafts (inv)
--

--A bundle from sticks and fibre
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:torch 1",
	items = {"tech:stick 1", "group:fibrous_plant 4"},
	level = 1,
	always_known = true,
})

