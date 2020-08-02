------------------------------
-- overcast_light_snow weather
-- grey sky snow

------------------------------
local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end



local overcast_light_snow = {}


overcast_light_snow.name = 'overcast_light_snow'


overcast_light_snow.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#BCC7D4",
		day_horizon = "#c9d2dc",
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


overcast_light_snow.cloud_data = {
	color = "#A7ADC9",
	density = 0.6,
	height = 300,
	thickness = 128,
	speed = {x=0, z=-2}
}


overcast_light_snow.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


overcast_light_snow.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

overcast_light_snow.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}



--probabilities in each temp class
overcast_light_snow.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast', 0.15, 1, 1, 1},
	{'overcast_snow', 0.25, 0, 0, 0},
	{'overcast_light_rain', 0, 1, 1, 1},
	{'light_snow', 0.1, 0, 0, 0}

}

overcast_light_snow.particle_interval = 0.1

overcast_light_snow.particle_function = function()

	local velxz = math.random(-1,-0.1)
	local vely = math.random(-2,-0.5)
	local accxz = math.random(-1,-0.1)
	local accy = -0.5
	local ext = 7
	local size = 2
	local tex = random_texture()
	local sound = ""

	climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)
end





--add this weather to register
climate.register_weather(overcast_light_snow)


------
