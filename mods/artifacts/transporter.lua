------------------------------------
--TRANSPORTER
--Teleporter
--[[
Difficult to assemble, dangerous when incomplete, expensive to use, limited powers (range, links etc)
Intended to make long distance travel possible, but not overpowered.

Single destination - must physically key it to a paired transporter.

Components
-transporter pad: central part that moves player.
-power core: used up by transport, must be recharged by heating.
-regulator: stops dangerous effects e.g. extreme heat.
-stabilizer: locks onto actual location, not just general area
-focalizer: increases range to full distance

-locator ley: allows linking (item)

Components must be 1 block radius around the pad. Above pad must be kept clear.
Only need one of each

]]
------------------------------------
local rand = math.random
--minimum distance transporters muct be apart (nodes)
local MIN_DIST = 30

--standard  range, fully functioning range
local STAN_RANGE = 300
local FULL_RANGE = 3000

--to stop excessive back and forth
local recent_teleports = {}




------------------------------------------------------------
--TRANSPORTER PAD

--actually move
local function teleport_effects(target_pos, pos, player, player_name, regulator, power, random)
	local origin = player:get_pos()
	target_pos.y = target_pos.y + 0.5

	--effects at source
	minetest.sound_play( {name="artifacts_transport", gain=1}, {pos=pos, max_hear_distance=100})
	minetest.add_particlespawner({
		amount = 15,
		time = 0.75,
		minpos = {x=pos.x, y=pos.y+0.3, z=pos.z},
		maxpos = {x=pos.x, y=pos.y+2, z=pos.z},
		minvel = {x = 1,  y = -6,  z = 1},
		maxvel = {x = -1, y = 2, z = -1},
		minacc = {x = 0, y = -2, z = 0},
		maxacc = {x = 0, y = -6, z = 0},
		minexptime = 0.2,
		maxexptime = 1,
		minsize = 1,
		maxsize = 10,
		texture = "artifacts_sparks.png",
		glow = 15,
	})


	--swap out power core
	minetest.set_node(power, {name = "artifacts:transporter_power_dep"})
	--go to target
	player:set_pos(target_pos)


	--effects at target
	minetest.sound_play( {name="artifacts_transport", gain=1}, {pos=target_pos, max_hear_distance=100})
	minetest.add_particlespawner({
		amount = 15,
		time = 0.75,
		minpos = {x=target_pos.x, y=target_pos.y+0.3, z=target_pos.z},
		maxpos = {x=target_pos.x, y=target_pos.y+2, z=target_pos.z},
		minvel = {x = 1,  y = -6,  z = 1},
		maxvel = {x = -1, y = 2, z = -1},
		minacc = {x = 0, y = -2, z = 0},
		maxacc = {x = 0, y = -6, z = 0},
		minexptime = 0.2,
		maxexptime = 1,
		minsize = 1,
		maxsize = 10,
		texture = "artifacts_sparks.png",
		glow = 15,
	})

	--dangerous effects (super heated air)
	if not regulator then
		local node = minetest.get_node(target_pos).name
		if node == 'air' then
			--minetest.set_node(target_pos, {name = 'nodes_nature:lava_flowing'})
			minetest.set_node(target_pos, {name = 'climate:air_temp'})
			local meta = minetest.get_meta(target_pos)
			meta:set_float("temp", 3000)
		end
	end

	--failsafe. (if emerge area failed, and end up in rock)
	--hopefully only an issue for random teleports, unless someone's screwed with
	--your teleporter pad
	--means you get zapped instead of thrown to a random place,
	-- which serves the purpose of a fail either way
	if random ~= 'locked' then

		local dest_node = minetest.get_node(target_pos).name
		local def = minetest.registered_nodes[dest_node]
		if dest_node == 'ignore' or (def and def.walkable) then
			--potentially went into a solid
			--return to origin
			player:set_pos(origin)
			--you temporarirly merged with a solid...ouch
			local hp = player:get_hp()
			player:set_hp(hp-10)
		end

	end

	-- prevent teleport spamming
	recent_teleports[player_name] = true
	minetest.after(5, function(name)
		recent_teleports[name] = nil
	end,
	player_name)

end






--ensure destination is usable
local function check_teleport_dest(dest, pos, range, random)


	local dest_ok  = true

	--check if in range
	local dist = vector.distance(pos, dest)

	if random == "locked" then
		if dist > range or dist < MIN_DIST then
			dest_ok = false
			return dest_ok
		end
	else
		if dist > range then
			dest_ok = false
			return dest_ok
		end
	end


	-- check the destination node for pad, and the two nodes
	-- above for "walkthrough"
	-- "ignore" is ok, we could not emerge in time then.
	local dest_bot = minetest.get_node({ x = dest.x, y = dest.y  , z = dest.z })
	local dest_mid = minetest.get_node({ x = dest.x, y = dest.y+1, z = dest.z })
	local dest_top = minetest.get_node({ x = dest.x, y = dest.y+2, z = dest.z })

	if random == "locked" then
		if dest_bot.name ~= 'ignore'
		and dest_bot.name ~= 'artifacts:transporter_pad'
		and dest_bot.name ~= 'artifacts:transporter_pad_charging'
		and dest_bot.name ~= 'artifacts:transporter_pad_active' then
			dest_ok = false
			return dest_ok
		end
	end

	if dest_mid.name ~= 'ignore' and dest_mid.name ~= 'air' then
		local def = minetest.registered_nodes[dest_mid.name]
		if def and def.walkable then
			dest_ok = false
			return dest_ok
		end
	end

	if dest_top.name ~= 'ignore' and dest_top.name ~= 'air' then
		local def = minetest.registered_nodes[dest_top.name]
		if def and def.walkable then
			dest_ok = false
			return dest_ok
		end
	end
	return dest_ok


end




--get a random teleport destination
local function find_random_dest(pos)
	local target_pos = false
	local r = MIN_DIST - 2

	local cnt = 0
	while cnt < 30 do
		local randpos = {x = pos.x + rand(-r,r), y = pos.y + rand(-r, r), z = pos.z + rand(-r,r)}
		local dest_ok = check_teleport_dest(randpos, pos, MIN_DIST, true)
		if dest_ok then
			target_pos = randpos
			break
		end
		cnt = cnt + 1
	end

	return target_pos
end




--Main teleport function
local function do_teleport(pos, target_pos, random, player, range, regulator, power)

	-- prevent teleport spamming
	local player_name = player:get_player_name()
	if recent_teleports[player_name] then
		return
	end

	if random == "random" then
		target_pos = find_random_dest(target_pos)
		if not target_pos then
			--failed to find a viable spot
			minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
			return
		end
	end


	--check for usability
	local dest_ok = check_teleport_dest(target_pos, pos, range, random)

	if not dest_ok then
		--lose link
		local meta_tran = minetest.get_meta(pos)
		meta_tran:set_string("target_name", "")
		meta_tran:set_string("target_pos", "")
		local tran_name = meta_tran:get_string("tran_name")
		if tran_name ~= "" then
			meta_tran:set_string("infotext", "Name: "..tran_name)
		else
			meta_tran:set_string("infotext", "")
		end
		minetest.sound_play("artifacts_transport_fail", {pos = pos, gain = 1, max_hear_distance = 6})


	else

		teleport_effects(target_pos, pos, player, player_name, regulator, power, random)

	end
end




--finds where it will transport to, then emerges this area
--after a time delay to allow for emerge the usual checks can be preformed
local function get_transporter_target(pos, stabilizer)

	local meta = minetest.get_meta(pos)
	local target = meta:get_string('target_pos')


	--no pre-saved target, go to random
	if target == "" then
		--will go to random at source after area is emerged
		return pos, "random"

	elseif target ~= "" then
		target = minetest.string_to_pos(target)

		--has a target but can't lock on
		if not stabilizer then
			--will go to random at target after area is emerged
			return target, "random"
		else
			return target, "locked"
		end

	end

end




--get the status of the transporter set up
local function assess_transporter(pos)
	--assume no Components, then check which are present
	local power = false
	local range = STAN_RANGE
	local stabilizer = false
	local regulator = false

	--get the position so it can be swapped out
	local power = minetest.find_node_near(pos, 1, {"artifacts:transporter_power"})

	if minetest.find_node_near(pos, 1, {"artifacts:transporter_focalizer"}) then
		range = FULL_RANGE
	else
		minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
	end

	if minetest.find_node_near(pos, 1, {"artifacts:transporter_stabilizer"}) then
		stabilizer = true
	else
		minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
	end

	if minetest.find_node_near(pos, 1, {"artifacts:transporter_regulator"}) then
		regulator = true
	else
		minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
	end


	return power, range, stabilizer, regulator
end





--
local function transporter_rightclick(pos, node, player, itemstack, pointed_thing)
	if itemstack:get_name() == "artifacts:transporter_key" then
		--don't conflict with key
		return
	end

	--assess status
	local power, range, stabilizer, regulator  = assess_transporter(pos)
	if power then

		local dpos, random = get_transporter_target(pos, stabilizer)

		local p1 = { x = dpos.x - MIN_DIST, y = dpos.y - MIN_DIST, z = dpos.z - MIN_DIST}
		local p2 = { x = dpos.x + MIN_DIST, y = dpos.y + MIN_DIST, z = dpos.z + MIN_DIST}

		minetest.emerge_area(p1, p2)

		local dest = minetest.pos_to_string(dpos)

		--create charging pad and copy over meta data
		local meta_tran = minetest.get_meta(pos)
		local target_name = meta_tran:get_string("target_name")
		local target_pos = meta_tran:get_string("target_pos")
		local tran_name = meta_tran:get_string("tran_name")
		local infotext = meta_tran:get_string("infotext")

		minetest.set_node(pos, {name = "artifacts:transporter_pad_charging"})
		minetest.sound_play("artifacts_transport_charge", {pos = pos, gain = 2, max_hear_distance = 20})

		meta_tran:set_string("target_name", target_name)
		meta_tran:set_string("target_pos", target_pos)
		meta_tran:set_string("tran_name", tran_name)
		meta_tran:set_string("infotext", infotext)
		meta_tran:set_string("tmp_dest", dest)
		meta_tran:set_string("tmp_random", random)


	else
		minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
	end

end


local function active_transporter_rightclick(pos, node, player, itemstack, pointed_thing)
	--recheck incase it's been buggered with during wait
	local power, range, stabilizer, regulator  = assess_transporter(pos)
	if power then

		local meta_tran = minetest.get_meta(pos)
		local dest = minetest.string_to_pos(meta_tran:get_string("tmp_dest"))
		local random = meta_tran:get_string("tmp_random")

		do_teleport(pos, dest, random, player, range, regulator, power)

	else
		minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
	end

end



-----------------------------------------------------------
--KEYS

--set a transporter location from saved
local function set_from_key(itemstack, placer, pointed_thing)

	-- possible only on nodes
	if pointed_thing.type ~= "node" then
		return
	end

	local pt_under = pointed_thing.under
	local node = minetest.get_node(pt_under).name
	local player_name = placer:get_player_name()
	local pos = placer:get_pos()

	if node ~= "artifacts:transporter_pad" then
		minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "KEY CAN ONLY SET DESTINATIONS FOR TRANSPORTER PAD"))
		return
	end


	if node == "artifacts:transporter_pad" then
		local meta_tran = minetest.get_meta(pt_under)
		local power, range, stabilizer, regulator  = assess_transporter(pt_under) --really just need range

		--only one link
		local tran_target = meta_tran:get_string("target_pos")
		if tran_target ~= "" then
			minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "TRANSPORTER ALREADY BONDED"))
			minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
			return
			--[[--requires area to be loaded to work
			--check if target is even usable
			local dest_ok = check_teleport_dest(minetest.string_to_pos(tran_target), pt_under, range)
			if dest_ok then
				minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "TRANSPORTER ALREADY BONDED"))
				minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
				return
			else
				--wipe faulty bond
				meta_tran:set_string("target_name", "")
				meta_tran:set_string("target_pos", "")
				local tran_name = meta_tran:get_string("tran_name")
				if tran_name ~= "" then
					meta_tran:set_string("infotext", "Name: "..tran_name)
				else
					meta_tran:set_string("infotext", "")
				end
				minetest.sound_play("artifacts_transport_fail", {pos = pos, gain = 1, max_hear_distance = 6})
				return
			end
			]]
		end

		--get meta and see if key has a saved location
		local meta = itemstack:get_meta()
		local posstring = meta:get_string("target_pos")

		--use saved location to set transporter's target.
		if posstring ~= "" and not minetest.is_protected(pt_under, player_name) then

			--[[--requires area to be loaded to work

			local dest_ok = check_teleport_dest(minetest.string_to_pos(posstring), pt_under, range)

			if not dest_ok then
				minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "KEY: TARGET NOT VIABLE"))
				minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
				return
			end
			]]

			--call a formspec to make it harder to accidently set a transporter to the wrong location

			--temporary save transporter position, and the target pos and name
			--so can be used by formspec
			local player_meta = placer:get_meta()
			local tmp_tran_pos = minetest.pos_to_string(pt_under)
			local target_name = meta:get_string("target_name")
			player_meta:set_string("tmp_tran_pos", tmp_tran_pos)
			player_meta:set_string("tmp_target_name", target_name)
			player_meta:set_string("tmp_target_pos", posstring)

			minetest.show_formspec(player_name, "set_from_trans_key",
					"size[10,2.5]" ..
					"label[1,1;Target name: "..target_name.."]"..
					"button_exit[0.7,2;3,1;cancel;Cancel]"..
					"button_exit[3.7,2;5,1;ok;Bond Transporter to Target]" )

		elseif posstring == "" then
			minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "KEY IS BLANK!: use leftclick to save this location"))
			minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})
		end
	end

end


-- Set from key from formspec
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "set_from_trans_key" and (fields.ok or fields.key_enter) then

		--get temp saved data
		local player_meta = player:get_meta()
		local pos_tran = minetest.string_to_pos(player_meta:get_string("tmp_tran_pos"))
		local target_name = player_meta:get_string("tmp_target_name")
		local target_pos = player_meta:get_string("tmp_target_pos")


		--set transporter
		local meta_tran = minetest.get_meta(pos_tran)
		meta_tran:set_string("target_name", target_name)
		meta_tran:set_string("target_pos", target_pos)
		local infotext = meta_tran:get_string("infotext")
		meta_tran:set_string("infotext", infotext.. "\nDestination: "..target_name)

		local player_name = player:get_player_name()
		minetest.sound_play( 'artifacts_key', { pos = pos_tran, gain = 1, max_hear_distance = 5,})
		minetest.chat_send_player(player_name, minetest.colorize("#00ff00", "TRANSPORTER DESTINATION SET TO: "..target_name.." at "..target_pos))
		minetest.sound_play("artifacts_transport_fail", {pos = pos, gain = 1, max_hear_distance = 6})

		--clear temp
		player_meta:set_string("tmp_tran_pos", "")
		player_meta:set_string("tmp_target_name", "")
		player_meta:set_string("tmp_target_pos", "")

	end
end)




--Save a location
local function save_to_key(itemstack, player, pointed_thing)

	-- possible only on nodes
	if pointed_thing.type ~= "node" then
		return
	end

	local pt_under = pointed_thing.under
	local node = minetest.get_node(pt_under).name
	local player_name = player:get_player_name()
	local pos = player:get_pos()

	if node ~= "artifacts:transporter_pad" then
		minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "KEY CAN ONLY SAVE FROM TRANSPORTER PAD"))
		return
	end


	if node == "artifacts:transporter_pad" then

		--get meta and see if it has a saved location
		local meta = itemstack:get_meta()
		local posstring = meta:get_string("target_pos")

		if posstring ~= "" then
			--key already bonded, give chance to wipe it
			--minetest.chat_send_player(player_name, minetest.colorize("#cc6600", "KEY ALREADY BONDED: use rightclick to set transporter to this key's location"))
			local target_name = meta:get_string("target_name")
			minetest.show_formspec(player_name, "wipe_trans_key",
					"size[10,2.5]" ..
					"label[1,1;Key's target name: "..target_name.."]"..
					"button_exit[0.7,2;3,1;cancel;Cancel]"..
					"button_exit[3.7,2;5,1;ok;Wipe Key]" )
			return

		elseif posstring == "" then
			--save location to the key
			-- show the formspec to player
			local tmp_target_pos = minetest.pos_to_string(pt_under)
			meta:set_string("tmp_target_pos", tmp_target_pos)

			--different form depending on if transporter already has a name
			local meta_tran = minetest.get_meta(pt_under)
			local tran_name = meta_tran:get_string("tran_name")
			if tran_name == "" then
				minetest.show_formspec(player_name, "create_transporter_key_nameless",
						"size[10,2.5]" ..
						"field[1,1;8,1;name;Destination name:;".."]"..
						"button_exit[0.7,2;3,1;cancel;Cancel]"..
						"button_exit[3.7,2;5,1;ok;Create Bonded Key]" )
				return itemstack
			else
				minetest.show_formspec(player_name, "create_transporter_key",
						"size[10,2.5]" ..
						"label[1,1;Destination name: "..tran_name.."]"..
						"button_exit[0.7,2;3,1;cancel;Cancel]"..
						"button_exit[3.7,2;5,1;ok;Create Bonded Key]" )
				return itemstack
			end
		end
	end
end


--wipe transporter key
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "wipe_trans_key" and (fields.ok or fields.key_enter) then
		local player_name = player:get_player_name()
		local stack=player:get_wielded_item()
		local meta=stack:get_meta()

		meta:set_string("target_pos", "")
		meta:set_string("target_name", "target_name")
		meta:set_string("description", "Transporter Key")

		minetest.sound_play("artifacts_transport_error", {pos = pos, gain = 1, max_hear_distance = 6})

		player:set_wielded_item(stack)

	end
end)



-- Save key from formspec (first time transporter saved from, sets location name)
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "create_transporter_key_nameless" and fields.name and (fields.ok or fields.key_enter) then
		local player_name = player:get_player_name()
		local stack=player:get_wielded_item()
		local meta=stack:get_meta()

		local target = meta:get_string("tmp_target_pos")
		meta:set_string("target_pos", target)

		local target_name = fields.name
		if target_name == "" then
			target_name = "nameless location"
		end

		meta:set_string("target_name", target_name)
		meta:set_string("description", "Transporter Key to "..target_name)

		meta:set_string("tmp_target_pos", "")

		--set name and infotext of transporter
		local meta_tran = minetest.get_meta(minetest.string_to_pos(target))
		local infotext = meta_tran:get_string("infotext")
		meta_tran:set_string("infotext", infotext.. "\nName: "..target_name)
		meta_tran:set_string("tran_name", target_name)


		minetest.chat_send_player(player_name, minetest.colorize("#00ff00", "TRANSPORTER KEY CREATED TO: "..target_name))
		minetest.sound_play("artifacts_transport_fail", {pos = pos, gain = 1, max_hear_distance = 6})


		player:set_wielded_item(stack)
	end
end)



-- Save key from formspec (location already named)
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "create_transporter_key" and (fields.ok or fields.key_enter) then
		local player_name = player:get_player_name()
		local stack=player:get_wielded_item()
		local meta=stack:get_meta()

		local target = meta:get_string("tmp_target_pos")
		meta:set_string("target_pos", target)

		local meta_tran = minetest.get_meta(minetest.string_to_pos(target))
		local target_name = meta_tran:get_string("tran_name")


		meta:set_string("target_name", target_name)
		meta:set_string("description", "Transporter Key to "..target_name)

		meta:set_string("tmp_target_pos", "")

		minetest.chat_send_player(player_name, minetest.colorize("#00ff00", "TRANSPORTER KEY CREATED TO: "..target_name))
		minetest.sound_play("artifacts_transport_fail", {pos = pos, gain = 1, max_hear_distance = 6})


		player:set_wielded_item(stack)
	end
end)




------------------------------------------------------------------
--RECHARGE POWER

local function set_charging(pos, length, interval)
	local meta = minetest.get_meta(pos)
	meta:set_int("charging", length)
	minetest.get_node_timer(pos):start(interval)
end



local function charge_power(pos, selfname, name, length)
	local meta = minetest.get_meta(pos)
	local charging = meta:get_int("charging")

	--exchange accumulated heat
	climate.heat_transfer(pos, selfname)

	--check if above temp
	--able to heat with lava
	local temp = climate.get_point_temp(pos)
	local charge_temp = 1000

	if charging <= 0 then
		--finished
		minetest.set_node(pos, {name = name})
		return false
	elseif temp < charge_temp then
		return true
	elseif temp >= charge_temp then
		--do charge
		meta:set_int("charging", charging - 1)
		return true
	end

end



------------------------------------------------------------------
--NODES, ITEMS

minetest.register_node('artifacts:transporter_pad', {
	description = 'Transporter Pad',
	tiles = {'artifacts_antiquorium.png'},
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, -0.125, 0.0625, -0.125}, -- NodeBox1
			{0.125, 0, -0.5, 0.5, 0.0625, -0.125}, -- NodeBox2
			{0.125, 0, 0.125, 0.5, 0.0625, 0.5}, -- NodeBox3
			{-0.5, 0, 0.125, -0.125, 0.0625, 0.5}, -- NodeBox4
			{-0.375, -0.125, -0.375, 0.375, 0.0, 0.375}, -- NodeBox5
			{-0.4375, -0.3125, -0.4375, 0.4375, -0.125, 0.4375}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox7
			{-0.125, 0, -0.125, 0.125, 0.0625, 0.125}, -- NodeBox9
		}
	},
	groups = { cracky = 2 },
	on_rightclick = transporter_rightclick,
	sounds = nodes_nature.node_sound_glass_defaults(),
})


minetest.register_node('artifacts:transporter_pad_charging', {
	description = 'Transporter Pad (Charging)',
	tiles = {'artifacts_antiquorium.png^artifacts_moon_glass.png'},
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	paramtype = "light",
	light_source = 3,
	drop = 'artifacts:transporter_pad',
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, -0.125, 0.0625, -0.125}, -- NodeBox1
			{0.125, 0, -0.5, 0.5, 0.0625, -0.125}, -- NodeBox2
			{0.125, 0, 0.125, 0.5, 0.0625, 0.5}, -- NodeBox3
			{-0.5, 0, 0.125, -0.125, 0.0625, 0.5}, -- NodeBox4
			{-0.375, -0.125, -0.375, 0.375, 0.0, 0.375}, -- NodeBox5
			{-0.4375, -0.3125, -0.4375, 0.4375, -0.125, 0.4375}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox7
			{-0.125, 0, -0.125, 0.125, 0.0625, 0.125}, -- NodeBox9
		}
	},
	groups = {},
	sounds = nodes_nature.node_sound_glass_defaults(),
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(20)
	end,
	on_timer = function(pos, elapsed)
		local meta_tran = minetest.get_meta(pos)
		local target_name = meta_tran:get_string("target_name")
		local target_pos = meta_tran:get_string("target_pos")
		local tran_name = meta_tran:get_string("tran_name")
		local infotext = meta_tran:get_string("infotext")
		local tmp_dest = meta_tran:get_string("tmp_dest")
		local tmp_random = meta_tran:get_string("tmp_random")

		minetest.set_node(pos, {name = 'artifacts:transporter_pad_active'})
		minetest.sound_play("artifacts_transport_charged", {pos = pos, gain = 2, max_hear_distance = 20})
		minetest.add_particlespawner({
			amount = 15,
			time = 0.75,
			minpos = {x=pos.x, y=pos.y+0.3, z=pos.z},
			maxpos = {x=pos.x, y=pos.y+2, z=pos.z},
			minvel = {x = 1,  y = -6,  z = 1},
			maxvel = {x = -1, y = 2, z = -1},
			minacc = {x = 0, y = -2, z = 0},
			maxacc = {x = 0, y = -6, z = 0},
			minexptime = 0.2,
			maxexptime = 1,
			minsize = 1,
			maxsize = 10,
			texture = "artifacts_sparks.png",
			glow = 15,
		})

		meta_tran:set_string("target_name", target_name)
		meta_tran:set_string("target_pos", target_pos)
		meta_tran:set_string("tran_name", tran_name)
		meta_tran:set_string("infotext", infotext)
		meta_tran:set_string("tmp_dest", tmp_dest)
		meta_tran:set_string("tmp_random", tmp_random)

	end,
})


minetest.register_node('artifacts:transporter_pad_active', {
	description = 'Transporter Pad (active)',
	tiles = {'artifacts_antiquorium.png^artifacts_sun_stone.png'},
	stack_max = minimal.stack_max_bulky,
	light_source = 6,
	drawtype = "nodebox",
	paramtype = "light",
	drop = 'artifacts:transporter_pad',
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, -0.125, 0.0625, -0.125}, -- NodeBox1
			{0.125, 0, -0.5, 0.5, 0.0625, -0.125}, -- NodeBox2
			{0.125, 0, 0.125, 0.5, 0.0625, 0.5}, -- NodeBox3
			{-0.5, 0, 0.125, -0.125, 0.0625, 0.5}, -- NodeBox4
			{-0.375, -0.125, -0.375, 0.375, 0.0, 0.375}, -- NodeBox5
			{-0.4375, -0.3125, -0.4375, 0.4375, -0.125, 0.4375}, -- NodeBox6
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox7
			{-0.125, 0, -0.125, 0.125, 0.0625, 0.125}, -- NodeBox9
		}
	},
	groups = {},
	on_rightclick = active_transporter_rightclick,
	sounds = nodes_nature.node_sound_glass_defaults(),
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(30)
	end,
	on_timer = function(pos, elapsed)
		local meta_tran = minetest.get_meta(pos)
		local target_name = meta_tran:get_string("target_name")
		local target_pos = meta_tran:get_string("target_pos")
		local tran_name = meta_tran:get_string("tran_name")
		local infotext = meta_tran:get_string("infotext")

		minetest.set_node(pos, {name = 'artifacts:transporter_pad'})
		minetest.sound_play("artifacts_transport_fail", {pos = pos, gain = 1, max_hear_distance = 6})

		meta_tran:set_string("target_name", target_name)
		meta_tran:set_string("target_pos", target_pos)
		meta_tran:set_string("tran_name", tran_name)
		meta_tran:set_string("infotext", infotext)
		meta_tran:set_string("tmp_dest", "")
		meta_tran:set_string("tmp_random", "")
	end,
})


minetest.register_node('artifacts:transporter_power', {
	description = 'Transporter Power Core (charged)',
	tiles = {
		'artifacts_sun_stone.png',
	},
	light_source = 2,
	stack_max = minimal.stack_max_bulky *2,
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, -0.375, 0.5, 0.5}, -- NodeBox1
			{0.375, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox2
			{0.375, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox3
			{-0.5, -0.5, -0.5, -0.375, -0.375, 0.5}, -- NodeBox4
			{-0.375, -0.5, -0.5, 0.375, -0.375, -0.375}, -- NodeBox5
			{-0.375, -0.5, 0.375, 0.375, -0.375, 0.5}, -- NodeBox6
			{-0.375, 0.375, 0.375, 0.375, 0.5, 0.5}, -- NodeBox7
			{-0.375, 0.375, -0.5, 0.375, 0.5, -0.375}, -- NodeBox8
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.375}, -- NodeBox9
			{-0.125, -0.375, -0.5, 0.125, 0.375, -0.375}, -- NodeBox10
			{-0.125, -0.375, 0.375, 0.125, 0.375, 0.5}, -- NodeBox11
			{0.375, -0.375, -0.125, 0.5, 0.375, 0.125}, -- NodeBox12
			{-0.5, -0.375, -0.125, -0.375, 0.375, 0.125}, -- NodeBox13
		}
	},
	groups = { oddly_breakable_by_hand = 3 },
	sounds = nodes_nature.node_sound_glass_defaults(),
})





minetest.register_node('artifacts:transporter_power_dep', {
	description = 'Transporter Power Core (depleted)',
	tiles = {
		'artifacts_moon_glass.png',
	},
	stack_max = minimal.stack_max_bulky *2,
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, -0.375, 0.5, 0.5}, -- NodeBox1
			{0.375, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox2
			{0.375, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox3
			{-0.5, -0.5, -0.5, -0.375, -0.375, 0.5}, -- NodeBox4
			{-0.375, -0.5, -0.5, 0.375, -0.375, -0.375}, -- NodeBox5
			{-0.375, -0.5, 0.375, 0.375, -0.375, 0.5}, -- NodeBox6
			{-0.375, 0.375, 0.375, 0.375, 0.5, 0.5}, -- NodeBox7
			{-0.375, 0.375, -0.5, 0.375, 0.5, -0.375}, -- NodeBox8
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.375}, -- NodeBox9
			{-0.125, -0.375, -0.5, 0.125, 0.375, -0.375}, -- NodeBox10
			{-0.125, -0.375, 0.375, 0.125, 0.375, 0.5}, -- NodeBox11
			{0.375, -0.375, -0.125, 0.5, 0.375, 0.125}, -- NodeBox12
			{-0.5, -0.375, -0.125, -0.375, 0.375, 0.125}, -- NodeBox13
		}
	},
	groups = { oddly_breakable_by_hand = 3, heatable = 30 },
	sounds = nodes_nature.node_sound_glass_defaults(),
	on_construct = function(pos)
		--length(i.e. difficulty), interval for checks (speed)
		set_charging(pos, 5, 20)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length
		return charge_power(pos, "artifacts:transporter_power_dep", "artifacts:transporter_power", 5)
	end,
})

minetest.register_node('artifacts:transporter_focalizer', {
	description = 'Transporter Focalizer',
	tiles = {'artifacts_antiquorium.png'},
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- NodeBox1
			{-0.3125, -0.25, -0.3125, 0.3125, 0, 0.3125}, -- NodeBox2
			{-0.0625, 0, -0.0625, 0.0625, 0.5, 0.0625}, -- NodeBox3
			{-0.0625, 0, -0.25, 0.0625, 0.4375, -0.125}, -- NodeBox4
			{-0.0625, 0, 0.125, 0.0625, 0.4375, 0.25}, -- NodeBox5
			{0.125, 0, 0.125, 0.25, 0.5, 0.25}, -- NodeBox6
			{-0.25, 0, 0.125, -0.125, 0.5, 0.25}, -- NodeBox7
			{-0.25, 0, -0.25, -0.125, 0.5, -0.125}, -- NodeBox8
			{0.125, 0, -0.25, 0.25, 0.5, -0.125}, -- NodeBox9
			{0.125, 0, -0.0625, 0.25, 0.4375, 0.0625}, -- NodeBox10
			{-0.25, 0, -0.0625, -0.125, 0.4375, 0.0625}, -- NodeBox11
		}
	},
	groups = { cracky = 3 },
	sounds = nodes_nature.node_sound_glass_defaults(),
})

minetest.register_node('artifacts:transporter_stabilizer', {
	description = 'Transporter Stabilizer',
	tiles = {'artifacts_antiquorium.png'},
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, 0.125, -0.125, 0.125, 0.1875, 0.125}, -- NodeBox1
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- NodeBox2
			{-0.125, -0.25, -0.5, 0.125, -0.0625, -0.25}, -- NodeBox6
			{-0.125, -0.25, 0.25, 0.125, -0.0625, 0.5}, -- NodeBox7
			{-0.5, -0.25, -0.125, -0.25, -0.0625, 0.125}, -- NodeBox8
			{0.25, -0.25, -0.125, 0.5, -0.0625, 0.125}, -- NodeBox9
			{-0.25, -0.25, -0.25, 0.25, 0.125, 0.25}, -- NodeBox10
		}
	},
	groups = { cracky = 3 },
	sounds = nodes_nature.node_sound_glass_defaults(),
})

minetest.register_node('artifacts:transporter_regulator', {
	description = 'Transporter Regulator',
	tiles = {'artifacts_antiquorium.png'},
	stack_max = minimal.stack_max_bulky,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.3125, -0.5, 0.5, 0.5, -0.1875}, -- NodeBox1
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox2
			{-0.5, -0.125, -0.5, 0.5, 0.125, 0.5}, -- NodeBox3
			{-0.3125, 0.125, -0.3125, 0.3125, 0.3125, 0.3125}, -- NodeBox4
			{0.125, -0.3125, -0.5, 0.5, -0.125, -0.125}, -- NodeBox5
			{0.125, -0.3125, 0.125, 0.5, -0.125, 0.5}, -- NodeBox6
			{-0.5, -0.3125, -0.5, -0.125, -0.125, -0.125}, -- NodeBox9
			{-0.5, -0.3125, 0.125, -0.125, -0.125, 0.5}, -- NodeBox10
			{-0.5, 0.3125, 0.1875, 0.5, 0.5, 0.5}, -- NodeBox11
			{0.1875, 0.3125, -0.1875, 0.5, 0.5, 0.1875}, -- NodeBox12
			{-0.5, 0.3125, -0.1875, -0.1875, 0.5, 0.1875}, -- NodeBox13
		}
	},
	groups = { cracky = 3 },
	sounds = nodes_nature.node_sound_glass_defaults(),
})



minetest.register_tool('artifacts:transporter_key', {
    description = 'Transporter Key',
    inventory_image = 'artifacts_transporter_key.png',
    --groups = {},
		on_use = save_to_key,
		on_place = set_from_key,
})


---------------------------------------------------------
