minimal = {
	stack_max_bulky = 2,
	stack_max_medium = 24,
	stack_max_light = 288,
	--hand base abilities
	hand_punch_int = 0.8,
	hand_max_lvl = 1,
	hand_crac = 3.5,
	hand_chop = 1.5,
	hand_crum = 1.0,
	hand_snap = 0.5,
	hand_dmg = 1,

	t_scale2 = 3,
	t_scale1 = 6,

}

minimal.S = minetest.get_translator("minimal")
minimal.FS = function(...)
	return minetest.formspec_escape(minimal.S(...))
end

dofile(minetest.get_modpath('minimal')..'/item_names.lua')
dofile(minetest.get_modpath('minimal')..'/settingswarn.lua')
dofile(minetest.get_modpath('minimal')..'/aliases.lua')
dofile(minetest.get_modpath('minimal')..'/overrides.lua')
dofile(minetest.get_modpath('minimal')..'/protection.lua')
dofile(minetest.get_modpath('minimal')..'/utility.lua')

-- GUI related stuff

function minimal.set_hotbar(player,pref) 
	if pref == "true" then
		-- use wide hotbar
		player:hud_set_hotbar_image("gui_hotbar16.png")
		player:hud_set_hotbar_itemcount(16)
	else
		player:hud_set_hotbar_image("gui_hotbar.png")
		player:hud_set_hotbar_itemcount(8)
	end
end


minetest.register_chatcommand("hud16", {
	params = "true or false",
	description = "Toggle wide hud hotbar on or off for player",
	func = function(name, param)
	local player = minetest.get_player_by_name(name)
	local meta = player:get_meta()
	local hud16=meta:get_string("hud16") or minetest.settings:get("exile_hud_wide_hotbar") or "false"
	if param and param ~="" then
		local wlist = "/hud16:\n"..
		"Toggle wide HUD hotbar off or on for you."
		return false, wlist
	end
	if hud16 == "true" then
		hud16 = "false"
	else
		hud16 = "true"
	end
	meta:set_string("hud16", hud16)
	minimal.set_hotbar(player,hud16)
	end,
})


minetest.register_on_joinplayer(function(player)
	-- Set formspec prepend
	local formspec = [[
			bgcolor[#080808BB;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]]
	local name = player:get_player_name()
	local info = minetest.get_player_information(name)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)
	-- Set hotbar textures
	local meta = player:get_meta()
	local hud = meta:get_string("hud16") or minetest.settings:get('exile_hud_wide_hotbar') or 'false'
	minimal.set_hotbar(player,hud)
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
end)


--[[
function minimal.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end
]]

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


minetest.register_on_joinplayer(function(player)
      local p_name = player:get_player_name()
      --Custom small inventory
      minetest.get_inventory({type="player", name=p_name}):set_size("main", 16)
      --enable shadows if using minetest 5.6.0+
      local mt560 = false
      local version = minetest.get_version()
      local tabstr = string.split(version.string,".")
      local major = tabstr[1]
      local minor = tabstr[2]
      local patch = tabstr[3]
      minetest.log("action", "Running on version: "..version.project.." "..
		   major.."."..minor.."."..patch)
      if ( version.project == "Minetest" and
	   tonumber(major) == 5 and tonumber(minor) >= 6 )then
	 mt560 = true
      end
      if mt560 then
	 minetest.log("action", "MT5.6.0+, enabling shadows")
	 player:set_lighting({
	    shadows = { intensity = 0.33 }
      })

      end
end)

