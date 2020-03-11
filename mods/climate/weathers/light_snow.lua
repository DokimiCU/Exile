------------------------------
-- light_snow weather
-- gentle snow

------------------------------
-- Random texture getter
local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end



local light_snow = {


	name = 'light_snow',


	clouds_color = "#D6D6D6",
	clouds_density = 0.5,
	clouds_height = 520,
	clouds_thickness = 64,
	clouds_speed = {x=0, z=-2},



	--probabilities in each temp class
	chain = {
		--name, p_cold, p_mid , p_hot
		{'overcast_light_rain', 0, 0.75, 1, 1},
		{'overcast', 0.15, 1, 1, 1},
		{'snow_flurry', 0.25, 0, 0, 0},
		{'overcast_light_snow', 0.25, 0, 0, 0}

	},


	particle_interval = 0.1,

	particle_function = function()

		local velxz = math.random(-1,-0.1)
		local vely = math.random(-1.5,-0.5)
		local accxz = math.random(-1,-0.1)
		local accy = -0.5
		local ext = 7
		local size = 2
		local tex = random_texture()
		local sound = ""

		climate.add_blizzard_particle(velxz, vely, accxz, accy, ext, size, tex)
	end,
}


--add this weather to register
climate.register_weather(light_snow)

------
