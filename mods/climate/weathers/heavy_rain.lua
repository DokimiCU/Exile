------------------------------
-- heavy_rainn weather
-- grey sky rain, heavy intensity

------------------------------

local heavy_rain = {}


heavy_rain.name = 'heavy_rain'

--day, night, sunrise/sunset
heavy_rain.sky_color_day = 70
heavy_rain.sky_color_night = 15
heavy_rain.fog = 100

heavy_rain.clouds_color = "#505050"
heavy_rain.clouds_density = 0.6
heavy_rain.clouds_height = 460
heavy_rain.clouds_thickness = 128
heavy_rain.clouds_speed = {x=2, z=0}

heavy_rain.sound_loop = 'heavy_rain_loop'

--probabilities in each temp class
heavy_rain.chain = {
	--name, p_cold, p_mid , p_hot
	{'overcast_rain', 0, 0.25, 0.5, 0.75},
	{'heavy_snow', 1, 0, 0, 0},
	{'thunderstorm', 0, 0.01, 0.25, 0.75}

}




heavy_rain.particle_interval = 0.001

heavy_rain.particle_function = function()
	local vel = -10
	local acc = -10
	local ext = 6
	local size = 30
	local tex = "heavy_rain_drops.png"
	local sound = ""

	climate.add_particle(vel, acc, ext, size, tex)
end



--add this weather to register
climate.register_weather(heavy_rain)


------
