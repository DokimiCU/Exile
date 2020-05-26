----------------------------------------------------------------------
-- Pegasun
--chicken like bird
--[[

]]
---------------------------------------------------------------------
local random = math.random


--energy
local energy_max = 8000--secs it can survive without food
local energy_egg = energy_max/4 --energy that goes to egg
local egg_timer  = 60*25
local young_per_egg = 1		--will get this/energy_egg starting energy

local lifespan = energy_max * 8



-----------------------------------
local function brain(self)

	--die from damage
	if not animals.core_hp(self) then
		return
	end

	if mobkit.timer(self,1) then

		local pos = mobkit.get_stand_pos(self)

		local age, energy = animals.core_life(self, lifespan, pos)
		--die from exhaustion or age
		if not age then
			return
		end


		-------------------
		--High priority actions

		--swim to shore
		if self.isinliquid then
			mobkit.hq_liquid_recovery(self,70)
		end


		--Threats
		local plyr = mobkit.get_nearby_player(self)
		if plyr then
			animals.fight_or_flight_plyr(self, plyr, 65, 0.01)
		end

		animals.predator_avoid(self, 65, 0.01)


		----------------------
		--Low priority actions
		local prty = mobkit.get_queue_priority(self)

		if prty < 20 then


			--random choice between
			--feeding, exploring, social
			--chance differs by time
			local ce = 0.1
			local cs = 0.1
			-- c feeding is simply what happens if no
			--others are selected
			local tod = minetest.get_timeofday()
			if tod <0.2 or tod >0.8 then
				--more social at night
				ce = 0.01
				cs = 0.75
			elseif tod >0.55 and tod <0.55 then
				--explore during midday
				ce = 0.75
				cs = 0.01
			end


			if random() < ce then

				--wander
				mobkit.animate(self,'walk')
				animals.hq_roam_comfort_temp(self,12, 21)

			elseif random() < cs then

				--social
				if random()< 0.3 then
					animals.flock(self, 15, 3)
				elseif random()< 0.01 then
					animals.territorial(self, energy, false)
				elseif random() < 0.01 then
					--reproduction
					if age > lifespan/10
					and self.hp >= self.max_hp
					and energy >= energy_max/2 then
						--are we already pregnant?
						local preg = mobkit.recall(self,'pregnant')
						if preg and random() < 0.01 then
							energy = animals.place_egg(pos, "animals:pegasun_eggs", energy, energy_egg, 'air')
							mobkit.remember(self,'pregnant',false)
						else
							--we are randy
							mobkit.remember(self,'sexual',true)
							local mate = animals.mate_assess(self, 'animals:pegasun_male')
							if mate then
								--go get him!
								mobkit.make_sound(self,'mating')
								animals.hq_mate(self, 20, mate)
							end
						end
					else
						--I'm too tired darling
						mobkit.remember(self,'sexual',false)
					end
				end

			elseif energy < energy_max then

				--feed via a method
				if random()< 0.5 then
					--scratch dirt
					if animals.eat_spreading_under(pos, 0.005) then
						energy = energy + 15
					end
				elseif random()< 0.5 then
					--veg
					if animals.eat_flora(pos, 0.005) then
						energy = energy + 15
					end
				else
					--hunt
					if not animals.prey_hunt(self, 50) then
						--random search
						mobkit.animate(self,'walk')
						mobkit.hq_roam(self,10)
					end
				end
			end

		end

		-------------------
		--generic behaviour
		if mobkit.is_queue_empty_high(self) then
			mobkit.animate(self,'walk')
			mobkit.hq_roam(self,10)
		end

		-----------------
		--housekeeping
		--save energy, age
		mobkit.remember(self,'energy',energy)
		mobkit.remember(self,'age',age)

	end
end





-----------------------------------
--MALE BEHAVIOUR
local function brain_male(self)

	--die from damage
	if not animals.core_hp(self) then
		return
	end

	if mobkit.timer(self,1) then

		local pos = mobkit.get_stand_pos(self)

		local age, energy = animals.core_life(self, lifespan, pos)
		--die from exhaustion or age
		if not age then
			return
		end


		-------------------
		--High priority actions

		--swim to shore
		if self.isinliquid then
			mobkit.hq_liquid_recovery(self,70)
		end


		--Threats
		local plyr = mobkit.get_nearby_player(self)
		if plyr then
			animals.fight_or_flight_plyr(self, plyr, 65, 0.6)
		end

		animals.predator_avoid(self, 65, 0.6)


		----------------------
		--Low priority actions
		local prty = mobkit.get_queue_priority(self)

		if prty < 20 then


			--random choice between
			--feeding, exploring, social
			--chance differs by time
			local ce = 0.2
			local cs = 0.3
			-- c feeding is simply what happens if no
			--others are selected
			local tod = minetest.get_timeofday()
			if tod <0.2 or tod >0.8 then
				--more social at night
				ce = 0.01
				cs = 0.85
			elseif tod >0.55 and tod <0.55 then
				--explore during midday
				ce = 0.85
				cs = 0.2
			end


			if random() < ce then

				--wander
				mobkit.animate(self,'walk')
				animals.hq_roam_comfort_temp(self,12, 21)

			elseif random() < cs then

				--social
				if random()< 0.3 then
					animals.flock(self, 25, 1)
				elseif random()< 0.95 then
					animals.territorial(self, energy, false)
				elseif random() < 0.01 then
					--reproduction
					if self.hp >= self.max_hp
					and energy >= energy_max/10 then
						--set status as randy
						--find nearby prospect and try to mate
						mobkit.remember(self, 'sexual', true)
						local mate = animals.mate_assess(self, 'animals:pegasun')
						if mate then
							--go get her!
							mobkit.make_sound(self,'mating')
							animals.hq_mate(self, 50, mate)
						end
					else
						--in no state for hankypanky
						mobkit.remember(self, 'sexual', false)
					end
				end

			elseif energy < energy_max then

				--feed via a method
				if random()< 0.5 then
					--scratch dirt
					if animals.eat_spreading_under(pos, 0.005) then
						energy = energy + 15
					end
				elseif random()< 0.5 then
					--veg
					if animals.eat_flora(pos, 0.005) then
						energy = energy + 15
					end
				else
					--hunt
					if not animals.prey_hunt(self, 50) then
						--random search
						mobkit.animate(self,'walk')
						mobkit.hq_roam(self,10)
					end
				end
			end

		end

		-------------------
		--generic behaviour
		if mobkit.is_queue_empty_high(self) then
			mobkit.animate(self,'walk')
			mobkit.hq_roam(self,10)
		end

		-----------------
		--housekeeping
		--save energy, age
		mobkit.remember(self,'energy',energy)
		mobkit.remember(self,'age',age)

	end
end




---------------
-- the CREATURE
---------------

--eggs
minetest.register_node("animals:pegasun_eggs", {
	description = 'Pegasun Egg',
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_medium,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.125, -0.5, -0.125,  0.125, -0.125, 0.125},
	},
	groups = {snappy = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 0, 8, -4, 0)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		if random()<=0.5 then
			return animals.hatch_egg(pos, 'air', 'air', "animals:pegasun", energy_egg, young_per_egg)
		else
			return animals.hatch_egg(pos, 'air', 'air', "animals:pegasun_male", energy_egg, young_per_egg)
		end

	end,
})




------------------------------------------------------

--dead
minetest.register_node("animals:dead_pegasun", {
	description = 'Dead Pegasun',
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.1875, -0.5, -0.1875, 0.1875, -0.4, 0.1875},
	},
	tiles = {"animals_pegasun.png"},
	stack_max = minimal.stack_max_medium,
	groups = {snappy = 3, dig_immediate = 3, falling_node = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 0, 12, -6, 0)
	end,
})







----------------------------------------------
--THE MALE

minetest.register_entity("animals:pegasun_male",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.125, -0.75, -0.125, 0.125, -0.125, 0.125},
	visual = "mesh",
	mesh = "animals_pegasun.b3d",
	textures = {"animals_pegasun_male.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,
	timeout = 0,

	--damage
	max_hp = 120,
	lung_capacity = 25,
	min_temp = -10,
	max_temp = 40,

	--interaction
	predators = {"animals:kubwakubwa", "animals:darkasthaan"},
	prey = {"animals:impethu"},
	friends = {"animals:pegasun"},
	rivals = {"animals:pegasun_male"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain_male,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=71, y=90}, speed=24, loop=true},
		fast={range={x=91, y=110}, speed=24, loop=true},
		stand={
			{range={x=1, y=30}, speed=28, loop=true},
			{range={x=31, y=70}, speed=32, loop=true},
		},
	},
	sounds = {
		warn = {
			name = "animals_pegasun_warn",
			gain={0.3, 0.6},
			fade={0.5, 1.5},
			pitch={0.9, 1.1},
		},
		call = {
			name = "animals_pegasun_call",
			gain={0.2, 0.5},
			fade={0.5, 1.5},
			pitch={0.9, 1.1},
		},
		mating = {
			name = "animals_pegasun_mate",
			gain={0.5, 0.9},
			fade={0.5, 1.5},
			pitch={0.8, 1.2},
		},
		attack = {
			name = "animals_pegasun_attack",
			gain={0.6, 0.8},
			fade={0.5, 1.5},
			pitch={0.7, 1.1},
		},
		punch = {
			name = "animals_punch",
			gain={0.5, 1.5},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
	},

	--movement
	springiness=0,
	buoyancy = 1.01,
	max_speed = 2.5,					-- m/s
	jump_height = 1.5,				-- nodes/meters
	view_range = 7,					-- nodes/meters

	--attack
	attack={range=0.6, damage_groups={fleshy=4}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:dead_pegasun", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch(self, tool_capabilities, puncher, 65, 0.6)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.15)
	end,
})





--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:pegasun_male", "Live Pegasun (male)", "animals_pegasun_item.png", minimal.stack_max_medium, energy_egg)



------------------------------------------------------------------------
--FEMALE

minetest.register_entity("animals:pegasun",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.125, -0.75, -0.125, 0.125, -0.125, 0.125},
	visual = "mesh",
	mesh = "animals_pegasun.b3d",
	textures = {"animals_pegasun.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,
	timeout = 0,

	--damage
	max_hp = 100,
	lung_capacity = 20,
	min_temp = -10,
	max_temp = 40,

	--interaction
	predators = {"animals:kubwakubwa", "animals:darkasthaan"},
	prey = {"animals:impethu"},
	friends = {"animals:pegasun", "animals:pegasun_male"},
	rivals = {"animals:pegasun"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=71, y=90}, speed=24, loop=true},
		fast={range={x=91, y=110}, speed=24, loop=true},
		stand={
			{range={x=1, y=30}, speed=28, loop=true},
			{range={x=31, y=70}, speed=32, loop=true},
		},
	},
	sounds = {
		warn = {
			name = "animals_pegasun_warn",
			gain={0.2, 0.5},
			fade={0.5, 1.5},
			pitch={0.9, 1.1},
		},
		call = {
			name = "animals_pegasun_call",
			gain={0.2, 0.4},
			fade={0.5, 1.5},
			pitch={0.9, 1.1},
		},
		mating = {
			name = "animals_pegasun_mate",
			gain={0.4, 0.7},
			fade={0.5, 1.5},
			pitch={0.9, 1.4},
		},
		attack = {
			name = "animals_pegasun_attack",
			gain={0.4, 0.7},
			fade={0.5, 1.5},
			pitch={0.9, 1.4},
		},
		punch = {
			name = "animals_punch",
			gain={0.5, 1.5},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
	},

	--movement
	springiness=0,
	buoyancy = 1.01,
	max_speed = 2,					-- m/s
	jump_height = 1.2,				-- nodes/meters
	view_range = 7,					-- nodes/meters

	--attack
	attack={range=0.6, damage_groups={fleshy=2}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:dead_pegasun", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch(self, tool_capabilities, puncher, 65, 0.05)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.25)
	end,
})





--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:pegasun", "Live Pegasun (female)", "animals_pegasun_item.png", minimal.stack_max_medium, energy_egg)
