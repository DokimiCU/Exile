------------------------------
-- medium cloud weather
-- blue sky weather, but a few more clouds

------------------------------

local medium_cloud = {}


medium_cloud.name = 'medium_cloud'
medium_cloud.particles = false

medium_cloud.clouds_color = "#FFFFFF"
medium_cloud.clouds_density = 0.3
medium_cloud.clouds_height = 560
medium_cloud.clouds_thickness = 16
medium_cloud.clouds_speed = {x=2, z=0}


--probabilities in each temp class

medium_cloud.chain = {
	--name, p_froz, p_cold, p_mid , p_hot
	{'light_cloud', 0.12, 0.25, 0.5, 0.75},
	{'sun_shower', 0, 0.75, 0.5, 0.25},
	{'snow_flurry', 0.25, 0, 0, 0}

}




--add this weather to register
climate.register_weather(medium_cloud)



------
