------------------------------
-- Haze
-- looming dust storm
-- sky color
------------------------------

local haze = {


	name = 'haze',
	particles = false,

	sky_color_day = 222,
	sky_color_night = 19,
	fog = 230,

	clouds_color = "#ECD2AF",
	clouds_density = 0.2,
	clouds_height = 200,
	clouds_thickness = 64,
	clouds_speed = {x=0, z=3},

	sound_loop = 'duststorm_loop_light',


	--probabilities in each temp class

	chain = {
		--name, p_froz, p_cold, p_mid , p_hot
		{'light_haze', 0.75, 0.5, 0.1, 0.1},
		{'duststorm', 0, 0, 0.01, 0.1}

	},


}

--add this weather to register
climate.register_weather(haze)



------
