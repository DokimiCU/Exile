-------------------------------------
--HEALTH
------------------------------------
--[[
Some notes:

Calculating sensible values for food:
(intervals/day) * hunger_rate = daily basal food needs
i.e. 20min/1min * 2 = 40 units per day

Therefore 40 units = 2000 calories.
calories -> units = 2000/40 = 50 cal/unit

Sugar 3900 cal/kg = 78 units/kg
Bread 2600 cal/kg = 52 units/kg
Potato. 1500 cal/kg = 30 u/kg
Meat 1000 cal/kg = 20 u/kg
cabbage 240 cal/kg = 4.8 u/kg

]]

------------------------------------

HEALTH = {}


dofile(minetest.get_modpath('health')..'/on_actions.lua')
dofile(minetest.get_modpath('health')..'/hud.lua')


--frequency of updating and applying effects
local interval = 60

-----------------------------
--Player Attibutes
--
--use standard values base, so it doesn't compound each time called
--Only adjusted values saved in player meta so they can be accessed without recalculating
--cf hunger etc which do get change and have no base value
local heal_rate = 4
local thirst_rate = -1
local hunger_rate = -2
local recovery_rate = 5
local move = 0
local jump = 0

--no clothing temperature comfort zone
local temp_min = 20
local temp_max = 30

--e.g. for new players
local function set_default_attibutes(player)
	local meta = player:get_meta()
	meta:set_int("thirst", 100)
	meta:set_int("hunger", 1000)
	meta:set_int("energy", 1000)
	meta:set_int("temperature", 37)
	meta:set_int("heal_rate", heal_rate)
	meta:set_int("thirst_rate", thirst_rate)
	meta:set_int("hunger_rate", hunger_rate)
	meta:set_int("recovery_rate", recovery_rate)
	meta:set_int("move", move)
	meta:set_int("jump", jump)
	meta:set_int("clothing_temp_min", temp_min)
	meta:set_int("clothing_temp_max", temp_max )

end




-----------------------------
--Forms for sfinv
--only for bug testing


--get data and create form
local function sfinv_get(self, player, context)
	local meta = player:get_meta()

	local player_pos = player:get_pos()
	player_pos.y = player_pos.y + 0.6 --adjust to body height
	local enviro_temp = tostring(math.floor(climate.get_point_temp(player_pos)))

	local health = tostring(player:get_hp())
	local thirst = tostring(meta:get_int("thirst"))
	local hunger = tostring(meta:get_int("hunger"))
	local energy = tostring(meta:get_int("energy"))
	local temperature = tostring(meta:get_int("temperature"))
	local heal_rate = tostring(meta:get_int("heal_rate"))
	local thirst_rate = tostring(meta:get_int("thirst_rate"))
	local hunger_rate = tostring(meta:get_int("hunger_rate"))
	local recovery_rate = tostring(meta:get_int("recovery_rate"))
	local move = tostring(meta:get_int("move"))
	local jump = tostring(meta:get_int("jump"))

	--[[
	local active_list = ""
	local all_actives = {"Drank Sea Water", "Plague", "Intestinal Parasites"}
	for i, all_actives in ipairs(all_actives) do
		active_list = active_list .. all_actives.. ", "
	end
	]]

	local formspec = "label[0.1,0.1; Health: " .. health .. " / 20]"..
	"label[0.1,0.6; Thirst: " .. thirst .. " / 100]"..
	"label[0.1,1.1; Hunger: " .. hunger .. " / 1000]"..
	"label[0.1,1.6; Energy: " .. energy .. " / 1000]"..
	"label[0.1,2.1; Body Temperature: " .. temperature .. " C]"..
	"label[0.1,3.1; Move Speed: " .. move .. " % change]"..
	"label[0.1,3.6; Jumping: " .. jump .. " % change]"..

	"label[4,0.1; Heal Rate: " .. heal_rate .. " ]"..
	"label[4,0.6; Thirst Rate: " .. thirst_rate .. " ]"..
	"label[4,1.1; Hunger Rate: " .. hunger_rate .. " ]"..
	"label[4,1.6; Recovery Rate: " .. recovery_rate .. " ]"..
	"label[4,2.1; External Temperature: " .. enviro_temp .. " C]"..
	"button[4,3.1;1,1;toggle_health_hud;HUD]"
	--..
	--"textarea[0.5,5.1;6,6;;Active Effects:;"..active_list.." ]"

	return formspec
end

local function register_tab()
	sfinv.register_page("health:health_tab", {
		title = "Health",
		on_enter = function(self, player, context)
			sfinv.set_player_inventory_formspec(player)
		end,
		get = function(self, player, context)
			local formspec = sfinv_get(self, player, context)
			return sfinv.make_formspec(player, context, formspec, true)
		end
	})
end

register_tab()




-----------------------------
--Bonus Malus... so can be called whenever player status is changed
--takes standard rates and adjusts them based on player status.
--saves adjusted rates and applies physics.
--send it attributes to adjust by,
--also give name and meta, bc anything calling it should already have that
-- returns the adjusted rates so they can be used if desired
--
function HEALTH.malus_bonus(player, name, meta, energy, thirst, hunger, temperature)

	--use standard values, so it doesn't compound each time adjusted.
	--Only saved to player meta so they can be accessed without recalculating
	local h_rate = heal_rate
	local t_rate = thirst_rate
	local hun_rate = hunger_rate
	local r_rate = recovery_rate
	local mov = move
	local jum = jump

	--(hunger/Energy has 10x stock)
	--0-20 starving/severe dehydrated: malus, no heal
	--20-40 malnourished/dehydrated: malus
	--40-60 hungry/thirsty: small malus
	--60-80 good:
	--80-100 overfull: small malus

	--80-100 well rested. bonus
	--60-80 rested.
	--40-60 tired. small malus
	--20-40 fatigued. malus
	--0-20 exhausted. malus no heal

	--<27 death
	--27-32: severe hypo. malus no heal
	--32-37: hypothermia. malus
	--36-38: normal
	--38-43: hyperthermia. malus.
	--43-47: severe heat stroke. malus no heal
	-->47 death

	--
	--update rates
	--

	--bonus/malus from health

	--bonus/malus from energy
	if energy > 800 then
		h_rate = h_rate + 2
		mov = mov + 15
		jum = jum + 15
	elseif energy < 1 then
		h_rate = h_rate - 1
		mov = mov - 30
		jum = jum - 30
		t_rate = t_rate - 12
		hun_rate = hun_rate - 24
	elseif energy < 200 then
		h_rate = h_rate - 1
		mov = mov - 20
		jum = jum - 20
		t_rate = t_rate - 4
		hun_rate = hun_rate - 8
	elseif energy < 400 then
		mov = mov - 10
		jum = jum - 10
		t_rate = t_rate - 3
		hun_rate = hun_rate - 4
	elseif energy < 600 then
		mov = mov - 1
		jum = jum - 1
		t_rate = t_rate - 2
		hun_rate = hun_rate - 2
	elseif energy < 700 then
		hun_rate = hun_rate - 1
	end


	--bonus/malus from thirst
	if thirst > 80 then
		h_rate = h_rate + 1
		r_rate = r_rate + 2
		mov = mov + 1
		jum = jum + 1
	elseif thirst < 1 then
		h_rate = h_rate - 12
		r_rate = r_rate - 10
		mov = mov - 30
		jum = jum - 30
	elseif thirst < 20 then
		h_rate = h_rate - 2
		r_rate = r_rate - 2
		mov = mov - 20
		jum = jum - 20
	elseif thirst < 40 then
		h_rate = h_rate - 1
		r_rate = r_rate - 1
		mov = mov - 10
		jum = jum - 10
	elseif thirst < 60 then
		mov = mov - 1
		jum = jum - 1
	end

	--bonus/malus from hunger
	if hunger > 800 then
		h_rate = h_rate + 1
		r_rate = r_rate + 2
		mov = mov + 1
		jum = jum + 1
	elseif hunger < 1 then
		h_rate = h_rate - 12
		r_rate = r_rate - 10
		mov = mov - 30
		jum = jum - 30
	elseif hunger < 200 then
		h_rate = h_rate - 2
		r_rate = r_rate - 2
		mov = mov - 20
		jum = jum - 20
	elseif hunger < 400 then
		h_rate = h_rate - 1
		r_rate = r_rate - 1
		mov = mov - 10
		jum = jum - 10
	elseif hunger < 600 then
		mov = mov - 1
		jum = jum - 1
	end

	--temp malus..severe..having this happen would make you very ill
	if temperature > 47 or temperature < 27 then
		h_rate = h_rate - 16
		r_rate = r_rate - 64
		mov = mov - 80
		jum = jum - 80
	elseif temperature > 43 or temperature < 32 then
		h_rate = h_rate - 8
		r_rate = r_rate - 32
		mov = mov - 40
		jum = jum - 40
	elseif temperature > 38 or temperature < 37 then
		h_rate = h_rate - 4
		r_rate = r_rate - 8
		mov = mov - 20
		jum = jum - 20
	end


	--save adjusted rates for access (e.g. by a medical tab/equipment etc)
	meta:set_int("heal_rate", h_rate)
	meta:set_int("thirst_rate", t_rate)
	meta:set_int("hunger_rate", hun_rate)
	meta:set_int("recovery_rate", r_rate)
	meta:set_int("move", mov)
	meta:set_int("jump", jum)

	--apply player physics
	--don't do in bed or it buggers the physics
	if not bed_rest.player[name] then
		player_monoids.speed:add_change(player, 1 + (mov/100), "health:physics")
		player_monoids.jump:add_change(player, 1 + (jum/100), "health:physics")
	end

	--return adjusted rates so can be applied if necessary
	return h_rate, r_rate, t_rate, hun_rate,  mov, jum

end


-----------------------------
--Main
--
minetest.register_on_newplayer(function(player)
	set_default_attibutes(player)
end)

minetest.register_on_joinplayer(function(player)
	sfinv.set_player_inventory_formspec(player)
end)

minetest.register_on_respawnplayer(function(player)
	set_default_attibutes(player)
	--sfinv.set_player_inventory_formspec(player)

	--redo physics (to clear what killed them)
	player_monoids.speed:del_change(player, "health:physics")
	player_monoids.jump:del_change(player, "health:physics")
end)


if minetest.settings:get_bool("enable_damage") then


	--Main update values
	local timer = 0
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime

		--run
		if timer > interval then

			for _,player in ipairs(minetest.get_connected_players()) do


				local name = player:get_player_name()
				local meta = player:get_meta()

				local health = player:get_hp()
				local thirst = meta:get_int("thirst")
				local hunger = meta:get_int("hunger")
				local energy = meta:get_int("energy")
				local temperature = meta:get_int("temperature")


				--apply rate adjustments so they are correct for current player status
				local h_rate, r_rate, t_rate, hun_rate,  mov, jum = HEALTH.malus_bonus(player, name, meta, energy, thirst, hunger, temperature)

				--
				--update attributes based on adjusted rates
				--XXX1 is the new (healt/thirst etc) value
				--so can be compared with old value, (which was useful...at one point)
				--

				--update and min max
				local health1, thirst1, hunger1, energy1, temperature1

				thirst1 = thirst + t_rate
				if thirst1 < 0 then
					thirst1 = 0
				elseif thirst1 > 100 then
					thirst1 = 100
				end

				hunger1 = hunger + hun_rate
				if hunger1 < 0 then
					hunger1 = 0
				elseif hunger1 > 1000 then
					hunger1 = 1000
				end

				energy1 = energy + r_rate
				if energy1 < 0 then
					energy1 = 0
				elseif energy1 > 1000 then
					energy1 = 1000
				end

				health1 = health + h_rate

				if temperature > 37 then
					temperature1 = temperature - 1
					if temperature > 47 then
						health1 = health1 - 1
					end

				elseif temperature < 37 then
					temperature1 = temperature + 1
					if temperature < 27 then
						health1 = health1 - 1
					end
				else
					temperature1 = temperature
				end

				if health1 < 0 then
					health1 = 0
				elseif health1 > 20 then
					health1 = 20
				end


				--update
				--
				player:set_hp(health1)
				meta:set_int("thirst", thirst1)
				meta:set_int("hunger", hunger1)
				meta:set_int("energy", energy1)
				meta:set_int("temperature", temperature1)


				--sfinv.set_player_inventory_formspec(player)

			end
		end

		--reset
		if timer > interval then
			timer = 0
		end

	end)

end
