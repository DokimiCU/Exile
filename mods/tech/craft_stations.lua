------------------------------------
--CRAFTING STATIONS
--work tables etc
-----------------------------------

-------------------------------------------------
--Register
--some crafts are more convienently registered at the same time as the resource,
--hence why not all are here.

crafting.register_type("crafting_spot")
--crafting.register_type("mixing_spot")...has to be done in nodes_nature
--crafting.register_type("threshing_spot")...has to be done in nodes_nature
crafting.register_type("weaving_frame")
crafting.register_type("grinding_stone")
crafting.register_type("mortar_and_pestle")
--crafting.register_type("chopping_block")...has to be done in nodes_nature
--crafting.register_type("hammering_block")...has to be done in nodes_nature
crafting.register_type("anvil")
crafting.register_type("carpentry_bench")
--crafting.register_type("masonry_bench")...has to be done in nodes_nature
crafting.register_type("brick_makers_bench")
crafting.register_type("spinning_wheel")
crafting.register_type("loom")
crafting.register_type("glass_furnace")

-------------------------------------------------
--Stations


-------------------
--Entry level
--equivalent to sitting down to make stuff


--crafting spot
--basic crafts
minetest.register_node("tech:crafting_spot", {
	description = "Crafting Spot",
	tiles = {"tech_station_crafting_spot.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	stack_max = 1,
	paramtype = "light",
	use_texture_alpha = "clip",
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("crafting_spot", 2, { x = 8, y = 3 }),
	on_punch = function(pos, node, player)
		minetest.remove_node(pos)
	end
})


--Mixing spot
--rearranging previously existing stuff (e.g. stairs, slabs)
minetest.register_node("tech:mixing_spot", {
	description = "Mixing Spot",
	tiles = {"tech_station_mixing_spot.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	stack_max = 1,
	paramtype = "light",
	use_texture_alpha = "clip",
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("mixing_spot", 2, { x = 8, y = 3 }),
	on_punch = function(pos, node, player)
		minetest.remove_node(pos)
	end
})


--Threshing spot
--extracting seeds from plants
minetest.register_node("tech:threshing_spot", {
	description = "Threshing Spot",
	tiles = {"tech_station_threshing_spot.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	stack_max = 1,
	paramtype = "light",
	use_texture_alpha = "clip",
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("threshing_spot", 2, { x = 8, y = 3 }),
	on_punch = function(pos, node, player)
		minetest.remove_node(pos)
	end
})




-------------------
--2nd Level.
--low level stone tech
--Boulders, rough hewn timber


--weaving_frame
--fa primitive loom, for simple woven crafts
minetest.register_node("tech:weaving_frame",{
	description = "Weaving Frame",
	drawtype = "nodebox",
	tiles = {"tech_stick.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {falling_node = 1, dig_immediate=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, -0.25, -0.25}, -- NodeBox1
			{-0.5, -0.5, -0.375, -0.375, -0.125, -0.25}, -- NodeBox2
			{0.375, -0.5, -0.375, 0.5, -0.125, -0.25}, -- NodeBox3
			{0.375, -0.5, 0.375, 0.5, 0.0625, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.375, -0.375, 0.0625, 0.5}, -- NodeBox5
			{-0.375, -0.0625, 0.375, 0.375, 0.0625, 0.5}, -- NodeBox6
			{-0.3125, -0.5, 0.375, -0.25, -0.0625, 0.4375}, -- NodeBox7
			{0.25, -0.5, 0.375, 0.3125, -0.0625, 0.4375}, -- NodeBox8
			{0.125, -0.5, 0.375, 0.1875, -0.0625, 0.4375}, -- NodeBox9
			{-0.1875, -0.5, 0.375, -0.125, -0.0625, 0.4375}, -- NodeBox10
			{-0.0625, -0.5, 0.375, 0.0625, -0.0625, 0.5}, -- NodeBox11
			{-0.5, -0.0625, 0.3125, 0.5, 0, 0.375}, -- NodeBox12
			{-0.5, -0.4375, 0.3125, 0.5, -0.375, 0.375}, -- NodeBox13
		}
	},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("weaving_frame", 2, { x = 8, y = 3 }),
})


--grinding stone
--for grinding stone tools
minetest.register_node("tech:grinding_stone",{
	description = "Grinding stone",
	drawtype = "nodebox",
	tiles = {"nodes_nature_granite.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {falling_node = 1, dig_immediate=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.3125, 0.375, -0.4375, 0.3125},
			{-0.4375, -0.4375, -0.375, 0.4375, -0.1875, 0.375},
			{-0.1875, -0.1875, 0, 0, -0.0625, 0.25},
			{0.4375, -0.375, -0.3125, 0.5, -0.1875, 0.3125},
			{-0.5, -0.375, -0.3125, -0.4375, -0.1875, 0.3125},
			{-0.375, -0.375, -0.4375, 0.375, -0.1875, -0.375},
			{-0.375, -0.375, 0.375, 0.375, -0.1875, 0.4375},
		}
	},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("grinding_stone", 2, { x = 8, y = 3 }),
})

--mortar and pestle.
--for grinding food etc
minetest.register_node("tech:mortar_pestle_basalt",{
	description = "Basalt Mortar and Pestle",
	drawtype = "nodebox",
	tiles = {"nodes_nature_basalt.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {falling_node = 1, dig_immediate=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
			{-0.4375, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375},
			{-0.4375, -0.3125, -0.4375, 0.4375, 0.25, -0.3125},
			{-0.4375, -0.3125, 0.3125, 0.4375, 0.25, 0.4375},
			{-0.4375, -0.3125, -0.3125, -0.3125, 0.25, 0.3125},
			{0.3125, -0.3125, -0.3125, 0.4375, 0.25, 0.3125},
			{-0.25, -0.3125, 0.125, -0.0625, 0.4375, 0.3125},
		}
	},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("mortar_and_pestle", 2, { x = 8, y = 3 }),
})

minetest.register_node("tech:mortar_pestle_granite",{
	description = "Granite Mortar and Pestle",
	drawtype = "nodebox",
	tiles = {"nodes_nature_granite.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {falling_node = 1, dig_immediate=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
			{-0.4375, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375},
			{-0.4375, -0.3125, -0.4375, 0.4375, 0.25, -0.3125},
			{-0.4375, -0.3125, 0.3125, 0.4375, 0.25, 0.4375},
			{-0.4375, -0.3125, -0.3125, -0.3125, 0.25, 0.3125},
			{0.3125, -0.3125, -0.3125, 0.4375, 0.25, 0.3125},
			{-0.25, -0.3125, 0.125, -0.0625, 0.4375, 0.3125},
		}
	},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("mortar_and_pestle", 2, { x = 8, y = 3 }),
})

minetest.register_node("tech:mortar_pestle_limestone",{
	description = "Limestone Mortar and Pestle",
	drawtype = "nodebox",
	tiles = {"nodes_nature_limestone.png"},
	stack_max = minimal.stack_max_bulky *2,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {falling_node = 1, dig_immediate=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
			{-0.4375, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375},
			{-0.4375, -0.3125, -0.4375, 0.4375, 0.25, -0.3125},
			{-0.4375, -0.3125, 0.3125, 0.4375, 0.25, 0.4375},
			{-0.4375, -0.3125, -0.3125, -0.3125, 0.25, 0.3125},
			{0.3125, -0.3125, -0.3125, 0.4375, 0.25, 0.3125},
			{-0.25, -0.3125, 0.125, -0.0625, 0.4375, 0.3125},
		}
	},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("mortar_and_pestle", 2, { x = 8, y = 3 }),
})

--chopping_block
--crude wood crafts,
minetest.register_node("tech:chopping_block", {
	description = "Chopping Block",
	tiles = {
		"tech_chopping_block_top.png",
		"tech_chopping_block_top.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.43, -0.5, -0.43, 0.43, 0.38, 0.43},
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("chopping_block", 2, { x = 8, y = 3 }),
})

--hammering_block
--crude hammering crushing jobs,
minetest.register_node("tech:hammering_block", {
	description = "Hammering Block",
	tiles = {
		"tech_hammering_block_top.png",
		"tech_chopping_block_top.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.47, -0.5, -0.47, 0.47, 0.31, 0.47},
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("hammering_block", 2, { x = 8, y = 3 }),
})




-------------------
--3rd Level.
--metal working, and things dependant on it


--anvil
--metal  working
minetest.register_node("tech:anvil", {
	description = "Anvil",
	tiles = {"tech_iron.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
			{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
			{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
			{-0.35,-0.1,-0.2,0.35,0.1,0.2},
		},
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("anvil", 2, { x = 8, y = 3 }),
})


--carpentry_bench
--more sophisticated wood working
minetest.register_node("tech:carpentry_bench", {
	description = "Carpentry Bench",
	tiles = {"nodes_nature_maraka_log.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.3125, 0.5, 0.25, 0.375},
			{-0.5, -0.125, -0.25, 0.5, 0, 0.3125},
			{0.3125, -0.5, -0.25, 0.4375, -0.125, -0.125},
			{0.3125, -0.5, 0.1875, 0.4375, -0.125, 0.3125},
			{-0.4375, -0.5, 0.1875, -0.3125, -0.125, 0.3125},
			{-0.4375, -0.5, -0.25, -0.3125, -0.125, -0.125},
		}
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("carpentry_bench", 2, { x = 8, y = 3 }),
})

--masonry_bench
--more sophisticated stone crafts
minetest.register_node("tech:masonry_bench", {
	description = "Masonry Bench",
	tiles = {"nodes_nature_maraka_log.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, 0.5, 0.25, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, 0, -0.3125},
			{0.3125, -0.5, -0.5, 0.5, 0, -0.3125},
			{0.3125, -0.5, 0.3125, 0.5, 0, 0.5},
			{-0.5, -0.5, 0.3125, -0.3125, 0, 0.5},
			{-0.4375, -0.1875, -0.3125, -0.3125, 0, 0.3125},
			{0.3125, -0.1875, -0.3125, 0.4375, 0, 0.3125},
			{-0.375, -0.1875, -0.4375, 0.3125, 0, -0.3125},
			{-0.375, -0.1875, 0.3125, 0.375, 0, 0.4375},
		}
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("masonry_bench", 2, { x = 8, y = 3 }),
})


--brick_makers_bench
--for fired bricks and associated crafts
minetest.register_node("tech:brick_makers_bench", {
	description = "Brick Maker's Bench",
	tiles = {"nodes_nature_maraka_log.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, 0, -0.375, 0.4375, 0.125, 0.375}, -- NodeBox1
			{-0.375, -0.5, -0.3125, -0.25, 0, -0.1875}, -- NodeBox2
			{0.25, -0.5, -0.3125, 0.375, 0, -0.1875}, -- NodeBox3
			{0.25, -0.5, 0.1875, 0.375, 0, 0.3125}, -- NodeBox4
			{-0.375, -0.5, 0.1875, -0.25, 0, 0.3125}, -- NodeBox5
			{-0.375, -0.125, -0.1875, -0.25, 2.42144e-008, 0.1875}, -- NodeBox6
			{0.25, -0.125, -0.1875, 0.375, -3.72529e-009, 0.1875}, -- NodeBox7
			{-0.25, -0.125, -0.3125, 0.25, 5.7742e-008, -0.1875}, -- NodeBox8
			{-0.25, -0.125, 0.1875, 0.25, -2.23517e-008, 0.3125}, -- NodeBox9
			{-0.25, 0.125, 0.1875, 0.25, 0.25, 0.25}, -- NodeBox10
			{-0.25, 0.125, -0.0625, 0.25, 0.25, 1.86265e-009}, -- NodeBox11
			{-0.3125, 0.125, -0.0625, -0.25, 0.25, 0.25}, -- NodeBox12
			{0.25, 0.125, -0.0625, 0.3125, 0.25, 0.25}, -- NodeBox13
			{0.1875, 0.125, -0.3125, 0.25, 0.1875, -0.125}, -- NodeBox14
		}
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("brick_makers_bench", 2, { x = 8, y = 3 }),
})


--spinning_wheel
--turn raw fibres into spun fibre
--including steps here that in reality would require their own equipment
minetest.register_node("tech:spinning_wheel", {
	description = "Spinning Wheel",
	tiles = {"nodes_nature_maraka_log.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.1875, 0.5, -0.25, 0.1875}, -- NodeBox1
			{-0.25, -0.25, -0.1875, -0.0625, 0.1875, -0.0625}, -- NodeBox2
			{-0.25, -0.25, 0.0625, -0.0625, 0.1875, 0.1875}, -- NodeBox3
			{-0.1875, -0.1875, -0.0625, -0.125, 0.5, 0.0625}, -- NodeBox4
			{-0.5, 0.125, -0.0625, -0.25, 0.1875, 0.0625}, -- NodeBox5
			{-0.0625, 0.125, -0.0625, 0.1875, 0.1875, 0.0625}, -- NodeBox6
			{0.375, -0.25, -0.0625, 0.5, -0.125, 0.0625}, -- NodeBox7
		}
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("spinning_wheel", 2, { x = 8, y = 3 }),
})


--Loom
--turn fibre into fabric items
minetest.register_node("tech:loom", {
	description = "Loom",
	tiles = {"nodes_nature_maraka_log.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.1875}, -- NodeBox1
			{0.375, -0.5, -0.125, 0.5, 0.5, 0.1875}, -- NodeBox3
			{-0.375, -0.5, -0.5, 0.375, -0.4375, 0.5}, -- NodeBox4
			{-0.5, 0, -0.125, 0.5, 0.0625, 0.1875}, -- NodeBox5
			{-0.5, 0.3125, 0.1875, 0.5, 0.5, 0.25}, -- NodeBox6
			{-0.5, 0.3125, -0.1875, 0.5, 0.5, -0.125}, -- NodeBox7
			{-0.375, -0.1875, -0.5, -0.3125, -0.125, 0.5}, -- NodeBox8
			{0.3125, -0.1875, -0.5, 0.375, -0.125, 0.5}, -- NodeBox9
			{-0.4375, -0.1875, -0.5, 0.4375, -0.125, -0.4375}, -- NodeBox10
			{-0.4375, -0.1875, 0.4375, 0.4375, -0.125, 0.5}, -- NodeBox11
			{-0.375, -0.5, 0.375, -0.3125, -0.125, 0.4375}, -- NodeBox12
			{0.3125, -0.5, 0.375, 0.375, -0.125, 0.4375}, -- NodeBox13
			{-0.375, -0.5, -0.4375, -0.3125, -0.125, -0.375}, -- NodeBox14
			{0.3125, -0.5, -0.4375, 0.375, -0.125, -0.375}, -- NodeBox15
			{-0.3125, -0.4375, -0.25, 0.3125, 0, 0.25}, -- NodeBox16
		}
	},
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("loom", 2, { x = 8, y = 3 }),
})

--Glassworking Furnace
--Glassblowing and similar
minetest.register_node("tech:glass_furnace", {
	description = "Glass furnace",
	tiles = {
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_glassfurnace_front.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.47, -0.5, -0.47, 0.47, 0.31, 0.47},
	},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("glass_furnace", 2, { x = 8, y = 3 }),
})


---------------------------------------
--Recipes

--
--Hand crafts (inv)
--

----craft crafting spot for free
crafting.register_recipe({
	type = "inv",
	output = "tech:crafting_spot",
	items = {},
	level = 1,
	always_known = true,
})

----craft mixing spot for free
crafting.register_recipe({
	type = "inv",
	output = "tech:mixing_spot",
	items = {},
	level = 1,
	always_known = true,
})

----craft threshing spot for free
crafting.register_recipe({
	type = "inv",
	output = "tech:threshing_spot",
	items = {},
	level = 1,
	always_known = true,
})


--
--Boulders
--

--grinding_stone from craft spot
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:grinding_stone",
	items = {'nodes_nature:granite_boulder', 'nodes_nature:sand 8'},
	level = 1,
	always_known = true,
})


--grind a mortar_and_pestle
crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:mortar_pestle_basalt",
	items = {'nodes_nature:basalt_boulder 2'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:mortar_pestle_granite",
	items = {'nodes_nature:granite_boulder 2'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:mortar_pestle_limestone",
	items = {'nodes_nature:limestone_boulder 2'},
	level = 1,
	always_known = true,
})


--
--Wood
--

--weaving_frame
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:weaving_frame",
	items = {'tech:stick 12', 'group:fibrous_plant 8'},
	level = 1,
	always_known = true,
})


--chopping_block
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:chopping_block",
	items = {'group:log'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "chopping_block",
	output = "tech:chopping_block",
	items = {'group:log'},
	level = 1,
	always_known = true,
})

--hammering block
crafting.register_recipe({
	type = "chopping_block",
	output = "tech:hammering_block",
	items = {'group:log'},
	level = 1,
	always_known = true,
})


--
--Iron
--

--hammer ingots into anvil
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:anvil",
	items = {'tech:iron_ingot 4'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "anvil",
	output = "tech:anvil",
	items = {'tech:iron_ingot 4'},
	level = 1,
	always_known = true,
})

--carpentary from logs for bench and iron for tools
crafting.register_recipe({
	type = "chopping_block",
	output = "tech:carpentry_bench",
	items = {'tech:iron_ingot 4', 'nodes_nature:maraka_log 2'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:carpentry_bench",
	items = {'tech:iron_ingot 4', 'nodes_nature:maraka_log 2'},
	level = 1,
	always_known = true,
})

--masonry_bench from logs for bench and iron for tools
crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:masonry_bench",
	items = {'tech:iron_ingot 4', 'nodes_nature:maraka_log 2'},
	level = 1,
	always_known = true,
})

--brick_makers_bench from logs for bench, simple tools so no iron
--allow early access because includes primitive construction methods
crafting.register_recipe({
	type = "chopping_block",
	output = "tech:brick_makers_bench",
	items = {'tech:stick 8', 'group:log 2'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:brick_makers_bench",
	items = {'tech:stick 8', 'group:log 2'},
	level = 1,
	always_known = true,
})

--spinning wheel. wood,
crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:spinning_wheel",
	items = {'nodes_nature:maraka_log 2'},
	level = 1,
	always_known = true,
})

--loom. wood, fibre for mechanisms
crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:loom",
	items = {'nodes_nature:maraka_log 2', 'tech:coarse_fibre 12'},
	level = 1,
	always_known = true,
})

-- Glass furnace from bricks for the main structure and iron for the tools
crafting.register_recipe({
	type = "brick_makers_bench",
	output = "tech:glass_furnace",
	items = {'tech:iron_ingot', 'tech:loose_brick 3', 'tech:lime_mortar'},
	level = 1,
	always_known = true,
})
