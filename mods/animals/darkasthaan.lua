----------------------------------------------------------------------
-- Darkasthaan

--[[
a big spider for deep caves
much same as kubwakubwa, but more dangerous
]]
---------------------------------------------------------------------

local random = math.random
local floor = math.floor

--energy
local energy_max = 12000--secs it can survive without food
local energy_egg = energy_max/3 --energy that goes to egg
local egg_timer  = 60*15
local young_per_egg = 3		--will get this/energy_egg starting energy

local lifespan = energy_max * 7



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

		------------------
		--Emergency actions

		--swim to shore
		if self.isinliquid then
			mobkit.hq_liquid_recovery(self,60)
		end

		local prty = mobkit.get_queue_priority(self)
		-------------------
		--High priority actions
		if prty < 50 then


			--Threats
			local plyr = mobkit.get_nearby_player(self)
			if plyr then
				animals.fight_or_flight_plyr(self, plyr, 55, 0.75)
			end

			--currently has none
			--animals.predator_avoid(self, 55, 0.75)
		end


		----------------------
		--Low priority actions

		if prty < 20 then

			--territorial behaviour
			local rival = animals.territorial(self, energy, true)


			--feeding
			--hunt prey
			if energy < energy_max then
				if not animals.prey_hunt(self, 25) then
					--random search for darkness
					animals.hq_roam_dark(self,15)
				end
			end

			--reproduction
			--asexual parthogenesis, eggs
			--when in prime condition
			if random() < 0.01
			and not rival
			and self.hp >= self.max_hp
			and energy >= energy_egg*2 then
				energy = animals.place_egg(pos, "animals:darkasthaan_eggs", energy, energy_egg, 'air')
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
minetest.register_node("animals:darkasthaan_eggs", {
	description = 'Darkasthaan Eggs',
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_medium,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.125, -0.5, -0.125,  0.125, -0.375, 0.125},
	},
	groups = {snappy = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = exile_eatdrink,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		return animals.hatch_egg(pos, 'air', 'air', "animals:darkasthaan", energy_egg, young_per_egg)
	end,
})






----------------------------------------------

--The Animal
minetest.register_entity("animals:darkasthaan",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.3, -0.3, -0.3, 0.3, 0, 0.3},
	visual = "mesh",
	mesh = "animals_darkasthaan.b3d",
	textures = {"animals_darkasthaan.png"},
	visual_size = {x = 0.6, y = 0.6},
	makes_footstep_sound = true,
	timeout = 0,


	--damage
	max_hp = 200,
	lung_capacity = 40,
	min_temp = 10,
	max_temp = 50,

	--interaction
	--predators = {"animals:darkasthaan"},
	rivals = {"animals:darkasthaan"},
	prey = {"animals:impethu", "animals:kubwakubwa", "animals:pegasun", "animals:sneachan"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=1,y=21},speed=15,loop=true},
		fast={range={x=1,y=21},speed=35,loop=true},
		stand={range={x=25,y=45},speed=5,loop=true},
	},
	sounds = {
		warn = {
			name = "animals_darkasthaan_warn",
			gain={0.3, 0.7},
			fade={0.5, 1.5},
			pitch={0.4, 1.4},
		},
		punch = {
			name = "animals_punch",
			gain={0.7, 1.3},
			fade={0.5, 1.5},
			pitch={0.7, 1.3},
		},
	},

	--movement
	springiness=0,
	buoyancy = 1.01,
	max_speed = 1,					-- m/s
	jump_height = 2,				-- nodes/meters
	view_range = 6,					-- nodes/meters

	--attack
	attack={range=0.8, damage_groups={fleshy=12}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:carcass_invert_large", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch(self, tool_capabilities, puncher, 55, 0.85)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.02)
	end,
})




--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:darkasthaan", "Live Darkasthaan", "animals_darkasthaan_item.png", minimal.stack_max_medium, energy_egg)
