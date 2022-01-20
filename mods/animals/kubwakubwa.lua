----------------------------------------------------------------------
-- Kubwakubwa
--a spider
--[[
Predator in shallow caves
]]

---------------------------------------------------------------------
local random = math.random
local floor = math.floor

--energy
local energy_max = 8000--secs it can survive without food
local energy_egg = energy_max/2 --energy that goes to egg
local egg_timer  = 60*10
local young_per_egg = 4		--will get this/energy_egg starting energy

local lifespan = energy_max * 6



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
				animals.fight_or_flight_plyr(self, plyr, 55, 0.15)
			end

			animals.predator_avoid(self, 55, 0.15)

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
			and energy >= energy_egg + 100 then
				energy = animals.place_egg(pos, "animals:kubwakubwa_eggs", energy, energy_egg, 'air')
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
minetest.register_node("animals:kubwakubwa_eggs", {
	description = 'Kubwakubwa Eggs',
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_medium,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.0625, -0.5, -0.0625,  0.0625, -0.375, 0.0625},
	},
	groups = {snappy = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = exile_eatdrink,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
	   if minetest.get_node_light(pos, 0.5) >= 13 then
	      minetest.remove_node(pos)
	   else
	      return animals.hatch_egg(pos, 'air', 'air', "animals:kubwakubwa", energy_egg, young_per_egg)
	   end
	end,
})







----------------------------------------------

--The Animal
minetest.register_entity("animals:kubwakubwa",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.14, -0.01, -0.14, 0.14, 0.27, 0.14},
	visual = "mesh",
	mesh = "animals_kubwakubwa.b3d",
	textures = {"animals_kubwakubwa.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,
	timeout = 0,


	--damage
	max_hp = 80,
	lung_capacity = 20,
	min_temp = -15,
	max_temp = 50,

	--interaction
	predators = {"animals:darkasthaan"},
	rivals = {"animals:kubwakubwa"},
	prey = {"animals:impethu", "animals:pegasun", "animals:sneachan"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=0,y=20},speed=20,loop=true},
		fast={range={x=0,y=20},speed=50,loop=true},
		stand={range={x=20,y=40},speed=10,loop=true},
	},
	sounds = {
		warn = {
			name = "animals_kubwakubwa_warn",
			gain={0.4, 0.8},
			fade={0.5, 1.5},
			pitch={0.9, 1.1},
		},
		punch = {
			name = "animals_punch",
			gain={0.5, 1},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
	},

	--movement
	springiness=0,
	buoyancy = 1.01,
	max_speed = 0.75,					-- m/s
	jump_height = 1.5,				-- nodes/meters
	view_range = 4,					-- nodes/meters

	--attack
	attack={range=0.5, damage_groups={fleshy=4}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:carcass_invert_large", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch(self, tool_capabilities, puncher, 55, 0.75)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.1)
	end,
})




--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:kubwakubwa", "Live Kubwakubwa", "animals_kubwakubwa_item.png", minimal.stack_max_medium, energy_egg)
