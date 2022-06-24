betterfall = betterfall -- explicitly declare the global, makes luacheck happy
betterfall.next_fall_time = 0.0

betterfall.falling_queue = {}
betterfall.falling_queue.entries = {}
betterfall.falling_queue.first = 0
betterfall.falling_queue.last = -1

function betterfall.falling_queue.enqueue(entry)
    local new_last_index = betterfall.falling_queue.last + 1;
    betterfall.falling_queue.last = new_last_index;
    betterfall.falling_queue.entries[new_last_index] = entry
end

function betterfall.falling_queue.dequeue()
    if betterfall.falling_queue.first > betterfall.falling_queue.last then
        return nil
    end

    local first_index = betterfall.falling_queue.first
    local entry = betterfall.falling_queue.entries[first_index]
    betterfall.falling_queue.entries[first_index] = nil
    betterfall.falling_queue.first = first_index + 1

    return entry
end

function betterfall.enqueue_falling_node(p, n, m)
    local entry = {
        pos = p,
        node = n,
        meta = m
    }

    betterfall.falling_queue.enqueue(entry)
end

local function convert_to_falling_node(pos, node)
    if betterfall.ghost_nodes[node.name] == nil then
        local obj = core.add_entity(pos, "__builtin:falling_node")
        if not obj then
            return false
        end
        node.level = core.get_node_level(pos)
        local meta = core.get_meta(pos)
        local metatable = meta and meta:to_table() or {}

        obj:get_luaentity():set_node(node, metatable)
    end

    core.remove_node(pos)
    minetest.check_for_falling(pos)
    return true
end

minetest.register_globalstep(function(dtime)
    betterfall.next_fall_time = betterfall.next_fall_time + dtime

    if betterfall.next_fall_time >= betterfall.falling_timer then
        betterfall.next_fall_time = 0.0
        local node_entry = betterfall.falling_queue.dequeue()

        if node_entry then
            if node_entry.node.name ~= "air" and minetest.get_node(node_entry.pos).name == node_entry.node.name then
                local result = betterfall.should_node_fall(node_entry.node, node_entry.pos)

                node_entry.meta:set_int("falling", 0)

                if result then
                    convert_to_falling_node(node_entry.pos, node_entry.node)
                end
            end
        end
    end
end)
