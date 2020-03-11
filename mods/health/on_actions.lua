-----------------------------
--ON ACTION EFFECTS
--e.g. for eating items, exhaustion from moving etc

-----------------------------



-----------------------------
--On Actions
--

--Consummable items
function HEALTH.use_item(itemstack, user, hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item)
  local name = user:get_player_name()

	if itemstack == nil or user == nil or not minetest.settings:get_bool("enable_damage") then
		return
	end

	local item = itemstack:get_name()
	local name = user:get_player_name()
	local meta = user:get_meta()

	local health = user:get_hp()
	local thirst = meta:get_int("thirst")
	local hunger = meta:get_int("hunger")
	local energy = meta:get_int("energy")
	local temperature = meta:get_int("temperature")



	--calc change with min max
	health = health + hp_change
	if health < 0 then
		health = 0
	elseif health > 20 then
		health = 20
	end

	thirst = thirst + thirst_change
	if thirst < 0 then
		thirst = 0
	elseif thirst > 100 then
		thirst = 100
	end

	hunger = hunger + hunger_change
	if hunger < 0 then
		hunger = 0
	elseif hunger > 1000 then
		hunger = 1000
	end

	energy = energy + energy_change
	if energy < 0 then
		energy = 0
	elseif energy > 1000 then
		energy = 1000
	end

	temperature = temperature + temp_change

	--set new values
	-- and update malus (need for setting correct physics)
	HEALTH.malus_bonus(user, name, meta, energy, thirst, hunger, temperature)

	user:set_hp(health)
	meta:set_int("thirst", thirst)
	meta:set_int("hunger", hunger)
	meta:set_int("energy", energy)
	meta:set_int("temperature", temperature)

	--minetest.chat_send_player(name, minetest.registered_items[item].description .." effect = Health: "..hp_change..", Thirst: "..thirst_change.. ", Hunger: "..hunger_change.. ", Energy: "..energy_change.. ", Body Temperature: "..temp_change )
  local pos = user:get_pos()
  minetest.sound_play("health_eat", {pos = pos, gain = 0.5, max_hear_distance = 2}
  )

	--replace/take
	itemstack:take_item()


	if itemstack:get_count() == 0 then
		itemstack:add_item(replace_with_item)
	else
		local inv = user:get_inventory()
		if inv:room_for_item("main", replace_with_item) then
			inv:add_item("main", replace_with_item)
		else
			minetest.add_item(user:get_pos(), replace_with_item)
		end
	end

	return itemstack
end


--fast interval (cf main update)
--Moving and digging and building
--Environmental based, bed rest ...
--also main place for updating hud and formspec
if minetest.settings:get_bool("enable_damage") then

	local timer = 0
	local interval = 4
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime

		--run
		if timer > interval then
			for _,player in ipairs(minetest.get_connected_players()) do
				local name = player:get_player_name()
				local meta = player:get_meta()

				local health = player:get_hp()
				local thirst = meta:get_int("thirst")
				local hunger = meta:get_int("hunger")
				local energy = meta:get_int("energy")
				local temperature = meta:get_int("temperature")

				----------------
				--movement/digging
				local controls = player:get_player_control()
				-- Determine if the player is active,
        --some actions more energetic
				if controls.up
				or controls.down
				or controls.left
				or controls.right
				or controls.RMB
				then
					energy = energy - 1
				elseif controls.LMB
				or controls.jump then
					energy = energy - 6
				end

				----------------
				--Environmental temperature
				local player_pos = player:get_pos()
        local node_name = minetest.get_node(player_pos).name
        local water = minetest.get_item_group(node_name,"water")
				player_pos.y = player_pos.y + 0.6 --adjust to body height (for radiant heat)
				local enviro_temp = climate.get_point_temp(player_pos)
				--being outside tolerance range will drain energy. When energy is drained will succumb.
        --[safe] comfort zone ->[low cost]->stress zone ->[high cost]-> danger zone->[damage]
        --placeholder values! until do clothes!
        -- (different clothes should affect each value differently)
				local comfort_low = 15
				local comfort_high = 35
        local stress_low = comfort_low - 10
        local stress_high = comfort_high + 10
        local danger_low = stress_low - 40
        local danger_high = stress_high +40
        --energy costs (extreme, danger, stress)
        local costex = 10
        local costd = 5
        local costs = 1
        --water conducts heat better
        if water then
          costex = 20
          costd = 10
          costs = 2
        end


        --burn or freeze
        if enviro_temp < danger_low or enviro_temp > danger_high then
          --tissue damaging freeze/burn
          health = health - 1
          energy = energy - costex
        --exhaustion from temp
        elseif energy > 0 then
					--have energy to resist (and it is resistable cf extreme)
					if enviro_temp < comfort_low or enviro_temp > comfort_high then
            --outside comfort zone
						if enviro_temp < stress_low or enviro_temp > stress_high then
							energy = energy - costd
						else
							energy = energy - costs
						end
					end
        --totally exhausted, heat stroke or hypothermia now sets in
				elseif enviro_temp < comfort_low or enviro_temp > comfort_high then
          --heat or cool to ambient temperature
          temperature = (temperature*0.95) + (enviro_temp*0.05)
          meta:set_int("temperature", temperature)
        end


				------------------
				local light = minetest.get_node_light(player_pos, 0.5)
				local rain = climate.get_rain(player_pos, light)
				local snow = climate.get_snow(player_pos, light)
				local dam_weather = climate.get_damage_weather(player_pos, light)

				--bed rest
				--when in bed, under shelter boost energy
				if energy < 1000 then
					if bed_rest.player[name] then
						--best rest is under shelter, in a non-extreme temperature
            local lvl = bed_rest.level[name]
						if rain
            or snow
            or dam_weather
            or enviro_temp < stress_low
            or enviro_temp > stress_high then
              --terrible sleep in the rain etc
							energy = energy + math.random(0, lvl)
            elseif enviro_temp < comfort_high and enviro_temp > comfort_low and light < 14 then
              --best rest is under shelter, in a non-extreme temperature
							energy = energy + (15 * lvl)
							if energy > 1000 then
								energy = 1000
							end
						else
							energy = energy + (2*lvl)
							if energy > 1000 then
								energy = 1000
							end
						end
					end
				end

				--drink a little rain
				if rain and thirst < 100 then
					--only sometimes or too easy
					if math.random()<0.2 then
						thirst = thirst + 1
						meta:set_int("thirst", thirst)
					end
				end

				------------------
				--harmed by damaging weather,
				--exhausted by rain, snow
				if math.random()<0.5 then
					if dam_weather then
            health = health - 1
						energy = energy - 15
						if energy < 0 then
							energy = 0
						end
					elseif rain or snow then
						energy = energy - 1
						if energy < 0 then
							energy = 0
						end
					end
				end


				--update
				meta:set_int("energy", energy)
        player:set_hp(health)
				--update form so can see change while looking
				sfinv.set_player_inventory_formspec(player)
        --update hud (will abort if no hud on)
        HEALTH.update_hud(player, thirst, hunger, energy, temperature, enviro_temp)


			end


		end

		--reset
		if timer > interval then
			timer = 0
		end
	end)

end
