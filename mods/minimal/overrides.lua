--overrides.lua
--Alters base minetest functions for:
--item_place
--is_protected

--A new item_place that allows disabling sneak-rightclick behavior for nodes
--Needed for tech:stick
function core.item_place(itemstack, placer, pointed_thing, param2)
        -- Call on_rightclick if the pointed node defines it
        if pointed_thing.type == "node" and placer then
                local node = core.get_node( pointed_thing.under )
                local ndef = core.registered_nodes[ node.name ]

                if ndef and ndef.on_rightclick and ( ndef.override_sneak == true or not placer:get_player_control( ).sneak ) then
                        return ndef.on_rightclick( pointed_thing.under, node, placer, itemstack, pointed_thing ) or itemstack, nil
                end
        end

        if itemstack:get_definition( ).type == "node" then
                return core.item_place_node( itemstack, placer, pointed_thing, param2 )
        end
        return itemstack, nil
end


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
