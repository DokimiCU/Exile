-------------------------------------
--HEALTH EFFECTS
------------------------------------
--[[
Persistent changes e.g. disease, drug trips, venom, parasites

Names
A string name is used both for checks and is displayed on Char Tab (Lore)
This string has an associated function.

Effects List:
Stored as string in the player meta. {{name, order},{name2, order},... }

Run health function:
Applies the health effect. Returns modifiers to main helath loop, runs
other health processes (e.g. vomiting, staggering). Checks for internal means
of progression or ending (timers, chance).
Called by malus_bonus (i.e. the players internal metabolism)


Triggers for adding:
e.g. from eating, getting bitten, ...
update_list_add_new,

Triggers for swapping or removal
-Internal:
	- on_timer:
	- chance:
	- conditional:
-external: something outside the disease process itself e.g eat item.


each health effect has its three functions:
- one for adding symptoms and calls for internal adding, swapping, removing (e.g. due to timers)
- progression: for adding, worsening effects. Called internally and can be called externally (e.g.  when eating items).
- regression: for removing, lessening effects. Ditto
(can use defaults for progress and regress)

Any new effect must be listed in:
- do_effects_list (so it can be run at all)
- HEALTH.remove_new_effect (so it can be removed externally - not everything will need this)
- HEALTH.add_new_effect (so it can be added)


component effects:
various minor effects (symptoms) shared by many diseases (e.g. vomiting). Called by the health effects internal function



]]


local random = math.random

------------------------------------------------------------------
--COMPONENT EFFECTS
------------------------------------------------------------------


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

			local rant =  random(t_min, t_max)
			local ranh = random(h_min, h_max)

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

			local ran_dam =  random(dam_min, dam_max)

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








---------------------------------------------------------------------------
--Timers for ending:
---------------------------------------------------------------------------


--if not set will set the timer, save to meta
--otherwise it will tick down
--if zero it will return true so progression can take place
local function do_timer(meta, t_name, t_min, t_max)
	--is timer present?
	if not meta:contains(t_name) then
		local duration = random(t_min, t_max)
		meta:set_int(t_name, duration)
		return false
	else
		--count down
		local time = meta:get_int(t_name)
		time = time - 1
		if time <= 0 then
			meta:set_int(t_name,0)
			return true
		else
			meta:set_int(t_name,time)
			return false
		end
	end
end


--add (or subtract) to the value for a timer that already exists
local function extend_timer(meta, t_name, t_min, t_max)

	local time = meta:get_int(t_name)
	local duration = random(t_min, t_max)
	time = time + duration

	if time <= 0 then
		time = 0
	end
	meta:set_int(t_name,time)

end

--end timer, e.g. when removing an effect
local function end_timer(meta, t_name)
	local time = meta:get_int(t_name)
	meta:set_int(t_name,0)
end


---------------------------------------------------------------------------
--Update Effects List
---------------------------------------------------------------------------
--swap an effect that currently exists, including swap to nil
--finds given effect, removes it and replaces it (optional)
-- name e.g. "Food Poisoning" (the general type of effect)
--replace is the table inserted e.g. {"Food Poisoning", 2}
local function update_list_swap(meta, effects_list, name, replace)

	for i, effect in ipairs(effects_list) do
		if effect[1] == name then
			table.remove(effects_list, i)
		end
	end

	--replace
	if replace then
		table.insert(effects_list, replace)
	end

	-- update HUD number, save
	local num = #effects_list or 0
	meta:set_int("effects_num", num )

	meta:set_string("effects_list", minetest.serialize(effects_list))

end

---------------------------------------------------------------------------
--RUN health functions:
---------------------------------------------------------------------------
--Default progression and regression, for effects with timers
local function default_timer_progress(effect_name, t_min, t_max, max_order, c_boost, meta, effects_list, current_order, added_order, internal)

	--was called internally so can skip comparisons (it will be higher)
	if internal == true then
		update_list_swap(meta, effects_list, effect_name, {effect_name, added_order})
		extend_timer(meta, effect_name, t_min, t_max)
		return
	end

	--current order vs the order of what we are trying to add
	--higher replaces lower, and extends the timer.
	if current_order < added_order then
		update_list_swap(meta, effects_list, effect_name, {effect_name, added_order})
		extend_timer(meta, effect_name, t_min, t_max)

	else
		--lower and equal extends the timer
		extend_timer(meta, effect_name, t_min, t_max)
		--with chance to increase severity
		if current_order < max_order and random() < c_boost then
			current_order = current_order + 1
			if current_order > max_order then
				 current_order = max_order
			 end
			update_list_swap(meta, effects_list, effect_name, {effect_name, current_order})
		end
	end
end


local function default_timer_regress(player, effect_name, t_min, t_max, meta, effects_list, current_order, removed_order, replace_nil, internal)
	--was called internally so can skip comparisons
	if internal == true then
		if current_order <= 0 then
			--remove from effects list
			update_list_swap(meta, effects_list, effect_name)
			end_timer(meta, effect_name)

			if replace_nil then
				--swtich to a different effect rather than nothing
				HEALTH.add_new_effect(player, replace_nil)
			end

		else
			--swap with new lower value
			update_list_swap(meta, effects_list, effect_name, {effect_name, current_order})
			extend_timer(meta, effect_name, t_min, t_max)
		end
		return
	end

	--current order vs the order of what we are trying to remove
	if current_order > removed_order then
		--trying to remove lower than current (i.e. not powerful enough)
		--chance it does some small help
		if random() <0.1 then
			extend_timer(meta, effect_name, -t_max, -t_min)
		end
	else
		--removing higher or equal than current (i.e. effective treatment)
		--lower the order
		local order = current_order - 1
		if order <= 0 then
			--remove from effects list
			update_list_swap(meta, effects_list, effect_name)
			end_timer(meta, effect_name)
			if replace_nil then
				--swtich to a different effect rather than nothing
				HEALTH.add_new_effect(player, replace_nil)
			end
		else
			--swap with new lower value
			update_list_swap(meta, effects_list, effect_name, {effect_name, order})
			extend_timer(meta, effect_name, t_min, t_max)
		end
	end


end


----------------------------------
--Food Poisoning
--[[
effect_name = "Food Poisoning"

Ate something bad.
vomiting, fever, etc

]]


function HEALTH.food_poisoning(order, player, meta, effects_list, r_rate, mov, jum, temperature)

	--APPLY SYMPTOMS
	if order == 1 then
		--slow recovery, movement
		r_rate = r_rate - 1
		mov = mov - 2
		jum = jum - 2
		--some vomiting
		if random()<0.3 then
			vomit(player, meta, 1, 3, 1, 10, 1, 5, 1, 5 )
		end

	elseif order == 2 then
		--slow recovery, movement
		r_rate = r_rate - 2
		mov = mov - 4
		jum = jum - 4
		--some vomiting
		if random()<0.6 then
			vomit(player, meta, 1, 4, 1, 10, 1, 10, 1, 10 )
		end

	elseif order == 3 then
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

	elseif order == 4 then
		--slow recovery, movement
		r_rate = r_rate - 8
		mov = mov - 30
		jum = jum - 30
		--fever
		if temperature <= 42 then
			temperature = temperature + random(2,3)
		end
		--vomiting
		vomit(player, meta, 5, 10, 1, 10, 5, 10, 5, 10 )
		--mild staggering
		stagger(player, 1, 5, 1, 5, 3)
	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Food Poisoning", 3, 6) == true then
		--small chance of worsening, otherwise recover

		if random()<0.1 then
			local added_order = order + 1
			if added_order > 4 then
				added_order = 4
			end
			--food_poisoning_progress(meta, effects_list, order, added_order, true)
			default_timer_progress("Food Poisoning", 3, 6, 4, 0.2, meta, effects_list, current_order, added_order, true)
		else
			--food_poisoning_regress(meta, effects_list, order-1, nil, true)
			default_timer_regress(player, "Food Poisoning", 3, 6, meta, effects_list, order-1, nil, nil, true)
		end

	end

	--send back modified values
	return r_rate, mov, jum, temperature

end


----------------------------------
--Fungal Infection
--[[
effect_name = "Fungal Infection"
Soil fungus got into your skin. Something vaguely like Mycetoma.
For Exile, you get it from wet soil, a reason not to live in a mud hole.
]]

function HEALTH.fungal_infection(order, player, meta, effects_list, r_rate, mov, jum, temperature)

	--APPLY SYMPTOMS
	if order == 1 then
		--slow recovery, movement
		r_rate = r_rate - 1
		mov = mov - 1
		jum = jum - 1

	elseif order == 2 then
		--slow recovery, movement
		r_rate = r_rate - 2
		mov = mov - 2
		jum = jum - 2

	elseif order == 3 then
		--slow recovery, movement
		r_rate = r_rate - 4
		mov = mov - 8
		jum = jum - 8

	elseif order == 4 then
		--slow recovery, movement
		r_rate = r_rate - 8
		mov = mov - 16
		jum = jum - 16
		--fever
		if temperature <= 39 then
			temperature = temperature + 1
		end

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Fungal Infection", 6, 12) == true then
		--small chance of worsening, otherwise recover
		if random()<0.1 then
			local added_order = order + 1
			if added_order > 4 then
				added_order = 4
			end
			default_timer_progress("Fungal Infection", 6, 12, 4, 0.2, meta, effects_list, current_order, added_order, true)
		else
			default_timer_regress(player, "Fungal Infection", 6, 12, meta, effects_list, order-1, nil, nil, true)
		end

	end

	--send back modified values
	return r_rate, mov, jum, temperature

end

----------------------------------
--Dust Fever
--[[
effect_name = "Dust Fever"
Dust storm born soil fungus got into your lungs. Something vaguely like Valley Fever.

]]

function HEALTH.dust_fever(order, player, meta, effects_list, r_rate, mov, jum, temperature)

	--APPLY SYMPTOMS
	if order == 1 then
		--slow recovery, movement
		r_rate = r_rate - 4
		jum = jum - 1
		--fever
		if temperature <= 39 then
			temperature = temperature + 1
		end

	elseif order == 2 then
		--slow recovery, movement
		r_rate = r_rate - 8
		mov = mov - 1
		jum = jum - 2
		--fever
		if temperature <= 39 then
			temperature = temperature + 1
		end

	elseif order == 3 then
		--slow recovery, movement
		r_rate = r_rate - 16
		mov = mov - 2
		jum = jum - 4
		--fever
		if temperature <= 40 then
			temperature = temperature + 1
		end

	elseif order == 4 then
		--slow recovery, movement
		r_rate = r_rate - 32
		mov = mov - 4
		jum = jum - 8
		--fever
		if temperature <= 41 then
			temperature = temperature + 1
		end

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Dust Fever", 6, 12) == true then
		--small chance of worsening, otherwise recover
		if random()<0.1 then
			local added_order = order + 1
			if added_order > 4 then
				added_order = 4
			end
			default_timer_progress("Dust Fever", 6, 12, 4, 0.2, meta, effects_list, current_order, added_order, true)
		else
			default_timer_regress(player, "Dust Fever", 6, 12, meta, effects_list, order-1, nil, nil, true)
		end

	end

	--send back modified values
	return r_rate, mov, jum, temperature

end


----------------------------------
--Drunkeness
--[[
effect_name = "Drunk"
Alcohol intoxication. Stumble around. Extreme level is alcohol poisoning

]]


function HEALTH.drunk(order, player, meta, effects_list, r_rate, mov, jum, h_rate, temperature)
	local max_drunk = meta:get_int("max_hangover") or 0
	--APPLY SYMPTOMS
	if order == 1 then
		if max_drunk < 1 then
			max_drunk = 1
			meta:set_int("max_hangover", max_drunk)
		end

		r_rate = r_rate - 1
		mov = mov - 2
		jum = jum - 5
		--mild staggering
		stagger(player, 1, 5, 1, 5, 3)

	elseif order == 2 then
		if max_drunk < 2 then
			max_drunk = 2
			meta:set_int("max_hangover", max_drunk)
		end

		r_rate = r_rate - 2
		mov = mov - 5
		jum = jum - 10
		--staggering
		stagger(player, 5, 10, 0.5, 5, 4)

	elseif order == 3 then
		if max_drunk < 3 then
			max_drunk = 3
			meta:set_int("max_hangover", max_drunk)
		end

		r_rate = r_rate - 4
		mov = mov - 10
		jum = jum - 15
		--vomit chance
		if random()<0.5 then
			vomit(player, meta, 1, 3, 1, 10, 1, 5, 1, 5 )
		end
		--major staggering
		stagger(player, 30, 60, 0.5, 1, 4)

	elseif order == 4 then
		if max_drunk < 4 then
			max_drunk = 4
			meta:set_int("max_hangover", max_drunk)
		end

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

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Drunk", 3, 6) == true then
		order = order - 1
		-- recover with a hangover that matches most extreme point achieved
		default_timer_regress(player, "Drunk", 3, 6, meta, effects_list, order, nil, {"Hangover", max_drunk}, true)

		--reset to zero
		if order <= 0 then
			meta:set_int("max_hangover", 0)
		end
	end

	--send back modified values
	return r_rate, mov, jum, h_rate, temperature

end

----------------------------------
--Hangover
--[[
effect_name = "Hangover"
After effects of drugs and alcohol

]]

function HEALTH.hangover(order, player, meta, effects_list, mov, jum )

	--APPLY SYMPTOMS
	if order == 1 then
		mov = mov - 2
		jum = jum - 2

	elseif order == 2 then
		mov = mov - 4
		jum = jum - 4

	elseif order == 3 then
		mov = mov - 6
		jum = jum - 6
		--mild staggering
		stagger(player, 1, 5, 1, 5, 3)

	elseif order == 4 then
		mov = mov - 8
		jum = jum - 8
		--mild staggering
		stagger(player, 1, 5, 1, 5, 3)

	end

	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Hangover", 4, 8) == true then
		order = order - 1
		-- recover
		default_timer_regress(player, "Hangover", 4, 8, meta, effects_list, order, nil, nil, true)

	end

	--send back modified values
	return mov, jum

end


----------------------------------
--Intestinal Parasites
--[[
effect_name = "Intestinal Parasites"
Gut worms etc. Increased hunger.

]]


function HEALTH.intestinal_parasites(order, player, meta, effects_list, r_rate, hun_rate)
	--no orders, or progression.
	--you get them, then hope they go away (or cure them)
	--hunger quicker, recover slower
	r_rate = r_rate - 2
	hun_rate = hun_rate - 6

	--end chance
	if random()<0.001 then
		update_list_swap(meta, effects_list, "Intestinal Parasites")
	end

	--send back modified values
	return r_rate, hun_rate

end



----------------------------------
--Tiku Stimulants
--[[
effect_name = "Tiku High"
For a crazy drug fueled bender, with a chance of losing control of it.
Extreme is an overdose

]]


function HEALTH.tiku_high(order, player, meta, effects_list, r_rate, hun_rate, mov, jum, temperature)
	local max_drunk = meta:get_int("max_hangover") or 0
	--APPLY SYMPTOMS
	if order == 1 then
		if max_drunk < 1 then
			max_drunk = 1
			meta:set_int("max_hangover", max_drunk)
		end

		r_rate = r_rate + 6
		hun_rate = hun_rate - 2
		mov = mov + 24
		jum = jum + 12
		if random()<0.1 then
			auditory_hallucination(player, 1, 3, 3, 10, 0.01, 0.02)
		end

	elseif order == 2 then
		if max_drunk < 2 then
			max_drunk = 2
			meta:set_int("max_hangover", max_drunk)
		end
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


	elseif order == 3 then
		if max_drunk < 3 then
			max_drunk = 3
			meta:set_int("max_hangover", max_drunk)
		end
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


	elseif order == 4 then
		if max_drunk < 4 then
			max_drunk = 4
			meta:set_int("max_hangover", max_drunk)
		end
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

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Tiku High", 6, 12) == true then
		--small chance of worsening, otherwise recover
		if random()<0.1 then
			local added_order = order + 1
			if added_order > 4 then
				added_order = 4
			end
			default_timer_progress("Tiku High", 3, 6, 3, 0.2, meta, effects_list, current_order, added_order, true)
		else
			order = order - 1
			-- recover with a hangover that matches most extreme point achieved
			default_timer_regress(player, "Tiku High", 3, 6, meta, effects_list, order, nil, {"Hangover", max_drunk}, true)

			--reset to zero
			if order <= 0 then
				meta:set_int("max_hangover", 0)
			end
		end
	end

	--send back modified values
	return r_rate, hun_rate, mov, jum, temperature

end


----------------------------------
--Neurotoxicity (brain)
--[[
effect_name = "Neurotoxicity"
 nerve poison. staggering, movement problems, death

]]

function HEALTH.neurotoxicity(order, player, meta, effects_list, mov, jum)

	--APPLY SYMPTOMS
	if order == 1 then
		--restrict movement
		mov = mov - 7
		jum = jum - 7
		--major staggering
		stagger(player, 10, 15, 0.3, 1, 4)

	elseif order == 2 then
		--restrict movement
		mov = mov - 15
		jum = jum - 15
		--major staggering
		stagger(player, 20, 30, 0.3, 1, 4)
		--damage
		if random()<0.05 then
			organ_failure(player, 1, 3, 1, 5, 1, 5)
		end

	elseif order == 3 then
		--restrict movement
		mov = mov - 30
		jum = jum - 30
		--major staggering
		stagger(player, 50, 60, 0.3, 1, 4)
		--damage
		if random()<0.25 then
			organ_failure(player, 1, 3, 1, 5, 1, 5)
		end

	elseif order == 4 then
		--restrict movement
		mov = mov - 30
		jum = jum - 30
		--major staggering
		stagger(player, 50, 60, 0.3, 1, 4)
		--damage
		organ_failure(player, 1, 3, 1, 5, 1, 5)

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Neurotoxicity", 6, 12) == true then
		-- recover
		default_timer_regress(player, "Neurotoxicity", 3, 6, meta, effects_list, order-1, nil, nil, true)

	end

	--send back modified values
	return mov, jum

end



----------------------------------
--Hepatotoxicity (liver)
--[[
effect_name = "Hepatotoxicity"
liver poison. vomiting, death

]]
function HEALTH.hepatotoxicity(order, player, meta, effects_list, mov, jum, r_rate, h_rate)

	--APPLY SYMPTOMS
	--you're fine until you really aren't
	if random()<0.3 then

		if order == 1 then
			vomit(player, meta, 2, 6, 0.75, 3, 1, 2, 5, 10 )
			mov = mov - 7
			jum = jum - 7
			r_rate = r_rate - 7
			h_rate = h_rate - 1
			--damage
			if random()<0.05 then
				organ_failure(player, 1, 2, 1, 5, 5, 8)
			end

		elseif order == 2 then
			vomit(player, meta, 5, 10, 0.75, 3, 1, 5, 10, 20 )
			mov = mov - 15
			jum = jum - 15
			r_rate = r_rate - 15
			h_rate = h_rate - 3
			--damage
			if random()<0.25 then
				organ_failure(player, 1, 2, 1, 5, 5, 8)
			end

		elseif order == 3 then
			vomit(player, meta, 10, 20, 0.75, 3, 1, 5, 20, 40 )
			mov = mov - 30
			jum = jum - 30
			r_rate = r_rate - 30
			h_rate = h_rate - 6
			--damage
			if random()<0.5 then
				organ_failure(player, 1, 2, 1, 5, 5, 8)
			end

		elseif order == 4 then
			vomit(player, meta, 10, 20, 0.75, 3, 2, 10, 40, 60 )
			mov = mov - 30
			jum = jum - 30
			r_rate = r_rate - 60
			h_rate = h_rate - 6
			--damage
			organ_failure(player, 1, 2, 1, 5, 5, 8)

		end

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Hepatotoxicity", 6, 12) == true then
		-- recover
		default_timer_regress(player, "Hepatotoxicity", 6, 12, meta, effects_list, order-1, nil, nil, true)

	end

	--send back modified values
	return mov, jum, r_rate, h_rate

end


----------------------------------
--Phototoxin (light and skin)
--[[
effect_name =  "Photosensitivity"
Light sensitivity
i.e. you are coming up in blisters if exposed to sun
]]

function HEALTH.photosensitivity(order, player, meta, effects_list, h_rate, r_rate )

	--APPLY SYMPTOMS
	--you're fine unless in the sun
	local pos = player:get_pos()
	pos.y = pos.y + 0.8
	local light = minetest.get_node_light(pos) or 0
	if light >= 13 then

		if order == 1 then
			h_rate = h_rate - 3
			r_rate = r_rate - 8
			stagger(player, 1, 2, 1, 5, 1)

		elseif order == 2 then
			h_rate = h_rate - 6
			r_rate = r_rate - 12
			stagger(player, 1, 3, 1, 5, 1)

		elseif order == 3 then
			h_rate = h_rate - 12
			r_rate = r_rate - 24
			stagger(player, 1, 2, 1, 5, 1)

		elseif order == 4 then
			h_rate = h_rate - 9
			r_rate = r_rate - 48
			stagger(player, 1, 4, 1, 5, 1)
		end

	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Photosensitivity", 12, 24) == true then
		-- recover
		default_timer_regress(player, "Photosensitivity", 12, 24, meta, effects_list, order-1, nil, nil, true)

	end

	--send back modified values
	return h_rate, r_rate

end

----------------------------------
--Meta-Stim
--[[
effect_name =  Meta-Stim
from artifact. Super powers for a price.
Increasing powers unlocked the more you inject.
A slight bit of a techno-vampire vibe

]]


function HEALTH.meta_stim(order, player, meta, effects_list, h_rate, r_rate, hun_rate, t_rate)
	local max_metastim = meta:get_int("max_metastim") or 0


	--only applies effect if not in bright light
	local pos = player:get_pos()
	pos.y = pos.y + 0.8
	local light = minetest.get_node_light(pos) or 0
	if light <= 14 then


		--APPLY SYMPTOMS
		if order == 1 then
			if max_metastim < 1 then
				max_metastim = 1
				meta:set_int("max_metastim", max_metastim)
			end

			--Get boosters
			h_rate = h_rate + 8
			r_rate = r_rate + 32
			hun_rate = hun_rate + 5
			t_rate = t_rate + 5


		elseif order == 2 then
			if max_metastim < 2 then
				max_metastim = 2
				meta:set_int("max_metastim", max_metastim)
			end

			--Get boosters
			h_rate = h_rate + 16
			r_rate = r_rate + 64
			hun_rate = hun_rate + 10
			t_rate = t_rate + 10

			--cures mild ailments
			HEALTH.remove_new_effect(player, {"Food Poisoning", 2})
			HEALTH.remove_new_effect(player, {"Dust Fever", 2})
			HEALTH.remove_new_effect(player, {"Fungal Infection", 2})
			HEALTH.remove_new_effect(player, {"Hangover", 2})
			HEALTH.remove_new_effect(player, {"Intestinal Parasites"})



		elseif order == 3 then
			if max_metastim < 3 then
				max_metastim = 3
				meta:set_int("max_metastim", max_metastim)
			end

			--Get boosters
			h_rate = h_rate + 32
			r_rate = r_rate + 128
			hun_rate = hun_rate + 20
			t_rate = t_rate + 20

			--cures serious ailments
			HEALTH.remove_new_effect(player, {"Food Poisoning", 4})
			HEALTH.remove_new_effect(player, {"Dust Fever", 4})
			HEALTH.remove_new_effect(player, {"Fungal Infection", 4})
			HEALTH.remove_new_effect(player, {"Drunk", 4})
			HEALTH.remove_new_effect(player, {"Hangover", 4})
			HEALTH.remove_new_effect(player, {"Intestinal Parasites"})
			HEALTH.remove_new_effect(player, {"Tiku High", 4})
			HEALTH.remove_new_effect(player, {"Neurotoxicity", 4})
			HEALTH.remove_new_effect(player, {"Hepatotoxicity", 4})


		elseif order == 4 then
			if max_metastim < 4 then
				max_metastim = 4
				meta:set_int("max_metastim", max_metastim)
			end


			--Get boosters
			h_rate = h_rate + 32
			r_rate = r_rate + 128
			hun_rate = hun_rate + 20
			t_rate = t_rate + 20

			--cures serious ailments
			HEALTH.remove_new_effect(player, {"Food Poisoning", 4})
			HEALTH.remove_new_effect(player, {"Dust Fever", 4})
			HEALTH.remove_new_effect(player, {"Fungal Infection", 4})
			HEALTH.remove_new_effect(player, {"Drunk", 4})
			HEALTH.remove_new_effect(player, {"Hangover", 4})
			HEALTH.remove_new_effect(player, {"Intestinal Parasites"})
			HEALTH.remove_new_effect(player, {"Tiku High", 4})
			HEALTH.remove_new_effect(player, {"Neurotoxicity", 4})
			HEALTH.remove_new_effect(player, {"Hepatotoxicity", 4})


			--Achieve God like powers
			if pos.y < 200 then
				player_monoids.fly:add_change(player, true, "health:metastim")
				player_monoids.gravity:add_change(player, 0.1, "health:metastim")
				--player_monoids.noclip:add_change(player, true, "health:metastim") --does weird stuff with stagger?
			else
				--no flying into space!
				player_monoids.fly:del_change(player, "health:metastim")
				player_monoids.gravity:del_change(player, "health:metastim")
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


		end

	else
		--in bright light

		--can't fly
		player_monoids.fly:del_change(player, "health:metastim")
		player_monoids.gravity:del_change(player, "health:metastim")

		--get photosensitivity
		if order == 1 then
			HEALTH.add_new_effect(player, {"Photosensitivity", 1})
		elseif order == 2 then
			HEALTH.add_new_effect(player, {"Photosensitivity", 2})
		elseif order == 3 then
			HEALTH.add_new_effect(player, {"Photosensitivity", 3})
		elseif order == 4 then
			HEALTH.add_new_effect(player, {"Photosensitivity", 4})
		end



	end


	--PROGRESSION (timers, conditionals, chance)
	if do_timer(meta, "Meta-Stim", 12, 24) == true then
		order = order - 1
		-- end with a toxic hangover that matches most extreme point achieved
		default_timer_regress(player, "Meta-Stim", 12, 24, meta, effects_list, order, nil, {"Neurotoxicity", max_metastim}, true)

		--reset to zero
		if order <= 0 then
			meta:set_int("max_metastim", 0)
			player_monoids.fly:del_change(player, "health:metastim")
			player_monoids.gravity:del_change(player, "health:metastim")
			--player_monoids.noclip:del_change(player, "health:metastim")
		end
	end

	--send back modified values
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
--venom (requires duplicating chains of stuff from mobkit just to add one line to attacking??)
--radiation
--plague
--trench foot
--frost bite



-------------------------------------------------------------------
--ADD/REMOVE NEW
-------------------------------------------------------------------
--add a new effect
--if it finds the effect currently in place, it must know how to progress it.
--this is specific to each health effect so must call that function
function HEALTH.add_new_effect(player, name)

	local meta = player:get_meta()
	local effects_list = meta:get_string("effects_list")
	effects_list = minetest.deserialize(effects_list) or {}

	--effect already present. call function to decide how to progress it
	for i, effect in ipairs(effects_list) do

		if effect[1] == name[1] then

			--min timer, max timer (for extensions), max order, chance of adding an equal or lower boosting to a higher order
			if name[1] == "Food Poisoning" then
				default_timer_progress("Food Poisoning", 3, 6, 4, 0.2, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Fungal Infection" then
				default_timer_progress("Fungal Infection", 6, 12, 4, 0.2, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Dust Fever" then
				default_timer_progress("Dust Fever", 6, 12, 4, 0.2, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Drunk" then
				default_timer_progress("Drunk", 3, 6, 4, 0.2, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Hangover" then
				default_timer_progress("Hangover", 4, 8, 4, 0.4, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Intestinal Parasites" then
				--no progression, only need to block it
				return
			elseif name[1] == "Tiku High" then
				default_timer_progress("Tiku High", 3, 6, 4, 0.3, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Neurotoxicity" then
				default_timer_progress("Neurotoxicity", 3, 6, 4, 0.75, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Hepatotoxicity" then
				default_timer_progress("Hepatotoxicity", 6, 12, 4, 0.75, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Photosensitivity" then
				default_timer_progress("Photosensitivity", 12, 24, 4, 0.1, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Meta-Stim" then
				default_timer_progress("Meta-Stim", 12, 24, 4, 1, meta, effects_list, effect[2], name[2])
			end


			return
		end
	end


	--doesn't currently exist, so add and update HUD, list
	table.insert(effects_list, name)
	local num = #effects_list or 0
	meta:set_int("effects_num", num )
	meta:set_string("effects_list", minetest.serialize(effects_list))

end



--Remove a new effect
--(new in the sense that we don't know if it is actually on or not)
--if it finds the effect currently in place, it must know how to regress it.
--this is specific to each health effect so must call that function
function HEALTH.remove_new_effect(player, name)

	local meta = player:get_meta()
	local effects_list = meta:get_string("effects_list")
	effects_list = minetest.deserialize(effects_list) or {}

	--effect is present. call function to decide how to regress it
	for i, effect in ipairs(effects_list) do

		if effect[1] == name[1] then
			--min timer, max timer,
			if name[1] == "Food Poisoning" then
				default_timer_regress(player, "Food Poisoning", 3, 6, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Fungal Infection" then
				default_timer_regress(player, "Fungal Infection", 6, 12, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Dust Fever" then
				default_timer_regress(player, "Dust Fever", 6, 12, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Drunk" then
				default_timer_regress(player, "Drunk", 3, 6, meta, effects_list, effect[2], name[2], {"Hangover", meta:get_int("max_hangover") or 1})
			elseif name[1] == "Hangover" then
				default_timer_regress(player, "Hangover", 4, 8, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Intestinal Parasites" then
				update_list_swap(meta, effects_list, "Intestinal Parasites")
			elseif name[1] == "Tiku High" then
				default_timer_regress(player, "Tiku High", 3, 6, meta, effects_list, effect[2], name[2], {"Hangover", meta:get_int("max_hangover") or 1})
			elseif name[1] == "Neurotoxicity" then
				default_timer_regress(player, "Neurotoxicity", 3, 6, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Hepatotoxicity" then
				default_timer_regress(player, "Hepatotoxicity", 6, 12, meta, effects_list, effect[2], name[2])
			elseif name[1] == "Photosensitivity" then
				default_timer_regress(player, "Photosensitivity", 12, 24, meta, effects_list, effect[2], name[2])
			--elseif name[1] == "Meta-Stim" then
			--note, this wont remove flying effects. Not needed at this point,
			-- but will need something better if want to have an item that removes meta-stim
			--	default_timer_regress(player, "Meta-Stim", 12, 24, meta, effects_list, effect[2], name[2], {"Neurotoxicity", meta:get_int("max_metastim") or 1})

			end

		end
	end


	--Otherwise doesn't currently exist, so nothing to do...

end


-------------------------------------------------------------------
--TEST!!!!
-------------------------------------------------------------------
--[[
minetest.register_craftitem("health:bug_test_food", {
	description = "Bug TESTING FOOD",
	inventory_image = "tech_vegetable_oil.png",
	stack_max = 500,
	groups = {flammable = 1},


  on_use = function(itemstack, user, pointed_thing)

		--HEALTH.add_new_effect(user, {"Food Poisoning", 1})
		--HEALTH.add_new_effect(user, {"Drunk", 1})
		--HEALTH.add_new_effect(user, {"Intestinal Parasites"})
		--HEALTH.add_new_effect(user, {"Tiku High", 1})
		--HEALTH.add_new_effect(user, {"Neurotoxicity", 1})
		--HEALTH.add_new_effect(user, {"Hepatotoxicity", 1})
		--HEALTH.add_new_effect(user, {"Photosensitivity", 1})
		--HEALTH.add_new_effect(user, {"Meta-Stim", 1})

  end,
})

minetest.register_craftitem("health:bug_test_food2", {
	description = "Bug TESTING FOOD 2",
	inventory_image = "tech_vegetable_oil.png",
	stack_max = 500,
	groups = {flammable = 1},


  on_use = function(itemstack, user, pointed_thing)

		--HEALTH.remove_new_effect(user, {"Food Poisoning", 3})
		--HEALTH.remove_new_effect(user, {"Drunk", 4})
		--HEALTH.remove_new_effect(user, {"Hangover", 4})
		--HEALTH.remove_new_effect(user, {"Intestinal Parasites"})
		--HEALTH.remove_new_effect(user, {"Tiku High", 4})
		--HEALTH.remove_new_effect(user, {"Neurotoxicity", 4})
		--HEALTH.remove_new_effect(user, {"Hepatotoxicity", 4})
		--HEALTH.remove_new_effect(user, {"Photosensitivity", 4})
		--HEALTH.remove_new_effect(user, {"Meta-Stim", 4})

  end,
})
]]
