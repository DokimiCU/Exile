---------------------------------------------------------
--STONE
--sedimentary rocks can be deconstructed into sediment, but not reformed
--sedimentary rocks are of the weakly consolidated soft variety

local list = {
	{"sandstone", "Sandstone",3, "sediment", "nodes_nature:sand",},
	{"siltstone", "Siltstone", 3, "sediment", "nodes_nature:silt",},
	{"claystone", "Claystone", 3, "sediment", "nodes_nature:clay",},
	{"conglomerate", "Conglomerate", 3,  "sediment", "nodes_nature:gravel",},
	{"limestone", "Limestone", 3},
	{"ironstone", "Ironstone", 3},
  {"granite", "Granite", 1},
	{"basalt", "Basalt", 2},
	{"gneiss", "Gneiss", 1},
	{"jade", "Jade", 1},

}


for i in ipairs(list) do
	local name = list[i][1]
	local desc = list[i][2]
	local hardness = list[i][3]
	local type = list[i][4]
	local sediment = list[i][5]


	--harder rocks drop boulders
	local g = {cracky = hardness, stone = 1}
	local dropped = "nodes_nature:"..name.."_boulder"
	local s = nodes_nature.node_sound_stone_defaults()

	--make soft sedimentary rocks into sediment
	if type == "sediment" then
		g = {cracky = hardness, crumbly = 1, soft_stone = 1}
		dropped = sediment
		s = nodes_nature.node_sound_gravel_defaults({footstep = {name = "nodes_nature_hard_footstep", gain = 0.25},})
	end


	--register raw
	minetest.register_node("nodes_nature:"..name, {
		description = desc,
		tiles = {"nodes_nature_"..name..".png"},
		stack_max = minimal.stack_max_bulky,
		groups = g,
		drop = dropped,
		sounds = s,
	})

	if not sediment then

		--boulder
		minetest.register_node("nodes_nature:"..name.."_boulder",{
			description = desc.." Boulder",
			drawtype = "mesh",
			mesh = "nodes_nature_boulder.obj",
			tiles = {"nodes_nature_"..name..".png"},
			stack_max = minimal.stack_max_bulky,
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {cracky = hardness, falling_node = 1, oddly_breakable_by_hand = 1},
			selection_box = {
				type = "fixed",
				fixed = {-7/16, -8/16, -7/16, 7/16, 7/16, 7/16},
			},
			collision_box = {
				type = "fixed",
				fixed = {-7/16, -8/16, -7/16, 7/16, 7/16, 7/16},
			},
			sounds = nodes_nature.node_sound_stone_defaults(),
		})


		--blocks and bricks
		--drystone construction. (see tech for the mortared version)
		--Bricks are more portable.
		minetest.register_node("nodes_nature:"..name.."_brick", {
			description = desc.." Brick",
			tiles = {"nodes_nature_"..name.."_brick.png"},
			paramtype2 = "facedir",
			stack_max = minimal.stack_max_bulky *3,
			groups = {cracky = hardness, falling_node = 1,  oddly_breakable_by_hand = 1, masonry = 1},
			sounds = nodes_nature.node_sound_stone_defaults(),
		})

		--block is a shaped boulder, so has similar properties
		minetest.register_node("nodes_nature:"..name.."_block", {
			description = desc.. " Block",
			tiles = {"nodes_nature_"..name.."_block.png"},
			--drawtype = "nodebox",
			--paramtype = "light",
			--[[...fancy block
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
					{-0.375, -0.5, 0.375, 0.375, 0.5, 0.5},
					{-0.375, -0.5, -0.5, 0.375, 0.5, -0.375},
					{0.375, -0.5, -0.375, 0.5, 0.5, 0.375},
					{-0.5, -0.5, -0.375, -0.375, 0.5, 0.375},
					{-0.5, -0.375, -0.5, -0.375, 0.375, -0.375},
					{0.375, -0.375, -0.5, 0.5, 0.375, -0.375},
					{0.375, -0.375, 0.375, 0.5, 0.375, 0.5},
					{-0.5, -0.375, 0.375, -0.375, 0.375, 0.5},
				}
			},]]
			stack_max = minimal.stack_max_bulky *2,
			groups = {cracky = hardness, falling_node = 1, oddly_breakable_by_hand = 1, masonry = 1},
			sounds = nodes_nature.node_sound_stone_defaults(),
		})

		--hammer out blocks etc from boulder
		crafting.register_recipe({
			type = "hammering_block",
			output = "nodes_nature:"..name.."_block",
			items = {"nodes_nature:"..name.."_boulder"},
			level = 1,
			always_known = true,
		})

		crafting.register_recipe({
			type = "masonry_bench",
			output = "nodes_nature:"..name.."_block",
			items = {"nodes_nature:"..name.."_boulder"},
			level = 1,
			always_known = true,
		})

		crafting.register_recipe({
			type = "masonry_bench",
			output = "nodes_nature:"..name.."_brick",
			items = {"nodes_nature:"..name.."_boulder"},
			level = 1,
			always_known = true,
		})

		--recycle block (e.g. so can get iron ore)
		crafting.register_recipe({
			type = "mixing_spot",
			output = "nodes_nature:"..name.."_boulder",
			items = {"nodes_nature:"..name.."_block"},
			level = 1,
			always_known = true,
		})

		--stairs and slabs

		--brick
		stairs.register_stair_and_slab(
			name.."_brick",
			"nodes_nature:"..name.."_brick",
			"masonry_bench",
			"true",
			{cracky = hardness, falling_node = 1, oddly_breakable_by_hand = 1},
			{"nodes_nature_"..name.."_brick.png" },
			desc.." Brick Stair",
			desc.." Brick Slab",
			minimal.stack_max_bulky * 6,
			nodes_nature.node_sound_stone_defaults()
		)

		--block
		stairs.register_stair_and_slab(
			name.."_block",
			"nodes_nature:"..name.."_block",
			"masonry_bench",
			"false",
			{cracky = hardness, falling_node = 1, oddly_breakable_by_hand = 1},
			{"nodes_nature_"..name.."_block.png" },
			desc.." Block Stair",
			desc.." Block Slab",
			minimal.stack_max_bulky * 4,
			nodes_nature.node_sound_stone_defaults()
		)
	end

end

------------------------------------------------------------------
--Special features
