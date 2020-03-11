------------------------------
-- snowstorm
-- very heavy blustery snow
------------------------------

local snowstorm = {


	name = 'snowstorm',
	particles = false,

	sky_color_day = 80,
	sky_color_night = 15,
	fog = 180,

	damage = true,

	clouds_color = "#505050",
	clouds_density = 0.6,
	clouds_height = 460,
	clouds_thickness = 148,
	clouds_speed = {x=0, z=-2},

	sound_loop = 'snowstorm_loop',


	--probabilities in each temp class
	chain = {
		--name, p_froz, p_cold, p_mid , p_hot
		--{'thunderstorm', 0, 1, 1, 1},
		--{'superstorm', 0, 1, 1, 1},
		{'heavy_snow', 0.15, 1, 1, 1}

	},


	particle_interval = 0.0006,

	particle_function = function()
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
	end,


}

--add this weather to register
climate.register_weather(snowstorm)



------
