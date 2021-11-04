------------------------------
-- Light Haze
-- entry into dust storm pathway
--drought, hot weather, sky color paler

------------------------------

local light_haze = {}


light_haze.name = 'light_haze'


light_haze.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#DAEDFB",
		day_horizon = "#F9FBE7",
		dawn_sky = "daacfb",
		dawn_horizon ="#fbacf4",
		night_sky = "#0600A9",
		night_horizon = "#615f98",
		indoors = "#2B2B2B",
		--fog_sun_tint = "#FB7F55",
		--fog_moon_tint = "#C5C9C9",
		--fog_tint_type = "custom"
	}
}



light_haze.cloud_data = {
	color = "#FFFFFF",
	density = 0.1,
	height = 500,
	thickness = 4,
	speed = {x=1, z=0}
}


light_haze.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


light_haze.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

light_haze.star_data = {
	visible = true,
	count = 1500,
	color = "#80FCFEFF"
}



--probabilities in each temp class
light_haze.chain = {
		--name, p_froz, p_cold, p_mid , p_hot
		{'clear', 1, 0.85, 0.4, 0.1},
		{'haze', 0, 0, 0, 0.25}
	}



--add this weather to register
climate.register_weather(light_haze)



------
