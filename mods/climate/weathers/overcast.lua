------------------------------
-- overcast weather
-- grey sky but no rain

------------------------------

local overcast = {}


overcast.name = 'overcast'

overcast.sky_color_day = 90
overcast.sky_color_night = 15
overcast.fog = 200

overcast.clouds_color = "#808080"
overcast.clouds_density = 0.6
overcast.clouds_height = 500
overcast.clouds_thickness = 128
overcast.clouds_speed = {x=2, z=0}

--overcast.sound_loop = 'light_rain_loop'

--probabilities in each temp class
overcast.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_light_rain',0.01, 0.75, 0.5, 0.25},
	{'light_rain', 0.01, 0.05, 0.15, 0.25},
	{'overcast_light_snow', 0.25, 0, 0, 0},
	{'light_snow', 0.1, 0, 0, 0}

}




--add this weather to register
climate.register_weather(overcast)


------
