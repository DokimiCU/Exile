--[[
Copyright (c) 2022 Skamiz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

dofile(minetest.get_modpath("rings") .. "/noise.lua")
noise_handler = noise_handler

minetest.register_node("rings:antiquorium", {
	description = "Antiquorium",
	tiles = {"artifacts_antiquorium.png"},
	stack_max = minimal.stack_max_bulky *4,
	sounds = nodes_nature.node_sound_glass_defaults(),
	paramtype = "light",
	groups = {cracky = 1, not_in_creative_inventory = 1},
	after_place_node = minimal.protection_after_place_node,
	drop = "artifacts:antiquorium"
})
minetest.register_node("rings:moon_glass", {
	description = "Moon Glass",
	drawtype = "glasslike",
	tiles = {"artifacts_moon_glass.png"},
	stack_max = minimal.stack_max_bulky *4,
	light_source = 5,
	paramtype = "light",
	sunlight_propagates  = true,
	use_texture_alpha = "clip",
	sounds = nodes_nature.node_sound_glass_defaults(),
	groups = {cracky = 1,},
	after_place_node = minimal.protection_after_place_node,
	drop = "artifacts:moon_glass",
})

dofile(minetest.get_modpath("rings") .. "/meru.lua")

local c_ring = minetest.get_content_id("rings:antiquorium")
local c_ring_i = minetest.get_content_id("rings:moon_glass") -- TODO: replace this with a glowing material

--noise parameters
-- base terrain height
np_2d_base = {
    offset = 0,
    scale = 7,
    spread = {x = 80, y = 80, z = 80},
    seed = 0,
    octaves = 3,
    persist = 0.5,
    lacunarity = 3,
	-- flags = "noeased",
}
-- cracks in the shells of the great rings
np_3d_ring = {
    offset = 0,
    scale = 1,
    spread = {x = 8, y = 8, z = 8},
    seed = 0,
    octaves = 1,
    persist = 1,
    lacunarity = 1.0,
    -- flags = "absvalue",
}

local chunk_size = {x = 80, y = 80, z = 80}

local nobj_2d_b = noise_handler.get_noise_object(np_2d_base, chunk_size)
local nobj_3d_r = noise_handler.get_noise_object(np_3d_ring, chunk_size)

local data = {}

minetest.register_on_generated(function(minp, maxp, blockseed)
      if maxp.y < 40 or minp.y > 80 then  -- not too high or low
	 return
      end
      if math.floor(blockseed / 100) % 70 > 0 then return end
      local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
      local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
      vm:get_data(data)
      local nvals_2d_b = nobj_2d_b:get_2d_map_flat(minp)
      local nvals_3d_r

      math.randomseed(blockseed)

      local rdir, rpos
      nvals_3d_r = nobj_3d_r:get_3d_map_flat(minp)
      rdir = vector.new(math.random() - 0.5, (math.random() - 0.5)/2, math.random() - 0.5)

      rpos = {}
      rpos.x = math.floor((minp.x + maxp.x) / 2)
      rpos.z = math.floor((minp.z + maxp.z) / 2)
      rpos.y = math.floor(nvals_2d_b[(rpos.z-minp.z) * 80 + (rpos.x-minp.x) + 1])

      for z = minp.z, maxp.z do
	 for y = minp.y, maxp.y do
	    for x = minp.x, maxp.x do
	       local vi = area:index(x, y, z)

	       if rdir then
		  local dist = math.pow(rpos.x - x, 2) + math.pow(rpos.z - z, 2) + math.pow(rpos.y - y, 2)
		  if dist > math.pow(31, 2) and dist < math.pow(34, 2) and
		     math.abs((x-rpos.x) * rdir.x + (y-rpos.y) * rdir.y + (z-rpos.z) * rdir.z) <= 2 then
		     data[vi] = c_ring_i
		  end
		  local nv_3d_r = nvals_3d_r[(z - minp.z) * 80 * 80 + (y - minp.y) * 80 + (x - minp.x) + 1]

		  if data[vi] ~= c_ring_i and nv_3d_r < 0.3 and
		     dist > math.pow(30, 2) and dist < math.pow(35, 2) and
		     math.abs((x-rpos.x) * rdir.x + (y-rpos.y) * rdir.y + (z-rpos.z) * rdir.z) <= 3 then
		     data[vi] = c_ring
		  end
	       end

	    end
	 end
      end

      vm:set_data(data)
      vm:calc_lighting()
      vm:write_to_map()
      if rdir then
	 minetest.fix_light(minp, maxp)
      end
end)
