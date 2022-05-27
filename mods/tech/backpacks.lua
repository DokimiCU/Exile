------------------------------------
--BACK PACKS
--registered with backpacks
--put backpack in the name if wish to prevent infinite stack
-----------------------------------

-- Internationalization
local S = tech.S

---------------------------------------
--Register


-- Woven
backpacks.register_backpack("woven_bag", S("Woven Bag"), "tech_woven.png", 8,2, {snappy = 3, dig_immediate = 3, temp_pass = 1}, nodes_nature.node_sound_leaves_defaults())

-- Wicker
backpacks.register_backpack("wicker_bag", S("Wicker Bag"), "tech_wicker.png", 8,2, {snappy = 3, dig_immediate = 3, temp_pass = 1}, nodes_nature.node_sound_leaves_defaults())


-- fabric
backpacks.register_backpack("fabric_bag", S("Fabric Bag"), "tech_coarse_fabric.png", 8,4, {snappy = 3, dig_immediate = 3, temp_pass = 1}, nodes_nature.node_sound_leaves_defaults())


---------------------------------------
--Recipes

--
--Hand crafts (crafting_spot)
--

----woven from fibrous_plant
crafting.register_recipe({
	type = "weaving_frame",
	output = "backpacks:backpack_woven_bag 1",
	items = {"group:fibrous_plant 48"},
	level = 1,
	always_known = true,
})

----wicker from sticks
crafting.register_recipe({
	type = "weaving_frame",
	output = "backpacks:backpack_wicker_bag 1",
	items = {"tech:stick 48"},
	level = 1,
	always_known = true,
})


--
--loom
--

----fabric from...fabric
crafting.register_recipe({
	type = "loom",
	output = "backpacks:backpack_fabric_bag 1",
	items = {"tech:coarse_fabric 6"},
	level = 1,
	always_known = true,
})
