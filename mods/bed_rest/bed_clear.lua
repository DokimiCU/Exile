--bed_clear.lua
--Clears busted bed tops from the map as soon as they're loaded

local Set = minetest.settings
if minetest.settings:get_bool('exile_bed_clear') then
   minetest.log("warning","Bed clear LBM is enabled, searching for broken beds")
   minetest.register_lbm({ --This should clean up nodes that don't get deleted for some reason
      nodenames={"tech:sleeping_spot_top","tech:sleeping_mat_top","tech:primitive_bed_top","tech:mattress_top","tech:bed_top"},
      label="Remove leftover half-beds",
      name="bed_rest:bed_cleanup",
      run_at_every_load = true,
      action = function(pos)
	   local canExist = false
	   local topname = minetest.get_node(pos).name
	   local bottomname = topname:gsub("%_top","_bottom")
	   local xpos1 = { x = pos.x - 1, y = pos.y, z = pos.z }
	   local xpos2 = { x = pos.x + 1, y = pos.y, z = pos.z}
	   local xfind =  minetest.find_nodes_in_area(xpos1, xpos2,
						      {bottomname, "ignore"})
	   local zpos1 = { x = pos.x , y = pos.y, z = pos.z - 1}
	   local zpos2 = { x = pos.x , y = pos.y, z = pos.z + 1}
	   local zfind =  minetest.find_nodes_in_area(zpos1, zpos2,
						      {bottomname, "ignore"})
	   --"ignore" is an unloaded node, there could be a bottom in there
	   if #xfind > 0 then
	      canExist = true
	   end
	   if #zfind > 0 then
	      canExist = true
	   end
	   if not canExist then
	      minetest.remove_node(pos)
	   end
	end
   })
end
