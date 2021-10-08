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

minetest.register_on_player_receive_fields(function(player, formname, fields)
      --maybe unnecessary, but guarantee they won't be penalized for reading
      if formname == "lore:login" then
	 reset_attributes(player)
      end
end)
      
