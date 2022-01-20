----------------------------------------------------------------------
-- Impethu
--cave worm.
--[[
Bottom of shallow cave food chain
]]
---------------------------------------------------------------------
local random = math.random
local floor = math.floor

--energy
local energy_max = 5000--secs it can survive without food
local energy_egg = energy_max/10 --energy that goes to egg
local egg_timer  = 120*5
local young_per_egg = 5		--will get this/energy_egg starting energy

local lifespan = energy_max * 4



-----------------------------------
local function brain(self)

	--die from damage
	if not animals.core_hp(self) then
		return
	end

	if mobkit.timer(self,1.5) then

		local pos = mobkit.get_stand_pos(self)

		local age, energy = animals.core_life(self, lifespan, pos)
		--die from exhaustion or age
		if not age then
			return
		end

		------------------
		--Emergency actions

		--swim to shore
		if self.isinliquid then
			mobkit.hq_liquid_recovery(self,60)
		end


		local prty = mobkit.get_queue_priority(self)
		-------------------
		--High priority actions
		local pred

		if prty < 50 then


			--Threats
			local plyr = mobkit.get_nearby_player(self)
			if plyr then
				animals.fight_or_flight_plyr(self, plyr, 55, 0.02)
			end

			pred = animals.predator_avoid(self, 55, 0.02)

		end


		----------------------
		--Low priority actions

		if prty < 20 then

			--territorial behaviour
			local rival
			if random() < 0.7 then
				rival = animals.territorial(self, energy, false)
			else
				rival = animals.territorial(self, energy, true)
			end


			--feeding
			--eat stuff in the dark
			local light = (minetest.get_node_light(pos) or 0)

			if light <= 5 then
				if not rival and energy < energy_max then
					energy = energy + 2
				end
				mobkit.animate(self,'walk')
				mobkit.hq_roam(self,10)
			else
				--random search for darkness
				--fatigued by light
				energy = energy - 1
				animals.hq_roam_dark(self,15)
			end


			--reproduction
			--asexual parthogenesis, eggs
			if random() < 0.005 then
				if not rival
				and energy >= energy_max then
					energy = animals.place_egg(pos, "animals:impethu_eggs", energy, energy_egg, 'air')
				end
			end

		end

		-------------------
		--generic behaviour
		if mobkit.is_queue_empty_high(self) then
			mobkit.animate(self,'walk')
			animals.hq_roam_dark(self,10,1)
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
minetest.register_node("animals:impethu_eggs", {
	description = 'Impethu Eggs',
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_medium,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.08, -0.5, -0.08,  0.08, -0.4375, 0.08},
	},
	groups = {snappy = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = exile_eatdrink,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		local light = (minetest.get_node_light(pos) or 0)
		if light <= 5 then
			return animals.hatch_egg(pos, 'air', 'air', "animals:impethu", energy_egg, young_per_egg)
		else
			return true
		end
	end,
})







----------------------------------------------

--The Animal
minetest.register_entity("animals:impethu",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.09, -0.25, -0.09, 0.09, -0.1, 0.09},
	visual = "mesh",
	mesh = "animals_impethu.b3d",
	textures = {"animals_impethu.png"},
	visual_size = {x = 5, y = 5},
	makes_footstep_sound = false,
	timeout = 0,

	--damage
	max_hp = 10,
	lung_capacity = 10,
	min_temp = -15,
	max_temp = 50,

	--interaction
	predators = {"animals:kubwakubwa", "animals:darkasthaan", "animals:pegasun"},
	rivals = {"animals:impethu", "animals:sneachan"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=0, y=12}, speed=10, loop=true},
		fast={range={x=0, y=12}, speed=10, loop=true},
		stand={
			{range={x=12, y=24}, speed=5, loop=true},
			{range={x=24, y=31}, speed=5, loop=true},
		},
	},
	sounds = {
		warn = {
			name = "animals_impethu_warn",
			gain={0.1, 0.4},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
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
	max_speed = 0.5,					-- m/s
	jump_height = 1,				-- nodes/meters
	view_range = 2,					-- nodes/meters

	--attack
	attack={range=0.3, damage_groups={fleshy=1}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:carcass_invert_small", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch(self, tool_capabilities, puncher, 55, 0.05)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.75)
	end,
})





--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:impethu", "Live Impethu", "animals_impethu_item.png", minimal.stack_max_medium, energy_egg)
