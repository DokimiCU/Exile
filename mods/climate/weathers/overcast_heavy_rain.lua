------------------------------
-- overcast_heavy_rainn weather
-- grey sky rain, heavy intensity

------------------------------

local overcast_heavy_rain = {}


overcast_heavy_rain.name = 'overcast_heavy_rain'


overcast_heavy_rain.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#656D7C",
		day_horizon = "#747b89",
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


overcast_heavy_rain.cloud_data = {
	color = "#494B54",
	density = 0.6,
	height = 260,
	thickness = 128,
	speed = {x=2, z=0}
}


overcast_heavy_rain.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


overcast_heavy_rain.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

overcast_heavy_rain.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}




overcast_heavy_rain.sound_loop = 'heavy_rain_loop'

--probabilities in each temp class
overcast_heavy_rain.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_rain', 0, 0.75, 0.75, 0.85},
	{'overcast_heavy_snow', 1, 0, 0, 0},
	{'thunderstorm', 0, 0.05, 0.25, 0.5}

}




overcast_heavy_rain.particle_interval = 0.001

overcast_heavy_rain.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 6
	local size = 20
	local tex = "heavy_rain_drops.png"
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end



--add this weather to register
climate.register_weather(overcast_heavy_rain)


------
