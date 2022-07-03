----------------------------------------------------------------------
-- Sarkamos
--[[
predator fish
]]
---------------------------------------------------------------------

-- Internationalization
local S = animals.S

local random = math.random
local floor = math.floor

--energy
local energy_max = 14000--secs it can survive without food
local energy_egg = energy_max/8 --energy that goes to egg
local egg_timer  = 60*45
local young_per_egg = 2		--will get this/energy_egg starting energy

local lifespan = energy_max * 8




-----------------------------------
local function brain(self)

	--die from damage
	if not animals.core_hp_water(self) then
		return
	end

	if mobkit.timer(self,1) then

		local pos = mobkit.get_stand_pos(self)

		local age, energy = animals.core_life(self, lifespan, pos)
		--die from exhaustion or age
		if not age then
			return
		end


		local prty = mobkit.get_queue_priority(self)
		-------------------
		--High priority actions
		--if prty < 50 then

			--Threats

			--currently none
			--animals.predator_avoid_water(self, 65, 0.01)

		--end


		----------------------
		--Low priority actions
		if prty < 20 then

			--territorial behaviour
			local rival = animals.territorial_water(self, energy, false)

			--feeding
			if energy < energy_max then
			   --You are prey
			   local plyr = mobkit.get_nearby_player(self)
			   if plyr then
			      animals.fight_or_flight_plyr_water(self, plyr, 25, 0.4)
			   end

			   if not animals.prey_hunt_water(self, 25) then
			      --random search for darkness
			      mobkit.hq_aqua_roam(self,15,self.max_speed/3)
			   end
			end

			if energy >= energy_max then
			   -- heavy with eggs, sink to look for a laying spot
			   self.object:add_velocity({ x = 0, y = -0.2,
						      z = 0})
			end


			--reproduction
			--asexual parthogenesis, eggs
			--when in prime condition
			--in dark
			local light = minetest.get_node_light(pos, 0.5) or 0

			if random() < 0.02
			and not rival
			and light < 10
			and self.hp >= self.max_hp
			and energy >= energy_max then
			   energy = animals.place_egg(pos, "animals:sarkamos_eggs", energy, energy_egg, 'nodes_nature:salt_water_source')
			end

		end

		-------------------
		--generic behaviour
		if mobkit.is_queue_empty_high(self) then
			mobkit.animate(self,'def')
			mobkit.hq_aqua_roam(self,10,1)
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
minetest.register_node("animals:sarkamos_eggs", {
	description = S('Sarkamos Eggs'),
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_bulky,
	groups = {snappy = 3},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = exile_eatdrink,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		return animals.hatch_egg(pos, 'nodes_nature:salt_water_source', 'nodes_nature:salt_water_flowing', "animals:sarkamos", energy_egg, young_per_egg)
	end,
})






----------------------------------------------

--The Animal
minetest.register_entity("animals:sarkamos",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.2, -0.2, -0.2, 0.2, 0.15, 0.2},
	visual = "mesh",
	mesh = "animals_sarkamos.b3d",
	textures = {"animals_sarkamos.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = false,
	timeout = 0,

	--damage
	max_hp = 200,
	lung_capacity = 40,
	min_temp = 1,
	max_temp = 35,

	--interaction
	--predators = {"animals:sarkamos"},
	rivals = {"animals:sarkamos"},
	prey = {"animals:gundu"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		def={range={x=1,y=59},speed=40,loop=true},
		fast={range={x=1,y=59},speed=80,loop=true},
		stand={range={x=1,y=15},speed=15,loop=true},
	},
	sounds = {
		flee = {
			name = "animals_water_swish",
			gain={0.5, 1.5},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
		punch = {
			name = "animals_punch",
			gain={0.5, 1},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
		bite = {
			name = "animals_bite",
			gain={0.4, 0.8},
			fade={0.5, 1.5},
			pitch={0.6, 1.1},
		},
	},

	--movement
	springiness=0.5,
	buoyancy = 1,
	max_speed = 3,					-- m/s
	jump_height = 2,				-- nodes/meters
	view_range = 7,					-- nodes/meters

	--attack
	attack={range=0.6, damage_groups={fleshy=10}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:carcass_fish_large", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch_water(self, tool_capabilities, puncher, 55, 0.75)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.01)
	end,
})


--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:sarkamos", S("Live Sarkamos"), "animals_sarkamos_item.png", minimal.stack_max_medium/2, energy_egg)
