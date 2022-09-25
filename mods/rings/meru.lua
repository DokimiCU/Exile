-- Parameters
--[[
Reducing noise to zero at the center creates a perfect spike as a summit. Constant noise throughout often creates floating islands at the summit. Choosing zero noise throughout creates a smooth geometric conical shape. There is a parameter CONVEX to control whether the basic conical structure bulges outwards or is pinched inwards in the middle.

]]

local COORD = false -- Print tower co-ordinates to terminal (cheat)

local area = 256
local XMIN = -area
local XMAX = area
local ZMIN = -area
local ZMAX = area
local YBASE = -1280 -- base height.

local BASRAD = 128 -- Average radius at y = YBASE
local HEIGHT = 1792 -- Approximate height measured from y = YBASE
local CONVEX = 3 -- Convexity. <1 = concave, 1 = conical, >1 = convex
local VOID = 1 -- Void threshold. Controls size of central void (1 = no void)
local NOISYRAD = 0.01 -- Noisyness of structure at base radius.
						-- 0 = smooth geometric form, 0.3 = noisy.
local NOISYCEN = 0 -- Noisyness of structure at centre
local FISOFFBAS = 0.01 -- Fissure noise offset at base,
						-- controls size of fissure entrances on outer surface.
local FISOFFTOP = 0.06 -- Fissure noise offset at top
local FISEXPBAS = 0.05 -- Fissure expansion rate under surface at base
local FISEXPTOP = 0.3 -- Fissure expansion rate under surface at top

-- 3D noise for primary structure

local np_structure = {
	offset = 0,
	scale = 1,
	spread = {x = 64, y = 64, z = 64},
	seed = 46893,
	octaves = 2,
	persist = 0.5
}

-- 3D noise for fissures

local np_fissure = {
	offset = 0,
	scale = 1,
	spread = {x = 12, y = 12, z = 12},
	seed = 92940980987,
	octaves = 3,
	persist = 0.5
}

-- 3D noise for block type

local np_biome = {
	offset = 0,
	scale = 1,
	spread = {x = 8, y = 64, z = 8},
	seed = 9130,
	octaves = 2,
	persist = 0.8
}

-- Stuff

local cxmin = math.floor((XMIN + 32) / 80) -- limits in chunk co-ordinates
local czmin = math.floor((ZMIN + 32) / 80)
local cxmax = math.floor((XMAX + 32) / 80)
local czmax = math.floor((ZMAX + 32) / 80)
local cxav = (cxmin + cxmax) / 2 -- spawn area midpoint in chunk co-ordinates
local czav = (czmin + czmax) / 2
local xnom = (cxmax - cxmin) / 4 -- noise multipliers
local znom = (czmax - czmin) / 4



-- Initialize noise objects to nil

local nobj_structure = nil
local nobj_fissure = nil
local nobj_biome = nil

-- On generated function

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.x < XMIN or minp.x > XMAX
	or maxp.z < ZMIN or minp.z > ZMAX then
		return
	end

	--noise does random location, we want it at map center
	--local locnoise = minetest.get_perlin(5839090, 2, 0.5, 3)
	--local noisex = locnoise:get2d({x = 31, y = 23})
	--local noisez = locnoise:get2d({x = 17, y = 11})
	--local cx = cxav-+ math.floor(noisex * xnom) -- chunk co ordinates
	--local cz = czav + math.floor(noisez * znom)
	local merux = 80 * cxav + 8
	local meruz = 80 * czav + 8
	if COORD then
		print ("[meru] at x " .. merux .. " z " .. meruz)
	end
	if minp.x < merux - 120 or minp.x > merux + 40
	or minp.z < meruz - 120 or minp.z > meruz + 40
	or minp.y < YBASE*2 or minp.y > HEIGHT * 1.2 then
		return
	end

	local t0 = os.clock()
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	local data = vm:get_data()

	local c_stone = minetest.get_content_id("rings:antiquorium")
	local c_destone = minetest.get_content_id("rings:moon_glass")
	local c_air = minetest.get_content_id("air")

	local sidelen = x1 - x0 + 1
	local chulens3d = {x = sidelen, y = sidelen, z = sidelen}
	--local chulens2d = {x = sidelen, y = sidelen, z = 1}
	local minpos3d = {x = x0, y = y0, z = z0}

	nobj_structure = nobj_structure or minetest.get_perlin_map(np_structure, chulens3d)
	nobj_fissure = nobj_fissure or minetest.get_perlin_map(np_fissure, chulens3d)
	nobj_biome = nobj_biome or minetest.get_perlin_map(np_biome, chulens3d)

	local nvals_structure = nobj_structure:get3dMap_flat(minpos3d)
	local nvals_fissure = nobj_fissure:get3dMap_flat(minpos3d)
	local nvals_biome = nobj_biome:get3dMap_flat(minpos3d)

	local nixyz = 1 -- 3D noise index
	--local nixz = 1 -- 2D noise index
	for z = z0, z1 do
		for y = y0, y1 do
			local vi = area:index(x0, y, z)
			for x = x0, x1 do
				local n_structure = nvals_structure[nixyz]
				local radius = ((x - merux) ^ 2 + (z - meruz) ^ 2) ^ 0.5
				local deprop = (BASRAD - radius) / BASRAD -- radial depth proportion
				local noisy = NOISYRAD + deprop * (NOISYCEN - NOISYRAD)
				local heprop = (y + math.abs(YBASE)) / (HEIGHT) -- height proportion
				local offset = deprop - heprop ^ CONVEX
				local n_offstructure = n_structure * noisy + offset
				if n_offstructure > 0 and n_offstructure < VOID then
					local n_absfissure = math.abs(nvals_fissure[nixyz])
					local fisoff = FISOFFBAS + heprop * (FISOFFTOP - FISOFFBAS)
					local fisexp = FISEXPBAS + heprop * (FISEXPTOP - FISEXPBAS)
					if n_absfissure - n_offstructure * fisexp - fisoff > 0 then
						local n_biome = nvals_biome[nixyz]
						local desert = n_biome > 0.45
						or math.random(0,10) > (0.45 - n_biome) * 100
						if desert then
							data[vi] = c_destone
						else
							data[vi] = c_stone
						end
					else
						 data[vi] = c_air
					end
				elseif n_offstructure > VOID then
					data[vi] = c_air
				end

				nixyz = nixyz + 1
				--nixz = nixz + 1
				vi = vi + 1
			end
			--nixz = nixz - sidelen
		end
		--nixz = nixz + sidelen
	end

	vm:set_data(data)
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:write_to_map(data)

	local chugent = math.ceil((os.clock() - t0) * 1000)
	print ("[meru] " .. chugent .. " ms")
end)
