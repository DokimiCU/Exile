------------------------------
-- sun_shower weather
-- patchy clouds and a few spots of rain

------------------------------

local sun_shower = {}


sun_shower.name = 'sun_shower'


sun_shower.sky_data = {
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


sun_shower.cloud_data = {
	color = "#FFFFFF",
	density = 0.4,
	height = 340,
	thickness = 32,
	speed = {x=2, z=0}
}



sun_shower.moon_data = {
	visible = true,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


sun_shower.sun_data = {
	visible = true,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = true,
	scale = 0.4
}

sun_shower.star_data = {
	visible = true,
	count = 2000,
	color = "#80FCFEFF"
}




sun_shower.sound_loop = 'light_rain_loop'

--probabilities in each temp class

sun_shower.chain = {
	--name, p_cold, p_mid , p_hot
	{'medium_cloud',0.25, 0.25, 0.5, 0.75},
	{'light_rain', 0, 0.5, 0.5, 0.05},
	{'snow_flurry', 1, 0, 0, 0}

}

-- Random texture getter
local random_texture = function()
	local base_name = "light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end


sun_shower.particle_interval = 0.5

sun_shower.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 5
	local size = 1
	local tex = random_texture()
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end

--add this weather to register
climate.register_weather(sun_shower)


------
