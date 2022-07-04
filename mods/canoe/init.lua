-- canoe/init.lua

-- Internationalization
local S = minetest.get_translator("canoe")

--
-- Helper functions
--
local random = math.random

local function is_water(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "water") ~= 0
end


local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i / math.abs(i)
	end
end


--
-- canoe entity
--

local canoe = {
	initial_properties = {
		physical = true,
		-- Warning: Do not change the position of the collisionbox top surface,
		-- lowering it causes the canoe to fall through the world if underwater
		collisionbox = {-0.5, -0.35, -0.5, 0.5, 0.3, 0.5},
		visual = "mesh",
		mesh = "canoe_canoe.obj",
		textures = {"canoe_texture.png"},

	},

	driver = nil,
	v = 0,
	last_v = 0,
	removed = false,
}



function canoe.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() then
		return
	end

	local name = clicker:get_player_name()
	--get off canoe
	if self.driver and name == self.driver then
		self.driver = nil
		clicker:set_detach()
		player_api.player_attached[name] = false
		player_api.set_animation(clicker, "stand" , 30)
		local pos = clicker:get_pos()
		pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
		minetest.after(0.1, function()
			clicker:set_pos(pos)
		end)
	--get on canoe
	elseif not self.driver then
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
			{x = 0.5, y = 1, z = -3}, {x = 0, y = 0, z = 0})
		player_api.player_attached[name] = true
		minetest.after(0.2, function()
			player_api.set_animation(clicker, "sit" , 30)
		end)
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end


-- If driver leaves server while driving canoe
function canoe.on_detach_child(self, child)
	self.driver = nil
end


function canoe.on_activate(self, staticdata, dtime_s)
	self.object:set_armor_groups({immortal = 1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
	self.last_v = self.v
end


function canoe.get_staticdata(self)
	return tostring(self.v)
end

--!!change this for keeping an inventory in canoe ? no picking up canoe?
function canoe.on_punch(self, puncher)
	if not puncher or not puncher:is_player() or self.removed then
		return
	end

	local name = puncher:get_player_name()
	if self.driver and name == self.driver then
		self.driver = nil
		puncher:set_detach()
		player_api.player_attached[name] = false
	end
	if not self.driver then
		self.removed = true
		local inv = puncher:get_inventory()
		if not (creative and creative.is_enabled_for
				and creative.is_enabled_for(name))
				or not inv:contains_item("main", "canoe:canoe") then
			local leftover = inv:add_item("main", "canoe:canoe")
			-- if no room in inventory add a replacement canoe to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		-- delay remove to ensure player is detached
		minetest.after(0.1, function()
			self.object:remove()
		end)
	end
end

local function limit_and_reduce(vec, cap, decay)
   local s = get_sign(vec)
   vec = vec - decay * s
   if s ~= get_sign(vec) then
      vec = 0
   end
   if math.abs(vec) > cap then
      vec = cap * get_sign(vec)
   end
   return vec
end


local steplimit = 0
function canoe.on_step(self, dtime)
	steplimit = steplimit + dtime
	if not minetest.is_singleplayer()
	   and steplimit < 0.2 then
	   return
	end
	dtime = steplimit
	steplimit = 0
	local lyaw = self.object:get_yaw()
	local lvelocity = vector.rotate_around_axis(
	   self.object:get_velocity(),
	   {x=0, y=1, z=0},
	   lyaw * -1)
	local pos = self.object:get_pos()
	--Using three digits of precision
	self.v = math.floor(lvelocity.z * 1000) / 1000 -- forward speed
	self.y = math.floor(lvelocity.y * 1000) / 1000 -- vertical speed
	--paddle canoe
	if self.driver then
		local driver_objref = minetest.get_player_by_name(self.driver)
		if driver_objref then
			local ctrl = driver_objref:get_player_control()
			if ctrl.down then
				self.v = self.v - dtime * 1.8
				if random()>0.9 then
					minetest.sound_play("nodes_nature_water_footstep", {pos = pos, gain = random(0.1,0.3), max_hear_distance = 6})
				end
			elseif ctrl.up then
				self.v = self.v + dtime * 1.5
				if random()>0.9 then
					minetest.sound_play("nodes_nature_water_footstep", {pos = pos, gain = random(0.1,0.3), max_hear_distance = 6})
				end
			end
			if ctrl.left then
				if random()>0.9 then
					minetest.sound_play("nodes_nature_water_footstep", {pos = pos, gain = random(0.1,0.3), max_hear_distance = 6})
				end
				if self.v < -0.001 then
					self.object:set_yaw(self.object:get_yaw() - dtime * 0.9)
				else
					self.object:set_yaw(self.object:get_yaw() + dtime * 0.9)
				end
			elseif ctrl.right then
				if self.v < -0.001 then
					self.object:set_yaw(self.object:get_yaw() + dtime * 0.9)
				else
					self.object:set_yaw(self.object:get_yaw() - dtime * 0.9)
				end
			end
		end
	end

	self.v = limit_and_reduce(self.v, 5, dtime * 0.3)
	--self.v = self.v - dtime * 0.6 * s

	--early return if motionless
	if self.v == 0 and lvelocity.x == 0
	   and lvelocity.y == 0 and lvelocity.x == 0 then
		return
	end

	local below = vector.new(pos.x, pos.y - 0.5, pos.z)
	local above = vector.new(pos.x, pos.y + 0.5, pos.z)
	local new_acce
	if is_water(above) then -- water over us
	   if self.y < 0 then -- rise hard if falling
	      new_acce = {x = 0, y = 10, z = 0}
	   else
	      new_acce = {x = 0, y = 4, z = 0}
	   end
	elseif is_water(below) then -- we're on the surface
	   new_acce = {x = 0, y = 0, z = 0}

	   if math.abs(self.y) < 1
	      and pos.y - 0.5 > math.floor(pos.y - 0.5) then
	      pos.y = math.floor(pos.y + 1) - 0.5
	      self.object:set_pos(pos)
	   end
	   self.y = 0
	else -- no water below either
	   local nodedef = minetest.registered_nodes[minetest.get_node(below).name]
	   if (not nodedef) or nodedef.walkable then
	      --beached, stop
	      self.v = 0
	      new_acce = {x = 0, y = 0, z = 0}
	   else
	      --out of water, begin falling
	      new_acce = {x = 0, y = -9.8, z = 0}
	   end
	end

	local new_velo = vector.subtract(
	   vector.new(0, self.y, self.v),
	   lvelocity)
	new_velo = vector.rotate_around_axis(
	   new_velo,
	   { x = 0, y = 1, z = 0},
	   lyaw)
	self.object:add_velocity(new_velo)
	self.object:set_acceleration(new_acce)
end


minetest.register_entity("canoe:canoe", canoe)


minetest.register_craftitem("canoe:canoe", {
	description = S("Dugout Canoe"),
	inventory_image = "canoe.png",
	wield_image = "canoe.png",
	wield_scale = {x = 3, y = 3, z = 1},
	liquids_pointable = true,
	groups = {flammable = 1},
	stack_max = 1,

	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]

		if pointed_thing.type ~= "node" then
			return itemstack
		end
		if not is_water(pointed_thing.under) then
			return itemstack
		end
		pointed_thing.under.y = pointed_thing.under.y + 0.5
		canoe = minetest.add_entity(pointed_thing.under, "canoe:canoe")
		if canoe then
			if placer then
				canoe:set_yaw(placer:get_look_horizontal())
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


--
--recipe
--
crafting.register_recipe({
	type = "chopping_block",
	output = "canoe:canoe",
	items = {"group:log 6"},
	level = 1,
	always_known = true,
})
