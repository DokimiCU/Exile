------------------------------
-- overcast_rain weather
-- grey sky rain, moderate intensity

------------------------------

local overcast_rain = {}


overcast_rain.name = 'overcast_rain'

overcast_rain.sky_color_day = 80
overcast_rain.sky_color_night = 15
overcast_rain.fog = 150

overcast_rain.clouds_color = "#606060"
overcast_rain.clouds_density = 0.6
overcast_rain.clouds_height = 480
overcast_rain.clouds_thickness = 128
overcast_rain.clouds_speed = {x=2, z=0}

overcast_rain.sound_loop = 'rain_loop'

--probabilities in each temp class
overcast_rain.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_light_rain', 0.01, 0.25, 0.5, 0.75},
	{'heavy_rain', 0.01, 0.5, 0.25, 0.25},
	{'thunderstorm', 0.01, 0.01, 0.1, 0.25},
	{'overcast_snow', 0.5, 0, 0, 0}


}


-- Random texture getter
local random_texture = function()
	local base_name = "light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end


overcast_rain.particle_interval = 0.004

overcast_rain.particle_function = function()
	local vel = -12
	local acc = -10
	local ext = 6
	local size = 1
	local tex = random_texture()
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end



--add this weather to register
climate.register_weather(overcast_rain)


------
