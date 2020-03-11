------------------------------
-- light cloud weather
-- blue sky weather, a few clouds

------------------------------

local light_cloud = {}


light_cloud.name = 'light_cloud'
light_cloud.particles = false


light_cloud.clouds_color = "#FFFFFF"
light_cloud.clouds_density = 0.2
light_cloud.clouds_height = 580
light_cloud.clouds_thickness = 8
light_cloud.clouds_speed = {x=2, z=0}


--probabilities in each temp class

light_cloud.chain = {
	--name, p_cold, p_mid , p_hot
	{'clear', 0.1, 0.2, 0.4, 0.8},
	{'medium_cloud', 0.75, 0.75, 0.5, 0.25},
	{'snow_flurry', 0.1, 0, 0, 0}

}




--add this weather to register
climate.register_weather(light_cloud)



------
