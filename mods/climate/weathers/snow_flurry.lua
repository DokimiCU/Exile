------------------------------
-- snow_flurry
-- patchy clouds and a few snow flakes

------------------------------
-- Random texture getter
	local random_texture = function()
	local base_name = "snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end



local snow_flurry = {


	name = 'snow_flurry',

	clouds_color = "#FFFFFF",
	clouds_density = 0.4,
	clouds_height = 540,
	clouds_thickness = 32,
	clouds_speed = {x=0, z=-2},


	--probabilities in each temp class

	chain = {
		--name, p_froz p_cold, p_mid , p_hot
		{'medium_cloud', 0.15, 1, 1, 1},
		{'sun_shower', 0, 1, 1, 1},
		{'light_snow', 0.5, 0, 0, 0}

	},


	particle_interval = 0.5,

	particle_function = function()

		local velxz = math.random(-1,-0.1)
		local vely = math.random(-1, 0)
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
climate.register_weather(snow_flurry)


------
