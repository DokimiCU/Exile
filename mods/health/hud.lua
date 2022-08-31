----------------------------------------------------------------------
--HUD
----------------------------------------------------------------------

-- Internationalization
local S = HEALTH.S

local hud = {}
local overlaid = {}
local barstate = {}
local hudupdateseconds = tonumber(minetest.settings:get("exile_hud_update"))
-- global setting for whether to show stats
local mtshowstats = minetest.settings:get_bool("exile_hud_show_stats") or true
local mthudopacity = minetest.settings:get("exile_hud_icon_transparency") or 127

local hud_scale = minetest.settings:get("gui_scaling") or 1

-- These are color values for the various status levels. They have to be modified
-- per-function below because textures expect one color format and text another.
-- This is a minetest caveat.

-- In texture coloring we simply concat a #.
--		"#"..stat_color

-- In text coloring we concat an 0x and convert the resulting string to a number.
--		tostring("0x"..stat_color)

local stat_fine 	= "FFFFFF"
local stat_slight 	= "FDFF46"
local stat_problem 	= "FF8100"
local stat_major 	= "DF0000"
local stat_extreme	= "8008FF"

local hud_vert_pos	= -128 * hud_scale -- all HUD icon vertical position
local hud_extra_y	= -16 * hud_scale  -- pixel offset for hot/cold icons
local hud_text_y	= 32 * hud_scale   -- optional text stat offset

local hud_tier_offset	= 80 * hud_scale  -- add to y offset of stacked icons
local hud_lb_x		= 0 * hud_scale

local hud_health_x	= -300 * hud_scale
local hud_hunger_x	= -300 * hud_scale
local hud_thirst_x	= -64 * hud_scale
local hud_energy_x	= 0
local hud_air_temp_x 	= 64 * hud_scale
local hud_sick_x 	= 300 * hud_scale
local hud_body_temp_x	= 300 * hud_scale

local icon_scale = {x = hud_scale, y = hud_scale}  -- all HUD icon image scale

local function tobool(str)
   if str == "true" then
      return true
   end
   return false
end

local setup_hud = function(player)

	player:hud_set_flags({healthbar = false})
	local playername = player:get_player_name()

	local meta = player:get_meta()
	barstate[playername] = {}
	local show_stats = meta:get("exile_hud_show_stats")
	if show_stats then
	   if tobool(show_stats) == true then
	      barstate[playername].showstats = true
	   elseif tobool(show_stats) == false then
	      barstate[playername].showstats = false
	   end
	end

	local hud_opacity = meta:get("exile_hud_icon_transparency")
	if hud_opacity then
	   barstate[playername].hudopacity = tonumber(hud_opacity)
	else
	   hud_opacity = mthudopacity
	end
	local hud_longbar = meta:get_string("hud16")
	if hud_longbar then
	   barstate[playername].longbar = true
	end

	local hud_data = {}

	hud[playername] = hud_data
	hud_data.p_health = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_health_x - hud_lb_x, y = hud_vert_pos + hud_tier_offset},
		position = {x = .5, y = 1},
	    text = "hud_health.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity
	})

	hud_data.p_hunger = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_hunger_x, y = hud_vert_pos},
		position = {x = .5, y = 1},
	    text = "hud_hunger.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity
	})

	hud_data.p_thirst = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_thirst_x, y = hud_vert_pos},
		position = {x = .5, y = 1},
	    text = "hud_thirst.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity
	})

	hud_data.p_energy = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_energy_x, y = hud_vert_pos},
		position = {x = .5, y = 1},
	    text = "hud_energy.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity
	})

	hud_data.p_body_temp = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_body_temp_x, y = hud_vert_pos},
		position = {x = .5, y = 1},
	    text = "hud_body_temp.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity
	})

	hud_data.p_body_temp_type = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_body_temp_x, y = hud_vert_pos + hud_extra_y},
		position = {x = .5, y = 1},
	    text = "hud_temp_normal.png^[opacity:"..hud_opacity -- don't colorize
	})

	hud_data.p_air_temp = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_air_temp_x, y = hud_vert_pos},
		position = {x = .5, y = 1},
	    text = "hud_air_temp.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity

	})

	hud_data.p_air_temp_type = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_air_temp_x, y = hud_vert_pos + hud_extra_y},
		position = {x = .5, y = 1},
	    text = "hud_temp_normal.png^[opacity:"..hud_opacity -- don't colorize

	})

	hud_data.p_sick = player:hud_add({
		hud_elem_type = "image",
		scale = icon_scale,
		offset = {x = hud_sick_x + hud_lb_x, y = hud_vert_pos + hud_tier_offset},
		position = {x = .5, y = 1},
	    text = "hud_sick.png^[colorize:#"..stat_fine.."^[opacity:"..hud_opacity
	})


	hud_data.p_health_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_health_x + hud_lb_x, y = hud_vert_pos + hud_text_y + hud_tier_offset},
		position = {x = .5, y = 1},
		text = ""
	})

	hud_data.p_hunger_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_hunger_x - hud_lb_x, y = hud_vert_pos + hud_text_y},
		position = {x = .5, y = 1},
		text = ""
	})

	hud_data.p_thirst_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_thirst_x, y = hud_vert_pos + hud_text_y},
		position = {x = .5, y = 1},
		text = ""
	})

	hud_data.p_energy_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_energy_x, y = hud_vert_pos + hud_text_y},
		position = {x = .5, y = 1},
		text = ""
	})

	hud_data.p_body_temp_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_body_temp_x + hud_lb_x, y = hud_vert_pos + hud_text_y},
		position = {x = .5, y = 1},
		text = ""
	})

	hud_data.p_air_temp_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_air_temp_x, y = hud_vert_pos + hud_text_y},
		position = {x = .5, y = 1},
		text = ""

	})

	hud_data.p_sick_text = player:hud_add({
		hud_elem_type = "text",
		offset = {x = hud_sick_x, y = hud_vert_pos + hud_text_y + hud_tier_offset},
		position = {x = .5, y = 1},
		text = ""
	})

end

minetest.register_on_joinplayer(function(player) setup_hud(player) end)

-- status indicator colors for use in stat display option

local function color(v)
	local stat_col = stat_fine
	if v <= 20 then
		stat_col = stat_extreme
	elseif v <= 40 then
		stat_col = stat_major
	elseif v <= 60 then
		stat_col = stat_problem
	elseif v <= 80 then
		stat_col = stat_slight
	end
	return stat_col
end

local function color_bodytemp(v)
	local stat_col = stat_fine
	local ttype = "hud_temp_normal"
	if v > 47 or v < 27 then
		stat_col = stat_extreme
		if v > 47 then ttype = "hud_temp_hot" end
		if v < 27 then ttype = "hud_temp_cold" end
	elseif v > 43 or v < 32 then
		stat_col = stat_major
		if v > 43 then ttype = "hud_temp_hot" end
		if v < 32 then ttype = "hud_temp_cold" end
	elseif v > 38 or v < 37 then
		stat_col = stat_problem
		if v > 38 then ttype = "hud_temp_hot" end
		if v < 37 then ttype = "hud_temp_cold" end
	end
	return stat_col, ttype
end

local function color_envirotemp(v, meta)
	--make sure matches actual values used!
	local comfort_low = meta:get_int("clothing_temp_min")
	local comfort_high = meta:get_int("clothing_temp_max")
	local stress_low = comfort_low - 10
	local stress_high = comfort_high + 10
	local danger_low = stress_low - 40
	local danger_high = stress_high +40
	local overlay

	local stat_col = stat_fine
	local ttype = "hud_temp_normal"

	if v > danger_high or v < danger_low then
		stat_col = stat_extreme
		if v > danger_high then ttype = "hud_temp_hot" end
		if v < danger_low then ttype = "hud_temp_cold" end
	elseif v > stress_high or v < stress_low then
		stat_col = stat_major
		if v > stress_high then ttype = "hud_temp_hot" end
		if v < stress_low then ttype = "hud_temp_cold" end
	elseif v > comfort_high or v < comfort_low then
		stat_col = stat_slight
		if v > comfort_high then ttype = "hud_temp_hot" end
		if v < comfort_low then ttype = "hud_temp_cold" end
	end
	if v < stress_low then
	   overlay = "weather_hud_frost.png"
	end
	if v > stress_high then
	   overlay = "weather_hud_heat.png"
	end

	return stat_col, ttype, overlay
end

local function health(player, hud_data, stats, opac)
	local v = player:get_hp()
	v = (v/20)*100
	local stat_col = color(v)
	local t = v .." %"
	local hud1 = hud_data.p_health
	player:hud_change(hud1, "text", "hud_health.png^[colorize:#"..stat_col.."^[opacity:"..opac)

	local hud2 = hud_data.p_health_text
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end

local function energy(player, hud_data, meta, stats, opac)
	local v = meta:get_int("energy")
	v = (v/1000)*100
	local stat_col = color(v)
	local t = v .." %"
	local hud1 = hud_data.p_energy
	player:hud_change(hud1, "text", "hud_energy.png^[colorize:#"..stat_col.."^[opacity:"..opac)
	local hud2 = hud_data.p_energy_text
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end

local function thirst(player, hud_data, meta, stats, opac)
	local v = meta:get_int("thirst")
	v = (v/100)*100
	local t = v .." %"
	local stat_col = color(v)
	local hud1 =  hud_data.p_thirst
	player:hud_change(hud1, "text", "hud_thirst.png^[colorize:#"..stat_col.."^[opacity:"..opac)
	local hud2 = hud_data.p_thirst_text
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end

local function hunger(player, hud_data, meta, stats, opac)
	local v = meta:get_int("hunger")
	v = (v/1000)*100
	local t = v .." %"
	local stat_col = color(v)
	local hud1 =  hud_data.p_hunger
	player:hud_change(hud1, "text", "hud_hunger.png^[colorize:#"..stat_col.."^[opacity:"..opac)
	local hud2 = hud_data.p_hunger_text
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end


local function temp(player, hud_data, meta, stats, opac)
	local v = meta:get_int("temperature")
	local stat_col, ttype = color_bodytemp(v)
	local t = climate.get_temp_string(v, meta)
	local hud1 = hud_data.p_body_temp
	player:hud_change(hud1, "text", "hud_body_temp.png^[colorize:#"..stat_col.."^[opacity:"..opac)
	local hud2 = hud_data.p_body_temp_text
	player:hud_change(hud2, "text", ttype..".png^[opacity:"..opac) -- don't colorize)
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end

local function do_overlay(player, pname, pos, overlay)
   local handle = player:hud_add({
	 name = overlay,
	 hud_elem_type = "image",
	 position = {x = 0, y = 0},
	 alignment = {x = 1, y = 1},
	 scale = { x = -100, y = -100},
	 z_index = hud.z_index,
	 text = overlay,
	 offset = {x = 0, y = 0}
   })
   overlaid[pname] = handle
end


local function enviro_temp(player, hud_data, meta, stats,
			   opac)
	local pname = player:get_player_name()
	local player_pos = player:get_pos()
	player_pos.y = player_pos.y + 0.6 --adjust to body height
	local v = math.floor(climate.get_point_temp(player_pos))
	local stat_col, ttype, overlay = color_envirotemp(v, meta)
	if overlay then
	   if not overlaid[pname] then
	      do_overlay(player, pname, player_pos, overlay)
	   elseif player:hud_get(overlaid[pname]) and
	      ( overlay ~= player:hud_get(overlaid[pname]).name ) then
	      -- direct transition from one overlay to another
	      player:hud_remove(overlaid[pname])
	      do_overlay(player, pname, player_pos, overlay)
	   end
	elseif overlaid[pname] then -- remove overlay
	   player:hud_remove(overlaid[pname])
	   overlaid[pname] = nil
	end
	local t = climate.get_temp_string(v, meta)
	local newhud = hud_data.p_air_temp
	local newhud2 = hud_data.p_air_temp_type
	player:hud_change(newhud, "text", "hud_air_temp.png^[colorize:#"..stat_col.."^[opacity:"..opac)
	player:hud_change(newhud2, "text", ttype..".png^[opacity:"..opac) -- don't colorize)
	local hud2 = hud_data.p_air_temp_text
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end

local function effects(player, hud_data, meta, stats, opac)
	local stat_col = stat_fine
	local v = meta:get_int("effects_num")
	local t = "x"..v
	if v > 0 then
		stat_col = stat_slight
	elseif v > 1 then
		stat_col = stat_problem
	elseif v > 2 then
		stat_col = stat_major
	elseif v > 3 then
		stat_col = stat_extreme
	end
	local hud1 = hud_data.p_sick
	player:hud_change(hud1, "text", "hud_sick.png^[colorize:#"..stat_col.."^[opacity:"..opac)
	local hud2 = hud_data.p_sick_text
	player:hud_change(hud2, "number", tonumber("0x"..stat_col))
	if stats then
		player:hud_change(hud2, "text", t)
	else
		player:hud_change(hud2, "text", "")
	end
end

local timer = 0

minetest.register_globalstep(function(dtime)
  timer = timer + dtime

  if timer > hudupdateseconds then
   for _0, player in ipairs(minetest.get_connected_players()) do

		local name = player:get_player_name()
		local meta = player:get_meta()
		local hud_data = hud[name]
		if not hud_data then
			return
		end
		local stats = mtshowstats
		if barstate[name].showstats ~= nil then
		   stats = barstate[name].showstats
		end
		local opac = mthudopacity
		if barstate[name].hudopacity ~= nil then
		   opac = barstate[name].hudopacity
		end
		health(player, hud_data, stats, opac)
		energy(player, hud_data, meta, stats, opac)
		thirst(player, hud_data, meta, stats, opac)
		hunger(player, hud_data, meta, stats, opac)
		temp(player, hud_data, meta, stats, opac)
		enviro_temp(player, hud_data, meta, stats,
			    opac)
		effects(player, hud_data, meta, stats, opac)

		if barstate[name].longbar then
			hud_lb_x = 64 * hud_scale
			hud_tier_offset = 0
		else
			hud_lb_x = 0
			hud_tier_offset	= 80 * hud_scale
		end

		player:hud_change(hud_data.p_health, "offset", {x = hud_health_x - hud_lb_x, y = hud_vert_pos + hud_tier_offset})
		player:hud_change(hud_data.p_health_text, "offset",
			{x = hud_health_x - hud_lb_x,
			 y = hud_vert_pos + hud_text_y + hud_tier_offset})
		player:hud_change(hud_data.p_sick, "offset",
			{x = hud_body_temp_x + hud_lb_x,
			 y = hud_vert_pos + hud_tier_offset})
		player:hud_change(hud_data.p_sick_text, "offset",
			{x = hud_body_temp_x + hud_lb_x,
			 y = hud_vert_pos + hud_text_y + hud_tier_offset})
   end
   timer = 0
   return nil
  end
end)

minetest.register_chatcommand("show_stats", {
	params = S("help"),
	description = S("Enable or disable stats showing below icons. "..
			"Pass 'clear' as a parameter to revert to defaults."),
    func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local meta = player:get_meta()
		if param == "help" then
		   local wlist = S("/show_stats:\n"..
		      "Toggle stats showing below icons. Use '/show_stats "..
		      "clear' to revert to defaults")
		   return false, wlist
		elseif param == "clear" then
		   meta:set_string("exile_hud_show_stats", "")
		   barstate[name].showstats = nil
		   return true, S("Cleared setting")
		else
		   local show_stats = meta:get("exile_hud_show_stats")
		   if not show_stats then
		      show_stats = tostring(mtshowstats)
		   end
		   local newval = not tobool(show_stats)
		   meta:set_string("exile_hud_show_stats", tostring(newval))
		   barstate[name].showstats = newval
		   if newval == true then
		      return true, S("Enabled stats.")
		   else
		      return true, S("Disabled stats.")
		   end
		end
	end
})

minetest.register_chatcommand("icon_transparency", {
    params = "<int>",
    description = S("Set stat icon transparency between 0 and 255 or "..
		    "default ").."("..mthudopacity..")",
    func = function(name, param)
       local player = minetest.get_player_by_name(name)
       local meta = player:get_meta()
       if param == "" or param == "help" then
	  local wlist = S("/show_stats:\n"..
			  "Set stat icon transparency between 0 and 255.\n"..
			  "Valid value is an integer between 0 and 255 or default.\n")
	  return false, wlist
       end
       if param == "default" then
	  meta:set_string("exile_hud_icon_transparency", "")
	  barstate[name].hudopacity = nil
	  return true, S("Returned setting to default")
       else
	  local num = tonumber(param)
	  if type(num) == "number" then
	     if num < 0 then
		meta:set_string("exile_hud_icon_transparency", "0")
		barstate[name].hudopacity = 0
		return false, S("Icon transparency set to 0")
	     elseif num > 255 then
		meta:set_string("exile_hud_icon_transparency", "255")
		barstate[name].hudopacity = 255
		return false, S("Icon transparency set to 255")
	     else
		meta:set_string("exile_hud_icon_transparency", tostring(math.floor(num)))
		barstate[name].hudopacity = num
		return false, S("Icon transparency set to ")..math.floor(num)
	     end
	  else
	     return false, S("Invalid value. Please use a whole number between 0 and 255")
	  end
       end
    end
})
