------------------------------
-- Fog
-- ground level cloud.
------------------------------

local fog = {}


fog.name = 'fog'


fog.sky_data = {
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


fog.cloud_data = {
	color = "#FFFFFF",
	density = 1,
	height = 2,
	thickness = 428,
	speed = {x=0, z=0}
}


fog.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


fog.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

fog.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}





--probabilities in each temp class
fog.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'overcast_light_rain', 0, 0.01, 0.01, 0.05},
	{'overcast_light_snow', 0.05, 0, 0, 0},
	{'overcast', 0.02, 0.02, 0.02, 0.05},
	{'clear', 0, 0, 0.01, 0.05}

}



--add this weather to register
climate.register_weather(fog)



------
