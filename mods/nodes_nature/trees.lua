---------------------------------------------------------
--TREES
--

--[[param2
Currently the following meshes are choosable:
  * 0 = a "x" shaped plant (ordinary plant)
  * 1 = a "+" shaped plant (just rotated 45 degrees)
  * 2 = a "*" shaped plant with 3 faces instead of 2
  * 3 = a "#" shaped plant with 4 faces instead of 2
  * 4 = a "#" shaped plant with 4 faces that lean
]]



local random = math.random
local floor = math.floor
---------------------------------------------------------
--
-- Leafdecay
--


-- Leafdecay
local function leafdecay_after_destruct(pos, oldnode, def)
	for _, v in pairs(minetest.find_nodes_in_area(vector.subtract(pos, def.radius),
			vector.add(pos, def.radius), def.leaves)) do
		local node = minetest.get_node(v)
		local timer = minetest.get_node_timer(v)
		if node.param2 == 0 and not timer:is_started() then
			timer:start(math.random(20, 120) / 10)
		end
	end
end

local function leafdecay_on_timer(pos, def)
	if minetest.find_node_near(pos, def.radius, def.trunks) then
		return false
	end

	local node = minetest.get_node(pos)
	local drops = minetest.get_node_drops(node.name)
	for _, item in ipairs(drops) do
		local is_leaf
		for _, v in pairs(def.leaves) do
			if v == item then
				is_leaf = true
			end
		end
		if minetest.get_item_group(item, "leafdecay_drop") ~= 0 or
				not is_leaf then
			minetest.add_item({
				x = pos.x - 0.5 + math.random(),
				y = pos.y - 0.5 + math.random(),
				z = pos.z - 0.5 + math.random(),
			}, item)
		end
	end

	minetest.remove_node(pos)
	minetest.check_for_falling(pos)
end

local function register_leafdecay(def)
	assert(def.leaves)
	assert(def.trunks)
	assert(def.radius)
	for _, v in pairs(def.trunks) do
		minetest.override_item(v, {
			after_destruct = function(pos, oldnode)
				leafdecay_after_destruct(pos, oldnode, def)
			end,
		})
	end
	for _, v in pairs(def.leaves) do
		minetest.override_item(v, {
			on_timer = function(pos)
				leafdecay_on_timer(pos, def)
			end,
		})
	end
end

---------------------------------------------------------
--
--Mark
--used to regrow fruit, leaves, trunks on trees

minetest.register_node("nodes_nature:tree_mark", {
	description = "Tree Marker",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local saved_name = meta:get_string("saved_name")
		local saved_param2 = meta:get_string("saved_param2")
		local leaf_name = meta:get_string("leaf_name")
		local tree_name = meta:get_string("tree_name")

		local positions = minetest.find_nodes_in_area(
			{x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
			{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
			{leaf_name, tree_name })

		if #positions == 0 then
			minetest.remove_node(pos)
		elseif climate.get_rain(pos, 15) then
			--needs rain for growth
			minetest.set_node(pos, {name = saved_name, param2 = saved_param2})
		else
			--no rain, so wait
			return true
		end
	end
})


---------------------------------------------------------
local base_tree_growth = 31000
local base_leaf_growth = 21000
local base_fruit_growth = 19000


local treelist = {
	{"maraka", "Maraka Tree", "maraka_nut", "Maraka Nut", 1, {-0.2, 0.2, -0.2, 0.2, 0.5, 0.2},1},
	{"tangkal", "Tangkal Tree", "tangkal_fruit", "Tangkal Fruit", 1, {-0.1, 0.1, -0.1, 0.1, 0.5, 0.1},2},
}


for i in ipairs(treelist) do
	local treename = treelist[i][1]
	local treedesc = treelist[i][2]
	local fruitname = treelist[i][3]
	local fruitdesc = treelist[i][4]
	local p2_fruit  = treelist[i][5]
	local selbox_fruit = treelist[i][6]
	local hardness = treelist[i][7]

	if not selbox_fruit then
		selbox_fruit = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	end



	--trunk
	minetest.register_node("nodes_nature:"..treename.."_tree", {
		description = treedesc,
		tiles = {
			"nodes_nature_"..treename.."_tree_top.png",
			"nodes_nature_"..treename.."_tree_top.png",
			"nodes_nature_"..treename.."_tree.png"
		},
		stack_max = minimal.stack_max_bulky,
		drop = "nodes_nature:"..treename.."_log",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {tree = 1, choppy = hardness, flammable = 1},
		sounds = nodes_nature.node_sound_wood_defaults(),
		on_place = minetest.rotate_node,
		after_place_node = function(pos, placer, itemstack)
			minetest.set_node(pos, {name = "nodes_nature:"..treename.."_tree", param3 = 1})
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			if oldnode.param3 ~= 1 then
				minetest.set_node(pos, {name = "nodes_nature:tree_mark"})
				local meta = minetest.get_meta(pos)
				meta:set_string("saved_name", "nodes_nature:"..treename.."_tree")
				meta:set_string("saved_param2", 0)
				meta:set_string("leaf_name", "nodes_nature:"..treename.."_leaves")
				meta:set_string("tree_name", "nodes_nature:"..treename.."_tree")
				minetest.get_node_timer(pos):start(math.random(base_tree_growth/2, base_tree_growth))
			end
		end,
	})

	--dropped log
	minetest.register_node("nodes_nature:"..treename.."_log", {
		description = treedesc.." Log",
		tiles = {
			"nodes_nature_"..treename.."_log_top.png",
			"nodes_nature_"..treename.."_log_top.png",
			"nodes_nature_"..treename.."_log.png"
		},
		stack_max = minimal.stack_max_bulky,
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
				{-0.375, -0.5, 0.4375, 0.375, 0.5, 0.5},
				{-0.375, -0.5, -0.5, 0.375, 0.5, -0.4375},
				{0.4375, -0.5, -0.375, 0.5, 0.5, 0.375},
				{-0.5, -0.5, -0.375, -0.4375, 0.5, 0.375},
			}
		},
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {log = 1, choppy = hardness, flammable = 1},
		sounds = nodes_nature.node_sound_wood_defaults(),
		on_place = minetest.rotate_node,
	})

	--stairs and slabs
	stairs.register_stair_and_slab(
		treename.."_log",
		"nodes_nature:"..treename.."_log",
		"chopping_block",
		"false",
		{choppy = hardness, flammable = 1},
		{
			"nodes_nature_"..treename.."_log_top.png",
			"nodes_nature_"..treename.."_log_top.png",
			"nodes_nature_"..treename.."_log.png"
		},
		treedesc.." Log Stair",
		treedesc.." Log Slab",
		minimal.stack_max_bulky * 2,
		nodes_nature.node_sound_wood_defaults()
	)




	--leaves
	minetest.register_node("nodes_nature:"..treename.."_leaves", {
		description = treedesc.." Leaves",
		drawtype =  "plantlike",
		visual_scale = 1,
		tiles ={"nodes_nature_"..treename.."_leaves.png" },
		stack_max = minimal.stack_max_bulky * 3,
		paramtype = "light",
		paramtype2 = "meshoptions",
		place_param2 = 4,
		walkable = false,
		climbable = true,
		groups = {choppy = 3, flammable = 1, woody_plant = 1, leafdecay = 1, leafdecay_drop = 1},
		sounds = nodes_nature.node_sound_leaves_defaults(),
		after_place_node = function(pos, placer, itemstack)
			minetest.set_node(pos, {name = "nodes_nature:"..treename.."_leaves", param2 = 4, param3 = 1})
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			if oldnode.param3 ~= 1 then
				minetest.set_node(pos, {name = "nodes_nature:tree_mark"})
				local meta = minetest.get_meta(pos)
				meta:set_string("saved_name", "nodes_nature:"..treename.."_leaves")
				meta:set_string("saved_param2", place_param2)
				meta:set_string("leaf_name", "nodes_nature:"..treename.."_leaves")
				meta:set_string("tree_name", "nodes_nature:"..treename.."_tree")
				minetest.get_node_timer(pos):start(math.random(base_leaf_growth/2, base_leaf_growth))
			end
		end,
	})

	--fruit
	if fruitname then
		minetest.register_node("nodes_nature:"..fruitname, {
			description = fruitdesc,
			drawtype = "plantlike",
			tiles = { "nodes_nature_"..fruitname..".png" },
			inventory_image = "nodes_nature_"..fruitname..".png",
			wield_image = "nodes_nature_"..fruitname..".png",
			stack_max = minimal.stack_max_medium,
			visual_scale = 1,
			paramtype = "light",
			paramtype2 = "meshoptions",
			place_param2 = p2_fruit or 2,
			sunlight_propagates = true,
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = selbox_fruit
			},
			groups = {dig_immediate=3, flammable=1, leafdecay = 3, leafdecay_drop = 1},
			sounds = nodes_nature.node_sound_defaults(),
			after_place_node = function(pos, placer, itemstack)
				minetest.set_node(pos, {name = "nodes_nature:"..fruitname, param2 = p2_fruit, param3 = 1})
			end,
			after_dig_node = function(pos, oldnode, oldmetadata, digger)
				if oldnode.param3 ~= 1 then
					minetest.set_node(pos, {name = "nodes_nature:tree_mark"})
					local meta = minetest.get_meta(pos)
					meta:set_string("saved_name", "nodes_nature:"..fruitname)
					meta:set_string("saved_param2", p2_fruit)
					meta:set_string("leaf_name", "nodes_nature:"..treename.."_leaves")
					meta:set_string("tree_name", "nodes_nature:"..treename.."_tree")
					minetest.get_node_timer(pos):start(math.random(base_fruit_growth/2, base_fruit_growth))
				end
			end,
		})

		register_leafdecay({
			trunks = {"nodes_nature:"..treename.."_tree"},
			leaves = {"nodes_nature:"..treename.."_leaves", "nodes_nature:"..fruitname},
			radius = 3,
		})
	else
		register_leafdecay({
			trunks = {"nodes_nature:"..treename.."_tree"},
			leaves = {"nodes_nature:"..treename.."_leaves"},
			radius = 3,
		})

	end


end


-------------------------------------------------
--Special properties

--maraka thorns
minetest.override_item("nodes_nature:maraka_leaves",{damage_per_second = 1})


--maraka nut is dangerous poisonous until processed,
-- causes photosensitivity, risk of hepatotoxicity
--you can eat it raw if you want to take the risk... famine food for the desperate
minetest.override_item("nodes_nature:maraka_nut",{
	on_use = function(itemstack, user, pointed_thing)

		--food poisoning
		if random() < 0.001 then
			HEALTH.add_new_effect(user, {"Food Poisoning", 1})
		end

		--toxins
		if random() < 0.005 then
			HEALTH.add_new_effect(user, {"Hepatotoxicity", floor(random(1,4))})
		end
		if random() < 0.3 then
			HEALTH.add_new_effect(user, {"Photosensitivity", 1})
		end


		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 0, 5, 5, 0)
	end,
})

--tangkal_fruit is good food, but bulky, contains small amounts of alcohol
minetest.override_item("nodes_nature:tangkal_fruit",{
	stack_max = minimal.stack_max_medium/4,
	on_use = function(itemstack, user, pointed_thing)
		--food poisoning
		if random() < 0.001 then
			HEALTH.add_new_effect(user, {"Food Poisoning", 1})
		end

		--drunk
		if random() < 0.005 then
			HEALTH.add_new_effect(user, {"Drunk", 1})
		end

		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 5, 10, 10, 0)
	end,
})
