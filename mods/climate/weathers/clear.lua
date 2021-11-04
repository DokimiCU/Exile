------------------------------
-- Clear weather
-- blue sky weather, few to small clouds

------------------------------

local clear = {}

clear.name = 'clear'


clear.sky_data = {
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


clear.cloud_data = {
	color = "#FFFFFF",
	density = 0.1,
	height = 500,
	thickness = 4,
	speed = {x=1, z=0}
}


clear.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


clear.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

clear.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}




--probabilities in each temp class

clear.chain = {
	--name, p_forz, p_cold, p_mid , p_hot
	{'light_cloud', 0.3, 0.3, 0.3, 0.3},
	{'light_haze', 0.0, 0.0, 0.0, 0.05}


}




--add this weather to register
climate.register_weather(clear)



------
