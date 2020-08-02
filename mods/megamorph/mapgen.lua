-- Megamorph mapgen.lua

local DEBUG

local mod = megamorph
local mod_name = 'megamorph'
local megamorph_depth = megamorph.morph_depth


--------------------------------------------------------------------------

function mod.save_map(params)
	local t_over = os.clock()

	local area, data, node = params.area, params.data, mod.node

--[[
	local n_stone = node['default:stone']
	local n_placeholder_lining
	if minetest.registered_nodes[mod_name .. ':placeholder_lining'] then
		n_placeholder_lining = node[mod_name .. ':placeholder_lining']

		local screwed_up
		for i = 1, #data do
			if data[i] == n_placeholder_lining then
				data[i] = n_stone
				screwed_up = area:position(i)
			end
		end
		if screwed_up then
			print(mod_name .. ': Correcting for minetest voxelmanip bug at around (' .. screwed_up.x .. ',' .. screwed_up.y .. ',' .. screwed_up.z .. '). Biome data has been replaced with default nodes.')
		end
	end
	]]

	params.vm:set_data(params.data)
	params.vm:set_param2_data(params.p2data)

	if DEBUG then
		params.vm:set_lighting({day = 10, night = 10})
	else
		params.vm:set_lighting({day = 0, night = 0})
		params.vm:calc_lighting()
	end

	params.vm:update_liquids()
	params.vm:write_to_map()

	-- Save all meta data for chests, cabinets, etc.

	for _, t in ipairs(params.metadata) do
		local meta = minetest.get_meta({x=t.x, y=t.y, z=t.z})
		meta:from_table()
		meta:from_table(t.meta)
	end


	mod.do_on_constructs(params)


	do
		--local ps = PcgRandom(os.time())
		for _, v in ipairs(params.share.treasure_chests or {}) do
			local n = minetest.get_node_or_nil(v)
			if n then

				minetest.registered_nodes['artifacts:antiquorium_chest'].on_construct(v)

				local meta = minetest.get_meta(v)
				local inv = meta:get_inventory()
				local listsz = inv:get_size("main")
				if listsz > 0 then
					mod.fill_chest(v)
				end
			end
		end
	end

	mod.time_overhead = mod.time_overhead + os.clock() - t_over
end








--------------------------------------------------------------------------
local data = {}
local p2data = {}

local function generate(p_minp, p_maxp, seed)

  if not (p_minp and p_maxp and seed) then
    return
  end

  --realms
  local minp, maxp = p_minp, p_maxp

  local params = {}
  params.chunk_minp = minp
  params.chunk_maxp = maxp

  local realms = {}
	for _, realm in pairs(mod.registered_realms) do
		-- This won't necessarily find realms smaller than a chunk.
		local isect_minp, isect_maxp = mod.cube_intersect(
			{minp = params.chunk_minp, maxp = params.chunk_maxp},
			{minp = realm.realm_minp, maxp = realm.realm_maxp}
		)

		if isect_minp and isect_maxp then
      table.insert(realms, realm.name)
		end
	end

	if #realms < 1 then
		return
	end

  --parameters
  local avg = (minp.y + maxp.y) / 2
  local csize = vector.add(vector.subtract(maxp, minp), 1)
  local chunk = vector.floor(vector.divide(vector.add(minp, 32), 80))

  local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
  if not (vm and emin and emax) then
    return
  end

  data = vm:get_data()
  p2data = vm:get_param2_data()
  local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})


  local heightmap = minetest.get_mapgen_object("heightmap")
  local surface = {}

  local index = 0
  for z = minp.z, maxp.z do
    surface[z] = {}
    for x = minp.x, maxp.x do
      index = index + 1
      local height = heightmap[index]
      height = math.floor(height + 0.5)
      surface[z][x] = {
        top = height
      }
    end
  end

  local map_seed = mod.generate_map_seed()
  local blockseed = mod.generate_block_seed(minp, map_seed)


  params.area = area
	params.csize = csize
	params.data = data
	params.gpr = PcgRandom(blockseed + 772)
	params.isect_minp = minp
	params.isect_maxp = maxp
	params.node = mod.node
  params.p2data = p2data

  params.share = {}
  params.share.surface = surface
  params.share.treasure_chests = {} --?

  params.vm = vm
  params.metadata = {}


  --Select a random one of the realms available
  local ran_realm = realms[math.random(1, #realms)]

  --select geomorphs for this realm
	local box_names = {}
	for k, v in pairs(mod.registered_geomorphs) do
		if v.areas and v.areas:find(ran_realm) then
			table.insert(box_names, v.name)
		end
	end

	if #box_names < 1 then
		return
	end


  --get a random box
  local box_seed = chunk.z * 10000 + chunk.y * 100 + chunk.x + 150
  local bgpr = PcgRandom(box_seed)
  local box_type = box_names[bgpr:next(1, #box_names)]
  local box = mod.registered_geomorphs[box_type]

  --create box
	local geo = Geomorph.new(params, box)
	geo:write_to_map(0)



  mod.save_map(params)

end






local function pgenerate(...)
  local status, err = pcall(generate, ...)

  if not status then
    print('megamorph: Could not generate terrain:')
    print(dump(err))
    collectgarbage("collect")
  end
end


--minetest.register_on_generated(pgenerate)

--debug
minetest.register_on_generated(generate)
