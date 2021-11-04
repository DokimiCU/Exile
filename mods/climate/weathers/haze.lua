------------------------------
-- Haze
-- looming dust storm
-- sky color
------------------------------

local haze = {}


haze.name = 'haze'


haze.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#F4DFBE",
		day_horizon = "#f6e5cb",
		dawn_sky = "#F9A09C",
		dawn_horizon ="#fab3af",
		night_sky = "#513200",
		night_horizon = "#735a32",
		indoors = "#2B2B2B",
		--fog_sun_tint = "#FB7F55",
		--fog_moon_tint = "#C5C9C9",
		--fog_tint_type = "custom"
	}
}


haze.cloud_data = {
	color = "#ddc194",
	density = 0.4,
	height = 150,
	thickness = 64,
	speed = {x=0, z=3}
}


haze.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


haze.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

haze.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}





haze.sound_loop = 'duststorm_loop_light'


	--probabilities in each temp class

haze.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'light_haze', 1, 0.95, 0.5, 0.1},
	{'duststorm', 0, 0, 0.0, 0.2}

}



--add this weather to register
climate.register_weather(haze)



------
