
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
	paramtype2 = "glasslikeliquidlevel",
	is_ground_content = false,
	sunlight_propagates = true,
  use_texture_alpha = true,
  --temp_effect = -3,
  --temp_effect_max = 5,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 1,},-- temp_effect = 1},
})


------------------------------------
--ANTIQUORIUM
--the super material of the ancients
------------------------------------
minetest.register_node("artifacts:antiquorium", {
	description = "Antiquorium",
	tiles = {"artifacts_antiquorium.png"},
  stack_max = minimal.stack_max_bulky *4,
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
  use_texture_alpha = true,
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
	groups = {cracky = 1},
})


------------------------------------
--ANTIQUORIUM DOOR
------------------------------------
doors.register("door_antiquorium", {
		tiles = {{ name = "artifacts_antiquorium_door.png", backface_culling = true }},
		description = "Antiquorium Door",
		inventory_image = "artifacts_antiquorium_door_item.png",
		groups = {cracky = 1},
		sounds = nodes_nature.node_sound_glass_defaults(),
})
