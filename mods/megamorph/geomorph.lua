-- Megamorph geomorph.lua

local mod = megamorph
local mod_name = 'megamorph'


local ladder_transform = { [0] = 4, 2, 5, 3 }
local n_air = mod.node['air']
local null_vector = {x = 1, y = 1, z = 1}


local action_names = {
	cube = true,
	cylinder = true,
	ladder = true,
	puzzle = true,
	sphere = true,
	stair = true,
}


function vector.max(v1, v2)
	if type(v1) == 'number' then
		v1 = vector.new(v1, v1, v1)
	end

	if type(v2) == 'number' then
		v2 = vector.new(v2, v2, v2)
	end

	local v3 = vector.new(0, 0, 0)
	v3.x = math.max(v1.x, v2.x)
	v3.y = math.max(v1.y, v2.y)
	v3.z = math.max(v1.z, v2.z)
	return v3
end


function vector.min(v1, v2)
	if type(v1) == 'number' then
		v1 = vector.new(v1, v1, v1)
	end

	if type(v2) == 'number' then
		v2 = vector.new(v2, v2, v2)
	end

	local v3 = vector.new(0, 0, 0)
	v3.x = math.min(v1.x, v2.x)
	v3.y = math.min(v1.y, v2.y)
	v3.z = math.min(v1.z, v2.z)
	return v3
end


function mod.rotate_coords(item, rot, csize)
	local min = table.copy(null_vector)
	local max = table.copy(null_vector)

	if rot == 0 then
		min.x = item.location.x
		max.x = item.location.x + item.size.x - 1
		min.z = item.location.z
		max.z = item.location.z + item.size.z - 1
	elseif rot == 1 then
		min.x = item.location.z
		max.x = item.location.z + item.size.z - 1
		min.z = csize.x - (item.location.x + item.size.x)
		max.z = csize.x - item.location.x - 1
	elseif rot == 2 then
		min.x = csize.x - (item.location.x + item.size.x)
		max.x = csize.x - item.location.x - 1
		min.z = csize.z - (item.location.z + item.size.z)
		max.z = csize.z - item.location.z - 1
	elseif rot == 3 then
		min.x = csize.z - (item.location.z + item.size.z)
		max.x = csize.z - item.location.z - 1
		min.z = item.location.x
		max.z = item.location.x + item.size.x - 1
	end

	min.y = item.location.y
	max.y = item.location.y + item.size.y - 1

	-- Limiting to csize causes problems with splitting maps,
	--  and it shouldn't be necessary. If the input was out
	--  of bounds, it should still be out of bounds here.
	--min = vector.max(0, min)
	--max = vector.min(vector.add(csize, -1), max)

	return min, max
end
local rotate_coords = mod.rotate_coords


---------------
-- Geomorph class
---------------
Geomorph = {}
Geomorph.__index = Geomorph
Geomorph.action_names = action_names


function Geomorph.new(mgen, description)
	local self = setmetatable({
	}, Geomorph)

	self.area = mgen.area
	self.csize = mgen.csize
	self.data = mgen.data
	self.gpr = mgen.gpr
	self.minp = mgen.isect_minp
	self.maxp = mgen.isect_maxp
	self.node = mgen.node
	self.params = mgen
	self.p2data = mgen.p2data
	self.ystride = mgen.area.ystride
	self.shapes = {}

	if description then
		self.areas = description.areas
		self.base_heat = description.base_heat
		self.base_humidity = description.base_humidity
		self.csize = description.size or self.csize
		self.name = description.name

		if description.data then
			for _, i in ipairs(description.data) do
				self:add(i)
			end
		end
	end

	return self
end


function Geomorph:create_shape(t)
	local action = t.act or t.action
	local location = t.loc or t.location
	local lining = t.line or t.lining
	local param2 = t.p2 or t.param2

	local intersect = t.intersect
	if type(intersect) == 'string' then
		intersect = { intersect }
	end

	if type(intersect) == 'table' then
		local t2 = {}
		local con
		for _, v in pairs(intersect) do
			if type(v) == 'string' then
				if v:find('^group:') then
					local g = v:gsub('^group:', '')
					for nm, n in pairs(minetest.registered_nodes) do
						if n.groups and n.groups[g] then
							t2[minetest.get_content_id(nm)] = true
						end
					end
				else
					t2[minetest.get_content_id(v)] = true
					con = true
				end
			end
		end
		if con then
			intersect = t2
		end
	end

	if not action then
		minetest.log(mod_name .. ': missing action')
		return
	end

	if action_names[action] then
		if not (location and t.size and (action == 'puzzle' or t.node)) then
			minetest.log(mod_name .. ': missing location/size')
			return
		end
	else
		minetest.log(mod_name .. ': can\'t create a ' .. action)
		return
	end

	if action_names[action] then
		local shape = {
			action = action,
			axis = t.axis,
			chance = t.chance,
			clear_up = t.clear_up,
			depth = t.depth,
			depth_fill = t.depth_fill,
			floor = t.floor,
			height = t.height,
			hollow = t.hollow,
			intersect = intersect,
			lining = lining,
			location = location,
			move_earth = t.move_earth,
			node = t.node,
			param2 = param2,
			pattern = t.pattern,
			random = t.random,
			size = t.size,
			treasure = t.treasure,
			underground = t.underground,
		}

		return shape
	end
end


function Geomorph:add(t, n)
	local shape = self:create_shape(t)
	if not n then
		n = #self.shapes + 1
	end
	if shape then
		table.insert(self.shapes, n, shape)
	end
end


function Geomorph:write_to_map(rot, replace, loc)
	if not self.gpr then
		minetest.log(mod_name .. ': missing gpr')
		return
	end

	if not rot then
		rot = self.gpr:next(0, 3)
	end

	if replace and type(replace) ~= 'table' then
		minetest.log(mod_name .. ': bad replace')
		return
	end

	for _, shape in ipairs(self.shapes) do
		local copy

		-- linings - fills the surface of the volume
		if shape.lining then
			copy = table.copy(shape)
			copy.location = vector.add(copy.location, -1)
			copy.size = vector.add(copy.size, 2)
			copy.node = shape.lining
			--copy.potholes = potholes and potholes
			--copy.stain = copy.stain or cobble
			copy.hollow = 5
			copy.treasure = nil
			self:write_shape(copy, rot, loc)
		end

		if shape.floor
		and (
			shape.action == 'cube'
			or (
				shape.action == 'cylinder'
				and (shape.axis == 'y' or shape.axis == 'Y')
			)
		) then
			copy = table.copy(shape)
			copy.location = table.copy(copy.location)
			copy.location.y = copy.location.y - 1
			copy.size = table.copy(copy.size)
			copy.size.y = 1
			copy.treasure = nil
			copy.node = shape.floor
			--copy.potholes = potholes and potholes
			--copy.stain = copy.stain or cobble
			self:write_shape(copy, rot, loc)
		end

		if replace and replace[shape.node] then
			copy = table.copy(shape)
			copy.node = replace[shape.node]
			self:write_shape(copy, rot, loc)
		else
			self:write_shape(shape, rot, loc)
		end
	end
end


function Geomorph:write_shape(shape, rot, loc)
	if not rot or type(rot) ~= 'number' then
		minetest.log(mod_name .. ': can\'t write without rotation.')
	end

	if shape.action == 'cube' then
		self:write_cube(shape, rot, loc)
	elseif shape.action == 'cylinder' then
		self:write_cylinder(shape, rot, loc)
	elseif shape.action == 'ladder' then
		self:write_ladder(shape, rot, loc)
	elseif shape.action == 'sphere' then
		self:write_sphere(shape, rot, loc)
	elseif shape.action == 'stair' then
		self:write_stair(shape, rot, loc)
	elseif shape.action == 'puzzle' then
		self:write_puzzle(shape, rot, loc)
	else
		minetest.log(mod_name .. ': can\'t create a ' .. shape.action)
	end
end


local wallmounted = mod.wallmounted
function mod.get_p2(shape, rot)
	-- This gets the rotated p2 value without disrupting
	-- color data in the more significant bits.

	local p2 = shape.param2

	if not p2 or not rot or rot == 0 or mod.no_rotate[shape.node] then
		return p2
	end

	if wallmounted[shape.node] then
		local yaw = minetest.dir_to_yaw(minetest.wallmounted_to_dir(p2))
		yaw = yaw + math.pi
		for _ = 1, rot do
			yaw = yaw + math.pi / 2
		end
		p2 = minetest.dir_to_wallmounted(minetest.yaw_to_dir(yaw))
	else
		local rp2 = p2 % 4
		local extra = math.floor(p2 / 4)
		if rot ~= 0 then
			rp2 = (rp2 + rot) % 4
		end
		p2 = rp2 + extra * 4
	end

	return p2
end


function mod.pattern_match(pattern, x, y, z)
	if not pattern then
		return true
	end

	if z then
		if pattern == 1 and math.floor(z / 2) % 2 == 1 then
			return
		end
		if pattern == 2 and math.floor(z / 4) % 4 == 1 then
			return
		end
	end

	if x then
		if pattern == 1 and math.floor(x / 2) % 2 == 1 then
			return
		end
		if pattern == 2 and math.floor(x / 4) % 4 == 1 then
			return
		end
	end
end


function Geomorph:write_cube(shape, rot, loc)
	local min, max = rotate_coords(shape, rot, self.csize)
	if not min then
		minetest.log(mod_name .. ': missing min')
		return
	end

	if loc then
		min = vector.add(min, loc)
		max = vector.add(max, loc)
	end

	local p2 = mod.get_p2(shape, rot)

	local data = self.data
	local gpr = self.gpr
	local hollow = shape.hollow
	local intersect = shape.intersect
	local minp = self.minp
	local move_earth = shape.move_earth
	local node_num = self.node[shape.node]
	local p2data = self.p2data
	local pattern = shape.pattern
	local random = shape.random
	local underground = shape.underground
	local ystride = self.ystride

	local hmin, hmax
	if hollow then
		hmin = vector.add(min, hollow)
		hmax = vector.subtract(max, hollow)
	end

	--local pattern_fail_x, pattern_fail_y, pattern_fail_z
	for z = min.z, max.z do
		for x = min.x, max.x do
			local top_y = max.y
			local surface = self.params.share.surface

			--[[
			if underground then
				local height = surface[z][x] - minp.y
				if height then
					top_y = math.min(max.y, height - underground)
				end
			end
			if shape.height then
				top_y = math.min(top_y, min.y + shape.height)
			end
			--]]

			local top_node, top_p2
			if move_earth and surface then
				local mz = minp.z + z
				local mx = minp.x + x
				if surface[mz] and surface[mz][mx] and surface[mz][mx].top then
					local tn = surface[mz][mx].top
					if tn <= minp.y + top_y and tn >= min.y + minp.y then
						local ivm = self.area:index(mx, surface[mz][mx].top, mz)

						top_node = data[ivm]
						top_p2 = p2data[ivm]
					end
				end
			end

			--[[
			if minp.z and minp.x and z and x and self.params.share.surface then
				local height = self.params.share.surface[minp.z + z][minp.x + x].top or false
			else
				height = -33000
			end}}
			
			height = height or -330]]
			local height = -30000

			local ivm = self.area:index(minp.x + x, minp.y + min.y, minp.z + z)
			for y = min.y, top_y do
				local underground_ok = not underground or (height and minp.y + y < height - underground)

				if  (not hollow or not vector.contains(hmin, hmax, x, y, z))
				and (not pattern or mod.pattern_match(pattern, x, y, z))
				and (not random or gpr:next(1, math.max(1, random)) == 1)
				and (
					not intersect
					or (type(intersect) == 'table' and intersect[data[ivm]])
					or (intersect == true and data[ivm] ~= n_air)
				)
				and y < 80 and y >= 0 and underground_ok then
					if top_node and y == min.y then
						data[ivm] = top_node
						p2data[ivm] = top_p2
						surface[minp.z + z][minp.x + x].top = minp.y + y
					else
						data[ivm] = node_num
						p2data[ivm] = p2
					end
				end

				ivm = ivm + ystride
			end
		end
	end

	if shape.treasure and self.params.share
	and type(shape.treasure) == 'number'
	and self.gpr:next(1, shape.treasure) == 1 then
		if not self.params.share.treasure_chests then
			self.params.share.treasure_chests = {}
		end
		local acpos = {
			x = self.gpr:next(min.x, max.x),
			y = min.y,
			z = self.gpr:next(min.z, max.z),
		}
		acpos = vector.add(acpos, minp)
		local ivm = self.area:indexp(acpos)
		if data[ivm] == n_air then
			--!!
			data[ivm] = self.node['artifacts:antiquorium_chest']
			table.insert(self.params.share.treasure_chests, acpos)
		end
	end
end


function Geomorph:write_sphere(shape, rot, loc)
	local min, max = rotate_coords(shape, rot, self.csize)
	if not min then
		return
	end

	if loc then
		min = vector.add(min, loc)
		max = vector.add(max, loc)
	end

	local p2 = mod.get_p2(shape, rot)

	local area = self.area
	local data = self.data
	local gpr = self.gpr
	local intersect = shape.intersect
	local minp = self.minp
	local node_num = self.node[shape.node]
	local p2data = self.p2data
	local pattern = shape.pattern
	local random = shape.random
	local underground = shape.underground
	local ystride = self.area.ystride

	local radius = math.max(shape.size.x, shape.size.y, shape.size.z) / 2
	local radius_s = radius * radius
	local center = vector.divide(vector.add(min, max), 2)
	local proportions = vector.divide(vector.subtract(max, vector.subtract(min, 1)), radius * 2)
	local h_radius, h_radius_s

	if shape.hollow then
		h_radius = radius - shape.hollow
		h_radius_s = h_radius * h_radius
	end

	for z = min.z, max.z do
		local index = z * self.csize.x + min.x + 1
		local zv = (z - center.z) / proportions.z
		local zvs = zv * zv
		for x = min.x, max.x do
			--local height = self.params.share.surface[minp.z + z][minp.x + x].top
			--height = height or -33000
			local height = -30000

			local ivm = area:index(minp.x + x, minp.y + min.y, minp.z + z)
			local top_y = max.y

			local xv = (x - center.x) / proportions.x
			local xvs = xv * xv

			for y = min.y, top_y do
				local yv = (y - center.y) / proportions.y
				local dist = xvs + yv * yv + zvs
				local underground_ok = not underground or (height and minp.y + y < height - underground)

				if (dist <= radius_s)
				and (not random or gpr:next(1, math.max(1, random)) == 1)
				and (not pattern or mod.pattern_match(pattern, x, y, z))
				and (not h_radius or dist > h_radius_s)
				and (
					not intersect
					or (type(intersect) == 'table' and intersect[data[ivm]])
					or (intersect == true and data[ivm] ~= n_air)
				)
				and y < 80 and y >= 0 and underground_ok then
					data[ivm] = node_num
					p2data[ivm] = p2
				end

				ivm = ivm + ystride
			end
			index = index + 1
		end
	end
end


function Geomorph:write_cylinder(shape, rot, loc)
	if not shape.axis then
		minetest.log(mod_name .. ': can\'t create a cylinder without an axis')
		return
	end

	local min, max = rotate_coords(shape, rot, self.csize)
	if not min then
		return
	end

	if loc then
		min = vector.add(min, loc)
		max = vector.add(max, loc)
	end

	local p2 = mod.get_p2(shape, rot)

	local area = self.area
	local axis = shape.axis
	local data = self.data
	local hollow = shape.hollow
	local intersect = shape.intersect
	local minp = self.minp
	local node_num = self.node[shape.node]
	local p2data = self.p2data
	local pattern = shape.pattern
	--local underground = shape.underground
	local ystride = self.area.ystride

	if rot == 1 or rot == 3 then
		if axis == 'x' or axis == 'X' then
			axis = 'z'
		elseif axis == 'z' or axis == 'Z' then
			axis = 'x'
		end
	end

	local do_radius = {
		x=(axis ~= 'x' and axis ~= 'X'),
		y=(axis ~= 'y' and axis ~= 'Y'),
		z=(axis ~= 'z' and axis ~= 'Z'),
	}

	local radius = math.max(shape.size.x, shape.size.y, shape.size.z) / 2
	local radius_s = radius * radius
	local center = vector.divide(vector.add(min, max), 2)
	local proportions = vector.divide(vector.subtract(max, min), radius * 2)
	local h_radius, h_radius_s

	if hollow then
		h_radius = radius - shape.hollow
		h_radius_s = h_radius * h_radius
	end

	for z = min.z, max.z do
		local xv, xvs, yv, zv, zvs
		local index = z * self.csize.x + min.x + 1
		if do_radius.z then
			zv = (z - center.z) / proportions.z
			zvs = zv * zv
		end
		for x = min.x, max.x do
			local ivm = area:index(minp.x + x, minp.y + min.y, minp.z + z)
			local top_y = max.y

			--local height = self.params.share.surface[minp.z + z][minp.x + x].top
			--height = height or -33000
			local height = -30000

			if do_radius.x then
				xv = (x - center.x) / proportions.x
				xvs = xv * xv
			end

			for y = min.y, top_y do
				if do_radius.y then
					yv = (y - center.y) / proportions.y
				end

				local radius_good = false
				local hollow_good = (not hollow)

				if do_radius.x and do_radius.y then
					local dist = xvs + yv * yv
					radius_good = (dist <= radius_s)
					if hollow then
						hollow_good = (dist > h_radius_s)
						and (z < min.z + hollow and z > max.z - hollow)
					end
				elseif do_radius.x and do_radius.z then
					local dist = xvs + zvs
					radius_good = (dist <= radius_s)
					if hollow then
						hollow_good = (dist > h_radius_s)
						and (y < min.y + hollow and y > max.y - hollow)
					end
				elseif do_radius.y and do_radius.z then
					local dist = yv * yv + zvs
					radius_good = (dist <= radius_s)
					if hollow then
						hollow_good = (dist > h_radius_s)
						and (x < min.x + hollow and x > max.x - hollow)
					end
				end

				if radius_good and hollow_good and y < 80 and y >= 0
				and (
					not intersect
					or (type(intersect) == 'table' and intersect[data[ivm]])
					or (intersect == true and data[ivm] ~= n_air)
				)
				and (not pattern or mod.pattern_match(pattern, x, y, z)) then
					data[ivm] = node_num
					p2data[ivm] = p2
				end

				ivm = ivm + ystride
			end
			index = index + 1
		end
	end
end


function Geomorph:write_stair(shape, rot, loc)
	if not shape.param2 then
		minetest.log(mod_name .. ': can\'t make a stair with no p2')
		return
	end

	local min, max = rotate_coords(shape, rot, self.csize)
	if not min then
		return
	end

	if loc then
		min = vector.add(min, loc)
		max = vector.add(max, loc)
	end

	local p2 = mod.get_p2(shape, rot)

	local area = self.area
	local data = self.data
	local depth_fill = shape.depth_fill
	local depth = (shape.depth and shape.depth > -1) and shape.depth
	local minp = self.minp
	local node_num = self.node[shape.node]
	local p2data = self.p2data
	local s_hi = (shape.height and shape.height > 0) and shape.height or 3
	--local underground = shape.underground
	local ystride = self.area.ystride
	--!!!
	local n_stone = self.node['nodes_nature:granite'] --self.node['default:stone']
	local n_depth = depth_fill and self.node[depth_fill] or n_stone

	for z = min.z, max.z do
		local index = z * self.csize.x + min.x + 1
		for x = min.x, max.x do
			local top_y = max.y

			--local height = self.params.share.surface[minp.z + z][minp.x + x].top
			--height = height or -33000
			local height = -30000

			local dy
			if p2 == 0 then
				dy = z - min.z
			elseif p2 == 1 then
				dy = x - min.x
			elseif p2 == 2 then
				dy = max.z - z
			elseif p2 == 3 then
				dy = max.x - x
			end

			--dy = math.min(dy, top_y)

			local s_lo = depth and dy - depth or 0
			if min.y + dy + 1 <= 96 and min.y + s_lo >= -16 then
				local y1 = minp.y + min.y + s_lo
				local ivm = area:index(minp.x + x, y1, minp.z + z)

				for _ = s_lo, dy - 1 do
					data[ivm] = n_depth
					p2data[ivm] = 0
					ivm = ivm + ystride
				end
				data[ivm] = node_num
				p2data[ivm] = p2

				y1 = minp.y + min.y + dy + 1
				ivm = area:index(minp.x + x, y1, minp.z + z)
				for y = 1, s_hi do
					-- This attempts to match corridor heights without
					--  actually knowing them. It's very questionable.
					if y1 + y - minp.y > top_y + s_hi then
						break
					end
					data[ivm] = n_air
					p2data[ivm] = 0
					ivm = ivm + ystride
				end
			end

			index = index + 1
		end
	end
end


function Geomorph:write_ladder(shape, rot, loc)
	local min, max = rotate_coords(shape, rot, self.csize)
	if not min then
		return
	end

	if loc then
		min = vector.add(min, loc)
		max = vector.add(max, loc)
	end

	local area = self.area
	local data = self.data
	local minp = self.minp
	local node_num = self.node[shape.node]
	local p2data = self.p2data
	local underground = shape.underground
	local ystride = self.area.ystride

	local p2 = shape.param2
	-- 2 X+   3 X-   4 Z+   5 Z-
	for i = 0, 3 do
		if ladder_transform[i] == p2 then
			p2 = ladder_transform[(i + rot) % 4]
			break
		end
	end

	for z = min.z, max.z do
		local index = z * self.csize.x + min.x + 1
		for x = min.x, max.x do
			local ivm = area:index(minp.x + x, minp.y + min.y, minp.z + z)
			local top_y = max.y

			if underground then
				local height = self.params.share.surface[minp.z + z][minp.x + x].top
				if height then
					top_y = math.min(max.y, height - underground)
				end
			end

			if min.y + top_y + 1 <= 96 and min.y + top_y + 1 >= -16 then
				for _ = min.y, top_y do
					data[ivm] = node_num
					p2data[ivm] = p2

					ivm = ivm + ystride
				end
			end

			index = index + 1
		end
	end
end

--!!!
function Geomorph:write_puzzle(shape, rot, loc)
	local chance = shape.chance or 20
	if self.gpr:next(1, math.max(1, chance)) == 1 then
		--self:write_match_three(shape, rot, loc)

		local l = vector.add(shape.location, vector.floor(vector.divide(shape.size, 2)))
		l.y = shape.location.y
		self:write_chest(l, rot, loc)
	end
end


function Geomorph:write_chest(location, rot, loc)
	local s = {
		action = 'cube',
		location = location,
		node = 'artifacts:antiquorium_chest',
		size = vector.new(1, 1, 1)
	}
	self:write_cube(s, rot, loc)
end

--!!
function Geomorph:write_match_three(shape, rot, loc)
	--local width = shape.size.z - 4
	local p1

	local p = table.copy(shape)
	p.location = vector.add(p.location, -2)
	p.location.y = p.location.y + 2
	p.size = vector.add(p.size, 4)
	p.size.y = p.size.y - 6 + (shape.clear_up or 0)
	p.node = 'air'
	self:write_cube(p, rot, loc)

	p = table.copy(shape)
	p.node = 'match_three:top'
	p.location.y = p.location.y + shape.size.y - 2
	p.size.y = 1
	self:write_cube(p, rot, loc)

	p1 = table.copy(p)
	p1.node = 'match_three:clear_scrith'
	p1.location.y = shape.location.y - 1
	self:write_cube(p1, rot, loc)

	p = table.copy(p)
	p.location.x = p.location.x + 1
	p.location.z = p.location.z + 1
	p.size.x = p.size.x - 2
	p.size.z = p.size.z - 2
	p.node = 'match_three:clear_scrith'
	self:write_cube(p, rot, loc)
end


mod.registered_geomorphs = {}
function mod.register_geomorph(def)
	if not def.name then
		minetest.log(mod_name .. ': cannot register a nameless geomorph')
		return
	end

	mod.registered_geomorphs[def.name] = def
end
