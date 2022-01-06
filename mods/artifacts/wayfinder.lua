
-- compass configuration interface - adjustable from other mods or minetest.conf settings
--ccompass = {}

-- default target to static_spawnpoint or 0/0/0
local default_target = minetest.setting_get_pos("static_spawnpoint") or {x=0, y=0, z=0}



-- set a position to the compass stack
local function set_target(stack, param)
	param = param or {}
	-- param.target_pos_string
	-- param.target_name
	-- param.playername

	local meta=stack:get_meta()
	meta:set_string("target_pos", param.target_pos_string)
	if param.target_name == "" then
		meta:set_string("description", "Wayfinder to "..param.target_pos_string)
	else
		meta:set_string("description", "Wayfinder to "..param.target_name)
	end

	if param.playername then
		local player = minetest.get_player_by_name(param.playername)
		minetest.chat_send_player(param.playername, minetest.colorize("#00ff00", "WAYFINDER BONDED TO: "..param.target_name.." "..param.target_pos_string))
	end
end


-- Get compass target
local function get_destination(player, stack)

	local meta = stack:get_meta()
	local posstring = meta:get_string("target_pos")

	if posstring ~= "" then

		local npos = minetest.string_to_pos(posstring)
		local node = minetest.get_node(npos).name

		if node == "ignore" or node == "artifacts:waystone" then
			return minetest.string_to_pos(posstring)
		else
			minetest.chat_send_player(player:get_player_name(), minetest.colorize("#cc6600", "WAYFINDER BOND LOST"))
			meta:set_string("target_pos", "")
			meta:set_string("description", "")
			return default_target
		end

	else
		return default_target
	end
end



-- get right image number for players compas
local function get_compass_stack(player, stack)
	local target = get_destination(player, stack)
	local pos = player:get_pos()
	local dir = player:get_look_horizontal()
	local angle_north = math.deg(math.atan2(target.x - pos.x, target.z - pos.z))
	if angle_north < 0 then
		angle_north = angle_north + 360
	end
	local angle_dir = math.deg(dir)
	local angle_relative = (angle_north + angle_dir) % 360
	local wayfinder_image = math.floor((angle_relative/22.5) + 0.5)%16

	-- create new stack with metadata copied
	local metadata = stack:get_meta():to_table()

	local newstack = ItemStack("artifacts:wayfinder_"..wayfinder_image)
	if metadata then
		newstack:get_meta():from_table(metadata)
	end

	return newstack
end

-- Calibrate compass on pointed_thing
local function on_use_function(itemstack, player, pointed_thing)
	-- possible only on nodes
	if pointed_thing.type ~= "node" then
		--minetest.chat_send_player(player:get_player_name(), minetest.colorize("#cc6600", "WAYFINDER CAN ONLY BOND TO ANTIQUORIUM"))
		return
	end

	local nodepos = minetest.get_pointed_thing_position(pointed_thing)
	local node = minetest.get_node(nodepos)

	local destination = itemstack:get_meta():get_string("target_pos")
	if destination ~= "" then
		minetest.chat_send_player(player:get_player_name(), minetest.colorize("#cc6600", "WAYFINDER ALREADY BONDED"))
		return
	end

	if node.name ~= "artifacts:waystone" then
		minetest.chat_send_player(player:get_player_name(), minetest.colorize("#cc6600", "WAYFINDER CAN ONLY BOND TO WAYSTONE"))
		return
	end


	-- check if waypoint name set in target node
	local nodepos_string = minetest.pos_to_string(nodepos)
	local nodemeta = minetest.get_meta(nodepos)
	local waypoint_name = nodemeta:get_string("waypoint_name")
	local waypoint_pos = nodemeta:get_string("waypoint_pos")
	local skip_namechange = nodemeta:get_string("waypoint_skip_namechange")
	local itemmeta=itemstack:get_meta()

	if waypoint_pos and waypoint_pos ~= "" then
		nodepos_string = waypoint_pos
	end


	if skip_namechange ~= "" then
		set_target(itemstack, {
			target_pos_string = nodepos_string,
			target_name = waypoint_name,
			playername = player:get_player_name()
		})
	else
		-- show the formspec to player
		itemmeta:set_string("tmp_target_pos", nodepos_string) --just save temporary
		minetest.show_formspec(player:get_player_name(), "wayfinder",
				"size[10,2.5]" ..
				"field[1,1;8,1;name;Destination name:;"..waypoint_name.."]"..
				"button_exit[0.7,2;3,1;cancel;Cancel]"..
				"button_exit[3.7,2;5,1;ok;Permanently Bond]" )
	end
	return itemstack
end

-- Process the calibration using entered data
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "wayfinder" and fields.name and (fields.ok or fields.key_enter) then
		local stack=player:get_wielded_item()
		local meta=stack:get_meta()
		set_target(stack, {
				target_pos_string = meta:get_string("tmp_target_pos"),
				target_name = fields.name,
				playername = player:get_player_name()
			})
		meta:set_string("tmp_target_pos", "")
		player:set_wielded_item(stack)
	end
end)

-- update inventory
minetest.register_globalstep(function(dtime)
	for i,player in ipairs(minetest.get_connected_players()) do
		if player:get_inventory() then
			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if i > 8 then
					break
				end
				if string.sub(stack:get_name(), 0, 19) == "artifacts:wayfinder" then
					player:get_inventory():set_stack("main", i, get_compass_stack(player, stack))
				end
			end
		end
	end
end)

-- register items
for i = 0, 15 do
	local image = "artifacts_wayfinder_16_"..i..".png"
	local groups = {}
	if i > 0 then
		groups.not_in_creative_inventory = 1
	end
	minetest.register_tool("artifacts:wayfinder_"..i, {
		description = "Wayfinder",
		inventory_image = image,
		wield_image = image,
		groups = groups,
		on_use = on_use_function,
	})
end


------------------------------------
--WAYSTONE
--the super material of the ancients
------------------------------------
minetest.register_node("artifacts:waystone", {
	description = "Waystone",
	tiles = {"artifacts_antiquorium.png"},
  stack_max = 1,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25}, -- NodeBox6
			{-0.125, -0.125, 0.25, 0.125, 0.125, 0.5}, -- NodeBox7
			{-0.125, -0.125, -0.5, 0.125, 0.125, -0.25}, -- NodeBox8
			{0.25, -0.125, -0.125, 0.5, 0.125, 0.125}, -- NodeBox9
			{-0.5, -0.125, -0.125, -0.25, 0.125, 0.125}, -- NodeBox10
			{-0.125, 0.25, -0.125, 0.125, 0.5, 0.125}, -- NodeBox11
			{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox12
			{0.25, -0.5, 0.25, 0.4375, -0.1875, 0.4375}, -- NodeBox13
			{0.25, -0.5, -0.4375, 0.4375, -0.1875, -0.25}, -- NodeBox14
			{-0.4375, -0.5, -0.4375, -0.25, -0.1875, -0.25}, -- NodeBox15
			{-0.4375, -0.5, 0.25, -0.25, -0.1875, 0.4375}, -- NodeBox16
			{-0.4375, 0.25, 0.25, -0.25, 0.5, 0.4375}, -- NodeBox17
			{-0.4375, 0.1875, -0.4375, -0.25, 0.5, -0.25}, -- NodeBox18
			{0.25, 0.1875, -0.4375, 0.4375, 0.5, -0.25}, -- NodeBox19
			{0.25, 0.1875, 0.25, 0.4375, 0.5, 0.4375}, -- NodeBox20
		}
	},
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 2, temp_pass = 1},
})
