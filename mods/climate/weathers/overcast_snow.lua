------------------------------
-- overcast_snow weather
-- grey sky snow, moderate intensity

------------------------------

-- Random texture getter
local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end

local overcast_snow = {


	name = 'overcast_snow',

	sky_color_day = 80,
	sky_color_night = 15,
	fog = 150,

	clouds_color = "#606060",
	clouds_density = 0.6,
	clouds_height = 480,
	clouds_thickness = 128,
	clouds_speed = {x=0, z=-2},



	--probabilities in each temp class
	chain = {
		--name, p_cold, p_mid , p_hot
		{'overcast_rain', 0, 1, 1, 1},
		{'overcast_light_snow', 0.15, 0, 0, 0},
		{'heavy_snow', 0.15, 0, 0, 0}


	},


	particle_interval = 0.004,

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
climate.register_weather(overcast_snow)


------
