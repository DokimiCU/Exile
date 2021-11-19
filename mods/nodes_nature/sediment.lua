---------------------------------------------------------
--SEDIMENT
--
----------------------------------------------------------

--recipes
--loam
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:loam 3",
	items = {"nodes_nature:clay 1","nodes_nature:silt 1","nodes_nature:sand 1"},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:loam_wet 3",
	items = {"nodes_nature:clay_wet 1","nodes_nature:silt_wet 1","nodes_nature:sand_wet 1"},
	level = 1,
	always_known = true,
})


--Ag soils from raw and fertilizer
--otherwise have to wait for natural regeneration
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:loam_agricultural_soil",
	items = {"nodes_nature:loam 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:loam_agricultural_soil_wet",
	items = {"nodes_nature:loam_wet 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay_agricultural_soil",
	items = {"nodes_nature:clay 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay_agricultural_soil_wet",
	items = {"nodes_nature:clay_wet 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:silt_agricultural_soil",
	items = {"nodes_nature:silt 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:silt_agricultural_soil_wet",
	items = {"nodes_nature:silt_wet 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:sand_agricultural_soil",
	items = {"nodes_nature:sand 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:sand_agricultural_soil_wet",
	items = {"nodes_nature:sand_wet 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:gravel_agricultural_soil",
	items = {"nodes_nature:gravel 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})
crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:gravel_agricultural_soil_wet",
	items = {"nodes_nature:gravel_wet 1","group:fertilizer 1"},
	level = 1,
	always_known = true,
})

-------------------------------------------------
--set groups and sounds by basic sediment type
local function property_by_type(type, hardness, special)
	local s, sw, g, g2, g3

	--core sounds
	local s_dirt = nodes_nature.node_sound_dirt_defaults()
	local s_dirt_w = nodes_nature.node_sound_dirt_defaults({
		footstep = {name = "nodes_nature_mud", gain = 0.4},
		dug = {name = "nodes_nature_mud", gain = 0.4}})

	local s_sand = nodes_nature.node_sound_sand_defaults()
	local s_sand_w = nodes_nature.node_sound_sand_defaults({
		footstep = {name = "nodes_nature_mud", gain = 0.4},
		dug = {name = "nodes_nature_mud", gain = 0.4}})

	local s_gravel = nodes_nature.node_sound_gravel_defaults()
	local s_gravel_w = nodes_nature.node_sound_gravel_defaults({
		footstep = {name = "nodes_nature_mud", gain = 0.4},
		dug = {name = "nodes_nature_mud", gain = 0.4}})

	--Specials
	if special == "spreading" then
		--by type
		if type == "loam" then
			s = s_dirt
			sw = s_dirt_w
			g = {falling_node = 1, crumbly = hardness, sediment = 1, spreading = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 1, spreading = 1}
			return s, sw, g, g2

		elseif type == "clay" then
			s = s_dirt
			sw = s_dirt_w
			g = {falling_node = 1, crumbly = hardness, sediment = 2, spreading = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 2, spreading = 1}
			return s, sw, g, g2

		elseif type == "silt" then
			s = s_dirt
			sw = s_dirt_w
			g = {falling_node = 1, crumbly = hardness, sediment = 3, spreading = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 3, spreading = 1}
			return s, sw, g, g2

		elseif type == "sand" then
			s = s_sand
			sw = s_sand_w
			g = {falling_node = 1, crumbly = hardness, sediment = 4, spreading = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 4, spreading = 1}
			return s, sw, g, g2

		elseif type == "gravel" then
			s = s_gravel
			sw = s_gravel_w
			g = {falling_node = 1, crumbly = hardness, sediment = 5, spreading = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 5, spreading = 1}
			return s, sw, g, g2
		end
	elseif special == "agricultural" then
		local g4
		if type == "loam" then
			s = s_dirt
			sw = s_dirt_w
			g = {falling_node = 1, crumbly = hardness, sediment = 1, agricultural_soil = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 1, agricultural_soil = 1}
			g3 = {falling_node = 1, crumbly = hardness, sediment = 1, depleted_agricultural_soil = 1}
			g4 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 1, depleted_agricultural_soil = 1}
			return s, sw, g, g2, g3, g4

		elseif type == "clay" then
			s = s_dirt
			sw = s_dirt_w
			g = {falling_node = 1, crumbly = hardness, sediment = 2, agricultural_soil = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 2, agricultural_soil = 1}
			g3 = {falling_node = 1, crumbly = hardness, sediment = 2, depleted_agricultural_soil = 1}
			g4 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 2, depleted_agricultural_soil = 1}
			return s, sw, g, g2, g3, g4

		elseif type == "silt" then
			s = s_dirt
			sw = s_dirt_w
			g = {falling_node = 1, crumbly = hardness, sediment = 3, agricultural_soil = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 3, agricultural_soil = 1}
			g3 = {falling_node = 1, crumbly = hardness, sediment = 3, depleted_agricultural_soil = 1}
			g4 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 3, depleted_agricultural_soil = 1}
			return s, sw, g, g2, g3, g4

		elseif type == "sand" then
			s = s_sand
			sw = s_sand_w
			g = {falling_node = 1, crumbly = hardness, sediment = 4, agricultural_soil = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 4, agricultural_soil = 1}
			g3 = {falling_node = 1, crumbly = hardness, sediment = 4, depleted_agricultural_soil = 1}
			g4 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 4, depleted_agricultural_soil = 1}
			return s, sw, g, g2, g3, g4

		elseif type == "gravel" then
			s = s_gravel
			sw = s_gravel_w
			g = {falling_node = 1, crumbly = hardness, sediment = 5, agricultural_soil = 1}
			g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 5, agricultural_soil = 1}
			g3 = {falling_node = 1, crumbly = hardness, sediment = 5, depleted_agricultural_soil = 1}
			g4 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 5, depleted_agricultural_soil = 1}
			return s, sw, g, g2, g3, g4
		end

	end

	--Not special
	--by type
	if type == "loam" then
		s = s_dirt
		sw = s_dirt_w
		g = {falling_node = 1, crumbly = hardness, sediment = 1}
		g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 1}
		g3 = {falling_node = 1, crumbly = hardness, wet_sediment = 2, puts_out_fire = 1, sediment = 1}
		return s, sw, g, g2, g3

	elseif type == "clay" then
		s = s_dirt
		sw = s_dirt_w
		g = {falling_node = 1, crumbly = hardness, sediment = 2}
		g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 2}
		g3 = {falling_node = 1, crumbly = hardness, wet_sediment = 2, puts_out_fire = 1, sediment = 2}
		return s, sw, g, g2, g3

	elseif type == "silt" then
		s = s_dirt
		sw = s_dirt_w
		g = {falling_node = 1, crumbly = hardness, sediment = 3}
		g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 3}
		g3 = {falling_node = 1, crumbly = hardness, wet_sediment = 2, puts_out_fire = 1, sediment = 3}
		return s, sw, g, g2, g3

	elseif type == "sand" then
		s = s_sand
		sw = s_sand_w
		g = {falling_node = 1, crumbly = hardness, sediment = 4}
		g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 4}
		g3 = {falling_node = 1, crumbly = hardness, wet_sediment = 2, puts_out_fire = 1, sediment = 4}
		return s, sw, g, g2, g3

	elseif type == "gravel" then
		s = s_gravel
		sw = s_gravel_w
		g = {falling_node = 1, crumbly = hardness, sediment = 5}
		g2 = {falling_node = 1, crumbly = hardness, wet_sediment = 1, puts_out_fire = 1, sediment = 5}
		g3 = {falling_node = 1, crumbly = hardness, wet_sediment = 2, puts_out_fire = 1, sediment = 5}
		return s, sw, g, g2, g3
	end
end




---------------------------------------------------------
--SEDIMENT
--all are falling
--can make stairs
--has  wet versions for salt and fresh



local doslopes = minetest.settings:get_bool('exile_enableslopes')
local slopechance = minetest.settings:get('exile_slopechance') or 20

for i in ipairs(sed_list) do
	local name = sed_list[i][1]
	local desc = sed_list[i][2]
	local hardness = sed_list[i][3]
	local type = sed_list[i][4]

 	local s, sw, g, g2, g3 = property_by_type(type, hardness)


	--register raw
	minetest.register_node("nodes_nature:"..name, {
		description = desc,
		tiles = {"nodes_nature_"..name..".png"},
		stack_max = minimal.stack_max_bulky,
		groups = g,
		drop = "nodes_nature:"..name,
		sounds = s,
		_wet_name = "nodes_nature:"..name.."_wet",
		_wet_salty_name = "nodes_nature:"..name.."_wet_salty",
	})


	--register wet
	minetest.register_node("nodes_nature:"..name.."_wet", {
		description = "Wet "..desc,
		tiles = {"nodes_nature_"..name..".png^nodes_nature_mud.png"},
		stack_max = minimal.stack_max_bulky,
		groups = g2,
		drop = "nodes_nature:"..name.."_wet",
		sounds = sw,
		_dry_name = "nodes_nature:"..name,
	})

	minetest.register_node("nodes_nature:"..name.."_wet_salty", {
		description = "Salty Wet "..desc,
		tiles = {"nodes_nature_"..name..".png^nodes_nature_mud.png^nodes_nature_mud_salt.png"},
		stack_max = minimal.stack_max_bulky,
		groups = g3,
		drop = "nodes_nature:"..name.."_wet_salty",
		sounds = sw,
		_dry_name = "nodes_nature:"..name,
	})


	--stairs and slabs
	--raw
	stairs.register_stair_and_slab(
		name,
		"nodes_nature:"..name,
		"mixing_spot",
		"true",
		{falling_node = 1, crumbly = hardness},
		{"nodes_nature_"..name..".png" },
		desc.." Stair",
		desc.." Slab",
		minimal.stack_max_bulky *2,
		s
	)

	if doslopes then
	   naturalslopeslib.register_slope("nodes_nature:"..name, {}, slopechance)
	   naturalslopeslib.register_slope("nodes_nature:"..name.."_wet", {}, slopechance)
	   naturalslopeslib.register_slope("nodes_nature:"..name.."_wet_salty", {}, slopechance)
	end
end


---------------------------------------------------------
--SURFACE SEDIMENT
--i.e. having surface textures
--all are falling


for i in ipairs(soil_list) do
	local name = soil_list[i][1]
	local desc = soil_list[i][2]
	local hardness = soil_list[i][3]
	local dropped = soil_list[i][4]
	local type = soil_list[i][5]

	local s, sw, g, g2 = property_by_type(type, hardness, "spreading")

	--register raw
	minetest.register_node("nodes_nature:"..name, {
		description = desc,
		tiles = {"nodes_nature_"..name..".png", "nodes_nature_"..dropped..".png",
		{name = "nodes_nature_"..dropped..".png^nodes_nature_"..name.."_side.png"}},
		stack_max = minimal.stack_max_bulky,
		groups = g,
		drop = "nodes_nature:"..dropped,
		sounds = s,
		_wet_name = "nodes_nature:"..name.."_wet",
		_wet_salty_name = "nodes_nature:"..dropped.."_wet_salty",
		_ag_soil = "nodes_nature:"..dropped.."_agricultural_soil",
	})


	--register wet
	minetest.register_node("nodes_nature:"..name.."_wet", {
		description = "Wet "..desc,
		tiles = {"nodes_nature_"..name..".png^nodes_nature_mud.png",
		{name = "nodes_nature_"..dropped..".png^nodes_nature_"..name.."_side.png^nodes_nature_mud.png"}},
		stack_max = minimal.stack_max_bulky,
		groups = g2,
		drop = "nodes_nature:"..dropped.."_wet",
		sounds = sw,
		_dry_name = "nodes_nature:"..name,
		_ag_soil = "nodes_nature:"..dropped.."_agricultural_soil_wet",
	})
	if doslopes then
	   naturalslopeslib.register_slope("nodes_nature:"..name, {}, slopechance)
	   naturalslopeslib.register_slope("nodes_nature:"..name.."_wet", {}, slopechance)
	end

	--no salty as salty kills the surface life
	--wet salty is just the raw sediment version.


end


---------------------------------------------------------
--AGRICULTURAL SOILS
--for growing seed faster
-- two types per sediment: normal, depleted

--soil degrades from farming
local function erode_deplete_ag_soil(pos, depleted_name)
	local c = math.random()
	--rain makes this more likely (erosive, washes nutrient out)
	local adjust = 1
	if climate.get_rain(pos) then
	   adjust = 2
	end

	if c < (0.05 * adjust) then -- 90-95% chance nothing happens
	   return true 
	end
	--4-8% chance of rain/water erosion
	if c > (0.01 * adjust) then
		--erode if exposed, and near water or raining
		local positions = minetest.find_nodes_in_area(
			{x = pos.x - 1, y = pos.y, z = pos.z - 1},
			{x = pos.x + 1, y = pos.y, z = pos.z + 1},
			{"group:water", "air"})

		if #positions >= 1 then
			local name = minetest.get_node(pos).name
			local new = name:gsub("%_depleted","")
			new = new:gsub("%_agricultural_soil","")
			--would prefer stairs:slab, but sand/etc lacks wet
			new = new:gsub("%nature:","%nature:slope_pike_")
			minetest.set_node(pos, {name = new})
			return false
		end

	elseif minetest.get_node({x=pos.x, y=(pos.y+1), z=pos.z}) == 'air' then
	        -- ^ don't deplete a planted node; already handled in life.lua
		-- and a 1-2% chance to be depleted via neglect
		minetest.set_node(pos, {name = depleted_name})
		return false
	end
end

--For using fertilizer on punch
local function fertilize_ag_soil(pos, puncher, restored_name)
	--hit it with fertilizer to restore
	local itemstack = puncher:get_wielded_item()
	local ist_name = itemstack:get_name()

	if minetest.get_item_group(ist_name, "fertilizer") >= 1 then
		minetest.set_node(pos, {name = restored_name})
		local inv = puncher:get_inventory()
		inv:remove_item("main", ist_name)
	end
end





for i in ipairs(agri_soil_list) do
	local name = agri_soil_list[i][1]
	local desc = agri_soil_list[i][2]
	local hardness = agri_soil_list[i][3]
	local source = agri_soil_list[i][4]		--derived from this type of sediment
	local type = agri_soil_list[i][5]


	local s, sw, g, g2, g3, g4 = property_by_type(type, hardness, "agricultural")


	--register agricultural soil
	minetest.register_node("nodes_nature:"..name, {
		description = desc,
		tiles = {
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_top.png"},
			"nodes_nature_"..type..".png",
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_side.png"}},
		stack_max = minimal.stack_max_bulky,
		groups = g,
		sounds = s,
		drop = source,
		_wet_name = "nodes_nature:"..name.."_wet",
		_wet_salty_name = "nodes_nature:"..type.."_wet_salty",
		on_construct = function(pos)
			--speed of erosion, degrade to depleted
			minetest.get_node_timer(pos):start(math.random(90, 300))
		end,
		on_timer = function(pos,elapsed)
			return erode_deplete_ag_soil(pos, "nodes_nature:"..name.."_depleted")
		end,
	})

	--register wet agricultural soil
	minetest.register_node("nodes_nature:"..name.."_wet", {
		description = "Wet "..desc,
		tiles = {
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_top.png^nodes_nature_mud.png"},
			"nodes_nature_"..type..".png^nodes_nature_mud.png",
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_side.png^nodes_nature_mud.png"}},
		stack_max = minimal.stack_max_bulky,
		groups = g2,
		sounds = sw,
		drop = source.."_wet",
		_dry_name = "nodes_nature:"..name,
		on_construct = function(pos)
			--speed of erosion, degrade to depleted
			minetest.get_node_timer(pos):start(math.random(60, 300))
		end,
		on_timer = function(pos,elapsed)
			return erode_deplete_ag_soil(pos, "nodes_nature:"..name.."_wet_depleted")
		end,
	})



	--register depleted soil
	minetest.register_node("nodes_nature:"..name.."_depleted", {
		description = "Depleted "..desc,
		tiles = {
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_dep_top.png"},
			"nodes_nature_"..type..".png",
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_dep_side.png"}},
		stack_max = minimal.stack_max_bulky,
		groups = g3,
		sounds = s,
		drop = source,
		_wet_name = "nodes_nature:"..name.."_wet_depleted",
		_wet_salty_name = "nodes_nature:"..type.."_wet_salty",
		on_punch = function(pos, node, puncher, pointed_thing)
			fertilize_ag_soil(pos, puncher, "nodes_nature:"..name)
		end,
		on_construct = function(pos)
			--speed of erosion, reversion to natural/depleted
			minetest.get_node_timer(pos):start(math.random(60, 300))
		end,
		on_timer = function(pos,elapsed)
			return erode_deplete_ag_soil(pos, source)
		end,
	})

	--register wet depleted soil
	minetest.register_node("nodes_nature:"..name.."_wet_depleted", {
		description = "Wet Depleted "..desc,
		tiles = {
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_dep_top.png^nodes_nature_mud.png"},
			"nodes_nature_"..type..".png^nodes_nature_mud.png",
			{name = "nodes_nature_"..type..".png^nodes_nature_ag_dep_side.png^nodes_nature_mud.png"}},
		stack_max = minimal.stack_max_bulky,
		groups = g4,
		sounds = sw,
		drop = source.."_wet",
		_dry_name = "nodes_nature:"..name.."_depleted",
		on_punch = function(pos, node, puncher, pointed_thing)
			fertilize_ag_soil(pos, puncher, "nodes_nature:"..name.."_wet")
		end,
		on_construct = function(pos)
			--speed of erosion, reversion to natural/depleted
			minetest.get_node_timer(pos):start(math.random(60, 300))
		end,
		on_timer = function(pos,elapsed)
			return erode_deplete_ag_soil(pos, source.."_wet")
		end,
	})

end
