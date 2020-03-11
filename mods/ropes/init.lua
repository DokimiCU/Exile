ropes = {
  name = 'ropes',
}



ropes.ropeLength =  48
ropes.ropeLadderLength =  12



dofile( minetest.get_modpath( ropes.name ) .. "/functions.lua" )
dofile( minetest.get_modpath( ropes.name ) .. "/ropeboxes.lua" )
dofile( minetest.get_modpath( ropes.name ) .. "/ladder.lua" )
dofile( minetest.get_modpath( ropes.name ) .. "/crafts.lua" )
