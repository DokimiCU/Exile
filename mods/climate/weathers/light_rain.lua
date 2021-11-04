------------------------------
-- light_rain weather
-- gentle rain, blue sky still visible

------------------------------

local light_rain = {}


light_rain.name = 'light_rain'



light_rain.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#91CDF9",
		day_horizon = "#a7d7fa",
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


light_rain.cloud_data = {
	color = "#D6D6D6",
	density = 0.5,
	height = 320,
	thickness = 64,
	speed = {x=2, z=0}
}



light_rain.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


light_rain.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

light_rain.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}


light_rain.sound_loop = 'light_rain_loop'

--probabilities in each temp class
light_rain.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'sun_shower', 0, 0.25, 0.5, 0.5},
	{'overcast_light_rain', 0, 0.5, 0.25, 0.12},
	{'overcast', 0.1, 0.2, 0.3, 0.4},
	{'light_snow', 1, 0, 0, 0}

}


-- Random texture getter
local random_texture = function()
	local base_name = "light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end


light_rain.particle_interval = 0.1

light_rain.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 5
	local size = 1
	local tex = random_texture()
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end



--add this weather to register
climate.register_weather(light_rain)


------
