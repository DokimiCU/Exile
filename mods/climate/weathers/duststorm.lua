------------------------------
-- Duststorm
-- clouds of dust, low visibility
-- sky color yellowish
------------------------------

local duststorm = {


	name = 'duststorm',
	particles = false,

	sky_color_day = 222,
	sky_color_night = 18,
	fog = 180,

	clouds_color = "#ECD2AF",
	clouds_density = 0.4,
	clouds_height = 150,
	clouds_thickness = 180,
	clouds_speed = {x=0, z=3},

	sound_loop = 'duststorm_loop',

	damage = true,


	--probabilities in each temp class
	chain = {
		--name, p_froz, p_cold, p_mid , p_hot
		{'haze', 1, 0.75, 0.5, 0.25}

	},


	particle_interval = 0.0007,

	particle_function = function()
		local velxz = math.random(-5, 2)
		local vely = math.random(-3, 2)
		local accxz = math.random(-3,2)
		local accy = math.random(-2, 2)
		local ext = 10
		local size = 35
		local tex = "duststorm.png"

		climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)

		if math.random() < 0.00016 then
			lightning.strike()
		end
	end,


}

--add this weather to register
climate.register_weather(duststorm)



------
