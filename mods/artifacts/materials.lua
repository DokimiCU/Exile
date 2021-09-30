------------------------------------
--MATERIALS
--exotic building materials
------------------------------------




------------------------------------
--MOON GLASS
--glowing glass
------------------------------------
minetest.register_node("artifacts:moon_glass", {
	description = "Moon Glass",
	drawtype = "glasslike",
	tiles = {"artifacts_moon_glass.png"},
	stack_max = minimal.stack_max_bulky *4,
	light_source = 5,
	paramtype = "light",
	use_texture_alpha = "clip",
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 1,},
})

------------------------------------
--SUN STONE
-- bright glowing glass, with warming effect
------------------------------------
minetest.register_node("artifacts:sun_stone", {
	description = "Sun Stone",
	tiles = {"artifacts_sun_stone.png"},
	stack_max = 1,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, -0.4375, 0.25}, -- NodeBox1
			{-0.0625, -0.5, 0.25, 0.0625, -0.4375, 0.5}, -- NodeBox2
			{-0.0625, -0.5, -0.5, 0.0625, -0.4375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox4
			{-0.5, -0.5, -0.0625, -0.25, -0.4375, 0.0625}, -- NodeBox5
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.375, 0.1875}, -- NodeBox6
			{0.25, -0.5, -0.3125, 0.3125, -0.4375, -0.25}, -- NodeBox8
			{0.25, -0.5, 0.25, 0.3125, -0.4375, 0.3125}, -- NodeBox9
			{-0.3125, -0.5, 0.25, -0.25, -0.4375, 0.3125}, -- NodeBox10
			{-0.3125, -0.5, -0.3125, -0.25, -0.4375, -0.25}, -- NodeBox11
		}
	},
	light_source = 13,
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = false,
	sunlight_propagates = true,
	use_texture_alpha = "clip",
	temp_effect = 4,
	temp_effect_max = 40,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 3, oddly_breakable_by_hand = 3, attached_node = 1, temp_effect = 1, temp_pass = 1},
})



------------------------------------
--MOON STONE
-- glowing glass, with cooling effect
------------------------------------
minetest.register_node("artifacts:moon_stone", {
	description = "Moon Stone",
	tiles = {"artifacts_moon_glass.png"},
  stack_max = 1,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, -0.375, 0.0625}, -- NodeBox1
			{0.0625, -0.5, 0.0625, 0.125, -0.375, 0.125}, -- NodeBox2
			{0.0625, -0.5, -0.125, 0.125, -0.375, -0.0625}, -- NodeBox3
			{-0.125, -0.5, -0.125, -0.0625, -0.375, -0.0625}, -- NodeBox4
			{-0.125, -0.5, 0.0625, -0.0625, -0.375, 0.125}, -- NodeBox5
			{0.125, -0.5, -0.125, 0.25, -0.4375, 0.125}, -- NodeBox6
			{-0.25, -0.5, -0.125, -0.125, -0.4375, 0.125}, -- NodeBox7
			{-0.125, -0.5, 0.125, 0.125, -0.4375, 0.25}, -- NodeBox8
			{-0.125, -0.5, -0.25, 0.125, -0.4375, -0.125}, -- NodeBox9
			{0.125, -0.5, -0.375, 0.25, -0.4375, -0.25}, -- NodeBox10
			{0.25, -0.5, -0.25, 0.375, -0.4375, -0.125}, -- NodeBox11
			{0.25, -0.5, 0.125, 0.375, -0.4375, 0.25}, -- NodeBox12
			{0.125, -0.5, 0.25, 0.25, -0.4375, 0.375}, -- NodeBox13
			{-0.25, -0.5, 0.25, -0.125, -0.4375, 0.375}, -- NodeBox14
			{-0.375, -0.5, 0.125, -0.25, -0.4375, 0.25}, -- NodeBox15
			{-0.375, -0.5, -0.25, -0.25, -0.4375, -0.125}, -- NodeBox16
			{-0.25, -0.5, -0.375, -0.125, -0.4375, -0.25}, -- NodeBox17
			{-0.125, -0.5, -0.5, 0.125, -0.4375, -0.375}, -- NodeBox18
			{-0.125, -0.5, 0.375, 0.125, -0.4375, 0.5}, -- NodeBox19
			{-0.5, -0.5, -0.125, -0.375, -0.4375, 0.125}, -- NodeBox20
			{0.375, -0.5, -0.125, 0.5, -0.4375, 0.125}, -- NodeBox21
		}
	},
  light_source = 7,
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = false,
	sunlight_propagates = true,
  use_texture_alpha = "blend",
  temp_effect = -4,
  temp_effect_max = 0,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 3, oddly_breakable_by_hand = 3, attached_node = 1, temp_effect = 1, temp_pass = 1},
})

------------------------------------
--STAR STONE
--small glowing glass
------------------------------------

minetest.register_node("artifacts:star_stone", {
	description = "Star Stone",
	tiles = {"artifacts_moon_glass.png"},
  stack_max = minimal.stack_max_medium * 2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, -0.4375, 0.0625}, -- NodeBox1
			{0.0625, -0.5, 0.0625, 0.125, -0.4375, 0.125}, -- NodeBox2
			{0.0625, -0.5, -0.125, 0.125, -0.4375, -0.0625}, -- NodeBox3
			{-0.125, -0.5, -0.125, -0.0625, -0.4375, -0.0625}, -- NodeBox4
			{-0.125, -0.5, 0.0625, -0.0625, -0.4375, 0.125}, -- NodeBox5
		}
	},
  light_source = 3,
	paramtype = "light",
	paramtype2 = "wallmounted",
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {oddly_breakable_by_hand = 3, attached_node = 1, temp_pass = 1},

})


------------------------------------
--ANTIQUORIUM
--the super material of the ancients
------------------------------------
minetest.register_node("artifacts:antiquorium", {
	description = "Antiquorium",
	tiles = {"artifacts_antiquorium.png"},
  stack_max = minimal.stack_max_bulky *4,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 1,},
})

------------------------------------
--ANTIQUORIUM LADDER
------------------------------------

minetest.register_node("artifacts:antiquorium_ladder", {
	description = "Antiquorium Ladder",
	drawtype = "signlike",
  stack_max = minimal.stack_max_medium,
	tiles = {"artifacts_antiquorium_ladder.png"},
	inventory_image = "artifacts_antiquorium_ladder.png",
	wield_image = "artifacts_antiquorium_ladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 2},
})


------------------------------------
--ANTIQUORIUM DOOR
------------------------------------
doors.register("door_antiquorium", {
		tiles = {{ name = "artifacts_antiquorium_door.png", backface_culling = true }},
		description = "Antiquorium Door",
		inventory_image = "artifacts_antiquorium_door_item.png",
		groups = {cracky = 2},
		sounds = nodes_nature.node_sound_glass_defaults(),
})


doors.register_trapdoor("artifacts:trapdoor_antiquorium", {
	description = "Antiquorium Trapdoor",
	inventory_image = "artifacts_antiquorium_chest_top.png",
	wield_image = "artifacts_antiquorium_chest_top.png",
	tile_front = "artifacts_antiquorium_chest_top.png",
	tile_side = "artifacts_antiquorium_chest_top.png",
	groups = {cracky = 2},
	sounds = nodes_nature.node_sound_wood_defaults(),
})



------------------------------------
--TRAMPOLINE
------------------------------------
minetest.register_node('artifacts:trampoline', {
	description = 'Trampoline',
	tiles = {'artifacts_antiquorium_chest_top.png'},
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox1
			{-0.5, 0.3125, -0.5, 0.5, 0.5, 0.5}, -- NodeBox2
			{-0.1875, -0.3125, -0.1875, 0.1875, -0.1875, 0.1875}, -- NodeBox3
			{-0.1875, 0.1875, -0.1875, 0.1875, 0.3125, 0.1875}, -- NodeBox4
			{-0.125, 0.0625, -0.125, 0.125, 0.1875, 0.125}, -- NodeBox5
			{-0.125, -0.1875, -0.125, 0.125, -0.0625, 0.125}, -- NodeBox6
			{-0.1875, -0.0625, -0.1875, 0.1875, 0.0625001, 0.1875}, -- NodeBox7
		}
	},
	groups = {fall_damage_add_percent=-70, bouncy=85, oddly_breakable_by_hand = 3, temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults({footstep = {name="artifacts_bouncy", gain=0.8}}),
})

------------------------------------
--TRAMPOLINE
------------------------------------
minetest.register_node('artifacts:conveyor', {
	description = 'Conveyor',
	tiles = {'artifacts_antiquorium_chest_top.png'},
	stack_max = minimal.stack_max_medium *2,
	drawtype = "nodebox",
	light_source = 2,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5}, -- NodeBox1
		}
	},
	groups = {slippery = 1000, oddly_breakable_by_hand = 3, temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults({footstep = {name="artifacts_transport_fail", gain=0.5}}),
})
