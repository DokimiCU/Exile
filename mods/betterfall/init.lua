-- MOD STRUCT INITIALIZATION
betterfall = {}
betterfall.path = minetest.get_modpath("betterfall")
betterfall.ghost_nodes = {} -- those nodes will just disappear instead of falling
betterfall.falling_timer = 0.0

function betterfall.register_ghostnode(nodename)
    table.insert(betterfall.ghost_nodes, nodename)
end

function betterfall.set_falling_timer(timer)
    betterfall.falling_timer = timer
end

dofile(betterfall.path.."/config.lua")
dofile(betterfall.path.."/attached.lua")
dofile(betterfall.path.."/fallingqueue.lua")

--[[ Don't want this for everything
for nodename, nodedef in pairs(minetest.registered_nodes) do
    if nodedef.groups.falling_node == nil and
         nodedef.name ~= "air" and
         minetest.get_item_group(nodedef.name, "attached_node") == 0 and
         minetest.get_item_group(nodedef.name, "liquid") == 0
        then
            nodedef.groups.falling_node = 2
    end
end
]]--


local function is_node_supporting(n, p_bottom)
    local n_bottom = core.get_node_or_nil(p_bottom)
    local d_bottom = n_bottom and core.registered_nodes[n_bottom.name]

    if d_bottom and
        (core.get_item_group(n.name, "float") == 0 or
        d_bottom.liquidtype == "none") and

        (n.name ~= n_bottom.name or (d_bottom.leveled and
        core.get_node_level(p_bottom) <
        core.get_node_max_level(p_bottom))) and

        (not d_bottom.walkable or d_bottom.buildable_to) then
            return false
    end

    return true
end

local supporting_neighbours_lateral = {
    {x = 1, y = 0, z = 0},
    {x = -1, y = 0, z = 0},

    {x = 0, y = 0, z = -1},
    {x = 0, y = 0, z = 1},

    {x = 1, y = 0, z = 1},
    {x = -1, y = 0, z = -1},

    {x = 1, y = 0, z = -1},
    {x = -1, y = 0, z = 1},
}

local supporting_neighbours_diagonal = {
    {x = 1, y = -1, z = 0},
    {x = -1, y = -1, z = 0},

    {x = 0, y = -1, z = -1},
    {x = 0, y = -1, z = 1},

    {x = 1, y = -1, z = 1},
    {x = -1, y = -1, z = -1},

    {x = 1, y = -1, z = -1},
    {x = -1, y = -1, z = 1}
}

function betterfall.should_node_fall(node, pos, fallgroup)
    if is_node_supporting(pos, {x = pos.x, y = pos.y - 1, z = pos.z}) then
        return false
    end

    local range = core.get_item_group(node.name, "falling_node") - 1

    if range > 0 then
        for i, diagneighpos in pairs(supporting_neighbours_diagonal) do
            local dp = {
                x = pos.x + diagneighpos.x,
                y = pos.y + diagneighpos.y,
                z = pos.z + diagneighpos.z
            }

            if is_node_supporting(pos, dp, node) then
                return false
            else
                for j, latneighpos in pairs(supporting_neighbours_lateral) do
                    local lp = {
                        x = pos.x + latneighpos.x,
                        y = pos.y + latneighpos.y,
                        z = pos.z + latneighpos.z
                    }

                    if is_node_supporting(pos, lp, node) then
                        local ldp = {
                            x = dp.x + latneighpos.x,
                            y = dp.y + latneighpos.y,
                            z = dp.z + latneighpos.z
                        }

                        if is_node_supporting(pos, ldp, node) then
                            return false
                        end
                    end
                end
            end
        end
    end

    return true
end

minetest.check_single_for_falling = function(pos)
    local node = core.get_node(pos)
    local meta = minetest.get_meta(pos);

    local falling_node_group = core.get_item_group(node.name, "falling_node")

	if falling_node_group ~= 0 and meta:get_int("falling") ~= 1 then
	   local result = betterfall.should_node_fall(node, pos,
						      falling_node_group - 1)

        if result then
            meta:set_int("falling", 1)
            node = core.get_node(pos)
            betterfall.enqueue_falling_node(pos, node, meta)
        end

        return result
    end

	if core.get_item_group(node.name, "attached_node") ~= 0 then
	   if not betterfall.check_attached_node(pos, node) then
	      betterfall.drop_attached_node(pos)
	      return true
	   end
	end

    return false
end

local check_for_falling_neighbors = {
   {x = -1, y = -1, z = 0},
   {x = 1, y = -1, z = 0},
   {x = 0, y = -1, z = -1},
   {x = 0, y = -1, z = 1},
   {x = 0, y = -1, z = 0},

   {x = -1, y = 0, z = 0},
   {x = 1, y = 0, z = 0},
   {x = 0, y = 0, z = 1},
   {x = 0, y = 0, z = -1},
   {x = 0, y = 0, z = 0},

   {x = -1, y = 0, z = -1},
   {x = 1, y = 0, z = 1},
   {x = -1, y = 0, z = 1},
   {x = 1, y = 0, z = -1},

   {x = -1, y = 1, z = 0},
   {x = 1, y = 1, z = 0},
   {x = 0, y = 1, z = 1},
   {x = 0, y = 1, z = -1},
   {x = 0, y = 1, z = 0},

   {x = -1, y = 1, z = -1},
   {x = 1, y = 1, z = 1},
   {x = -1, y = 1, z = 1},
   {x = 1, y = 1, z = -1},

   {x = 0, y = 2, z = 0}
}

minetest.check_for_falling = function(pos)
   -- print("check for falling " .. p.x .. " " .. p.y .. " " .. p.z)

   pos = vector.round(pos)

   local s = {}
   local n = 0
   local val = 1

   while true do
      n = n + 1
      s[n] = {p = pos, v = val}
      pos = vector.add(pos, check_for_falling_neighbors[val])
      if not core.check_single_for_falling(pos) then
	 repeat
	    local pop = s[n]
	    pos = pop.p
	    val = pop.v
	    s[n] = nil
	    n = n - 1
	    if n == 0 and val == #check_for_falling_neighbors then
	       return
	    end
	 until val < #check_for_falling_neighbors
	 val = val + 1
      else
	 val = 1
      end
   end
end
