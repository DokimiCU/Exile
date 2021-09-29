-------------------------------------------------------------------------
--Dripping Water
--underground drinkable water drops
-------------------------------------------------------------------------
local random = math.random

--Drop entities
minetest.register_entity("nodes_nature:drop_water", {
	hp_max = 2,
	physical = true,
	collide_with_objects = false,
	collisionbox = {-0.05,-0.05,-0.05,0.05,0.05,0.05},
	visual = "cube",
	visual_size = {x=0.05, y=0.1},
	textures = {"nodes_nature_freshwater.png","nodes_nature_freshwater.png","nodes_nature_freshwater.png","nodes_nature_freshwater.png", "nodes_nature_freshwater.png","nodes_nature_freshwater.png"},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},

	on_activate = function(self, staticdata)
		self.object:set_sprite({x=0,y=0}, 1, 1, true)
		self.object:set_armor_groups({immortal=1})
	end,

	on_step = function(self, dtime)
		local k = math.random(1,444)
		local ownpos = self.object:get_pos()

		if k==1 then
			self.object:set_acceleration({x=0, y=-5, z=0})
		end

		if minetest.get_node({x=ownpos.x, y=ownpos.y+0.5, z=ownpos.z}).name == "air" then
			self.object:set_acceleration({x=0, y=-5, z=0})
		end

		if minetest.get_node({x=ownpos.x, y=ownpos.y -0.5, z=ownpos.z}).name ~= "air" then
			self.object:remove()
			minetest.sound_play({name="nodes_nature_water_drip"}, {pos = ownpos, gain = math.random(0.5,1), max_hear_distance = 12})
		end
	end,

	on_punch=function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		--drink
		local meta = puncher:get_meta()
		local thirst = meta:get_int("thirst")
		--only drink if thirsty
		if thirst < 100 then

			local water = math.random(1,10)
			thirst = thirst + water
			if thirst > 100 then
				thirst = 100
			end

			meta:set_int("thirst", thirst)
			minetest.sound_play("nodes_nature_slurp",	{pos = pos, max_hear_distance = 3, gain = 0.1})
			self.object:remove()

			--food poisoning
			if random() < 0.005 then
				HEALTH.add_new_effect(clicker, {"Food Poisoning", 1})
			end

			--parasites
			if random() < 0.001 then
				HEALTH.add_new_effect(clicker, {"Intestinal Parasites"})
			end

		end
	end,
})


--Create drop
minetest.register_abm({
	nodenames = {"group:stone", "group:soft_stone"},
	--neighbors = {"group:water"},
	interval = 27,
	chance = 120,
	action = function(pos)

		if pos.y < 200
		and pos.y > -1000 then
			local nb = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
			if nb == 'air' then
				local nb2 = minetest.get_node({x=pos.x, y=pos.y-2, z=pos.z}).name
				if nb2 == 'air' then
					local i = math.random(-35,35) / 100
					minetest.add_entity({x=pos.x + i, y=pos.y-0.501, z=pos.z + i}, "nodes_nature:drop_water")
				end
			end
		end
	end,
})
