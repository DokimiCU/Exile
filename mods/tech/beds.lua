-------------------------------------
--BED REST REGISTER BEDS
--and crafts...
------------------------------------

-- Internationalization
local S = tech.S
local FS = tech.FS

--------------------------------
--Free and ineffective bed
--so you don't die simply because you can't lie down
--a bit like crafing spots

bed_rest.register_bed("tech:sleeping_spot", {
	description = S("Sleeping Spot"),
	inventory_image = "tech_sleeping_spot_inv.png",
	wield_image = "tech_sleeping_spot_inv.png",
	stack_max = 1,
  tiles = {
		bottom = {
			"tech_sleeping_spot.png^[transformR180",
			--"tech_thatch.png",
			--"tech_thatch.png",
			--"tech_thatch.png^[transformfx",
			--"tech_thatch.png"
		},
		top = {
			"tech_sleeping_spot.png",
			--"tech_thatch.png",
			--"tech_thatch.png",
			--"tech_thatch.png^[transformfx",
			--"tech_thatch.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, -0.48, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, -0.48, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.45, 1.5},
	sounds =  nodes_nature.node_sound_wood_defaults(),
	groups = {snappy = 3, dig_immediate = 3, falling_node = 1, bed = 1,
		  temp_pass = 1, nobones = 1},
	bed_level = 0.5,


	walkable = false,
	buildable_to = true,
	floodable = true,
	on_punch = function(pos, node, player)
		local name = player:get_player_name()
		if bed_rest.player[name] == nil then
			minetest.remove_node(pos)
		end
	end

})



-------------------------------
--Cheap bed
--for travel, early game
bed_rest.register_bed("tech:sleeping_mat", {
	description = S("Sleeping Mat"),
	inventory_image = "tech_sleeping_mat.png",
	wield_image = "tech_sleeping_mat.png",
	stack_max = minimal.stack_max_medium/2,
  tiles = {
		bottom = {
			"tech_thatch.png^[transformR90",
			"tech_thatch.png",
			"tech_thatch.png",
			"tech_thatch.png^[transformfx",
			"tech_thatch.png"
		},
		top = {
			"tech_thatch.png^[transformR90",
			"tech_thatch.png",
			"tech_thatch.png",
			"tech_thatch.png^[transformfx",
			"tech_thatch.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.4, 1.5},
	sounds =  nodes_nature.node_sound_leaves_defaults(),
	groups = {snappy = 3, dig_immediate = 3, flammable = 3, bed = 1,
		  temp_pass = 1, fall_damage_add_percent = -5},
	bed_level = 1,
})


------------------------------------------
--primitive bed
--decent cave man bed
bed_rest.register_bed("tech:primitive_bed", {
	description = S("Primitive Bed"),
	inventory_image = "tech_primitive_bed.png",
	wield_image = "tech_primitive_bed.png",
	stack_max = minimal.stack_max_bulky,
  tiles = {
		bottom = {
			"tech_thatch.png^[transformR90",
			"tech_primitive_bed_bottom.png",
			"tech_primitive_bed_side.png",
			"tech_primitive_bed_side.png^[transformfx",
			"tech_primitive_bed_side.png"
		},
		top = {
			"tech_thatch.png^[transformR90",
			"tech_primitive_bed_bottom.png",
			"tech_primitive_bed_side.png",
			"tech_primitive_bed_side.png^[transformfx",
			"tech_primitive_bed_side.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	groups = {choppy = 3, oddly_breakable_by_hand = 3, flammable = 3,
		  bed = 1, temp_pass = 1, fall_damage_add_percent = -20},
	sounds =  nodes_nature.node_sound_wood_defaults(),
	bed_level = 2,
})








------------------------------------------------
--mattress (upgraded version of sleeping mat)
--as good as primitive_bed
bed_rest.register_bed("tech:mattress", {
	description = S("Mattress"),
	inventory_image = "tech_mattress.png",
	wield_image = "tech_mattress.png",
	stack_max = minimal.stack_max_medium/4,
  tiles = {
		bottom = {
			"tech_fine_fabric.png^[transformR90",
			"tech_fine_fabric.png",
			"tech_fine_fabric.png",
			"tech_fine_fabric.png^[transformfx",
			"tech_fine_fabric.png"
		},
		top = {
			"tech_fine_fabric.png^[transformR90",
			"tech_fine_fabric.png",
			"tech_fine_fabric.png",
			"tech_fine_fabric.png^[transformfx",
			"tech_fine_fabric.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.3, 1.5},
	sounds =  nodes_nature.node_sound_leaves_defaults(),
	groups = {snappy = 3, dig_immediate = 3, flammable = 3,
		  bed = 1, temp_pass = 1, fall_damage_add_percent = -35},
	bed_level = 2,
})



------------------------------------------
--bed
--decent bed
bed_rest.register_bed("tech:bed", {
	description = S("Bed"),
	inventory_image = "tech_bed.png",
	wield_image = "tech_bed.png",
	stack_max = minimal.stack_max_bulky,
  tiles = {
		bottom = {
			"tech_fine_fabric.png^[transformR90",
			"tech_bed_bottom.png",
			"tech_bed_side.png",
			"tech_bed_side.png^[transformfx",
			"tech_bed_side.png"
		},
		top = {
			"tech_fine_fabric.png^[transformR90",
			"tech_bed_bottom.png",
			"tech_bed_side.png",
			"tech_bed_side.png^[transformfx",
			"tech_bed_side.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	groups = {choppy = 3, oddly_breakable_by_hand = 3, flammable = 3,
		  bed = 1, temp_pass = 1, fall_damage_add_percent = -35},
	sounds =  nodes_nature.node_sound_wood_defaults(),
	bed_level = 3,
})





------------------------------------
--RECIPES

--sleeping_spot is free
crafting.register_recipe({
	type = "inv",
	output = "tech:sleeping_spot",
	items = {},
	level = 1,
	always_known = true,
})


--sleeping_mat from cheap thatch
crafting.register_recipe({
	type = "weaving_frame",
	output = "tech:sleeping_mat",
	items = {"tech:thatch"},
	level = 1,
	always_known = true,
})

--Primitve bed from sticks and mats
crafting.register_recipe({
	type = "weaving_frame",
	output = "tech:primitive_bed",
	items = {"tech:sleeping_mat 4", "tech:stick 36"},
	level = 1,
	always_known = true,
})




--Mattress from fine fabric stuffed with fine fibre
crafting.register_recipe({
	type = "loom",
	output = "tech:mattress",
	items = {"tech:fine_fabric 6", "tech:coarse_fibre 24"},
	level = 1,
	always_known = true,
})

--Bed, nice wood frame, mattress
crafting.register_recipe({
	type = "carpentry_bench",
	output = "tech:bed",
	items = {"tech:mattress", "group:log 4", "tech:vegetable_oil"},
	level = 1,
	always_known = true,
})
