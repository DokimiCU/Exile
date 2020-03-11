------------------------------
-- Clear weather
-- blue sky weather, few to no clouds or rain

------------------------------

local clear = {}


clear.name = 'clear'
clear.particles = false


clear.clouds_color = "#FFFFFF"
clear.clouds_density = 0.1
clear.clouds_height = 600
clear.clouds_thickness = 4
clear.clouds_speed = {x=3, z=0}


--probabilities in each temp class

clear.chain = {
	--name, p_forz, p_cold, p_mid , p_hot
	{'light_cloud', 0.7, 0.4, 0.3, 0.2}

}




--add this weather to register
climate.register_weather(clear)



------
