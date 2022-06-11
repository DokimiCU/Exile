local break_sound = "default_tool_breaks"
local clang_sound = "default_metal_footstep"
local stuck_sound = "default_place_node"
if minetest.get_modpath("minimal") then
   break_sound = "tech_tool_breaks"
   stuck_sound = "nodes_nature_dug_node"
   clang_sound = "nodes_nature_dig_choppy"
end

function spears_throw (itemstack, player, pointed_thing)
	local spear = itemstack:get_name() .. '_entity'
	local player_pos = player:get_pos()
	local head_pos = vector.new(player_pos.x, player_pos.y + player:get_properties().eye_height, player_pos.z)
	local direction = player:get_look_dir()
	local throw_pos = vector.add(head_pos, vector.multiply(direction,0.5))
	local pitch = player:get_look_vertical()
	local yaw = player:get_look_horizontal()
	local rotation = vector.new(0, yaw + math.pi/2, pitch + math.pi/6)
	-- Plant into node
	if pointed_thing.type == "node" then
		local node = minetest.get_node(pointed_thing.under)
		if minetest.registered_nodes[node.name].walkable and vector.distance(pointed_thing.above, throw_pos) < 1 then
		   local spear_object = minetest.add_entity(
		      vector.divide(vector.add(vector.multiply(pointed_thing.above, 2),
					       pointed_thing.under), 3), spear)
			spear_object:set_rotation(rotation)
			spear_object:get_luaentity()._wear = itemstack:get_wear()
			spear_object:get_luaentity()._stickpos = pointed_thing.under
			return
		end
	end
	-- Avoid hitting yourself and throw
	local throw_speed = 12
	while vector.distance(player_pos, throw_pos) < 1.2 do
		throw_pos = vector.add(throw_pos, vector.multiply(direction, 0.1))
	end
	local player_vel = player:get_player_velocity()
	local spear_object = minetest.add_entity(throw_pos, spear)
	spear_object:set_velocity(vector.add(player_vel, vector.multiply(direction, throw_speed)))
	spear_object:set_rotation(rotation)
	minetest.sound_play("spears_throw", {pos = player_pos}, true)
	spear_object:get_luaentity()._wear = itemstack:get_wear()
	spear_object:get_luaentity()._stickpos = nil
	return true
end

function spears_set_entity(spear_type, base_damage, toughness)
	local SPEAR_ENTITY={
		initial_properties = {
			physical = false,
			visual = "item",
			visual_size = {x = 0.3, y = 0.3, z = 0.3},
			wield_item = "spears:spear_" .. spear_type,
			collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		},

		on_activate = function (self, staticdata, dtime_s)
			self.object:set_armor_groups({immortal = 1})
		end,

		on_punch = function (self, puncher)
			if puncher:is_player() then -- Grab the spear
				local stack = {name='spears:spear_' .. spear_type, wear = self._wear}
				local inv = puncher:get_inventory()
				if inv:room_for_item("main", stack) then
					inv:add_item("main", stack)
					self.object:remove()
				end
			end
		end,

		on_step = function(self, dtime)
			if not self._wear then
				self.object:remove()
				return
			end
			local velocity = self.object:get_velocity()
			local speed = vector.length(velocity)
			-- Spear is stuck ?
			if self._stickpos then
				local node = minetest.get_node(self._stickpos)
				local node_cracky = minetest.registered_nodes[node.name].groups.cracky
				if node_cracky and node_cracky < 3 then
					minetest.sound_play(clang_sound, {pos = self._stickpos}, true)
					self.object:remove()
					minetest.add_item(self._stickpos, {name='spears:spear_' .. spear_type, wear = self._wear})
				elseif not self._node_walkable then
					minetest.sound_play(stuck_sound, {pos = self._stickpos}, true)
				end
				self._node_walkable = minetest.registered_nodes[node.name].walkable
				if not node or not self._node_walkable then -- Fall when node is removed
					self.object:remove()
					minetest.add_item(self._stickpos, {name='spears:spear_' .. spear_type, wear = self._wear})
					return
				end
			else -- Spear is flying
				local direction = vector.normalize(velocity)
				local yaw = minetest.dir_to_yaw(direction)
				local pitch = math.acos(velocity.y/speed) - math.pi/3
				local pos = self.object:get_pos()
				local spearhead_pos = vector.add(pos, vector.multiply(direction, 0.5))
				local node = minetest.get_node(spearhead_pos)
				self.object:set_rotation({x = 0, y = yaw + math.pi/2, z = pitch})
				-- Hit someone?
				local objects_in_radius = minetest.get_objects_inside_radius(spearhead_pos, 0.6)
				for _,object in ipairs(objects_in_radius) do
					if object:get_luaentity() ~= self and object:get_armor_groups().fleshy then
						local damage = (speed + base_damage)^1.15 - 20
						object:punch(self.object, 1.0, {full_punch_interval = 1.0, damage_groups = {fleshy=damage},}, direction)
						self.object:remove()
						minetest.sound_play("spears_hit", {pos = pos}, true)
						minetest.add_item(pos, {name='spears:spear_' .. spear_type, wear = self._wear + 65535/toughness})
						return
					end
				end
				-- Hit a node?
				if node and minetest.registered_nodes[node.name].walkable
				and not minetest.registered_nodes[node.name].buildable_to
				and not (minetest.registered_nodes[node.name].groups.slab and spearhead_pos.y % 1 < 0.5)
				then -- Stick
					self.object:set_acceleration({x = 0, y = 0, z = 0})
					self.object:set_velocity({x = 0, y = 0, z = 0})
					self._wear = self._wear + 65535/toughness
					if self._wear >= 65535 then
						minetest.sound_play(break_sound, {pos = pos}, true)
						self.object:remove()
						return
					end
					self._stickpos = spearhead_pos
				else  -- Get drag
					local drag = math.max(minetest.registered_nodes[node.name].liquid_viscosity, 0.1)
					local acceleration = vector.multiply(velocity, -drag)
					acceleration.y = acceleration.y - 10 * ((7 - drag) / 7)
					self.object:set_acceleration(acceleration)
				end
			end
		end,
	}
	return SPEAR_ENTITY
end
