-- NOTE: This code contains some hacks to work around a number of bugs in mapgen v7 and in Minetest's core mapgen code.
-- The issue URLs for those bugs are included in comments wherever those hacks are used, if the issues get resolved
-- then the associated hacks should be removed.
-- https://github.com/minetest/minetest/issues/7878
-- https://github.com/minetest/minetest/issues/7864

local modpath = minetest.get_modpath(minetest.get_current_modname())


--
local water_level = tonumber(minetest.get_mapgen_setting("water_level"))
local mapgen_seed = tonumber(minetest.get_mapgen_setting("seed"))

--volcano size
local max_height = 500
local min_height = 300
local depth_root = -2000

--volcano spacing
local region_mapblocks = 32 --ie 16x80 = 1280 between
local mapgen_chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))
local volcano_region_size = region_mapblocks * mapgen_chunksize * 16

--type probabilities
local p_active = 0.15
local p_dormant = 0.3
local p_extinct = 0.15
local state_dormant = 1 - p_active
local state_extinct = 1 - p_active - p_dormant
local state_none = 1 - p_active - p_dormant - p_extinct

if p_active + p_dormant + p_extinct > 1.0 then
	minetest.log("error", "[volcano] probabilities of various volcano types adds up to more than 1")
end

--shape
local depth_maxwidth = -30 -- point of maximum width
local slope_max = 2 --i.e. 2*300 = 600 radius
local radius_lining = 5 -- cf vent radius
local radius_cone_max =  (max_height - depth_maxwidth) * slope_max + radius_lining + 20
local slope_min = 1

local caldera_min = 4 -- minimum radius of caldera
local caldera_max = 32 -- maximum radius of caldera

local chamber_radius_multiplier = 0.5

local depth_base = -50 -- point where the mountain root starts expanding

local radius_vent = 8 -- approximate minimum radius of vent - noise adds a lot to this

local depth_maxwidth_dist = depth_maxwidth-depth_base

--nodes
local snow_line = 350 -- above this elevation snow is added to the dirt type
local snow_border = 25 -- transitional zone

local c_ocean_sed = minetest.get_content_id("nodes_nature:gravel_wet_salty")
local c_dune_soil = minetest.get_content_id("nodes_nature:duneland_soil")
local c_sand = minetest.get_content_id("nodes_nature:sand")
local c_gravel = minetest.get_content_id("nodes_nature:gravel")
local c_snow = minetest.get_content_id("nodes_nature:snow")
local c_high_soil = minetest.get_content_id("nodes_nature:highland_soil")
local c_moss = minetest.get_content_id("nodes_nature:moss")

local c_lava =  minetest.get_content_id("nodes_nature:lava_source")
local c_basalt = minetest.get_content_id("nodes_nature:basalt")
local c_boulder = minetest.get_content_id("nodes_nature:basalt_boulder")

local c_air = minetest.get_content_id("air")

local c_cone = c_basalt



------------------------------------------------------------------------
-- offset for alignment
local get_corner = function(pos)
	return {x = math.floor((pos.x+32) / volcano_region_size) * volcano_region_size - 32, z = math.floor((pos.z+32) / volcano_region_size) * volcano_region_size - 32}
end

------------------------------------------------------------------------
local scatter_2d = function(min_xz, gridscale, border_width)
	local bordered_scale = gridscale - 2 * border_width
	local point = {}
	point.x = math.random() * bordered_scale + min_xz.x + border_width
	point.y = 0
	point.z = math.random() * bordered_scale + min_xz.z + border_width
	return point
end

-------------------------------------------------------------------
--location and type
local get_volcano = function(pos)

	local corner_xz = get_corner(pos)
	local next_seed = math.random(1, 1000000000)
	math.randomseed(corner_xz.x + corner_xz.z * 2 ^ 8 + mapgen_seed)

	local state = math.random()
	if state < state_none then
		return nil
	end

	local location = scatter_2d(corner_xz, volcano_region_size, radius_cone_max)
	local depth_peak = math.random(min_height, max_height)
	local depth_lava

	if state < state_extinct then
		depth_lava = - math.random(1, math.abs(depth_root)) -- extinct, put the lava somewhere deep.
	elseif state < state_dormant then
		depth_lava = depth_peak - math.random(5, 50) -- dormant
	else
		depth_lava = depth_peak - math.random(1, 25) -- active, put the lava near the top
	end
	local slope = math.random() * (slope_max - slope_min) + slope_min
	local caldera = math.random() * (caldera_max - caldera_min) + caldera_min

	math.randomseed(next_seed)
	return {location = location, depth_peak = depth_peak, depth_lava = depth_lava, slope = slope, state = state, caldera = caldera}
end



-----------------------------------------------------------------------------
local perlin_params = {
	offset = 0,
	scale = 1,
	spread = {x=30, y=30, z=30},
	seed = -40681,
	octaves = 3,
	persist = 0.7
}

local nvals_perlin_buffer = {}
local nobj_perlin = nil
local data = {}



-----------------------------------------------------------
minetest.register_on_generated(function(minp, maxp, seed)
	--outside range
	if minp.y > max_height or maxp.y < depth_root then
		return
	end

	local volcano = get_volcano(minp)

	if volcano == nil then
		return -- no volcano in this map region
	end

	local depth_peak = volcano.depth_peak
	local base_radius = (depth_peak - depth_maxwidth) * volcano.slope + radius_lining
	local chamber_radius = (base_radius / volcano.slope) * chamber_radius_multiplier

	-- early out if the volcano is too far away to matter
	-- The plus 20 is because the noise being added will generally be in the 0-20 range, see the "distance" calculation below
	if volcano.location.x - base_radius - 20 > maxp.x
	or volcano.location.x + base_radius + 20 < minp.x
	or volcano.location.z - base_radius - 20 > maxp.z
	or volcano.location.z + base_radius + 20 < minp.z
	then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	vm:get_data(data)

	local sidelen = mapgen_chunksize * 16 --length of a mapblock
	local chunk_lengths = {x = sidelen, y = sidelen, z = sidelen} --table of chunk edges

	nobj_perlin = nobj_perlin or minetest.get_perlin_map(perlin_params, chunk_lengths)
	local nvals_perlin = nobj_perlin:get_3d_map_flat(minp, nvals_perlin_buffer)
	local noise_area = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
	local noise_iterator = noise_area:iterp(minp, maxp)

	local x_coord = volcano.location.x
	local z_coord = volcano.location.z
	local depth_lava = volcano.depth_lava
	local caldera = volcano.caldera
	local state = volcano.state


	-------------------------------------------------
	for vi, x, y, z in area:iterp_xyz(minp, maxp) do
		local vi3d = noise_iterator()

		local distance_perturbation = (nvals_perlin[vi3d]+1)*10
		local distance = vector.distance({x=x, y=y, z=z}, {x=x_coord, y=y, z=z_coord}) - distance_perturbation


		-- Determine what materials to use at this y level
		local c_top
		local c_filler
		local c_dust

		if state < state_dormant then
			if y < water_level + 2 then
				c_top = c_ocean_sed
				c_filler = c_ocean_sed
			elseif y > snow_line then
				c_top = c_high_soil
				c_filler =  c_gravel
				c_dust = c_snow
			elseif y > snow_line - snow_border then
				c_top = c_high_soil
				c_filler =  c_gravel
				if math.random()>0.25 then
					c_dust = c_snow
				end
			elseif y > snow_line - snow_border *2 then
				c_top = c_high_soil
				c_filler =  c_gravel
				if math.random()>0.5 then
					c_dust = c_snow
				end
			elseif y > snow_line - snow_border *3 then
				c_top = c_dune_soil
				c_filler =  c_gravel
				if math.random()>0.75 then
					c_dust = c_snow
				end
			else
				--c_dust = c_boulder
				c_top = c_dune_soil
				c_filler = c_gravel
			end
		elseif y > snow_line then
			c_dust = c_snow
			c_top = c_sand
			c_filler = c_gravel
		else
			--c_dust = c_boulder
			c_top = c_sand
			c_filler = c_gravel
		end

		local pipestuff
		local liningstuff
		if y < depth_lava + math.random() * 1.1 then
			pipestuff = c_lava
			liningstuff = c_basalt
		else
			if state < state_dormant then
				pipestuff = c_basalt -- dormant volcano
				liningstuff = c_basalt
			else
				pipestuff = c_air -- active volcano
				liningstuff = c_basalt
			end
		end

		-- Actually create the volcano
		if y < depth_base then
			if y < depth_root + chamber_radius then -- Magma chamber lower half
				local lower_half = ((y - depth_root) / chamber_radius) * chamber_radius
				if distance < lower_half + radius_vent then
					data[vi] = c_lava -- Put lava in the magma chamber even for extinct volcanoes, if someone really wants to dig for it it's down there.
				elseif distance < lower_half + radius_lining and data[vi] ~= c_air and data[vi] ~= c_lava then -- leave holes into caves and into existing lava
					data[vi] = liningstuff
				end
			elseif y < depth_root + chamber_radius * 2 then -- Magma chamber upper half
				local upper_half = (1 - (y - depth_root - chamber_radius) / chamber_radius) * chamber_radius
				if distance < upper_half + radius_vent then
					data[vi] = c_lava
				elseif distance < upper_half + radius_lining and data[vi] ~= c_air and data[vi] ~= c_lava then -- leave holes into caves and into existing lava
					data[vi] = liningstuff
				end
			else -- pipe
				if distance < radius_vent then
					data[vi] = pipestuff
				elseif distance < radius_lining and data[vi] ~= c_air and data[vi] ~= c_lava then -- leave holes into caves and into existing lava
					data[vi] = liningstuff
				end
			end
		elseif y < depth_maxwidth then -- root
			if distance < radius_vent then
				data[vi] = pipestuff
			elseif distance < radius_lining then
				data[vi] = liningstuff
			elseif distance < radius_lining + ((y - depth_base)/depth_maxwidth_dist) * base_radius then
				data[vi] = c_cone
			end
		elseif y < depth_peak + 5 then -- cone
			local current_elevation = y - depth_maxwidth
			local peak_elevation = depth_peak - depth_maxwidth
			if current_elevation > peak_elevation - caldera and distance < current_elevation - peak_elevation + caldera then
				data[vi] = c_air -- caldera
			elseif distance < radius_vent then
				data[vi] = pipestuff
			elseif distance < radius_lining then
				data[vi] = liningstuff
			elseif distance <  current_elevation * -volcano.slope + base_radius then
				data[vi] = c_cone
				if data[vi + area.ystride] == c_air and c_dust ~= nil then
					if c_dust ~= c_boulder and math.random()>0.95 then
						c_dust = c_boulder
					end
					data[vi + area.ystride] = c_dust
				end
			elseif c_top ~= nil and c_filler ~= nil and distance < current_elevation * -volcano.slope + base_radius + nvals_perlin[vi3d] +1.5 then
				data[vi] = c_top
				if data[vi - area.ystride] == c_top then
					data[vi - area.ystride] = c_filler
				end
				if data[vi + area.ystride] == c_air then
					if math.random()>0.95 then
						data[vi + area.ystride] = c_moss
					elseif math.random()>0.995 then
						data[vi + area.ystride] = c_boulder
					elseif c_dust ~= nil then
						data[vi + area.ystride] = c_dust
					end
				end
			end

		end
	end

	--send data back to voxelmanip
	vm:set_data(data)
	--calc lighting
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:update_liquids()
	--write it to world
	vm:write_to_map()
end)

----------------------------------------------------------------------------------------------
-- Debugging and sightseeing commands

minetest.register_privilege("findvolcano", { description = "Allows players to use a console command to find volcanoes", give_to_singleplayer = false})

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

local send_volcano_state = function(pos, name)
	local corner_xz = get_corner(pos)
	local volcano = get_volcano(pos)
	if volcano == nil then
		return false
	end
	local location = {x=math.floor(volcano.location.x), y=volcano.depth_peak, z=math.floor(volcano.location.z)}
	local text = "Peak at " .. minetest.pos_to_string(location)
		.. ", Slope: " .. tostring(round(volcano.slope, 2))
		.. ", State: "
	if volcano.state < state_extinct then
		text = text .. "Extinct"
	elseif volcano.state < state_dormant then
		text = text .. "Dormant"
	else
		text = text .. "Active"
	end

	minetest.chat_send_player(name, text)
	return true
end

local send_nearby_states = function(pos, name)
	local retval = false
	retval = send_volcano_state({x=pos.x-volcano_region_size, y=0, z=pos.z+volcano_region_size}, name) or retval
	retval = send_volcano_state({x=pos.x, y=0, z=pos.z+volcano_region_size}, name) or retval
	retval = send_volcano_state({x=pos.x+volcano_region_size, y=0, z=pos.z+volcano_region_size}, name) or retval
	retval = send_volcano_state({x=pos.x-volcano_region_size, y=0, z=pos.z}, name) or retval
	retval = send_volcano_state(pos, name) or retval
	retval = send_volcano_state({x=pos.x+volcano_region_size, y=0, z=pos.z}, name) or retval
	retval = send_volcano_state({x=pos.x-volcano_region_size, y=0, z=pos.z-volcano_region_size}, name) or retval
	retval = send_volcano_state({x=pos.x, y=0, z=pos.z-volcano_region_size}, name) or retval
	retval = send_volcano_state({x=pos.x+volcano_region_size, y=0, z=pos.z-volcano_region_size}, name) or retval
	return retval
end

minetest.register_chatcommand("findvolcano", {
    params = "pos", -- Short parameter description
    description = "find the volcanoes near the player's map region, or in the map region containing pos if provided",
    func = function(name, param)
		if minetest.check_player_privs(name, {findvolcano = true}) then
			local pos = {}
			pos.x, pos.y, pos.z = string.match(param, "^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			pos.x = tonumber(pos.x)
			pos.y = tonumber(pos.y)
			pos.z = tonumber(pos.z)
			if pos.x and pos.y and pos.z then
				if not send_nearby_states(pos, name) then
					minetest.chat_send_player(name, "No volcanoes near " .. minetest.pos_to_string(pos))
				end
				return true
			else
				local playerobj = minetest.get_player_by_name(name)
				pos = playerobj:get_pos()
				if not send_nearby_states(pos, name) then
					pos.x = math.floor(pos.x)
					pos.y = math.floor(pos.y)
					pos.z = math.floor(pos.z)
					minetest.chat_send_player(name, "No volcanoes near " .. minetest.pos_to_string(pos))
				end
				return true
			end
		else
			return false, "You need the findvolcano privilege to use this command."
		end
	end,
})
