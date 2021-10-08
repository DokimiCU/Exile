----------------------------------------------------------
--WOODWORKING


-----------------------------------------------------------
--Wooden planks?


-----------------------------------------------------------
--Chest ...see storage

crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_chest",
	items = {'tech:iron_fittings 2', 'group:log 4', 'tech:vegetable_oil'},
	level = 1,
	always_known = true,
})


-----------------------------------------------------------
--Ladder
minetest.register_node("tech:wooden_ladder", {
 description = "Wooden Ladder",
 drawtype = "nodebox",
 node_box = {
		type = "fixed",
		fixed = {
			{0.3125, -0.5, 0.3125, 0.5, 0.5, 0.5}, -- NodeBox12
			{-0.5, -0.5, 0.3125, -0.3125, 0.5, 0.5}, -- NodeBox13
			{-0.3125, 0.3125, 0.375, 0.3125, 0.4375, 0.4375}, -- NodeBox14
			{-0.3125, -0.4375, 0.375, 0.3125, -0.3125, 0.4375}, -- NodeBox15
			{-0.3125, -0.1875, 0.375, 0.3125, -0.0625, 0.4375}, -- NodeBox16
			{-0.3125, 0.0625, 0.375, 0.3125, 0.1875, 0.4375}, -- NodeBox17
		}
	},
 tiles = { "tech_stick.png"},
 stack_max = minimal.stack_max_medium,
 paramtype = "light",
 paramtype2 = "facedir",
 climbable = true,
 sunlight_propagates = true,
 groups = {choppy=2, dig_immediate=2, flammable=1, attached_node=1, temp_pass = 1, ladder = 1},
 drop = "tech:wooden_ladder",
 sounds = nodes_nature.node_sound_wood_defaults(),

 after_place_node = function(pos, placer, itemstack, pointed_thing)
    local node = minetest.get_node(pos)
    local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}
    local under = minetest.get_node(pos_under)
    if minetest.get_item_group(under.name, "ladder") > 0 then
       minetest.set_node(pos, {name = node.name, param1 = node.param1,
			       param2 = under.param2})
    end
 end
})

crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_ladder 4",
	items = {'group:log'},
	level = 1,
	always_known = true,
})

-----------------------------------------------------------
--Floor boards
--good flooring for large multi-story buildings


minetest.register_node("tech:wooden_floor_boards", {
 description = "Wooden Floor Boards",
 drawtype = "nodebox",
 node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.25, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, 0, -0.5, -0.125, 0.25, 0.5}, -- NodeBox2
			{0.125, 0, -0.5, 0.375, 0.25, 0.5}, -- NodeBox5
		}
	},
	tiles = {
		"tech_wooden_floor_boards_top.png",
		"tech_wooden_floor_boards_bottom.png",
		"tech_wooden_floor_boards_side.png",
		"tech_wooden_floor_boards_side.png",
		"tech_wooden_floor_boards_front.png",
		"tech_wooden_floor_boards_front.png"
	},
 stack_max = minimal.stack_max_medium,
 paramtype = "light",
 paramtype2 = "facedir",
 groups = {choppy=2, flammable=1},
 sounds = nodes_nature.node_sound_wood_defaults(),

})


crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_floor_boards 4",
	items = {'group:log', 'tech:vegetable_oil'},
	level = 1,
	always_known = true,
})

-----------------------------------------------------------
--Wooden Stairs


minetest.register_node("tech:wooden_stairs", {
 description = "Wooden Stairs",
 tiles = {"tech_oiled_wood.png"},
 drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.5, 0.5, -0.25, -0.25},
			{-0.5, 0.375, 0.25, 0.5, 0.5, 0.5},
			{-0.5, -0.125, -0.25, 0.5, 0, 0},
			{-0.5, 0.125, 0, 0.5, 0.25, 0.25},
			{-0.5, -0.5, -0.4375, 0.5, -0.375, -0.25},
			{-0.5, -0.25, -0.1875, 0.5, -0.125, 0},
			{-0.5, 0, 0.0625, 0.5, 0.125, 0.25},
			{-0.5, 0.25, 0.3125, 0.5, 0.375, 0.5},
		}
	},
 stack_max = minimal.stack_max_medium,
 paramtype = "light",
 paramtype2 = "facedir",
 sunlight_propagates = true,
 groups = {choppy=2, flammable=1},
 sounds = nodes_nature.node_sound_wood_defaults(),

})


crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_stairs 4",
	items = {'group:log', 'tech:vegetable_oil'},
	level = 1,
	always_known = true,
})
