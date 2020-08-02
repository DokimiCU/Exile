------------------------------
-- snowstorm
-- very heavy blustery snow
------------------------------

local snowstorm = {}


snowstorm.name = 'snowstorm'

snowstorm.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#62758D",
		day_horizon = "#8190a3",
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


snowstorm.cloud_data = {
	color = "#656A83",
	density = 0.6,
	height = 260,
	thickness = 148,
	speed = {x=0, z=-3}
}


snowstorm.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


snowstorm.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

snowstorm.star_data = {
	visible = false,
	count = 1000,
	color = "#80FCFEFF"
}



snowstorm.damage = true

snowstorm.sound_loop = 'snowstorm_loop'

--probabilities in each temp class
snowstorm.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	--{'thunderstorm', 0, 1, 1, 1},
	--{'superstorm', 0, 1, 1, 1},
	{'overcast_heavy_snow', 0.15, 1, 1, 1}

}


snowstorm.particle_interval = 0.0006

snowstorm.particle_function = function()
	local velxz = math.random(-3,1.5)
	local vely = math.random(-3, 1.5)
	local accxz = math.random(-4, 1.5)
	local accy = -1.5
	local ext = 10
	local size = 40
	local tex = "snowstorm.png"

	climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)

	if math.random() < 0.0001 then
		lightning.strike()
	end
end




--add this weather to register
climate.register_weather(snowstorm)



------
