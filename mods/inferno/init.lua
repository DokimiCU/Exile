--------------------------------
--Inferno

-- Global namespace for functions

inferno = {}

-- Internationalization
local S = minetest.get_translator("inferno")

-- 'Enable fire' setting

local fire_enabled = minetest.settings:get_bool("enable_fire")
if fire_enabled == nil then
	-- enable_fire setting not specified, check for disable_fire
	local fire_disabled = minetest.settings:get_bool("disable_fire")
	if fire_disabled == nil then
		-- Neither setting specified, check whether singleplayer
		fire_enabled = minetest.is_singleplayer()
	else
		fire_enabled = not fire_disabled
	end
end


--
-- Items
--

-- Flood flame function

local function flood_flame(pos, oldnode, newnode)
	-- Play flame extinguish sound if liquid is not an 'igniter'
	local nodedef = minetest.registered_items[newnode.name]
	if not (nodedef and nodedef.groups and
			nodedef.groups.igniter and nodedef.groups.igniter > 0) then
		minetest.sound_play("inferno_extinguish_flame",
			{pos = pos, max_hear_distance = 16, gain = 0.15})
	end
	-- Remove the flame
	return false
end

-- Flame nodes

local flame_def = {
	drawtype = "firelike",
	tiles = {
		{
			name = "inferno_basic_flame_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1
			},
		},
	},
	inventory_image = "inferno_basic_flame.png",
	paramtype = "light",
	light_source = 13,
	temp_effect = 50,
	temp_effect_max = 500,
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	floodable = true,
	damage_per_second = 4,
	groups = {igniter = 2, flames = 1, dig_immediate = 3,
		  not_in_creative_inventory = 1,
		  temp_effect = 1, temp_pass = 1},
	drop = "",

	on_timer = function(pos)
		local f = minetest.find_node_near(pos, 1, {"group:flammable"})
		if not f then
			minetest.remove_node(pos)
			return
		end
		--rain, water etc puts it out
		if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:puts_out_fire"}) then
			minetest.remove_node(pos)
			return
		end

		-- Restart timer
		return true
	end,

	on_construct = function(pos)
	   minetest.get_node_timer(pos):start(math.random(30, 60))
	end,

	on_flood = flood_flame,
}

minetest.register_node("inferno:hungry_flame", flame_def)
if not fire_enabled then
   flame_def.groups = {flames = 1, dig_immediate = 3,
		       not_in_creative_inventory = 1,
		       temp_effect = 1, temp_pass = 1}
end

minetest.register_node("inferno:basic_flame", flame_def)


--
-- Sound
--

local flame_sound = minetest.settings:get_bool("flame_sound")
if flame_sound == nil then
	-- Enable if no setting present
	flame_sound = true
end

if flame_sound then

	local handles = {}
	local timer = 0

	-- Parameters

	local radius = 8 -- Flame node search radius around player
	local cycle = 3 -- Cycle time for sound updates

	-- Update sound for player

	function inferno.update_player_sound(player)
		local player_name = player:get_player_name()
		-- Search for flame nodes in radius around player
		local ppos = player:get_pos()
		local areamin = vector.subtract(ppos, radius)
		local areamax = vector.add(ppos, radius)
		local fpos, num = minetest.find_nodes_in_area(
			areamin,
			areamax,
			{"group:flames"}
		)
		-- Total number of flames in radius
		local flames = (num["inferno:basic_flame"] or 0)
		flames = flames + (num["inferno:hungry_flame"] or 0)
		-- Stop previous sound
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
		-- If flames
		if flames > 0 then
			-- Find centre of flame positions
			local fposmid = fpos[1]
			-- If more than 1 flame
			if #fpos > 1 then
				local fposmin = areamax
				local fposmax = areamin
				for i = 1, #fpos do
					local fposi = fpos[i]
					if fposi.x > fposmax.x then
						fposmax.x = fposi.x
					end
					if fposi.y > fposmax.y then
						fposmax.y = fposi.y
					end
					if fposi.z > fposmax.z then
						fposmax.z = fposi.z
					end
					if fposi.x < fposmin.x then
						fposmin.x = fposi.x
					end
					if fposi.y < fposmin.y then
						fposmin.y = fposi.y
					end
					if fposi.z < fposmin.z then
						fposmin.z = fposi.z
					end
				end
				fposmid = vector.divide(vector.add(fposmin, fposmax), 2)
			end
			-- Play sound
			local handle = minetest.sound_play(
				"inferno_fire",
				{
					pos = fposmid,
					to_player = player_name,
					gain = math.min(0.06 * (1 + flames * 0.125), 0.18),
					max_hear_distance = 32,
					loop = true, -- In case of lag
				}
			)
			-- Store sound handle for this player
			if handle then
				handles[player_name] = handle
			end
		end
	end

	-- Cycle for updating players sounds

	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer < cycle then
			return
		end

		timer = 0
		local players = minetest.get_connected_players()
		for n = 1, #players do
			inferno.update_player_sound(players[n])
		end
	end)

	-- Stop sound and clear handle on player leave

	minetest.register_on_leaveplayer(function(player)
		local player_name = player:get_player_name()
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
	end)
end


--
-- ABM
--
-- Remove/convert flammable nodes around basic flame
--remember to set on_burn for the registered node where suitable
-- e.g. to turn trees into tech large fire

minetest.register_abm({
      label = "Ignite flammable nodes",
      nodenames = {"group:flammable"},
      neighbors = {"group:flames", "group:igniter"},
      interval = 27,
      chance = 9,
      catch_up = false,
      action = function(pos, node)
	 local flammable_node = node
	 local def = minetest.registered_nodes[flammable_node.name]
	 if math.random(1, def.groups.flammable) > 1 then
	    return -- resisted burning
	 end
	 if not minetest.is_singleplayer and
	    math.random(1,5) > 1 and
	    minetest.find_node_near(pos, 1, "group:igniter") == nil then
	    return -- multiplayer reduction, including no flame ignition
	 end
	 if def.on_burn then
	    def.on_burn(pos)
	 elseif minetest.get_item_group(flammable_node.name, "tree") >= 1
	    or minetest.get_item_group(flammable_node.name, "log") >= 1 then
	    minetest.set_node(pos, {name = "tech:large_wood_fire"})
	    if math.random(1,4) == 1 then
	       minetest.check_for_falling(pos)
	    end
	 else
	    local p = minetest.find_node_near(pos, 1, {"air",
						    "climate:air_temp",
						    "climate:air_temp_visible"})
	    if p and math.random(1,10) < 10 then
	       minetest.set_node(p, {name = "inferno:basic_flame"})
	    elseif minetest.find_node_near(pos, 1, "group:flames") == nil then
	       minetest.set_node(pos, {name = "inferno:basic_flame"})
	    else
	       minetest.remove_node(pos)
	    end
	    if math.random(1,4) == 1 then
	       minetest.check_for_falling(pos)
	    end
	 end
      end,
})


--------------------------------------------------
-- Fire Starters
--

local function add_wear(player_name, itemstack, sound_pos)
	if not (creative and creative.is_enabled_for
			and creative.is_enabled_for(player_name)) then
		-- Wear tool
		local wdef = itemstack:get_definition()
		itemstack:add_wear(2000)
		-- Tool break sound
		if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
		   minetest.sound_play(wdef.sound.breaks, {pos = sound_pos, gain = 0.5, max_hear_distance = 8})
		end
		return itemstack
	end

end

local lit = {
   ["tech:small_wood_fire_unlit"] = "tech:small_wood_fire",
   ["tech:large_wood_fire_unlit"] = "tech:large_wood_fire",
   ["tech:charcoal"] = "tech:small_charcoal_fire",
   ["tech:charcoal_block"] = "tech:large_charcoal_fire",
   ["tech:small_wood_fire_ext"] = "tech:small_wood_fire",
   ["tech:large_wood_fire_ext"] = "tech:large_wood_fire",
   ["tech:small_charcoal_fire_ext"] = "tech:small_charcoal_fire",
   ["tech:large_charcoal_fire_ext"] = "tech:large_charcoal_fire",
}

function inferno.ignite(pos, nodename)
   if nodename == nil or nodename == "" then
      nodename = minetest.get_node(pos).name
   end
   for unl, l in pairs(lit) do
      if nodename == unl then
	 minimal.switch_node(pos, {name = l})
	 return true
      end
   end
   return false
end

-- Fire Sticks
minetest.register_tool("inferno:fire_sticks", {
	description = S("Fire Sticks"),
	inventory_image = "inferno_fire_sticks.png",
	sound = {breaks = "tech_tool_breaks"},

	on_use = function(itemstack, user, pointed_thing)
		local sound_pos = pointed_thing.above or user:get_pos()
		minetest.sound_play(
			"inferno_fire_sticks",
			{pos = sound_pos, gain = 0.5, max_hear_distance = 8}
		)
		local player_name = user:get_player_name()
		if pointed_thing.type == "node" then
			local node_under = minetest.get_node(pointed_thing.under).name
			local pos_under = pointed_thing.under
			if inferno.ignite(pos_under, node_under) then
			   return add_wear(player_name, itemstack, sound_pos)
			end

			local nodedef = minetest.registered_nodes[node_under]
			if not nodedef then
				return
			end
			if minetest.is_protected(pointed_thing.under, player_name) then
				minetest.chat_send_player(player_name, "This area is protected")
				return
			end
			local chance = nodedef.groups.flammable
			if (chance and chance < 6) or chance == nil then
			   if nodedef.on_ignite then
			      nodedef.on_ignite(pointed_thing.under, user)
			   elseif chance and ( math.random(1, chance) == 1 and
				    minetest.get_node(pointed_thing.above).name == "air" ) then
			      minetest.set_node(pointed_thing.above, {name = "inferno:basic_flame"})
			   end
			end
		end

		return add_wear(player_name, itemstack, sound_pos)

	end
})


---------------------------------------
--Recipes

--
--Hand crafts (Crafting spot)
--
minetest.register_on_mods_loaded(function()
      ----craft unlit fire from Sticks, tinder
      crafting.register_recipe({
	    type = "crafting_spot",
	    output = "inferno:fire_sticks",
	    items = {"tech:stick 2", "group:fibrous_plant 1"},
	    level = 1,
	    always_known = true,
      })
end)
