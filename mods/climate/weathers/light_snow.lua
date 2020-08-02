------------------------------
-- light_snow weather
-- gentle snow

------------------------------
-- Random texture getter
local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end



local light_snow = {}

light_snow.name = 'light_snow'

light_snow.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#97C0F9",
		day_horizon = "#ABCCFA",
		dawn_sky = "#9EADFF",
		dawn_horizon ="#b1bdff",
		night_sky = "#0600A9",
		night_horizon = "#3732ba",
		indoors = "#2B2B2B",
		--fog_sun_tint = "#FB7F55",
		--fog_moon_tint = "#C5C9C9",
		--fog_tint_type = "custom"
	}
}


light_snow.cloud_data = {
	color = "#C9CCDB",
	density = 0.5,
	height = 320,
	thickness = 64,
	speed = {x=0, z=-2}
}


light_snow.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


light_snow.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

light_snow.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}





--probabilities in each temp class
light_snow.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_light_rain', 0, 0.75, 1, 1},
	{'overcast', 0.15, 1, 1, 1},
	{'snow_flurry', 0.25, 0, 0, 0},
	{'overcast_light_snow', 0.25, 0, 0, 0}

}


light_snow.particle_interval = 0.1

light_snow.particle_function = function()

	local velxz = math.random(-1,-0.1)
	local vely = math.random(-1.5,-0.5)
	local accxz = math.random(-1,-0.1)
	local accy = -0.5
	local ext = 7
	local size = 2
	local tex = random_texture()
	local sound = ""

	climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)
end



--add this weather to register
climate.register_weather(light_snow)

------
