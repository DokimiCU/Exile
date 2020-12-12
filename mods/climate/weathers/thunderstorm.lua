------------------------------
-- thunderstorm weather
-- grey sky rain, heavy intensity, lightning

------------------------------

local thunderstorm = {}

thunderstorm.name = 'thunderstorm'


thunderstorm.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#4E5160",
		day_horizon = "#5f626f",
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


thunderstorm.cloud_data = {
	color = "#393B42",
	density = 0.6,
	height = 260,
	thickness = 128,
	speed = {x=3, z=0}
}




thunderstorm.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


thunderstorm.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

thunderstorm.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}




thunderstorm.sound_loop = 'heavy_rain_loop'

	--probabilities in each temp class
thunderstorm.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_heavy_rain', 0.05, 0.5, 0.5, 0.5},
	{'superstorm', 0, 0, 0, 0.1},
	{'snowstorm', 1, 0, 0, 0}

}


thunderstorm.particle_interval = 0.001

thunderstorm.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 6
	local size = 20
	local tex = "heavy_rain_drops.png"
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)

	if math.random() < 0.002 then
		lightning.strike()
	end
end


--add this weather to register
climate.register_weather(thunderstorm)


------
