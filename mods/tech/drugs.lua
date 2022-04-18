------------------------------------
--DRUGS
--medicines etc

-----------------------------------

-- Internationalization
local S = tech.S

local random = math.random

-----------------------------------
--MEDICAL


------------
--Herbal medicine
-- removes energy cost of plants healing effects
--can heal certain health effects
--a restorative anti-bacterial/anti-parasitic
minetest.register_craftitem("tech:herbal_medicine", {
	description = S("Herbal Medicine"),
	inventory_image = "tech_herbal_medicine.png",
	stack_max = minimal.stack_max_medium *2,
	groups = {flammable = 1},

  on_use = function(itemstack, user, pointed_thing)
    local meta = user:get_meta()
    local effects_list = meta:get_string("effects_list")
    effects_list = minetest.deserialize(effects_list) or {}

    --remove parasites
    if random()<0.33 then
  		HEALTH.remove_new_effect(user, {"Intestinal Parasites"})
  	end

    --cure/reduce food poisoning and infections
    --see how effective the dose is
    local cfp = random()
    if cfp <0.25 then
      --cure up to severe
      HEALTH.remove_new_effect(user, {"Food Poisoning", 3})
			HEALTH.remove_new_effect(user, {"Fungal Infection", 3})
			HEALTH.remove_new_effect(user, {"Dust Fever", 3})
    elseif cfp < 0.5 then
      --cure up to moderate
      HEALTH.remove_new_effect(user, {"Food Poisoning", 2})
			HEALTH.remove_new_effect(user, {"Fungal Infection", 2})
			HEALTH.remove_new_effect(user, {"Dust Fever", 2})
    elseif cfp < 0.75 then
      --only cure mild
      HEALTH.remove_new_effect(user, {"Food Poisoning", 1})
			HEALTH.remove_new_effect(user, {"Fungal Infection", 1})
			HEALTH.remove_new_effect(user, {"Dust Fever", 1})
    end


    --hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
    return HEALTH.use_item(itemstack, user, 5, 0, 0, 0, 0)
  end,
})


------------
--Detox?
--for toxins, alcohol, drugs
-- e.g. charcoal? - doesn't work for everything, can itself cause vomiting etc

--[[
How toxins get treated:
Alcohol: wait for it to pass (while helping them not die), pump stomach
Stimulant OD: sedation, wait for it to pass (while helping them not die)
Specific toxins can have anti-toxins (a fairly modern treatment)

]]


-----------------------------------
-----------------------------------
--DRUGS

-----------------------------------
--STIMULANTS


------------
--Tiku
-- stimulant drug
-- gets you high
minetest.register_craftitem("tech:tiku", {
	description = S("Tiku (stimulant)"),
	inventory_image = "tech_tiku.png",
	stack_max = minimal.stack_max_medium *2,
	groups = {flammable = 1},

  on_use = function(itemstack, user, pointed_thing)

    --begin the bender
		HEALTH.add_new_effect(user, {S("Tiku High"), 1})

    --hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
    return HEALTH.use_item(itemstack, user, 0, 0, -24, 96, 0)
  end,
})



-----------------------------------
--DEPRESSANTS


-----------------
--Tang, alcoholic drink

--Pot of Tang
minetest.register_node("tech:tang", {
  description = S("Tang"),
	tiles = {
		"tech_pot_tang.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png"
	},
	drawtype = "nodebox",
	stack_max = 1,--minimal.stack_max_bulky,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25}, -- NodeBox1
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox5
		}
	},
	groups = {dig_immediate=3, pottery = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
  on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
    --lets skull an entire vat of booze, what could possibly go wrong...
		local meta = clicker:get_meta()
		local thirst = meta:get_int("thirst")
		local hunger = meta:get_int("hunger")
    local energy = meta:get_int("energy")
		--only drink if thirsty
		if thirst < 100 then

			--you're skulling a whole bucket
			thirst = thirst + 100
			if thirst > 100 then
				thirst = 100
			end

      --all energy and half food equivalent of the fruit
      --gets given as energy
      energy = energy + 180
      if energy > 1000 then
        energy = 1000
      end

			hunger = hunger + 60
			if hunger > 1000 then
				hunger = 1000
			end

      --drunkness
			if random() < 0.75 then
				HEALTH.add_new_effect(clicker, {"Drunk", 1})
			end


			meta:set_int("thirst", thirst)
      meta:set_int("energy", energy)
			minetest.set_node(pos, {name = "tech:clay_water_pot"})
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.25})
		end
	end


})



--save usage into inventory, to prevent infinite supply
local on_dig_tang = function(pos, node, digger)
	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end

	local meta = minetest.get_meta(pos)
	local ferment = meta:get_int("ferment")

	local new_stack = ItemStack("tech:tang_unfermented")
	local stack_meta = new_stack:get_meta()
	stack_meta:set_int("ferment", ferment)


	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new_stack) then
		player_inv:add_item("main", new_stack)
	else
		minetest.add_item(pos, new_stack)
	end
end

--set saved
local after_place_tang = function(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local stack_meta = itemstack:get_meta()
	local ferment = stack_meta:get_int("ferment")
	if ferment >0 then
		meta:set_int("ferment", ferment)
	end
end


--Pot of new Tang, must be left to ferment
minetest.register_node("tech:tang_unfermented", {
  description = S("Tang (unfermented)"),
	tiles = {
		"tech_pot_tang_uf.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png"
	},
	drawtype = "nodebox",
	stack_max = 1,--minimal.stack_max_bulky,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25}, -- NodeBox1
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox3
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox5
		}
	},
	groups = {dig_immediate=3, pottery = 1, temp_pass = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),

	on_dig = function(pos, node, digger)
		on_dig_tang(pos, node, digger)
	end,

	on_construct = function(pos)
		--duration of ferment
		local meta = minetest.get_meta(pos)
		meta:set_int("ferment", math.random(300,360))
		--ferment
		minetest.get_node_timer(pos):start(5)
	end,

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_tang(pos, placer, itemstack, pointed_thing)
	end,

	on_timer =function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local ferment = meta:get_int("ferment")
		if ferment < 1 then
			minetest.set_node(pos, {name = "tech:tang"})
			--minetest.check_for_falling(pos)
			return false
		else
      --ferment if at right temp
      local temp = climate.get_point_temp(pos)
      if temp > 10 and temp < 34 then
        meta:set_int("ferment", ferment - 1)
      end
			return true
		end
	end,
})

-----------------------------------
--HALLUCINOGENS



---------------------------------------
--Recipes



--
--mortar and pestle
--


--make herbal_medicine
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:herbal_medicine",
	items = {'nodes_nature:hakimi', 'nodes_nature:merki', 'nodes_nature:moss'},
	level = 1,
	always_known = true,
})

--make tiku
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:tiku",
	items = {'nodes_nature:tikusati_seed 12', 'nodes_nature:wiha', "tech:vegetable_oil"},
	level = 1,
	always_known = true,
})

--make tang_unfermented
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:tang_unfermented",
	items = {'nodes_nature:tangkal_fruit 12', "tech:clay_water_pot_freshwater"},
	level = 1,
	always_known = true,
})
