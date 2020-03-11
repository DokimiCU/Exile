----------------------------------------------------------
--WOODWORKING


-----------------------------------------------------------
--Wooden planks?


-----------------------------------------------------------
--Chest ...see storage

crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_chest",
	items = {'tech:iron_ingot 1', 'group:log 4', 'tech:vegetable_oil'},
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
 groups = {choppy=2, dig_immediate=2, flammable=1, attached_node=1, temp_pass = 1},
 drop = "tech:wooden_ladder",
 sounds = nodes_nature.node_sound_wood_defaults(),

})

crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_ladder 4",
	items = {'group:log'},
	level = 1,
	always_known = true,
})

-----------------------------------------------------------
--Bed


-----------------------------------------------------------
