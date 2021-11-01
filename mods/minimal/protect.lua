--Basic protection support
local old_is_protected = minetest.is_protected

function minetest.is_protected(pos, name)
   local owner = minetest.get_meta(pos):get_string("owner")
   local bypass = minetest.check_player_privs(name, "protection_bypass")
   if not ( owner == "" or owner == name or
	    minetest.check_player_privs(name, "protection_bypass") ) then
      return true
   end
   return old_is_protected(pos, name)
end
