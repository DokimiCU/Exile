------------------------------
-- overcast_snow weather
-- grey sky snow, moderate intensity

------------------------------

-- Random texture getter
local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end

local overcast_snow = {}

overcast_snow.name = 'overcast_snow'

overcast_snow.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#9EACBD",
		day_horizon = "#b1bcca",
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


overcast_snow.cloud_data = {
	color = "#848CB0",
	density = 0.6,
	height = 280,
	thickness = 128,
	speed = {x=0, z=-2}
}


overcast_snow.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


overcast_snow.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

overcast_snow.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}




--probabilities in each temp class
overcast_snow.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_rain', 0, 1, 1, 1},
	{'overcast_light_snow', 0.15, 0, 0, 0},
	{'overcast_heavy_snow', 0.15, 0, 0, 0}

}


overcast_snow.particle_interval = 0.004

overcast_snow.particle_function = function()

	local velxz = math.random(-1,-0.1)
	local vely = math.random(-2,-0.5)
	local accxz = math.random(-1,-0.1)
	local accy = -0.5
	local ext = 7
	local size = 3
	local tex = random_texture()
	local sound = ""

	climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)
end

--add this weather to register
climate.register_weather(overcast_snow)


------
