------------------------------------------------
-- POTTERY
-- all made from clay
--unfired versions must reach right temperature for long enough to fire.
-----------------------------------------------

-- Internationalization
local S = tech.S

--firing difficulty
local base_firing = ncrafting.base_firing
local firing_int = ncrafting.firing_int


---
--Broken Pottery
--if you smash it up, or from failed firings
minetest.register_node("tech:broken_pottery", {
	description = S("Broken Pottery"),
	tiles = {"tech_broken_pottery.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	groups = {cracky = 3, falling_node = 1, oddly_breakable_by_hand = 3},
	sounds = nodes_nature.node_sound_gravel_defaults(),
})




-------------------------------------------------------------------
--THIS SHOULD BE MOVED somewhere GENERALIZED to handle non-pottery pots
function water_pot(pos, pot_name)
	local light = minetest.get_natural_light({x=pos.x, y=pos.y + 1, z=pos.z}, 0.5)
	--collect rain
	if light == 15 then
		if climate.get_rain(pos, light) then
			minetest.set_node(pos, {name = pot_name.."_freshwater"})
			return
		end
	else
		--drain wet sediment into the pot
		--or melt snow and ice
		local posa = 	{x = pos.x, y = pos.y+1, z = pos.z}
		local name_a = minetest.get_node(posa).name
		if name_a == "air" then
			return true
		--[[-- Water puddles make more sense than this now,
		--especially given disease risks
		elseif minetest.get_item_group(name_a, "wet_sediment") == 1 then
			local nodedef = minetest.registered_nodes[name_a]
			if not nodedef then
				return true
			end
			minetest.set_node(posa, {name = nodedef._dry_name})
			minetest.set_node(pos, {name = "tech:clay_water_pot_freshwater"})
			return
		elseif minetest.get_item_group(name_a, "wet_sediment") == 2 then
			local nodedef = minetest.registered_nodes[name_a]
			if not nodedef then
				return true
			end
			minetest.set_node(posa, {name = nodedef._dry_name})
			minetest.set_node(pos, {name = "tech:clay_water_pot_salt_water"})
			return
			]]
		elseif (name_a == "nodes_nature:ice" or
			name_a == "nodes_nature:snow_block" or
			name_a == "nodes_nature:freshwater_source" ) then
			if climate.can_thaw(posa) then
				minetest.set_node(pos, {name = pot_name.."_freshwater"})
				minetest.remove_node(posa)
				return
			end
		end
	end
	return true
end




--Water pot
--for collecting water, catching rain water
--fired
minetest.register_node("tech:clay_water_pot", {
	description = S("Clay Water Pot"),
	tiles = {
		"tech_water_pot_empty.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png"
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25}, -- NodeBox1
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox5
		}
	},
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		return liquid_store.on_use_empty_bucket(itemstack, user, pointed_thing)
	end,
		--collect rain water
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(30,60))
	end,
	on_timer =function(pos, elapsed)
		return water_pot(pos, "tech:clay_water_pot")
	end,
	groups = {dig_immediate = 3, pottery = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),

})



--unfired
minetest.register_node("tech:clay_water_pot_unfired", {
	description = S("Clay Water Pot (unfired)"),
	tiles = {
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png"
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25}, -- NodeBox1
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox5
		}
	},
	groups = {dig_immediate=3, temp_pass = 1, heatable = 20},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		ncrafting.set_firing(pos, base_firing, firing_int)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length
		return ncrafting.fire_pottery(pos, "tech:clay_water_pot_unfired", "tech:clay_water_pot", base_firing)
	end,
})


--------------------------------------
--unfired storage pot (see storage for fired version)
minetest.register_node("tech:clay_storage_pot_unfired", {
	description = S("Clay Storage Pot (unfired)"),
	tiles = {
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png"
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
				{-0.375, -0.5, -0.375, 0.375, -0.375, 0.375},
				{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
				{-0.4375, -0.375, -0.4375, 0.4375, -0.25, 0.4375},
				{-0.4375, 0.25, -0.4375, 0.4375, 0.375, 0.4375},
				{-0.5, -0.25, -0.5, 0.5, 0.25, 0.5},
			}
		},
	groups = {dig_immediate=3, temp_pass = 1, heatable = 20},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		ncrafting.set_firing(pos, base_firing+5, firing_int)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length
		return ncrafting.fire_pottery(pos, "tech:clay_storage_pot_unfired", "tech:clay_storage_pot", base_firing+5)
	end,
})



--------------------------------------
--OIL LAMP

--convert fuel number to a string
local fuel_string = function(fuel)
   if not fuel or fuel < 1 then
      return S("Oil lamp (empty)")
   elseif fuel > 2159 then
      return S("Oil lamp (full)")
   elseif fuel < 200 then
      return S("Oil lamp (almost empty)")
   elseif fuel < 800 then
      return S("Oil lamp (1/4 full)")
   elseif fuel < 1600 then
      return S("Oil lamp (1/2 full)")
   elseif fuel < 2200 then
      return S("Oil lamp (3/4 full)")
   else
      return S("Oil lamp")
   end
end

--save usage into inventory, to prevent infinite supply
local on_dig_oil_lamp = function(pos, node, digger)
	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end

	local meta = minetest.get_meta(pos)
	local fuel = meta:get_int("fuel")

	local new_stack = ItemStack("tech:clay_oil_lamp_unlit")
	local stack_meta = new_stack:get_meta()
	stack_meta:set_int("fuel", fuel)
	stack_meta:set_string("description", fuel_string(fuel))


	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new_stack) then
		player_inv:add_item("main", new_stack)
	else
		minetest.add_item(pos, new_stack)
	end
end

--set saved fuel
local after_place_oil_lamp = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local stack_meta = itemstack:get_meta()
	local fuel = stack_meta:get_int("fuel")
	if not fuel then
	   fuel = 0
	end
	meta:set_int("fuel", fuel)
	meta:set_string("infotext", fuel_string(fuel))
end

--unfired oil clay lamp
minetest.register_node("tech:clay_oil_lamp_unfired", {
	description = S("Clay Oil Lamp (unfired)"),
	tiles = {
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png",
		"nodes_nature_clay.png"
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			--{-0.0625, -0.125, 0.25, 0.0625, 0.0625, 0.4375}, -- flame
			{-0.125, -0.5, -0.125, 0.125, -0.4375, 0.125}, -- bottom
			{-0.0625, -0.4375, -0.0625, 0.0625, -0.3125, 0.0625}, -- stand
			{-0.125, -0.3125, -0.125, 0.125, -0.125, 0.125}, -- body
			{-0.0625, -0.25, 0.125, 0.0625, -0.125, 0.25}, -- spout
			{-0.0625, -0.1875, -0.1875, 0.0625, -0.125, -0.125}, -- handle
			{-0.0625, -0.3125, -0.1875, 0.0625, -0.25, -0.125}, -- handle
			{-0.0625, -0.3125, -0.25, 0.0625, -0.125, -0.1875}, -- handle
		}
	},
	groups = {dig_immediate=3, temp_pass = 1, falling_node = 1, heatable = 20},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		ncrafting.set_firing(pos, base_firing, firing_int)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length
		return ncrafting.fire_pottery(pos, "tech:clay_oil_lamp_unfired", "tech:clay_oil_lamp_empty", base_firing)
	end,
})


--fired oil clay lamp
minetest.register_node("tech:clay_oil_lamp_unlit", {
	description = S("Clay Oil Lamp"),
	tiles = {
		"tech_oil_lamp_top.png",
		"tech_oil_lamp_bottom.png",
		"tech_oil_lamp_side.png",
		"tech_oil_lamp_side2.png",
		"tech_oil_lamp_front.png",
		"tech_oil_lamp_front.png"
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			--{-0.0625, -0.125, 0.25, 0.0625, 0.0625, 0.4375}, -- flame
			{-0.125, -0.5, -0.125, 0.125, -0.4375, 0.125}, -- bottom
			{-0.0625, -0.4375, -0.0625, 0.0625, -0.3125, 0.0625}, -- stand
			{-0.125, -0.3125, -0.125, 0.125, -0.125, 0.125}, -- body
			{-0.0625, -0.25, 0.125, 0.0625, -0.125, 0.25}, -- spout
			{-0.0625, -0.1875, -0.1875, 0.0625, -0.125, -0.125}, -- handle
			{-0.0625, -0.3125, -0.1875, 0.0625, -0.25, -0.125}, -- handle
			{-0.0625, -0.3125, -0.25, 0.0625, -0.125, -0.1875}, -- handle
		}
	},
	groups = {dig_immediate=3, pottery = 1, temp_pass = 1, falling_node = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
	floodable = true,
	on_flood = function(pos, oldnode, newnode)
		minetest.add_item(pos, ItemStack("tech:clay_oil_lamp_unlit 1"))
		return false
	end,
	on_dig = function(pos, node, digger)
		on_dig_oil_lamp(pos, node, digger)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_oil_lamp(pos, placer, itemstack, pointed_thing)
	end,
	on_ignite = function(pos, user)
	   local meta = minetest.get_meta(pos)
	   local fuel = meta:get_int("fuel")
	   if fuel and fuel > 0 then
	      minetest.swap_node(pos, {name = 'tech:clay_oil_lamp'})
	      minetest.registered_nodes["tech:clay_oil_lamp"].on_construct(pos)
	      meta:set_int("fuel", fuel)
	      meta:set_string("infotext", fuel_string(fuel))
	   end
	end,

	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		--hit it with oil to restore
		local ist_name = itemstack:get_name()
		local meta = minetest.get_meta(pos)
		local fuel = meta:get_int("fuel")
		if ist_name == "tech:vegetable_oil" then
		   if fuel and fuel < 1550 then
		      fuel = fuel + math.random(1450,1550)
		      meta:set_int("fuel", fuel)
		      meta:set_string("infotext",fuel_string(fuel))
		      local name = clicker:get_player_name()
		      if not minetest.is_creative_enabled(name) then
			 itemstack:take_item()
		      end
		      return itemstack
		   end
		end
	end,
})


--full oil clay lamp
minetest.register_node("tech:clay_oil_lamp", {
	description = S("Clay Oil Lamp (lit)"),
	tiles = {
		"tech_oil_lamp_top.png",
		"tech_oil_lamp_bottom.png",
		{
			    name = "tech_oil_lamp_side_animated.png",
			    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
		},
		{
					name = "tech_oil_lamp_side2_animated.png",
					animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
		},
		"tech_oil_lamp_front.png",
		"tech_oil_lamp_front.png"
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_medium,
	sunlight_propagates = true,
	light_source = 7,
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.125, 0.25, 0.0625, 0.0625, 0.4375}, -- flame
			{-0.125, -0.5, -0.125, 0.125, -0.4375, 0.125}, -- bottom
			{-0.0625, -0.4375, -0.0625, 0.0625, -0.3125, 0.0625}, -- stand
			{-0.125, -0.3125, -0.125, 0.125, -0.125, 0.125}, -- body
			{-0.0625, -0.25, 0.125, 0.0625, -0.125, 0.25}, -- spout
			{-0.0625, -0.1875, -0.1875, 0.0625, -0.125, -0.125}, -- handle
			{-0.0625, -0.3125, -0.1875, 0.0625, -0.25, -0.125}, -- handle
			{-0.0625, -0.3125, -0.25, 0.0625, -0.125, -0.1875}, -- handle
		}
	},
	groups = {dig_immediate=3, pottery = 1, temp_pass = 1, falling_node = 1, not_in_creative_inventory = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
	floodable = true,
	on_flood = function(pos, oldnode, newnode)
		minetest.add_item(pos, ItemStack("tech:clay_oil_lamp_unlit 1"))
		return false
	end,
	on_dig = function(pos, node, digger)
		on_dig_oil_lamp(pos, node, digger)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(5)
	end,
	on_timer =function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local fuel = meta:get_int("fuel")
		meta:set_string("infotext",fuel_string(fuel))
		if fuel < 1 then
			minetest.swap_node(pos, {name = "tech:clay_oil_lamp_unlit"})
			--minetest.check_for_falling(pos)
			return false
		else
			meta:set_int("fuel", fuel - 1)
			return true
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		-- to snuff it out
		local meta = minetest.get_meta(pos)
		local fuel = meta:get_int("fuel")
		minetest.swap_node(pos, {name = 'tech:clay_oil_lamp_unlit'})
		if fuel then
		   meta:set_int("fuel", fuel)
		   meta:set_string("infotext",fuel_string(fuel))
		end
		return itemstack
	end,
})


---------------------------------------
--Recipes

--
--Hand crafts (crafting spot)
--

--Pot from clay
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:clay_water_pot_unfired 1",
	items = {"nodes_nature:clay_wet 4"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay 4",
	items = {"tech:clay_water_pot_unfired 1"},
	level = 1,
	always_known = true,
})


--storage Pot from clay
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:clay_storage_pot_unfired 1",
	items = {"nodes_nature:clay_wet 6"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay 6",
	items = {"tech:clay_storage_pot_unfired 1"},
	level = 1,
	always_known = true,
})

--oil lamp
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:clay_oil_lamp_unfired 1",
	items = {"nodes_nature:clay_wet"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay",
	items = {"tech:clay_oil_lamp_unfired 1"},
	level = 1,
	always_known = true,
})

--Break up pots
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:broken_pottery",
	items = {"group:pottery"},
	level = 1,
	always_known = true,
})


-----------------------------------------------
--Register water stores
--source, nodename, nodename_empty, tiles, node_box, desc, groups

--clay pot with salt water
liquid_store.register_stored_liquid(
	"nodes_nature:salt_water_source",
	"tech:clay_water_pot_salt_water",
	"tech:clay_water_pot",
	{
		"tech_water_pot_water.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png"
	},
	{
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25}, -- NodeBox1
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox5
		}
	},
	"Clay Water Pot with Salt Water",
	{dig_immediate = 2})


--clay pot with freshwater
liquid_store.register_stored_liquid(
	"nodes_nature:freshwater_source",
	"tech:clay_water_pot_freshwater",
	"tech:clay_water_pot",
	{
		"tech_water_pot_water.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png"
	},
	{
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25}, -- NodeBox1
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox5
		}
	},
	S("Clay Water Pot with Freshwater"),
	{dig_immediate = 2})


--make freshwater Pot drinkable on click
minetest.override_item("tech:clay_water_pot_freshwater",{
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = clicker:get_meta()
		local thirst = meta:get_int("thirst")
		--only drink if thirsty
		if thirst < 100 then

			local water = 100 --you're skulling a whole bucket
			thirst = thirst + water
			if thirst > 100 then
				thirst = 100
			end

			--could add disease risk, but different sources have different risks
			--e.g. rain vs mud puddle

			meta:set_int("thirst", thirst)
			minetest.set_node(pos, {name = "tech:clay_water_pot"})
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.25})
		end
	end
})
