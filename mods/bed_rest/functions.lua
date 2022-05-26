-----------------------------------------------------------------
--BED REST FUNCTIONS
--
-----------------------------------------------------------------

local pi = math.pi
local store = minetest.get_mod_storage()
--silence luacheck warnings about accessing globals:
bed_rest = bed_rest
player_api = player_api
player_monoids = player_monoids
clothing = clothing

-- after this many days, beds in multiplayer will no longer be protected
local days_until_timeout = 7

function load_bedrest()
   local loaded = minetest.deserialize(store:get_string("bedrest"), true)
   return loaded
end

----------------------------------------------------
--Break taker
--

local quote_list = {
	"'Sometimes even to live is an act of courage.'\n\n- Seneca",
	"'Humor keeps us alive. Humor and food.\nDon't forget food. You can go a week without laughing.'\n\n- Joss Whedon",
	"'Extinction is the rule.\nSurvival is the exception.'\n\n- Carl Sagan",
	"'You don't drown by falling in the water;\nyou drown by staying there.'\n\n- Edwin Louis Cole",
	"'It has yet to be proven that intelligence has any survival value.'\n\n- Arthur C. Clarke",
	"'If quick, I survive. If not quick, I am lost.'\n\n- Sun Tzu",
	"'That fine line between bravery and stupidity is endlessly debated\n– the difference really doesn’t matter.'\n\n- Bear Grylls",
	"'My approach is to look for what I’m interested in using\nand if it’s there I use it.'\n\n- John Plant",
	"'The only way of discovering the limits of the possible\nis to venture a little way past them into the impossible.'\n\n- Arthur C. Clarke",
	"'The point is not how we use a tool, but how it uses us.'\n\n- Nick Joaquín",
	"'The ultimate goal of farming is not the growing of crops,\nbut the cultivation and perfection of human beings.'\n\n- Masanobu Fukuoka",
	"'Never confuse movement with action.'\n\n- Ernest Hemmingway",
	"'A step backward, after making a wrong turn, is a step in the right direction.'\n\n-Kurt Vonnegut",
	"'If you're going through hell, keep going'\n\n-Winston Churchill",
	"'It is not by muscle, speed, or physical dexterity that great things are achieved,\nbut by reflection, force of character, and judgment.'\n\n- Cicero",
	"'Progress is not an illusion; it happens,\nbut it is slow and invariably disappointing.'\n\n- George Orwell",
	"'Whatever is produced in haste goes hastily to waste.'\n\n- Saadi",
	"'Perhaps nothing is so fraught with significance as the human hand,\nthis oldest tool with which man has dug his way from savagery,\nand with which he is constantly groping forward.'\n\n- Jane Addams",
	"'Any technology distinguishable from magic is insufficiently advanced.'\n\n- Barry Gehm",
	"'Tis but a scratch!'\n\n- The Black Knight.",
	"'Emergencies have always been necessary to progress.'\n\n- Victor Hugo",
	"'I only fear danger where I want to fear it.'\n\n- Franz Kafka",
	"'Fill your bowl to the brim and it will spill.\nKeep sharpening your knife and it will blunt.'\n\n- Lao Tzu",
	"'Artist's need the world.'\n\n- Kazuaki Tanahashi",
	"'Lets build a happy little cloud.\nLets build some happy little trees.'\n\n- Bob Ross",
	"'The mountains are calling and I must go.'\n\n- John Muir",
	"'I like this place and could willingly waste my time in it.'\n\n- William Shakespeare",
	"'Adopt the pace of nature: her secret is patience.'\n\n- Ralph Waldo Emerson",
	"'Nature is pleased with simplicity. And nature is no dummy.'\n\n- Isaac Newton",
	"'There are rules to luck, not everything is chance for the wise;\nluck can be helped by skill.'\n\n- Balthasar Gracian",
	"'Life can only be understood backwards; but it must be lived forwards.'\n\n- Soren Kierkegaard",
	"'All truly great thoughts are conceived while walking.'\n\n- Friedrich Nietzsche",
	"'Learning without thought is labour lost;\nthought without learning is perilous'\n\n- Confucius",
	"'There is scarcely any passion without struggle.'\n\n- Albert Camus",
	"'O snail\nClimb Mount Fuji\nBut slowly, slowly!'\n\n- Kobayashi Issa",
	"'Not all those who wander are lost.'\n\n- Tolkien",
	"'I've never been lost, but I was mighty turned around for three days once.'\n\n- Daniel Boone",
	"'Dripping water hollows out stone,\nnot through force but through persistence.'\n\n- Ovid",
	"'I have not failed. I've just found 10,000 ways that won't work.'\n\n- Thomas Edison",
	"'I'm not afraid of death;\nI just don't want to be there when it happens.'\n\n- Woody Allen",
	"'Reality continues to ruin my life.'\n\n- Bill Watterson",
	"'Give a man a fire and he's warm for a day,\nbut set fire to him and he's warm for the rest of his life.'\n\n- Terry Pratchett",
	"'There's a fine line between genius and insanity.\nI have erased this line.'\n\n- Oscar Levant",
	"'Let's think the unthinkable, let's do the undoable.\nLet us prepare to grapple with the ineffable itself, and see if we may not eff it after all.'\n\n- Douglas Adams",
	"'When we are tired, we are attacked by ideas we conquered long ago.'\n\n- Friedrich Nietzsche",
	"'One cannot think well, love well, sleep well, if one has not dined well.'\n\n- Virginia Woolf",
	"'Do not go gentle into that good night.\nRage, rage against the dying of the light.'\n\n- Dylan Thomas",
	"'If you think you are too small to make a difference,\ntry sleeping with a mosquito.'\n\n- The Dalai Lama",
	"'Each night, when I go to sleep, I die.\nAnd the next morning, when I wake up, I am reborn.'\n\n- Mahatma Gandhi",
	"'Be careful about reading health books.\nSome fine day you'll die of a misprint.'\n\n- Markus Herz",
	"'Let food be thy medicine and medicine be thy food.'\n\n- Hippocrates",
	"'Somewhere, something incredible is waiting to be known.'\n\n- Carl Sagan",
	"'If you wish to make an apple pie from scratch, you must first invent the universe.'\n\n- Carl Sagan",
	"'Time you enjoy wasting is not wasted time.'\n\n- Marthe Troly-Curtin",
	"'They say I'm old-fashioned, and live in the past,\nbut sometimes I think progress progresses too fast!'\n\n- Dr. Seuss",
	"'He who has a strong enough why can bear any how.'\n\n- Friedrich Nietzsche",
	"'The greatest threat to our planet\nis the belief that someone else will save it.'\n\n- Robert Swan",
	"'Life is a struggle and wandering in a foreign country.'\n\n- Marcus Aurelius",
	"'It will be a sinister day when computers start to laugh,\nbecause that will mean they are capable of a lot of other things as well'\n\n- Edward de Bono",
	"'Po converts what might otherwise be taken as madness\ninto a perfectly reasonable illogical procedure.'\n\n- Edward de Bono",
	"'Reed-thatched huts and grass-thatched shelters are essential for protecting the body.\nTo sleep in the open air or in the open fields offends the sun and moon.'\n\n- Chongyang",
	"'On the other hand,\nliving beneath carved beams and high eaves is also not the action of a superior adept.\nGreat palaces and elevated halls,\n— how can these be part of the living plan for followers of the Dao?'\n\n- Chongyang",
	"'Medicinal herbs are the flourishing emanations of mountains and waterways,\nthe essential florescence of plants and trees.'\n\n- Chongyang",
	"'Followers of the Dao join together as companions\nbecause they can assist each other in sickness and disease.\nIf you die, I’ll bury you; if I die, you’ll bury me.'\n\n- Chongyang"
}


local function get_formspec()
	local title = "BREAK TIME!"
	local message1 = "You've been here long enough to justify a real break.\nThink of this as a reminder from your better self.\nGo get some rest. Leave Exile behind. You can come back any time."
	local message2 = minetest.colorize("#aaaa22",
		   "(Disable this notice with /breaktaker off)" )
	local quote = quote_list[math.random(1,#quote_list)]

	local formspec = {
		"size[19.5,13]"..
		"real_coordinates[true]",
		"label[9.375,1.5;", minetest.formspec_escape(title), "]",
		"label[2.375,3.5;", minetest.formspec_escape(message1), "]",
		"label[2.375,7.5;", minetest.formspec_escape(quote), "]",
		"label[12,12.5;", minetest.formspec_escape(message2), "]"
	}

	return table.concat(formspec, "")
end

--check session length and encourage player to take a real break
local function break_taker(name, prefs)
	local ts = bed_rest.session_start[name]
	local sess_l = bed_rest.session_limit[name]
	local tn = os.time()

	local nobreaks = minetest.settings:get('exile_nobreaktaker') or false
	if prefs == "off" or ( prefs == "" and nobreaks == true ) then
	   return
	end

	if os.difftime(tn, ts) > sess_l then
		--show form
		minetest.show_formspec(name, "bed_rest:break_taker", get_formspec())
		minetest.sound_play("bed_rest_breakbell", {to_player = name, gain = 0.8})
		--reset clock, with a diminishing limit
		--if ignored too long it will eventually become a constant nag
		--e.g. 30 + 15 + 7.5 + 3.25 + 1.125 = ~ 1hr max
		bed_rest.session_start[name] = tn
		bed_rest.session_limit[name] = sess_l/2
	end
end


--grab_blanket(inv = clothing_inv, list = "clothing") for removal
-----------------------------------------------------------------
local function wear_blanket(player, donning)
   local name = player:get_player_name()
   local plyrinv = player:get_inventory()
   local frominvl = "cloths"  local toinvl = "main"
   if donning then
      frominvl = "main"
      toinvl = "cloths"
   end
   local cinv = plyrinv:get_list(frominvl)
   local newstack = ItemStack("")
   for i = 1, #cinv do
      local stack = ItemStack(cinv[i])
      if stack:get_count() > 0 then
	 local def = stack:get_definition()
	 if def.groups.blanket and def.groups.blanket > 0 then
	    newstack = ItemStack(def.name)
	    plyrinv:remove_item(frominvl, newstack)
	    break
	 end
      end
   end
   if plyrinv:room_for_item(toinvl, newstack) then
      local tinv = plyrinv:get_list(toinvl)
      local pointer = 0 -- find the last empty slot, put it there, not first
      for i = 1, #tinv do
	 if ItemStack(tinv[i]):item_fits(newstack) then
	    pointer = i
	 end
      end
      newstack:add_item(ItemStack(tinv[pointer]))
      plyrinv:set_stack(toinvl, pointer, newstack)
   elseif donning then -- can't put it on, return it to main inv
      plyrinv:add_item(frominvl, newstack)
   else -- or drop it at our feet if there's no room when taking it off
      local ppos = player:get_pos()
      minetest.item_drop(newstack, player, ppos)
      minetest.chat_send_player(name, "You have no room to hold your blanket, so you drop it.")
      minetest.sound_play("nodes_nature_dig_snappy",
			  {pos = ppos, gain = .8, max_hear_distance = 2})
   end
   clothing:update_temp(player)
   player_api.set_texture(player)
end

-----------------------------------------------------------------
local function get_look_yaw(pos)
	local rotation = minetest.get_node(pos).param2
	if rotation > 3 then
		rotation = rotation % 4 -- Mask colorfacedir values
	end
	if rotation == 1 then
		return pi / 2, rotation
	elseif rotation == 3 then
		return -pi / 2, rotation
	elseif rotation == 0 then
		return pi, rotation
	else
		return 0, rotation
	end
end


-----------------------------------------------------------------
local function lay_down(player, level, pos, bed_pos, state, skip)
	local name = player:get_player_name()
	local hud_flags = player:hud_get_flags()
	local po = player:get_physics_override()

	if not player or not name then
		return
	end

	-- stand up
	if state ~= nil and not state then
	   local p = bed_rest.pos[name] or nil
	   local bedp = bed_rest.bed_position[name] or nil
	   if bedp ~= nil then
	      minetest.get_meta(bedp):set_string("infotext", "")
	   end
	   bed_rest.player[name] = nil
	   bed_rest.bed_position[name] = nil
	   bed_rest.level[name] = nil

		-- skip here to prevent sending player specific changes (used for leaving players)
		if skip then
			return
		end

		if p then
			player:set_pos(p)
		end

		--remove blanket
		wear_blanket(player, false)

		-- physics, eye_offset, etc
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		player_api.player_attached[name] = false
		po.speed = 1
		po.jump = 1
		po.sneak = true
		po.gravity = 1
		player:set_physics_override(po)
		hud_flags.wielditem = true
		player_api.set_animation(player, "stand")

	-- lay down
	else
	   local velo = player:get_velocity()
	   if velo.x ~= 0 then return end
	   if velo.z ~= 0 then return end
		-- Check if bed is occupied
		for nm, other_pos in pairs(bed_rest.bed_position) do
			if vector.distance(bed_pos, other_pos) < 0.1 then
			   minetest.chat_send_player(name, ("This bed is already occupied!"))
			   local meta = minetest.get_meta(bed_pos)
			   if meta:get_string("infotext") == "" then
			      meta:set_string("infotext",
					      nm.."'s bed")
			   end
			   return false
			end
		end
		bed_rest.pos[name] = pos
		bed_rest.bed_position[name] = bed_pos
		bed_rest.player[name] = 1
		bed_rest.level[name] = level
		if not minetest.is_singleplayer() then
		   minetest.get_meta(bed_pos):set_string("infotext",
							 name.."'s bed")
		   minetest.get_node_timer(bed_pos):start(60 * 60 * 24 *
							  days_until_timeout)
		end

		--check with break taker
		break_taker(name,player:get_meta():get_string("BreaktakerPref"))

		--wear a blanket from inventory
		wear_blanket(player, true)

		-- physics, eye_offset, etc
		player:set_eye_offset({x = 0, y = -12, z = 0}, {x = 0, y = -4.5, z = 0})
		local yaw, param2 = get_look_yaw(bed_pos)
		player:set_look_horizontal(yaw)
		local dir = minetest.facedir_to_dir(param2)
		local p = {x = bed_pos.x + dir.x / 2, y = bed_pos.y, z = bed_pos.z + dir.z / 2}
		--clear physics
		player_monoids.speed:del_change(player, "health:physics")
		player_monoids.jump:del_change(player, "health:physics")
		player_monoids.speed:del_change(player, "health:physics_HE")
		player_monoids.jump:del_change(player, "health:physics_HE")
		po.speed = 0
		po.jump = 0
		po.sneak = false
		po.gravity = 0
		player:set_physics_override(po)
		player:set_pos(p)
		player_api.player_attached[name] = true
		hud_flags.wielditem = false
		player_api.set_animation(player, "lay")
	end

	local brtemp = {}
	brtemp.level = bed_rest.level
	brtemp.player = bed_rest.player
	brtemp.pos = bed_rest.pos
	brtemp.bed_position = bed_rest.bed_position

	store:set_string("bedrest", minetest.serialize(brtemp))
	player:hud_set_flags(hud_flags)
end


--------------------------------------------
function bed_rest.on_rightclick(pos, player, level)
	local name = player:get_player_name()
	local ppos = player:get_pos()
	local tod = minetest.get_timeofday()

	if bed_rest.player[name] then
	   lay_down(player, nil, nil, nil, false)
	else
	   -- move to bed
	   lay_down(player, level, ppos, pos)
	end
end


--------------------------------------------
function bed_rest.can_dig(bed_pos, player)
	-- Check all players in bed which one is at the expected position
	for nm, player_bed_pos in pairs(bed_rest.bed_position) do
		if vector.equals(bed_pos, player_bed_pos) then
		   if minetest.check_player_privs(player, "protection_bypass") then
		      --admins can remove old beds
		      bed_rest.bed_position[nm] = nil
		      return true
		   end
		   return false
		end
	end
	return true
end

function bed_rest.on_timer(pos, elapsed)
-- Called after configured timeout to clear bed ownership
   local meta = minetest.get_meta(pos)
   for nm, other_pos in pairs(bed_rest.bed_position) do
      if vector.distance(pos, other_pos) < 0.1 then
	 bed_rest.bed_position[nm] = nil
	 if not minetest.is_singleplayer() then
	    meta:set_string("infotext", nm.."'s bed (old)")
	 end
	 return false
      end
   end
end

--------------------------------------------
--Jump out of bed
local jtimer = 0
minetest.register_globalstep(function(dtime)
      jtimer = jtimer + dtime
      if jtimer > 0.2 then
	 for _, player in ipairs(minetest.get_connected_players()) do
	    local name = player:get_player_name()
	    if bed_rest.player[name] then
	       if math.floor(player:get_player_control_bits() / 16) % 2 == 1 then
		  lay_down(player, nil, nil, nil, false)
	       end
	    end
	 end
	 jtimer = 0
      end
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	local hud_flags = player:hud_get_flags()

	bed_rest.player[name] = nil
	bed_rest.bed_position[name] = nil
	bed_rest.level[name] = nil

	-- physics, eye_offset, etc
	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	player:set_look_horizontal(math.random(1, 180) / 100)
	player_api.player_attached[name] = false
	player:set_physics_override(1, 1, 1)
	hud_flags.wielditem = true
	player_api.set_animation(player, "stand")

end)

--get start time of session
minetest.register_on_joinplayer(function(player)
      local name = player:get_player_name()
        if bed_rest.player[name] then
	 lay_down(player, nil, nil, nil, false)
      end
  bed_rest.session_start[name] = os.time()
  -- 30 minutes is 1800 ticks, so multiply by 60
  bed_rest.session_limit[name] = minetest.settings:get('exile_breaktime') * 60
end
)

--------------------------------------------
minetest.register_chatcommand("breaktaker", {
    params = "on or off",
    description = "Switch the break taker off or on per user",
    func = function(name, param)
       if param == "" or param == "help" then
	  local wlist = "/breaktaker:\n"..
	  "Switch the breaktaker notice off or on for you."
	  return false, wlist
       end
       if param ~= "on" and param ~= "off" then
	  return false, "Valid choices are on or off"
       end
       local player = minetest.get_player_by_name(name)
       local meta = player:get_meta()
       meta:set_string("BreaktakerPref", param)
    end,
})
