--CLIMATE

--[[
Uses a markov change to switch between weather states.
Has seasonal and diurnal fluctations in temperature, which adjust
the probability for which switch will occur (e.g rain more likely in cold)

This is climate rather than "weather" in the sense it treats the whole map
as the same, i.e. not big enough to get regional variation.


A specific locations Temperature and more can be called elsewhere (e.g. for health)

]]



climate = {
	active_weather = {},
	active_temp = {}

}

local modpath = minetest.get_modpath("climate")
local mod_storage = minetest.get_mod_storage()


-- Adds weather to register_weathers table
--all possible weather states
local registered_weathers = {}

-- Keeps sound handler references
local sound_handlers = {}

climate.register_weather = function(weather_obj)
	table.insert(registered_weathers, weather_obj)
end

dofile(modpath .. "/particles.lua")
dofile(modpath .. "/temperature.lua")
--weathers
dofile(modpath .. "/weathers/clear.lua")
dofile(modpath .. "/weathers/light_cloud.lua")
dofile(modpath .. "/weathers/medium_cloud.lua")
dofile(modpath .. "/weathers/sun_shower.lua")
dofile(modpath .. "/weathers/light_rain.lua")
dofile(modpath .. "/weathers/overcast_light_rain.lua")
dofile(modpath .. "/weathers/overcast.lua")
dofile(modpath .. "/weathers/overcast_rain.lua")
dofile(modpath .. "/weathers/heavy_rain.lua")
dofile(modpath .. "/weathers/thunderstorm.lua")
dofile(modpath .. "/weathers/light_haze.lua")
dofile(modpath .. "/weathers/haze.lua")
dofile(modpath .. "/weathers/duststorm.lua")
dofile(modpath .. "/weathers/snow_flurry.lua")
dofile(modpath .. "/weathers/light_snow.lua")
dofile(modpath .. "/weathers/overcast_light_snow.lua")
dofile(modpath .. "/weathers/overcast_snow.lua")
dofile(modpath .. "/weathers/heavy_snow.lua")
dofile(modpath .. "/weathers/snowstorm.lua")
dofile(modpath .. "/weathers/superstorm.lua")


--setting...for random intervals
local base_interval = 60
local base_int_range = 30

--temp classes for probabilities
local plvl_froz = -1
local plvl_cold = 15
local plvl_mid = 25


--what weather is on, and how long it will last, and temp
climate.active_weather = registered_weathers[math.random(#registered_weathers)]
local active_weather_interval = 0
--temperature...accessible by health etc
climate.active_temp = math.random(10,30)

--random walk, for temp
local ran_walk_range = 8
local ran_walk = math.random(-ran_walk_range,ran_walk_range)

--------------------------
-- Functions
--------------------------

--------------------
--create a random interval for the weather to last
local function set_active_interval()
  local intv = base_interval + math.random(-base_int_range, base_int_range)
  return intv
end


-----------------
--set the sky, for on join and when new weather set
local function set_sky_clouds(player, time)
	local active_weather = climate.active_weather

  if active_weather.sky_color_day then
    --day night transitions
    local sval

    if not time then
      time = minetest.get_timeofday()
      if time >= 0.5 then
        time = 1 - time
      end
    end

    -- Sky brightness transitions:
    -- First transition (24000 -) 4500, (1 -) 0.1875
    -- Last transition (24000 -) 5750, (1 -) 0.2396

    if time <= 0.1875 then
      sval = active_weather.sky_color_night

    elseif time >= 0.2396 then
      sval = active_weather.sky_color_day

    else

      local difsval = active_weather.sky_color_day - active_weather.sky_color_night

      sval = math.floor(active_weather.sky_color_night + ((time - 0.1875) / 0.0521) * difsval)

    end

    player:set_sky({r = sval, g = sval, b = sval, a = active_weather.fog},	"plain", nil, true)

	else
		--no sky so remove any previous effect (i.e. it's a blue sky)
			player:set_sky(nil, "regular", nil)
  end

  player:set_clouds({
    color = active_weather.clouds_color,
    density = active_weather.clouds_density,
    height = active_weather.clouds_height,
    thickness = active_weather.thickness,
    speed = active_weather.clouds_speed
  })


end

-----------------
local function get_weather_table(name, registered_weathers)
	local t = false
  for i, reg_weather in ipairs(registered_weathers) do
    if name == reg_weather.name then
      local active_weather = reg_weather
			t = true
      return active_weather
		end
	end

	if not t then
		--error, got a name it can't find
		--currently will likely make it crash
		minetest.log("error", "Climate: "..name.." not found")
		return
	end

end

-------------------------


minetest.register_on_joinplayer(function(player)
  set_sky_clouds(player)
  if climate.active_weather.sound_loop then
    local p_name = player:get_player_name()
    sound_handlers[p_name] = minetest.sound_play(climate.active_weather.sound_loop, {to_player = p_name, loop = true})
  end
end
)


--------------------------
-- Main step
--------------------------

local timer = 0
local timer_p = 0

minetest.register_globalstep(function(dtime)
	--check if anyone is above ground to bother doing this for
	local ag_c = 0
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		if pos.y > -12 then
			ag_c = ag_c + 1
		else
			--underground so remove sounds
			local p_name = player:get_player_name()
			local sound = sound_handlers[p_name]
			if sound ~= nil then
				minetest.sound_stop(sound)
				sound_handlers[p_name] = nil
			end
		end
	end
	if ag_c == 0 then
		--no one will experience any weather!
		--temperature doesn't get changed by seasons etc
		return
	end


  timer = timer + dtime
  timer_p = timer_p + dtime

	--fast weather effects
  if (climate.active_weather.particle_interval and timer_p > climate.active_weather.particle_interval) then
    -- do particle effects for current weather
    climate.active_weather.particle_function()
	end

	if climate.active_weather.sound_loop or climate.active_weather.sky_color_day then

    --update sky during transitions, and reset sounds
    for _,player in ipairs(minetest.get_connected_players()) do

			--add missing sounds (e.g. if turned off by going underground)
			if climate.active_weather.sound_loop  then
				local p_name = player:get_player_name()
				local sound = sound_handlers[p_name]
				if sound == nil  then
					sound_handlers[p_name] = minetest.sound_play(climate.active_weather.sound_loop, {to_player = p_name, loop = true})
				end
			end

			if climate.active_weather.sky_color_day then
				local time = minetest.get_timeofday()
        if time >= 0.5 then
          time = 1 - time
        end
				--update during transition so a smooth change
        if time >= 0.1875 and time <= 0.2396 then
          set_sky_clouds(player, time)
        end
      end

    end

    timer_p = 0
	end

	--update weather state
  if timer > active_weather_interval then
    --timer has expired, switch to a new weather state

    --reset timer and interval
    timer = 0
    active_weather_interval = set_active_interval()
    --save interval
    --mod_storage:set_float('active_weather_interval', active_weather_interval)


    --select a new active_weather from probabilities
    --it will loop through and try to change the weather
    local new_weather_name
    for n, next in pairs(climate.active_weather.chain) do
      --roll dice
      local c = math.random()
      --use temperature adjusted probability
      if climate.active_temp < plvl_froz then
				--frozen temperature
				if next[2] > c then
					new_weather_name = next[1]
				end
			elseif climate.active_temp < plvl_cold then
        --cold temperature
        if next[3] > c then
          new_weather_name = next[1]
        end
      elseif climate.active_temp < plvl_mid then
        --mid temperature
        if next[4] > c then
          new_weather_name = next[1]
        end
      else
        --hot temperature
        if next[5] > c then
          new_weather_name = next[1]
        end
      end
    end

    --did it succeed in getting a new state?
    if new_weather_name and new_weather_name ~= climate.active_weather.name then

      --we need to update the sky and set the new
      climate.active_weather = get_weather_table(new_weather_name, registered_weathers)

      --do for each player
      for _,player in ipairs(minetest.get_connected_players()) do
        --set sky and clouds for new state using the new active_weather
        set_sky_clouds(player)

        --remove old sounds
        local p_name = player:get_player_name()
        local sound = sound_handlers[p_name]
      	if sound ~= nil then
      		minetest.sound_stop(sound)
      		sound_handlers[p_name] = nil
      	end
        --add new loop
        if climate.active_weather.sound_loop then
          sound_handlers[p_name] = minetest.sound_play(climate.active_weather.sound_loop, {to_player = p_name, loop = true})
        end

      end

    end


		--this is a universal temperature for the whole map
		--we are treating the whole map as one coherent region, with a single climate
		--specific player temp adjusted from this (e.g. by altitude)

		--get day night wave
		local tod = minetest.get_timeofday()
		--diff between day and night is this x2
		local dn_amp = -9
		local dn_period = 6.283 ---match day length
		local dn_wav = dn_amp * math.cos(tod * dn_period)

		--get seasonal wave
		local dc = minetest.get_day_count()
		--diff +/- from yearly mean (seasonal variation)
		local dc_amp = 27
		--~56 day year, 14 day seasons
		local dc_period = 0.11
		--yearly average,
		local dc_mean = 15
		local dc_wav = dc_amp * math.sin(dc * dc_period) + dc_mean
		--random walk...an incremental fluctuation that resets
		ran_walk = ran_walk + math.random(-2, 2)
		if ran_walk > ran_walk_range or ran_walk < -ran_walk_range then
			ran_walk = ran_walk/2
		end

		--sum waves plus some random noise
		climate.active_temp = dc_wav + dn_wav + ran_walk

	end
end)
