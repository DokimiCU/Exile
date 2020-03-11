----------------------------------------------------------------------
-- Gundu
--a small fish
--[[
filter feeds in sunlit waters
]]
---------------------------------------------------------------------
local random = math.random
local energy_max = 8000
local energy_egg = energy_max/5
local egg_timer  = 60*30

--must get to e max to lay eggs,
--therefore this is max # of laying chances
local lifespan = energy_max * 4 --~ 8hrs


---------------------------------
--flee sound (has to be in water!)
local function flee_sound(self)
	if not self.isinliquid then
		return
	end
	mobkit.make_sound(self,'flee')
end

-----------------------------------
local function fish_brain(self)
	--die from damage
	local hp = self.hp
	if hp <= 0 then
		mobkit.clear_queue_high(self)
		animals.handle_drops(self)
		mobkit.hq_die(self)
		return
	end

	if mobkit.timer(self,1) then

		--use energy to live
		local energy = mobkit.recall(self,'energy')

		--grow old and die
		local age = mobkit.recall(self,'age')

		--this shouldn't happen but this prevents crashes during development
		--hopefully can be removed at some point...
		if not energy then
			energy = 1
		end
		if not age then
		age = 0
		end

		age = age + 1
		energy = energy - 1

		--die from exhaustion
		if energy <=0 or age > lifespan then
			mobkit.clear_queue_high(self)
			animals.handle_drops(self)
			mobkit.hq_die(self)
			return
		end

		--heal using energy
		if hp < self.max_hp and energy > 120 then
			mobkit.heal(self,1)
			energy = energy - 1
		end

		--suffocate
		if not self.isinliquid then
			mobkit.hurt(self,1)
		end

		--temperature damage
		--!??

		--Emergency actions

		--flee from player, and predator
		local plyr = mobkit.get_nearby_player(self)

		if plyr then
			mobkit.animate(self,'fast')
			animals.hq_swimfrom(self,25,plyr,self.max_speed)
			flee_sound(self)
		end

		local pred = mobkit.get_closest_entity(self,'animals:sarkamos')
		if pred then
			mobkit.animate(self,'fast')
			animals.hq_swimfrom(self,50,pred,self.max_speed)
			flee_sound(self)
		end

		--swim out of unsuitable water
		local liq = self.isinliquid
		if liq and liq == "nodes_nature:freshwater_source" then
			water_life.hq_swimto(self,30,2,"nodes_nature:salt_water_source")
		end

		--low priority actions
		local prty = mobkit.get_queue_priority(self)

		if prty < 20 then
			if liq and liq == "nodes_nature:salt_water_source" then
				local pos = mobkit.get_stand_pos(self)
				--territorial behaviour..keeps density down
				--avoid the bigger fish
				local rival = mobkit.get_closest_entity(self,'animals:gundu')
				if rival then
					local tpos = rival:get_pos()
					local r_ent = rival:get_luaentity()
					local r_ent_e = (mobkit.recall(r_ent,'energy') or 1)
					--most energy wins, flee or harass
					--we want fish to spread out wide across the ocean
					if energy < r_ent_e  then
						animals.hq_swimfrom(self, 25, rival ,self.max_speed)
						flee_sound(self)
					elseif random() > 0.4 then
						animals.hq_swimafter(self,15,rival,self.max_speed)
						flee_sound(self)
					end
				end

				--feed on "stuff" in water, if it is bright.
				local light = minetest.get_node_light(pos, 0.5)

				if light >= 13 then
					if energy < energy_max then
						energy = energy + 2
					end
					mobkit.hq_aqua_roam(self,10, random(0.5, self.max_speed/2))
				elseif random() > 0.5 then
					--rise
					local vel = self.object:get_velocity()
					vel.y = vel.y+0.1
					self.object:set_velocity(vel)
					mobkit.hq_aqua_roam(self,10, random(1, self.max_speed))
				end


				--hide during the darkest part of night
				if random() > 0.2 then
					local tod = minetest.get_timeofday()
					if tod <0.2 or tod >0.8 then
						--sink
						local vel = self.object:get_velocity()
						vel.y = vel.y-0.2
						self.object:set_velocity(vel)
						mobkit.hq_aqua_roam(self,15,0.1)
						--lay eggs at the bottom
						if not rival and energy >= energy_max and random() > 0.99 then
							local p = mobkit.get_node_pos(pos)
							local posu = {x = p.x, y = p.y - 1, z = p.z}
							local n = mobkit.nodeatpos(posu)
							if n.walkable then
								minetest.set_node(p, {name = 'animals:gundu_eggs'})
								energy = energy - (energy_egg*3)
							end
						end
					end
				end

			end

		end


		--generic behaviour
		if mobkit.is_queue_empty_high(self) then
			mobkit.animate(self,'def')
			mobkit.hq_aqua_roam(self,10,1)
		end

		--save energy, age
		mobkit.remember(self,'energy',energy)
		mobkit.remember(self,'age',age)

	end
end






---------------
-- the Fish
---------------

--eggs
minetest.register_node("animals:gundu_eggs", {
	description = 'Gundu Eggs',
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_bulky,
	groups = {snappy = 3},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 12, 120, -60, 0)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		local water = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, {"nodes_nature:salt_water_source"})
		--dies, or hatch
		if #water < 2 then
			minetest.set_node(pos, {name = "nodes_nature:salt_water_flowing"})
			return false
		else
			for _, wp in pairs(water) do
				if random() >= 0.5 then
					local ent = minetest.add_entity(wp,"animals:gundu")
					minetest.sound_play("animals_hatch_egg", {pos = pos, gain = random(0.1,0.4), max_hear_distance = 6})
					ent = ent:get_luaentity()
					mobkit.remember(ent,'energy',math.random(energy_egg/2,energy_egg*2))
					mobkit.remember(ent,'age',0)
				end
			end
			minetest.set_node(pos, {name = "nodes_nature:salt_water_flowing"})
			return false
		end
	end,
})




------------------------------------------------------

--dead
minetest.register_node("animals:dead_gundu", {
	description = 'Dead Gundu',
	drawtype = 'mesh',
	--mesh = "animals_gundu.b3d",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2,  0.2, -0.35, 0.2},
	},
	tiles = {"animals_gundu.png"},
	stack_max = minimal.stack_max_medium/2,
	groups = {snappy = 3, dig_immediate = 3, falling_node = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 3, 24, -24, 0)
	end,
})







----------------------------------------------

--The fish
minetest.register_entity("animals:gundu",{
	-- required minetest api props
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.15, -0.15, -0.15, 0.15, 0.15, 0.15},
	visual = "mesh",
	mesh = "animals_gundu.b3d",
	textures = {"animals_gundu.png"},
	visual_size = {x = 9, y = 9},
	makes_footstep_sound = true,
	-- required mobkit props
	timeout = 0,
	buoyancy = 1,
	--lung_capacity = [num], 		-- seconds
	max_hp = 30,
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = fish_brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		def={range={x=1,y=35},speed=40,loop=true},
		fast={range={x=1,y=35},speed=80,loop=true},
		idle={range={x=36,y=75},speed=20,loop=true},
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
			gain={0.5, 1.5},
			fade={0.5, 1.5},
			pitch={0.5, 1.5},
		},
	},
	springiness=1,
	max_speed = 5,					-- m/s
	jump_height = 2,				-- nodes/meters
	view_range = 6,					-- nodes/meters
	attack={range=0.3, damage_groups={fleshy=1}},
	armor_groups = {fleshy=100},
	--on actions
	drops = {
		{name = "animals:dead_gundu", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if mobkit.is_alive(self) then
			mobkit.clear_queue_high(self)
			mobkit.make_sound(self,'punch')
			flee_sound(self)
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			--fight or flight
			if random()>0.95 then
				mobkit.hq_attack(self,50,puncher)
			else
				animals.hq_swimfrom(self,60,puncher,self.max_speed)
			end
		end
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.8)
	end,
})





--spawn egg (i.e. live fish in inventory)
animals.register_egg("animals:gundu", "Live Gundu", "animals_gundu_item.png", minimal.stack_max_medium/2, energy_egg)
