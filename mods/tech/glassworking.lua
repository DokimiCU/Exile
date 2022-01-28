----------------------------------------------------------
--GLASS WORKING


--[[
>>> making glass
1800C will fuse sand itself.

Soda lime glass
Soda ash. - melting agent (1200C)
Sand -vitrifying
Calcium - stabilizing (potentially in the sand)

Two types of glass - green and clear

Green - made from ash and sand. Ash contains potash/soda ash and lime, but also iron impurities that color the glass green.
	Good for things where clarity doesn't matter, like bottler
Clear - made from refined potash (pearl ash), lime and sand. More expensive, as have to work to refine potash. Good for windows.

Potash - in this case get from wood ash. 
Process:
	1. Soak in water
	2. Put water into pot
	3. Evaporate water to get potash (still with impurities, makes green glass)
	4. Roast potash in kiln to get pearl ash

>>>make things from glass:
Reheat so it is workable, then shape.
Small glass workshop furnace.

Vessels: glass blowing

Panes: cast on to an iron tray, then polished. Only get small panes.


]]
-----------------------------------------------------------

-- Pre-roast  functions
local function set_roast(pos, length, interval)
	-- and firing count
	local meta = minetest.get_meta(pos)
	meta:set_int("roast", length)
	--check heat interval
	minetest.get_node_timer(pos):start(interval)
end



local function roast(pos, selfname, name, heat)
	local meta = minetest.get_meta(pos)
	local roast = meta:get_int("roast")

	--check if wet stop
	if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
		return true
	end

	--exchange accumulated heat
	climate.heat_transfer(pos, selfname)

	--check if above firing temp
	local temp = climate.get_point_temp(pos)
	local fire_temp = heat

	if roast <= 0 then
		--finished firing
    minetest.set_node(pos, {name = name})
    minetest.check_for_falling(pos)
    return false
  elseif temp < fire_temp then
    --not lit yet
    return true
	elseif temp >= fire_temp then
    --do firing
    meta:set_int("roast", roast - 1)
    return true
  end

end

-- Pane Casting function
local function pane_cast_check(pos)

	local pbelow = {x = pos.x, y = pos.y - 1, z = pos.z}
	if minetest.get_node(pbelow).name == "tech:pane_tray" and climate.get_point_temp(pos) >= 1800 then -- Melting temperature of glass is approx 1800 C
		local name = minetest.get_node(pos).name
		if name == "tech:green_glass_ingot" then
			minetest.set_node(pos, {name = "air"})
			minetest.set_node(pbelow, {name = "tech:pane_tray_green"})
			minetest.sound_play("tech_boil", {pos = pos, max_hear_distance = 8, gain = 1})
			return true
		elseif name == "tech:clear_glass_ingot" then
			minetest.set_node(pos, {name = "air"})
			minetest.set_node(pbelow, {name = "tech:pane_tray_clear"})
			minetest.sound_play("tech_boil", {pos = pos, max_hear_distance = 8, gain = 1})
			return true
		end
	end
	return false
end


-- Green glass

-- Mix - sand and ash 50/50
minetest.register_node("tech:green_glass_mix",
{
	description = "Green Glass Sand Mix",
	tiles = {"tech_sand_mix.png"},
	stack_max = minimal.stack_max_bulky *4,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1, heatable = 20},
	sounds = nodes_nature.node_sound_sand_defaults(),
  	on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		set_roast(pos, 40, 10)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length, heat, smelt
		return roast(pos, "tech:green_glass_mix", "tech:green_glass_ingot", 1500)
	end,
})

-- Finished Products
-- Glass ingot - 1/4 block
minetest.register_node("tech:green_glass_ingot", {
	description = "Green Glass Ingot",
	tiles = {"tech_green_glass.png"},
	inventory_image = "tech_glass_ingot_green_icon.png",
  	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.1, 0.3},
	},
	stack_max = minimal.stack_max_bulky * 4,
	paramtype = "light",
	groups = {cracky = 3, oddly_breakable_by_hand = 3, falling_node = 1, temp_pass = 1, heatable = 20},
	sounds = nodes_nature.node_sound_glass_defaults(),
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	on_construct = function(pos)
	   minetest.get_node_timer(pos):start(20)
	end,
	on_timer = function(pos)
	   if pane_cast_check(pos) then
	      return false -- end the timer
	   else
	      return true
	   end
	end,
})

-- Crafts
-- Mix sand and ash 50/50
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:green_glass_mix 2",
	items = {'tech:wood_ash_block 1', 'nodes_nature:sand 1'},
	level = 1,
	always_known = true,
})

-- Clear Glass

-- Potash

minetest.register_node("tech:potash_block", {
	description = "Potash Block",
	tiles = {"tech_potash.png"},
	stack_max = minimal.stack_max_bulky,
	groups = {crumbly = 3, falling_node = 1, fertilizer = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
})


minetest.register_node("tech:potash", {
	description = "Potash",
	tiles = {"tech_potash.png"},
	stack_max = minimal.stack_max_bulky *2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	groups = {crumbly = 3, falling_node = 1, fertilizer = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
})

local post_alpha = 140

-- Potash solution (More like lye in this case)
minetest.register_node("tech:potash_source", {
  	description = "Potash Solution Source",
  	drawtype = "liquid",
  	tiles = {"tech_potash.png"},
	--	use_texture_alpha = "blend",
  	paramtype = "light",
  	walkable = false,
  	pointable = false,
  	diggable = false,
  	buildable_to = true,
  	is_ground_content = false,
  	drop = "",
  	drowning = 1,
  	liquidtype = "source",
  	liquid_alternative_flowing = "tech:potash_flowing",
  	liquid_alternative_source = "tech:potash_source",
  	liquid_viscosity = 1,
	liquid_range = 2,
	liquid_renewable = false,
	post_effect_color = {a = post_alpha, r = 30, g = 60, b = 90},
  	groups = {water = 2, cools_lava = 1, puts_out_fire = 1},
  	sounds = nodes_nature.node_sound_water_defaults(),
  })


  minetest.register_node("tech:potash_flowing", {
  	description = "Flowing Potash Solution",
  	drawtype = "flowingliquid",
  	tiles = {"tech_potash.png"},
  	special_tiles = {"tech_potash.png"},
	use_texture_alpha = "blend",
  	paramtype = "light",
  	paramtype2 = "flowingliquid",
  	walkable = false,
  	pointable = false,
  	diggable = false,
  	buildable_to = true,
  	is_ground_content = false,
  	drop = "",
  	drowning = 1,
  	liquidtype = "flowing",
		liquid_range = 2,
  	liquid_alternative_flowing = "tech:potash_flowing",
  	liquid_alternative_source = "tech:potash_source",
  	liquid_viscosity = 1,
		liquid_renewable = false,
  	post_effect_color = {a = post_alpha, r = 30, g = 60, b = 90},
  	groups = {water = 2, not_in_creative_inventory = 1, puts_out_fire = 1, cools_lava = 1},
  	sounds = nodes_nature.node_sound_water_defaults(),
  })

-- Solution in pot
liquid_store.register_stored_liquid(
	"tech:potash_source",
	"tech:clay_water_pot_potash",
	"tech:clay_water_pot",
	{
		"tech_water_pot_potash.png",
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
	"Clay Water Pot with Potash Solution",
	{dig_immediate = 2})

liquid_store.register_liquid("tech:potash_source", "tech:potash_flowing", false)

-- Soak Ash
local function potash_soak_check(pos, node)

	local p_water = minetest.find_node_near(pos, 1, {"nodes_nature:freshwater_source"})
	if p_water then
		local p_name = minetest.get_node(p_water).name
		--check water type. Salt wouldn't work probably
		local water_type = minetest.get_item_group(p_name, "water")
  		if water_type == 1 then
  			minetest.set_node(pos, {name = "tech:potash_source"})
        		minetest.set_node(p_water, {name = "air"})
        		minetest.sound_play("tech_boil", {pos = pos, max_hear_distance = 8, gain = 1})
  		elseif water_type == 2 then
  			return false
  		end
	end
end

minetest.register_abm(
{
	label = "Ash Dissolve",
	nodenames = {"tech:wood_ash_block"},
	neighbours = {"nodes_nature:freshwater_source"},
	interval = 15,
	chance = 1,
	action = function(...)
		potash_soak_check(...)
	end
})

-- Evaporation result; water is gone, just potash left

minetest.register_node("tech:dry_potash_pot", {
	description = "Clay Water Pot With Potash",
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
	groups = {dig_immediate = 3, pottery = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
	drop = {
		max_items = 2,
		items = {
			{items = {"tech:potash"}},
			{items = {"tech:clay_water_pot"}},
		}
	}

})


-- Potash evaporation
minetest.override_item("tech:clay_water_pot_potash",
{
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(10,20))
	end,
	on_timer = function(pos, elapsed)
		if climate.get_point_temp(pos) > 100 then
			minetest.set_node(pos, {name = "tech:dry_potash_pot"})
			return false
		end

		return true
	end,
	
})

-- The actual glassmaking... finally

-- Mix - sand, potash and lime
minetest.register_node("tech:clear_glass_mix",
{
	description = "Clear Glass Sand Mix",
	tiles = {"tech_sand_mix.png"},
	stack_max = minimal.stack_max_bulky *4,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1, heatable = 20},
	sounds = nodes_nature.node_sound_sand_defaults(),
  	on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		set_roast(pos, 40, 10)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length, heat, smelt
		return roast(pos, "tech:clear_glass_mix", "tech:clear_glass_ingot", 1500)
	end,
})

-- Finished Products
-- Glass ingot - 1/4 block
minetest.register_node("tech:clear_glass_ingot", {
	description = "Clear Glass Ingot",
	tiles = {"tech_clear_glass.png"},
	inventory_image = "tech_glass_ingot_clear_icon.png",
  	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.1, 0.3},
	},
	stack_max = minimal.stack_max_bulky * 4,
	paramtype = "light",
	groups = {cracky = 3, oddly_breakable_by_hand = 3, falling_node = 1, temp_pass = 1, heatable = 20},
	sounds = nodes_nature.node_sound_glass_defaults(),
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	on_construct = function(pos)
	   minetest.get_node_timer(pos):start(20)
	end,
	on_timer = function(pos)
	   if pane_cast_check(pos) then
	      return false -- end the timer
	   else
	      return true
	   end
	end,
})

-- Crafts
-- Mix sand and potash and lime approx 70/15/15 (1/2 + 1/4 sand, 1/8 pearlash, 1/8 lime )
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:clear_glass_mix 8",
	items = {'tech:potash 1', 'tech:quicklime 1', 'nodes_nature:sand 6'},
	level = 1,
	always_known = true,
})

-- Pane casting tray - heat up a glass ingot above it to cast a pane
minetest.register_node("tech:pane_tray",
{
	description = "Pane Casting Tray",
	tiles = {"tech_iron.png"},
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
			{-0.5, -0.4, -0.5, -0.4, -0.3, 0.5},
			{0.5, -0.4, -0.5, 0.4, -0.3, 0.5},
			{-0.5, -0.4, -0.5, 0.5, -0.3, -0.4},
			{-0.5, -0.4, 0.5, 0.5, -0.3, 0.4}
		}
		
	},
	stack_max = minimal.stack_max_bulky * 2,
	paramtype2 = "facedir",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sunlight_propagates = true,
})

-- Trays with glass panes
minetest.register_node("tech:pane_tray_green",
{
	description = "Pane Casting Tray With Green Glass Pane",
	tiles = {"tech_tray_green.png", "tech_iron.png", "tech_iron.png", "tech_iron.png", "tech_iron.png", "tech_iron.png"},
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
			{-0.5, -0.4, -0.5, -0.4, -0.3, 0.5},
			{0.5, -0.4, -0.5, 0.4, -0.3, 0.5},
			{-0.5, -0.4, -0.5, 0.5, -0.3, -0.4},
			{-0.5, -0.4, 0.5, 0.5, -0.3, 0.4}
		}
		
	},
	stack_max = minimal.stack_max_bulky * 2,
	paramtype2 = "facedir",
	groups = {dig_immediate = 3},
	sunlight_propagates = true,
	on_dig = function(pos, node, digger)
	   digger:get_inventory():add_item("main", "tech:pane_green")
	   minetest.swap_node(pos, {name = "tech:pane_tray"})
	end,

})

minetest.register_node("tech:pane_tray_clear",
{
	description = "Pane Casting Tray With Clear Glass Pane",
	tiles = {"tech_tray_clear.png", "tech_iron.png", "tech_iron.png", "tech_iron.png", "tech_iron.png", "tech_iron.png"},
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
			{-0.5, -0.4, -0.5, -0.4, -0.3, 0.5},
			{0.5, -0.4, -0.5, 0.4, -0.3, 0.5},
			{-0.5, -0.4, -0.5, 0.5, -0.3, -0.4},
			{-0.5, -0.4, 0.5, 0.5, -0.3, 0.4}
		}
		
	},
	stack_max = minimal.stack_max_bulky * 2,
	paramtype2 = "facedir",
	groups = {dig_immediate = 3},
	sunlight_propagates = true,
	on_dig = function(pos, node, digger)
	   digger:get_inventory():add_item("main", "tech:pane_clear")
	   minetest.swap_node(pos, {name = "tech:pane_tray"})
	end,

})

-- Crafts
crafting.register_recipe({
	type = "anvil",
	output = "tech:pane_tray",
	items = {'tech:iron_ingot 2'},
	level = 1,
	always_known = true,
})

-- Stuff made from glass

-- Panes - raw, cast from glass with no framing
minetest.register_node("tech:pane_green",
{
	description = "Green Glass Pane",
	tiles = {"tech_green_glass.png"},
	inventory_image = "tech_green_pane_icon.png",
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {{-1/2 + 1/10, -1/2, -1/32, 1/2 - 1/10, 1/2 - 2/10, 1/32}}, -- Modified from xpanes
	},
	stack_max = minimal.stack_max_medium * 2,
	paramtype2 = "facedir",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
})

minetest.register_node("tech:pane_clear",
{
	description = "Clear Glass Pane",
	tiles = {"tech_clear_glass.png"},
	inventory_image = "tech_clear_pane_icon.png",
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {{-1/2 + 1/10, -1/2, -1/32, 1/2 - 1/10, 1/2 - 2/10, 1/32}}, -- Modified from xpanes	
	},
	stack_max = minimal.stack_max_medium * 2,
	paramtype2 = "facedir",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
})

-- Windows - glass panes with framing

minetest.register_node("tech:window_green",
{
	description = "Green Glass Window",
	tiles = {"tech_oiled_wood.png", "tech_oiled_wood.png", "tech_oiled_wood.png", "tech_oiled_wood.png", "tech_green_glass_window.png", "tech_green_glass_window.png"},
	inventory_image = "tech_green_glass_window.png^[noalpha",
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/32, 1/2, 1/2, 1/32}}, -- From xpanes
	},
	stack_max = minimal.stack_max_medium * 2,
	paramtype2 = "facedir",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
})

minetest.register_node("tech:window_clear",
{
	description = "Clear Glass Window",
	tiles = {"tech_oiled_wood.png", "tech_oiled_wood.png", "tech_oiled_wood.png", "tech_oiled_wood.png", "tech_clear_glass_window.png", "tech_clear_glass_window.png"},
	inventory_image = "tech_clear_glass_window.png^[noalpha",
	drawtype = "nodebox",
	node_box = 
	{
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/32, 1/2, 1/2, 1/32}}, -- From xpanes
	},
	stack_max = minimal.stack_max_medium * 2,
	paramtype2 = "facedir",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
})

-- Windows from oiled wood frames and glass panes
crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:window_green 4",
	items = {'group:log', 'tech:vegetable_oil', 'tech:pane_green 4'},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:window_clear 4",
	items = {'group:log', 'tech:vegetable_oil', 'tech:pane_clear 4'},
	level = 1,
	always_known = true,
})

-- Glass Vessels
-- More portable liquid storage than clay pots
-- Need inventory images, otherwise clear glass ones will be invisible

minetest.register_node("tech:glass_bottle_green", {
	description = "Green Glass Bottle",
	tiles = {"tech_green_glass.png"},
	inventory_image = "tech_bottle_green_icon.png",
	drawtype = "mesh",
	mesh = "tech_bottle.obj",
	stack_max = minimal.stack_max_bulky * 2,
	paramtype = "light",
	liquids_pointable = true,
	sunlight_prpagates = true,
	on_use = function(itemstack, user, pointed_thing)
		return liquid_store.on_use_empty_bucket(itemstack, user, pointed_thing)
	end,
		--collect rain water
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(30,60))
	end,
	groups = {dig_immediate = 2, pottery = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
	use_texture_alpha = "blend",
	selection_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
})

minetest.register_node("tech:glass_bottle_clear", {
	description = "Clear Glass Bottle",
	tiles = {"tech_clear_glass.png"},
	inventory_image = "tech_bottle_clear_icon.png",
	drawtype = "mesh",
	mesh = "tech_bottle.obj",
	stack_max = minimal.stack_max_bulky * 2,
	paramtype = "light",
	liquids_pointable = true,
	sunlight_prpagates = true,
	on_use = function(itemstack, user, pointed_thing)
		return liquid_store.on_use_empty_bucket(itemstack, user, pointed_thing)
	end,
		--collect rain water
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(30,60))
	end,
	groups = {dig_immediate = 2, pottery = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
	use_texture_alpha = "blend",
	selection_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},

})

-- Crafting
-- Blown from glass
-- For simplicity, crafts use charcoal as an ingredient, assuming its used for fuel somehow

crafting.register_recipe({
	type = "glass_furnace",
	output = "tech:glass_bottle_green",
	items = {"tech:green_glass_ingot", "tech:charcoal"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "glass_furnace",
	output = "tech:glass_bottle_clear",
	items = {"tech:clear_glass_ingot", "tech:charcoal"},
	level = 1,
	always_known = true,
})


-- Water stores for the jars
-- Salt Water
liquid_store.register_stored_liquid(
	"nodes_nature:salt_water_source",
	"tech:glass_bottle_green_saltwater",
	"tech:glass_bottle_green",
	{
		"tech_bottle_green_water.png"
	},
	{
		type = "fixed",
		fixed = 
		{
			{-0.2, -0.5, -0.2, 0.2, -0.4, 0.2}, -- base
			{-0.3, -0.5, -0.2, -0.2, 0.2, 0.2}, -- z-wall
			{0.3, -0.5, 0.2, 0.2, 0.2, -0.2}, -- z-wall
			{-0.3, -0.5, -0.3, 0.3, 0.2, -0.2}, --x-wall
			{0.3, -0.5, 0.3, -0.3, 0.2, 0.2}, --x-wall
			{-0.3, 0.2, -0.3, -0.1, 0.3, 0.3}, -- top
			{0.3, 0.2, 0.3, 0.1, 0.3, -0.3}, -- top
			{0.1, 0.2, 0.3, -0.1, 0.3, 0.1}, -- top
			{-0.1, 0.2, -0.3, 0.1, 0.3, -0.1}, -- top
			
			{-0.2, 0.3, -0.2, -0.1, 0.5, 0.2}, -- lip
			{0.2, 0.3, 0.2, 0.1, 0.5, -0.2}, -- lip
			{0.1, 0.3, 0.2, -0.1, 0.5, 0.1}, -- lip
			{0.1, 0.3, -0.2, -0.1, 0.5, -0.1}, -- lip
		}
	},
	"Green Glass Bottle With Salt Water",
	{dig_immediate = 2})

minetest.override_item("tech:glass_bottle_green_saltwater",
{
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	stack_max = minimal.stack_max_bulky * 2,
	drawtype = "mesh",
	mesh = "tech_bottle_liquid.obj",
	selection_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	inventory_image = "tech_bottle_green_icon.png",
})

liquid_store.register_stored_liquid(
	"nodes_nature:salt_water_source",
	"tech:glass_bottle_clear_saltwater",
	"tech:glass_bottle_clear",
	{
		"tech_bottle_clear_water.png"
	},
	{
		type = "fixed",
		fixed = 
		{
			{-0.2, -0.5, -0.2, 0.2, -0.4, 0.2}, -- base
			{-0.3, -0.5, -0.2, -0.2, 0.2, 0.2}, -- z-wall
			{0.3, -0.5, 0.2, 0.2, 0.2, -0.2}, -- z-wall
			{-0.3, -0.5, -0.3, 0.3, 0.2, -0.2}, --x-wall
			{0.3, -0.5, 0.3, -0.3, 0.2, 0.2}, --x-wall
			{-0.3, 0.2, -0.3, -0.1, 0.3, 0.3}, -- top
			{0.3, 0.2, 0.3, 0.1, 0.3, -0.3}, -- top
			{0.1, 0.2, 0.3, -0.1, 0.3, 0.1}, -- top
			{-0.1, 0.2, -0.3, 0.1, 0.3, -0.1}, -- top
			
			{-0.2, 0.3, -0.2, -0.1, 0.5, 0.2}, -- lip
			{0.2, 0.3, 0.2, 0.1, 0.5, -0.2}, -- lip
			{0.1, 0.3, 0.2, -0.1, 0.5, 0.1}, -- lip
			{0.1, 0.3, -0.2, -0.1, 0.5, -0.1}, -- lip
		}
	},
	"Clear Glass Bottle With Salt Water",
	{dig_immediate = 2})

minetest.override_item("tech:glass_bottle_clear_saltwater",
{
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	stack_max = minimal.stack_max_bulky * 2,
	drawtype = "mesh",
	mesh = "tech_bottle_liquid.obj",
	selection_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	inventory_image = "tech_bottle_clear_icon.png",
})


liquid_store.register_stored_liquid(
	"nodes_nature:freshwater_source",
	"tech:glass_bottle_green_freshwater",
	"tech:glass_bottle_green",
	{
		"tech_bottle_green_water.png"
	},
	{
		type = "fixed",
		fixed = 
		{
			{-0.2, -0.5, -0.2, 0.2, -0.4, 0.2}, -- base
			{-0.3, -0.5, -0.2, -0.2, 0.2, 0.2}, -- z-wall
			{0.3, -0.5, 0.2, 0.2, 0.2, -0.2}, -- z-wall
			{-0.3, -0.5, -0.3, 0.3, 0.2, -0.2}, --x-wall
			{0.3, -0.5, 0.3, -0.3, 0.2, 0.2}, --x-wall
			{-0.3, 0.2, -0.3, -0.1, 0.3, 0.3}, -- top
			{0.3, 0.2, 0.3, 0.1, 0.3, -0.3}, -- top
			{0.1, 0.2, 0.3, -0.1, 0.3, 0.1}, -- top
			{-0.1, 0.2, -0.3, 0.1, 0.3, -0.1}, -- top
			
			{-0.2, 0.3, -0.2, -0.1, 0.5, 0.2}, -- lip
			{0.2, 0.3, 0.2, 0.1, 0.5, -0.2}, -- lip
			{0.1, 0.3, 0.2, -0.1, 0.5, 0.1}, -- lip
			{0.1, 0.3, -0.2, -0.1, 0.5, -0.1}, -- lip
		}
	},
	"Green Glass Bottle With Fresh Water",
	{dig_immediate = 2})

minetest.override_item("tech:glass_bottle_green_freshwater",
{
	drawtype = "mesh",
	mesh = "tech_bottle_liquid.obj",
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	stack_max = minimal.stack_max_bulky * 2,
	selection_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	inventory_image = "tech_bottle_green_icon.png",
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
			minetest.set_node(pos, {name = "tech:glass_bottle_green"})
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.25})
		end
	end

})


liquid_store.register_stored_liquid(
	"nodes_nature:freshwater_source",
	"tech:glass_bottle_clear_freshwater",
	"tech:glass_bottle_clear",
	{
		"tech_bottle_clear_water.png"
	},
	{
		type = "fixed",
		fixed = 
		{
			{-0.2, -0.5, -0.2, 0.2, -0.4, 0.2}, -- base
			{-0.3, -0.5, -0.2, -0.2, 0.2, 0.2}, -- z-wall
			{0.3, -0.5, 0.2, 0.2, 0.2, -0.2}, -- z-wall
			{-0.3, -0.5, -0.3, 0.3, 0.2, -0.2}, --x-wall
			{0.3, -0.5, 0.3, -0.3, 0.2, 0.2}, --x-wall
			{-0.3, 0.2, -0.3, -0.1, 0.3, 0.3}, -- top
			{0.3, 0.2, 0.3, 0.1, 0.3, -0.3}, -- top
			{0.1, 0.2, 0.3, -0.1, 0.3, 0.1}, -- top
			{-0.1, 0.2, -0.3, 0.1, 0.3, -0.1}, -- top
			
			{-0.2, 0.3, -0.2, -0.1, 0.5, 0.2}, -- lip
			{0.2, 0.3, 0.2, 0.1, 0.5, -0.2}, -- lip
			{0.1, 0.3, 0.2, -0.1, 0.5, 0.1}, -- lip
			{0.1, 0.3, -0.2, -0.1, 0.5, -0.1}, -- lip
		}
	},
	"Clear Glass Bottle With Fresh Water",
	{dig_immediate = 2})

minetest.override_item("tech:glass_bottle_clear_freshwater",
{
	drawtype = "mesh",
	mesh = "tech_bottle_liquid.obj",
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	stack_max = minimal.stack_max_bulky * 2,
	selection_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	inventory_image = "tech_bottle_clear_icon.png",
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
			minetest.set_node(pos, {name = "tech:glass_bottle_clear"})
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.25})
		end
	end

})
