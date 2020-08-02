-------------------------------------
--HUD
--[[
The point of this is to give simple uncluttered quick view information,
leaving the details for the inventory screen


HEALTH.update_hud(player) called by health code (e.g. on actions)


]]

local hud = {}


----------------------------------------
--Update

HEALTH.update_hud = function(player, thirst, hunger, energy, temperature, enviro_temp, comfort_low, comfort_high, stress_low, stress_high, danger_low, danger_high)
	local playername = player:get_player_name()
	local hud_data = hud[playername]

	if not hud_data then
		return
	end

--[[anything calling it should already have these values
	local meta = player:get_meta()
	local thirst = meta:get_int("thirst")
	local hunger = meta:get_int("hunger")
	local energy = meta:get_int("energy")
	local temperature = meta:get_int("temperature")

	local player_pos = player:get_pos()
	player_pos.y = player_pos.y + 0.6 --adjust to body height
	local enviro_temp = math.floor(climate.get_point_temp(player_pos))
	]]

--set dots to correct color (make sure it matches the actual code!)
--(hunger/Energy has 10x stock)
--0-20 starving/severe dehydrated: malus, no heal
--20-40 malnourished/dehydrated: malus
--40-60 hungry/thirsty: small malus
--60-80 good:
--80-100 overfull: small malus

--80-100 well rested. bonus
--60-80 rested.
--40-60 tired. small malus
--20-40 fatigued. malus
--0-20 exhausted. malus no heal

--body temp
--<27 death
--27-32: severe hypo. malus no heal
--32-37: hypothermia. malus
--36-38: normal
--38-43: hyperthermia. malus.
--43-47: severe heat stroke. malus no heal
-->47 death



	if thirst > 60 then
		player:hud_change(hud_data.thirst_hud_img, "text", "health_dot_green_thirst.png")
	elseif thirst > 40 then
		player:hud_change(hud_data.thirst_hud_img, "text", "health_dot_yellow_thirst.png")
	elseif thirst > 20 then
		player:hud_change(hud_data.thirst_hud_img, "text", "health_dot_orange_thirst.png")
	elseif thirst < 1 then
		player:hud_change(hud_data.thirst_hud_img, "text", "health_dot_black_thirst.png")
	else
		player:hud_change(hud_data.thirst_hud_img, "text", "health_dot_red_thirst.png")
	end

	if hunger > 600 then
		player:hud_change(hud_data.hunger_hud_img, "text", "health_dot_green_hunger.png")
	elseif hunger > 400 then
		player:hud_change(hud_data.hunger_hud_img, "text", "health_dot_yellow_hunger.png")
	elseif hunger > 200 then
		player:hud_change(hud_data.hunger_hud_img, "text", "health_dot_orange_hunger.png")
	elseif hunger < 1 then
		player:hud_change(hud_data.hunger_hud_img, "text", "health_dot_black_hunger.png")
	else
		player:hud_change(hud_data.hunger_hud_img, "text", "health_dot_red_hunger.png")
	end

	if energy > 600 then
		player:hud_change(hud_data.energy_hud_img, "text", "health_dot_green_energy.png")
	elseif energy > 400 then
		player:hud_change(hud_data.energy_hud_img, "text", "health_dot_yellow_energy.png")
	elseif energy > 200 then
		player:hud_change(hud_data.energy_hud_img, "text", "health_dot_orange_energy.png")
	elseif energy < 1 then
		player:hud_change(hud_data.energy_hud_img, "text", "health_dot_black_energy.png")
	else
		player:hud_change(hud_data.energy_hud_img, "text", "health_dot_red_energy.png")
	end


	if temperature >= 47 or temperature < 27 then
		player:hud_change(hud_data.temp_hud_img, "text", "health_dot_black_temp.png")
	elseif temperature >= 43 or temperature < 32 then
		player:hud_change(hud_data.temp_hud_img, "text", "health_dot_red_temp.png")
	elseif temperature >= 38 or temperature < 37 then
		player:hud_change(hud_data.temp_hud_img, "text", "health_dot_orange_temp.png")
	else
		player:hud_change(hud_data.temp_hud_img, "text", "health_dot_green_temp.png")
	end


	--enviro_temp tolerances
	if enviro_temp > danger_high or enviro_temp < danger_low then
		player:hud_change(hud_data.env_temp_hud_img, "text", "health_dot_black_env_temp.png")
	elseif enviro_temp > stress_high or enviro_temp < stress_low then
		player:hud_change(hud_data.env_temp_hud_img, "text", "health_dot_red_env_temp.png")
	elseif enviro_temp > comfort_high or enviro_temp < comfort_low then
		player:hud_change(hud_data.env_temp_hud_img, "text", "health_dot_orange_env_temp.png")
	else
		player:hud_change(hud_data.env_temp_hud_img, "text", "health_dot_green_env_temp.png")
	end





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

	local comfort_low = meta:get_int("clothing_temp_min")
	local comfort_high = meta:get_int("clothing_temp_max")
	local stress_low = comfort_low - 10
	local stress_high = comfort_high + 10
	local danger_low = stress_low - 40
	local danger_high = stress_high +40

	local place = {x = 0.315, y = 0.868}--{x = 0.36, y = 0.885}
	local size = { x = 1.8, y = 1.8}

	hud_data.thirst_hud_img = player:hud_add({
			hud_elem_type = "image",
			position  = place,
			offset    = {x = 0, y = 0},
			text      = "",
			scale     = size,
			alignment = { x = 0, y = 0 },
	})


	hud_data.hunger_hud_img = player:hud_add({
			hud_elem_type = "image",
			position  = place,
			offset    = {x = 32, y = 0},
			text      = "",
			scale     = size,
			alignment = { x = 0, y = 0 },
	})

	hud_data.energy_hud_img = player:hud_add({
			hud_elem_type = "image",
			position  = place,
			offset    = {x = 64, y = 0},
			text      = "",
			scale     = size,
			alignment = { x = 0, y = 0 },
	})

	hud_data.temp_hud_img = player:hud_add({
			hud_elem_type = "image",
			position  = place,
			offset    = {x = 96, y = 0},
			text      = "",
			scale     = size,
			alignment = { x = 0, y = 0 },
	})

	hud_data.env_temp_hud_img = player:hud_add({
			hud_elem_type = "image",
			position  = place,
			offset    = {x = 128, y = 0},
			text      = "",
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


--placeholder!
--minetest.register_on_joinplayer(function(player)
	--HEALTH.setup_hud(player)
--end)


minetest.register_on_leaveplayer(function(player)
	-- remove stale hud data
	local playername = player:get_player_name()
	hud[playername] = nil
end)
