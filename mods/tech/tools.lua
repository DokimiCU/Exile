------------------------------------
--TOOL CRAFTS

--[[
Tool values based on multipliers from hand values
Tools can dig even unsuitable types, if you would use it if you were desperate.
Tools get increased wear on unsuitable tasks (e.g. chopping wood with a sword would ruin the sword)
Therefore many tools can be used by the player as multi-purpose,
which should be useful given the limits on resources and space they face.


]]


local base_use = 500
local base_punch_int = minimal.hand_punch_int

-----------------------------------

--Till soil
local function till_soil(itemstack, placer, pointed_thing, uses)
	--agriculture
	if pointed_thing.type ~= "node" then
		return
	end

	local under = minetest.get_node(pointed_thing.under)
	-- am I clicking on something with existing on_rightclick function?
	local def = minetest.registered_nodes[under.name]
	if def and def.on_rightclick then
		return def.on_rightclick(pointed_thing.under, under, placer, itemstack)
	end

	local p = {x=pointed_thing.under.x, y=pointed_thing.under.y+1, z=pointed_thing.under.z}
	local above = minetest.get_node(p)

	-- return if any of the nodes is not registered
	local node_name = under.name
	local nodedef = minetest.registered_nodes[node_name]

	if not nodedef then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end

	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end

	--living surface level sediment

	if minetest.get_item_group(node_name, "spreading") ~= 0 then

		--figure out what soil it is from dropped
		local ag_soil = nodedef._ag_soil

		minetest.set_node(pointed_thing.under, {name = ag_soil})
		minetest.sound_play("nodes_nature_dig_crumbly", {pos = pointed_thing.under, gain = 0.5,})


		itemstack:add_wear(65535/(uses-1))

		return itemstack
	end



end



---------------------------------------
--Tools


--------------------------
--1st level
--Crude emergency tools

local lvl_1 = 0.8
--local lvl_1_use = base_use
local lvl_1_max_lvl = minimal.hand_max_lvl

--damage
local lvl_1_dmg = minimal.hand_dmg * 2
--snappy
local lvl_1_snap3 = minimal.hand_snap * lvl_1
local lvl_1_snap2 = (minimal.hand_snap * minimal.t_scale2) * lvl_1
local lvl_1_snap1 = (minimal.hand_snap * minimal.t_scale1) * lvl_1
--crumbly
local lvl_1_crum3 = minimal.hand_crum * lvl_1
local lvl_1_crum2 = (minimal.hand_crum * minimal.t_scale2) * lvl_1
local lvl_1_crum1 = (minimal.hand_crum * minimal.t_scale1) * lvl_1
--choppy
local lvl_1_chop3 = minimal.hand_chop * lvl_1
local lvl_1_chop2 = (minimal.hand_chop * minimal.t_scale2) * lvl_1
--cracky
--none at this level



--
-- Multitool
--

--a crude chipped stone: 1.snap. 2. chop 3.crum
minetest.register_tool("tech:stone_chopper", {
	description = "Stone Knife",
	inventory_image = "tech_tool_stone_chopper.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int,
		max_drop_level = lvl_1_max_lvl,
		groupcaps={
			choppy = {times={[3]=lvl_1_chop3}, uses=base_use*0.75, maxlevel=lvl_1_max_lvl},
			snappy= {times={[1]=lvl_1_snap1, [2]=lvl_1_snap2, [3]=lvl_1_snap3}, uses=base_use, maxlevel=lvl_1_max_lvl},
			crumbly = {times={[3]=lvl_1_crum3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl}
		},
		damage_groups = {fleshy= lvl_1_dmg},
	},
	--groups = {},
	sound = {breaks = "tech_tool_breaks"},
})



--
-- Crumbly
--

-- digging stick... specialist for digging. Can also till
minetest.register_tool("tech:digging_stick", {
	description = "Digging Stick",
	inventory_image = "tech_tool_digging_stick.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = base_punch_int*1.1,
		max_drop_level = lvl_1_max_lvl,
		groupcaps={
			crumbly = {times= {[1]=lvl_1_crum1, [2]=lvl_1_crum2, [3]=lvl_1_crum3}, uses=base_use, maxlevel=lvl_1_max_lvl}
		},
		damage_groups = {fleshy= lvl_1_dmg},
	},
	--groups = {flammable = 1},
	sound = {breaks = "tech_tool_breaks"},
	on_place = function(itemstack, placer, pointed_thing)
		return till_soil(itemstack, placer, pointed_thing, base_use)
	end
})



--------------------------
--2nd level
--polished stone tools. Sophisticated stone age tools

--[[
note: we have multiple rock types
Granite is harder than basalt.
]]

local lvl_2 = 0.8
local lvl_2_use = base_use * 2
local lvl_2_max_lvl = lvl_1_max_lvl

--damage
local lvl_2_dmg = lvl_1_dmg * 2
--snappy
local lvl_2_snap3 = lvl_1_snap3 * lvl_2
local lvl_2_snap2 = lvl_1_snap2 * lvl_2
local lvl_2_snap1 = lvl_1_snap1 * lvl_2
--crumbly
local lvl_2_crum3 = lvl_1_crum3 * lvl_2
local lvl_2_crum2 = lvl_1_crum2 * lvl_2
local lvl_2_crum1 = lvl_1_crum1 * lvl_2
--choppy
local lvl_2_chop3 = lvl_1_chop3 * lvl_2
local lvl_2_chop2 = lvl_1_chop2 * lvl_2
--cracky
--none at this level


--
-- multitool
--

--stone adze. best for chopping
minetest.register_tool("tech:adze_granite", {
	description = "Granite Adze",
	inventory_image = "tech_tool_adze_granite.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.1,
		max_drop_level = lvl_2_max_lvl,
		groupcaps={
			choppy = {times={[2]=lvl_2_chop2, [3]=lvl_2_chop3}, uses=lvl_2_use, maxlevel=lvl_2_max_lvl},
			snappy={times={[1]=lvl_2_snap1, [2]=lvl_2_snap2, [3]=lvl_2_snap3}, uses=lvl_2_use *0.8, maxlevel=lvl_2_max_lvl},
			crumbly = {times={[3]=lvl_1_crum3}, uses=base_use, maxlevel=lvl_1_max_lvl},
		},
		damage_groups = {fleshy = lvl_2_dmg},
	},
	groups = {axe = 1},
	sound = {breaks = "tech_tool_breaks"},
})

--less uses than granite bc softer stone
minetest.register_tool("tech:adze_basalt", {
	description = "Basalt Adze",
	inventory_image = "tech_tool_adze_basalt.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.1,
		max_drop_level = lvl_2_max_lvl,
		groupcaps={
			choppy = {times={[2]=lvl_2_chop2, [3]=lvl_2_chop3}, uses=lvl_2_use *0.9, maxlevel=lvl_2_max_lvl},
			snappy= {times={[1]=lvl_2_snap1, [2]=lvl_2_snap2, [3]=lvl_2_snap3}, uses=lvl_2_use *0.7, maxlevel=lvl_2_max_lvl},
			crumbly = {times={[3]=lvl_1_crum3}, uses=base_use*0.9, maxlevel=lvl_1_max_lvl},
		},
		damage_groups = {fleshy = lvl_2_dmg},
	},
	groups = {axe = 1},
	sound = {breaks = "tech_tool_breaks"},
})


--many more uses than granite.
minetest.register_tool("tech:adze_jade", {
	description = "Jade Adze",
	inventory_image = "tech_tool_adze_jade.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.1,
		max_drop_level = lvl_2_max_lvl,
		groupcaps={
			choppy = {times={[2]=lvl_2_chop2, [3]=lvl_2_chop3}, uses=lvl_2_use * 1.5, maxlevel=lvl_2_max_lvl},
			snappy={times={[1]=lvl_2_snap1, [2]=lvl_2_snap2, [3]=lvl_2_snap3}, uses=lvl_2_use, maxlevel=lvl_2_max_lvl},
			crumbly = {times={[3]=lvl_1_crum3}, uses=base_use, maxlevel=lvl_1_max_lvl},
		},
		damage_groups = {fleshy = lvl_2_dmg},
	},
	groups = {axe = 1},
	sound = {breaks = "tech_tool_breaks"},
})


--stone club. A weapon. Not very good for anything else
--can stun catch animals
minetest.register_tool("tech:stone_club", {
	description = "Stone Club",
	inventory_image = "tech_tool_stone_club.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.2,
		max_drop_level = lvl_2_max_lvl,
		groupcaps={
			choppy = {times={[3]=lvl_1_chop3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl},
			snappy = {times={[3]=lvl_1_snap3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl},
			crumbly = {times= {[3]=lvl_1_crum3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl}
		},
		damage_groups = {fleshy=lvl_2_dmg*2},
	},
	groups = {club = 1},
	sound = {breaks = "tech_tool_breaks"},
})




--------------------------
--3rd level
--iron tools.



local lvl_3 = 0.9
local lvl_3_use = base_use * 4
local lvl_3_max_lvl = lvl_1_max_lvl + 1

--damage
local lvl_3_dmg = lvl_2_dmg * 2
--snappy
local lvl_3_snap3 = lvl_2_snap3 * lvl_3
local lvl_3_snap2 = lvl_2_snap2 * lvl_3
local lvl_3_snap1 = lvl_2_snap1 * lvl_3
--crumbly
local lvl_3_crum3 = lvl_2_crum3 * lvl_3
local lvl_3_crum2 = lvl_2_crum2 * lvl_3
local lvl_3_crum1 = lvl_2_crum1 * lvl_3
--choppy
local lvl_3_chop3 = lvl_2_chop3 * lvl_3
local lvl_3_chop2 = lvl_2_chop2 * lvl_3
local lvl_3_chop1 = (minimal.hand_chop * minimal.t_scale1) * lvl_1 * lvl_2 * lvl_3
--cracky
local lvl_3_crac3 = minimal.hand_crac * lvl_1 * lvl_2 * lvl_3
local lvl_3_crac2 = (minimal.hand_crac * minimal.t_scale2) * lvl_1 * lvl_2 * lvl_3
--local lvl_3_crac1 = (minimal.hand_crac * minimal.t_scale1) * lvl_1 * lvl_2 * lvl_3




--Axe. best for chopping, snappy
minetest.register_tool("tech:axe_iron", {
	description = "Iron Axe",
	inventory_image = "tech_tool_axe_iron.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.1,
		max_drop_level = lvl_3_max_lvl,
		groupcaps={
			choppy = {times={[1]=lvl_3_chop1, [2]=lvl_3_chop2, [3]=lvl_3_chop3}, uses=lvl_3_use, maxlevel=lvl_3_max_lvl},
			snappy = {times={[1]=lvl_3_snap1, [2]=lvl_3_snap2, [3]=lvl_3_snap3}, uses=lvl_3_use, maxlevel=lvl_3_max_lvl},
			crumbly = {times={[3]=lvl_1_crum3}, uses= lvl_2_use, maxlevel=lvl_2_max_lvl},
		},
		damage_groups = {fleshy = lvl_3_dmg},
	},
	groups = {axe = 1},
	sound = {breaks = "tech_tool_breaks"},
})


-- shovel... best for digging. Can also till
minetest.register_tool("tech:shovel_iron", {
	description = "Iron Shovel",
	inventory_image = "tech_tool_shovel_iron.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = base_punch_int*1.1,
		max_drop_level = lvl_3_max_lvl,
		groupcaps={
			crumbly = {times= {[1]=lvl_3_crum1, [2]=lvl_3_crum2, [3]=lvl_3_crum3}, uses=lvl_3_use, maxlevel=lvl_3_max_lvl},
			snappy = {times= {[3]=lvl_2_snap3}, uses=lvl_3_use *0.8, maxlevel=lvl_3_max_lvl},
		},
		damage_groups = {fleshy= lvl_3_dmg},
	},
	--groups = {flammable = 1},
	sound = {breaks = "tech_tool_breaks"},
	on_place = function(itemstack, placer, pointed_thing)
		return till_soil(itemstack, placer, pointed_thing, lvl_3_use)
	end
})


--Mace.  A weapon. Not very good for anything else
--can stun catch animals
minetest.register_tool("tech:mace_iron", {
	description = "Iron Mace",
	inventory_image = "tech_tool_mace_iron.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.2,
		max_drop_level = lvl_3_max_lvl,
		groupcaps={
			choppy = {times={[3]=lvl_1_chop3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl},
			snappy = {times={[3]=lvl_1_snap3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl},
			crumbly = {times= {[3]=lvl_1_crum3}, uses=base_use*0.5, maxlevel=lvl_1_max_lvl},
		},
		damage_groups = {fleshy=lvl_3_dmg*2},
	},
	groups = {club = 1},
	sound = {breaks = "tech_tool_breaks"},
})


--Pick Axe. mining, digging
minetest.register_tool("tech:pickaxe_iron", {
	description = "Iron Pickaxe",
	inventory_image = "tech_tool_pickaxe_iron.png",
	tool_capabilities = {
		full_punch_interval = base_punch_int * 1.1,
		max_drop_level = lvl_3_max_lvl,
		groupcaps={
			choppy = {times={[3]=lvl_2_chop3}, uses=lvl_3_use *0.8, maxlevel=lvl_3_max_lvl},
			snappy = {times={[3]=lvl_2_snap3}, uses=lvl_3_use *0.8, maxlevel=lvl_3_max_lvl},
			crumbly = {times={[2]=lvl_2_crum2, [3]=lvl_2_crum3}, uses= lvl_3_use, maxlevel=lvl_3_max_lvl},
			cracky = {times= {[2]=lvl_3_crac2, [3]=lvl_3_crac3}, uses=lvl_3_use, maxlevel=lvl_3_max_lvl},
		},
		damage_groups = {fleshy = lvl_3_dmg},
	},
	sound = {breaks = "tech_tool_breaks"},
})



---------------------------------------
--Recipes

--
--Hand crafts (inv)
--

----craft stone chopper from gravel
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:stone_chopper 1",
	items = {"nodes_nature:gravel"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:stone_chopper 1",
	items = {"nodes_nature:gravel"},
	level = 1,
	always_known = true,
})


----digging stick from sticks
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:digging_stick 1",
	items = {"tech:stick 2"},
	level = 1,
	always_known = true,
})


--
--Polished Stone
--

--grind adze
crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:adze_granite",
	items = {'nodes_nature:granite_boulder', 'tech:stick', 'group:fibrous_plant 4'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:adze_jade",
	items = {'nodes_nature:jade_boulder', 'tech:stick', 'group:fibrous_plant 4'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:adze_basalt",
	items = {'nodes_nature:basalt_boulder', 'tech:stick', 'group:fibrous_plant 4'},
	level = 1,
	always_known = true,
})


--grind club
crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:stone_club",
	items = {'nodes_nature:granite_boulder'},
	level = 1,
	always_known = true,
})


--
--Iron tools
--

--axe
crafting.register_recipe({
	type = "anvil",
	output = "tech:axe_iron",
	items = {'tech:iron_ingot', 'tech:stick'},
	level = 1,
	always_known = true,
})

--shovel
crafting.register_recipe({
	type = "anvil",
	output = "tech:shovel_iron",
	items = {'tech:iron_ingot', 'tech:stick'},
	level = 1,
	always_known = true,
})

--mace
crafting.register_recipe({
	type = "anvil",
	output = "tech:mace_iron",
	items = {'tech:iron_ingot 2'},
	level = 1,
	always_known = true,
})

--pickaxe
crafting.register_recipe({
	type = "anvil",
	output = "tech:pickaxe_iron",
	items = {'tech:iron_ingot 2', 'tech:stick'},
	level = 1,
	always_known = true,
})


--[[
--would be nice to have,
--but hard to do without either spamming with crafts,
--or having illogical mass balance (e.g. anvil = 1 ingot and axe = 1 ingot)
crafting.register_recipe({
	type = "anvil",
	output = "tech:iron_ingot",
	items = {'group:iron 2'},
	level = 1,
	always_known = true,
})
]]
