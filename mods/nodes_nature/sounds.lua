
--
-- Sounds
--
function nodes_nature.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "nodes_nature_place_node_hard", gain = 1.0}
	return table
end


function nodes_nature.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_hard_footstep", gain = 0.3}
	table.dig = table.dig or
			{name = "nodes_nature_dig_cracky", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_hard_footstep", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end

function nodes_nature.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_dirt_footstep", gain = 0.4}
	table.dig = table.dig or
			{name = "nodes_nature_dig_crumbly", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_dirt_footstep", gain = 1.0}
	table.place = table.place or
			{name = "nodes_nature_place_node", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end

function nodes_nature.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_sand_footstep", gain = 0.12}
	table.dig = table.dig or
			{name = "nodes_nature_dig_crumbly", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_sand_footstep", gain = 0.24}
	table.place = table.place or
			{name = "nodes_nature_place_node", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end

function nodes_nature.node_sound_gravel_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_gravel_footstep", gain = 0.4}
	table.dig = table.dig or
			{name = "nodes_nature_dig_crumbly", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_gravel_footstep", gain = 1.0}
	table.place = table.place or
			{name = "nodes_nature_place_node", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end



function nodes_nature.node_sound_water_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_water_footstep", gain = 0.2}
	nodes_nature.node_sound_defaults(table)
	return table
end


function nodes_nature.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_grass_footstep", gain = 0.45}
	table.dig = table.dig or
			{name = "nodes_nature_dig_snappy", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_grass_footstep", gain = 0.7}
	table.place = table.place or
			{name = "nodes_nature_place_node", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end


function nodes_nature.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_wood_footstep", gain = 0.3}
	table.dig = table.dig or
			{name = "nodes_nature_dig_choppy", gain = 1.0}
	table.dug = table.dug or
			{name = "nodes_nature_wood_footstep", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end



function nodes_nature.node_sound_snow_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_snow_footstep", gain = 0.2}
	table.dig = table.dig or
			{name = "nodes_nature_snow_footstep", gain = 0.3}
	table.dug = table.dug or
			{name = "nodes_nature_snow_footstep", gain = 0.3}
	table.place = table.place or
			{name = "nodes_nature_place_node", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end


function nodes_nature.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "nodes_nature_glass_footstep", gain = 0.3}
	table.dig = table.dig or
			{name = "nodes_nature_glass_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "nodes_nature_break_glass", gain = 1.0}
	nodes_nature.node_sound_defaults(table)
	return table
end



--[[


function default.node_sound_metal_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_metal_footstep", gain = 0.4}
	table.dig = table.dig or
			{name = "default_dig_metal", gain = 0.5}
	table.dug = table.dug or
			{name = "default_dug_metal", gain = 0.5}
	table.place = table.place or
			{name = "default_place_node_metal", gain = 0.5}
	default.node_sound_defaults(table)
	return table
end
]]
