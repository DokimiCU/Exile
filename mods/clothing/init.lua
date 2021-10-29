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
		local cur_tmin = climate.get_temp_string(meta:get_int("clothing_temp_min"), meta)
		local cur_tmax = climate.get_temp_string(meta:get_int("clothing_temp_max"), meta)
		
		local formspec = clothing_formspec..
		"label[3,0.4; Min Temperature Tolerance: " .. cur_tmin .. " ]"..
		"label[3,1; Max Temperature Tolerance: " .. cur_tmax .. " ]"..
		--"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"..
		"list[current_player;cloths;0,0.5;2,3;]" ..
		"listring[current_player;main]"..
		--"listring[detached:"..name.."_clothing;clothing]"
		"listring[current_player;cloths]"
		return sfinv.make_formspec(player, context,
		formspec, false)
	end
})

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
      if inventory_info.to_list == "cloths" or inventory_info.from_list == "cloths" then
	 clothing:update_temp(player)
	 player_api.set_texture(player)
      end
end)

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	local stack, from_inv, to_index
	if action == "move" and inventory_info.to_list == "cloths" then
		if inventory_info.from_list == inventory_info.to_list then --for moving inside the 'cloths' inventory
			return 1
		end
		--for moving items from player inventory list 'main' to 'cloths'
		from_inv = "main"
		to_index = inventory_info.to_index
		stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)
	elseif action == "put" and inventory_info.listname == "cloths" then
		--for moving from node inventory 'closet' to player inventory 'cloths'
		from_inv = "closet"
		to_index = inventory_info.index
		stack = inventory_info.stack
	else
		return
	end
	if stack then
		local stack_name = stack:get_name()
		local item_group = minetest.get_item_group(stack_name , "cloth")
		if item_group == 0 then --not a cloth
			return 0
		end
		--search for another cloth of the same type
		local player_inv = player:get_inventory()
		local cloth_list = player_inv:get_list("cloths")
		for i = 1, #cloth_list do
			local cloth_name = cloth_list[i]:get_name()
			local cloth_type = minetest.get_item_group(cloth_name, "cloth")
			if cloth_type == item_group then
				if player_inv:get_stack("cloths", to_index):get_count() == 0 then --if put on an empty slot
					if from_inv == "main" then
						if player_inv:room_for_item("main", cloth_name) then
							player_inv:remove_item("cloths", cloth_name)
							player_inv:add_item("main", cloth_name)
							clothing:update_temp(player)
							return 1
						end
					end
				end
				return 0
			end
		end
		return 1
	end
	return 0
end)

--functions


local function load_clothing_metadata(player)
   -- Exile clothing was stored as a metadata string, migrate to new inv
	local player_inv = player:get_inventory()
	local meta = player:get_meta()
	local clothing_meta = meta:get_string("clothing:inventory")
	local clothes = clothing_meta and minetest.deserialize(clothing_meta) or {}
	if clothing_meta == "" then
	   return
	end
	-- Fill detached slots
	--clothing_inv:set_size("clothing", 6)
	for i = 1, 6 do
	   player_inv:set_stack("cloths", i, clothes[i] or "")
	   --overwrite current clothes, but it will be empty on first migration
	end
	meta:set_string("clothing:inventory", "")
end

minetest.register_on_joinplayer(function(player)
      --import old clothing
      load_clothing_metadata(player)
      clothing:update_temp(player)
      player_api.set_texture(player)
end)

---------------------------------------------------------
--Player death
local drop_clothes = function(pos, stack)
	local node = minetest.get_node_or_nil(pos)
	if node then
		local obj = minetest.add_item(pos, stack)
		if obj then
			obj:setvelocity({x=math.random(-1, 1), y=5, z=math.random(-1, 1)})
		end
	end
end



minetest.register_on_dieplayer(function(player)

	local drop = {}
	if minetest.check_player_privs(player, "creative") then
	   return -- Creative mode players keep their inv & leave no bones
	end
	local player_inv = player:get_inventory()
	local clothes = player_inv:get_list("cloths") or {}

	for i=1, #clothes do
		local stack = clothes[i]
		--queue to drop, remove effects, remove item
		if stack:get_count() > 0 then
		   table.insert(drop, stack)
		   player_inv:remove_item("cloths", stack:get_name())
		end
	end

	--reset appearance
	player_api.set_texture(player)

	local pos = player:get_pos()
	local name = player:get_player_name()
	minetest.after(1, function()
		local meta = nil
		local maxp = vector.add(pos, 8)
		local minp = vector.subtract(pos, 8)
		local bones = minetest.find_nodes_in_area(minp, maxp, {"bones:bones"})
		for _, p in pairs(bones) do
			local m = minetest.get_meta(p)
			if m:get_string("owner") == name then
				meta = m
				break
			end
		end
		if meta then
			local inv = meta:get_inventory()
			for _,stack in ipairs(drop) do
				if inv:room_for_item("main", stack) then
					inv:add_item("main", stack)
				else
					drop_clothes(pos, stack)
				end
			end
		else
			for _,stack in ipairs(drop) do
				drop_clothes(pos, stack)
			end
		end
	end)

end)
