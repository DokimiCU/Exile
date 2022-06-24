--inherited from builtin/falling.lua
betterfall = betterfall

function betterfall.drop_attached_node(p)
	local n = core.get_node(p)
	local drops = core.get_node_drops(n, "")
	local def = core.registered_items[n.name]
	if def and def.preserve_metadata then
		local oldmeta = core.get_meta(p):to_table().fields
		-- Copy pos and node because the callback can modify them.
		local pos_copy = {x=p.x, y=p.y, z=p.z}
		local node_copy = {name=n.name, param1=n.param1, param2=n.param2}
		local drop_stacks = {}
		for k, v in pairs(drops) do
			drop_stacks[k] = ItemStack(v)
		end
		drops = drop_stacks
		def.preserve_metadata(pos_copy, node_copy, oldmeta, drops)
	end
	core.remove_node(p)
	for _, item in pairs(drops) do
		local pos = {
			x = p.x + math.random()/2 - 0.25,
			y = p.y + math.random()/2 - 0.25,
			z = p.z + math.random()/2 - 0.25,
		}
		core.add_item(pos, item)
	end
end

function betterfall.check_attached_node(p, n)
    local def = core.registered_nodes[n.name]
    local d = {x = 0, y = 0, z = 0}
    if def.paramtype2 == "wallmounted" or
            def.paramtype2 == "colorwallmounted" then
        d = core.wallmounted_to_dir(n.param2) or {x = 0, y = 1, z = 0}
    else
        d.y = -1
    end
    local p2 = vector.add(p, d)
    local nn = core.get_node(p2).name
    local def2 = core.registered_nodes[nn]
    if def2 and not def2.walkable then
        return false
    end
    return true
end
