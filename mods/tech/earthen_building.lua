-------------------------------------------------------------
--EARTHEN BUILDING
-- construction from loose stones, mud etc


---------------------------------
--DRYSTACK
-- walls made from stacked stones (no mortar, hence dry)
-- made from loose found stones

minetest.register_node("tech:drystack", {
	description = "Drystack",
	tiles = {"tech_drystack.png"},
	stack_max = minimal.stack_max_bulky *1.5,
	groups = {cracky = 3, crumbly = 1, falling_node = 1, oddly_breakable_by_hand = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
})



-- Stairs and slab for drystack
stairs.register_stair_and_slab(
	"drystack",
	"tech:drystack",
	"mixing_spot",
	"true",
	{cracky = 3, crumbly = 1, oddly_breakable_by_hand = 1, falling_node = 1},
	{"tech_drystack.png"},
	"Drystack Stair",
	"Drystack Slab",
	minimal.stack_max_bulky *3,
	nodes_nature.node_sound_stone_defaults()
)


------------------------------------------
--MUDBRICK

minetest.register_node('tech:mudbrick', {
	description = 'Mudbrick',
	tiles = {"tech_mudbrick.png"},
	stack_max = minimal.stack_max_bulky *2,
	groups = {crumbly = 2, cracky = 3, oddly_breakable_by_hand = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
})

stairs.register_stair_and_slab(
	"mudbrick",
	"tech:mudbrick",
	"mixing_spot",
	"true",
	{crumbly = 2, cracky = 3, oddly_breakable_by_hand = 1},
	{"tech_mudbrick.png"},
	"Mudbrick Stair",
	"Mudbrick Slab",
	minimal.stack_max_bulky *4,
	nodes_nature.node_sound_dirt_defaults()
)

------------------------------------------
--RAMMED EARTH

minetest.register_node('tech:rammed_earth', {
	description = 'Rammed Earth',
	tiles = {
		"tech_rammed_earth.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png"
	},
	stack_max = minimal.stack_max_bulky *1.5,
	groups = {crumbly = 1, cracky = 3, falling_node = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
})

stairs.register_stair_and_slab(
	"rammed_earth",
	"tech:rammed_earth",
	"mixing_spot",
	"true",
	{crumbly = 1, cracky = 3, falling_node = 1},
	{
		"tech_rammed_earth.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png",
		"tech_rammed_earth_side.png"
	},
	"Rammed Earth Stair",
	"Rammed Earth Slab",
	minimal.stack_max_bulky *3,
	nodes_nature.node_sound_dirt_defaults()
)


	-----------------------------------------------------------
	--WATTLE

minetest.register_node('tech:wattle', {
	description = 'Wattle',
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-1/8, -1/2, -1/8, 1/8, 1/2, 1/8}},
		-- connect_bottom =
		connect_front = {{-1/8, -1/2, -1/2,  1/8, 1/2, -1/8}},
		connect_left = {{-1/2, -1/2, -1/8, -1/8, 1/2,  1/8}},
		connect_back = {{-1/8, -1/2,  1/8,  1/8, 1/2,  1/2}},
		connect_right = {{ 1/8, -1/2, -1/8,  1/2, 1/2,  1/8}},
	},
	connects_to = {
		"group:sediment",
		"group:tree",
		"group:log",
		"group:stone",
		"group:masonry",
		"group:soft_stone",
		'tech:mudbrick',
		'tech:rammed_earth',
		'tech:wattle_loose',
		'tech:wattle_door_frame',
		'tech:wattle',
		'tech:thatch'
	},
	paramtype = "light",
	use_texture_alpha = "clip",
	tiles = {"tech_wattle_top.png",
	 				"tech_wattle_top.png",
					"tech_wattle.png",
					"tech_wattle.png",
					"tech_wattle.png",
					"tech_wattle.png" },
	inventory_image = "tech_wattle.png",
	wield_image = "tech_wattle.png",
	stack_max = minimal.stack_max_bulky * 3,
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
})

--a crude window... or for resource saving
minetest.register_node('tech:wattle_loose', {
	description = 'Loose Wattle',
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-1/8, -1/2, -1/8, 1/8, 1/2, 1/8}},
		-- connect_bottom =
		connect_front = {{-1/8, -1/2, -1/2,  1/8, 1/2, -1/8}},
		connect_left = {{-1/2, -1/2, -1/8, -1/8, 1/2,  1/8}},
		connect_back = {{-1/8, -1/2,  1/8,  1/8, 1/2,  1/2}},
		connect_right = {{ 1/8, -1/2, -1/8,  1/2, 1/2,  1/8}},
	},
	connects_to = {
		"group:sediment",
		"group:tree",
		"group:log",
		"group:stone",
		"group:masonry",
		"group:soft_stone",
		'tech:mudbrick',
		'tech:rammed_earth',
		'tech:wattle_loose',
		'tech:wattle',
		'tech:thatch'
	},
	paramtype = "light",
	use_texture_alpha = "clip",
	tiles = {"tech_wattle_top.png",
	 				"tech_wattle_top.png",
					"tech_wattle_loose.png",
					"tech_wattle_loose.png",
					"tech_wattle_loose.png",
					"tech_wattle_loose.png" },
	inventory_image = "tech_wattle_loose.png",
	wield_image = "tech_wattle_loose.png",
	stack_max = minimal.stack_max_bulky * 3,
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
})

--A frame to let wattle walls connect to wattle doors
--TODO: Make it detect wattle or doors and rotate itself to match
minetest.register_node('tech:wattle_door_frame', {
	description = 'Wattle Door Frame',
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/8,  1/2, 1/2, 1/8},
		         {-4/8, -1/2, 1/8,  -3/8, 1/2, 1/2}},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	tiles = {"tech_wattle_top.png",
	 				"tech_wattle_top.png",
					"tech_wattle.png",
					"tech_wattle.png",
					"tech_wattle.png",
					"tech_wattle.png",
},
	inventory_image = "tech_wattle_door_frame.png",
	wield_image = "tech_wattle_door_frame.png",
	stack_max = minimal.stack_max_bulky * 3,
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
})



------------------------------------------
--THATCH

minetest.register_node('tech:thatch', {
	description = 'Thatch',
	tiles = {"tech_thatch.png"},
	stack_max = minimal.stack_max_bulky * 4,
	groups = {snappy=3, flammable=1},
	sounds = nodes_nature.node_sound_leaves_defaults(),
	on_burn = function(pos)
		if math.random()<0.5 then
			minetest.set_node(pos, {name = "tech:small_wood_fire"})
			minetest.check_for_falling(pos)
		else
			minetest.remove_node(pos)
		end
	end,
})

stairs.register_stair_and_slab(
	"thatch",
	"tech:thatch",
	"mixing_spot",
	"true",
	{snappy=3, flammable=1},
	{"tech_thatch.png"},
	"Thatch Stair",
	"Thatch Slab",
	minimal.stack_max_bulky * 8,
	nodes_nature.node_sound_leaves_defaults()
)



---------------------------------------
--Recipes

--
--Hand crafts (Cradting spot)
--

----craft drystack from gravel
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:drystack",
	items = {"nodes_nature:gravel 2"},
	level = 1,
	always_known = true,
})

--recycle drystack with some loss
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:gravel",
	items = {"tech:drystack"},
	level = 1,
	always_known = true,
})


----mudbrick from clay + sand and fibre
--(other recipes could be done also, but limit it for simplicity)
crafting.register_recipe({
	--type = "crafting_spot",
	type = "brick_makers_bench",
	output = "tech:mudbrick 4",
	items = {"nodes_nature:clay_wet 3", "nodes_nature:sand_wet", "group:fibrous_plant"},
	--items = {"nodes_nature:clay", "nodes_nature:sand_wet", "group:fibrous_plant"},
	level = 1,
	always_known = true,
})

----Rammed earth by compacting clay
crafting.register_recipe({
	--type = "crafting_spot",
	type = "brick_makers_bench",
	output = "tech:rammed_earth",
	items = {"nodes_nature:clay 2"},
	level = 1,
	always_known = true,
})

--recycle rammed_earth with some loss
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay",
	items = {"tech:rammed_earth"},
	level = 1,
	always_known = true,
})



----Wattle from sticks
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:wattle",
	items = {"tech:stick 6"},
	level = 1,
	always_known = true,
})


--recycle wattle with some loss
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:stick 4",
	items = {"tech:wattle"},
	level = 1,
	always_known = true,
})

----Loose Wattle from sticks
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:wattle_loose",
	items = {"tech:stick 3"},
	level = 1,
	always_known = true,
})

--recycle loose wattle with some loss
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:stick 2",
	items = {"tech:wattle_loose"},
	level = 1,
	always_known = true,
})

--convert loose wattle to wattle
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:wattle",
	items = {"tech:wattle_loose 2"},
	level = 1,
	always_known = true,
})

--convert wattle to loose wattle
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:wattle_loose 2",
	items = {"tech:wattle"},
	level = 1,
	always_known = true,
})

----Wattle door frame from sticks
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:wattle_door_frame",
	items = {"tech:stick 6"},
	level = 1,
	always_known = true,
})
--convert wattle to wattle door frame
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:wattle_door_frame",
	items = {"tech:wattle"},
	level = 1,
	always_known = true,
})
--convert wattle door frame to wattle
crafting.register_recipe({
	type = "mixing_spot",
	output = "tech:wattle",
	items = {"tech:wattle_door_frame"},
	level = 1,
	always_known = true,
})

----Thatch from  fibre
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:thatch",
	items = {"group:fibrous_plant 8"},
	level = 1,
	always_known = true,
})
