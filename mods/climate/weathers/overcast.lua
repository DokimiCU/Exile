------------------------------
-- overcast weather
-- grey sky but no rain

------------------------------

local overcast = {}


overcast.name = 'overcast'



overcast.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#B5B6B6",
		day_horizon = "#bcbdbd",
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


overcast.cloud_data = {
	color = "#777985",
	density = 0.6,
	height = 300,
	thickness = 128,
	speed = {x=2, z=0}
}



overcast.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


overcast.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

overcast.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}



--probabilities in each temp class
overcast.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_light_rain',0.01, 0.2, 0.1, 0.5},
	{'light_rain', 0.01, 0.05, 0.15, 0.25},
	{'medium_cloud', 0.01, 0.01, 0.01, 0.1},
	{'overcast_light_snow', 0.25, 0, 0, 0},
	{'light_snow', 0.1, 0, 0, 0},
	{'fog', 0.15, 0.1, 0.01, 0.01}

}




--add this weather to register
climate.register_weather(overcast)


------
