----------------------------------------------------------------------
-- Sneachan
--small insect.
--[[
Land living
Dislikes bright light, eats sediment, plants,
]]
---------------------------------------------------------------------

-- Internationalization
local S = animals.S

local random = math.random
local floor = math.floor

--energy
local energy_max = 5000--secs it can survive without food
local energy_egg = energy_max-100 --energy that goes to egg
local egg_timer  = 60*10
local young_per_egg = 5		--will get this/energy_egg starting energy

local lifespan = energy_max * 5



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
		local pred

		if prty < 50 then


			--Threats
			local plyr = mobkit.get_nearby_player(self)
			if plyr then
				animals.fight_or_flight_plyr(self, plyr, 55, 0.01)
			end

			pred = animals.predator_avoid(self, 55, 0.01)

		end


		----------------------
		--Low priority actions

		if prty < 20 then

			--territorial behaviour
			local rival = animals.territorial(self, energy, true)


			--feeding
			local light = (minetest.get_node_light(pos) or 0)

			if light <= 12 then
				--hungry eat stuff in the dark
				if energy < energy_max then
					if animals.eat_sediment_under(pos, 0.001) == true then
						energy = energy + 3
					elseif  animals.eat_flora(pos, 0.001) == true then
						energy = energy + 4
					else
						--wander random
						mobkit.animate(self,'walk')
						--mobkit.hq_roam(self,10)
						animals.hq_roam_surface_group(self, 'sediment', 20)
					end
				else
					--full
					mobkit.hq_roam(self,1)
				end
			elseif random()<0.5 and energy < energy_max then
				--slower, less effective feeding during day
				if animals.eat_sediment_under(pos, 0.001) then
					energy = energy + 1
				elseif  animals.eat_flora(pos, 0.001) then
					energy = energy + 2
				else
					--wander random
					mobkit.animate(self,'walk')
					animals.hq_roam_dark(self,10)
				end
			else
				--get out of the light
				animals.hq_roam_dark(self,15)
			end




			--reproduction
			--asexual parthogenesis, eggs
			if random() < 0.005
			and not rival
			and not pred
			and self.hp >= self.max_hp
			and energy >= energy_max then
				energy = animals.place_egg(pos, "animals:sneachan_eggs", energy, energy_egg, 'air')
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
minetest.register_node("animals:sneachan_eggs", {
	description = S('Sneachan Eggs'),
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
		if light <= 10 then
			return animals.hatch_egg(pos, 'air', 'air', "animals:sneachan", energy_egg, young_per_egg)
		else
			if random()<0.3 then
				return animals.hatch_egg(pos, 'air', 'air', "animals:sneachan", energy_egg, young_per_egg)
			end
			return true
		end
	end,
})







----------------------------------------------

--The Animal
minetest.register_entity("animals:sneachan",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.1, -0.01, -0.1, 0.1, 0.15, 0.1},
	visual = "mesh",
	mesh = "animals_sneachan.b3d",
	textures = {"animals_sneachan.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,
	timeout = 0,

	--damage
	max_hp = 10,
	lung_capacity = 10,
	min_temp = -28,
	max_temp = 48,

	--interaction
	predators = {"animals:pegasun", "animals:kubwakubwa", "animals:darkasthaan"},
	rivals = {"animals:sneachan", "animals:impethu"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=0, y=20}, speed=20, loop=true},
		fast={range={x=0, y=20}, speed=40, loop=true},
		stand={range={x=0, y=20}, speed=10, loop=true},
	},
	sounds = {
		warn = {
			name = "animals_sneachan_warn",
			gain={0.05, 0.2},
			fade={0.5, 1.5},
			pitch={0.6, 1.3},
		},
		punch = {
			name = "animals_punch",
			gain={0.3, 0.9},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
	},

	--movement
	springiness=0,
	buoyancy = 1.01,
	max_speed = 1,					-- m/s
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
		animals.on_punch(self, tool_capabilities, puncher, 55, 0.1)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.75)
	end,
})





--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:sneachan", S("Live Sneachan"), "animals_sneachan_item.png", minimal.stack_max_medium, energy_egg)
