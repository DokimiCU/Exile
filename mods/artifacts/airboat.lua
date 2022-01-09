local random = math.random

-- Functions

local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i / math.abs(i)
	end
end


local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end


local function get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end





-- Airboat entity

local airboat = {
		initial_properties = {
		physical = true,
		collide_with_objects = false, -- Workaround fix for a MT engine bug
		collisionbox = {-0.9, 0.3, -0.9, 0.9, 1.7, 0.9},
		visual = "wielditem",
		visual_size = {x = 2.0, y = 2.0}, -- Scale up of nodebox is these * 1.5
		textures = {"artifacts:airboat_nodebox"},
	},

	-- Custom fields
	driver = nil,
	removed = false,
	v = 0,
	vy = 0,
	rot = 0,
	auto = false,
}


function airboat.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local name = clicker:get_player_name()
	local pos = clicker:get_pos()
	if self.driver and name == self.driver then
		-- Detach
		self.driver = nil
		self.auto = false
		clicker:set_detach()
		player_api.player_attached[name] = false
		minetest.after(0.2, function()
			player_api.set_animation(clicker, "stand" , 30)
			clicker:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		end)
		minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 1, max_hear_distance = 6})
		minetest.after(0.1, function()
			clicker:set_pos(pos)
		end)
	elseif not self.driver then
		-- Attach
		local attach = clicker:get_attach()
		if attach and attach:get_luaentity() then
			local luaentity = attach:get_luaentity()
			if luaentity.driver then
				luaentity.driver = nil
			end
			clicker:set_detach()
		end
		self.driver = name
		clicker:set_attach(self.object, "",
			{x = 0, y = -8, z = 0}, {x = 0, y = 0, z = 0})
		player_api.player_attached[name] = true
		minetest.after(0.2, function()
			player_api.set_animation(clicker, "sit" , 30)
			clicker:set_eye_offset({x = 0, y = -12, z = 0}, {x = 0, y = 0, z = 0})
		end)
		minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 1, max_hear_distance = 6})
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end


function airboat.on_activate(self, staticdata, dtime_s)
	self.object:set_armor_groups({immortal = 1})
end


function airboat.on_punch(self, puncher)
	if not puncher or not puncher:is_player() or self.removed then
		return
	end

	local name = puncher:get_player_name()
        local pos = puncher:get_pos()
	if self.driver and name == self.driver then
		-- Detach
		--only use on_rightclick
		--[[
		self.driver = nil
		puncher:set_detach()
		puncher:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		player_api.player_attached[name] = false
		]]
	end
	if not self.driver then
		-- Move to inventory
		self.removed = true
		local inv = puncher:get_inventory()
		if not (creative and creative.is_enabled_for
				and creative.is_enabled_for(name))
				or not inv:contains_item("main", "artifacts:airboat") then
			local leftover = inv:add_item("main", "artifacts:airboat")
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		minetest.after(0.1, function()
			self.object:remove()
			minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 1, max_hear_distance = 6})
		end)
	end
end


function airboat.on_step(self, dtime)
	self.v = get_v(self.object:get_velocity()) * get_sign(self.v)
	self.vy = self.object:get_velocity().y
	local pos = self.object:get_pos()

	-- Controls
	if self.driver then

		local driver_objref = minetest.get_player_by_name(self.driver)
		if driver_objref then
			local ctrl = driver_objref:get_player_control()
			if (ctrl.up and ctrl.down) or (ctrl.left and ctrl.right) then
				if not self.auto then
					self.auto = true
					minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 1, max_hear_distance = 6})
					minetest.chat_send_player(self.driver,
						"[airboat] Cruise on")
				end
			elseif ctrl.down then
				self.v = self.v - 0.1
				if self.auto then
					self.auto = false
					minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 1, max_hear_distance = 6})
					minetest.chat_send_player(self.driver,
						"[airboat] Cruise off")
				end
			elseif ctrl.up or self.auto then
				self.v = self.v + 0.1
			end
			if ctrl.left then
				self.rot = self.rot + 0.001
				if random()>0.98 then
					minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 0.25, max_hear_distance = 6})
				end
			elseif ctrl.right then
				self.rot = self.rot - 0.001
				if random()>0.98 then
					minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 0.25, max_hear_distance = 6})
				end
			end
			if ctrl.jump then
				self.vy = self.vy + 0.06
				if random()>0.98 then
					minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 0.25, max_hear_distance = 6})
				end
			elseif ctrl.sneak then
				self.vy = self.vy - 0.06
				if random()>0.98 then
					minetest.sound_play("artifacts_airboat_gear", {pos = pos, gain = 0.25, max_hear_distance = 6})
				end
			end
		else
			-- Player left server while driving
			-- In MT 5.0.0 use 'airboat:on_detach_child()' to do this
			self.driver = nil
			self.auto = false
			minetest.log("warning", "[airboat] Driver left server while" ..
				" driving. This may cause some 'Pushing ObjectRef to" ..
				" removed/deactivated object' warnings.")
		end
	end

	-- Early return for stationary vehicle
	if self.v == 0 and self.rot == 0 and self.vy == 0 then
		self.object:set_pos(self.object:get_pos())
		return
	end

	-- Reduction and limiting of linear speed
	local s = get_sign(self.v)
	self.v = self.v - 0.02 * s
	if s ~= get_sign(self.v) then
		self.v = 0
	end
	if math.abs(self.v) > 4 then
		self.v = 4 * get_sign(self.v)
	end

	-- Reduction and limiting of rotation
	local sr = get_sign(self.rot)
	self.rot = self.rot - 0.0003 * sr
	if sr ~= get_sign(self.rot) then
		self.rot = 0
	end
	if math.abs(self.rot) > 0.015 then
		self.rot = 0.015 * get_sign(self.rot)
	end

	-- Reduction and limiting of vertical speed
	local sy = get_sign(self.vy)
	self.vy = self.vy - 0.03 * sy
	if sy ~= get_sign(self.vy) then
		self.vy = 0
	end
	if math.abs(self.vy) > 2 then
		self.vy = 2 * get_sign(self.vy)
	end

	local new_acce = {x = 0, y = 0, z = 0}
	-- Bouyancy in liquids
	local p = self.object:get_pos()
	p.y = p.y - 1.5
	local def = minetest.registered_nodes[minetest.get_node(p).name]
	if def and (def.liquidtype == "source" or def.liquidtype == "flowing") then
		new_acce = {x = 0, y = 10, z = 0}
	end

	self.object:set_pos(self.object:get_pos())
	self.object:set_velocity(get_velocity(self.v, self.object:get_yaw(), self.vy))
	self.object:set_acceleration(new_acce)
	self.object:set_yaw(self.object:get_yaw() + (1 + dtime) * self.rot)
end


minetest.register_entity("artifacts:airboat", airboat)


-- Craftitem

minetest.register_craftitem("artifacts:airboat", {
	description = "Airboat",
	inventory_image = "artifacts_airboat_inv.png",
	stack_max = 1,
	wield_scale = {x = 4, y = 4, z = 4},
	liquids_pointable = true,

	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]

		-- Run any on_rightclick function of pointed node instead
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		if pointed_thing.type ~= "node" then
			return itemstack
		end

		pointed_thing.under.y = pointed_thing.under.y + 2
		local airboat = minetest.add_entity(pointed_thing.under,
			"artifacts:airboat")
			minetest.sound_play("artifacts_airboat_gear", {pos = pointed_thing.under, gain = 1, max_hear_distance = 6})
		if airboat then
			if placer then
				airboat:set_yaw(placer:get_look_horizontal())
			end
			local player_name = placer and placer:get_player_name() or ""
			if not (creative and creative.is_enabled_for and
					creative.is_enabled_for(player_name)) then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
})


-- Nodebox for entity wielditem visual

minetest.register_node("artifacts:airboat_nodebox", {
	description = "Airboat Nodebox",
	tiles = { -- Top, base, right, left, front, back
		"artifacts_airboat_top.png",
		"artifacts_airboat_base.png",
		"artifacts_airboat_right.png",
		"artifacts_airboat_left.png",
		"artifacts_airboat_front.png",
		"artifacts_airboat_back.png",
	},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.375, -0.1875, 0.1875, -0.3125, 0.25}, -- seat_floor
			{-0.25, -0.1875, -0.1875, -0.1875, -0.0625, 0.1875}, -- seat_side_1
			{0.1875, -0.1875, -0.1875, 0.25, -0.0625, 0.1875}, -- seat_side_2
			{-0.25, -0.375, -0.25, 0.25, 0.125, -0.1875}, -- seat_side_back
			{-0.25, -0.3125, 0.1875, 0.25, -0.125, 0.25}, -- seat_side_front
			{-0.25, 0.125, -0.25, 0.25, 0.1875, 0.125}, -- seat_roof
			{-0.5, 0.1875, -0.5, -0.125, 0.5, 0.5}, -- balloon
			{0.125, 0.1875, -0.5, 0.5, 0.5, 0.5}, -- balloon2
		}
	},
	groups = {not_in_creative_inventory = 1},
})
