----------------------------------------------------------
--IRON WORKING



----------------------------------------------------------------------
--NODES

--Steps
--this is a simplified version of bloomery furnace method.
--leaves out steps that involve keeping a temporarily hot item in inventory,
--because that is annoying to code e.g. quenching and hammering hot metal

--1: Get ore
--2: crush ore into 'tech:crushed_iron_ore'
--3: roast 'tech:crushed_iron_ore' at wood fire heat into 'tech:roasted_iron_ore'
--4. powder into 'tech:roasted_iron_ore_powder'
--5. mix with x charcoal for 'tech:iron_smelting_mix'
--6. heat to smelt temp to create iron_slag_mix
--7. keep hot enough for X minutes (and a drainage space), for molten slag to run off.
--8. leaves behind small iron bloom (plus cooling slag nearby)
--9. hammer bloom into ingots
--10. make iron anvil out of many ingots
--11. make iron tools at anvil



--------------------------------------

--pre-roast and smelting functions
local function set_roast(pos, length, interval)
	-- and firing count
	local meta = minetest.get_meta(pos)
	meta:set_int("roast", length)
	--check heat interval
	minetest.get_node_timer(pos):start(interval)
end



local function roast(pos, selfname, name, length, heat, smelt)
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
		--need to transfer heat to smelt
		--for others doesn't matter
		if name == "tech:iron_and_slag" then
			local temp = meta:get_float("temp")
			minetest.set_node(pos, {name = name})
			meta:set_float("temp", temp)
			minetest.check_for_falling(pos)
			return false
		else
			minetest.set_node(pos, {name = name})
			minetest.check_for_falling(pos)
			return false
		end
  elseif temp < fire_temp then
    --not lit yet
    return true
	elseif temp >= fire_temp then
    if smelt then
      --smelting requires release of slag
      --position below
      local posb = {
        {x = pos.x, y = pos.y - 1, z = pos.z},
        {x = pos.x +1, y = pos.y - 1, z = pos.z},
        {x = pos.x -1, y = pos.y - 1, z = pos.z},
        {x = pos.x, y = pos.y - 1, z = pos.z +1},
        {x = pos.x +1, y = pos.y - 1, z = pos.z +1},
        {x = pos.x -1, y = pos.y - 1, z = pos.z +1},
        {x = pos.x, y = pos.y - 1, z = pos.z -1},
        {x = pos.x +1, y = pos.y - 1, z = pos.z -1},
        {x = pos.x -1, y = pos.y - 1, z = pos.z -1}
      }
      local cn = 0
      for _, p in pairs(posb) do
        local n = minetest.get_node(p).name
				--must drain into air or other slag mix
        if n == 'air' or n == 'climate:air_temp' or n == 'tech:iron_and_slag' then
					minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 8, gain = 0.1})
					if n ~= 'tech:iron_and_slag' then
						minetest.set_node(p, {name = 'tech:molten_slag_flowing'})
						--only drain to one place (i.e. so they all drain the same amount)
						cn = cn + 1
						break
					else
						--undo progress of the one it is draining into.
						local meta_under = minetest.get_meta(p)
						local roast_under = meta_under:get_int("roast")
						--only if still has room (i.e. can't infinitely fill it)
						if roast_under < 100 then
							meta_under:set_int("roast", roast_under + 1)
							--only drain to one place (i.e. so they all drain the same amount)
							cn = cn + 1
							break
						end
					end
        end
      end
      --only makes smelt progress if able to drain
      if cn > 0 then
        --do firing
        meta:set_int("roast", roast - 1)
        return true
      else
				--try again later
        return true
      end

    else
      --do non-smelting firing
      meta:set_int("roast", roast - 1)
      return true
    end
  end

end






----------------------------

--crushed_iron_ore
--raw ore broken into gravel
minetest.register_node("tech:crushed_iron_ore", {
	description = "Crushed Iron Ore",
	tiles = {"tech_crushed_iron_ore.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1, heatable =10},
	sounds = nodes_nature.node_sound_gravel_defaults(),
  on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		set_roast(pos, 10, 10)
	end,
	on_timer = function(pos, elapsed)
    --selfname, finished product, length, heat, smelt
    return roast(pos, "tech:crushed_iron_ore", "tech:roasted_iron_ore", 10, 300, false)
	end,
})

--recipe
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:crushed_iron_ore",
	items = {'nodes_nature:ironstone_boulder 2'},
	level = 1,
	always_known = true,
})


--roasted_iron_ore
--crushed ore pre-roasted
minetest.register_node("tech:roasted_iron_ore", {
	description = "Roasted Iron Ore",
	tiles = {"tech_roasted_iron_ore.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1},
	sounds = nodes_nature.node_sound_gravel_defaults(),
})

--roasted iron ore powder
--more smelting prep
minetest.register_node("tech:roasted_iron_ore_powder", {
	description = "Roasted Iron Ore Powder",
	tiles = {"tech_roasted_iron_ore_powder.png"},
	stack_max = minimal.stack_max_bulky *4,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1},
	sounds = nodes_nature.node_sound_gravel_defaults(),
})

--recipe
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:roasted_iron_ore_powder",
	items = {'tech:roasted_iron_ore 2'},
	level = 1,
	always_known = true,
})

--iron smelting mix
--mix of charcoal blocks and roasted iron ore powder, ready for smelting
--initial heating turns it into slag and iron mix, which continues actual smelt
minetest.register_node("tech:iron_smelting_mix", {
	description = "Iron Smelting Mix",
	tiles = {"tech_iron_smelting_mix.png"},
	stack_max = minimal.stack_max_bulky *4,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1, heatable = 20},
	sounds = nodes_nature.node_sound_gravel_defaults(),
  on_construct = function(pos)
    --length(i.e. difficulty of firing), interval for checks (speed)
    set_roast(pos, 2, 10)
  end,
  on_timer = function(pos, elapsed)
    --finished product, length, heat, smelt
    return roast(pos, "tech:iron_smelting_mix", "tech:iron_and_slag", 2, 1350, false)
  end,
})

--recipe
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:iron_smelting_mix",
	items = {'tech:roasted_iron_ore_powder', 'tech:charcoal_block 4'},
	level = 1,
	always_known = true,
})

---------------------
--save usage into inventory, to prevent infinite supply
local on_dig_iron_and_slag = function(pos, node, digger)
	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end

	local meta = minetest.get_meta(pos)
	local roast = meta:get_int("roast")

	local new_stack = ItemStack("tech:iron_and_slag")
	local stack_meta = new_stack:get_meta()
	stack_meta:set_int("roast", roast)


	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new_stack) then
		player_inv:add_item("main", new_stack)
	else
		minetest.add_item(pos, new_stack)
	end
end

--set saved
local after_place_iron_and_slag = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local stack_meta = itemstack:get_meta()
	local roast = stack_meta:get_int("roast")
	if roast >0 then
		meta:set_int("roast", roast)
	end
end

--iron and slag
--unseperated iron and impurities
minetest.register_node("tech:iron_and_slag", {
	description = "Iron and Slag",
	tiles = {"tech_iron_and_slag.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	groups = {cracky = 3, crumbly = 1, falling_node = 1, heatable = 20},
	sounds = nodes_nature.node_sound_stone_defaults(),
  on_construct = function(pos)
    --length(i.e. difficulty of firing), interval for checks (speed)
    set_roast(pos, 50, 10)
  end,
  on_timer = function(pos, elapsed)
    --finished product, length, heat, smelt
    return roast(pos, "tech:iron_and_slag", "tech:iron_bloom", 50, 1350, true)
  end,

	on_dig = function(pos, node, digger)
		on_dig_iron_and_slag(pos, node, digger)
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_iron_and_slag(pos, placer, itemstack, pointed_thing)
	end,
})


--------------------
--iron bloom
--smelted iron seperated from bulk of slag, but still not useable
minetest.register_node("tech:iron_bloom", {
	description = "Iron Bloom",
	tiles = {"tech_iron_and_slag.png"},
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-0.3, -0.5, -0.3, 0.3, -0.1, 0.3},
  },
	stack_max = minimal.stack_max_bulky * 4,
	paramtype = "light",
	groups = {cracky = 3, falling_node = 1, oddly_breakable_by_hand = 2, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
})


----------------
--iron ingot
--iron seperated from remainder of slag, finished product
minetest.register_node("tech:iron_ingot", {
	description = "Iron Ingot",
	tiles = {"tech_iron.png"},
  drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.2, 0.1, -0.3, 0.2},
	},
	stack_max = minimal.stack_max_bulky * 8,
	paramtype = "light",
  paramtype2 = "facedir",
	groups = {falling_node = 1, dig_immediate=3, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
})

--recipe
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:iron_ingot",
	items = {'tech:iron_bloom 2'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "anvil",
	output = "tech:iron_ingot",
	items = {'tech:iron_bloom 2'},
	level = 1,
	always_known = true,
})

-----------------
--slag
--waste product (cooled)
minetest.register_node("tech:slag", {
	description = "Slag",
	tiles = {"tech_iron_and_slag.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	groups = {cracky = 3, falling_node = 1, crumbly = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
})

--molten slag
local lava_light = 6
local lava_temp_effect = 6
local lava_heater = 1350

minetest.register_node("tech:molten_slag_source", {
	description = "Molten Slag",
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
	liquid_alternative_flowing = "tech:molten_slag_flowing",
	liquid_alternative_source = "tech:molten_slag_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {igniter = 1, temp_effect = 1},
  --cooling
  on_construct = function(pos)
    minetest.get_node_timer(pos):start(10)
  end,
  on_timer = function(pos, elapsed)
    if math.random()>0.87 then
			minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 8, gain = 0.1})
      minetest.set_node(pos, {name = 'tech:slag'})
			minetest.check_for_falling(pos)
      return false
    else
      return true
    end
  end,
})

minetest.register_node("tech:molten_slag_flowing", {
	description = "Flowing Molten Slag",
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
	liquid_alternative_flowing = "tech:molten_slag_flowing",
	liquid_alternative_source = "tech:molten_slag_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {igniter = 1,	not_in_creative_inventory = 1, temp_effect = 1, temp_pass = 1},
  --cooling
  on_construct = function(pos)
    minetest.get_node_timer(pos):start(1)
  end,
  on_timer = function(pos, elapsed)
    if math.random()>0.95 then
			minetest.sound_play("nodes_nature_cool_lava",	{pos = pos, max_hear_distance = 8, gain = 0.1})
      minetest.set_node(pos, {name = 'tech:slag'})
			minetest.check_for_falling(pos)
      return false
    else
      return true
    end
  end,
})


------------------------------------------
--Iron Fittings
-- a catch all item to use in crafts
--e.g. bolts, nails, locks, screws, hinges
--metal content equivalent to enough hinges for one door
minetest.register_craftitem("tech:iron_fittings", {
	description = "Iron Fittings",
	inventory_image = "tech_iron_fittings.png",
	stack_max = minimal.stack_max_medium *2,
})


crafting.register_recipe({
	type = "anvil",
	output = "tech:iron_fittings 8",
	items = {'tech:iron_ingot'},
	level = 1,
	always_known = true,
})
