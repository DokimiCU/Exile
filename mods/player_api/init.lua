-- player/init.lua

dofile(minetest.get_modpath("player_api") .. "/api.lua")
dofile(minetest.get_modpath("player_api") .. "/base_texture.lua")
dofile(minetest.get_modpath("player_api") .. "/cloths.lua")

animation_table = {
		-- Standard animations.
		stand         = {x = 0,   y = 80},
		sit           = {x = 81,  y = 161},
		lay           = {x = 162, y = 167},
		walk          = {x = 168, y = 188},
		mine          = {x = 189, y = 199},
		walk_mine     = {x = 200, y = 220},
		float         = {x = 225, y = 245},
		float_mine    = {x = 250, y = 270},
		swim          = {x = 275, y = 315},
		swim_mine     = {x = 320, y = 360},
		crouch        = {x = 365, y = 375},
		crouch_mine   = {x = 380, y = 390},
		crawl         = {x = 395, y = 415},
		crawl_mine    = {x = 420, y = 440},
}

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png"},
	animations = animation_table,
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.45,
})

--Just a copy of the male model, but with a smaller visual_size applied
--Minetest doesn't allow you to register one model two ways
--TODO: Find/make better models
player_api.register_model("character-f.b3d", {
	animation_speed = 30,
	textures = {
		"female.png",
		"3d_armor_trans.png",
		"3d_armor_trans.png",
	},
	animations = animation_table,
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	visual_size = { x =.8, y = .94, z = .8 },
	stepheight = 0.6,
	eye_height = 1.38,
})

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
        local player_name = player:get_player_name()
	player_api.player_attached[player_name] = false
	local gender = player_api.get_gender(player)
	if gender == "" then
	   player_api.set_gender(player, "random") --set random gender
	end
	player:get_inventory():set_size("hand", 1)
	if not player_api.has_cloths(player) then
	   player_api.set_cloths(player)
	end
	local pinv = player:get_inventory()
	if pinv:get_size("cloths") == 8 then
	   --Exile uses 6 slots, but playerapi originally set 8
	   pinv:set_size("cloths", 6)
	end
	local cloth = player_api.compose_cloth(player)
	player_api.registered_models[player_api.get_gender_model(gender)].textures[1] = cloth
	player_api.set_model(player, player_api.get_gender_model(gender))
end)
