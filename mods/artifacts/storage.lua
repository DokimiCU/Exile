---------------------------------------------------
--STORAGE
--e.g. for chests, pots etc


---------------------------------------------------
local function get_storage_formspec(pos, w, h)
	local main_offset = 0.85 + h

	local formspec = {
		--"size[8,7]",
		"size[8,11]",
		"list[current_name;main;0,0.2;"..w..","..h.."]",
		"list[current_player;main;0,"..main_offset..";8,2]",
		"listring[current_name;main]",
		"listring[current_player;main]",}

	return table.concat(formspec, "")
end


local function is_owner(pos, name)
	local owner = minetest.get_meta(pos):get_string("owner")
	if owner == "" or owner == name or minetest.check_player_privs(name, "protection_bypass") then
		return true
	end
	return false
end




local on_construct = function(pos, width, height)
	local meta = minetest.get_meta(pos)

	local form = get_storage_formspec(pos, width, height)
	meta:set_string("formspec", form)

	local inv = meta:get_inventory()
	inv:set_size("main", width*height)
end



----------------------------------------------------
--ANTIQUORIUM CHEST
----------------------------------------------------

minetest.register_node("artifacts:antiquorium_chest", {
	description = "Antiquorium Chest",
	tiles = {"artifacts_antiquorium_chest_top.png",
			"artifacts_antiquorium_chest_bottom.png",
			"artifacts_antiquorium_chest_side.png",
			"artifacts_antiquorium_chest_side.png",
			"artifacts_antiquorium_chest_side.png",
			"artifacts_antiquorium_chest_side.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.4375, -0.5, 0.5, -0.25, 0.5}, -- NodeBox1
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox2
			{-0.5, -0.5, -0.5, -0.3125, -0.4375, -0.3125}, -- NodeBox3
			{-0.5, -0.5, 0.3125, -0.3125, -0.4375, 0.5}, -- NodeBox4
			{0.3125, -0.5, 0.3125, 0.5, -0.4375, 0.5}, -- NodeBox5
			{0.3125, -0.5, -0.5, 0.5, -0.4375, -0.3125}, -- NodeBox6
			{-0.4375, -0.25, -0.4375, 0.4375, 0.375, 0.4375}, -- NodeBox7
		}
	},
	groups = {cracky = 1},
	sounds = nodes_nature.node_sound_glass_defaults(),

	on_construct = function(pos)
		on_construct(pos, 8, 8)
	end,

	can_dig = function(pos, player)
		local inv = minetest.get_meta(pos):get_inventory()
		local name = ""
		if player then
			name = player:get_player_name()
		end
		return is_owner(pos, name) and inv:is_empty("main")
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if is_owner(pos, player:get_player_name()) then
			return count
		end
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if is_owner(pos, player:get_player_name())
		and not string.match(stack:get_name(), "backpacks:") then
			return stack:get_count()
		end
		return 0
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if is_owner(pos, player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,

	on_blast = function(pos)
	end,
})
