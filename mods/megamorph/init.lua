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
----------------------------------------

mod.registered_realms = {
  {name = 'geomoria', realm_minp = {x = -31000, y = -1000, z = -31000}, realm_maxp = {x = 31000, y = -120, z = 31000}},

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
--[[
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
	-- 1 wood / stone
	-- 2 coal
	-- 3 iron
	-- 4 gold
	-- 5 diamond
	-- 6 mese
	--options['booty:flaming_sword']       =  {  1,  10,   nil   }
	--options['booty:philosophers_stone']  =  {  1,  10,  nil   }
	--options['booty:unobtainium']         =  {  1,  10,  nil   }
	options['bucket:bucket_empty']       =  {  1,  3,    2     }
	options['bucket:bucket_lava']      =  {  1,  5,   nil     }
	options['bucket:bucket_water']      =  {  1,  4,   nil     }
	options['carts:rail']      =  {  1,  4,   nil     }
	options['default:acacia_wood']       =  {  1,  1,    10    }
	options['default:apple']             =  {  1,  1,    10    }
	options['default:axe_diamond']      =  {  1,  6,   nil     }
	options['default:book']              =  {  1,  3,    10    }
	options['default:cactus']      =  {  1,  1,   5     }
	options['default:coal_lump']         =  {  1,  2,    10    }
	options['default:desert_cobble']      =  {  1,  1,   20     }
	options['default:desert_sand']      =  {  1,  1,   20     }
	options['default:diamond']           =  {  1,  5,   5     }
	options['default:dirt']      =  {  1,  1,   20     }
	options['default:flint']      =  {  1,  2,   5     }
	options['default:glass']             =  {  1,  3,    5     }
	options['default:gold_ingot']        =  {  1,  4,   5     }
	options['default:junglewood']        =  {  1,  1,    10    }
	options['default:mese']      =  {  1,  7,   5     }
	options['default:mese_crystal']      =  {  1,  6,   nil   }
	options['default:meselamp']          =  {  1,  7,   nil   }
	options['default:obsidian']          =  {  1,  6,   nil   }
	options['default:obsidian_glass']    =  {  1,  6,   5     }
	options['default:obsidian_shard']    =  {  1,  5,    nil   }
	options['default:paper']             =  {  1,  2,    10    }
	options['default:pick_diamond']      =  {  1,  6,   nil   }
	options['default:pick_mese']         =  {  1,  7,   nil   }
	options['default:pick_steel']      =  {  1,  4,   nil   }
	options['default:pick_stone']      =  {  1,  2,   nil   }
	options['default:pick_wood']      =  {  1,  1,   nil   }
	options['default:sand']      =  {  1,  1,   20     }
	options['default:steel_ingot']       =  {  1,  3,    5     }
	options['default:stick']      =  {  1,  1,   20     }
	options['default:sword_diamond']     =  {  1,  6,   nil   }
	options['default:sword_mese']        =  {  1,  7,   nil   }
	options['default:sword_steel']      =  {  1,  4,   nil   }
	options['default:sword_stone']      =  {  1,  2,   nil   }
	options['default:sword_wood']      =  {  1,  1,   nil   }
	options['default:wood']              =  {  1,  1,    10    }
	options['dinv:bag_large']             =  { 1, 5, nil }
	options['dinv:bag_medium']            =  { 1, 4, nil }
	options['dinv:bag_small']             =  { 1, 3, nil }
	options['dinv:boots']                 =  { 1, 3, nil }
	options['dinv:chain_armor']           =  { 1, 6, nil }
	options['dinv:fur_cloak']             =  { 1, 3, nil }
	options['dinv:leather_armor']         =  { 1, 4, nil }
	options['dinv:leather_cap']           =  { 1, 4, nil }
	options['dinv:plate_armor']           =  { 1, 8, nil }
	options['dinv:ring_breath']           =  { 1, 6, nil }
	options['dinv:ring_leap']             =  { 1, 5, nil }
	options['dinv:ring_protection_9']     =  { 1, 5, nil }
	options['dinv:steel_shield']          =  { 1, 5, nil }
	options['dinv:wood_shield']           =  { 1, 3, nil }
	options['dpies:apple_pie']           =  {  1,  3,   10    }
	options['dpies:blueberry_pie']        =  {  1,   3,   nil   }
	options['dpies:meat_pie']            =  {  1,  3,   10    }
	options['dpies:onion']               =  {  1,  1,    10    }
	options['farming:cotton']            =  {  1,  1,    10    }
	options['farming:flour']             =  {  1,  1,    10    }
	options['farming:seed_cotton']       =  {  1,  1,    10    }
	options['farming:seed_wheat']        =  {  1,  1,    10    }
	options['farming:string']      =  {  1,  2,   5     }
	options['farming:wheat']      =  {  1,  1,   20     }
	options['fire:permanent_flame']      =  {  1,  4,   nil   }
	options['fun_tools:flare_gun']        =  { 1, 4, nil }
	options['fun_tools:molotov_cocktail'] =  { 1, 4, 5 }
	options['fun_tools:naptha']           =  { 1, 3, 5 }
	options['mapgen:moon_glass']      =  {  1,  4,   5     }
	--options['mapgen:moon_juice']      =  {  1,  4,   5     }
	--options['mapgen:moonstone']       =  {  1,  5,   nil   }
	options['map:mapping_kit']            =  { 1, 4, nil }
	options['tnt:gunpowder']              =  { 1, 3, 10 }
	options['vessels:glass_fragments']      =  {  1,  2,   5     }
	options['wooden_bucket:bucket_wood_empty']       =  {  1,  3,    nil     }
	options['wool:white']                =  {  1,  1,    nil     }

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



do
	local orig_loot_reg = dungeon_loot.register
	dungeon_loot.register = function(def)
		if not def or def.chance <= 0 then
			return
		end

		mod.register_loot({
			name = def.name,
			rarity = math.ceil(1 / 2 / def.chance),
			level = def.level or 1,
			number = {
				min = def.count[1] or 1,
				max = def.count[2] or 1,
			},
		})

		orig_loot_reg(def)
	end
end
]]


--------------------------------------
dofile(mod.path .. '/geomorph.lua')
dofile(mod.path .. '/plans.lua')
dofile(mod.path .. '/mapgen.lua')
