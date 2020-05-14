------------------------------------------------------------
--CLOTHING init
------------------------------------------------------------

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/api.lua")
--dofile(modpath.."/test_clothing.lua") --bug testing



------------------------------------------------------------
-- Inventory page

local clothing_formspec = "size[8,8.5]"..
"list[current_player;main;0,4.7;8,1;]"..
"list[current_player;main;0,5.85;8,3;8]"

sfinv.register_page("clothing:clothing", {
	title = "Clothing",
	get = function(self, player, context)
		local name = player:get_player_name()

		local meta = player:get_meta()
		local cur_tmin = meta:get_int("clothing_temp_min")
		local cur_tmax = meta:get_int("clothing_temp_max")

		local formspec = clothing_formspec..
		"label[3,0.4; Min Temperature Tolerance: " .. cur_tmin .. " ]"..
		"label[3,1; Max Temperature Tolerance: " .. cur_tmax .. " ]"..
		"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"..
		"listring[current_player;main]"..
		"listring[detached:"..name.."_clothing;clothing]"
		return sfinv.make_formspec(player, context,
		formspec, false)
	end
})





--functions


local function get_element(item_name)
	for _, element in pairs(clothing.elements) do
		if minetest.get_item_group(item_name, "clothing_"..element) > 0 then
			return element
		end
	end
end



local function save_clothing_metadata(player, clothing_inv)
	local player_inv = player:get_inventory()
	local is_empty = true
	local clothes = {}

	for i = 1, 6 do
		local stack = clothing_inv:get_stack("clothing", i)
		-- Move all non-clothes back to the player inventory
		if not stack:is_empty() and not get_element(stack:get_name()) then
			player_inv:add_item("main", clothing_inv:remove_item("clothing", stack))
			stack:clear()
		end
		if not stack:is_empty() then
			clothes[i] = stack:to_string()
			is_empty = false
		end
	end

	local meta = player:get_meta()
	if is_empty then
		meta:set_string("clothing:inventory", "")
	else
		meta:set_string("clothing:inventory", minetest.serialize(clothes))
	end
end

local function load_clothing_metadata(player, clothing_inv)
	local player_inv = player:get_inventory()
	local meta = player:get_meta()
	local clothing_meta = meta:get_string("clothing:inventory")
	local clothes = clothing_meta and minetest.deserialize(clothing_meta) or {}
	local dirty_meta = false
	if not clothing_meta then
		-- Backwards compatiblity
		for i = 1, 6 do
			local stack = player_inv:get_stack("clothing", i)
			if not stack:is_empty() then
				clothes[i] = stack:to_string()
				dirty_meta = true
			end
		end
	end
	-- Fill detached slots
	clothing_inv:set_size("clothing", 6)
	for i = 1, 6 do
		clothing_inv:set_stack("clothing", i, clothes[i] or "")
	end

	if dirty_meta then
		-- Requires detached inventory to be set up
		save_clothing_metadata(player, clothing_inv)
	end

	-- Clean up deprecated garbage after saving
	player_inv:set_size("clothing", 0)
end

local orig_init_on_joinplayer = player_api.init_on_joinplayer
function player_api.init_on_joinplayer(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local clothing_inv = minetest.create_detached_inventory(name.."_clothing",{

		on_put = function(inv, listname, index, stack, player)
			save_clothing_metadata(player, inv)
			clothing:run_callbacks("on_equip", player, index, stack)
			clothing:set_player_clothing(player)
		end,

		on_take = function(inv, listname, index, stack, player)
			save_clothing_metadata(player, inv)
			clothing:run_callbacks("on_unequip", player, index, stack)
			clothing:set_player_clothing(player)
		end,

		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			save_clothing_metadata(player, inv)
			clothing:set_player_clothing(player)
		end,

		allow_put = function(inv, listname, index, stack, player)

			local item = stack:get_name()

			local element = get_element(item)
			if not element then
				return 0
			end

			for i = 1, 6 do
				local stack = inv:get_stack("clothing", i)
				local def = stack:get_definition() or {}
				if def.groups and def.groups["clothing_"..element]	and i ~= index then
					return 0
				end
			end
			return 1
		end,

		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,

		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,

	}, name)



	load_clothing_metadata(player, clothing_inv)
	orig_init_on_joinplayer(player)
	clothing:set_player_clothing(player)
end
