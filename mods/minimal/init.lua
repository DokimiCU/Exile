minimal = {
	stack_max_bulky = 2,
	stack_max_medium = 24,
	stack_max_light = 288,
	--hand base abilities
	hand_punch_int = 0.9,
	hand_max_lvl = 1,
	hand_crac = 4.0,
	hand_chop = 2.0,
	hand_crum = 1.0,
	hand_snap = 0.5,
	hand_dmg = 1,

	t_scale2 = 3,
	t_scale1 = 6,

}


dofile(minetest.get_modpath('minimal')..'/item_names.lua')


-- GUI related stuff
minetest.register_on_joinplayer(function(player)
	player:set_formspec_prepend([[
			bgcolor[#080808BB;true]
			background[5,5;1,1;gui_formbg.png;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]])
end)



-- The hand
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	liquids_pointable = true,
	tool_capabilities = {
		full_punch_interval = minimal.hand_punch_int,
		max_drop_level = minimal.hand_max_lvl,
		groupcaps = {
			choppy = {times={[3]=minimal.hand_chop}, uses=0, maxlevel=minimal.hand_max_lvl},
			crumbly = {times={[3]=minimal.hand_crum}, uses=0, maxlevel=minimal.hand_max_lvl},
			snappy = {times={[3]=minimal.hand_snap}, uses=0, maxlevel=minimal.hand_max_lvl},
			oddly_breakable_by_hand = {times={[1]=minimal.hand_crum*minimal.t_scale1,[2]=minimal.hand_crum*minimal.t_scale2,[3]=minimal.hand_crum}, uses=0},
		},
		damage_groups = {fleshy=minimal.hand_dmg},
	}
})


--Custom small inventory
minetest.register_on_joinplayer(function(player)
	minetest.get_inventory({type="player", name=player:get_player_name()}):set_size("main", 16)
end
)
