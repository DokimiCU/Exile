
grafitti = {
    _palettes = {}
}

local g = grafitti
local _palette = {
    width = 8,
    items = {}
}

local _placers = {}

function get_part_pos(i, size)
    local row = (math.floor((i-1) / size.x))
    local col = i-1 - math.floor((i-1)/size.x)*size.x
    return {row=row, col=col}
end

function get_relative_node_pos(part_pos, center)
    return {x=part_pos.col-center.col, y=part_pos.row-center.row}
end

function is_main_node(node_pos)
    return node_pos.x == 0 and node_pos.y == 0
end

function get_node_name(name, node_pos)
    if is_main_node(node_pos) then return name end

    local x = node_pos.x < 0 and "m"..math.abs(node_pos.x) or node_pos.x
    local y = node_pos.y < 0 and "m"..math.abs(node_pos.y) or node_pos.y
    return name .."_".. x .."_".. y
end

function get_image_name(name, part_pos, part_size)
    return name .."^[sheet:".. part_size.x .."x".. part_size.y ..":".. part_pos.col ..",".. part_pos.row
end

function get_node_pos(pos, node_pos, param2)
    if param2 == 0 then
        return {x=pos.x+node_pos.x, y=pos.y, z=pos.z+node_pos.y}
    end

    if param2 == 1 then
        return {x=pos.x+node_pos.x, y=pos.y, z=pos.z-node_pos.y}
    end

    if param2 == 2 then
        return {x=pos.x, y=pos.y-node_pos.y, z=pos.z-node_pos.x}
    end

    if param2 == 3 then
        return {x=pos.x, y=pos.y-node_pos.y, z=pos.z+node_pos.x}
    end

    if param2 == 4 then
        return {x=pos.x+node_pos.x, y=pos.y-node_pos.y, z=pos.z}
    end

    if param2 == 5 then
        return {x=pos.x-node_pos.x, y=pos.y-node_pos.y, z=pos.z}
    end
end

function init_def_values(def)
    def = def or {}
    def.size = def.size or {x=1, y=1}
    def.center = def.center or {row=0, col=0}
    def.pointable = def.pointable or false
    return def
end

function g.register_grafitti(name, def)
    def = init_def_values(def)
    local parts_count = def.size and def.size.x*def.size.y or 1

    for i=1, parts_count, 1 do
        local part_pos = get_part_pos(i, def.size)
        local rel_node_pos = get_relative_node_pos(part_pos, def.center)
        local node_name = get_node_name(name, rel_node_pos)
        local image_name = parts_count == 1 and def.image
            or get_image_name(def.image, part_pos, def.size)

        minetest.register_node(node_name, {
            inventory_image = def.image,
            drawtype = "nodebox",
            tiles = { image_name },
            sunlight_propagates = true,
            light_source = def.light or 0,
            floodable = true,
	    use_texture_alpha = "clip",
            paramtype = "light",
            paramtype2 = "wallmounted",
            groups = {attached_node=1, not_in_creative_inventory=1, grafitti=1, temp_pass = 1},
            buildable_to = true,
            walkable = false,
            node_box = {
                type = "wallmounted",
                wall_top    = {-0.5, 0.49, -0.5, 0.5, 0.5, 0.5},
                wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.49, 0.5},
                wall_side   = {-0.5, -0.5, -0.5, -0.49, 0.5, 0.5},
            },
            pointable = def.pointable,
            legacy_wallmounted = true,
            drop = {},
            on_construct = function(pos)
                if parts_count == 1 or not is_main_node(rel_node_pos) then
                    return
                end

                local player_name = _placers[minetest.pos_to_string(pos)]
                local wallmounted = minetest.get_node(pos).param2

                for j=1, parts_count, 1 do
                    local _part_pos = get_part_pos(j, def.size)
                    local _rel_node_pos = get_relative_node_pos(_part_pos, def.center)

                    if not is_main_node(_rel_node_pos) then
                        local node_pos = get_node_pos(pos, _rel_node_pos, wallmounted)
                        local pos_under = vector.add(node_pos, minetest.wallmounted_to_dir(wallmounted))

                        if not minetest.is_protected(node_pos, player_name)
                        and not minetest.is_protected(pos_under, player_name)
                        then
                            local node_under = minetest.get_node(pos_under)
                            local node_under_def = core.registered_items[node_under.name]

                            if node_under_def and not node_under_def.buildable_to then
                                local _node_name = get_node_name(name, _rel_node_pos)
                                minetest.swap_node(vector.new(get_node_pos(pos, _rel_node_pos, wallmounted)), {
                                    name = _node_name,
                                    param2 = wallmounted
                                })
                            end
                        end
                    end
                end
            end,
            on_destruct = function(pos)
                if parts_count == 1 or not is_main_node(rel_node_pos) then
                    return
                end

                _placers[minetest.pos_to_string(pos)] = nil
            end
        })
    end

    table.insert(_palette.items, { name=name, image=def.image })
end

function g.set_palette_width(width)
    _palette.width = width
end

function g.palette_build(formspec_name)
    local formspec_cols = _palette.width
    local formspec_rows = math.ceil((#_palette.items+1)/formspec_cols)
    local formspec = "size[".. formspec_cols ..",".. formspec_rows .."]"

    for i=1,#_palette.items,1 do
        local name = _palette.items[i].name
        local image = _palette.items[i].image
        local row = math.ceil(i / formspec_cols)-1
        local col = i-1 - math.floor((i-1) / formspec_cols)*formspec_cols
        formspec = formspec .. "image_button_exit[".. col ..",".. row ..";1,1;".. image ..";".. name ..";]"
    end

    _palette.items = {}
    g._palettes[formspec_name] = formspec

    minetest.register_on_player_receive_fields(function(painter, formname, fields)
        if formname ~= formspec_name then return end

        for item,v in pairs(fields) do
            if core.registered_items[item] then
                local itemstack = painter:get_wielded_item()

                if not core.registered_items[itemstack:get_name()].groups.brush then return end

                local meta = itemstack:get_meta()
                meta:set_string("grafitti", item)
                painter:set_wielded_item(itemstack)
                return
            end
        end
    end)
end

function show_palette(painter, formspec_name)
    minetest.show_formspec(painter:get_player_name(), formspec_name, g._palettes[formspec_name])
end

function g.register_brush(brush_name, def)
    minetest.register_tool(brush_name, {
        description = def.description,
        inventory_image = def.inventory_image,
        wield_image = def.wield_image,
        groups = { brush=1 },

        on_place = function(itemstack, placer, pointed_thing)
            show_palette(placer, def.palette)
        end,

        on_secondary_use = function(itemstack, user, pointed_thing)
          show_palette(user, def.palette)
        end,

        on_use = function(itemstack, user, pointed_thing)
            local player_name = user:get_player_name()
            local meta = itemstack:get_meta()

            if pointed_thing.type ~= "node" then
                return nil
            end

            if minetest.is_protected(pointed_thing.above, player_name)
            or minetest.is_protected(pointed_thing.under, player_name)
            then
                return nil
            end

            local node_under = minetest.get_node(pointed_thing.under)
            local node_under_def = core.registered_items[node_under.name]
            if node_under_def and node_under_def.buildable_to then
                if node_under_def.groups.grafitti then
                    minetest.add_node(pointed_thing.under, {name = "air"})
                    minetest.sound_play("grafitti_scrape",	{pos = pointed_thing.above, max_hear_distance = 4, gain = 1})
                end
                return nil
            end

            local node_above = minetest.get_node(pointed_thing.above)
            local node_above_def = core.registered_items[node_above.name]
            if node_above_def and not node_above_def.buildable_to then
                return nil
            end

            if node_above_def.groups.grafitti then
                minetest.add_node(pointed_thing.above, {name = "air"})
                minetest.sound_play("grafitti_scrape",	{pos = pointed_thing.above, max_hear_distance = 4, gain = 1})
                return nil
            end

            if ( pointed_thing.type == "nothing" or
		 meta:get_string("grafitti") == "" ) then
                show_palette(user, def.palette)
                return nil
            end
	    
            _placers[minetest.pos_to_string(pointed_thing.above)] = player_name
            local dir = vector.direction(pointed_thing.above, pointed_thing.under)
            local wallmounted = minetest.dir_to_wallmounted(dir)
            minetest.add_node(pointed_thing.above, {name = meta:get_string("grafitti"), param2=wallmounted})
            minetest.sound_play("grafitti_paint",	{pos = pointed_thing.above, max_hear_distance = 4, gain = 1})

            itemstack:add_wear(65535/(2000-1))

            return itemstack
        end
    })

end
