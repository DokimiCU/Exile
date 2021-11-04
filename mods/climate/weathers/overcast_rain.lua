------------------------------
-- overcast_rain weather
-- grey sky rain, moderate intensity

------------------------------

local overcast_rain = {}


overcast_rain.name = 'overcast_rain'


overcast_rain.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#777D89",
		day_horizon = "#848a94",
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


overcast_rain.cloud_data = {
	color = "#5D5F69",
	density = 0.6,
	height = 280,
	thickness = 128,
	speed = {x=2, z=0}
}

overcast_rain.moon_data = {
	visible = false,
	--texture = "moon.png",
	--tonemap = "moon_tonemap.png",
	--scale = 0.5
}


overcast_rain.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

overcast_rain.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}




overcast_rain.sound_loop = 'rain_loop'

--probabilities in each temp class
overcast_rain.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_light_rain', 0.01, 0.3, 0.4, 0.75},
	{'overcast_heavy_rain', 0.01, 0.2, 0.1, 0.5},
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
