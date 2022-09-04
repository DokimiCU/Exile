-- Megamorph Boxes mapgen plans.lua



-- Rotation:
-- 0 Z+   1 X+   2 Z-   3 X-
-- ladders:  2 X+   3 X-   4 Z+   5 Z-

-----------------------------------------------------------------------
local mod = megamorph
local mod_name = 'megamorph'

local vn = vector.new
local register_geomorph = mod.register_geomorph

-----------------------------------------------------------------------
local n_ex = 'air'

--primary construction materials
local stone_main = 'nodes_nature:granite'
local stone_block_main = 'tech:granite_block_mortar'
local stone_brick_main = 'tech:granite_brick_mortar'
local stone_stairs_main = 'stairs:stair_granite_block_mortar'
local stone_stairs_block_main = 'stairs:stair_granite_block_mortar'

--secondary
local stone_2nd = 'nodes_nature:basalt'
local stone_block_2nd = 'tech:basalt_block_mortar'
local stone_brick_2nd = 'tech:basalt_brick_mortar'
local stone_stairs_2nd = 'stairs:stair_basalt_block_mortar'
local stone_stairs_block_2nd = 'stairs:stair_basalt_block_mortar'

--tertiary
local stone_3rd = 'nodes_nature:limestone'
local stone_block_3rd = 'tech:limestone_block_mortar'
local stone_brick_3rd = 'tech:limestone_brick_mortar'
local stone_stairs_3rd = 'stairs:stair_limestone_block_mortar'
local stone_stairs_block_3rd = 'stairs:stair_limestone_block_mortar'

--4th
local stone_4th = 'nodes_nature:gneiss'
local stone_block_4th = 'tech:gneiss_block_mortar'
local stone_brick_4th = 'tech:gneiss_brick_mortar'
local stone_stairs_block_4th = 'stairs:stair_gneiss_block_mortar'

--furniture etc
local lamp_block = 'artifacts:moon_glass'
local door_a = 'doors:door_antiquorium_a'
local door_b = 'doors:door_antiquorium_b'
local ladder = 'artifacts:antiquorium_ladder'
local special_stone = 'artifacts:antiquorium'

--natural
local freshwater = 'nodes_nature:freshwater_source'
local soil = 'nodes_nature:loam'
local lava = 'nodes_nature:lava_source'
local edible_mushroom = 'nodes_nature:lambakap'
--local medicinal_mushroom = 'nodes_nature:merki'
local fibre_mushroom = 'nodes_nature:reshedaar'
local woody_mushroom = 'nodes_nature:mahal'

-----------------------------------------------------------------------
local ground = 20
local vault_width = 7
local vault_offset = math.floor(vault_width / 2)



-----------------------------------------------------------------------
local seal_underground = false
local seal_box = 	{act = 'cube', node = stone_main, loc = vn(0, 0, 0), size = vn(80, 80, 80)}

-----------------------------------------------------------------------

local p




-----------------------------------------------------------------------
--REUSABLE PARTS
-----------------------------------------------------------------------


local default_exits = {
	{act = 'cube', node = n_ex, loc = vn(0, 21, 19), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 21, 59), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 21, 19), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 21, 59), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(19, 21, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(39, 21, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(59, 21, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(19, 21, 79), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(39, 21, 79), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(59, 21, 79), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(0, 51, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 51, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(39, 51, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(39, 51, 79), size = vn(2, 3, 1)},
}



local upper_cross = {
	{act = 'cube', node = 'air', loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 0), size = vn(2, 3, 80)},
}


local upper_cross_hash = {
	{act = 'cube', node = 'air', loc = vn(19, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(59, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 51, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 51, 19), size = vn(80, 3, 2)},
}


local lower_cross = {
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(80, 3, 2)},
}


local lower_cross_hash = {
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(80, 3, 2)},
}


local lower_stair = {
	{act = 'cube', node = 'air', treasure = 3, loc = vn(22, 0, 50), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(30, 0, 50), size = vn(20, 20, 2)},
}

--for morphs that can't link via lower stair, gives upper stair links a room instead of a dead end.
local lower_stair_room = {
	{act = 'cube', node = 'air', treasure = 3, loc = vn(22, 0, 50), size = vn(8, 4, 8)},
}

local lower_stair = {
	{act = 'cube', node = 'air', treasure = 3, loc = vn(22, 0, 50), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(30, 0, 50), size = vn(20, 20, 2)},
}


--links to upper_cross
local upper_stair = {
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 3, loc = vn(30, 51, 27), size = vn(9, 9, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(22, 60, 22), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 0, loc = vn(27, 60, 30), size = vn(2, 21, 20)},
}

--central stairwell (links upper and lower cross)
local central_stairwell = {
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 0, loc = vn(32, 21, 41), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(32, 31, 51), size = vn(2, 3, 2)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(34, 31, 51), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(44, 41, 51), size = vn(2, 3, 2)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 2, loc = vn(44, 41, 41), size = vn(2, 10, 10)},
}

--for air shafts, to help prevent flooding, so only 1x1 areas of water gets down
local shaft_filter = {
	{act = 'cube', node = 'air', loc = vn(38, 79, 38), size = vn(1, 1, 1)},
	{act = 'cube', node = 'air', loc = vn(38, 79, 41), size = vn(1, 1, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 79, 41), size = vn(1, 1, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 79, 38), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(38, 0, 38), size = vn(1, 1, 1)},
	{act = 'cube', node = 'air', loc = vn(38, 0, 41), size = vn(1, 1, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 0, 41), size = vn(1, 1, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 0, 38), size = vn(1, 1, 1)},
}

-----------------------------------------------------
--REUSABLE MORPHS
-----------------------------------------------------

-----------------------------------------------------
--Crossroads
--links up down and all sides
local crossroads = {
	--stairs and landing rooms
	{act = 'cube', node = 'air', treasure = 3, loc = vn(22, 0, 50), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(30, 0, 50), size = vn(20, 20, 2)},
	{act = 'cube', node = 'air', loc = vn(50, 20, 50), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 2, loc = vn(50, 20, 30), size = vn(2, 20, 20)},
	{act = 'stair', node = stone_stairs_main, height = 3, depth = 2, param2 = 0, loc = vn(50, 20, 58), size = vn(2, 1, 1)},--link stair
	{act = 'cube', node = 'air', loc = vn(50, 40, 27), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 3, loc = vn(30, 40, 27), size = vn(20, 20, 2)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 3, loc = vn(30, 51, 22), size = vn(9, 9, 1)},--link stair
	{act = 'cube', node = 'air', loc = vn(39, 51, 21), size = vn(2, 4, 2)},--link box
	{act = 'cube', node = 'air', loc = vn(22, 60, 22), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 0, loc = vn(27, 60, 30), size = vn(2, 21, 20)},

	--linkers (from middle def exits)
	{act = 'cube', node = 'air', loc = vn(0, 51, 39), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 0), size = vn(2, 3, 20)},
	{act = 'cube', node = 'air', loc = vn(59, 51, 39), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 59), size = vn(2, 3, 20)},

	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 20)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 39), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 59), size = vn(2, 3, 20)},

	--	exit alcoves
	{act = 'cube', node = 'air', treasure = 3, loc = vn(16, 51, 4), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(60, 51, 4), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(4, 51, 60), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(4, 51, 16), size = vn(4, 3, 4)},

	{act = 'cube', node = 'air', treasure = 3, loc = vn(16, 51, 76), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(59, 51, 76), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(76, 51, 59), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(76, 51, 16), size = vn(4, 3, 4)},

	{act = 'cube', node = 'air', treasure = 3, loc = vn(16, 21, 4), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(59, 21, 4), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(4, 21, 59), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(4, 21, 17), size = vn(4, 3, 4)},

	{act = 'cube', node = 'air', treasure = 3, loc = vn(16, 21, 76), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(59, 21, 76), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(76, 21, 59), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(76, 21, 16), size = vn(4, 3, 4)},


}




for _, item in pairs(lower_cross_hash) do
	table.insert(crossroads, table.copy(item))
end

for _, item in pairs(upper_cross_hash) do
	table.insert(crossroads, table.copy(item))
end

for _, item in pairs(default_exits) do
	table.insert(crossroads, table.copy(item))
end


if seal_underground then
	table.insert(crossroads, 1, table.copy(seal_box))
end




-----------------------------------------------------
--Tower Base
--antiquorium foundations of the Meru tower

local tower_base_a = {
	--shaft
	{act = 'cylinder', node = 'air', axis = 'y', loc = vn(36, 1, 36), size = vn(8, 78, 8)},
}

for _, item in pairs(shaft_filter) do
	table.insert(tower_base_a, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(tower_base_a, 2, table.copy(item))
end

for _, item in pairs(lower_cross) do
	table.insert(tower_base_a, 2, table.copy(item))
end

for _, item in pairs(lower_cross_hash) do
	table.insert(tower_base_a, 2, table.copy(item))
end


-----------------------------------------------------
--Air Shaft
--vertical shaft to the surface to link with central highways

------
local air_shaft = {

	--cross horizontal
--	{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 38, 38), size = vn(80, 4, 4)},
--	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(38, 38, 0), size = vn(4, 4, 80)},
	--shaft
	{act = 'cylinder', node = 'air', axis = 'y', loc = vn(36, 1, 36), size = vn(8, 78, 8)},
	--cross horizontal low
--	{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 1, 40), size = vn(80, 2, 1)},
--	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(40, 1, 0), size = vn(1, 2, 80)},
}

for _, item in pairs(shaft_filter) do
	table.insert(air_shaft, 2, table.copy(item))
end

if seal_underground then
	table.insert(air_shaft, 1, table.copy(seal_box))
end

------
local air_shaft_thin = {
	--shaft
	--{act = 'cube', node = 'air', loc = vn(39, 1, 39), size = vn(2, 78, 2)},
	{act = 'cube', node = 'air', loc = vn(38, 0, 38), size = vn(1, 79, 1)},
	{act = 'cube', node = 'air', loc = vn(38, 0, 41), size = vn(1, 79, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 0, 41), size = vn(1, 79, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 0, 38), size = vn(1, 79, 1)},
	--cross horizontal low
	--{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 1, 40), size = vn(80, 2, 1)},
	--{act = 'cylinder', node = 'air', axis = 'z', loc = vn(40, 1, 0), size = vn(1, 2, 80)},
	--pit
	{act = 'sphere', node = 'air', loc = vn(34, 7, 34), size = vn(12, 12, 12)},
	--pit
	{act = 'sphere', node = 'air', loc = vn(34, 34, 34), size = vn(12, 12, 12)},

}

for _, item in pairs(shaft_filter) do
	table.insert(air_shaft_thin, 2, table.copy(item))
end

if seal_underground then
	table.insert(air_shaft_thin, 1, table.copy(seal_box))
end



-----------------------------------------------------
--Highway
--Massive transport duct for airboat travel
--basic version
local highway = {

	--cross horizontal
	{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 32, 32), size = vn(80, 16, 16)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(32, 32, 0), size = vn(16, 16, 80)},
	--shaft
	{act = 'cylinder', node = 'air', axis = 'y', loc = vn(32, 0, 32), size = vn(16, 80, 16)},
	--central sphere
	{act = 'sphere', node = 'air', loc = vn(27, 27, 27), size = vn(26, 26, 26)},

}

for _, item in pairs(lower_stair_room) do
	table.insert(highway, 2, table.copy(item))
end

if seal_underground then
	table.insert(highway, 1, table.copy(seal_box))
end


-----------------------------------------------------
--highway 2
--Massive transport duct for airboat travel
-- horizontal only
local highway_no_shaft = {
	--cross horizontal
	{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 32, 32), size = vn(80, 16, 16)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(32, 32, 0), size = vn(16, 16, 80)},

}


for _, item in pairs(lower_stair_room) do
	table.insert(highway_no_shaft, 2, table.copy(item))
end

if seal_underground then
	table.insert(highway_no_shaft, 1, table.copy(seal_box))
end

-----------------------------------------------------
--Highway 3
--Massive transport duct for airboat travel
-- with foot corridors, and room
local highway_linked = {

	--cross horizontal
	{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 32, 32), size = vn(80, 16, 16)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(32, 32, 0), size = vn(16, 16, 80)},
	--shaft
	{act = 'cylinder', node = 'air', axis = 'y', loc = vn(32, 0, 32), size = vn(16, 80, 16)},
	--central sphere
	{act = 'sphere', node = 'air', loc = vn(27, 27, 27), size = vn(26, 26, 26)},

	--bridges
	{act = 'cube', node = 'air', floor = stone_main, loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_main, loc = vn(39, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = stone_main, loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_main, loc = vn(39, 21, 0), size = vn(2, 3, 80)},

	--exit rooms
	{act = 'cube', node = 'air', treasure = 20, loc = vn(0, 51, 37), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 51, 0), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(0, 21, 37), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 21, 0), size = vn(6, 3, 6)},

	{act = 'cube', node = 'air', treasure = 20, loc = vn(74, 51, 37), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 51, 74), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(74, 21, 37), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 21, 74), size = vn(6, 3, 6)},

}

--rooms
for _, y in pairs({7, 13,  19, 54, 60, 66}) do
	table.insert(highway_linked, 	{act = 'cube', node = 'air', treasure = 20, loc = vn(y, 51, 33), size = vn(5, 3, 5)})
	table.insert(highway_linked, 	{act = 'cube', node = 'air', loc = vn(y+1, 51, 38), size = vn(3, 2, 1)})

	table.insert(highway_linked, 	{act = 'cube', node = 'air', treasure = 20, loc = vn(y, 51, 42), size = vn(5, 3, 5)})
	table.insert(highway_linked, 	{act = 'cube', node = 'air', loc = vn(y+1, 51, 41), size = vn(3, 2, 1)})
end

for _, y in pairs({7, 13,  19, 54, 60, 66}) do
	table.insert(highway_linked, 	{act = 'cube', node = 'air', treasure = 20, loc = vn(y, 21, 33), size = vn(5, 3, 5)})
	table.insert(highway_linked, 	{act = 'cube', node = 'air', loc = vn(y+1, 21, 38), size = vn(3, 2, 1)})

	table.insert(highway_linked, 	{act = 'cube', node = 'air', treasure = 20, loc = vn(y, 21, 42), size = vn(5, 3, 5)})
	table.insert(highway_linked, 	{act = 'cube', node = 'air', loc = vn(y+1, 21, 41), size = vn(3, 2, 1)})
end

for _, y in pairs({7, 13,  19, 54, 60, 66}) do
	table.insert(highway_linked, 	{act = 'cube', node = 'air', treasure = 20, loc = vn(33, 21, y), size = vn(5, 3, 3)})
	table.insert(highway_linked, 	{act = 'cube', node = 'air', loc = vn(38, 21, y+1), size = vn(3, 2, 1)})

	table.insert(highway_linked, 	{act = 'cube', node = 'air', treasure = 20, loc = vn(42, 21, y), size = vn(7, 6, 5)})
	table.insert(highway_linked, 	{act = 'cube', node = 'air', loc = vn(41, 21, y), size = vn(1, 3, 5)})
end



for _, item in pairs(lower_stair_room) do
	table.insert(highway_linked, 2, table.copy(item))
end

if seal_underground then
	table.insert(highway_linked, 1, table.copy(seal_box))
end

-----------------------------------------------------
--Highway 4
--Massive transport duct for airboat travel
-- with foot corridors, horizontal only, but with stairs
local highway_no_shaft_linked = {

	--cross horizontal
	{act = 'cylinder', node = 'air', axis = 'x', loc = vn(0, 32, 32), size = vn(80, 16, 16)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(32, 32, 0), size = vn(16, 16, 80)},

	--corridors
	{act = 'cube', node = 'air', loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 80)},

	--ladder access
	{act = 'ladder', node = ladder, param2 = 3, loc = vn(39, 21, 42), size = vn(1, 12, 1)},

	--exit rooms
	{act = 'cube', node = 'air', treasure = 20, loc = vn(0, 51, 37), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 51, 0), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(0, 21, 37), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 21, 0), size = vn(6, 3, 6)},

	{act = 'cube', node = 'air', treasure = 20, loc = vn(74, 51, 37), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 51, 74), size = vn(6, 3, 6)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(74, 21, 37), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', treasure = 20, loc = vn(37, 21, 74), size = vn(6, 3, 6)},

	--lower stair linker
	{act = 'cube', node = 'air', loc = vn(41, 21, 46), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(50, 20, 46), size = vn(4, 3, 6)},
	{act = 'stair', node = stone_stairs_main, height = 3, depth = 2, param2 = 3, loc = vn(49, 20, 46), size = vn(1, 1, 2)},

	--corridor link stair
	{act = 'stair', node = stone_stairs_main, height = 3, depth = 2, param2 = 3, loc = vn(45, 21, 51), size = vn(30, 30, 2)},
	-- link corridor
	{act = 'cube', node = 'air', loc = vn(41, 51, 51), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 41), size = vn(2, 3, 12)},

	--mini shafts
	--{act = 'cube', node = 'air', loc = vn(39, 53, 39), size = vn(2, 27, 2)},
	{act = 'cube', node = 'air', loc = vn(38, 52, 38), size = vn(1, 28, 1)},
	{act = 'cube', node = 'air', loc = vn(38, 52, 41), size = vn(1, 28, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 52, 41), size = vn(1, 28, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 52, 38), size = vn(1, 28, 1)},

	{act = 'cube', node = 'air', loc = vn(38, 0, 38), size = vn(1, 28, 1)},
	{act = 'cube', node = 'air', loc = vn(38, 0, 41), size = vn(1, 28, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 0, 41), size = vn(1, 28, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 0, 38), size = vn(1, 28, 1)},


}

for _, item in pairs(upper_stair) do
	table.insert(highway_no_shaft_linked, 2, table.copy(item))
end

for _, item in pairs(lower_stair) do
	table.insert(highway_no_shaft_linked, 2, table.copy(item))
end

if seal_underground then
	table.insert(highway_no_shaft_linked, 1, table.copy(seal_box))
end





-----------------------------------------------------
--reservoir
--big water pool

local reservoir = {
	{act = 'cube', node = 'air', loc = vn(20, 12, 11), size = vn(51, 36, 50)},
	{act = 'cube', node = freshwater, treasure = 5, loc = vn(20, 11, 11), size = vn(51, 10, 50)},
	{act = 'cube', node = stone_main, loc = vn(38, 11, 30), size = vn(17, 10, 16)},
	{act = 'cube', node = stone_main, loc = vn(39, 11, 11), size = vn(2, 10, 19)},
	{act = 'cube', node = freshwater, treasure = 3, loc = vn(49, 11, 62), size = vn(30, 5, 17)},
	{act = 'cube', node = freshwater, loc = vn(17, 11, 69), size = vn(32, 2, 2)},
	{act = 'cube', node = freshwater, loc = vn(43, 11, 61), size = vn(2, 2, 10)},
	{act = 'cube', node = freshwater, loc = vn(17, 11, 23), size = vn(2, 2, 46)},
	{act = 'cube', node = freshwater, treasure = 2, loc = vn(1, 11, 1), size = vn(18, 5, 22)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 1), size = vn(8, 5, 5)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 1), size = vn(8, 5, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 11)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(1, 21, 42), size = vn(15, 6, 16)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 22), size = vn(7, 6, 19)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 31), size = vn(4, 4, 7)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 22), size = vn(4, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 10), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 10), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 47), size = vn(7, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 34), size = vn(8, 6, 12)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 1), size = vn(7, 5, 32)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 19), size = vn(9, 2, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(49, 21, 62), size = vn(30, 6, 17)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(1, 21, 62), size = vn(30, 6, 17)},
	{act = 'cube', node = 'air', loc = vn(37, 21, 75), size = vn(6, 4, 4)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 10), size = vn(2, 3, 32)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 34), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 26), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 1), size = vn(14, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 10), size = vn(4, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 7), size = vn(7, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 7), size = vn(44, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 5), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(58, 21, 5), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 73), size = vn(28, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 56), size = vn(2, 3, 6)},
	{act = 'ladder', node = ladder, param2 = 5, loc = vn(78, 11, 62), size = vn(1, 10, 1)},
	{act = 'ladder', node = ladder, param2 = 4, loc = vn(20, 21, 60), size = vn(1, 20, 1)},

	{act = 'cube', node = 'air', loc = vn(20, 41, 61), size = vn(51, 5, 9)},
	{act = 'cube', node = 'air', loc = vn(11, 41, 11), size = vn(9, 5, 59)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 2, loc = vn(16, 21, 36), size = vn(2, 20, 20)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(1, 41, 39), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 0, loc = vn(39, 41, 69), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(71, 51, 39), size = vn(8, 3, 2)},
	{act = 'stair', node = stone_stairs_main, depth = 2, param2 = 2, loc = vn(69, 41, 51), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(69, 51, 13), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(61, 51, 13), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 31, 13), size = vn(2, 20, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 50, 13), size = vn(2, 1, 2)}, --?
	{act = 'cube', node = 'air', loc = vn(60, 51, 41), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(60, 51, 29), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 30), size = vn(24, 6, 25)},
	{act = 'cube', node = 'air', loc = vn(52, 51, 41), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(44, 51, 27), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 27), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(44, 51, 55), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 55), size = vn(8, 3, 3)},
	{act = 'cube', node = stone_main, loc = vn(37, 51, 40), size = vn(5, 6, 5)},
	{act = 'cube', node = 'air', loc = vn(68, 51, 34), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(68, 51, 44), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 1), size = vn(2, 3, 29)},
}

for _, item in pairs(default_exits) do
	table.insert(reservoir, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(reservoir, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(reservoir, 2, table.copy(item))
end

if seal_underground then
	table.insert(reservoir, 1, table.copy(seal_box))
end



-----------------------------------------------------
--empty reservoir

local reservoir_empty = {
	{act = 'cube', node = 'air', treasure = 10, loc = vn(20, 12, 11), size = vn(51, 36, 50)},
	{act = 'cube', node = 'air', treasure = 5, loc = vn(20, 11, 11), size = vn(51, 10, 50)},
	{act = 'cube', node = stone_main, loc = vn(38, 11, 30), size = vn(17, 10, 16)},
	{act = 'cube', node = stone_main, loc = vn(39, 11, 11), size = vn(2, 10, 19)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(49, 11, 62), size = vn(30, 5, 17)},
	{act = 'cube', node = 'air', loc = vn(17, 11, 69), size = vn(32, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(43, 11, 61), size = vn(2, 2, 10)},
	{act = 'cube', node = 'air', loc = vn(17, 11, 23), size = vn(2, 2, 46)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(1, 11, 1), size = vn(18, 5, 22)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 1), size = vn(8, 5, 5)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 1), size = vn(8, 5, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 11)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(1, 21, 42), size = vn(15, 6, 16)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 22), size = vn(7, 6, 19)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 31), size = vn(4, 4, 7)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 22), size = vn(4, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 10), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 10), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 47), size = vn(7, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 34), size = vn(8, 6, 12)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 1), size = vn(7, 5, 32)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 19), size = vn(9, 2, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(49, 21, 62), size = vn(30, 6, 17)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 62), size = vn(30, 6, 17)},
	{act = 'cube', node = 'air', loc = vn(37, 21, 75), size = vn(6, 4, 4)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 10), size = vn(2, 3, 32)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 34), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 26), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 1), size = vn(14, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 10), size = vn(4, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 7), size = vn(7, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 7), size = vn(44, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 5), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(58, 21, 5), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 73), size = vn(28, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 56), size = vn(2, 3, 6)},
	{act = 'ladder', node = ladder, param2 = 5, loc = vn(78, 11, 62), size = vn(1, 10, 1)},
	{act = 'ladder', node = ladder, param2 = 4, loc = vn(20, 21, 60), size = vn(1, 20, 1)},

	{act = 'cube', node = 'air', loc = vn(20, 41, 61), size = vn(51, 5, 9)},
	{act = 'cube', node = 'air', loc = vn(11, 41, 11), size = vn(9, 5, 59)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 2, loc = vn(16, 21, 36), size = vn(2, 20, 20)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(1, 41, 39), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 0, loc = vn(39, 41, 69), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(71, 51, 39), size = vn(8, 3, 2)},
	{act = 'stair', node = stone_stairs_main, depth = 2, param2 = 2, loc = vn(69, 41, 51), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(69, 51, 13), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(61, 51, 13), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 31, 13), size = vn(2, 20, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 50, 13), size = vn(2, 1, 2)}, --?
	{act = 'cube', node = 'air', loc = vn(60, 51, 41), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(60, 51, 29), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(28, 51, 30), size = vn(24, 6, 25)},
	{act = 'cube', node = 'air', loc = vn(52, 51, 41), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(44, 51, 27), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 27), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(44, 51, 55), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 55), size = vn(8, 3, 3)},
	{act = 'cube', node = stone_main, loc = vn(37, 51, 40), size = vn(5, 6, 5)},
	{act = 'cube', node = 'air', loc = vn(68, 51, 34), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(68, 51, 44), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 1), size = vn(2, 3, 29)},
}

for _, item in pairs(default_exits) do
	table.insert(reservoir_empty, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(reservoir_empty, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(reservoir_empty, 2, table.copy(item))
end

if seal_underground then
	table.insert(reservoir_empty, 1, table.copy(seal_box))
end



-----------------------------------------------------
--mushroom_garden
--three levels with soil

local mushroom_garden = {
	{act = 'cube', node = soil, loc = vn(5, 19, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = soil, loc = vn(5, 19, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = edible_mushroom, random = 30, loc = vn(5, 21, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 59), size = vn(5, 3, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(61, 21, 75), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(9, 21, 3), size = vn(10, 10, 2)},
	{act = 'cube', node = soil, loc = vn(5, 29, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = soil, loc = vn(5, 29, 5), size = vn(70, 1, 70), treasure = 2},
	{act = 'cube', node = 'air', loc = vn(5, 31, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = fibre_mushroom, random = 30, loc = vn(5, 31, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(71, 31, 75), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 31, 3), size = vn(6, 3, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(75, 31, 65), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_main, param2 = 0, loc = vn(3, 31, 5), size = vn(2, 10, 10)},

	{act = 'cube', node = soil, loc = vn(5, 39, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = soil, loc = vn(5, 39, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(5, 41, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = woody_mushroom, random = 30, loc = vn(5, 41, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(75, 41, 60), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(3, 41, 15), size = vn(2, 3, 5)},

}

for _, item in pairs(default_exits) do
	table.insert(mushroom_garden, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(mushroom_garden, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(mushroom_garden, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(mushroom_garden, 2, table.copy(item))
end

if seal_underground then
	table.insert(mushroom_garden, 1, table.copy(seal_box))
end


-----------------------------------------------------
--barren_mushroom_garden

local barren_mushroom_garden = {
	{act = 'cube', node = 'air', loc = vn(5, 19, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'nodes_nature:sand', random = 10, loc = vn(5, 19, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'nodes_nature:sand', loc = vn(5, 19, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 5), size = vn(70, 7, 70)},
	--{act = 'cube', node = edible_mushroom, random = 30, loc = vn(5, 21, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 59), size = vn(5, 3, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(61, 21, 75), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(9, 21, 3), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 29, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'nodes_nature:sand', random = 10, loc = vn(5, 29, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'nodes_nature:sand', loc = vn(5, 29, 5), size = vn(70, 1, 70), treasure = 3},
	{act = 'cube', node = 'air', loc = vn(5, 31, 5), size = vn(70, 7, 70)},
	--{act = 'cube', node = medicinal_mushroom, random = 30, loc = vn(5, 31, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(71, 31, 75), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 31, 3), size = vn(6, 3, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(75, 31, 65), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_main, param2 = 0, loc = vn(3, 31, 5), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(5, 39, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'nodes_nature:sand', random = 10, loc = vn(5, 39, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'nodes_nature:sand', loc = vn(5, 39, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(5, 41, 5), size = vn(70, 7, 70)},
	--{act = 'cube', node = edible_mushroom, random = 30, loc = vn(5, 41, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(75, 41, 60), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(3, 41, 15), size = vn(2, 3, 5)},
}

for _, item in pairs(default_exits) do
	table.insert(barren_mushroom_garden, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(barren_mushroom_garden, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(barren_mushroom_garden, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(barren_mushroom_garden, 2, table.copy(item))
end

if seal_underground then
	table.insert(barren_mushroom_garden, 1, table.copy(seal_box))
end



-----------------------------------------------------
--stockyards
--three levels with pits

local stockyards = {
	{act = 'cube', node = 'air', loc = vn(15, 19, 15), size = vn(50, 2, 50)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 59), size = vn(5, 3, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(15, 19, 15), size = vn(2, 2, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(61, 21, 75), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(9, 21, 3), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(15, 29, 15), size = vn(50, 2, 50)},
	{act = 'cube', node = 'air', loc = vn(5, 31, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = 'air', loc = vn(71, 31, 75), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 31, 3), size = vn(6, 3, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(15, 29, 15), size = vn(2, 2, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(75, 31, 65), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_main, param2 = 0, loc = vn(3, 31, 5), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', treasure = 5, loc = vn(15, 39, 15), size = vn(50, 2, 50)},
	{act = 'cube', node = 'air', loc = vn(5, 41, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = 'air', loc = vn(75, 41, 60), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(3, 41, 15), size = vn(2, 3, 5)},
	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(15, 39, 15), size = vn(2, 2, 2)},

	--lower stair link
	{act = 'cube', node = stone_main, loc = vn(41, 19, 46), size = vn(24, 2, 10)},
	{act = 'cube', node = stone_main, loc = vn(43, 19, 48), size = vn(7, 9, 6)},
	{act = 'cube', node = "air", loc = vn(44, 19, 50), size = vn(5, 5, 2)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(49, 19, 50), size = vn(2, 2, 2)},
	{act = 'cube', node = stone_main, loc = vn(50, 21, 52), size = vn(1, 1, 1)},
	{act = 'cube', node = stone_main, loc = vn(50, 21, 49), size = vn(1, 1, 1)},

}

for _, item in pairs(default_exits) do
	table.insert(stockyards, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(stockyards, 2, table.copy(item))
end

for _, item in pairs(lower_stair) do
	table.insert(stockyards, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(stockyards, 2, table.copy(item))
end

if seal_underground then
	table.insert(stockyards, 1, table.copy(seal_box))
end


-----------------------------------------------------
--granary

local granary = {
{act = 'cube', node = 'air', treasure = 3, loc = vn(15, 21, 15), size = vn(20, 28, 20)},
{act = 'cube', node = stone_main,  loc = vn(23, 21, 23), size = vn(4, 4, 4)},
{act = 'cube', node = 'air', loc = vn(19, 21, 21), size = vn(2, 3, 10)},
{act = 'cube', node = 'air', loc = vn(59, 21, 21), size = vn(2, 3, 10)},
{act = 'cube', node = 'air', floor = stone_main, treasure = 2, loc = vn(15, 46, 15), size = vn(20, 2, 20)},
{act = 'cube', node = 'air', loc = vn(22, 44, 22), size = vn(6, 3, 6)},
{act = 'cube', node = 'air', floor = stone_main, treasure = 2, loc = vn(15, 30, 15), size = vn(20, 2, 20)},
{act = 'cube', node = 'air', loc = vn(24, 28, 24), size = vn(2, 3, 2)},
{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(21, 46, 13), size = vn(5, 5, 2)},
{act = 'cube', node = 'air', loc = vn(26, 46, 13), size = vn(2, 3, 2)},

}

for _, item in pairs(crossroads) do
	table.insert(granary, 2, table.copy(item))
end



-----------------------------------------------------
--kitchen

local kitchen = {
	--stair link rooms
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(50, 20, 47), size = vn(8, 3, 8)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 2, depth = 1, param2 = 1, loc = vn(58, 20, 48), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 3, loc = vn(39, 51, 21), size = vn(8, 3, 8)},

	--oven room 1
	{act = 'cube', node = 'air', line = stone_block_2nd, treasure = 2, loc = vn(24, 51, 31), size = vn(32, 8, 26)},
	--oven room access
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(39, 51, 29), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(39, 51, 56), size = vn(2, 3, 3)},

	--stairs
	{act = 'stair', node = stone_stairs_block_3rd, height = 3, depth = 3, param2 = 3, loc = vn(47, 42, 27), size = vn(9, 9, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(56, 42, 21), size = vn(3, 3, 9)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 3, depth = 3, param2 = 2, loc = vn(56, 33, 30), size = vn(2, 9, 9)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(55, 33, 39), size = vn(3, 3, 9)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 3, depth = 3, param2 = 1, loc = vn(46, 24, 40), size = vn(9, 9, 2)},
	--main kitchen
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(24, 24, 24), size = vn(22, 5, 32)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 4, depth = 3, param2 = 0, loc = vn(43, 21, 21), size = vn(3, 3, 3)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 4, depth = 3, param2 = 2, loc = vn(43, 21, 56), size = vn(3, 3, 3)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 4, depth = 3, param2 = 1, loc = vn(21, 21, 39), size = vn(3, 3, 3)},
	--kitchen benches
	{act = 'cube', node = stone_block_3rd, loc = vn(26, 24, 26), size = vn(16, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(26, 24, 30), size = vn(16, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(26, 24, 34), size = vn(16, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(26, 24, 45), size = vn(16, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(26, 24, 49), size = vn(16, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(26, 24, 53), size = vn(4, 1, 3)},
	{act = 'cube', node = stone_block_3rd, loc = vn(34, 24, 53), size = vn(4, 1, 3)},

	--stores
	{act = 'cube', node = 'air', treasure = 10, floor = stone_block_3rd, loc = vn(1, 33, 45), size = vn(78, 3, 3)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(0, 33, 46), size = vn(1, 2, 1)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(79, 33, 46), size = vn(1, 2, 1)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(36, 42, 21), size = vn(20, 3, 2)},
	{act = 'cylinder', node = 'air', axis = 'y', floor = stone_block_3rd, loc = vn(21, 38, 13), size = vn(18, 10, 18)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(25, 38, 18), size = vn(6, 1, 6)},

	--short lower cross corridors
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 19)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(19, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 21, 39), size = vn(19, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 61), size = vn(2, 3, 19)},




}

--ovens
for _, x in pairs({25, 32, 42, 49 }) do
	for _, z in pairs({33, 41, 49 }) do
		table.insert(kitchen, {act = 'cube', node = stone_block_2nd, loc = vn(x, 51, z), size = vn(5, 6, 5)})
		table.insert(kitchen, {act = 'cube', treasure = 10, node = 'air', loc = vn(x+2, 52, z+2), size = vn(1, 2, 1)})
		table.insert(kitchen, {act = 'cube', node = 'air', loc = vn(x+1, 54, z+1), size = vn(3, 2, 3)})
		table.insert(kitchen, {act = 'cube', node = 'air', loc = vn(x+2, 55, z+4), size = vn(1, 1, 1)})
		table.insert(kitchen, {act = 'cube', node = 'air', loc = vn(x+2, 52, z+3), size = vn(1, 1, 2)})
	end
end

--store rooms
for _, y in pairs({1, 8, 15, 22, 29, 36, 43, 50, 57, 64, 71 }) do
	table.insert(kitchen, {act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 7, loc = vn(y, 33, 49), size = vn(6, 3, 6)})
	table.insert(kitchen, {act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(y+2, 33, 48), size = vn(2, 2, 1)})
end

for _, y in pairs({1, 8, 15, 22, 29, 36, 43, 64, 71 }) do
	table.insert(kitchen, {act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 7, loc = vn(y, 33, 38), size = vn(6, 3, 6)})
	table.insert(kitchen, {act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(y+2, 33, 44), size = vn(2, 2, 1)})
end



for _, item in pairs(default_exits) do
	table.insert(kitchen, 2, table.copy(item))
end

for _, item in pairs(lower_cross_hash) do
	table.insert(kitchen, 2, table.copy(item))
end

for _, item in pairs(upper_cross_hash) do
	table.insert(kitchen, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(kitchen, 2, table.copy(item))
end

for _, item in pairs(lower_stair) do
	table.insert(kitchen, 2, table.copy(item))
end


-----------------------------------------------------
-----------------------------------------------------
--prison

local prison = {
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(79, 21, 19), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(79, 21, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(79, 21, 59), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 79), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 79), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 79), size = vn(2, 2, 1)},

	{act = 'cube', node = 'air', loc = vn(38, 21, 1), size = vn(4, 3, 78)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 58), size = vn(78, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 18), size = vn(78, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 37), size = vn(8, 3, 6)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(10, 21, 30), size = vn(25, 5, 20)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 38), size = vn(3, 3, 4)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(42, 21, 38), size = vn(37, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(51, 21, 42), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(51, 21, 37), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(69, 21, 42), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(69, 21, 37), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(44, 21, 43), size = vn(16, 6, 9)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(44, 21, 28), size = vn(16, 6, 9)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(62, 21, 43), size = vn(16, 6, 9)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(62, 21, 28), size = vn(16, 6, 9)},

	{act = 'cube', node = 'air', loc = vn(24, 21, 71), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(43, 21, 71), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(24, 21, 7), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(43, 21, 7), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 71), size = vn(8, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 71), size = vn(8, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 1), size = vn(8, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 1), size = vn(8, 3, 8)},

	{act = 'cube', node = door_a, param2 = 3, loc = vn(0, 21, 59), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 3, loc = vn(0, 21, 60), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 1, loc = vn(79, 21, 59), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 1, loc = vn(79, 21, 60), size = vn(1, 1, 1)},

	{act = 'cube', node = door_a, param2 = 3, loc = vn(0, 21, 19), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 3, loc = vn(0, 21, 20), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 1, loc = vn(79, 21, 19), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 1, loc = vn(79, 21, 20), size = vn(1, 1, 1)},

	{act = 'cube', node = door_a, param2 = 0, loc = vn(39, 21, 79), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 0, loc = vn(40, 21, 79), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 2, loc = vn(39, 21, 0), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 2, loc = vn(40, 21, 0), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(37, 21, 71), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(42, 21, 71), size = vn(1, 2, 2)},

	{act = 'cube', node = door_b, param2 = 1, loc = vn(37, 21, 71), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 1, loc = vn(37, 21, 72), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 3, loc = vn(42, 21, 71), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 3, loc = vn(42, 21, 72), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(37, 21, 7), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(42, 21, 7), size = vn(1, 2, 2)},

	{act = 'cube', node = door_b, param2 = 1, loc = vn(37, 21, 7), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 1, loc = vn(37, 21, 8), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 3, loc = vn(42, 21, 7), size = vn(1, 1, 1)},
	{act = 'cube', node = door_b, param2 = 3, loc = vn(42, 21, 8), size = vn(1, 1, 1)},

	{act = 'cube', node = door_b, param2 = 1, loc = vn(79, 21, 39), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 1, loc = vn(79, 21, 40), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(9, 21, 39), size = vn(1, 2, 2)},

	{act = 'cube', node = door_b, param2 = 1, loc = vn(9, 21, 39), size = vn(1, 1, 1)},
	{act = 'cube', node = door_a, param2 = 1, loc = vn(9, 21, 40), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(28, 21, 26), size = vn(1, 2, 1)},--?
	{act = 'cube', node = 'air', loc = vn(27, 31, 26), size = vn(3, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 31, 29), size = vn(1, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(3, 31, 39), size = vn(74, 3, 2)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(3, 31, 42), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(47, 31, 42), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(32, 31, 32), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(64, 31, 32), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(11, 31, 32), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', loc = vn(6, 31, 41), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(51, 31, 41), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(14, 31, 38), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(36, 31, 38), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(66, 31, 38), size = vn(2, 3, 1)},
	{act = 'ladder', node = ladder, param2 = 2, loc = vn(28, 21, 27), size = vn(1, 10, 1)},
}

for _, o in pairs({0, 43}) do
	for x = 4 + o, 32 + o, 4 do
		for _, y in pairs({57, 17}) do
			local i = {act = 'cube', node = 'air', loc = vn(x, 21, y + 5), size = vn(1, 2, 1)}
			table.insert(prison, i)
			i = {act = 'cube', node = door_a, param2 = 0, loc = vn(x, 21, y + 5), size = vn(1, 1, 1)}
			table.insert(prison, i)
			i = {act = 'cube', node = 'air', treasure = 30, loc = vn(x - 1, 21, y + 6), size = vn(3, 3, 3)}
			table.insert(prison, i)

			i = {act = 'cube', node = 'air', loc = vn(x, 21, y), size = vn(1, 2, 1)}
			table.insert(prison, i)
			i = {act = 'cube', node = door_a, param2 = 2, loc = vn(x, 21, y), size = vn(1, 1, 1)}
			table.insert(prison, i)
			i = {act = 'cube', node = 'air', treasure = 30, loc = vn(x - 1, 21, y - 3), size = vn(3, 3, 3)}
			table.insert(prison, i)
		end
	end
end

for _, item in pairs(upper_cross) do
	table.insert(prison, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(prison, 2, table.copy(item))
end

if seal_underground then
	table.insert(prison, 1, table.copy(seal_box))
end


-----------------------------------------------------
--stair_base

local stair_base = {

	--
	{act = 'sphere', node = 'air', loc = vn(35, 31, 35), size = vn(40, 40, 40)},
	{act = 'cube', node = stone_main, loc = vn(35, 31, 35), size = vn(40, 20, 40)},
	{act = 'cube', node = stone_block_main, loc = vn(35, 50, 35), size = vn(40, 1, 40)},

	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 3, loc = vn(50, 41, 10), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 0, loc = vn(10, 41, 25), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 3, loc = vn(20, 41, 55), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(55, 41, 20), size = vn(15, 5, 50)},
	{act = 'cube', node = 'air', loc = vn(60, 46, 25), size = vn(5, 1, 40)},
	{act = 'cube', node = 'air', loc = vn(60, 41, 15), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(30, 41, 55), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(60, 41, 10), size = vn(10, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(33, 41, 20), size = vn(22, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 41, 9), size = vn(12, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(12, 41, 9), size = vn(11, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(10, 41, 9), size = vn(2, 3, 16)},


	{act = 'cube', node = 'air', loc = vn(66, 51, 39), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 66), size = vn(2, 3, 13)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 39), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 51, 10), size = vn(2, 3, 55)},
	{act = 'cube', node = 'air', loc = vn(7, 51, 10), size = vn(43, 3, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(25, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(38, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(51, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(64, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(36, 51, 1), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 9), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(29, 51, 12), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(36, 51, 14), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 51, 23), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(62, 51, 14), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 51, 65), size = vn(15, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(10, 51, 35), size = vn(2, 3, 30)},
	{act = 'cube', node = 'air', loc = vn(18, 51, 55), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(14, 51, 55), size = vn(2, 3, 10)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 2, loc = vn(14, 51, 45), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(14, 61, 22), size = vn(2, 3, 23)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(14, 61, 4), size = vn(61, 5, 18)},
	{act = 'cube', node = 'air', loc = vn(16, 66, 6), size = vn(14, 1, 14)},
	{act = 'cube', node = 'air', loc = vn(36, 66, 6), size = vn(14, 1, 14)},
	{act = 'cube', node = 'air', loc = vn(56, 66, 6), size = vn(14, 1, 14)},
	{act = 'cube', node = 'air', loc = vn(50, 61, 22), size = vn(10, 5, 21)},
	{act = 'cube', node = stone_main, loc = vn(48, 60, 34), size = vn(14, 1, 42)},
	{act = 'cube', node = stone_main, loc = vn(34, 60, 54), size = vn(14, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 61, 54), size = vn(17, 3, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(13, 61, 56), size = vn(12, 4, 16)},
	{act = 'cube', node = 'air', loc = vn(25, 61, 70), size = vn(9, 4, 9)},

	{act = 'cube', node = 'air', loc = vn(65, 31, 70), size = vn(7, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 39), size = vn(12, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 11), size = vn(2, 3, 28)},
	{act = 'cube', node = 'air', loc = vn(35, 31, 70), size = vn(10, 3, 9)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 2, loc = vn(30, 31, 65), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(30, 31, 75), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(45, 31, 75), size = vn(8, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(57, 21, 1), size = vn(6, 6, 78)},
	{act = 'cube', node = 'air', loc = vn(63, 21, 58), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(72, 21, 56), size = vn(7, 3, 8)},
	{act = 'stair', node = stone_stairs_main, depth = 2, height = 4, param2 = 3, loc = vn(69, 21, 39), size = vn(10, 10, 2)},
	{act = 'sphere', node = 'air', loc = vn(10, 11, 2), size = vn(20, 20, 20)},
	{act = 'cube', node = stone_main, loc = vn(10, 11, 2), size = vn(20, 10, 20)},
	{act = 'cube', node = stone_block_main, loc = vn(10, 20, 2), size = vn(20, 1, 20)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 1), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(35, 21, 21), size = vn(13, 5, 27)},
	{act = 'cube', node = 'air',treasure = 10,  loc = vn(37, 21, 55), size = vn(16, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(51, 21, 53), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 48), size = vn(2, 3, 9)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 0, loc = vn(51, 21, 65), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 65), size = vn(2, 3, 14)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 0, loc = vn(65, 21, 60), size = vn(2, 10, 10)},

	{act = 'cube', node = stone_stairs_main, param2 = 0, loc = vn(51, 20, 53), size = vn(2, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(5, 26, 5), size = vn(4, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(45, 31, 11), size = vn(12, 3, 2)},
	{act = 'stair', node = stone_stairs_main, height = 5, param2 = 1, loc = vn(40, 26, 11), size = vn(5, 5, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 26, 11), size = vn(35, 3, 2)},
	{act = 'cube', node = stone_main, loc = vn(9, 25, 11), size = vn(22, 1, 2)},

	{act = 'cube', node = 'air', loc = vn(64, 21, 20), size = vn(7, 3, 1)},
	{act = 'cube', node ='air', loc = vn(64, 21, 20), size = vn(1, 3, 1)},--?
	{act = 'cube', node = 'air', loc = vn(41, 21, 11), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 3), size = vn(2, 3, 52)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 19), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(74, 21, 42), size = vn(5, 4, 13)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 48), size = vn(1, 2, 1)},
	{act = 'cube', node = door_b, param2 = 1, loc = vn(73, 21, 48), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(29, 21, 11), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 1), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 11), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 13), size = vn(2, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 21), size = vn(2, 3, 58)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 55), size = vn(14, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 10, loc = vn(1, 21, 25), size = vn(14, 4, 50)},
	{act = 'cube', node = 'air', loc = vn(2, 25, 26), size = vn(12, 1, 48)},
	{act = 'cube', node = 'air', loc = vn(3, 26, 27), size = vn(10, 1, 46)},
	{act = 'cube', node = 'air', loc = vn(4, 27, 28), size = vn(8, 1, 44)},
	{act = 'cube', node = 'air', loc = vn(15, 21, 49), size = vn(4, 3, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(5, 21, 30), size = vn(5, 1, 40)},
	{act = 'cube', node = freshwater, loc = vn(6, 21, 31), size = vn(3, 1, 38)},
	{act = 'stair', node = stone_stairs_main, height = 4, param2 = 2, loc = vn(70, 31, 60), size = vn(2, 10, 10)},

	--stairs
	{act = 'cube', node = stone_main, loc = vn(26, 0, 23), size = vn(5, 5, 31)},
	{act = 'cube', node = stone_main, loc = vn(26, 0, 49), size = vn(28, 26, 5)},
	{act = 'cube', node = stone_main, loc = vn(49, 19, 29), size = vn(5, 27, 28)},
	{act = 'cube', node = stone_main, loc = vn(29, 39, 26), size = vn(25, 27, 5)},
	{act = 'cube', node = stone_main, loc = vn(26, 59, 26), size = vn(5, 21, 28)},
	{act = 'cube', node = 'air', loc = vn(27, 0, 47), size = vn(3, 4, 6)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 3, param2 = 1, loc = vn(30, 0, 50), size = vn(20, 20, 3)},
	{act = 'cube', node = 'air', loc = vn(47, 20, 50), size = vn(6, 4, 3)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 3, param2 = 2, loc = vn(50, 20, 30), size = vn(3, 20, 20)},
	{act = 'cube', node = 'air', loc = vn(50, 40, 27), size = vn(3, 4, 6)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 3, param2 = 3, loc = vn(30, 40, 27), size = vn(20, 20, 3)},
	{act = 'cube', node = 'air', loc = vn(27, 60, 27), size = vn(6, 4, 3)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 3, param2 = 0, loc = vn(27, 60, 30), size = vn(3, 21, 20)},
}

for y = 2, 78, 3 do
	for x = 56, 63, 7 do
		table.insert(stair_base, {act = 'cube', node = 'air', loc = vn(x, 21, y), size = vn(1, 3, 1)})
	end
end

for _, y in pairs({1, 7, 13, 22, 28, 34, 40, 46, 52}) do
	table.insert(stair_base, {act = 'cube', node = 'air', treasure = 10, loc = vn(65, 21, y), size = vn(5, 3, 5)})
	table.insert(stair_base, {act = 'cube', node = 'air', loc = vn(70, 21, y + 2), size = vn(1, 2, 1)})
	table.insert(stair_base, {act = 'cube', node = door_a, param2 = 3, loc = vn(70, 21, y + 2), size = vn(1, 1, 1)})
end

for _, y in pairs({1, 7, 13, 22, 28}) do
	table.insert(stair_base, {act = 'cube', node = 'air', treasure = 10, loc = vn(74, 21, y), size = vn(5, 3, 5)})
	table.insert(stair_base, {act = 'cube', node = 'air', loc = vn(73, 21, y + 2), size = vn(1, 2, 1)})
	table.insert(stair_base, {act = 'cube', node = door_b, param2 = 1, loc = vn(73, 21, y + 2), size = vn(1, 1, 1)})
end

for _, y in pairs({24, 30, 36, 42, 48, 59, 65, 71}) do
	table.insert(stair_base, {act = 'cube', node = 'air', treasure = 10, loc = vn(22, 21, y), size = vn(5, 3, 5)})
	table.insert(stair_base, {act = 'cube', node = 'air', loc = vn(21, 21, y + 2), size = vn(1, 2, 1)})
	table.insert(stair_base, {act = 'cube', node = door_b, param2 = 1, loc = vn(21, 21, y + 2), size = vn(1, 1, 1)})
end

for _, item in pairs(default_exits) do
	table.insert(stair_base, 2, table.copy(item))
end

if seal_underground then
	table.insert(stair_base, table.copy(seal_box))
end


-----------------------------------------------------
--great_hall

local great_hall = {
	--hall
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(26, 25, 0), size = vn(10, 10, 80)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(36, 25, 0), size = vn(10, 10, 80)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(46, 25, 0), size = vn(10, 10, 80)},
	{act = 'cube', node = 'air', treasure = 2, floor = stone_block_2nd, loc = vn(26, 21, 0), size = vn(30, 8, 80)},

	--side rooms
	{act = 'cube', node = n_ex, treasure = 6, floor = stone_block_3rd, loc = vn(0, 21, 12), size = vn(26, 7, 16)},
	{act = 'cube', node = n_ex, treasure = 6, floor = stone_block_3rd, loc = vn(0, 21, 32), size = vn(26, 7, 16)},
	{act = 'cube', node = n_ex, treasure = 6, floor = stone_block_3rd, loc = vn(0, 21, 52), size = vn(26, 7, 16)},

	{act = 'cube', node = n_ex, treasure = 6, floor = stone_block_3rd, loc = vn(56, 21, 12), size = vn(24, 7, 16)},
	{act = 'cube', node = n_ex, treasure = 6, floor = stone_block_3rd,  loc = vn(56, 21, 32), size = vn(24, 7, 16)},
	{act = 'cube', node = n_ex, treasure = 6, floor = stone_block_3rd,  loc = vn(56, 21, 52), size = vn(24, 7, 16)},

	--upper rooms
	{act = 'cube', node = 'air', treasure = 10, loc = vn(10, 51, 18), size = vn(20, 6, 20)},
	{act = 'cube', node = 'air',loc = vn(21, 51, 30), size = vn(3, 3, 9)},
	{act = 'cube', node = 'air',loc = vn(16, 51, 30), size = vn(3, 3, 9)},
	{act = 'cube', node = 'air',loc = vn(30, 51, 18), size = vn(9, 3, 3)},
	{act = 'cube', node = 'air',loc = vn(36, 51, 15), size = vn(3, 3, 4)},

	--stair
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(12, 21, 3), size = vn(2, 3, 9)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 4, depth = 1, param2 = 1, loc = vn(14, 21, 3), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(24, 31, 3), size = vn(2, 3, 2)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 4, depth = 1, param2 = 0, loc = vn(24, 31, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(24, 41, 15), size = vn(2, 3, 2)},
	{act = 'stair', node = stone_stairs_block_3rd, height = 4, depth = 1, param2 = 1, loc = vn(26, 41, 15), size = vn(10, 10, 2)},

}

--pillars
for _, z in pairs({6, 21, 36, 51, 66}) do
	table.insert(great_hall, {act = 'cube', node = stone_block_3rd, loc = vn(35, 21, z), size = vn(2, 8, 2)})
	table.insert(great_hall, {act = 'cube', node = stone_block_3rd, loc = vn(45, 21, z), size = vn(2, 8, 2)})
end

for x = 9, 69, 15 do
	table.insert(great_hall, {act = 'cube', node = 'air', floor = stone_block_main, loc = vn(x, 51, 41), size = vn(2, 3, 39)})
	for z = 44, 74, 6 do
		table.insert(great_hall, {act = 'cube', node = 'air', floor = stone_block_main, treasure = 20, loc = vn(x - 6, 51, z - 2), size = vn(5, 3, 5)})
		table.insert(great_hall, {act = 'cube', node = 'air', floor = stone_block_main, treasure = 20, loc = vn(x + 3, 51, z - 2), size = vn(5, 3, 5)})
		table.insert(great_hall, {act = 'cube', node = 'air', floor = stone_block_main, loc = vn(x - 1, 51, z), size = vn(1, 2, 1)})
		table.insert(great_hall, {act = 'cube', node = door_b, param2 = 3, loc = vn(x - 1, 51, z), size = vn(1, 1, 1)})
		table.insert(great_hall, {act = 'cube', node = 'air', floor = stone_block_main, loc = vn(x + 2, 51, z), size = vn(1, 2, 1)})
		table.insert(great_hall, {act = 'cube', node = door_a, param2 = 1, loc = vn(x + 2, 51, z), size = vn(1, 1, 1)})
	end
end

for _, item in pairs(upper_cross) do
	table.insert(great_hall, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(great_hall, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(great_hall, 2, table.copy(item))
end


if seal_underground then
	table.insert(great_hall, 1, table.copy(seal_box))
end


-----------------------------------------------------
--apartments

local apartments = {
	--lower stair linker
	{act = 'cube', node = 'air', loc = vn(50, 20, 50), size = vn(2, 3, 9)},
	{act = 'stair', node = stone_stairs_main, height = 3, depth = 2, param2 = 0, loc = vn(50, 20, 58), size = vn(2, 1, 1)},

	--corridors middle
	--{act = 'cube', node = 'air', loc = vn(20, 31, 39), size = vn(40, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 20), size = vn(2, 3, 40)},
	{act = 'cube', node = 'air', loc = vn(32, 31, 53), size = vn(7, 3, 2)},

	-- big room middle
	{act = 'cube', node = 'air', treasure = 30, loc = vn(22, 31, 22), size = vn(16, 5, 16)},
	{act = 'cube', node = 'air', loc = vn(38, 31, 28), size = vn(1, 3, 4)},

}

-- apartments
for _, z in pairs({32, 52}) do
	for _, y in pairs({21, 51}) do

		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(37, y, z), size = vn(2, 2, 2)})
		table.insert(apartments, {act = 'cube', node = door_b, param2 = 1, loc = vn(38, y, z), size = vn(1, 1, 1)})
		table.insert(apartments, {act = 'cube', node = door_a, param2 = 1, loc = vn(38, y, z+1), size = vn(1, 1, 1)})
		table.insert(apartments, {act = 'cube', node = 'air', treasure = 3, floor = stone_block_4th, loc = vn(31, y, z-2), size = vn(6, 3, 6)})
		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(25, y, z), size = vn(6, 3, 2)})
		table.insert(apartments, {act = 'cube', node = 'air', treasure = 3, floor = stone_block_4th, loc = vn(24, y, z-8), size = vn(6, 3, 6)})
		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(26, y, z-2), size = vn(1, 2, 2)})
		table.insert(apartments, {act = 'cube', node = door_a, param2 = 0, loc = vn(26, y, z-2), size = vn(1, 1, 1)})

		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(29, y, z+2), size = vn(1, 2, 1)})
		table.insert(apartments, {act = 'cube', node = door_a, param2 = 2, loc = vn(29, y, z+2), size = vn(1, 1, 1)})
		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, treasure = 3, loc = vn(27, y, z+3), size = vn(3, 3, 3)})

		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(25, y, z+2), size = vn(1, 2, 1)})
		table.insert(apartments, {act = 'cube', node = door_a, param2 = 2, loc = vn(25, y, z+2), size = vn(1, 1, 1)})
		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_4th, treasure = 3, loc = vn(23, y, z+3), size = vn(3, 3, 3)})
	end
end

for _, y in pairs({21, 51}) do
	-- big room
	table.insert(apartments, {act = 'cube', node = 'air', treasure = 3, loc = vn(42, y, 22), size = vn(16, 5, 16)})
	table.insert(apartments, {act = 'cube', node = 'air', loc = vn(41, y, 28), size = vn(1, 3, 4)})
	table.insert(apartments, {act = 'cube', node = 'air', loc = vn(58, y, 28), size = vn(1, 3, 4)})
end


-- middle rooms
for _, z in pairs({21, 31, 44, 54}) do

		table.insert(apartments, {act = 'cube', node = 'air', floor = stone_block_main, loc = vn(41, 31, z), size = vn(1, 2, 1)})
		table.insert(apartments, {act = 'cube', node = door_a, param2 = 1, loc = vn(41, 31, z), size = vn(1, 1, 1)})
		table.insert(apartments, {act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(42, 31, z-2), size = vn(6, 3, 8)})
		table.insert(apartments, {act = 'cube', node = 'air', treasure = 3, floor = stone_main, loc = vn(48, 32, z-2), size = vn(1, 1, 3)})
		table.insert(apartments, {act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(48, 31, z+2), size = vn(3, 3, 3)})

end



for _, item in pairs(lower_cross_hash) do
	table.insert(apartments, 2, table.copy(item))
end

for _, item in pairs(upper_cross_hash) do
	table.insert(apartments, 2, table.copy(item))
end

for _, item in pairs(lower_cross) do
	table.insert(apartments, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(apartments, 2, table.copy(item))
end

for _, item in pairs(central_stairwell) do
	table.insert(apartments, 2, table.copy(item))
end


for _, item in pairs(upper_stair) do
	table.insert(apartments, 2, table.copy(item))
end

for _, item in pairs(lower_stair) do
	table.insert(apartments, 2, table.copy(item))
end


if seal_underground then
	table.insert(great_hall, 1, table.copy(seal_box))
end


-----------------------------------------------------
--grand_apartments

local grand_apartments = {
	--central space
	{act = 'cube', node = 'air', loc = vn(25, 11, 25), size = vn(30, 59, 30)},

	--walkways
	{act = 'cube', node = stone_block_main, loc = vn(25, 60, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = stone_block_main, loc = vn(25, 50, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = stone_block_main, loc = vn(25, 40, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = stone_block_main, loc = vn(25, 30, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = stone_block_main, loc = vn(25, 20, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = 'air', loc = vn(28, 11, 28), size = vn(24, 54, 24)},

	--central pillar
	{act = 'cube', node = stone_main, loc = vn(35, 11, 35), size = vn(10, 59, 10)},

	--access walkways
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(0, 21, 38), size = vn(80, 3, 4)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(0, 51, 38), size = vn(80, 3, 4)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 21, 0), size = vn(4, 3, 80)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 51, 0), size = vn(4, 3, 80)},

	{act = 'cube', node = 'air', loc = vn(0, 24, 39), size = vn(80, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 54, 39), size = vn(80, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 24, 0), size = vn(2, 1, 80)},
	{act = 'cube', node = 'air', loc = vn(39, 54, 0), size = vn(2, 1, 80)},

	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(25, 31, 38), size = vn(30, 3, 4)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 31, 25), size = vn(4, 3, 30)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(25, 41, 38), size = vn(30, 3, 4)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 41, 25), size = vn(4, 3, 30)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(25, 61, 38), size = vn(30, 3, 4)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 61, 25), size = vn(4, 3, 30)},

	--stairs
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 2, loc = vn(33, 11, 42), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 0, loc = vn(33, 21, 28), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 2, loc = vn(33, 31, 42), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 0, loc = vn(33, 41, 28), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 2, loc = vn(33, 51, 42), size = vn(2, 10, 10)},

	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 0, loc = vn(45, 11, 42), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 2, loc = vn(45, 21, 28), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 0, loc = vn(45, 31, 42), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 2, loc = vn(45, 41, 28), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 1, param2 = 0, loc = vn(45, 51, 42), size = vn(2, 10, 10)},



	--lower stair
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(24, 0, 50), size = vn(6, 4, 6)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 2, param2 = 1, loc = vn(30, 0, 50), size = vn(11, 11, 2)},

}

--apartments
for _, x in pairs({26, 33, 45, 52}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		--back room
		table.insert(grand_apartments, {act = 'sphere', node = 'air', loc = vn(x-2, y+2, 10), size = vn(6, 6, 6)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 10, node = 'air', loc = vn(x-2, y, 10), size = vn(6, 4, 6)})
		table.insert(grand_apartments, {act = 'cube', treasure = 6, node = 'air', loc = vn(x, y+1, 9), size = vn(2, 2, 1)})

		--side alcoves
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(x+2, y, 17), size = vn(2, 3, 4)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(x-2, y, 17), size = vn(2, 3, 4)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(x+2, y, 22), size = vn(2, 3, 2)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(x-2, y, 22), size = vn(2, 3, 2)})

		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(x+2, y, 17), size = vn(1, 1, 2)})
		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(x-1, y, 17), size = vn(1, 1, 2)})

		--hallway and doors
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, y, 16), size = vn(2, 4, 8)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, y, 24), size = vn(2, 2, 1)})
		table.insert(grand_apartments, {act = 'cube', node = door_a, param2 = 2, loc = vn(x+1, y, 24), size = vn(1, 1, 1)})
		table.insert(grand_apartments, {act = 'cube', node = door_b, param2 = 2, loc = vn(x, y, 24), size = vn(1, 1, 1)})
	end
end

for _, x in pairs({30, 48}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		--large room
		table.insert(grand_apartments, {act = 'sphere', node = 'air', loc = vn(x-5, y+2, 56), size = vn(10, 5, 10)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(x-5, y, 56), size = vn(10, 4, 10)})
		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(x-3, y, 58), size = vn(1, 1, 6)})
		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(x+3, y, 58), size = vn(1, 1, 6)})
		--back room
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 10, node = 'air', loc = vn(x-5, y, 67), size = vn(10, 3, 5)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x-2, y, 66), size = vn(4, 2, 1)})

		--door
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, y, 55), size = vn(2, 2, 1)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = door_b, param2 = 0, loc = vn(x+1, y, 55), size = vn(1, 1, 1)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = door_a, param2 = 0, loc = vn(x, y, 55), size = vn(1, 1, 1)})

	end
end

for _, z in pairs({30, 48}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		--large room
		table.insert(grand_apartments, {act = 'sphere', node = 'air', loc = vn(56, y+2, z-5), size = vn(10, 5, 10)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(56, y, z-5), size = vn(10, 4, 10)})
		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(58, y, z-3), size = vn(6, 1, 1)})
		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(58, y, z+3), size = vn(6, 1, 1)})
		--back room
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 10, node = 'air', loc = vn(67, y, z-5), size = vn(5, 3, 10)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(66, y, z-2), size = vn(1, 2, 4)})

		--door
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(55, y, z), size = vn(1, 2, 2)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = door_a, param2 = 1, loc = vn(55, y, z+1), size = vn(1, 1, 1)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = door_b, param2 = 1, loc = vn(55, y, z), size = vn(1, 1, 1)})

	end
end


for _, z in pairs({26, 33, 45, 52}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		--back room
		table.insert(grand_apartments, {act = 'sphere', node = 'air', loc = vn(10, y+2, z-2), size = vn(6, 6, 6)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 10, node = 'air', loc = vn(10, y, z-2), size = vn(6, 4, 6)})
		table.insert(grand_apartments, {act = 'cube', treasure = 6, node = 'air', loc = vn(9, y+1, z), size = vn(1, 2, 2)})

		--side alcoves
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(17, y, z+2), size = vn(4, 3, 2)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(17, y, z-2), size = vn(4, 3, 2)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(22, y, z+2), size = vn(2, 3, 2)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, treasure = 15, node = 'air', loc = vn(22, y, z-2), size = vn(2, 3, 2)})

		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(17, y, z+2), size = vn(2, 1, 1)})
		table.insert(grand_apartments, {act = 'cube', node = stone_block_main, loc = vn(17, y, z-1), size = vn(2, 1, 1)})

		--hallway and doors
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(16, y, z), size = vn(8, 4, 2)})
		table.insert(grand_apartments, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(24, y, z), size = vn(1, 2, 2)})
		table.insert(grand_apartments, {act = 'cube', node = door_b, param2 = 3, loc = vn(24, y, z+1), size = vn(1, 1, 1)})
		table.insert(grand_apartments, {act = 'cube', node = door_a, param2 = 3, loc = vn(24, y, z), size = vn(1, 1, 1)})
	end
end


if seal_underground then
	table.insert(grand_apartments, 1, table.copy(seal_box))
end



-----------------------------------------------------
-----------------------------------------------------
--market

local market = {
	{act = 'cube', node = 'air', loc = vn(1, 21, 21), size = vn(2, 3, 40)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(7, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 17), size = vn(70, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 19), size = vn(7, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 1), size = vn(42, 6, 14)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 46), size = vn(5, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 23), size = vn(5, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(69, 21, 23), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 21), size = vn(50, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 21), size = vn(2, 3, 59)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 77), size = vn(22, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(44, 21, 75), size = vn(2, 3, 2)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(30, 25, 25), size = vn(10, 10, 50)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(40, 25, 25), size = vn(10, 10, 50)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(50, 25, 25), size = vn(10, 10, 50)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(30, 21, 25), size = vn(30, 8, 50)},

	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(24, 21, 64), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(24, 21, 51), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(24, 21, 38), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(24, 21, 25), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(61, 21, 64), size = vn(14, 3, 11)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(61, 21, 51), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(61, 21, 38), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 5, loc = vn(61, 21, 25), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(29, 21, 68), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(29, 21, 56), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(29, 21, 43), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(29, 21, 30), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(60, 21, 68), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(60, 21, 56), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(60, 21, 43), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(60, 21, 30), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 34), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 59), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 31, 13), size = vn(25, 4, 11)},
	{act = 'stair', node = stone_stairs_3rd, param2 = 3, loc = vn(33, 21, 14), size = vn(10, 10, 1)},
	{act = 'cube', node = 'air', loc = vn(61, 31, 56), size = vn(14, 4, 19)},
	{act = 'ladder', node = ladder, param2 = 4, loc = vn(63, 21, 74), size = vn(1, 10, 1)},
	{act = 'stair', node = stone_stairs_3rd, param2 = 0, loc = vn(73, 21, 49), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_3rd, param2 = 1, loc = vn(6, 21, 57), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 31, 24), size = vn(2, 4, 35)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 1, loc = vn(61, 31, 22), size = vn(2, 4, 34)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(36, 31, 22), size = vn(25, 4, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 57), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 31, 55), size = vn(2, 4, 1)},--?
	{act = 'cube', node = 'air', loc = vn(36, 31, 22), size = vn(1, 4, 2)},--?
	{act = 'stair', node = stone_stairs_3rd, param2 = 2, loc = vn(67, 31, 46), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(55, 41, 37), size = vn(10, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(13, 41, 16), size = vn(53, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(12, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(23, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(34, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(45, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(56, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(12, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(23, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(34, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(45, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 5, loc = vn(56, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', loc = vn(67, 41, 25), size = vn(2, 3, 21)},
	{act = 'cube', node = 'air', loc = vn(65, 41, 22), size = vn(4, 3, 3)},
	{act = 'stair', node = stone_stairs_3rd, param2 = 1, loc = vn(67, 41, 11), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 41, 41), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 41, 11), size = vn(2, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(77, 51, 3), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 39), size = vn(76, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 1), size = vn(78, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 3), size = vn(2, 3, 36)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 75), size = vn(2, 3, 4)},

	--lower stair link
	{act = 'cube', node = 'air', loc = vn(46, 20, 50), size = vn(4, 1, 2)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(50, 20, 50), size = vn(1, 1, 2)},
}

for x = 9, 69, 15 do
	table.insert(market, {act = 'cube', node = 'air', loc = vn(x, 51, 41), size = vn(2, 3, 34)})
	for z = 44, 74, 6 do
		table.insert(market, {act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 10, loc = vn(x - 6, 51, z - 2), size = vn(5, 3, 5)})
		table.insert(market, {act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 10, loc = vn(x + 3, 51, z - 2), size = vn(5, 3, 5)})
		table.insert(market, {act = 'cube', node = 'air', loc = vn(x - 1, 51, z), size = vn(1, 2, 1)})
		table.insert(market, {act = 'cube', node = door_b, param2 = 3, loc = vn(x - 1, 51, z), size = vn(1, 1, 1)})
		table.insert(market, {act = 'cube', node = 'air', loc = vn(x + 2, 51, z), size = vn(1, 2, 1)})
		table.insert(market, {act = 'cube', node = door_a, param2 = 1, loc = vn(x + 2, 51, z), size = vn(1, 1, 1)})
	end
end

for _, item in pairs(lower_stair) do
	table.insert(market, 2, table.copy(item))
end

if seal_underground then
	table.insert(market, 1, table.copy(seal_box))
end

for _, item in pairs(default_exits) do
	table.insert(market, 2, table.copy(item))
end


-----------------------------------------------------
--arena

local arena = {
	{act = 'cube', node = 'air', loc = vn(15, 39, 15), size = vn(50, 6, 50)},
	{act = 'cube', node = 'air', loc = vn(16, 38, 16), size = vn(48, 7, 48)},
	{act = 'cube', node = 'air', loc = vn(17, 37, 17), size = vn(46, 8, 46)},
	{act = 'cube', node = 'air', loc = vn(18, 36, 18), size = vn(44, 9, 44)},
	{act = 'cube', node = 'air', loc = vn(19, 35, 19), size = vn(42, 10, 42)},
	{act = 'cube', node = 'air', loc = vn(20, 34, 20), size = vn(40, 11, 40)},
	{act = 'cube', node = 'air', loc = vn(21, 33, 21), size = vn(38, 12, 38)},
	{act = 'cube', node = 'air', loc = vn(22, 32, 22), size = vn(36, 13, 36)},
	{act = 'cube', node = 'air', floor = lamp_block, treasure = 1, loc = vn(24, 21, 24), size = vn(32, 24, 32)},

	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 4, loc = vn(30, 21, 65), size = vn(20, 5, 10)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 4, loc = vn(30, 21, 5), size = vn(20, 5, 10)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, treasure = 4, loc = vn(65, 21, 30), size = vn(10, 5, 20)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 4, loc = vn(5, 21, 30), size = vn(10, 5, 20)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(39, 21, 56), size = vn(2, 3, 24)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(39, 21, 0), size = vn(2, 3, 24)},
	{act = 'cube', node = 'air', loc = vn(77, 21, 19), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(77, 21, 59), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 77), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 77), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(0, 21, 39), size = vn(24, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(56, 21, 39), size = vn(24, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(19, 31, 65), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 31, 65), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 31, 13), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 31, 13), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 31, 19), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 31, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 31, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 31, 19), size = vn(2, 3, 2)},

	{act = 'stair', node = stone_stairs_block_2nd, param2 = 2, loc = vn(59, 21, 67), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 0, loc = vn(59, 21, 3), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 0, loc = vn(19, 21, 3), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_2nd, param2 = 3, loc = vn(67, 21, 19), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_block_2nd, param2 = 3, loc = vn(67, 21, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 1, loc = vn(3, 21, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 1, loc = vn(3, 21, 19), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_block_2nd, param2 = 2, loc = vn(19, 21, 67), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(65, 39, 29), size = vn(2, 3, 22)},
	{act = 'cube', node = 'air', loc = vn(13, 39, 29), size = vn(2, 3, 22)},
	{act = 'cube', node = 'air', loc = vn(29, 39, 65), size = vn(22, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(29, 39, 13), size = vn(22, 3, 2)},

	{act = 'stair', node = stone_stairs_block_2nd, param2 = 2, loc = vn(65, 31, 51), size = vn(2, 8, 8)},
	{act = 'stair', node = stone_stairs_block_2nd, param2 = 0, loc = vn(65, 31, 21), size = vn(2, 8, 8)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 2, loc = vn(13, 31, 51), size = vn(2, 8, 8)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 0, loc = vn(13, 31, 21), size = vn(2, 8, 8)},
	{act = 'stair', node = stone_stairs_block_2nd, param2 = 3, loc = vn(51, 31, 65), size = vn(8, 8, 2)},
	{act = 'stair', node = stone_stairs_block_2nd, param2 = 1, loc = vn(21, 31, 65), size = vn(8, 8, 2)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 3, loc = vn(51, 31, 13), size = vn(8, 8, 2)},
	{act = 'stair', node = stone_stairs_block_3rd, param2 = 1, loc = vn(21, 31, 13), size = vn(8, 8, 2)},
}

for _, item in pairs(default_exits) do
	table.insert(arena, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(arena, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(arena, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(arena, 2, table.copy(item))
end

if seal_underground then
	table.insert(arena, 1, table.copy(seal_box))
end



-----------------------------------------------------
--grand_bazaar

local grand_bazaar = {
	--central space
	{act = 'cube', node = 'air', line = stone_block_4th, loc = vn(15, 11, 15), size = vn(50, 54, 50)},
	--top dome
	{act = 'sphere', node = 'air', loc = vn(15, 55, 15), size = vn(50, 20, 50)},

	--walkways
	{act = 'cube', node = special_stone, loc = vn(15, 60, 15), size = vn(50, 1, 50)},
	{act = 'cube', node = special_stone, loc = vn(15, 50, 15), size = vn(50, 1, 50)},
	{act = 'cube', node = special_stone, loc = vn(15, 40, 15), size = vn(50, 1, 50)},
	{act = 'cube', node = special_stone, loc = vn(15, 30, 15), size = vn(50, 1, 50)},
	{act = 'cube', node = special_stone, loc = vn(15, 20, 15), size = vn(50, 1, 50)},
	{act = 'cube', node = 'air', loc = vn(17, 11, 17), size = vn(46, 54, 46)},
	--central column,
	{act = 'sphere', node = stone_block_4th, loc = vn(25, 36, 25), size = vn(30, 30, 30)},
	{act = 'sphere', node = 'air', loc = vn(28, 39, 28), size = vn(24, 24, 24)},
	{act = 'cylinder', node = stone_4th, axis = 'y', loc = vn(24, 10, 24), size = vn(32, 41, 32)},
	--corner columns
	{act = 'cylinder', node = stone_4th, axis = 'y', loc = vn(0, 10, 0), size = vn(28, 61, 28)},
	{act = 'cylinder', node = stone_4th, axis = 'y', loc = vn(0, 10, 52), size = vn(28, 61, 28)},
	{act = 'cylinder', node = stone_4th, axis = 'y', loc = vn(52, 10, 0), size = vn(28, 61, 28)},
	{act = 'cylinder', node = stone_4th, axis = 'y', loc = vn(52, 10, 52), size = vn(28, 61, 28)},
	--access walkways
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(39, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(39, 51, 0), size = vn(2, 3, 80)},
	--central_stairwell
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(32, 11, 27), size = vn(5, 3, 2)},
	{act = 'stair', node = stone_stairs_block_4th, height = 4, depth = 2, param2 = 0, loc = vn(32, 11, 29), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_block_4th, height = 4, depth = 2, param2 = 0, loc = vn(32, 21, 41), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(32, 31, 51), size = vn(2, 3, 2)},
	{act = 'stair', node = stone_stairs_block_4th, height = 4, depth = 2, param2 = 1, loc = vn(34, 31, 51), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(44, 41, 51), size = vn(2, 3, 2)},
	{act = 'stair', node = stone_stairs_block_4th, height = 4, depth = 2, param2 = 2, loc = vn(44, 41, 41), size = vn(2, 10, 10)},

	--corner rooms
	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 11, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 11, 15), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 11, 25), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 11, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 11, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 11, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 11, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 11, 25), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 11, 15), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 11, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 11, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 11, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 21, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 21, 15), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 21, 25), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 21, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 21, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 21, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 21, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 21, 25), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 21, 15), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 21, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 21, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 21, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 31, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 31, 15), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 31, 25), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 31, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 31, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 31, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th,  axis = 'y', loc = vn(54, 31, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 31, 25), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 31, 15), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 31, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 31, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 31, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 41, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 41, 15), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 41, 25), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 41, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 41, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 41, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 41, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 41, 25), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 41, 15), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 41, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 41, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 41, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 51, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 51, 15), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 51, 25), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 51, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 51, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 51, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 51, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 51, 25), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 51, 15), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 51, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 51, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 51, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 61, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 61, 15), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 61, 25), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(2, 61, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(25, 61, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(15, 61, 53), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 61, 2), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 61, 25), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 61, 15), size = vn(2, 3, 2)},

	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(54, 61, 54), size = vn(24, 5, 24)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(53, 61, 63), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(63, 61, 53), size = vn(2, 3, 2)},

	--corner void
	{act = 'cylinder', node = 'air', floor = lamp_block, axis = 'y', loc = vn(62, 11, 62), size = vn(8, 60, 8)},

	--corner stairs
	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(3, 51, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(0, 61, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(3, 41, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(0, 51, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(3, 31, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(0, 41, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(3, 21, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(0, 31, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(3, 11, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(0, 21, 3), size = vn(9, 5, 2)},

	--
	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(75, 51, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(71, 61, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(75, 41, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(71, 51, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(75, 31, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(71, 41, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(75, 21, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(71, 31, 3), size = vn(9, 5, 2)},

	{act = 'stair', node = stone_stairs_block_4th, height = 6, depth = 2, param2 = 2, loc = vn(75, 11, 5), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(71, 21, 3), size = vn(9, 5, 2)},

	--lower stair
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(24, 0, 50), size = vn(6, 4, 6)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 2, param2 = 1, loc = vn(30, 0, 50), size = vn(11, 11, 2)},

	--central lower rooms
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(37, 11, 37), size = vn(6, 4, 6)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(41, 11, 43), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(36, 11, 53), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(37, 11, 25), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(40, 11, 25), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(43, 11, 38), size = vn(3, 3, 4)},
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(34, 11, 38), size = vn(3, 3, 4)},
	--central rooms
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(35, 21, 35), size = vn(3, 4, 3)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 21, 36), size = vn(1, 2, 1)},

	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(41, 21, 35), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(43, 21, 38), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(42, 21, 30), size = vn(8, 4, 8)},

	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(41, 21, 43), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(43, 21, 41), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(42, 21, 42), size = vn(8, 4, 8)},


}

--wall shops
for _, x in pairs({28, 34, 42, 48}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, treasure = 4, node = 'air', loc = vn(x, y, 7), size = vn(4, 3, 7)})
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, y, 14), size = vn(2, 3, 1)})
		table.insert(grand_bazaar, {act = 'cube', node = 'air', loc = vn(x+1, y+1, 14), size = vn(3, 2, 1)})
	end
end

for _, x in pairs({28, 34, 42, 48}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, treasure = 3, node = 'air', loc = vn(x, y, 66), size = vn(4, 3, 7)})
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, y, 65), size = vn(2, 3, 1)})
		table.insert(grand_bazaar, {act = 'cube', node = 'air', loc = vn(x+1, y+1, 65), size = vn(3, 2, 1)})
	end
end

for _, z in pairs({28, 34, 42, 48}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, treasure = 2, node = 'air', loc = vn(7, y, z), size = vn(7, 3, 4)})
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(14, y, z), size = vn(1, 3, 2)})
		table.insert(grand_bazaar, {act = 'cube', node = 'air', loc = vn(14, y+1, z+1), size = vn(1, 2, 3)})
	end
end

for _, z in pairs({28, 34, 42, 48}) do
	for _, y in pairs({11, 21, 31, 41, 51, 61}) do
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, treasure = 2, node = 'air', loc = vn(66, y, z), size = vn(7, 3, 4)})
		table.insert(grand_bazaar, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(65, y, z), size = vn(1, 3, 2)})
		table.insert(grand_bazaar, {act = 'cube', node = 'air', loc = vn(65, y+1, z+1), size = vn(1, 2, 3)})
	end
end



if seal_underground then
	table.insert(grand_bazaar, 1, table.copy(seal_box))
end



-----------------------------------------------------
--Plaza
local plaza = {
	{act = 'sphere', node = 'air', loc = vn(25, 22, 25), size = vn(30, 20, 30)},
	{act = 'cylinder', node = 'air', floor = stone_block_4th, axis = 'y', loc = vn(24, 21, 24), size = vn(32, 11, 32)},

	{act = 'sphere', node = 'air', loc = vn(25, 52, 25), size = vn(30, 20, 30)},
	{act = 'cylinder', node = 'air', floor = lamp_block, axis = 'y', loc = vn(24, 51, 24), size = vn(32, 11, 32)},
}

for _, item in pairs(lower_stair_room) do
	table.insert(plaza, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(plaza, 2, table.copy(item))
end

for _, item in pairs(lower_cross) do
	table.insert(plaza, 2, table.copy(item))
end

for _, item in pairs(lower_cross_hash) do
	table.insert(plaza, 2, table.copy(item))
end

if seal_underground then
	table.insert(plaza, 1, table.copy(seal_box))
end

-----------------------------------------------------
-----------------------------------------------------

-----------------------------------------------------
--silly_straw

local silly_straw = {
	{act = 'cube', node = 'air', loc = vn(19, 21, 76), size = vn(2, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 74), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 70), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 70), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 21, 72), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(25, 21, 76), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(28, 21, 60), size = vn(2, 3, 16)},
	{act = 'cube', node = 'air', loc = vn(28, 21, 58), size = vn(27, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(53, 21, 41), size = vn(2, 3, 17)},
	{act = 'cube', node = 'air', loc = vn(50, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 73), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(32, 21, 71), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(52, 21, 63), size = vn(16, 15, 16)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 59), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 52), size = vn(2, 3, 15)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 52), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 54), size = vn(2, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(11, 21, 61), size = vn(14, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 21, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 21, 57), size = vn(12, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 21, 55), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 21, 53), size = vn(37, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(48, 21, 50), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 41), size = vn(2, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 48), size = vn(25, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 25), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(8, 21, 25), size = vn(2, 3, 19)},
	{act = 'cube', node = 'air', loc = vn(8, 21, 44), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 23), size = vn(2, 3, 21)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 39), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(1, 21, 17), size = vn(78, 15, 6)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(2, 21, 3), size = vn(17, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(2, 21, 5), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 13), size = vn(33, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 9), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 11), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 11), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 9), size = vn(15, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 17)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 23), size = vn(2, 3, 13)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 17)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(59, 21, 36), size = vn(20, 3, 8)},
	{act = 'cube', node = 'air', treasure = 3, floor = lamp_block, loc = vn(30, 21, 30), size = vn(20, 15, 20)},

	{act = 'cube', node = 'air', loc = vn(13, 31, 55), size = vn(2, 3, 22)},
	{act = 'cube', node = 'air', loc = vn(15, 31, 75), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(17, 31, 45), size = vn(2, 3, 32)},
	{act = 'cube', node = 'air', loc = vn(4, 31, 53), size = vn(11, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 31, 25), size = vn(2, 3, 28)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(8, 31, 35), size = vn(11, 3, 10)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(8, 31, 24), size = vn(11, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(20, 31, 11), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(20, 31, 23), size = vn(2, 3, 18)},
	{act = 'cube', node = 'air', loc = vn(22, 31, 39), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(32, 31, 52), size = vn(2, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(34, 31, 52), size = vn(7, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 50), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 23), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 5), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(41, 31, 5), size = vn(24, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(58, 31, 11), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(58, 31, 23), size = vn(2, 3, 40)},
	{act = 'cube', node = 'air', loc = vn(50, 31, 39), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(63, 31, 58), size = vn(2, 3, 3)},
	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(3, 21, 65), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(12, 21, 9), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(50, 21, 9), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(65, 21, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(32, 21, 61), size = vn(2, 10, 10)},
	{act = 'ladder', node = ladder, param2 = 3, loc = vn(4, 21, 25), size = vn(1, 10, 1)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 9), size = vn(1, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(63, 41, 17), size = vn(2, 3, 31)},
	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(63, 31, 48), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_main, param2 = 0, loc = vn(63, 31, 7), size = vn(2, 10, 10)},

	{act = 'cube', node = stone_main, loc = vn(20, 30, 17), size = vn(2, 1, 6)},
	{act = 'cube', node = stone_main, loc = vn(39, 30, 17), size = vn(2, 1, 6)},
	{act = 'cube', node = stone_main, loc = vn(58, 30, 17), size = vn(2, 1, 6)},
	{act = 'cube', node = stone_main, loc = vn(56, 30, 63), size = vn(6, 1, 3)},
	{act = 'cube', node = stone_main, loc = vn(39, 30, 30), size = vn(2, 1, 20)},
	{act = 'cube', node = stone_main, loc = vn(30, 30, 39), size = vn(20, 1, 2)},

	{act = 'cube', node = 'air', loc = vn(1, 21, 58), size = vn(2, 3, 1)}, --?v..
	{act = 'cube', node = 'air', loc = vn(21, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 12), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(38, 21, 9), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(41, 21, 9), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 23), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(13, 31, 67), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(13, 31, 34), size = vn(2, 3, 1)},--?^..
}

for _, item in pairs(default_exits) do
	table.insert(silly_straw, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(silly_straw, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(silly_straw, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(silly_straw, 2, table.copy(item))
end

if seal_underground then
	table.insert(silly_straw, 1, table.copy(seal_box))
end


--------------------------------------------------------
--pillared_room

local pillared_room = {
	{act = 'cube', node = 'air', line = stone_block_2nd, treasure = 1, loc = vn(1, 21, 1), size = vn(78, 38, 78)},
	{act = 'cube', node = stone_block_2nd, loc = vn(1, 50, 1), size = vn(78, 1, 78)},
	{act = 'cube', node = 'air', loc = vn(5, 50, 5), size = vn(70, 1, 70)},
	{act = 'stair', node = stone_stairs_block_2nd, depth = 3, height = 4, param2 = 2, loc = vn(1, 21, 25), size = vn(2, 30, 30)},
	{act = 'stair', node = stone_stairs_block_2nd, depth = 3, height = 4, param2 = 0, loc = vn(77, 21, 25), size = vn(2, 30, 30)},
}

for _, item in pairs(default_exits) do
	table.insert(pillared_room, 2, table.copy(item))
end

for z = 7, 78, 9 do
	for x = 7, 78, 9 do
		local i = {act = 'cube', node = stone_block_2nd, loc = vn(z, 21, x), size = vn(2, 38, 2)}
		table.insert(pillared_room, i)

		for y = 25, 57, 9 do
			i = {act = 'cube', node = lamp_block, loc = vn(z, y, x), size = vn(2, 1, 2), cheap_lighting = true}
			table.insert(pillared_room, i)
		end

	end
end


for _, item in pairs(lower_stair_room) do
	table.insert(pillared_room, 2, table.copy(item))
end

if seal_underground then
	table.insert(pillared_room, 1, table.copy(seal_box))
end

-----------------------------------------------------
--pillared_room_antiq

local pillared_room_antiq = {
	{act = 'cube', node = 'air', line = special_stone, treasure = 1, loc = vn(1, 21, 1), size = vn(78, 38, 78)},
	{act = 'cube', node = special_stone, loc = vn(1, 50, 1), size = vn(78, 1, 78)},
	{act = 'cube', node = 'air', loc = vn(5, 50, 5), size = vn(70, 1, 70)},
	--{act = 'stair', node = stone_stairs_block_2nd, depth = 3, height = 4, param2 = 2, loc = vn(1, 21, 25), size = vn(2, 30, 30)},
	--{act = 'stair', node = stone_stairs_block_2nd, depth = 3, height = 4, param2 = 0, loc = vn(77, 21, 25), size = vn(2, 30, 30)},
}

for _, item in pairs(default_exits) do
	table.insert(pillared_room_antiq, 2, table.copy(item))
end

for z = 7, 78, 9 do
	for x = 7, 78, 9 do
		local i = {act = 'cube', node = special_stone, loc = vn(z, 21, x), size = vn(2, 38, 2)}
		table.insert(pillared_room_antiq, i)

		for y = 25, 57, 9 do
			i = {act = 'cube', node = lamp_block, loc = vn(z, y, x), size = vn(2, 1, 2), cheap_lighting = true}
			table.insert(pillared_room_antiq, i)
		end

	end
end

for _, item in pairs(lower_stair_room) do
	table.insert(pillared_room_antiq, 2, table.copy(item))
end

if seal_underground then
	table.insert(pillared_room_antiq, 1, table.copy(seal_box))
end

-----------------------------------------------------
--pillared_room_moon

local pillared_room_moon = {
	{act = 'cube', node = 'air', line = special_stone, treasure = 1, loc = vn(1, 21, 1), size = vn(78, 38, 78)},
	{act = 'cube', node = special_stone, loc = vn(1, 50, 1), size = vn(78, 1, 78)},
	{act = 'cube', node = 'air', loc = vn(5, 50, 5), size = vn(70, 1, 70)},
	--{act = 'stair', node = stone_stairs_block_2nd, depth = 3, height = 4, param2 = 2, loc = vn(1, 21, 25), size = vn(2, 30, 30)},
	--{act = 'stair', node = stone_stairs_block_2nd, depth = 3, height = 4, param2 = 0, loc = vn(77, 21, 25), size = vn(2, 30, 30)},
}

for _, item in pairs(default_exits) do
	table.insert(pillared_room_moon, 2, table.copy(item))
end

for z = 7, 78, 9 do
	for x = 7, 78, 9 do
		local i = {act = 'cube', node = lamp_block, loc = vn(z, 21, x), size = vn(2, 38, 2)}
		table.insert(pillared_room_moon, i)

	end
end

for _, item in pairs(lower_stair_room) do
	table.insert(pillared_room_moon, 2, table.copy(item))
end

if seal_underground then
	table.insert(pillared_room_moon, 1, table.copy(seal_box))
end

-----------------------------------------------------
--jade_temple

local jade_temple = {
	{act = 'cube', node = 'air', line = special_stone, loc = vn(1, 21, 1), size = vn(78, 38, 78)},
	{act = 'cube', node = lamp_block, loc = vn(1, 50, 1), size = vn(78, 1, 78)},
	{act = 'cube', node = 'air', loc = vn(5, 50, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 30, loc = vn(5, 58, 5), size = vn(70, 1, 70)},

	{act = 'cube', node = "artifacts:sculpture_j_axeman", param2 = 0, random = 30, loc = vn(5, 21, 5), size = vn(70, 1, 70)},

	{act = 'cube', node = "nodes_nature:jade", loc = vn(28, 21, 28), size = vn(24, 12, 24)},
	{act = 'cube', node = "nodes_nature:jade", loc = vn(34, 33, 34), size = vn(12, 6, 12)},
	{act = 'cube', node = "nodes_nature:jade", loc = vn(37, 39, 37), size = vn(6, 3, 6)},

	{act = 'cube', node = "air", floor = special_stone, loc = vn(36, 33, 36), size = vn(8, 5, 8)},
	{act = 'cube', node = lamp_block, loc = vn(36, 33, 36), size = vn(2, 1, 2)},
	{act = 'cube', node = "air", treasure = 1, loc = vn(36, 34, 36), size = vn(2, 1, 2)},
	{act = 'cube', node = lamp_block, loc = vn(42, 33, 36), size = vn(2, 1, 2)},
	{act = 'cube', node = "air", treasure = 1, loc = vn(42, 34, 36), size = vn(2, 1, 2)},

	{act = 'cube', node = lamp_block, param2 = 3, loc = vn(42, 33, 42), size = vn(1, 1, 1)},
	{act = 'cube', node = "artifacts:waystone", loc = vn(42, 34, 42), size = vn(1, 1, 1)},

	{act = 'cube', node = lamp_block, param2 = 3, loc = vn(37, 33, 42), size = vn(1, 1, 1)},
	{act = 'cube', node = "artifacts:bell", loc = vn(37, 34, 42), size = vn(1, 1, 1)},

	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 10, loc = vn(36, 37, 36), size = vn(8, 1, 8)},

	{act = 'stair', node = "stairs:stair_jade_block", depth = 0, height = 3, param2 = 2, loc = vn(39, 21, 41), size = vn(2, 12, 12)},
	{act = 'cube', node = "nodes_nature:jade", loc = vn(38, 21, 52), size = vn(1, 1, 1)},
	{act = 'cube', node = "nodes_nature:jade", loc = vn(41, 21, 52), size = vn(1, 1, 1)},
	{act = 'cube', node = "artifacts:sculpture_j_dragon_head", param2 = 2, loc = vn(38, 22, 52), size = vn(1, 1, 1)},
	{act = 'cube', node = "artifacts:sculpture_j_dragon_head", param2 = 2, loc = vn(41, 22, 52), size = vn(1, 1, 1)},


}

for _, item in pairs(default_exits) do
	table.insert(jade_temple, 2, table.copy(item))
end


for _, item in pairs(lower_stair_room) do
	table.insert(jade_temple, 2, table.copy(item))
end

if seal_underground then
	table.insert(jade_temple, 1, table.copy(seal_box))
end


-----------------------------------------------------
--fountain_court

local fountain_court = {
	--{param = 'wet'},
	{act = 'cube', node = 'air', line = stone_block_3rd, loc = vn(26, 11, 25), size = vn(30, 4, 30)},
	{act = 'cube', node = 'air', loc = vn(29, 11, 55), size = vn(2, 3, 16)},
	{act = 'cube', node = 'air', loc = vn(25, 11, 69), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(25, 11, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 11, 9), size = vn(2, 3, 62)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 24), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 39), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 54), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 69), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 11, 59), size = vn(12, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 11, 55), size = vn(2, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(49, 11, 19), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(29, 11, 9), size = vn(2, 3, 16)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(15, 11, 5), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(15, 11, 20), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(15, 11, 35), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(15, 11, 50), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 3, loc = vn(15, 11, 65), size = vn(10, 6, 10)},
	{act = 'cube', node = stone_block_3rd, loc = vn(18, 11, 8), size = vn(4, 6, 4)},
	{act = 'cube', node = stone_block_3rd, loc = vn(18, 11, 23), size = vn(4, 6, 4)},
	{act = 'cube', node = stone_block_3rd, loc = vn(18, 11, 38), size = vn(4, 6, 4)},
	{act = 'cube', node = stone_block_3rd, loc = vn(18, 11, 53), size = vn(4, 6, 4)},
	{act = 'cube', node = stone_block_3rd, loc = vn(18, 11, 68), size = vn(4, 6, 4)},
	{act = 'cube', node = freshwater, loc = vn(19, 11, 9), size = vn(2, 10, 2)},
	{act = 'cube', node = freshwater, loc = vn(19, 11, 24), size = vn(2, 10, 2)},
	{act = 'cube', node = freshwater, loc = vn(19, 11, 39), size = vn(2, 10, 2)},
	{act = 'cube', node = freshwater, loc = vn(19, 11, 54), size = vn(2, 10, 2)},
	{act = 'cube', node = freshwater, loc = vn(19, 11, 69), size = vn(2, 10, 2)},

	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(61, 11, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 2, loc = vn(39, 11, 1), size = vn(2, 10, 10)},
	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(39, 11, 19), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 11, 11), size = vn(2, 3, 14)},
	{act = 'cube', node = stone_block_3rd, loc = vn(61, 21, 59), size = vn(1, 6, 2)},

	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(10, 15, 1), size = vn(20, 20, 79)},
	{act = 'cube', node = stone_block_3rd, loc = vn(10, 15, 1), size = vn(20, 6, 79)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(10, 21, 1), size = vn(20, 4, 79)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(1, 21, 56), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(1, 21, 36), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(1, 21, 16), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 64), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 69), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 44), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 49), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 24), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 29), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 9), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(31, 21, 56), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(31, 21, 36), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', treasure = 10, loc = vn(31, 21, 16), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 64), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 69), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 44), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 49), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 24), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 29), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 9), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 39), size = vn(41, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 19), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 1), size = vn(2, 3, 79)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 69), size = vn(2, 3, 11)},

	{act = 'cube', node = stone_block_3rd, loc = vn(15, 21, 5), size = vn(10, 1, 10)},
	{act = 'cube', node = freshwater, loc = vn(16, 21, 6), size = vn(8, 1, 8)},
	{act = 'cube', node = stone_block_3rd, loc = vn(19, 21, 9), size = vn(2, 2, 2)},
	--{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 9), size = vn(2, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(15, 21, 20), size = vn(10, 1, 10)},
	{act = 'cube', node = freshwater, loc = vn(16, 21, 21), size = vn(8, 1, 8)},
	{act = 'cube', node = stone_block_3rd, loc = vn(19, 21, 24), size = vn(2, 2, 2)},
	--{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 24), size = vn(2, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(15, 21, 35), size = vn(10, 1, 10)},
	{act = 'cube', node = freshwater, loc = vn(16, 21, 36), size = vn(8, 1, 8)},
	{act = 'cube', node = stone_block_3rd, loc = vn(19, 21, 39), size = vn(2, 2, 2)},
	--{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 39), size = vn(2, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(15, 21, 50), size = vn(10, 1, 10)},
	{act = 'cube', node = freshwater, loc = vn(16, 21, 51), size = vn(8, 1, 8)},
	{act = 'cube', node = stone_block_3rd, loc = vn(19, 21, 54), size = vn(2, 2, 2)},
	--{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 54), size = vn(2, 1, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(15, 21, 65), size = vn(10, 1, 10)},
	{act = 'cube', node = freshwater, loc = vn(16, 21, 66), size = vn(8, 1, 8)},
	{act = 'cube', node = stone_block_3rd, loc = vn(19, 21, 69), size = vn(2, 2, 2)},
	--{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 69), size = vn(2, 1, 2)},

	{act = 'cube', node = 'air', loc = vn(51, 31, 65), size = vn(20, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(51, 31, 15), size = vn(10, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(55, 31, 25), size = vn(2, 3, 27)},
	{act = 'cube', node = 'air', loc = vn(60, 31, 41), size = vn(2, 3, 24)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 39), size = vn(8, 3, 2)},
	{act = 'cube', node = stone_block_3rd, loc = vn(54, 11, 49), size = vn(4, 6, 4)},
	{act = 'cube', node = 'air', loc = vn(55, 6, 50), size = vn(2, 25, 2)},
	{act = 'cube', node = 'air', loc = vn(55, 30, 50), size = vn(2, 1, 2)},--?
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 1, loc = vn(65, 31, 35), size = vn(10, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(69, 31, 45), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, treasure = 1, loc = vn(65, 31, 50), size = vn(10, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 39), size = vn(1, 3, 2)},--?

	{act = 'stair', node = stone_stairs_main, param2 = 3, loc = vn(61, 21, 19), size = vn(10, 10, 2)},
	{act = 'stair', node = stone_stairs_main, param2 = 1, loc = vn(41, 21, 69), size = vn(10, 10, 2)},
}

for _, item in pairs(default_exits) do
	table.insert(fountain_court, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(fountain_court, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(fountain_court, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(fountain_court, 2, table.copy(item))
end

if seal_underground then
	table.insert(fountain_court, 1, table.copy(seal_box))
end



-----------------------------------------------------
--sphere_of_light

local sphere_of_light = {
	{act = 'sphere', node = 'air', line = lamp_block, loc = vn(5, 8, 5), size = vn(70, 70, 70)},
	{act = 'cube', node = 'air', loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 0), size = vn(2, 3, 80)},

	{act = 'cube', node = 'air', treasure = 1, floor = special_stone, loc = vn(38, 38, 38), size = vn(4, 2, 4)},
	{act = 'cube', node = special_stone, loc = vn(38, 8, 38), size = vn(4, 29, 4)},

	{act = 'cube', node = 'air', floor = special_stone, loc = vn(19, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(39, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(59, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 21, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 21, 19), size = vn(80, 3, 2)},

	{act = 'cube', node = 'air', floor = special_stone, loc = vn(19, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(39, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(59, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 51, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 51, 19), size = vn(80, 3, 2)},

}

for _, item in pairs(default_exits) do
	table.insert(sphere_of_light, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(sphere_of_light, 2, table.copy(item))
end

if seal_underground then
	table.insert(sphere_of_light, 1, table.copy(seal_box))
end


-----------------------------------------------------
--sphere_of_darkness

local sphere_of_darkness = {
	{act = 'sphere', node = 'air', line = special_stone, loc = vn(5, 8, 5), size = vn(70, 70, 70)},
	{act = 'cube', node = 'air', loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 0), size = vn(2, 3, 80)},

	{act = 'cube', node = 'air', treasure = 1, floor = special_stone, loc = vn(38, 38, 38), size = vn(4, 2, 4)},
	{act = 'cube', node = lamp_block, loc = vn(38, 8, 38), size = vn(4, 29, 4)},

	{act = 'cube', node = 'air', floor = special_stone, loc = vn(19, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(39, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(59, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 21, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 21, 19), size = vn(80, 3, 2)},

	{act = 'cube', node = 'air', floor = special_stone, loc = vn(19, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(39, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(59, 51, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 51, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = special_stone, loc = vn(0, 51, 19), size = vn(80, 3, 2)},

}

for _, item in pairs(default_exits) do
	table.insert(sphere_of_darkness, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(sphere_of_darkness, 2, table.copy(item))
end

if seal_underground then
	table.insert(sphere_of_darkness, 1, table.copy(seal_box))
end



-----------------------------------------------------
--forum

local forum = {
	--chamber
	{act = 'cube', node = 'air', line = stone_block_4th, floor = special_stone, loc = vn(25, 30, 25), size = vn(30, 10, 30)},
	{act = 'sphere', node = 'air', line = stone_block_4th, loc = vn(25, 30, 25), size = vn(30, 19, 30)},
	{act = 'cube', node = 'air', loc = vn(25, 30, 25), treasure = 2, size = vn(30, 10, 30)},
	--chamber features
	{act = 'cube', node = 'air', floor = lamp_block, loc = vn(37, 31, 37), treasure = 1, size = vn(6, 1, 6)},

	{act = 'cube', node = special_stone, loc = vn(25, 30, 31), size = vn(6, 1, 18)},
	{act = 'cube', node = special_stone, loc = vn(49, 30, 31), size = vn(6, 1, 18)},
	{act = 'cube', node = special_stone, loc = vn(31, 30, 49), size = vn(18, 1, 6)},

	{act = 'cube', node = special_stone, loc = vn(25, 31, 31), size = vn(3, 1, 18)},
	{act = 'cube', node = special_stone, loc = vn(52, 31, 31), size = vn(3, 1, 18)},
	{act = 'cube', node = special_stone, loc = vn(31, 31, 52), size = vn(18, 1, 3)},


	--chamber corner columns
	{act = 'cube', node = stone_block_4th, loc = vn(25, 30, 25), size = vn(6, 15, 6)},
	{act = 'cube', node = stone_block_4th, loc = vn(25, 30, 49), size = vn(6, 15, 6)},
	{act = 'cube', node = stone_block_4th, loc = vn(49, 30, 25), size = vn(6, 15, 6)},
	{act = 'cube', node = stone_block_4th, loc = vn(49, 30, 49), size = vn(6, 15, 6)},

	--starry promenade
	{act = 'cube', node = 'air', line = stone_block_2nd, floor = stone_block_4th, loc = vn(15, 21, 1), size = vn(50, 6, 5)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(15, 26, 1), size = vn(50, 1, 5)},
	{act = 'cube', node = 'air', line = stone_block_3rd, floor = stone_block_4th, loc = vn(15, 51, 1), size = vn(50, 6, 5)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(15, 56, 1), size = vn(50, 1, 5)},

	{act = 'cube', node = 'air', line = stone_block_2nd, floor = stone_block_4th, loc = vn(1, 21, 15), size = vn(5, 6, 50)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(1, 26, 15), size = vn(5, 1, 50)},
	{act = 'cube', node = 'air', line = stone_block_3rd, floor = stone_block_4th, loc = vn(1, 51, 15), size = vn(5, 6, 50)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(1, 56, 15), size = vn(5, 1, 50)},

	{act = 'cube', node = 'air', line = stone_block_2nd, floor = stone_block_4th, loc = vn(15, 21, 74), size = vn(50, 6, 5)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(15, 26, 74), size = vn(50, 1, 5)},
	{act = 'cube', node = 'air', line = stone_block_3rd, floor = stone_block_4th, loc = vn(15, 51, 74), size = vn(50, 6, 5)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(15, 56, 74), size = vn(50, 1, 5)},

	{act = 'cube', node = 'air', line = stone_block_2nd, floor = stone_block_4th, loc = vn(74, 21, 15), size = vn(5, 6, 50)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(74, 26, 15), size = vn(5, 1, 50)},
	{act = 'cube', node = 'air', line = stone_block_3rd, floor = stone_block_4th, loc = vn(74, 51, 15), size = vn(5, 6, 50)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(74, 56, 15), size = vn(5, 1, 50)},

	--corner rooms
	{act = 'cube', node = 'air', line = stone_brick_2nd, floor = special_stone, treasure = 3, loc = vn(1, 21, 1), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(1, 28, 1), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 2), size = vn(1, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(2, 21, 16), size = vn(3, 3, 1)},
	{act = 'cube', node = lamp_block, loc = vn(8, 21, 8), size = vn(1, 8, 1)},

	{act = 'cube', node = 'air', line = stone_brick_3rd, floor = special_stone, treasure = 3, loc = vn(1, 51, 1), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(1, 58, 1), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(16, 51, 2), size = vn(1, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(2, 51, 16), size = vn(3, 3, 1)},
	{act = 'cube', node = lamp_block, loc = vn(8, 51, 8), size = vn(1, 8, 1)},
	--
	{act = 'cube', node = 'air', line = stone_brick_2nd, floor = special_stone, treasure = 3, loc = vn(1, 21, 64), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(1, 28, 64), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 75), size = vn(1, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(2, 21, 63), size = vn(3, 3, 1)},
	{act = 'cube', node = lamp_block, loc = vn(8, 21, 71), size = vn(1, 8, 1)},

	{act = 'cube', node = 'air', line = stone_brick_3rd, floor = special_stone, treasure = 3, loc = vn(1, 51, 64), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(1, 58, 64), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(16, 51, 75), size = vn(1, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(2, 51, 63), size = vn(3, 3, 1)},
	{act = 'cube', node = lamp_block, loc = vn(8, 51, 71), size = vn(1, 8, 1)},
	--
	{act = 'cube', node = 'air', line = stone_brick_2nd, floor = special_stone, treasure = 3, loc = vn(64, 21, 1), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(64, 28, 1), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 16), size = vn(3, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(63, 21, 2), size = vn(1, 3, 3)},
	{act = 'cube', node = lamp_block, loc = vn(71, 21, 8), size = vn(1, 8, 1)},

	{act = 'cube', node = 'air', line = stone_brick_3rd, floor = special_stone, treasure = 3, loc = vn(64, 51, 1), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(64, 58, 1), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(75, 51, 16), size = vn(3, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(63, 51, 2), size = vn(1, 3, 3)},
	{act = 'cube', node = lamp_block, loc = vn(71, 51, 8), size = vn(1, 8, 1)},
	--
	{act = 'cube', node = 'air', line = stone_block_2nd, floor = special_stone, treasure = 3, loc = vn(64, 21, 64), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(64, 28, 64), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 63), size = vn(3, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(63, 21, 75), size = vn(1, 3, 3)},
	{act = 'cube', node = lamp_block, loc = vn(71, 21, 71), size = vn(1, 8, 1)},

	{act = 'cube', node = 'air', line = stone_block_3rd, floor = special_stone, treasure = 3, loc = vn(64, 51, 64), size = vn(15, 8, 15)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(64, 58, 64), size = vn(15, 1, 15)},
	{act = 'cube', node = 'air', loc = vn(75, 51, 63), size = vn(3, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(63, 51, 75), size = vn(1, 3, 3)},
	{act = 'cube', node = lamp_block, loc = vn(71, 51, 71), size = vn(1, 8, 1)},

	--upper gallery
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(39, 53, 16), size = vn(16, 6, 48)},
	{act = 'cube', node = 'air', floor = stone_block_4th, treasure = 2, loc = vn(39, 51, 16), size = vn(16, 5, 48)},
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(46, 51, 6), size = vn(2, 3, 68)},
	--lower gallery
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(51, 23, 18), size = vn(14, 6, 44)},
	{act = 'cube', node = 'air', floor = stone_block_4th, treasure = 2, loc = vn(51, 21, 18), size = vn(14, 4, 44)},
	{act = 'cube', node = 'air', floor = stone_block_3rd, loc = vn(57, 21, 6), size = vn(2, 3, 68)},
	--lower stair link
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(50, 20, 50), size = vn(1, 1, 2)},

	--lobby
	{act = 'stair', node = stone_stairs_block_4th, height = 4, depth = 2, param2 = 0, loc = vn(38, 21, 6), size = vn(4, 9, 9)},
	{act = 'cube', node = 'air', floor = stone_block_4th, loc = vn(36, 30, 15), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(37, 34, 15), size = vn(6, 1, 10)},
	{act = 'cube', node = "artifacts:star_stone", param2 = 0, random = 5, loc = vn(37, 34, 15), size = vn(6, 1, 10)},

	--linker stair
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 2, param2 = 0, loc = vn(20, 21, 16), size = vn(2, 30, 30)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(20, 21, 6), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(20, 51, 46), size = vn(2, 3, 28)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(22, 51, 56), size = vn(4, 3, 4)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(22, 51, 66), size = vn(4, 3, 4)},





	--exits plus (need to be a little longer than default)
	{act = 'cube', node = n_ex, loc = vn(0, 21, 19), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 21, 39), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 21, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(78, 21, 19), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(78, 21, 39), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(78, 21, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(19, 21, 0), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(39, 21, 0), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(59, 21, 0), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(19, 21, 78), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(39, 21, 78), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(59, 21, 78), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 51, 39), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(78, 51, 39), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(39, 51, 0), size = vn(2, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(39, 51, 78), size = vn(2, 3, 2)},


}


for _, item in pairs(lower_stair) do
	table.insert(forum, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(forum, 2, table.copy(item))
end

if seal_underground then
	table.insert(forum, 1, table.copy(seal_box))
end

-----------------------------------------------------
-----------------------------------------------------
--lake_of_fire

local lake_of_fire = {
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(1, 21, 1), size = vn(78, 5, 78)},
	{act = 'cube', node = stone_2nd, loc = vn(9, 21, 9), size = vn(62, 1, 62)},
	{act = 'cube', node = stone_2nd, loc = vn(9, 23, 9), size = vn(62, 5, 62)},
	{act = 'cube', node = 'air', loc = vn(10, 11, 10), size = vn(60, 25, 60)},
	{act = 'cube', node = lava, loc = vn(10, 11, 10), size = vn(60, 5, 60)},
	{act = 'cube', node = stone_2nd, loc = vn(25, 11, 25), size = vn(30, 9, 30)},
	{act = 'cube', node = stone_block_2nd, loc = vn(25, 20, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = stone_2nd, loc = vn(39, 20, 55), size = vn(2, 1, 15)},
	{act = 'cube', node = stone_2nd, loc = vn(39, 20, 10), size = vn(2, 1, 15)},
	{act = 'cube', node = stone_2nd, loc = vn(10, 20, 39), size = vn(15, 1, 2)},
	{act = 'cube', node = stone_2nd, loc = vn(55, 20, 39), size = vn(15, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(70, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 70), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 9), size = vn(2, 3, 1)},
	{act = 'cube', node = stone_2nd, loc = vn(37, 20, 37), size = vn(6, 2, 6)},
	{act = 'cube', node = lava, loc = vn(38, 20, 38), size = vn(4, 2, 4)},
}

for _, item in pairs(default_exits) do
	table.insert(lake_of_fire, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(lake_of_fire, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(lake_of_fire, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(lake_of_fire, 2, table.copy(item))
end

if seal_underground then
	table.insert(lake_of_fire, 1, table.copy(seal_box))
end


-----------------------------------------------------
--lake_of_fire_solid

local lake_of_fire_solid = {
	{act = 'cube', node = 'air', floor = stone_block_2nd, loc = vn(1, 21, 1), size = vn(78, 5, 78)},
	{act = 'cube', node = stone_2nd, loc = vn(9, 21, 9), size = vn(62, 1, 62)},
	{act = 'cube', node = stone_2nd, loc = vn(9, 23, 9), size = vn(62, 5, 62)},
	{act = 'cube', node = 'air', loc = vn(10, 11, 10), size = vn(60, 25, 60)},
	{act = 'cube', node = stone_2nd, loc = vn(10, 11, 10), size = vn(60, 8, 60)},
	{act = 'cube', node = stone_2nd, loc = vn(25, 11, 25), size = vn(30, 9, 30)},
	{act = 'cube', node = stone_block_2nd, loc = vn(25, 20, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = stone_2nd, loc = vn(39, 20, 55), size = vn(2, 1, 15)},
	{act = 'cube', node = stone_2nd, loc = vn(39, 20, 10), size = vn(2, 1, 15)},
	{act = 'cube', node = stone_2nd, loc = vn(10, 20, 39), size = vn(15, 1, 2)},
	{act = 'cube', node = stone_2nd, loc = vn(55, 20, 39), size = vn(15, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(70, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 70), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 9), size = vn(2, 3, 1)},
	{act = 'cube', node = stone_2nd, loc = vn(37, 20, 37), size = vn(6, 2, 6)},
	{act = 'cube', node = stone_2nd, loc = vn(38, 20, 38), size = vn(4, 2, 4)},
}

for _, item in pairs(default_exits) do
	table.insert(lake_of_fire_solid, 2, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(lake_of_fire_solid, 2, table.copy(item))
end

for _, item in pairs(upper_stair) do
	table.insert(lake_of_fire_solid, 2, table.copy(item))
end

for _, item in pairs(lower_stair_room) do
	table.insert(lake_of_fire_solid, 2, table.copy(item))
end

if seal_underground then
	table.insert(lake_of_fire_solid, 1, table.copy(seal_box))
end



-----------------------------------------------------
--warehouse
--large stockpiles, big prize for making it down deep

local warehouse = {
	--lower foyer
	{act = 'sphere', node = 'air', loc = vn(35, 23, 29), size = vn(20, 5, 20)},
	{act = 'cube', node = 'air', treasure = 2, floor = stone_block_main, loc = vn(35, 21, 29), size = vn(20, 5, 20)},

	--lower stair linkers
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(29, 21, 39), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(50, 20, 50), size = vn(2, 4, 2)},
	{act = 'stair', node = stone_stairs_block_main, height = 4, depth = 2, param2 = 2, loc = vn(50, 20, 49), size = vn(2, 1, 1)},

	--upper foyer
	{act = 'sphere', node = 'air', loc = vn(39, 53, 21), size = vn(20, 5, 20)},
	{act = 'cube', node = 'air', treasure = 2, floor = stone_block_main, loc = vn(39, 51, 21), size = vn(20, 5, 20)},


	-- promenade
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(15, 21, 1), size = vn(50, 5, 5)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(15, 51, 1), size = vn(50, 5, 5)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(1, 21, 15), size = vn(5, 5, 50)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(1, 51, 15), size = vn(5, 5, 50)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(15, 21, 74), size = vn(50, 5, 5)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(15, 51, 74), size = vn(50, 5, 5)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(74, 21, 15), size = vn(5, 5, 50)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(74, 51, 15), size = vn(5, 5, 50)},

	--corner rooms
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(1, 21, 1), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(1, 51, 1), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(1, 21, 64), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(1, 51, 64), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(64, 21, 1), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air',floor = stone_block_main, treasure = 3, loc = vn(64, 51, 1), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(64, 21, 64), size = vn(15, 6, 15)},
	{act = 'cube', node = 'air', floor = stone_block_main, treasure = 3, loc = vn(64, 51, 64), size = vn(15, 6, 15)},

	{act = 'sphere', node = 'air', loc = vn(1, 23, 1), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(1, 53, 1), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(1, 23, 64), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(1, 53, 64), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(64, 23, 1), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(64, 53, 1), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(64, 23, 64), size = vn(15, 5, 15)},
	{act = 'sphere', node = 'air', loc = vn(64, 53, 64), size = vn(15, 5, 15)},

	--lower store linkers
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(6, 21, 29), size = vn(68, 5, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(6, 21, 47), size = vn(68, 5, 2)},

	--lower workshop
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(15, 21, 32), size = vn(14, 5, 14)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(19, 21, 46), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(19, 21, 31), size = vn(2, 3, 1)},

	--upper cross
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', floor = stone_block_main,  loc = vn(39, 51, 0), size = vn(2, 3, 80)},

	--upper workshop
	{act = 'cube', node = 'air', treasure = 3, floor = stone_block_main, loc = vn(15, 51, 42), size = vn(23, 5, 14)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(24, 51, 41), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', floor = stone_block_main, loc = vn(38, 51, 51), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', treasure = 2, floor = stone_block_main, loc = vn(15, 52, 42), size = vn(1, 1, 14)},

}


--store corridors
for _, x in pairs({19, 29, 39, 49, 59}) do
	--corrdors
	table.insert(warehouse, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, 21, 6), size = vn(2, 5, 23)})
	--stores
	for _, z in pairs({7,9,11,13,15,17,19,21, 23, 25, 27}) do
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x-1, 22, z), size = vn(1, 1, 1)})
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x+2, 22, z), size = vn(1, 1, 1)})
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x-1, 24, z), size = vn(1, 1, 1)})
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x+2, 24, z), size = vn(1, 1, 1)})
	end
end

--store corridors
for _, x in pairs({19, 29, 39, 59}) do
	--corrdors
	table.insert(warehouse, {act = 'cube', floor = stone_block_main, node = 'air', loc = vn(x, 21, 49), size = vn(2, 5, 25)})
	--stores
	for _, z in pairs({72,70,68,66,64,62,60,58, 56, 54, 52, 50}) do
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x-1, 22, z), size = vn(1, 1, 1)})
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x+2, 22, z), size = vn(1, 1, 1)})
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x-1, 24, z), size = vn(1, 1, 1)})
		table.insert(warehouse, {act = 'cube', treasure = 2, floor = stone_block_main, node = 'air', loc = vn(x+2, 24, z), size = vn(1, 1, 1)})
	end
end

--upper workshop stores
for _, x in pairs({16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}) do
	--stores
	for _, y in pairs({52, 54}) do
		table.insert(warehouse, {act = 'cube', node = 'air', treasure = 2, floor = stone_block_main, loc = vn(x, y, 56), size = vn(1, 1, 1)})
	end
end

for _, item in pairs(default_exits) do
	table.insert(warehouse, 2, table.copy(item))
end


for _, item in pairs(upper_stair) do
	table.insert(warehouse, 2, table.copy(item))
end

for _, item in pairs(lower_stair) do
	table.insert(warehouse, 2, table.copy(item))
end

for _, item in pairs(central_stairwell) do
	table.insert(warehouse, 2, table.copy(item))
end

if seal_underground then
	table.insert(warehouse, 1, table.copy(seal_box))
end


-----------------------------------------------------
-----------------------------------------------------
--deep_stair

local deep_stair = {
	--stairs and landing rooms
	{act = 'cube', node = 'air', treasure = 3, loc = vn(22, 0, 50), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 1, loc = vn(30, 0, 50), size = vn(20, 20, 1)},
	{act = 'cube', node = 'air', loc = vn(50, 20, 50), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 2, loc = vn(50, 20, 30), size = vn(1, 20, 20)},
	{act = 'cube', node = 'air', loc = vn(50, 40, 27), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 3, loc = vn(30, 40, 27), size = vn(20, 20, 1)},
	{act = 'cube', node = 'air', loc = vn(22, 60, 22), size = vn(8, 4, 8)},
	{act = 'stair', node = stone_stairs_main, height = 4, depth = 2, param2 = 0, loc = vn(27, 60, 30), size = vn(1, 21, 20)},

}

if seal_underground then
	table.insert(deep_stair, 1, table.copy(seal_box))
end


-----------------------------------------------------
--CITY SECTORS
-----------------------------------------------------
-----------------------------------------------------
--Tower base
--displaces natural stuff from bottom of the tower
-----------------------------------------------------
register_geomorph({
	name = 'tower_base_a',
	areas = 'tower_base',
	data = tower_base_a,
})

-----------------------------------------------------
--shafts
--surface access, if you have a rope
-----------------------------------------------------
for _, n in pairs({"ns", "ew"}) do

	register_geomorph({
		name = n..'_air_shaft',
		areas = n..'_air_shaft',
		data = air_shaft,
	})

	register_geomorph({
		name = n..'_air_shaft_thin',
		areas = n..'_air_shaft',
		data = air_shaft_thin,
	})


end

-----------------------------------------------------
--highways
--provide rapid transport routes, the city's main arteries
--this how you get down without getting lost in the maze,
--but it limits you to these locations
-----------------------------------------------------

for _, n in pairs({"ns", "ew", "n", "s", "e", "w"}) do

--[[
--unlinked result in a lot of dead end corridors
	register_geomorph({
		name = n..'_highway',
		areas = n..'_highway',
		data = highway,
	})

	register_geomorph({
		name = n..'_highway_no_shaft',
		areas = n..'_highway',
		data = highway_no_shaft,
	})

	]]

	register_geomorph({
		name = n..'_highway_linked',
		areas = n..'_highway',
		data = highway_linked,
	})

	register_geomorph({
		name = n..'_highway_no_shaft_linked',
		areas = n..'_highway',
		data = highway_no_shaft_linked,
	})

end

-----------------------------------------------------
--moria_ag
--farming
-----------------------------------------------------
for _, n in pairs({"nw", "ne", "sw", "se"}) do

	register_geomorph({
		name = n..'_crossroads_ag',
		areas = n..'_moria_ag',
		data = crossroads,
	})

	register_geomorph({
		name = n..'_reservoir',
		areas = n..'_moria_ag',
		data = reservoir,
	})

	register_geomorph({
		name = n..'_reservoir_empty',
		areas = n..'_moria_ag',
		data = reservoir_empty,
	})

	register_geomorph({
		name = n..'_mushroom_garden',
		areas = n..'_moria_ag',
		data = mushroom_garden,
	})

	register_geomorph({
		name = n..'_barren_mushroom_garden',
		areas = n..'_moria_ag',
		data = barren_mushroom_garden,
	})

	register_geomorph({
		name = n..'_stockyards',
		areas = n..'_moria_ag',
		data = stockyards,
	})

	register_geomorph({
		name = n..'_granary',
		areas = n..'_moria_ag',
		data = granary,
	})

	register_geomorph({
		name = n..'_kitchen',
		areas = n..'_moria_ag',
		data = kitchen,
	})


end


-----------------------------------------------------
--moria_res
--housing
-----------------------------------------------------
for _, n in pairs({"nw", "ne", "sw", "se"}) do

	register_geomorph({
		name = n..'_crossroads_res',
		areas = n..'_moria_res',
		data = crossroads,
	})

	register_geomorph({
		name = n..'_prison',
		areas = n..'_moria_res',
		data = prison,
	})

	register_geomorph({
		name = n..'_stair_base',
		areas = n..'_moria_res',
		data = stair_base,
	})

	register_geomorph({
		name = n..'_great_hall',
		areas = n..'_moria_res',
		data = great_hall,
	})

	register_geomorph({
		name = n..'_kitchen_res',
		areas = n..'_moria_res',
		data = kitchen,
	})

	register_geomorph({
		name = n..'_apartments',
		areas = n..'_moria_res',
		data = apartments,
	})

	register_geomorph({
		name = n..'_grand_apartments',
		areas = n..'_moria_res',
		data = grand_apartments,
	})

end


-----------------------------------------------------
--moria_mar
--markets
-----------------------------------------------------
for _, n in pairs({"nw", "ne", "sw", "se"}) do

	register_geomorph({
		name = n..'_crossroads_mar',
		areas = n..'_moria_mar',
		data = crossroads,
	})

	register_geomorph({
		name = n..'_market',
		areas = n..'_moria_mar',
		data = market,
	})

	register_geomorph({
		name = n..'_great_hall_mar',
		areas = n..'_moria_mar',
		data = great_hall,
	})

	register_geomorph({
		name = n..'_grand_bazaar',
		areas = n..'_moria_mar',
		data = grand_bazaar,
	})

	register_geomorph({
		name = n..'_plaza',
		areas = n..'_moria_mar',
		data = plaza,
	})

	register_geomorph({
		name = n..'_arena',
		areas = n..'_moria_mar',
		data = arena,
	})

end



-----------------------------------------------------
--moria_civ
--civic
-----------------------------------------------------
for _, n in pairs({"nw", "ne", "sw", "se"}) do

	register_geomorph({
		name = n..'_crossroads_civ',
		areas = n..'_moria_civ',
		data = crossroads,
	})

	register_geomorph({
		name = n..'_silly_straw',
		areas = n..'_moria_civ',
		data = silly_straw,
	})

	register_geomorph({
		name = n..'_pillared_room',
		areas = n..'_moria_civ',
		data = pillared_room,
	})

	register_geomorph({
		name = n..'_pillared_room_antiq',
		areas = n..'_moria_civ',
		data = pillared_room_antiq,
	})

	register_geomorph({
		name = n..'_pillared_room_moon',
		areas = n..'_moria_civ',
		data = pillared_room_moon,
	})

	register_geomorph({
		name = n..'_jade_temple',
		areas = n..'_moria_civ',
		data = jade_temple,
	})

	register_geomorph({
		name = n..'_fountain_court',
		areas = n..'_moria_civ',
		data = fountain_court,
	})

	register_geomorph({
		name = n..'_sphere_of_light',
		areas = n..'_moria_civ',
		data = sphere_of_light,
	})

	register_geomorph({
		name = n..'_sphere_of_darkness',
		areas = n..'_moria_civ',
		data = sphere_of_darkness,
	})

	register_geomorph({
		name = n..'_great_hall_civ',
		areas = n..'_moria_civ',
		data = great_hall,
	})

	register_geomorph({
		name = n..'_forum_civ',
		areas = n..'_moria_civ',
		data = forum,
	})

end




-----------------------------------------------------
--moria_ind
--industrial
-----------------------------------------------------
for _, n in pairs({"nw", "ne", "sw", "se"}) do

	register_geomorph({
		name = n..'_crossroads_ind',
		areas = n..'_moria_ind',
		data = crossroads,
	})

	register_geomorph({
		name = n..'_lake_of_fire',
		areas = n..'_moria_ind',
		data = lake_of_fire,
	})

	register_geomorph({
		name = n..'_lake_of_fire_solid',
		areas = n..'_moria_ind',
		data = lake_of_fire_solid,
	})

	register_geomorph({
		name = n..'_warehouse',
		areas = n..'_moria_ind',
		data = warehouse,
	})

end


-----------------------------------------------------
--moria_mine
--mines
-----------------------------------------------------
for _, n in pairs({"nw", "ne", "sw", "se"}) do

	register_geomorph({
		name = n..'_crossroads_mine',
		areas = n..'_moria_mine',
		data = crossroads,
	})


	register_geomorph({
		name = n..'_deep_stair',
		areas = n..'_moria_mine',
		data = deep_stair,
	})

end
