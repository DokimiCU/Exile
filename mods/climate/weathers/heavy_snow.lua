------------------------------
-- heavy_snow weather
-- grey sky snow, heavy intensity

------------------------------

-- Random texture getter
local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end


local heavy_snow = {


	name = 'heavy_snow',

	--day, night, sunrise/sunset
	sky_color_day = 70,
	sky_color_night = 15,
	fog = 100,

	clouds_color = "#505050",
	clouds_density = 0.6,
	clouds_height = 460,
	clouds_thickness = 128,
	clouds_speed = {x=0, z=-2},

	sound_loop = 'snowstorm_loop_light',


	--probabilities in each temp class
	chain = {
		--name, p_cold, p_mid , p_hot
		{'overcast_rain', 0, 1, 1, 1},
		{'heavy_rain', 0, 1, 1, 1},
		{'thunderstorm', 0, 0, 0, 1},
		{'overcast_snow', 0.15, 0, 0, 0},
		{'snowstorm', 0.15, 0, 0, 0}

	},


	particle_interval = 0.0009,

	particle_function = function()

		local velxz = math.random(-1,-0.1)
		local vely = math.random(-2,-0.5)
		local accxz = math.random(-1,-0.1)
		local accy = -0.5
		local ext = 7
		local size = 3
		local tex = random_texture()
		local sound = ""

		climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)
	end,
}



--add this weather to register
climate.register_weather(heavy_snow)


------
