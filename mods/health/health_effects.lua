-------------------------------------
--HEALTH EFFECTS
------------------------------------
--[[
Persistent changes e.g. disease, drug trips, venom, parasites


-----------------

Effects are called from malus_bonus when called by main Health function.
This means they are applied slowly.

Can adjust (e.g hunger rate, move speed) and feed these back to malus_bonus
so that they are applied properly in combination with other factors.
Other effects can be called within the effect function.

Triggering events apply the health effect. use check_for_effect

Progression, and ending:
Effects will last forever unless removed or swapped for another
Use remove_effect to end them (with option to swap rather than remove)
 (e.g. for slowly winding up or down severity )
 meta, and effects_list, need to be given as inputs if the function is to do removals etc

Names
A string name is used both for checks and is displayed on Char Tab (Lore)
This string has an associated function.

End probabilities:
if random < X then ...
duration drops of linearly e.g. 0.2 = most times it ends after a few minutes,
but some last up to 20 min

Timers preferable for most things
{name, chance, remove old timer(bool), extend new timer(int)}

default time: 20min = 1 day
roughly 1 min = 1 hr

]]
------------------------------------------------------------------
local random = math.random




-------------------------------------------------------------------
--Timers for ending

--if not will set the timer, save to meta
--returns true if timer already set
local function set_timer(meta, t_name, t_min, t_max)
	--is timer present?
	if not meta:contains(t_name) then
		local duration = random(t_min, t_max)
		meta:set_int(t_name, duration)
		--minetest.chat_send_all("setting: "..t_name.." "..duration)
		return false
	else
		--minetest.chat_send_all("timer present: "..t_name)
		return true
	end
end

--count down the timer
local function do_timer(meta, t_name)
	local time = meta:get_int(t_name)
	time = time - 1

	--minetest.chat_send_all(t_name.." : "..time)
	if time <= 0 then
		meta:set_int(t_name,0)
	else
		meta:set_int(t_name,time)
	end
	return time
end

-------------------------------------------------------------------
--removes matching and updates
local function remove(meta, effects_list, name)
	for i, effect in ipairs(effects_list) do
		if effect == name then
			table.remove(effects_list, i)
		end
	end

	--update HUD number, save
	local num = #effects_list or 0
	meta:set_int("effects_num", num )

	meta:set_string("effects_list", minetest.serialize(effects_list))


end
-------------------------------------------------------------------
--USE THIS to add effects
--CHECK for an pre-existing effect from the list of active effects
--will add the given effect, or an updgraded version
--(e.g. drink more booze get more drunk)
--If effect found it will cancel, or updgrade so not to apply same effect twice.
--block_names = all effects that are variants of the effect (to be blocked)
--(e.g. mild, moderate, severe)
--triples with name and updgrade and chance, no pair means no updgrade
-- e.g. {{"drunk_mild", "drunk_moderate", 0.2}, {"drunk_moderate", "drunk_severe", 0.3}, {"drunk_severe"}}
-- effect name = {name, chance} e.g. {"drunk_mild", 1} = 100% chance of drunk_mild
-- remove_sender = name, for removing an effect despite having no upgrade
-- e.g. hungover severe has nothing higher, but must remove the effect that sent it (drunk severe)

function HEALTH.check_for_effect(player, effect_name, block_names, savmeta, remove_sender)

	--accept saved meta, or get it from player... depends on what calls it
	local meta
	if player then
		meta = player:get_meta()
	elseif savmeta then
		meta = savmeta
	else
		return
	end

	local effects_list = meta:get_string("effects_list")
	effects_list = minetest.deserialize(effects_list) or {}

	--upgrade or block anything that matches existing
	if block_names then
		for i, effect in ipairs(effects_list) do
			--loop through multiple names
			for b, name in ipairs(block_names) do

				--found match
				if effect == name[1] then
					if name[2] and random() < name[3] then
						--remove current and add new
						--effects_list[i] = nil
						table.remove(effects_list, i)
						table.insert(effects_list, name[2])
						--save new list
						meta:set_string("effects_list", minetest.serialize(effects_list))

						--if old effect had a timer associated then it must be turned off
						--or extended
						if name[4] == true then
							meta:set_int(name[1],0)
						elseif name[5] then
							local t = meta:get_int(name[1])
							meta:set_int(name[1], t + name[5])
						end

						if remove_sender then
							remove(meta, effects_list, remove_sender)
						end

						--matched, and changed it, stop looking
						return

					else

						--if old effect had a timer associated then it must be turned off
						--or extended
						if name[4] == true then
							meta:set_int(name[1],0)
						elseif name[5] then
							local t = meta:get_int(name[1])
							meta:set_int(name[1], t + name[5])
						end
						--remove effect if new already exists?
						if remove_sender then
							remove(meta, effects_list, remove_sender)
							return
						else
							return
						end
					end
				end
			end
		end
	end

	--no matches found, so add the effect
	--chance of applying new effect
	if random() < effect_name[2] then

		if remove_sender then
			--e.g. Drunk -> hangover.
			--not currently hung over so no match.
			--but must remove drunk
			remove(meta, effects_list, remove_sender)
		end


		table.insert(effects_list, effect_name[1])
		--update HUD number, save list
		local num = #effects_list
		meta:set_int("effects_num", num )
		meta:set_string("effects_list", minetest.serialize(effects_list))

		return
	end

end


-------------------------------------------------------------------
--REMOVE an effect from the list of active effects
--swap is optional name of another effect to replace it with
--swap will call Check, so needs same input as adding a new effect
--this can mean needing to give it input for situations that ought never happen
--i.e. amounts to telling it to overwrite anything that got doubled up
function HEALTH.remove_effect(meta, effects_list, name, swap, block_names)
	--adding a new effect
	if swap then
		HEALTH.check_for_effect(nil, swap, block_names, meta, name)
		return
	end

	remove(meta, effects_list, name)

end

------------------------------------------------------------------
------------------------------------------------------------------
--COMPONENT EFFECTS

--throw up losing some food and water
local function vomit(player, meta, repeat_min, repeat_max, delay_min, delay_max, t_min, t_max, h_min, h_max )
	--vomit repeatedly after time
	local ranrep = random(repeat_min, repeat_max)

	local randel = 0

	for i=1, ranrep do
		randel = randel + random(delay_min, delay_max)
		minetest.after(randel, function()

			local pos = player:get_pos()
			minetest.sound_play("health_vomit", {pos = pos, gain = 0.5, max_hear_distance = 2})

			rant =  random(t_min, t_max)
			ranh = random(h_min, h_max)

			--must directly set them, as time delay means it isn't feeding into main health loop
			local thirst = meta:get_int("thirst")
			local hunger = meta:get_int("hunger")

			thirst = thirst - rant
			hunger = hunger - ranh
			if thirst < 0 then
				thirst = 0
			end
			if hunger < 0 then
				hunger = 0
			end

			meta:set_int("thirst", thirst)
			meta:set_int("hunger", hunger)
		end)
	end
end


--stagger, make player hard to control
local function stagger(player, repeat_min, repeat_max, delay_min, delay_max, stag)

	local name = player:get_player_name()

	--move erraticly repeatedly after time
	local ranrep = random(repeat_min, repeat_max)
	local randel = 0

	for i=1, ranrep do
		randel = randel + random(delay_min, delay_max)
		minetest.after(randel, function()
			if not bed_rest.player[name] then
				local xr = random(-stag, stag)
				local zr = random(-stag, stag)
				player:add_player_velocity({x=xr, y=0, z=zr})
				--player_api.set_animation(player, "walk", 10) --doesn't work
			end
		end)
	end
end


--organ failure... time to die...
local function organ_failure(player, repeat_min, repeat_max, delay_min, delay_max, dam_min, dam_max)

	local ranrep = random(repeat_min, repeat_max)
	minetest.sound_play("health_heart", {to_player = name, gain = 0.5})

	local randel = 0

	for i=1, ranrep do
		randel = randel + random(delay_min, delay_max)
		minetest.after(randel, function()

			ran_dam =  random(dam_min, dam_max)

			local health = player:get_hp()
			health = health - ran_dam

			if health < 0 then
				health = 0
			elseif health > 20 then
				health = 20
			end

			player:set_hp(health)

		end)
	end
end


--hallucinate
local function auditory_hallucination(player, repeat_min, repeat_max, delay_min, delay_max, min_gain, max_gain)
	--hear things repeatedly after time
	local ranrep = random(repeat_min, repeat_max)
	local name = player:get_player_name()

	local randel = 0

	for i=1, ranrep do
		randel = randel + random(delay_min, delay_max)
		minetest.after(randel, function()

			local pos = player:get_pos()

			pos = {x=pos.x+random(-15,15), y=pos.y+random(-15,15), z=pos.z+random(-15,15)}

			minetest.sound_play("health_hallucinate", {to_player = name, pos = pos, gain = random(min_gain,max_gain)})

		end)
	end
end


--tunnel vision

--collapse


------------------------------------------------------------------
------------------------------------------------------------------
--EFFECTS


------------------------------
--Hangovers, from drunkeness and drugs

--name = "Hangover (mild)"
function HEALTH.hangover_mild(meta, effects_list, mov, jum)
	mov = mov - 2
	jum = jum - 2

	--end chance
	--see if timer is present, if it is count down, if all the way down end
	if set_timer(meta, "Hangover (mild)", 5, 10) then
		if do_timer(meta, "Hangover (mild)") <= 0 then
			HEALTH.remove_effect(meta, effects_list, "Hangover (mild)")
		end
	end

	return mov, jum
end


--name = Hangover (moderate)
function HEALTH.hangover_moderate(meta, effects_list, mov, jum)
	mov = mov - 4
	jum = jum - 4

	--downgrade chance
	if set_timer(meta, "Hangover (moderate)", 5, 10) then
		if do_timer(meta, "Hangover (moderate)") <= 0 then
			local swap = {"Hangover (mild)", 1}
			HEALTH.remove_effect(meta, effects_list, "Hangover (moderate)", swap, nil)
		end
	end


	return mov, jum
end

--name = Hangover (severe)
function HEALTH.hangover_severe(player, meta, effects_list, mov, jum)
	mov = mov - 6
	jum = jum - 6

	--mild staggering
	stagger(player, 1, 5, 1, 5, 3)

	--downgrade chance
	if set_timer(meta, "Hangover (severe)", 5, 10) then
		if do_timer(meta, "Hangover (severe)") <= 0 then
			local swap = {"Hangover (moderate)", 1}
			HEALTH.remove_effect(meta, effects_list, "Hangover (severe)", swap, nil)
		end
	end

	return mov, jum
end


------------------------------
--Alcohol effects

--name = "Drunk (mild)"
function HEALTH.drunk_mild(player, meta, effects_list, r_rate, mov, jum)
	r_rate = r_rate - 1
	mov = mov - 2
	jum = jum - 5

	--mild staggering
	stagger(player, 1, 5, 1, 5, 3)

	--end chance
	if set_timer(meta, "Drunk (mild)", 4, 6) == true then
		if do_timer(meta, "Drunk (mild)") <= 0 then
			local swap = {"Hangover (mild)", 1}
			local block = {
				{"Hangover (mild)", nil, nil, false, 10},
				{"Hangover (moderate)"},
				{"Hangover (severe)"},
			}
			HEALTH.remove_effect(meta, effects_list, "Drunk (mild)", swap, block)
		end
	end

	return r_rate, mov, jum
end


--name = "Drunk (moderate)"
function HEALTH.drunk_moderate(player, meta, effects_list, r_rate, mov, jum)
	r_rate = r_rate - 2
	mov = mov - 5
	jum = jum - 10

	--staggering
	stagger(player, 5, 10, 0.5, 5, 4)

	--downgrade chance
	if set_timer(meta, "Drunk (moderate)", 4, 6) then
		if do_timer(meta, "Drunk (moderate)") <= 0 then
			local swap = {"Hangover (moderate)", 1}
			local block = {
				{"Hangover (mild)","Hangover (moderate)", 1, true},
				{"Hangover (moderate)", nil, nil, false, 10},
				{"Hangover (severe)", nil, nil, false, 10},
			}
			HEALTH.remove_effect(meta, effects_list, "Drunk (moderate)", swap, block)
		end
	end



	return r_rate, mov, jum
end

--name = "Drunk (severe)"
function HEALTH.drunk_severe(player, meta, effects_list, r_rate, mov, jum)
	r_rate = r_rate - 4
	mov = mov - 10
	jum = jum - 15

	--vomit chance
	if random()<0.5 then
		vomit(player, meta, 1, 3, 1, 10, 1, 5, 1, 5 )
	end

	--major staggering
	stagger(player, 30, 60, 0.5, 1, 4)

	--downgrade chance
	if set_timer(meta, "Drunk (severe)", 4, 6) then
		if do_timer(meta, "Drunk (severe)") <= 0 then
			local swap = {"Hangover (severe)", 1}
			local block = {
				{"Hangover (mild)","Hangover (severe)", 1, true},
				{"Hangover (moderate)", "Hangover (severe)", 1, true},
				{"Hangover (severe)", nil, nil, false, 10},
			}
			HEALTH.remove_effect(meta, effects_list, "Drunk (severe)", swap, block)
		end
	end


	return r_rate, mov, jum
end

--name = "Alcohol Poisoning"
function HEALTH.alcohol_poisoning(player, meta, effects_list, r_rate, h_rate, mov, jum, temperature)
	r_rate = r_rate - 4
	h_rate = h_rate - 2
	mov = mov - 20
	jum = jum - 20

	--vomiting and hypothermia
	vomit(player, meta, 1, 5, 1, 10, 5, 10, 5, 10 )

	if temperature >= 34 then
		temperature = temperature - random(1,3)
	end

	--damage
	if random()<0.25 then
		organ_failure(player, 1, 3, 1, 8, 2, 3)
	end

	--major staggering
	stagger(player, 30, 60, 0.5, 1, 4)

	--downgrade chance
	if set_timer(meta, "Alcohol Poisoning", 8, 12) then
		if do_timer(meta, "Alcohol Poisoning") <= 0 then
			local swap = {"Hangover (severe)", 1}
			local block = {
				{"Hangover (mild)","Hangover (severe)", 1, true},
				{"Hangover (moderate)", "Hangover (severe)", 1, true},
				{"Hangover (severe)", nil, nil, false, 10},
			}
			HEALTH.remove_effect(meta, effects_list, "Alcohol Poisoning", swap, block)
		end
	end


	return r_rate, h_rate, mov, jum, temperature
end




----------------------------------
--Food Poisoning
--vomiting, fever, and aches, and may include diarrhea

--name = "Food Poisoning (mild)"
function HEALTH.food_poisoning_mild(player, meta, effects_list, r_rate, mov, jum)
	--slow recovery, movement
	r_rate = r_rate - 1
	mov = mov - 2
	jum = jum - 2

	--some vomiting
	if random()<0.3 then
		vomit(player, meta, 1, 3, 1, 10, 1, 5, 1, 5 )
	end

	--end vs progression
	if set_timer(meta, "Food Poisoning (mild)", 3, 6) == true then
		if do_timer(meta, "Food Poisoning (mild)") <= 0 then
			HEALTH.remove_effect(meta, effects_list, "Food Poisoning (mild)")
		end
	end

	if random()<0.02 then
		local swap = {"Food Poisoning (moderate)", 1}
		HEALTH.remove_effect(meta, effects_list, "Food Poisoning (mild)", swap, nil)
		meta:set_int("Food Poisoning (mild)",0)
	end

	return r_rate, mov, jum
end


--name = "Food Poisoning (moderate)"
function HEALTH.food_poisoning_moderate(player, meta, effects_list, r_rate, mov, jum)
	--slow recovery, movement
	r_rate = r_rate - 2
	mov = mov - 4
	jum = jum - 4

	--some vomiting
	if random()<0.6 then
		vomit(player, meta, 1, 4, 1, 10, 1, 10, 1, 10 )
	end

	--end chance vs progression
	if set_timer(meta, "Food Poisoning (moderate)", 4, 7) == true then
		if do_timer(meta, "Food Poisoning (moderate)") <= 0 then
			HEALTH.remove_effect(meta, effects_list, "Food Poisoning (moderate)")
		end
	end

	if random()<0.02 then
		local swap = {"Food Poisoning (severe)", 1}
		HEALTH.remove_effect(meta, effects_list, "Food Poisoning (moderate)", swap, nil)
		meta:set_int("Food Poisoning (moderate)",0)
	end


	return r_rate, mov, jum
end


--name = "Food Poisoning (severe)"
function HEALTH.food_poisoning_severe(player, meta, effects_list, r_rate, mov, jum, temperature)
	--slow recovery, movement
	r_rate = r_rate - 4
	mov = mov - 20
	jum = jum - 20

	--fever
	if temperature <= 42 then
		temperature = temperature + random(2,3)
	end

	--vomiting
	vomit(player, meta, 1, 5, 1, 10, 5, 10, 5, 10 )

	--mild staggering
	stagger(player, 1, 5, 1, 5, 3)


	--end chance
	if set_timer(meta, "Food Poisoning (severe)", 5, 12) == true then
		if do_timer(meta, "Food Poisoning (severe)") <= 0 then
			HEALTH.remove_effect(meta, effects_list, "Food Poisoning (severe)")
		end
	end

	return r_rate, mov, jum, temperature
end


----------------------------------
--Intestinal Parasites

--name = "Intestinal Parasites"
function HEALTH.intestinal_parasites(meta, effects_list, r_rate, hun_rate)
	--hunger quicker, recover slower
	r_rate = r_rate - 2
	hun_rate = hun_rate - 6

	--end chance
	if random()<0.001 then
		HEALTH.remove_effect(meta, effects_list, "Intestinal Parasites")
	end

	return r_rate, hun_rate
end


----------------------------------
--Tiku Stimulants
--for a crazy drug fueled bender, with a chance of losing control of it

--name = "Tiku High (mild)"
function HEALTH.tiku_mild(player, meta, effects_list, r_rate, hun_rate, mov, jum)
	r_rate = r_rate + 6
	hun_rate = hun_rate - 2
	mov = mov + 24
	jum = jum + 12

	if random()<0.1 then
		auditory_hallucination(player, 1, 3, 3, 10, 0.01, 0.02)
	end


	--end chance vs progression
	if set_timer(meta, "Tiku High (mild)", 5, 15) == true then
		if do_timer(meta, "Tiku High (mild)") <= 0 then
			local swap = {"Hangover (mild)", 1}
			local block = {
				{"Hangover (mild)", nil, nil, false, 20},
				{"Hangover (moderate)"},
				{"Hangover (severe)"},
			}
			HEALTH.remove_effect(meta, effects_list, "Tiku High (mild)", swap, block)
		end
	end

	if random()<0.02 then
		local swap = {"Tiku High (moderate)", 1}
		HEALTH.remove_effect(meta, effects_list, "Tiku High (mild)", swap, nil)
		meta:set_int("Tiku High (mild)",0)
	end

	return r_rate, hun_rate, mov, jum
end


--name = "Tiku High (moderate)"
function HEALTH.tiku_moderate(player, meta, effects_list, r_rate, hun_rate, mov, jum, temperature)
	r_rate = r_rate + 12
	hun_rate = hun_rate - 4
	mov = mov + 36
	jum = jum + 24

	-- mild fever
	if temperature < 38 and random()<0.3 then
		temperature = temperature + random(2,3)
	end

	if random()<0.1 then
		auditory_hallucination(player, 1, 4, 2, 10, 0.02, 0.08)
	end

	--end chance vs progression
	if set_timer(meta, "Tiku High (moderate)", 5, 15) == true then
		if do_timer(meta, "Tiku High (moderate)") <= 0 then
			local swap = {"Hangover (moderate)", 1}
			local block = {
				{"Hangover (mild)","Hangover (moderate)", 1, true},
				{"Hangover (moderate)", nil, nil, false, 20},
				{"Hangover (severe)", nil, nil, false, 20},
			}
			HEALTH.remove_effect(meta, effects_list, "Tiku High (moderate)", swap, block)
		end

	elseif random()<0.03 then
		local swap = {"Tiku High (severe)", 1}
		HEALTH.remove_effect(meta, effects_list, "Tiku High (moderate)", swap, nil)
		meta:set_int("Tiku High (moderate)",0)
	end


	return r_rate, hun_rate, mov, jum, temperature
end


--name = "Tiku High (severe)"
function HEALTH.tiku_severe(player, meta, effects_list, r_rate, hun_rate, mov, jum, temperature)
	r_rate = r_rate + 24
	hun_rate = hun_rate - 8
	mov = mov + 48
	jum = jum + 45

	-- mild fever
	if temperature <= 38 and random()<0.6 then
		temperature = temperature + random(2,3)
	end


	--time to go crazy
	auditory_hallucination(player, 30, 60, 0.4, 1, 0.5, 4)


	--mild staggering
	stagger(player, 1, 5, 1, 5, 3)


	--downgrade chance vs progression
	if set_timer(meta, "Tiku High (severe)", 5, 15) == true then
		if do_timer(meta, "Tiku High (severe)") <= 0 then
			local swap = {"Hangover (severe)", 1}
			local block = {
				{"Hangover (mild)","Hangover (severe)", 1, true},
				{"Hangover (moderate)", "Hangover (severe)", 1, true},
				{"Hangover (severe)", nil, nil, false, 10},
			}
			HEALTH.remove_effect(meta, effects_list, "Tiku High (severe)", swap, block)
		end
		
	elseif random()<0.03 then
		local swap = {"Tiku Overdose", 1}
		HEALTH.remove_effect(meta, effects_list, "Tiku High (severe)", swap, nil)
		meta:set_int("Tiku High (severe)",0)
	end

	return r_rate, hun_rate, mov, jum, temperature
end


--name = "Tiku Overdose"
function HEALTH.tiku_overdose(player, meta, effects_list, r_rate, hun_rate, mov, jum, temperature)
	r_rate = r_rate - 24
	hun_rate = hun_rate - 8
	mov = mov - 5
	jum = jum - 5

	--  fever
	if temperature <= 43 then
		temperature = temperature + random(2,4)
	end

	--time to go crazy
	auditory_hallucination(player, 30, 60, 0.5, 1, 1, 4)


	--major staggering
	stagger(player, 30, 60, 0.5, 1, 4)

	--vomit chance
	if random()<0.75 then
		vomit(player, meta, 1, 3, 1, 10, 1, 5, 1, 5 )
	end

	--damage
	if random()<0.33 then
		organ_failure(player, 1, 5, 1, 8, 1, 2)
	end

	--downgrade chance
	if set_timer(meta, "Tiku Overdose", 5, 15) == true then
		if do_timer(meta, "Tiku Overdose") <= 0 then
			local swap = {"Tiku High (mild)", 1}
			HEALTH.remove_effect(meta, effects_list, "Tiku Overdose", swap, nil)
		end
	end


	return r_rate, hun_rate, mov, jum, temperature
end



----------------------------------
--Neurotoxicity (brain)

--name = "Neurotoxicity"
function HEALTH.neurotoxicity(player, meta, effects_list, mov, jum, h_rate)
	--restrict movement
	mov = mov - 30
	jum = jum - 30

	--major staggering
	stagger(player, 50, 60, 0.3, 1, 4)

	--damage
	if random()<0.25 then
		organ_failure(player, 1, 3, 1, 5, 1, 5)
	end

	--end chance
	if random()<0.1 then
		HEALTH.remove_effect(meta, effects_list, "Neurotoxicity")
	end

	return mov, jum, h_rate
end


----------------------------------
--Hepatotoxicity (liver)

--name = "Hepatotoxicity"
function HEALTH.hepatotoxicity(player, meta, effects_list, mov, jum, r_rate, h_rate )

	--you're fine until you really aren't
	if random()<0.2 then
		vomit(player, meta, 10, 20, 0.75, 3, 1, 5, 20, 40 )
		mov = mov - 30
		jum = jum - 30
		r_rate = r_rate - 30
		h_rate = h_rate - 6
		--damage
		if random()<0.2 then
			organ_failure(player, 1, 2, 1, 5, 5, 8)
		end
	end


	--end chance
	if random()<0.01 then
		HEALTH.remove_effect(meta, effects_list, "Hepatotoxicity")
	end

	return mov, jum, r_rate, h_rate
end

----------------------------------
--Phototoxin (light and skin)

--name = "Photosensitivity"
function HEALTH.photosensitivity(player, meta, effects_list, h_rate, r_rate)

	--exposure to light causes painful reaction
	local pos = player:get_pos()
	pos.y = pos.y + 0.8
	local light = minetest.get_node_light(pos) or 0
	if light >= 13 then
		h_rate = h_rate - 8
		r_rate = r_rate - 30
	end

	--end chance
	if random()<0.01 then
		HEALTH.remove_effect(meta, effects_list, "Photosensitivity")
	end

	return h_rate, r_rate
end


----------------------------------
--Meta-Stim (super powers for a price)
--from artifact

--name = "Meta-Stim"
function HEALTH.meta_stim(player, meta, effects_list, h_rate, r_rate, hun_rate, t_rate)

	h_rate = h_rate + 7
	r_rate = r_rate + 29
	hun_rate = hun_rate + 5
	t_rate = t_rate + 5

	local pos = player:get_pos()
	if pos.y < 200 then
		player_monoids.fly:add_change(player, true, "health:metastim")
		player_monoids.gravity:add_change(player, 0.1, "health:metastim")
		--player_monoids.noclip:add_change(player, true, "health:metastim") --does weird stuff with stagger?
	else
		--no flying into space!
		player_monoids.fly:del_change(player, "health:metastim")
	end

	--I am a GOD!
	minetest.sound_play( {name="health_superpower", gain=1}, {pos=pos, max_hear_distance=20})
	minetest.add_particlespawner({
		amount = 80,
		time = 18,
		minpos = {x=pos.x+7, y=pos.y+7, z=pos.z+7},
		maxpos = {x=pos.x-7, y=pos.y-7, z=pos.z-7},
		minvel = {x = -5,  y = -5,  z = -5},
		maxvel = {x = 5, y = 5, z = 5},
		minacc = {x = -3, y = -3, z = -3},
		maxacc = {x = 3, y = 3, z = 3},
		minexptime = 0.2,
		maxexptime = 1,
		minsize = 0.5,
		maxsize = 2,
		texture = "health_superpower.png",
		glow = 15,
	})

	--cures toxins but have to keep using it to avoid fatal outcome
	HEALTH.remove_effect(meta, effects_list, "Neurotoxicity")
	HEALTH.remove_effect(meta, effects_list, "Hepatotoxicity")
	HEALTH.remove_effect(meta, effects_list, "Tiku Overdose")
	HEALTH.remove_effect(meta, effects_list, "Alcohol Poisoning")

	--risk getting bad reaction
	--cancels out some of the gains, trapping you in the dark
	if random()<0.05 then
		HEALTH.check_for_effect(player, {"Photosensitivity", 1}, {{"Photosensitivity"}})
	end

	--end chance, you die now...
	if random()<0.05 then
		local swap = {"Neurotoxicity", 1}
		local block = {
			{"Neurotoxicity"}
		}

		HEALTH.remove_effect(meta, effects_list, "Meta-Stim", swap, block)

		player_monoids.fly:del_change(player, "health:metastim")
		player_monoids.gravity:del_change(player, "health:metastim")
		--player_monoids.noclip:del_change(player, "health:metastim")
	end

	return h_rate, r_rate, hun_rate, t_rate
end

----------------------------------
--Stimulant addiction, withdrawal



----------------------------------
--Enterotoxin (gut)
--Cytotoxin (all cells)
--Necrotoxin (necrotizing)
--Myotoxin (muscles)


----------------------------------
--indigestion (eat too much and throw up)?
--infection
--venom
--radiation
--plague
--trench foot/fungal infection


-------------------------------------------------------------------
