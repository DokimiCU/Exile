------------------------------
-- overcast_light_rain weather
-- grey sky rain

------------------------------

local overcast_light_rain = {}

overcast_light_rain.name = 'overcast_light_rain'


overcast_light_rain.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#979AA1",
		day_horizon = "#a1a4aa",
		dawn_sky = "#CBC0D6",
		dawn_horizon ="#d5ccde",
		night_sky = "#4B3C5A",
		night_horizon = "#6e627a",
		indoors = "#2B2B2B",
		--fog_sun_tint = "#FB7F55",
		--fog_moon_tint = "#C5C9C9",
		--fog_tint_type = "custom"
	}
}


overcast_light_rain.cloud_data = {
	color = "#5D5F69",
	density = 0.6,
	height = 300,
	thickness = 128,
	speed = {x=2, z=0}
}



overcast_light_rain.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


overcast_light_rain.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

overcast_light_rain.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}



overcast_light_rain.sound_loop = 'light_rain_loop'

--probabilities in each temp class
overcast_light_rain.chain = {
	--name, p_cold, p_mid , p_hot
	{'light_rain', 0.01, 0.25, 0.5, 0.75},
	{'overcast', 0.5, 0.5, 0.5, 0.75},
	{'overcast_rain', 0.01, 0.3, 0.2, 0.5},
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
