-------------------------------------
--HUD
--[[
The point of this is to give simple uncluttered quick view information,
leaving the details for the inventory screen


HEALTH.update_hud(player) called by health code (e.g. on actions)


]]

local hud = {}
if minetest.get_modpath("hudbars") then
	HEALTH.hudbars = true
	
	--Thirst
	hb.register_hudbar('thirst', 0xffffff, "Hydration", {
		bar = 'health_hudbar_bar_thirst.png',
		icon = 'health_dot_blue_thirst.png'
	}, 100, 100, false)
	
	--Hunger
	hb.register_hudbar('hunger', 0xffffff, "Satiation", {
		bar = 'health_hudbar_bar_hunger.png',
		icon = 'health_dot_orange_hunger.png'
	}, 1000, 1000, false)
	
	--Energy
	hb.register_hudbar('energy', 0xffffff, "Energy", {
		bar = 'health_hudbar_bar_energy.png',
		icon = 'health_dot_green_energy.png'
	}, 1000, 1000, false)
	
	--Body-temp
	hb.register_hudbar('temperature', 0xffffff, "Body-Temp", {
		bar = 'health_hudbar_bar_temp.png',
		icon = 'health_dot_red_temp.png'
	}, 37, 50, false)
	
	
	
	function HEALTH.get_value(player,hval)
		if not player then return false end
		
		local meta = player:get_meta()
		if not meta then return false end
		
		local thirst = meta:get_int("thirst")
		local hunger = meta:get_int("hunger")
		local energy = meta:get_int("energy")
		local temperature = meta:get_int("temperature")
		
		if hval == "thirst" then return thirst end
		if hval == "hunger" then return hunger end
		if hval == "energy" then return energy end
		if hval == "temp" then return temperature end
	end
	

end


----------------------------------------
--Update

HEALTH.update_hud = function(player, thirst, hunger, energy, temperature, enviro_temp, comfort_low, comfort_high, stress_low, stress_high, danger_low, danger_high)
	local playername = player:get_player_name()
	local hud_data = hud[playername]

	if HEALTH.hudbars then
		local thirst = HEALTH.get_value(player,"thirst") or 100
		local hunger = HEALTH.get_value(player,"hunger") or 1000
		local energy = HEALTH.get_value(player,"energy") or 1000
		local temp = HEALTH.get_value(player,"temp") or 37
		
		hb.change_hudbar(player, 'thirst', thirst, 100)
		hb.change_hudbar(player, 'hunger', hunger, 1000)
		hb.change_hudbar(player, 'energy', energy, 1000)
		hb.change_hudbar(player, 'temperature', temp, 50)
	end
	
	if not hud_data then
		return
	end


	local tempstring = "Temp = "..tostring(math.floor(enviro_temp*100)/100)
	player:hud_change(hud_data.env_temp_hud_txt, "text", tempstring)


end







----------------------------------------
--Add HUD
local setup_hud = function(player)
	local playername = player:get_player_name()

	local hud_data = {}
	hud[playername] = hud_data

	local meta = player:get_meta()
	local thirst = meta:get_int("thirst")
	local hunger = meta:get_int("hunger")
	local energy = meta:get_int("energy")
	local temperature = meta:get_int("temperature")

	local player_pos = player:get_pos()
	player_pos.y = player_pos.y + 0.6 --adjust to body height
	local enviro_temp = math.floor(climate.get_point_temp(player_pos))


	local place = {x = 0.55, y = 0.96}--{x = 0.36, y = 0.885}
	local size = { x = 1.8, y = 1.8}

	
	hud_data.env_temp_hud_txt = player:hud_add({
			hud_elem_type = "text",
			position  = place,
			offset    = {x = 224, y = 0},
			number	= 0xe49b0f,
			text      = "Temp = "..tostring(enviro_temp),
			scale     = size,
			alignment = { x = 0, y = 0 },
	})
	--set correct images
	--no idea why this pause is needed...  but it is, and can be no shorter
	minetest.after(0.1, function()
		HEALTH.update_hud(player, thirst, hunger, energy, temperature, enviro_temp, comfort_low, comfort_high, stress_low, stress_high, danger_low, danger_high)
	end)


end


----------------------------------------
--Remove HUD

local remove_hud = function(player)
	local playername = player:get_player_name()
	local hud_data = hud[playername]

	player:hud_remove(hud_data.thirst_hud_img)
	player:hud_remove(hud_data.hunger_hud_img)
	player:hud_remove(hud_data.energy_hud_img)
	player:hud_remove(hud_data.temp_hud_img)
	player:hud_remove(hud_data.env_temp_hud_img)

	hud[playername] = nil
end





----------------------------------------
--toggle hud
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.toggle_health_hud then
		local playername = player:get_player_name()
		local hud_data = hud[playername]

		--add if not there, remove if is
		if not hud_data then
			setup_hud(player)
		else
			remove_hud(player)
			hud[playername] = nil
		end
	end
end)


	minetest.register_on_joinplayer(function(player)
		
		if player and HEALTH.hudbars then
			
			local thirst = HEALTH.get_value(player,"thirst") or 100
			local hunger = HEALTH.get_value(player,"hunger") or 1000
			local energy = HEALTH.get_value(player,"energy") or 1000
			local temp = HEALTH.get_value(player,"temp") or 37
							
			hb.init_hudbar(player, 'thirst', thirst, 100, false)
			hb.init_hudbar(player, 'hunger', hunger, 1000, false)    
			hb.init_hudbar(player, 'energy', energy, 1000, false)
			hb.init_hudbar(player, 'temperature', temp, 50, false)
		end
	                               
		setup_hud(player)
	end)

minetest.register_on_leaveplayer(function(player)
	-- remove stale hud data
	local playername = player:get_player_name()
	hud[playername] = nil
end)
