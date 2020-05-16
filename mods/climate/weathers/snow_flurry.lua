------------------------------
-- snow_flurry
-- patchy clouds and a few snow flakes

------------------------------
-- Random texture getter
	local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end



local snow_flurry = {}

snow_flurry.name = 'snow_flurry'

snow_flurry.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#A5D4F6",
		day_horizon = "#b7dcf7",
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


snow_flurry.cloud_data = {
	color = "#FFFFFF",
	density = 0.4,
	height = 340,
	thickness = 32,
	speed = {x=0, z=-2}
}



snow_flurry.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


snow_flurry.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

snow_flurry.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}




	--probabilities in each temp class

snow_flurry.chain = {
	--name, p_froz p_cold, p_mid , p_hot
	{'medium_cloud', 0.15, 1, 1, 1},
	{'sun_shower', 0, 1, 1, 1},
	{'light_snow', 0.5, 0, 0, 0}

}


snow_flurry.particle_interval = 0.5

snow_flurry.particle_function = function()

	local velxz = math.random(-1,-0.1)
	local vely = math.random(-1, 0)
	local accxz = math.random(-1,-0.1)
	local accy = -0.5
	local ext = 7
	local size = 2
	local tex = random_texture()
	local sound = ""

	climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)
end



--add this weather to register
climate.register_weather(snow_flurry)


------
