------------------------------
-- Duststorm
-- clouds of dust
-- sky color yellowish, damaging
------------------------------

local duststorm = {}


duststorm.name = 'duststorm'


duststorm.sky_data = {
	type = "regular",
	clouds = true,
	sky_color = {
		day_sky = "#F4DFBE",
		day_horizon = "#f6e5cb",
		dawn_sky = "#F9A09C",
		dawn_horizon ="#fab3af",
		night_sky = "#513200",
		night_horizon = "#735a32",
		indoors = "#2B2B2B",
		--fog_sun_tint = "#FB7F55",
		--fog_moon_tint = "#C5C9C9",
		--fog_tint_type = "custom"
	}
}


duststorm.cloud_data = {
	color = "#ac9673",
	density = 0.6,
	height = 100,
	thickness = 180,
	speed = {x=0, z=4}
}


duststorm.moon_data = {
	visible = false,
	texture = "moon.png",
	tonemap = "moon_tonemap.png",
	scale = 0.5
}


duststorm.sun_data = {
	visible = false,
	texture = "sun.png",
	tonemap = "sun_tonemap.png",
	sunrise = "sunrisebg.png",
	sunrise_visible = false,
	scale = 0.4
}

duststorm.star_data = {
	visible = false,
	count = 500,
	color = "#80FCFEFF"
}




duststorm.sound_loop = 'duststorm_loop'

duststorm.damage = true


--probabilities in each temp class
duststorm.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'haze', 1, 1, 0.97, 0.35}

}

duststorm.particle_interval = 0.0007

duststorm.particle_function = function()
	local velxz = math.random(-5, 2)
	local vely = math.random(-3, 2)
	local accxz = math.random(-3,2)
	local accy = math.random(-2, 2)
	local ext = 10
	local size = 20
	local tex = "duststorm.png"

	climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)

	if math.random() < 0.00016 then
		lightning.strike()
	end
end


--add this weather to register
climate.register_weather(duststorm)



------
