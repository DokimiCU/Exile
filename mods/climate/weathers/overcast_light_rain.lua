------------------------------
-- overcast_light_rain weather
-- grey sky rain

------------------------------

local overcast_light_rain = {}


overcast_light_rain.name = 'overcast_light_rain'

overcast_light_rain.sky_color_day = 90
overcast_light_rain.sky_color_night = 15
overcast_light_rain.fog = 175

overcast_light_rain.clouds_color = "#808080"
overcast_light_rain.clouds_density = 0.6
overcast_light_rain.clouds_height = 500
overcast_light_rain.clouds_thickness = 128
overcast_light_rain.clouds_speed = {x=2, z=0}

overcast_light_rain.sound_loop = 'light_rain_loop'

--probabilities in each temp class
overcast_light_rain.chain = {
	--name, p_cold, p_mid , p_hot
	{'light_rain', 0.01, 0.1, 0.2, 0.3},
	{'overcast', 0.5, 0.5, 0.5, 0.75},
	{'overcast_rain', 0.01, 0.75, 0.5, 0.25},
	{'overcast_light_snow', 0.25, 0, 0, 0}

}


-- Random texture getter
local random_texture = function()
	local base_name = "light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end


overcast_light_rain.particle_interval = 0.1

overcast_light_rain.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 5
	local size = 1
	local tex = random_texture()
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end



--add this weather to register
climate.register_weather(overcast_light_rain)


------
