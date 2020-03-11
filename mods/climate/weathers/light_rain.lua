------------------------------
-- light_rain weather
-- gentle rain

------------------------------

local light_rain = {}


light_rain.name = 'light_rain'


light_rain.clouds_color = "#D6D6D6"
light_rain.clouds_density = 0.5
light_rain.clouds_height = 520
light_rain.clouds_thickness = 64
light_rain.clouds_speed = {x=2, z=0}

light_rain.sound_loop = 'light_rain_loop'

--probabilities in each temp class
light_rain.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'sun_shower', 0.01, 0.25, 0.5, 0.75},
	{'overcast_light_rain', 0.01, 0.25, 0.15, 0.05},
	{'overcast', 0.1, 0.2, 0.3, 0.4},
	{'light_snow', 0.75, 0, 0, 0}

}


-- Random texture getter
local random_texture = function()
	local base_name = "light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end


light_rain.particle_interval = 0.1

light_rain.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 5
	local size = 1
	local tex = random_texture()
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end



--add this weather to register
climate.register_weather(light_rain)


------
