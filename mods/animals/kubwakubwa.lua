----------------------------------------------------------------------
-- Kubwakubwa
--a spider
--[[
prefers the dark. Put in caves. Creepy, minor threat, minor food source.
]]
---------------------------------------------------------------------
local random = math.random
local energy_max = 7000 --secs it can survive without food
local energy_egg = energy_max/5
local egg_timer  = 60*15

--must get to e max to lay eggs,
--therefore this is max # of laying chances
local lifespan = energy_max * 4 --~ 7hrs



-----------------------------------
local function spider_brain(self)
	mobkit.vitals(self)
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

		--die from exhaustion, old age
		if energy <=0 or age > lifespan then
			mobkit.clear_queue_high(self)
			animals.handle_drops(self)
			mobkit.hq_die(self)
			return
		end


		--heal using energy
		local max_hp = self.max_hp
		if hp < self.max_hp and energy > 120 then
			mobkit.heal(self,1)
			energy = energy - 1
		end

		--temperature damage
		--!??

		--Emergency actions

		--swim to shore
		if self.isinliquid then
			mobkit.hq_liquid_recovery(self,70)
		end


		--flee from player, and predator
		--local pred = mobkit.get_closest_entity(self,'insert baddy here!!!!')
		local plyr = mobkit.get_nearby_player(self)

		if plyr then--or pred then
			--rare aggression
			if random()> 0.95 and plyr:get_attach() == nil then
				mobkit.hq_warn(self,50,plyr)
			else
				mobkit.animate(self,'run')
				mobkit.make_sound(self,'warn')
				mobkit.hq_runfrom(self,50,plyr)
			end
		end


		--low priority actions
		local prty = mobkit.get_queue_priority(self)

		if prty < 20 then
			local pos = mobkit.get_stand_pos(self)

			--territorial behaviour..keeps density down
			--avoid the bigger fish
			local rival = mobkit.get_closest_entity(self,'animals:kubwakubwa')
			if rival then
				local tpos = rival:get_pos()
				local r_ent = rival:get_luaentity()
				local r_ent_e = (mobkit.recall(r_ent,'energy') or 1)
				--spider life is brutal, otherwise caves get too crammed with spiders
				--Eat the weak! flee  the strong.
				if hp < max_hp/4 then
					mobkit.animate(self,'run')
					mobkit.make_sound(self,'warn')
					mobkit.hq_runfrom(self,25,rival)
				elseif energy > r_ent_e then
					animals.hq_attack_eat(self,15,rival)
				else
					mobkit.animate(self,'run')
					mobkit.make_sound(self,'warn')
					mobkit.hq_runfrom(self,25,rival)
				end
			end

			--feed on "stuff" , if it is dark.
			local light = (minetest.get_node_light(pos, 0.5) or 0)

			if light <= 13 then
				if energy < energy_max then
					energy = energy + 2 --i.e. half it's time must be spent feeding
				end
				mobkit.animate(self,'walk')
				mobkit.hq_roam(self,10, random(0.2, self.max_speed/3))
			else
				--random search for darkness
				 animals.hq_roam_dark(self,10)
			end

			--lay eggs.. when full and alone.
			if not rival and energy >= energy_max and random() > 0.99 then
				local p = mobkit.get_node_pos(pos)
				if minetest.get_node(p).name =='air' then
					local posu = {x = p.x, y = p.y - 1, z = p.z}
					local n = mobkit.nodeatpos(posu)
					if n and n.walkable then
						minetest.set_node(p, {name = 'animals:kubwakubwa_eggs'})
						energy = energy - energy_egg
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
-- the CREATURE
---------------

--eggs
minetest.register_node("animals:kubwakubwa_eggs", {
	description = 'Kubwakubwa Eggs',
	tiles = {"animals_gundu_eggs.png"},
	stack_max = minimal.stack_max_light/2,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.05, -0.5, -0.05, 0.05, -0.4, 0.05},
	},
	groups = {snappy = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 1, 16, -16, 0)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(egg_timer,egg_timer*2))
	end,
	on_timer =function(pos, elapsed)
		local air = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, {"air"})
		--dies, or hatch
		if #air < 1 then
			minetest.set_node(pos, {name = "air"})
			return false
		else
			for _, wp in pairs(air) do
				if random() >= 0.8 then
					local ent = minetest.add_entity(wp,"animals:kubwakubwa")
					minetest.sound_play("animals_hatch_egg", {pos = pos, gain = random(0.1,0.4), max_hear_distance = 6})
					ent = ent:get_luaentity()
					mobkit.remember(ent,'energy',math.random(energy_egg/2,energy_egg*2))
					mobkit.remember(ent,'age',0)
				end
			end
			minetest.set_node(pos, {name = "air"})
			return false
		end
	end,
})




------------------------------------------------------

--dead
minetest.register_node("animals:dead_kubwakubwa", {
	description = 'Dead Kubwakubwa',
	drawtype = 'mesh',
	--visual_scale = 0.1,
	--mesh = "animals_kubwakubwa.b3d",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.15, -0.5, -0.15,  0.15, -0.35, 0.15},
	},
	tiles = {"animals_kubwakubwa.png"},
	stack_max = minimal.stack_max_medium,
	groups = {snappy = 3, dig_immediate = 3, falling_node = 1},
	sounds = nodes_nature.node_sound_defaults(),
	on_use = function(itemstack, user, pointed_thing)
		--hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
		return HEALTH.use_item(itemstack, user, 0, 2, 8, -8, 0)
	end,
})







----------------------------------------------

--The Animal
minetest.register_entity("animals:kubwakubwa",{
	-- required minetest api props
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.14, -0.01, -0.14, 0.14, 0.27, 0.14},
	visual = "mesh",
	mesh = "animals_kubwakubwa.b3d",
	textures = {"animals_kubwakubwa.png"},
	--mesh = "test.dae",
	--textures = {"test.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,
	-- required mobkit props
	timeout = 0,
	buoyancy = 1.01,
	lung_capacity = 60,
	max_hp = 15,
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	logic = spider_brain,
	-- optional mobkit props
	-- or used by built in behaviors
	--physics = [function user defined] 		-- optional, overrides built in physics
	animation = {
		walk={range={x=0,y=20},speed=20,loop=true},
		run={range={x=0,y=20},speed=50,loop=true},
		idle={range={x=20,y=40},speed=10,loop=true},
	},
	sounds = {
		warn = {
			name = "animals_kubwakubwa_warn",
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
	springiness=0,
	max_speed = 1.5,					-- m/s
	jump_height = 2,				-- nodes/meters
	view_range = 4,					-- nodes/meters
	attack={range=0.3, damage_groups={fleshy=2}},
	armor_groups = {fleshy=100},
	--on actions
	drops = {
		{name = "animals:dead_kubwakubwa", chance = 1, min = 1, max = 1,},
	},
	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if mobkit.is_alive(self) then
			mobkit.clear_queue_high(self)
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			mobkit.make_sound(self,'punch')
			--fight or flight
			if random()>0.5 then
				mobkit.make_sound(self,'warn')
				mobkit.hq_attack(self,50,puncher)
			else
				mobkit.make_sound(self,'warn')
				mobkit.hq_runfrom(self,60,puncher)
			end
		end
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		animals.stun_catch_mob(self, clicker, 0.5)
	end,
})





--spawn egg (i.e. live fish in inventory)
animals.register_egg("animals:kubwakubwa", "Live Kubwakubwa", "animals_kubwakubwa_item.png", minimal.stack_max_medium, energy_egg)
