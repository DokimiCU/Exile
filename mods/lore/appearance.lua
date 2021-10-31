--appearance.lua
--
--Generates a new appearance when a player joins or respawns

--Random tables
--TODO: Set up peoples and polities for character origin, use those instead
local HC = {"black", "gray", "brown", "red", "blonde"}
local SC = {"tan", "pale", "red", "yellow", "brown", "black",
	    --natural colors three times, greater odds of getting one
	    "tan", "pale", "red", "yellow", "brown", "black",
	    "tan", "pale", "red", "yellow", "brown", "black",
	    --unnatural colors
	    "greenmen","bluemen","graymen","redmen"}
local EC = {"blue","brown","gray","green","hazel","violet"}

local function NewBody(player)
   player_api.set_gender(player, "random")
   player_api.set_base_textures(player)
   local base_texture = player_api.load_base_texture_table(player)
   local SColor = SC[math.random(1,#SC)]
   local HColor = HC[math.random(1,#HC)]
   local EColor = EC[math.random(1,#EC)]
   base_texture["skin"].color = SColor 
   base_texture["hair"].color = HColor
   base_texture["eye"] = "player_"..EColor.."_eye.png"
   player_api.save_base_texture(player, base_texture)
end

minetest.register_on_newplayer(function(player)
      NewBody(player)
end)

minetest.register_on_respawnplayer(function(player)
      NewBody(player)
      player_api.set_texture(player)
end)
