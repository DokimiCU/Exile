------------------------------
-- superstorm weather
-- grey sky rain, heavy intensity, a barrage of lightning

------------------------------

local superstorm = {}


superstorm.name = 'superstorm'


superstorm.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#40434F",
		day_horizon = "#535560",
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


superstorm.cloud_data = {
	color = "#2E3036",
	density = 0.6,
	height = 260,
	thickness = 128,
	speed = {x=3, z=0}
}


superstorm.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


superstorm.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

superstorm.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}






superstorm.sound_loop = 'heavy_rain_loop'

	--probabilities in each temp class
superstorm.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'thunderstorm', 0, 1, 1, 1},
	{'snowstorm', 1, 0, 0, 0}

}


superstorm.particle_interval = 0.0009

superstorm.particle_function = function()
		local vel = -10
		local acc = -10
		local ext = 6
		local size = 20
		local tex = "heavy_rain_drops.png"
		local sound = ""

		climate.add_particle(vel, acc, ext, size, tex)

		if math.random() < 0.02 then
			lightning.strike()
		end
	end


--add this weather to register
climate.register_weather(superstorm)


------
