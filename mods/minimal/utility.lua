minimal = minimal

function minimal.switch_node(pos, node)
   --Swap a node, but run its on_construct, so that
   -- timers etc. are started, but metadata is left intact
   if not minetest.registered_nodes[node.name] then
      minetest.log("error","Attempted to switch_node to an invalid node: "..node.name)
      return
   end
   minetest.swap_node(pos, node)
   if minetest.registered_nodes[node.name].on_construct then
      minetest.registered_nodes[node.name].on_construct(pos)
   end
end

function minimal.safe_landing_spot(pos)
   if pos == nil then return false end
   local dest_top = minetest.get_node({ x = pos.x, y = pos.y+1, z = pos.z })
   local dest_bot = minetest.get_node({ x = pos.x, y = pos.y  , z = pos.z })
   local floor = vector.new( pos.x, pos.y-1, pos.z )
   local dest_flr = minetest.get_node(floor)
   local def_top = minetest.registered_nodes[dest_top.name]
   local def_bot = minetest.registered_nodes[dest_bot.name]
   local def_flr = minetest.registered_nodes[dest_flr.name]
   if dest_top.name ~= "ignore" and ( def_top and
				      def_top.walkable == true ) then
      return false -- loaded a solid node
   end
   if dest_bot.name ~= "ignore" and ( def_bot and
				      def_bot.walkable == true ) then
      return false
   end
   if dest_flr.name == "ignore" or ( def_flr and
				     def_flr.walkable == true ) then
      return true
   end
   -- floor is not walkable, search below it for a walkable floor
   local count = 0
   repeat
      floor = vector.add(floor, vector.new(0, -1, 0))
      dest_flr = minetest.get_node(floor)
      def_flr = minetest.registered_nodes[dest_flr.name]
      count = count + 1
   until ( def_flr and def_flr.walkable == true ) or
      count == 20
   if count == 20 then -- a 20 node drop is certain death
      return false
   else
      return true
   end
end
