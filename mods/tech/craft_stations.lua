------------------------------------
--CRAFTING STATIONS
--work tables etc
-----------------------------------
-------------------------------------------------

-- Internationalization
local S = tech.S

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
---- Stations -------------------
--Entry level --equivalent to sitting down to make stuff
--crafting spot--basic crafts
minetest.register_node("tech:crafting_spot", {
	description   = S("Crafting Spot"),
	tiles         = {"tech_station_crafting_spot.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
		},
	selection_box = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	stack_max     = 1,
	paramtype     = "light",
	use_texture_alpha = "clip",
	walkable      = false,
	buildable_to  = true,
	floodable     = true,
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("crafting_spot", 2, { x = 8, y = 3 }),
	on_punch      = function(pos, node, player)
		minetest.remove_node(pos)
		end
	})
--Mixing spot
--rearranging previously existing stuff (e.g. stairs, slabs)
minetest.register_node("tech:mixing_spot", {
	description   = S("Mixing Spot"),
	tiles         = {"tech_station_mixing_spot.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
		},
	selection_box = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	stack_max     = 1,
	paramtype     = "light",
	use_texture_alpha = "clip",
	walkable      = false,
	buildable_to  = true,
	floodable     = true,
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("mixing_spot", 2, { x = 8, y = 3 }),
	on_punch      = function(pos, node, player)
		minetest.remove_node(pos)
		end
	})
--Threshing spot
--extracting seeds from plants
minetest.register_node("tech:threshing_spot", {
	description       = S("Threshing Spot"),
	tiles             = {"tech_station_threshing_spot.png"},
	drawtype          = "nodebox",
	node_box          = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
		},
	selection_box     = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	stack_max         = 1,
	paramtype         = "light",
	use_texture_alpha = "clip",
	walkable          = false,
	buildable_to      = true,
	floodable         = true,
	groups            = {dig_immediate = 3, falling_node = 1, temp_pass = 1},
	sounds            = nodes_nature.node_sound_wood_defaults(),
	on_rightclick     = crafting.make_on_rightclick("threshing_spot", 2, { x = 8, y = 3 }),
	on_punch          = function(pos, node, player)
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
	description   = S("Weaving Frame"),
	drawtype      = "nodebox",
	tiles         = {"tech_stick.png"},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {falling_node = 1, dig_immediate=3},
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.3750, -0.3750, -0.3750,  0.3750, -0.2500, -0.2500}, -- NodeBox1
			{-0.5000, -0.5000, -0.3750, -0.3750, -0.1250, -0.2500}, -- NodeBox2
			{ 0.3750, -0.5000, -0.3750,  0.5000, -0.1250, -0.2500}, -- NodeBox3
			{ 0.3750, -0.5000,  0.3750,  0.5000,  0.0625,  0.5000}, -- NodeBox4
			{-0.5000, -0.5000,  0.3750, -0.3750,  0.0625,  0.5000}, -- NodeBox5
			{-0.3750, -0.0625,  0.3750,  0.3750,  0.0625,  0.5000}, -- NodeBox6
			{-0.3125, -0.5000,  0.3750, -0.2500, -0.0625,  0.4375}, -- NodeBox7
			{ 0.2500, -0.5000,  0.3750,  0.3125, -0.0625,  0.4375}, -- NodeBox8
			{ 0.1250, -0.5000,  0.3750,  0.1875, -0.0625,  0.4375}, -- NodeBox9
			{-0.1875, -0.5000,  0.3750, -0.1250, -0.0625,  0.4375}, -- NodeBox10
			{-0.0625, -0.5000,  0.3750,  0.0625, -0.0625,  0.5000}, -- NodeBox11
			{-0.5000, -0.0625,  0.3125,  0.5000,  0.0000,  0.3750}, -- NodeBox12
			{-0.5000, -0.4375,  0.3125,  0.5000, -0.3750,  0.3750}, -- NodeBox13
			}
		},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("weaving_frame", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--grinding stone
--for grinding stone tools
minetest.register_node("tech:grinding_stone",{
	description   = S("Grinding stone"),
	drawtype      = "nodebox",
	tiles         = {"nodes_nature_granite.png"},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {falling_node = 1, dig_immediate=3},
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.3750, -0.5000, -0.3125,  0.3750, -0.4375,  0.3125},
			{-0.4375, -0.4375, -0.3750,  0.4375, -0.1875,  0.3750},
			{-0.1875, -0.1875,  0.0000,  0.0000, -0.0625,  0.2500},
			{ 0.4375, -0.3750, -0.3125,  0.5000, -0.1875,  0.3125},
			{-0.5000, -0.3750, -0.3125, -0.4375, -0.1875,  0.3125},
			{-0.3750, -0.3750, -0.4375,  0.3750, -0.1875, -0.3750},
			{-0.3750, -0.3750,  0.3750,  0.3750, -0.1875,  0.4375},
			}
		},
	sounds        = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("grinding_stone", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--mortar and pestle.
--for grinding food etc
minetest.register_node("tech:mortar_pestle_basalt",{
	description   = S("Basalt Mortar and Pestle"),
	drawtype      = "nodebox",
	tiles         = {"nodes_nature_basalt.png"},
	stack_max     = minimal.stack_max_bulky *2,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {falling_node = 1, dig_immediate=3},
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.3750, -0.5000, -0.3750,  0.3750, -0.4375,  0.3750},
			{-0.4375, -0.4375, -0.4375,  0.4375, -0.3125,  0.4375},
			{-0.4375, -0.3125, -0.4375,  0.4375,  0.2500, -0.3125},
			{-0.4375, -0.3125,  0.3125,  0.4375,  0.2500,  0.4375},
			{-0.4375, -0.3125, -0.3125, -0.3125,  0.2500,  0.3125},
			{ 0.3125, -0.3125, -0.3125,  0.4375,  0.2500,  0.3125},
			{-0.2500, -0.3125,  0.1250, -0.0625,  0.4375,  0.3125},
			}
		},
	sounds        = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("mortar_and_pestle", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
minetest.register_node("tech:mortar_pestle_granite",{
	description   = S("Granite Mortar and Pestle"),
	drawtype      = "nodebox",
	tiles         = {"nodes_nature_granite.png"},
	stack_max     = minimal.stack_max_bulky *2,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {falling_node = 1, dig_immediate=3},
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.3750, -0.5000, -0.3750,  0.3750, -0.4375,  0.3750},
			{-0.4375, -0.4375, -0.4375,  0.4375, -0.3125,  0.4375},
			{-0.4375, -0.3125, -0.4375,  0.4375,  0.2500, -0.3125},
			{-0.4375, -0.3125,  0.3125,  0.4375,  0.2500,  0.4375},
			{-0.4375, -0.3125, -0.3125, -0.3125,  0.2500,  0.3125},
			{ 0.3125, -0.3125, -0.3125,  0.4375,  0.2500,  0.3125},
			{-0.2500, -0.3125,  0.1250, -0.0625,  0.4375,  0.3125},
			}
		},
	sounds        = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("mortar_and_pestle", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
minetest.register_node("tech:mortar_pestle_limestone",{
	description   = S("Limestone Mortar and Pestle"),
	drawtype      = "nodebox",
	tiles         = {"nodes_nature_limestone.png"},
	stack_max     = minimal.stack_max_bulky *2,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {falling_node = 1, dig_immediate=3},
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.3750, -0.5000, -0.3750,  0.3750, -0.4375,  0.3750},
			{-0.4375, -0.4375, -0.4375,  0.4375, -0.3125,  0.4375},
			{-0.4375, -0.3125, -0.4375,  0.4375,  0.2500, -0.3125},
			{-0.4375, -0.3125,  0.3125,  0.4375,  0.2500,  0.4375},
			{-0.4375, -0.3125, -0.3125, -0.3125,  0.2500,  0.3125},
			{ 0.3125, -0.3125, -0.3125,  0.4375,  0.2500,  0.3125},
			{-0.2500, -0.3125,  0.1250, -0.0625,  0.4375,  0.3125},
			}
		},
	sounds        = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("mortar_and_pestle", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--chopping_block --crude wood crafts,
minetest.register_node("tech:chopping_block", {
	description   = S("Chopping Block"),
	tiles         = {
		"tech_chopping_block_top.png",
		"tech_chopping_block_top.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {-0.43, -0.5, -0.43, 0.43, 0.38, 0.43},
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	groups        = {dig_immediate = 3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("chopping_block", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--hammering_block
--crude hammering crushing jobs,
minetest.register_node("tech:hammering_block", {
	description   = S("Hammering Block"),
	tiles         = {
		"tech_hammering_block_top.png",
		"tech_chopping_block_top.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		"tech_chopping_block.png",
		},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {-0.47, -0.5, -0.47, 0.47, 0.31, 0.47},
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("hammering_block", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
-------------------
--3rd Level. --metal working, and things dependant on it
minetest.register_node("tech:anvil", { --anvil--metal  working
	description   = S("Anvil"),
	tiles         = {"tech_iron.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.50, -0.5, -0.30, 0.50, -0.4, 0.30},
			{-0.35, -0.4, -0.25, 0.35, -0.3, 0.25},
			{-0.30, -0.3, -0.15, 0.30, -0.1, 0.15},
			{-0.35, -0.1, -0.20, 0.35,  0.1, 0.20},
			},
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_stone_defaults(),
	on_rightclick = crafting.make_on_rightclick("anvil", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
minetest.register_node("tech:carpentry_bench", { --carpentry_bench--more sophisticated wood working
	description   = S("Carpentry Bench"),
	tiles         = {"nodes_nature_maraka_log.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.5000,  0.000, -0.3125,  0.5000,  0.250,  0.3750},
			{-0.5000, -0.125, -0.2500,  0.5000,  0.000,  0.3125},
			{ 0.3125, -0.500, -0.2500,  0.4375, -0.125, -0.1250},
			{ 0.3125, -0.500,  0.1875,  0.4375, -0.125,  0.3125},
			{-0.4375, -0.500,  0.1875, -0.3125, -0.125,  0.3125},
			{-0.4375, -0.500, -0.2500, -0.3125, -0.125, -0.1250},
			}
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("carpentry_bench", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
minetest.register_node("tech:masonry_bench", { --masonry_bench--more sophisticated stone crafts
	description   = S("Masonry Bench"),
	tiles         = {"nodes_nature_maraka_log.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.5000,  0.0000, -0.5000,  0.5000, 0.25,  0.5000},
			{-0.5000, -0.5000, -0.5000, -0.3125, 0.00, -0.3125},
			{ 0.3125, -0.5000, -0.5000,  0.5000, 0.00, -0.3125},
			{ 0.3125, -0.5000,  0.3125,  0.5000, 0.00,  0.5000},
			{-0.5000, -0.5000,  0.3125, -0.3125, 0.00,  0.5000},
			{-0.4375, -0.1875, -0.3125, -0.3125, 0.00,  0.3125},
			{ 0.3125, -0.1875, -0.3125,  0.4375, 0.00,  0.3125},
			{-0.3750, -0.1875, -0.4375,  0.3125, 0.00, -0.3125},
			{-0.3750, -0.1875,  0.3125,  0.3750, 0.00,  0.4375},
			}
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("masonry_bench", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--brick_makers_bench
--for fired bricks and associated crafts
minetest.register_node("tech:brick_makers_bench", {
	description   = S("Brick Maker's Bench"),
	tiles         = {"nodes_nature_maraka_log.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.4375,  0.000, -0.3750,  0.4375,  0.1250,  0.3750}, -- NodeBox1
			{-0.3750, -0.500, -0.3125, -0.2500,  0.0000, -0.1875}, -- NodeBox2
			{ 0.2500, -0.500, -0.3125,  0.3750,  0.0000, -0.1875}, -- NodeBox3
			{ 0.2500, -0.500,  0.1875,  0.3750,  0.0000,  0.3125}, -- NodeBox4
			{-0.3750, -0.500,  0.1875, -0.2500,  0.0000,  0.3125}, -- NodeBox5
			{-0.3750, -0.125, -0.1875, -0.2500,  2.42144e-008, 0.1875}, -- NodeBox6
			{ 0.2500, -0.125, -0.1875,  0.3750, -3.72529e-009, 0.1875}, -- NodeBox7
			{-0.2500, -0.125, -0.3125,  0.2500,  5.7742e-008, -0.1875}, -- NodeBox8
			{-0.2500, -0.125,  0.1875,  0.2500, -2.23517e-008, 0.3125}, -- NodeBox9
			{-0.2500,  0.125,  0.1875,  0.2500,  0.2500,  0.2500}, -- NodeBox10
			{-0.2500,  0.125, -0.0625,  0.2500,  0.2500,  1.86265e-009}, -- NodeBox11
			{-0.3125,  0.125, -0.0625, -0.2500,  0.2500,  0.2500}, -- NodeBox12
			{ 0.2500,  0.125, -0.0625,  0.3125,  0.2500,  0.2500}, -- NodeBox13
			{ 0.1875,  0.125, -0.3125,  0.2500,  0.1875, -0.1250}, -- NodeBox14
			}
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("brick_makers_bench", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--spinning_wheel
--turn raw fibres into spun fibre
--including steps here that in reality would require their own equipment
minetest.register_node("tech:spinning_wheel", {
	description   = S("Spinning Wheel"),
	tiles         = {"nodes_nature_maraka_log.png"},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.2500, -0.5000, -0.1875,  0.5000, -0.2500,  0.1875}, -- NodeBox1
			{-0.2500, -0.2500, -0.1875, -0.0625,  0.1875, -0.0625}, -- NodeBox2
			{-0.2500, -0.2500,  0.0625, -0.0625,  0.1875,  0.1875}, -- NodeBox3
			{-0.1875, -0.1875, -0.0625, -0.1250,  0.5000,  0.0625}, -- NodeBox4
			{-0.5000,  0.1250, -0.0625, -0.2500,  0.1875,  0.0625}, -- NodeBox5
			{-0.0625,  0.1250, -0.0625,  0.1875,  0.1875,  0.0625}, -- NodeBox6
			{ 0.3750, -0.2500, -0.0625,  0.5000, -0.1250,  0.0625}, -- NodeBox7
			}
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("spinning_wheel", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--Loom--turn fibre into fabric items
minetest.register_node("tech:loom", {
	description   = S("Loom"),
	tiles         = {"nodes_nature_maraka_log.png"},
	drawtype      = "nodebox",
	paramtype     = "light",
	node_box      = {
		type  = "fixed",
		fixed = {
			{-0.5000, -0.5000, -0.1250, -0.3750,  0.5000,  0.1875}, -- NodeBox1
			{ 0.3750, -0.5000, -0.1250,  0.5000,  0.5000,  0.1875}, -- NodeBox3
			{-0.3750, -0.5000, -0.5000,  0.3750, -0.4375,  0.5000}, -- NodeBox4
			{-0.5000,  0.0000, -0.1250,  0.5000,  0.0625,  0.1875}, -- NodeBox5
			{-0.5000,  0.3125,  0.1875,  0.5000,  0.5000,  0.2500}, -- NodeBox6
			{-0.5000,  0.3125, -0.1875,  0.5000,  0.5000, -0.1250}, -- NodeBox7
			{-0.3750, -0.1875, -0.5000, -0.3125, -0.1250,  0.5000}, -- NodeBox8
			{ 0.3125, -0.1875, -0.5000,  0.3750, -0.1250,  0.5000}, -- NodeBox9
			{-0.4375, -0.1875, -0.5000,  0.4375, -0.1250, -0.4375}, -- NodeBox10
			{-0.4375, -0.1875,  0.4375,  0.4375, -0.1250,  0.5000}, -- NodeBox11
			{-0.3750, -0.5000,  0.3750, -0.3125, -0.1250,  0.4375}, -- NodeBox12
			{ 0.3125, -0.5000,  0.3750,  0.3750, -0.1250,  0.4375}, -- NodeBox13
			{-0.3750, -0.5000, -0.4375, -0.3125, -0.1250, -0.3750}, -- NodeBox14
			{ 0.3125, -0.5000, -0.4375,  0.3750, -0.1250, -0.3750}, -- NodeBox15
			{-0.3125, -0.4375, -0.2500,  0.3125,  0.0000,  0.2500}, -- NodeBox16
		}
		},
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("loom", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
--Glassworking Furnace
--Glassblowing and similar
minetest.register_node("tech:glass_furnace", {
	description   = S("Glass furnace"),
	tiles         = {
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_bricks_and_mortar.png",
		"tech_glassfurnace_front.png",
		},
	drawtype      = "nodebox",
	node_box      = {
		type  = "fixed",
		fixed = {-0.47, -0.5, -0.47, 0.47, 0.31, 0.47},
		},
	stack_max     = minimal.stack_max_bulky,
	paramtype     = "light",
	paramtype2    = "facedir",
	groups        = {dig_immediate=3, falling_node = 1, temp_pass = 1},
	sounds        = nodes_nature.node_sound_wood_defaults(),
	on_rightclick = crafting.make_on_rightclick("glass_furnace", 2, { x = 8, y = 3 }),
	after_place_node = minimal.protection_after_place_node,
	})
---------------------------------------
--Recipes
---- Hand crafts (inv) ----
crafting.register_recipe({ ----craft crafting spot for free
	type   = "inv",
	output = "tech:crafting_spot",
	items  = {},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ ----craft mixing spot for free
	type   = "inv",
	output = "tech:mixing_spot",
	items  = {},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ ----craft threshing spot for free
	type   = "inv",
	output = "tech:threshing_spot",
	items  = {},
	level  = 1,
	always_known = true,
	})
---- Boulders ----
--grinding_stone from craft spot
crafting.register_recipe({
	type   = "crafting_spot",
	output = "tech:grinding_stone",
	items  = {'nodes_nature:granite_boulder', 'nodes_nature:sand 8'},
	level  = 1,
	always_known = true,
	})
--grind a mortar_and_pestle
crafting.register_recipe({
	type   = "grinding_stone",
	output = "tech:mortar_pestle_basalt",
	items  = {'nodes_nature:basalt_boulder 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({
	type   = "grinding_stone",
	output = "tech:mortar_pestle_granite",
	items  = {'nodes_nature:granite_boulder 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({
	type   = "grinding_stone",
	output = "tech:mortar_pestle_limestone",
	items  = {'nodes_nature:limestone_boulder 2'},
	level  = 1,
	always_known = true,
	})
----Wood--
crafting.register_recipe({ --weaving_frame
	type   = "crafting_spot",
	output = "tech:weaving_frame",
	items  = {'tech:stick 12', 'group:fibrous_plant 8'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ --chopping_block
	type   = "crafting_spot",
	output = "tech:chopping_block",
	items  = {'group:log'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({
	type   = "chopping_block",
	output = "tech:chopping_block",
	items  = {'group:log'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ --hammering block
	type   = "chopping_block",
	output = "tech:hammering_block",
	items  = {'group:log'},
	level  = 1,
	always_known = true,
	})
---- Iron ----
crafting.register_recipe({ --hammer ingots into anvil
	type   = "hammering_block",
	output = "tech:anvil",
	items  = {'tech:iron_ingot 4'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({
	type   = "anvil",
	output = "tech:anvil",
	items  = {'tech:iron_ingot 4'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ --carpentary from logs for bench and iron for tools
	type   = "chopping_block",
	output = "tech:carpentry_bench",
	items  = {'tech:iron_ingot 4', 'nodes_nature:maraka_log 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({
	type   = "carpentry_bench",
	output = "tech:carpentry_bench",
	items  = {'tech:iron_ingot 4', 'nodes_nature:maraka_log 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ --masonry_bench from logs for bench and iron for tools
	type   = "carpentry_bench",
	output = "tech:masonry_bench",
	items  = {'tech:iron_ingot 4', 'nodes_nature:maraka_log 2'},
	level  = 1,
	always_known = true,
	})
--brick_makers_bench from logs for bench, simple tools so no iron
--allow early access because includes primitive construction methods
crafting.register_recipe({
	type   = "chopping_block",
	output = "tech:brick_makers_bench",
	items  = {'tech:stick 8', 'group:log 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({
	type   = "carpentry_bench",
	output = "tech:brick_makers_bench",
	items  = {'tech:stick 8', 'group:log 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ --spinning wheel. wood,
	type   = "carpentry_bench",
	output = "tech:spinning_wheel",
	items  = {'nodes_nature:maraka_log 2'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ --loom. wood, fibre for mechanisms
	type   = "carpentry_bench",
	output = "tech:loom",
	items  = {'nodes_nature:maraka_log 2', 'tech:coarse_fibre 12'},
	level  = 1,
	always_known = true,
	})
crafting.register_recipe({ -- Glass furnace from bricks for the main structure and iron for the tools
	type   = "brick_makers_bench",
	output = "tech:glass_furnace",
	items  = {'tech:iron_ingot', 'tech:loose_brick 3', 'tech:lime_mortar'},
	level  = 1,
	always_known = true,
	})
