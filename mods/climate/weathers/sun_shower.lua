------------------------------
-- sun_shower weather
-- patchy clouds and a few spots of rain

------------------------------

local sun_shower = {}


sun_shower.name = 'sun_shower'

sun_shower.clouds_color = "#FFFFFF"
sun_shower.clouds_density = 0.4
sun_shower.clouds_height = 540
sun_shower.clouds_thickness = 32
sun_shower.clouds_speed = {x=2, z=0}

sun_shower.sound_loop = 'light_rain_loop'

--probabilities in each temp class

sun_shower.chain = {
	--name, p_cold, p_mid , p_hot
	{'medium_cloud',0.25, 0.25, 0.5, 0.75},
	{'light_rain', 0.01, 0.75, 0.5, 0.25},
	{'snow_flurry', 0.25, 0, 0, 0}

}

-- Random texture getter
local random_texture = function()
	local base_name = "light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end


sun_shower.particle_interval = 0.5

sun_shower.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 5
	local size = 1
	local tex = random_texture()
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end

--add this weather to register
climate.register_weather(sun_shower)


------
