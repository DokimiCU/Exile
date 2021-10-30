---------------------------------------
-- Particles helpers
---------------------------------------


-- trying to locate position for particles by player look direction for performance reason.
-- it is costly to generate many particles around player so goal is focus mainly on front view.
local get_random_pos = function(player, offset)
	local look_dir = player:get_look_dir()
	local player_pos = player:get_pos()

	local random_pos_x = 0
	local random_pos_y = 0
	local random_pos_z = 0

	if look_dir.x > 0 then
		if look_dir.z > 0 then
			random_pos_x = math.random(player_pos.x - offset.back, player_pos.x + offset.front) + math.random()
			random_pos_z = math.random(player_pos.z - offset.back, player_pos.z + offset.front) + math.random()
		else
			random_pos_x = math.random(player_pos.x - offset.back, player_pos.x + offset.front) + math.random()
			random_pos_z = math.random(player_pos.z - offset.front, player_pos.z + offset.back) + math.random()
		end
	else
		if look_dir.z > 0 then
			random_pos_x = math.random(player_pos.x - offset.front, player_pos.x + offset.back) + math.random()
			random_pos_z = math.random(player_pos.z - offset.back, player_pos.z + offset.front) + math.random()
		else
			random_pos_x = math.random(player_pos.x - offset.front, player_pos.x + offset.back) + math.random()
			random_pos_z = math.random(player_pos.z - offset.front, player_pos.z + offset.back) + math.random()
		end
	end

	if offset.bottom ~= nil then
		random_pos_y = math.random(player_pos.y - offset.bottom, player_pos.y + offset.top)
	else
		random_pos_y = player_pos.y + offset.top
	end

	return {x=random_pos_x, y=random_pos_y, z=random_pos_z}
end



-- checks if player is undewater. This is needed in order to
-- turn off weather particles generation.
local is_underwater = function(player)
	local ppos = player:get_pos()
	local offset = player:get_eye_offset()
	local player_eye_pos = {
		x = ppos.x + offset.x,
		y = ppos.y + offset.y + 1.5,
		z = ppos.z + offset.z}
	local node_level = minetest.get_node_level(player_eye_pos)
	if node_level == 8 or node_level == 7 then
		return true
	end
	return false
end


-- outdoor check based on node light level
local is_outdoor = function(pos, offset_y)
	if offset_y == nil then
		offset_y = 0
	end

	if minetest.get_natural_light({x=pos.x, y=pos.y + offset_y, z=pos.z}, 0.5) == 15 then
		return true
	end
	return false
end




climate.add_particle = function(vel, acc, ext, size, tex)
	for _,player in ipairs(minetest.get_connected_players()) do
		if not player then
			return
		end
		if is_underwater(player) then
			return
		end

		--Far particle
		local offset = {
			front = 8,
			back = 5,
			top = 12
		}

		local random_pos = get_random_pos(player, offset)
		local name = player:get_player_name()

		--check if under cover
		if is_outdoor(random_pos) then

			minetest.add_particle({
				pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
				velocity = {x=0, y= vel, z=0},
				acceleration = {x=0, y=acc, z=0},
				expirationtime = ext,
				size = math.random(size/2, size),
				collisiondetection = true,
				collision_removal = true,
				vertical = true,
				texture = tex,
				playername = name
			})

		end

		--close particle
		offset = {
			front = 2,
			back = 0,
			top = 6
		}

		local random_pos = get_random_pos(player, offset)

		--check if under cover
		if is_outdoor(random_pos) then

			minetest.add_particle({
				pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
				velocity = {x=0, y= vel, z=0},
				acceleration = {x=0, y=acc, z=0},
				expirationtime = ext/2,
				size = math.random(size/2, size),
				collisiondetection = true,
				collision_removal = true,
				vertical = true,
				texture = tex,
				playername = name
			})
		end
	end

end



--e.g. duststorm, or more floaty
climate.add_blizzard_particle = function(velxz, vely, accxz, accy, ext, size, tex)
	for _,player in ipairs(minetest.get_connected_players()) do
		if not player then
			return
		end
		if is_underwater(player) then
			return
		end

		--Far particle
		local offset = {
			front = 7,
			back = 3,
			top = 6
		}

		local random_pos = get_random_pos(player, offset)

		local name = player:get_player_name()

		--check if under cover
		if is_outdoor(random_pos) then

			minetest.add_particle({
				pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
				velocity = {x=velxz, y= vely, z=velxz},
				acceleration = {x=accxz, y=accy, z=accxz},
				expirationtime = ext,
				size = math.random(size/2, size),
				collisiondetection = true,
				collision_removal = true,
				vertical = true,
				texture = tex,
				playername = name
			})

		end

		--close particle
		offset = {
			front = 3,
			back = 1,
			top = 3
		}

		local random_pos = get_random_pos(player, offset)

		--check if under cover
		if is_outdoor(random_pos) then

			minetest.add_particle({
				pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
				velocity = {x=velxz, y= vely, z=velxz},
				acceleration = {x=accxz, y=accy, z=accxz},
				expirationtime = ext/2,
				size = math.random(size/2, size),
				collisiondetection = true,
				collision_removal = true,
				vertical = true,
				texture = tex,
				playername = name
			})
		end
	end

end
