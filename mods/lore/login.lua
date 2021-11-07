--login.lua
--A login screen to show to new players

local logintext = ( "\n  You can scarcely hear the sound of them\n"..
		       "reading the list of your crimes over the\n" ..
		       "louder jeering of your kinsmen, but it's already\n"..
		       "too late to protest your innocence.\n"..
		       "\n  You are stripped of all possessions and given\n"..
		       "a writ describing your assorted crimes and the\n"..
		       "punishment that is to be given, and then you\n"..
		       "are pushed through a gateway to die in the\n"..
		       "cursed land of the Ancients, as an.." )

local loginspec = (-- "formspec_version 4"..
		       "size[6,6.5]"..
		   "label[0.5,0;"..logintext.."]"..
		   "image[1.5,5;6,2;logo.png]" )
		      

minetest.register_on_newplayer(function(player)
      minetest.show_formspec(player:get_player_name(),"lore:login",loginspec)
end)

local function safepoint_and_rspawn(player)
      --If rspawn is enabled, send new players to the safe point if enabled
      -- and later respawning players elsewhere randomly
      local safepoint = minetest.setting_get_pos("exile_safe_spawn_pos")
      local meta = player:get_meta()
      local lives = meta:get_int("lives")
      local safespawn = minetest.setting_get_pos("exile_safe_spawn_lives") or 0
      if lives <= safespawn and safepoint then
	 player:set_pos(safepoint)
	 return true -- disable regular respawn
      elseif rspawn then
	 rspawn:renew_player_spawn(player:get_player_name())
	 return true
      end
end

minetest.register_on_newplayer(safepoint_and_rspawn)
minetest.register_on_respawnplayer(safepoint_and_rspawn)


minetest.register_on_player_receive_fields(function(player, formname, fields)
      --maybe unnecessary, but guarantee they won't be penalized for reading
      if formname == "lore:login" then
	 reset_attributes(player)
      end
end)
      
