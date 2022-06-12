----------------------------------------------------------------------
-- Gundu
--a small fish
--[[
filter feeds in sunlit waters
]]
---------------------------------------------------------------------

-- Internationalization
local S = animals.S

local random = math.random
local floor = math.floor

--energy
local energy_max = 8000--secs it can survive without food
local energy_egg = energy_max/6 --energy that goes to egg
local egg_timer  = 60*45
local young_per_egg = 5		--will get this/energy_egg starting energy

local lifespan = energy_max * 6

local function pos_is_liquid(pos)
	local node=mobkit.nodeatpos(pos)
	if node and node.drawtype ~= 'liquid' then
		return false
	else 
		return true
	end
end

-----------------------------------
local function brain(self)
	-- Make sure the block in front is liquid.
	local pos = mobkit.get_stand_pos(self)
	local yaw = self.object:get_yaw()
	local vel = self.object:get_velocity()

	local fpos = mobkit.pos_translate2d(pos,yaw,1) --front position
	local fu_pos = mobkit.pos_shift(fpos,{y=-1}) -- under front position
	local u_pos = mobkit.pos_shift(pos,{y=-1})  -- under possition

	if not pos_is_liquid(u_pos) or not pos_is_liquid(fu_pos) then
		-- no water below risie up
		vel.y = 0.2
		self.object:set_velocity(vel)
	end

	if not pos_is_liquid(fpos) then
		-- rise a little faster and turn
		vel.y = vel.y+0.2
		self.object:set_velocity(vel)
		mobkit.clear_queue_high(self)
		mobkit.hq_aqua_turn(self,68,yaw+2,2)
	end


	if mobkit.timer(self,1) then
		-- die from damage - run before animals.core_life() 
		--
		if not animals.core_hp_water(self) then
			return
		end
		-- Also recharges health from energy
		local age, energy = animals.core_life(self, lifespan, pos)

		--die from exhaustion or age
		if not age then
			return
		end


		local prty = mobkit.get_queue_priority(self)
		-------------------
		--High priority actions
		local pred = nil

		if prty < 50 then
			--Threats
			local plyr = mobkit.get_nearby_player(self)
			if plyr then
				animals.fight_or_flight_plyr_water(self, plyr, 55, 0)
			end

			pred = animals.predator_avoid_water(self, 55, 0)

			--Return to water
			if not self.isinliquid then
				mobkit.clear_queue_high(self)
				animals.hq_swimfrompos(self,66,pos,1)
			end
			-- Temp out of range
			local temp = climate.get_point_temp(pos)
			if temp < self.min_temp or temp > self.max_temp then
				local vel = self.object:get_velocity()
				vel.y = vel.y-0.2
				self.object:set_velocity(vel)
				mobkit.hq_aqua_roam(self,10,0.2)
			end

		end


		----------------------
		--Low priority actions
		if prty < 20 then

			--social behaviour
			local rival
			if pred then
				animals.flock(self, 21, 1, self.max_speed)
			elseif random() <0.15 then
				rival = animals.territorial_water(self, energy, false)
			elseif random() <0.01 then
				rival = animals.territorial_water(self, energy, true)
			elseif random() <0.25 then
				animals.flock(self, 15, 2, self.max_speed/2)
			end

			--feeding
			--in bright light, when no threats
			local light = minetest.get_node_light(pos) or 0
			local lightm = minetest.get_node_light(pos, 0.5) or 0
			if not pred and not rival then

				if light >= 9 then
					--much light much food
					if energy < energy_max then
						energy = energy + 5
					end

				elseif light >= 5 then
					--some light
					if energy < energy_max then
						energy = energy + 2
					end
				end
			end

			--movement
			local tod = minetest.get_timeofday()

			if tod <0.06 or tod >0.94 then
				--sink at night to lay eggs
				local vel = self.object:get_velocity()
				vel.y = vel.y-0.2
				self.object:set_velocity(vel)
				mobkit.hq_aqua_roam(self,10,0.2)

			elseif light <= 9 then
				--rise during day if not in best light
				local vel = self.object:get_velocity()
				vel.y = vel.y+0.2
				self.object:set_velocity(vel)
				mobkit.hq_aqua_roam(self,10, random(1, self.max_speed))

			else
				--no special movement
				mobkit.hq_aqua_roam(self,5, random(0.5, self.max_speed/2))

			end


			--reproduction
			--asexual parthogenesis, eggs
			--no threats, darkness, peak condition
			if random() < 0.02
			and not rival
			and not pred
			and lightm <= 11
			and ( tod <0.5 ) -- only lay at night
			and self.hp >= self.max_hp
			and energy >= energy_max - 100 then
				energy = animals.place_egg(pos, "animals:gundu_eggs", energy, energy_egg, 'nodes_nature:salt_water_source')
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
minetest.register_node("animals:gundu_eggs", {
	description = S('Gundu Eggs'),
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_bulky,
	groups = {snappy = 3},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = exile_eatdrink,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		return animals.hatch_egg(pos, 'nodes_nature:salt_water_source', 'nodes_nature:salt_water_flowing', "animals:gundu", energy_egg, young_per_egg)
	end,
})




----------------------------------------------

--The Animal
minetest.register_entity("animals:gundu",{
	--core
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	visual = "mesh",
	mesh = "animals_gundu.b3d",
	textures = {"animals_gundu.png"},
	visual_size = {x = 5, y = 5},
	makes_footstep_sound = false,
	timeout = 0,

	--damage
	max_hp = 40,
	lung_capacity = 20,
	min_temp = -2,
	max_temp = 35,

	--interaction
	predators = {"animals:sarkamos"},
	rivals = {"animals:gundu"},
	friends = {"animals:gundu"},
	--prey = {"animals:impethu"},

	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		def={range={x=1,y=35},speed=30,loop=true},
		fast={range={x=1,y=35},speed=60,loop=true},
		stand={range={x=36,y=75},speed=20,loop=true},
	},
	sounds = {
		flee = {
			name = "animals_water_swish",
			gain={0.5, 1.5},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
		call = {
			name = "animals_gundu_call",
			gain={0.05, 0.15},
			fade={0.5, 1.5},
			pitch={0.6, 1.2},
		},
		punch = {
			name = "animals_punch",
			gain={0.5, 1},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
	},

	--movement
	springiness=0.5,
	buoyancy = 1,
	max_speed = 5,					-- m/s
	jump_height = 1.5,				-- nodes/meters
	view_range = 5,					-- nodes/meters

	--attack
	attack={range=0.3, damage_groups={fleshy=1}},
	armor_groups = {fleshy=100},

	--on actions
	drops = {
		{name = "animals:carcass_fish_small", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		animals.on_punch_water(self, tool_capabilities, puncher, 56, 0)
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.1)
	end,
})


--spawn egg (i.e. live animal in inventory)
animals.register_egg("animals:gundu", S("Live Gundu"), "animals_gundu_item.png", minimal.stack_max_medium/2, energy_egg)
