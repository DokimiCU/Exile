------------------------------
-- Light Haze
-- entry into dust storm pathway
--drought, hot weather, sky color paler

------------------------------

local light_haze = {


	name = 'light_haze',
	particles = false,

	sky_color_day = 255,
	sky_color_night = 15,
	fog = 200,

	clouds_color = "#FFFFFF",
	clouds_density = 0.1,
	clouds_height = 600,
	clouds_thickness = 4,
	clouds_speed = {x=0, z=1},


	--probabilities in each temp class

	chain = {
		--name, p_froz, p_cold, p_mid , p_hot
		{'clear', 0.75, 0.5, 0.1, 0.1},
		{'haze', 0, 0, 0, 0.25}

	},


}

--add this weather to register
climate.register_weather(light_haze)



------
