-- Megamorph init.lua



megamorph = {}
local mod = megamorph
--local mod_name = 'megamorph'

minetest.set_mapgen_setting('mg_flags', "nodungeons", true)

mod.path = minetest.get_modpath(minetest.get_current_modname())
mod.world = minetest.get_worldpath()
mod.max_height = 31000
mod.morph_depth = -1
mod.registered_loot = {}

mod.time_overhead = 0
minetest.register_on_shutdown(function()
  print('Megamorph time overhead: '..mod.time_overhead)
end)



-- This table looks up nodes that aren't already stored.
mod.node = setmetatable({}, {
	__index = function(t, k)
		if not (t and k and type(t) == 'table') then
			return
		end

		t[k] = minetest.get_content_id(k)
		return t[k]
	end
})
local node = mod.node


----------------------------------------
--Realms
--[[
By depth
150 - 350  --agricultural,
350- 550  --residential
550 - 750  --market
750 - 950  --civic
950 - 1150 --industrial
1150 - 1350 -- mines

--plus a little overlap to help blur them into eachother

--then divided into four quaters to with highways between them
]]


----------------------------------------
--city limits
local ymax = -150
local xzmax = 25000
local hwy_w = 60
local tow_w = 288

--city sections
mod.registered_realms = {

  {name = 'ns_air_shaft', realm_minp = {x = -hwy_w+30, y = ymax+80, z = -xzmax+30}, realm_maxp = {x = hwy_w-30, y = 250, z = xzmax-30}},
  {name = 'ew_air_shaft', realm_minp = {x = -xzmax+30, y = ymax+80, z = -hwy_w+30}, realm_maxp = {x = xzmax-30, y = 250, z = hwy_w-30}},

  {name = 'ns_highway', realm_minp = {x = -hwy_w, y = -1200, z = -xzmax}, realm_maxp = {x = hwy_w, y = ymax, z = xzmax}},
  {name = 'ew_highway', realm_minp = {x = -xzmax, y = -1200, z = -hwy_w}, realm_maxp = {x = xzmax, y = ymax, z = hwy_w}},

  {name = 'n_highway', realm_minp = {x = -xzmax - hwy_w , y = -1200, z = xzmax + hwy_w}, realm_maxp = {x = xzmax + hwy_w, y = ymax, z = xzmax}},
  {name = 's_highway', realm_minp = {x = -xzmax - hwy_w , y = -1200, z = -xzmax - hwy_w}, realm_maxp = {x = xzmax + hwy_w, y = ymax, z = -xzmax}},
  {name = 'e_highway', realm_minp = {x = -xzmax - hwy_w , y = -1200, z = -xzmax}, realm_maxp = {x = -xzmax, y = ymax, z = xzmax}},
  {name = 'w_highway', realm_minp = {x = xzmax , y = -1200, z = -xzmax}, realm_maxp = {x = xzmax + hwy_w, y = ymax, z = xzmax}},

  --Ag
  {name = 'nw_moria_ag', realm_minp = {x = -xzmax, y = -400, z = hwy_w}, realm_maxp = {x = -hwy_w, y = ymax, z = xzmax}},
  {name = 'ne_moria_ag', realm_minp = {x = hwy_w, y = -400, z = hwy_w}, realm_maxp = {x = xzmax, y = ymax, z = xzmax}},
  {name = 'sw_moria_ag', realm_minp = {x = -xzmax, y = -400, z = -xzmax}, realm_maxp = {x = -hwy_w, y = ymax, z = -hwy_w}},
  {name = 'se_moria_ag', realm_minp = {x = hwy_w, y = -400, z = -xzmax}, realm_maxp = {x = xzmax, y = ymax, z = -hwy_w}},

  --Res
  {name = 'nw_moria_res', realm_minp = {x = -xzmax, y = -600, z = hwy_w}, realm_maxp = {x = -hwy_w, y = -350, z = xzmax}},
  {name = 'ne_moria_res', realm_minp = {x = hwy_w, y = -600, z = hwy_w}, realm_maxp = {x = xzmax, y = -350, z = xzmax}},
  {name = 'sw_moria_res', realm_minp = {x = -xzmax, y = -600, z = -xzmax}, realm_maxp = {x = -hwy_w, y = -350, z = -hwy_w}},
  {name = 'se_moria_res', realm_minp = {x = hwy_w, y = -600, z = -xzmax}, realm_maxp = {x = xzmax, y = -350, z = -hwy_w}},

  --mar
  {name = 'nw_moria_mar', realm_minp = {x = -xzmax, y = -800, z = hwy_w}, realm_maxp = {x = -hwy_w, y = -550, z = xzmax}},
  {name = 'ne_moria_mar', realm_minp = {x = hwy_w, y = -800, z = hwy_w}, realm_maxp = {x = xzmax, y = -550, z = xzmax}},
  {name = 'sw_moria_mar', realm_minp = {x = -xzmax, y = -800, z = -xzmax}, realm_maxp = {x = -hwy_w, y = -550, z = -hwy_w}},
  {name = 'se_moria_mar', realm_minp = {x = hwy_w, y = -800, z = -xzmax}, realm_maxp = {x = xzmax, y = -550, z = -hwy_w}},

  --civ
  {name = 'nw_moria_civ', realm_minp = {x = -xzmax, y = -1000, z = hwy_w}, realm_maxp = {x = -hwy_w, y = -750, z = xzmax}},
  {name = 'ne_moria_civ', realm_minp = {x = hwy_w, y = -1000, z = hwy_w}, realm_maxp = {x = xzmax, y = -750, z = xzmax}},
  {name = 'sw_moria_civ', realm_minp = {x = -xzmax, y = -1000, z = -xzmax}, realm_maxp = {x = -hwy_w, y = -750, z = -hwy_w}},
  {name = 'se_moria_civ', realm_minp = {x = hwy_w, y = -1000, z = -xzmax}, realm_maxp = {x = xzmax, y = -750, z = -hwy_w}},

  --ind
  {name = 'nw_moria_ind', realm_minp = {x = -xzmax, y = -1200, z = hwy_w}, realm_maxp = {x = -hwy_w, y = -950, z = xzmax}},
  {name = 'ne_moria_ind', realm_minp = {x = hwy_w, y = -1200, z = hwy_w}, realm_maxp = {x = xzmax, y = -950, z = xzmax}},
  {name = 'sw_moria_ind', realm_minp = {x = -xzmax, y = -1200, z = -xzmax}, realm_maxp = {x = -hwy_w, y = -950, z = -hwy_w}},
  {name = 'se_moria_ind', realm_minp = {x = hwy_w, y = -1200, z = -xzmax}, realm_maxp = {x = xzmax, y = -950, z = -hwy_w}},

  --mine
  {name = 'nw_moria_mine', realm_minp = {x = -xzmax, y = -1400, z = hwy_w}, realm_maxp = {x = -hwy_w, y = -1150, z = xzmax}},
  {name = 'ne_moria_mine', realm_minp = {x = hwy_w, y = -1400, z = hwy_w}, realm_maxp = {x = xzmax, y = -1150, z = xzmax}},
  {name = 'sw_moria_mine', realm_minp = {x = -xzmax, y = -1400, z = -xzmax}, realm_maxp = {x = -hwy_w, y = -1150, z = -hwy_w}},
  {name = 'se_moria_mine', realm_minp = {x = hwy_w, y = -1400, z = -xzmax}, realm_maxp = {x = xzmax, y = -1150, z = -hwy_w}},

  --tower
  {name = 'tower_base', realm_minp = {x = -tow_w, y = -32, z = -tow_w}, realm_maxp = {x = tow_w, y = tow_w, z = tow_w}},

}

---------------------------------------
--functions
---------------------------------------

----
function math.xor(a, b)
	local r = 0
	for i = 0, 31 do
		local x = a / 2 + b / 2
		if x ~= math.floor(x) then
			r = r + 2^i
		end
		a = math.floor(a / 2)
		b = math.floor(b / 2)
	end
	return r
end

-----
local fnv_offset = 2166136261
local fnv_prime = 16777619
function math.fnv1a(data)
	local hash = fnv_offset
	for _, b in pairs(data) do
		hash = math.xor(hash, b)
		hash = hash * fnv_prime
	end
	return hash
end

----
function mod.generate_map_seed()
	-- I use the fixed_map_seed by preference, since minetest 5.0.1
	--  gives the wrong seed to lua when a text map seed is used.
	-- By wrong, I mean that it doesn't match the seed used in the
	--  C code (the one displayed when you hit F5).

	local map_seed = minetest.get_mapgen_setting('fixed_map_seed')
	if map_seed == '' then
		return minetest.get_mapgen_setting('seed')
	else
		-- Just convert each letter into a byte of data.
		local bytes = {map_seed:byte(1, math.min(8, map_seed:len()))}
		local seed = 0
		local i = 1
		for _, v in pairs(bytes) do
			seed = seed + v * i
			i = i * 256
		end
		return seed
	end
end

-----
function mod.generate_block_seed(minp, map_seed)
	local seed = tonumber(map_seed or mod.map_seed)
	local data = {}

	while seed > 0 do
		table.insert(data, seed % 256)
		seed = math.floor(seed / 256)
	end

	for _, axis in pairs({'x', 'y', 'z'}) do
		table.insert(data, math.floor(minp[axis] + mod.max_height) % 256)
		table.insert(data, math.floor((minp[axis] + mod.max_height) / 256))
	end

	return math.fnv1a(data)
end


--for realms
function mod.cube_intersect(r1, r2)
  local axes = { 'x', 'y', 'z' }
	local minp, maxp = {}, {}
	for _, axis in pairs(axes) do
		minp[axis] = math.max(r1.minp[axis], r2.minp[axis])
		maxp[axis] = math.min(r1.maxp[axis], r2.maxp[axis])

		if minp[axis] > maxp[axis] then
			return
		end
	end
	return minp, maxp
end


--
function vector.contains(minp, maxp, x, y, z)
	-- Don't create a vector here. It would be slower.
	if y and z then
		if minp.x > x or maxp.x < x
		or minp.y > y or maxp.y < y
		or minp.z > z or maxp.z < z then
			return
		end
	else
		for _, a in pairs(axes) do
			if minp[a] > x[a] or maxp[a] < x[a] then
				return
			end
		end
	end

	return true
end



-- These nodes will have their on_construct method called
--  when placed by the mapgen (to start timers).
mod.construct_nodes = {}
function mod.add_construct(node_name)
	mod.construct_nodes[node[node_name]] = true
end

----
function mod.do_on_constructs(params)
	-- Call on_construct methods for nodes that request it.
	-- This is mainly useful for starting timers.
	local data, area = params.data, params.area
	for i, n in ipairs(data) do
		if mod.construct_nodes[n] then
			local pos = area:position(i)
			local node_name = minetest.get_name_from_content_id(n)
			if minetest.registered_nodes[node_name] and minetest.registered_nodes[node_name].on_construct then
				minetest.registered_nodes[node_name].on_construct(pos)
			else
				local timer = minetest.get_node_timer(pos)
				if timer then
					timer:start(math.random(100))
				end
			end
		end
	end
end



--Loot

function mod.fill_chest(pos)
	local value = math.random(20)
	if pos.y < -100 then
		local depth = math.log(pos.y / -100)
		depth = depth * depth * depth * 10
		value = value + math.floor(depth)
	end
	local loot = mod.get_loot(value)

	local inv = minetest.get_inventory({ type = 'node', pos = pos })
	if inv then
		for _, it in pairs(loot) do
			if inv:room_for_item('main', it) then
				inv:add_item('main', it)
			end
		end
	end
end


function mod.get_loot(avg_value)
	local value = avg_value or 10
	local loot = {}
	local jump = 3

	if avg_value > 100 then
		jump = 4
	end

	while value > 0 do
		local r = 1
		local its = {}

		for i = 1, 12 do
			if math.random(5) < jump then
				r = r + 1
			else
				break
			end
		end

		while #its < 1 do
			for _, tr in pairs(mod.registered_loot) do
				if tr.rarity == r then
					table.insert(its, tr)
				end
			end
			r = r - 1
		end

		if #its > 0 then
			local it = its[math.random(#its)]
			local it_str = it.name
			local num = it.number.min
			local tool = minetest.registered_tools[it.name] ~= nil
			if tool or it.number.max > num then
				num = math.random(num, it.number.max)
				it_str = it_str .. ' ' .. num
				if tool then
					it_str = it_str .. ' ' .. math.floor(65000 * (math.random(10) + 5) / 20)
				end
			end
			table.insert(loot, it_str)
			value = value - 3 ^ r
		end
	end

	return loot
end



function mod.register_loot(def, force)
	if not def.name or not def.rarity
	or not minetest.registered_items[def.name]
	or (not force and mod.registered_loot[def.name]) then
		print(mod_name .. ': not (re)registering ' .. (def.name or 'nil'))
		--print(dump(def))
		return
	end

	if not def.level then
		def.level = 1
	end

	if not def.number then
		def.number = {}
	end
	if not def.number.min then
		def.number.min = 1
	end
	if not def.number.max then
		def.number.max = def.number.min
	end

	mod.registered_loot[def.name] = def
end



minetest.after(0, function()
	local options = {}
  --level, rarity, max stack (nil for unstackables)
  --not sure what, if anything, level does (original seems to have all at 1)
  --Examples from original:
	-- 1 wood / stone
	-- 2 coal
	-- 3 iron
	-- 4 gold
	-- 5 diamond
	-- 6 mese
  --[[
  options['default:desert_cobble']      =  {  1,  1,   20     }
  options['default:coal_lump']         =  {  1,  2,    10    }
  options['map:mapping_kit']            =  { 1, 4, nil }
  options['default:pick_diamond']      =  {  1,  6,   nil   }
  ]]

  --Only those items whch could survive centuries.
  --e.g. no food, wood/fabric etc rare
  --no tools, materials etc that allow to skip easily up the tech progression.

  --raw materials (rarity 1)

  options['nodes_nature:granite_boulder'] =  { 1, 1, 2 }
  options['nodes_nature:basalt_boulder'] =  { 1, 1, 2 }
  options['nodes_nature:limestone_boulder'] =  { 1, 1, 2 }
  options['nodes_nature:ironstone_boulder'] =  { 1, 1, 2 }
  options['nodes_nature:gravel'] =  { 1, 1, 2 }
  options['nodes_nature:sand'] =  { 1, 1, 2 }
  options['nodes_nature:silt'] =  { 1, 1, 2 }
  options['nodes_nature:clay'] =  { 1, 1, 2 }
  options['nodes_nature:loam'] =  { 1, 1, 2 }
  options['tech:wood_ash'] =  { 1, 1, 2 }
  options['tech:broken_pottery'] =  { 1, 1, 2 }


  --cheap processed materials (rarity 2)
  options['nodes_nature:granite_brick'] =  { 1, 2, 4 }
  options['nodes_nature:basalt_brick'] =  { 1, 2, 4 }
  options['nodes_nature:limestone_brick'] =  { 1, 1, 4 }
  options['nodes_nature:granite_block'] =  { 1, 2, 4 }
  options['nodes_nature:basalt_block'] =  { 1, 2, 4 }
  options['nodes_nature:limestone_block'] =  { 1, 2, 4 }

  options['nodes_nature:gneiss_boulder'] =  { 1, 2, 2 }


  --medium processed materials, cheap tools (rarity 3)
  options['tech:mortar_pestle_basalt'] =  { 1, 3, nil }
  options['tech:mortar_pestle_granite'] =  { 1, 3, nil }
  options['tech:mortar_pestle_limestone'] =  { 1, 3, nil }
  options['tech:clay_water_pot'] =  { 1, 3, nil }
  options['tech:clay_storage_pot'] =  { 1, 3, nil }
  options['tech:clay_oil_lamp_empty'] =  { 1, 3, nil }
  options['tech:charcoal'] =  { 1, 3, 2 }

  options['nodes_nature:gneiss_brick'] =  { 1, 3, 2 }
  options['nodes_nature:gneiss_block'] =  { 1, 3, 2 }
  options['nodes_nature:jade_boulder'] =  { 1, 3, 2 }

  --costly processed materials, expensive tools, crap artifacts (rarity 4)
  options['artifacts:moon_glass'] =  { 1, 4, 1 }
  options['artifacts:antiquorium_ladder'] =  { 1, 4, 1 }
  options['artifacts:antiquorium'] =  { 1, 4, 1 }
  options['doors:door_antiquorium'] =  { 1, 4, nil }
  options['artifacts:trapdoor_antiquorium'] =  { 1, 4, 1 }
  options['nodes_nature:jade_block'] =  { 1, 4, 2 }
  options['nodes_nature:jade_brick'] =  { 1, 4, 2 }

  --options['nodes_nature:zufani_seed'] =  { 1, 4, 4 }


  --low level artifacts (rarity 5), non-durables
  options['artifacts:conveyor'] =  { 1, 5, 24 }
  options['artifacts:trampoline'] =  { 1, 5, nil }

  --options['nodes_nature:merki_seed'] =  { 1, 5, 4 }

  options['artifacts:light_meter'] =  { 1, 5, nil }
  --options['artifacts:thermometer'] =  { 1, 5, nil }
  options['artifacts:temp_probe'] =  { 1, 5, nil }
  options['artifacts:fuel_probe'] =  { 1, 5, nil }
  options['artifacts:smelter_probe'] =  { 1, 5, nil }
  options['artifacts:potters_probe'] =  { 1, 5, nil }
  options['artifacts:chefs_probe'] =  { 1, 5, nil }
  options['artifacts:farmers_probe'] =  { 1, 5, nil }
  options['artifacts:animal_probe'] =  { 1, 5, nil }

  options['artifacts:spyglass'] =  { 1, 5, nil }
  options['artifacts:bell'] =  { 1, 5, nil }
  options['artifacts:waystone'] =  { 1, 5, nil }
  options['artifacts:wayfinder_0'] =  { 1, 5, nil }

  options['tech:stick'] =  { 1, 5, 1 }

  options['tech:fine_fibre'] =  { 1, 5, nil }
  options['tech:coarse_fibre'] =  { 1, 5, nil }
  options['tech:paint_lime_white'] =  { 1, 5, nil }
  options['tech:paint_glow_paint'] =  { 1, 5, nil }

  options['artifacts:sculpture_mg_dancers'] =  { 1, 5, nil }
  options['artifacts:sculpture_mg_bonsai'] =  { 1, 5, nil }
  options['artifacts:sculpture_mg_bloom'] =  { 1, 5, nil }
  options['artifacts:sculpture_j_axeman'] =  { 1, 5, nil }
  options['artifacts:sculpture_j_dragon_head'] =  { 1, 5, nil }
  options['artifacts:sculpture_j_skull_head'] =  { 1, 5, nil }

  options['artifacts:star_stone'] =  { 1, 5, 12 }
  options['artifacts:singing_stone'] =  { 1, 5, 12 }
  options['artifacts:drumming_stone'] =  { 1, 5, 12 }

  options['artifacts:gamepiece_a_black'] =  { 1, 5, 12 }
  options['artifacts:gamepiece_a_white'] =  { 1, 5, 12 }
  options['artifacts:gamepiece_b_black'] =  { 1, 5, 12 }
  options['artifacts:gamepiece_b_white'] =  { 1, 5, 12 }
  options['artifacts:gamepiece_c_black'] =  { 1, 5, 12 }
  options['artifacts:gamepiece_c_white'] =  { 1, 5, 12 }

  --high level artifacts, and intact non-durables (rarity 6)
  options['artifacts:moon_stone'] =  { 1, 6, nil }
  options['artifacts:sun_stone'] =  { 1, 6, nil }

  options['tech:fine_fabric'] =  { 1, 6, nil }
  options['tech:torch'] =  { 1, 6, nil }
  options['tech:vegetable_oil'] =  { 1, 6, nil }
  options['tech:coarse_fabric'] =  { 1, 6, nil }
  options['tech:mattress'] =  { 1, 6, 1 }
  --options["backpacks:backpack_fabric_bag"] =  { 1, 6, 1 }

  options['artifacts:airboat'] =  { 1, 6, nil }
  options['artifacts:mapping_kit'] =  { 1, 6, nil }
  options['artifacts:antiquorium_chisel'] =  { 1, 6, nil }

  options['artifacts:transporter_key'] =  { 1, 6, nil }
  options['artifacts:transporter_regulator'] =  { 1, 6, nil }
  options['artifacts:transporter_stabilizer'] =  { 1, 6, nil }
  options['artifacts:transporter_focalizer'] =  { 1, 6, nil }
  options['artifacts:transporter_power_dep'] =  { 1, 6, nil }
  options['artifacts:transporter_power'] =  { 1, 6, nil }
  options['artifacts:transporter_pad'] =  { 1, 6, nil }

  options['nodes_nature:lambakap_seed'] =  { 1, 6, 4 }
  options['nodes_nature:reshedaar_seed'] =  { 1, 6, 4 }
  options['nodes_nature:mahal_seed'] =  { 1, 6, 4 }

  options['artifacts:sculpture_g_arch_judge'] =  { 1, 6, nil }
  options['artifacts:sculpture_g_arch_beast'] =  { 1, 6, nil }
  options['artifacts:sculpture_g_arch_trickster'] =  { 1, 6, nil }
  options['artifacts:sculpture_g_arch_mother'] =  { 1, 6, nil }

  options['artifacts:metastim'] =  { 1, 6, nil }


	for name, d in pairs(options) do
		if minetest.registered_items[name] then
			local def = {
				level = d[1],
				rarity = d[2],
				name = name,
				number = {
					min = 1,
					max = d[3] or 1,
				},
			}
			mod.register_loot(def, true)
		end
	end

	for name, desc in pairs(minetest.registered_items) do
		if name:find('^wool:') then
			local def = {
				level = 1,
				rarity = 100,
				name = name,
				number = {
					min = 1,
					max = 10,
				},
			}
		end
	end
end)






--------------------------------------
dofile(mod.path .. '/geomorph.lua')
dofile(mod.path .. '/plans.lua')
dofile(mod.path .. '/mapgen.lua')
