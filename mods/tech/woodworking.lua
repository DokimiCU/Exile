----------------------------------------------------------
--WOODWORKING

-- Internationalisaton
local S = tech.S




-----------------------------------------------------------
--primitive_wooden_chest -- see storage
crafting.register_recipe({
	type = "chopping_block",
	output = "tech:primitive_wooden_chest",
	items = {'group:log 4'},
	level = 1,
	always_known = true,
})


-----------------------------------------------------------
--Wooden Water pot
--for collecting water, catching rain water
minetest.register_node("tech:wooden_water_pot", {
	description = S("Wooden Water Pot"),
	tiles = {
		"tech_wooden_water_pot_empty.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png"
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
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		return liquid_store.on_use_empty_bucket(itemstack, user, pointed_thing)
	end,
		--collect rain water
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(30,60))
	end,
	on_timer =function(pos, elapsed)
		return water_pot(pos, "tech:wooden_water_pot", elapsed)
	end,
	groups = {dig_immediate = 3, flammable = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_wood_defaults(),

})


crafting.register_recipe({
	type = "chopping_block",
	output = "tech:wooden_water_pot",
	items = {'group:log 2'},
	level = 1,
	always_known = true,
})


-----------------------------------------------
--Register water stores
--source, nodename, nodename_empty, tiles, node_box, desc, groups

-- pot with salt water
liquid_store.register_stored_liquid(
	"nodes_nature:salt_water_source",
	"tech:wooden_water_pot_salt_water",
	"tech:wooden_water_pot",
	{
		"tech_wooden_water_pot_water.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png"
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
	S("Wooden Water Pot with Salt Water"),
	{dig_immediate = 2})


--pot with freshwater
liquid_store.register_stored_liquid(
	"nodes_nature:freshwater_source",
	"tech:wooden_water_pot_freshwater",
	"tech:wooden_water_pot",
	{
		"tech_wooden_water_pot_water.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png",
		"tech_primitive_wood.png"
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
	S("Wooden Water Pot with Freshwater"),
	{dig_immediate = 2})


--make freshwater Pot drinkable on click
minetest.override_item("tech:wooden_water_pot_freshwater",{
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
			minetest.set_node(pos, {name = "tech:wooden_water_pot"})
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.25})
		end
	end
})

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
 description = S("Wooden Ladder"),
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
 groups = {choppy=2, dig_immediate=2, flammable=2, attached_node=1, temp_pass = 1, ladder = 1},
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
 end,
 on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
    local itemname = itemstack:get_name()
    if minetest.get_item_group(itemname, "ladder") > 0 then
       local pos_over = {x = pos.x, y = pos.y + 1, z = pos.z}
       local over = minetest.get_node(pos_over)
       if over.name == "air" then
	  minetest.place_node(pos_over, {name = itemname})
	  itemstack:take_item()
       end
    else
       if itemstack:get_definition().type == "node" then
	  return minetest.item_place_node(itemstack, clicker,
					  pointed_thing)
       end
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
 description = S("Wooden Floor Boards"),
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
 groups = {choppy=2, flammable=3},
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
 description = S("Wooden Stairs"),
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
 groups = {choppy=2, flammable=3},
 sounds = nodes_nature.node_sound_wood_defaults(),

})


crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:wooden_stairs 4",
	items = {'group:log', 'tech:vegetable_oil'},
	level = 1,
	always_known = true,
})
