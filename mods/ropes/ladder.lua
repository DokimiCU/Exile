----------------------------------------
local function ladder_place(pos, placer,length)
	local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
	local node_below = minetest.get_node(pos_below)
	local this_node = minetest.get_node(pos)
	local placer_name = placer:get_player_name()
	-- param2 holds the facing direction of this node. If it's 0 or 1 the node is "flat" and we don't want the ladder to extend.
	if node_below.name == "air" and this_node.param2 > 1
		and (not minetest.is_protected(pos_below, placer_name)
		or minetest.check_player_privs(placer_name, "protection_bypass")) then
		minetest.add_node(pos_below, {name="ropes:ropeladder_bottom", param2=this_node.param2})
		local meta = minetest.get_meta(pos_below)
		meta:set_int("length_remaining", length)
		meta:set_string("placer", placer_name)
	end

end


--------------------------------------

local rope_ladder_top_def = {
	description = "Rope Ladder",
	drawtype = "signlike",
	tiles = {"ropes_ropeladder_top.png"},
	is_ground_content = false,
	inventory_image = "ropes_ropeladder_top.png",
	wield_image = "ropes_ropeladder_top.png",
	stack_max = minimal.stack_max_medium,
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		wall_side = {-0.5,-0.4,-0.4,-0.4,0.4,0.4},
		--wall_side = = <default>

	},
	groups = { choppy=2, oddly_breakable_by_hand=1,flammable=1},
	sounds = nodes_nature.node_sound_wood_defaults(),

	after_place_node = function(pos, placer)
		ladder_place(pos, placer, ropes.ropeLadderLength)
	end,
	after_destruct = function(pos)
		local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
		ropes.destroy_rope(pos_below, {"ropes:ropeladder", "ropes:ropeladder_bottom", "ropes:ropeladder_falling"})
	end,
}

if ropes.ropeLadderLength == 0 then
	rope_ladder_top_def.groups.not_in_creative_inventory = 1
end

minetest.register_node("ropes:ropeladder_top", rope_ladder_top_def)

minetest.register_node("ropes:ropeladder", {
	description = "Rope Ladder",
	drop = "",
	drawtype = "signlike",
	tiles = {"ropes_ropeladder.png"},
	is_ground_content = false,
	inventory_image = "ropes_ropeladder.png",
	wield_image = "ropes_ropeladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		wall_side = {-0.5,-0.4,-0.4,-0.4,0.4,0.4},
		--wall_side = = <default>
	},
	groups = {choppy=2, flammable=1, not_in_creative_inventory=1},
	sounds = nodes_nature.node_sound_wood_defaults(),

	after_destruct = function(pos)
		ropes.hanging_after_destruct(pos, "ropes:ropeladder_falling", "ropes:ropeladder", "ropes:ropeladder_bottom")
	end,
})

local ladder_extender = ropes.make_rope_on_timer("ropes:ropeladder")

minetest.register_node("ropes:ropeladder_bottom", {
	description = "Rope Ladder",
	drop = "",
	drawtype = "signlike",
	tiles = {"ropes_ropeladder_bottom.png"},
	is_ground_content = false,
	inventory_image = "ropes_ropeladder_bottom.png",
	wield_image = "ropes_ropeladder_bottom.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		wall_side = {-0.5,-0.4,-0.4,-0.4,0.4,0.4},
		--wall_side = = <default>

	},
	groups = {choppy=2, flammable=1, not_in_creative_inventory=1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_construct = function( pos )
		local timer = minetest.get_node_timer( pos )
		timer:start( 1 )
	end,
	on_timer = ladder_extender,

	after_destruct = function(pos)
		ropes.hanging_after_destruct(pos, "ropes:ropeladder_falling", "ropes:ropeladder", "ropes:ropeladder_bottom")
	end,
})

minetest.register_node("ropes:ropeladder_falling", {
	description = "Rope Ladder",
	drop = "",
	drawtype = "signlike",
	tiles = {"ropes_ropeladder.png"},
	is_ground_content = false,
	inventory_image = "ropes_ropeladder.png",
	wield_image = "ropes_ropeladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>

	},
	groups = {flammable=1, not_in_creative_inventory=1},
	sounds = nodes_nature.node_sound_wood_defaults(),
	on_construct = function( pos )
		local timer = minetest.get_node_timer( pos )
		timer:start( 1 )
	end,
	on_timer = function( pos, elapsed )
		local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
		local node_below = minetest.get_node(pos_below)

		if (node_below.name ~= "ignore") then
			ropes.destroy_rope(pos_below, {'ropes:ropeladder', 'ropes:ropeladder_bottom', 'ropes:ropeladder_falling'})
			minetest.swap_node(pos, {name="air"})
		else
			local timer = minetest.get_node_timer( pos )
			timer:start( 1 )
		end
	end
})
