------------------------------
-- light cloud weather
-- blue sky weather, a few clouds

------------------------------

local light_cloud = {}


light_cloud.name = 'light_cloud'


light_cloud.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#BBDDF6",
		day_horizon = "#c1e0f6",
		dawn_sky = "#9EADFF",
		dawn_horizon ="#b1bdff",
		night_sky = "#020042",
		night_horizon = "#343267",
		indoors = "#2B2B2B",
		--fog_sun_tint = "#FB7F55",
		--fog_moon_tint = "#C5C9C9",
		--fog_tint_type = "custom"
	}
}


light_cloud.cloud_data = {
	color = "#FFFFFF",
	density = 0.2,
	height = 380,
	thickness = 8,
	speed = {x=2, z=0}
}


light_cloud.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


light_cloud.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

light_cloud.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}



--probabilities in each temp class

light_cloud.chain = {
	--name, p_cold, p_mid , p_hot
	{'clear', 0.1, 0.2, 0.4, 0.5},
	{'medium_cloud', 0.75, 0.5, 0.3, 0.3},
	{'snow_flurry', 0.1, 0, 0, 0}

}




--add this weather to register
climate.register_weather(light_cloud)



------
