------------------------------------
--ART & TOYS & WHATEVER...
--statues etc
--this is for things that are purely fun but don't add much to survival/power
--spreads out higher value finds
------------------------------------




------------------------------------
--MOON GLASS SCULPTURES
------------------------------------

--axeman (a warrior)
minetest.register_node("artifacts:mg_sculpture_axeman", {
	description = "Moon Glass Sculpture",
	tiles = {"artifacts_moon_glass.png"},
	--tiles = {"artifacts_antiquorium.png"},
  stack_max = minimal.stack_max_bulky *2,
  light_source = 5,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, -- NodeBox1
			{-0.375, -0.4375, -0.375, 0.375, -0.375, 0.375}, -- NodeBox3
			{-0.1875, -0.375, 0, 0, -0.0625, 0.125}, -- NodeBox4
			{-0.1875, -0.0625, -0.0625, 0.1875, 0.25, 0.0625}, -- NodeBox5
			{-0.125, 0.25, -0.0625, 0.1875, 0.4375, 0.125}, -- NodeBox6
			{0.1875, -0.0625, 0, 0.25, 0.1875, 0.125}, -- NodeBox7
			{-0.25, -0.0625, -0.125, -0.1875, 0.1875, 0}, -- NodeBox8
			{0, -0.375, -0.125, 0.1875, -0.0625, 7.45058e-009}, -- NodeBox9
			{0, 0.4375, -0.1875, 0.125, 0.5, 0.1875}, -- NodeBox10
			{-0.125, -0.0625, -0.125, 0.125, 0.1875, -0.0625}, -- NodeBox11
			{-0.0625, -0.0625, 0.0625, 0.1875, 0.1875, 0.125}, -- NodeBox12
			{-0.25, -0.3125, -0.25, -0.1875, 0.375, -0.1875}, -- NodeBox13
			{-0.25, -0.0625, -0.1875, -0.1875, 2.04891e-008, -0.125}, -- NodeBox14
			{0.1875, -0.125, 0, 0.25, -0.0625, 0.0625}, -- NodeBox15
			{-0.0625, 0.375, -0.125, 0.125, 0.4375, -0.0625}, -- NodeBox16
			{-0.0625, 0.25, -0.125, 0.125, 0.3125, -0.0625}, -- NodeBox17
			{0, 0.1875, 0.125, 0.125, 0.4375, 0.1875}, -- NodeBox18
			{0.25, -0.25, -0.1875, 0.3125, 0.25, 0.1875}, -- NodeBox19
			{0.25, -0.3125, -0.125, 0.3125, -0.25, 0.125}, -- NodeBox21
			{0.25, 0.25, -0.125, 0.3125, 0.3125, 0.125}, -- NodeBox22
			{0.25, -0.1875, -0.25, 0.3125, 0.1875, -0.1875}, -- NodeBox23
			{0.25, -0.1875, 0.1875, 0.3125, 0.1875, 0.25}, -- NodeBox24
			{-0.25, 0.25, -0.375, -0.1875, 0.375, -0.25}, -- NodeBox25
			{-0.25, 0.1875, -0.4375, -0.1875, 0.375, -0.375}, -- NodeBox26
			{0.3125, -0.0625, -0.0625, 0.375, 0.0625, 0.0625}, -- NodeBox27
		}
	},
	sunlight_propagates = true,
  --use_texture_alpha = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 3, temp_pass = 1},
})


--dancers (two figures dancing)
minetest.register_node("artifacts:mg_sculpture_dancers", {
	description = "Moon Glass Sculpture",
	tiles = {"artifacts_moon_glass.png"},
	--tiles = {"artifacts_antiquorium.png"},
  stack_max = minimal.stack_max_bulky *2,
  light_source = 5,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{0.1875, -0.375, -0.25, 0.25, -0.125, -0.1875}, -- NodeBox73
			{0.0625, -0.25, -0.25, 0.125, -0.125, -0.1875}, -- NodeBox79
			{0.0625, -0.3125, -0.3125, 0.125, -0.25, -0.1875}, -- NodeBox80
			{0.0625, -0.125, -0.25, 0.25, 0, -0.1875}, -- NodeBox81
			{0.125, 0, -0.25, 0.1875, 0.0625, -0.1875}, -- NodeBox83
			{0.0625, 0.0625, -0.25, 0.25, 0.1875, -0.1875}, -- NodeBox84
			{0.25, 0, -0.3125, 0.3125, 0.1875, -0.25}, -- NodeBox85
			{0, 0.0625, -0.1875, 0.0625, 0.1875, -0.125}, -- NodeBox86
			{0, 0.0625, -0.125, 0.0625, 0.125, -0.0625}, -- NodeBox87
			{0.125, 0.1875, -0.25, 0.1875, 0.25, -0.1875}, -- NodeBox88
			{0.0625, 0.25, -0.25, 0.1875, 0.375, -0.1875}, -- head
			{-0.1875, 0.3125, 0.25, -0.0625, 0.4375, 0.3125}, -- NodeBox90
			{-0.1875, 0.25, 0.25, -0.125, 0.3125, 0.3125}, -- NodeBox91
			{-0.25, 0, 0.25, -0.0625, 0.25, 0.3125}, -- NodeBox92
			{-0.0625, 0.1875, 0.0625, 0, 0.25, 0.25}, -- NodeBox93
			{-0.3125, 0.125, 0.3125, -0.25, 0.25, 0.375}, -- NodeBox94
			{-0.3125, 0.0625, 0.25, -0.25, 0.125, 0.3125}, -- NodeBox95
			{-0.3125, -0.125, 0.25, -0.125, -2.6077e-008, 0.3125}, -- NodeBox96
			{-0.3125, -0.375, 0.25, -0.25, -0.125, 0.3125}, -- NodeBox97
			{-0.1875, -0.25, 0.25, -0.125, -0.125, 0.3125}, -- NodeBox98
			{-0.1875, -0.25, 0.3125, -0.125, -0.1875, 0.4375}, -- NodeBox99
			{-0.375, -0.5, -0.375, 0.375, -0.375, 0.375}, -- NodeBox100
			{0.375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125}, -- NodeBox101
			{-0.4375, -0.5, -0.3125, -0.375, -0.4375, 0.3125}, -- NodeBox102
			{-0.3125, -0.5, -0.4375, 0.3125, -0.4375, -0.375}, -- NodeBox103
			{-0.3125, -0.5, 0.375, 0.3125, -0.4375, 0.4375}, -- NodeBox104
		}
	},
	sunlight_propagates = true,
  --use_texture_alpha = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 3, temp_pass = 1},
})


--bonsai
minetest.register_node("artifacts:mg_sculpture_bonsai", {
	description = "Moon Glass Sculpture",
	tiles = {"artifacts_moon_glass.png"},
	--tiles = {"artifacts_antiquorium.png"},
  stack_max = minimal.stack_max_bulky *2,
  light_source = 5,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.4375, -0.0625, 0.0625, -0.3125, 0.0625}, -- NodeBox1
			{-0.0625, -0.3125, -0.0625, 0, 0.25, -3.72529e-009}, -- NodeBox2
			{-0.0625, -0.3125, 0, 0, 0.375, 0.0625}, -- NodeBox3
			{0, -0.3125, 0, 0.0625, 0, 0.0625}, -- NodeBox4
			{0, -0.3125, -0.0625, 0.0625, -0.1875, -7.45058e-009}, -- NodeBox5
			{0.0625, -0.4375, 0.0625, 0.125, -0.3125, 0.125}, -- NodeBox6
			{-0.125, -0.4375, -0.125, -0.0625, -0.3125, -0.0625}, -- NodeBox7
			{0.0625, -0.4375, -0.125, 0.125, -0.375, -0.0625}, -- NodeBox8
			{-0.125, -0.4375, 0.0625, -0.0625, -0.375, 0.125}, -- NodeBox9
			{-0.3125, -0.4375, 0.125, -0.125, -0.375, 0.1875}, -- NodeBox10
			{0.125, -0.4375, -0.1875, 0.3125, -0.375, -0.125}, -- NodeBox11
			{-0.1875, -0.4375, -0.3125, -0.125, -0.375, -0.125}, -- NodeBox12
			{0.125, -0.4375, 0.125, 0.1875, -0.375, 0.3125}, -- NodeBox13
			{0.1875, -0.4375, 0.3125, 0.375, -0.375, 0.375}, -- NodeBox14
			{-0.375, -0.4375, -0.375, -0.1875, -0.375, -0.3125}, -- NodeBox15
			{-0.375, -0.4375, 0.1875, -0.3125, -0.375, 0.3125}, -- NodeBox16
			{0.3125, -0.4375, -0.3125, 0.375, -0.375, -0.1875}, -- NodeBox17
			{0.0625, -0.1875, 0, 0.125, -0.125, 0.0625001}, -- NodeBox18
			{0.125, -0.125, -0.0625, 0.1875, -0.0625, 1.15484e-007}, -- NodeBox20
			{0.1875, -0.0625, -0.125, 0.25, -1.67638e-008, -0.0624999}, -- NodeBox21
			{-0.125, 0.0625, 0.0625, -0.0625001, 0.125, 0.125}, -- NodeBox22
			{-0.1875, 0.125, 0.0625, -0.125, 0.1875, 0.125}, -- NodeBox23
			{-0.25, 0.1875, 0.125, -0.1875, 0.25, 0.1875}, -- NodeBox24
			{0, -0.1875, 0.0625, 0.0624999, -0.0625, 0.125}, -- NodeBox25
			{0.0625, -0.0625, 0.125, 0.125, 0.0625, 0.1875}, -- NodeBox26
			{0.125, 0.0625, 0.1875, 0.1875, 0.125, 0.25}, -- NodeBox27
			{-0.125, -0.125, -0.125, -0.0625001, -0.0625, -0.0624999}, -- NodeBox28
			{-0.1875, -0.0625, -0.1875, -0.125, 1.67638e-008, -0.125}, -- NodeBox29
			{-0.25, 0, -0.3125, -0.0624999, 0.125, -0.125}, -- NodeBox30
			{-0.3125, 0.25, 0.0625, -0.125, 0.375, 0.25}, -- NodeBox31
			{0.0625, 0.125, 0.125, 0.25, 0.25, 0.3125}, -- NodeBox32
			{0.125, 0, -0.1875, 0.3125, 0.125, -5.96046e-008}, -- NodeBox33
			{-0.0625, 0.1875, -0.25, 0.125, 0.3125, -0.0625001}, -- NodeBox34
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375}, -- NodeBox35
			{0.375, -0.5, -0.3125, 0.4375, -0.375, 0.3125}, -- NodeBox36
			{-0.4375, -0.5, -0.3125, -0.375, -0.375, 0.3125}, -- NodeBox37
			{-0.3125, -0.5, -0.4375, 0.3125, -0.375, -0.375}, -- NodeBox38
			{-0.3125, -0.5, 0.375, 0.3125, -0.375, 0.4375}, -- NodeBox39
		}
	},
	sunlight_propagates = true,
  --use_texture_alpha = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 3, temp_pass = 1},
})




------------------------------------
--SINGING STONE
-- singing cellular automata
------------------------------------
minetest.register_node("artifacts:singing_stone", {
	description = "Singing Stone",
	tiles = {"artifacts_antiquorium.png^artifacts_moon_glass.png"},
  stack_max = minimal.stack_max_medium * 2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.4375, 0.5},
	},
  --light_source = 1,
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {oddly_breakable_by_hand = 3, attached_node = 1, temp_pass = 1},

	on_punch = function(pos, node, player)
		--hit to start "life"
		local p2 = minetest.get_node(pos).param2
		minetest.set_node(pos, {name = "artifacts:singing_stone_b", param2 = p2})
	end,

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,

	on_timer =function(pos, elapsed)
		--look on node nearby, turn on if neighbor is on
		local lnode = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, {"artifacts:singing_stone_b"})
		--local lnode = minetest.find_node_near(pos, 1, "artifacts:singing_stone_b")
		if #lnode > 1 then
			local p2 = minetest.get_node(pos).param2
			minetest.set_node(pos, {name = "artifacts:singing_stone_b", param2 = p2})
		else
			--no life, remains off
			return true
		end
	end,
})



minetest.register_node("artifacts:singing_stone_b", {
	description = "singing Stone",
	tiles = {"artifacts_sun_stone.png"},
  stack_max = minimal.stack_max_medium * 2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.4375, 0.5},
	},
	drop = "artifacts:singing_stone",
  --light_source = 3,
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {oddly_breakable_by_hand = 3, attached_node = 1, temp_pass = 1, not_in_creative_inventory = 1},

	on_punch = function(pos, node, player)
		--turn off
		local p2 = minetest.get_node(pos).param2
		minetest.set_node(pos, {name = "artifacts:singing_stone", param2 = p2})
	end,

	on_construct = function(pos)
		--sing, and start timer to turn off
		minetest.get_node_timer(pos):start(1)
		minetest.sound_play({name="artifacts_singing_stone"}, {pos = pos, gain = math.random(0.1,0.3), max_hear_distance = 8})
	end,

	on_timer =function(pos, elapsed)

		--go to resting state
		local p2 = minetest.get_node(pos).param2
		minetest.set_node(pos, {name = "artifacts:singing_stone_c", param2 = p2})
	end,
})


minetest.register_node("artifacts:singing_stone_c", {
	description = "singing Stone",
	tiles = {"artifacts_moon_glass.png"},
  stack_max = minimal.stack_max_medium * 2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.4375, 0.5},
	},
	drop = "artifacts:singing_stone",
  --light_source = 3,
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {oddly_breakable_by_hand = 3, attached_node = 1, temp_pass = 1, not_in_creative_inventory = 1},

	on_construct = function(pos)
		--start timer to turn off
		minetest.get_node_timer(pos):start(0.5)
	end,

	on_timer =function(pos, elapsed)
		--return to off
		local p2 = minetest.get_node(pos).param2
		minetest.set_node(pos, {name = "artifacts:singing_stone", param2 = p2})
	end,
})


------------------------------------
--DRUMMING STONE
-- pulses and semi-synchronises
--can't do proper sync bc minetest auto syncs them on reload, defeating the purpose.
------------------------------------


minetest.register_node("artifacts:drumming_stone", {
	description = "Drumming Stone",
	tiles = {"artifacts_antiquorium.png"},
  stack_max = minimal.stack_max_medium * 2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.4375, 0.5},
	},
  --light_source = 1,
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {oddly_breakable_by_hand = 3, attached_node = 1, temp_pass = 1},

	on_construct = function(pos)
		minetest.sound_play({name="artifacts_drumming_stone"}, {pos = pos, gain = 0.2, max_hear_distance = 14})
		minetest.get_node_timer(pos):start(math.floor(math.random(1,2)))
	end,

	on_timer =function(pos, elapsed)

		--look nearby for a friend
		local r = 1
		local rpos = {x = pos.x + math.random(-r,r), y = pos.y + math.random(-r,r), z = pos.z + math.random(-r,r)}
		local lnode = minetest.get_node(rpos)

		if lnode == "artifacts:drumming_stone" then
			minetest.get_node_timer(pos):start(1)
			return true
		end

		local p2 = minetest.get_node(pos).param2
		minetest.set_node(pos, {name = "artifacts:drumming_stone_b", param2 = p2})

	end,
})



minetest.register_node("artifacts:drumming_stone_b", {
	description = "Drumming Stone",
	tiles = {"artifacts_antiquorium.png^artifacts_moon_glass.png"},
  stack_max = minimal.stack_max_medium * 2,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.4375, 0.5},
	},
	drop = "artifacts:drumming_stone",
  --light_source = 3,
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {oddly_breakable_by_hand = 3, attached_node = 1, temp_pass = 1, not_in_creative_inventory = 1},

	on_construct = function(pos)
		--minetest.get_node_timer(pos):start(math.random(1.4,1.6))
		minetest.get_node_timer(pos):start(0.5)
		minetest.sound_play({name="artifacts_drumming_stone"}, {pos = pos, gain = 0.4, max_hear_distance = 17})
	end,

	on_timer =function(pos, elapsed)

		--look nearby for a friend
		local r = 1
		local rpos = {x = pos.x + math.random(-r,r), y = pos.y + math.random(-r,r), z = pos.z + math.random(-r,r)}
		local lnode = minetest.get_node(rpos)

		if lnode == "artifacts:drumming_stone_b" then
			minetest.get_node_timer(pos):start(1)
			return true
		end

		local p2 = minetest.get_node(pos).param2
		minetest.set_node(pos, {name = "artifacts:drumming_stone", param2 = p2})
	end,
})
