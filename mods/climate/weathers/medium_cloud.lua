------------------------------
-- medium cloud weather
-- blue sky weather, but a few more clouds

------------------------------

local medium_cloud = {}


medium_cloud.name = 'medium_cloud'

medium_cloud.sky_data = {
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


medium_cloud.cloud_data = {
	color = "#FFFFFF",
	density = 0.3,
	height = 360,
	thickness = 15,
	speed = {x=2, z=0}
}


medium_cloud.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


medium_cloud.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

medium_cloud.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}




--probabilities in each temp class

medium_cloud.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'light_cloud', 0.2, 0.2, 0.3, 0.5},
	{'overcast', 0.06, 0.06, 0.06, 0.06},
	{'sun_shower', 0, 0.5, 0.3, 0.02},
	{'snow_flurry', 0.25, 0, 0, 0}

}




--add this weather to register
climate.register_weather(medium_cloud)



------
