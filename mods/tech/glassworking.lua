----------------------------------------------------------
--GLASS WORKING


--[[
>>> making glass
1800C will fuse sand itself.

Soda lime glass
Soda ash. - melting agent (1200C)
Sand -vitrifying
Calcium - stabilizing (potentially in the sand)

Two types of glass - green and clear

Green - made from ash and sand. Ash contains potash/soda ash and lime, but also iron impurities that color the glass green.
	Good for things where clarity doesn't matter, like bottler
Clear - made from refined potash (pearl ash), lime and sand. More expensive, as have to work to refine potash. Good for windows.

Potash - in this case get from wood ash. 
Process:
	1. Soak in water
	2. Put water into pot
	3. Evaporate water to get potash (still with impurities, makes green glass)
	4. Roast potash in kiln to get pearl ash

>>>make things from glass:
Reheat so it is workable, then shape.
Small glass workshop furnace.

Vessels: glass blowing

Panes: cast on to an iron tray, then polished. Only get small panes.


]]
-----------------------------------------------------------

-- Pre-roast  functions
local function set_roast(pos, length, interval)
	-- and firing count
	local meta = minetest.get_meta(pos)
	meta:set_int("roast", length)
	--check heat interval
	minetest.get_node_timer(pos):start(interval)
end



local function roast(pos, selfname, name, length, heat)
	local meta = minetest.get_meta(pos)
	local roast = meta:get_int("roast")

	--check if wet stop
	if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
		return true
	end

	--exchange accumulated heat
	climate.heat_transfer(pos, selfname)

	--check if above firing temp
	local temp = climate.get_point_temp(pos)
	local fire_temp = heat

	if roast <= 0 then
		--finished firing
    minetest.set_node(pos, {name = name})
    minetest.check_for_falling(pos)
    return false
  elseif temp < fire_temp then
    --not lit yet
    return true
	elseif temp >= fire_temp then
    --do firing
    meta:set_int("roast", roast - 1)
    return true
  end

end


-- Green glass

-- Mix - sand and ash 50/50
minetest.register_node("tech:green_glass_mix",
{
	description = "Green Glass Sand Mix",
	tiles = {"tech_sand_mix.png"},
	stack_max = minimal.stack_max_bulky *4,
	paramtype = "light",
	groups = {crumbly = 3, falling_node = 1, heatable = 20},
	sounds = nodes_nature.node_sound_sand_defaults(),
  	on_construct = function(pos)
		--length(i.e. difficulty of firing), interval for checks (speed)
		set_roast(pos, 40, 10)
	end,
	on_timer = function(pos, elapsed)
		--finished product, length, heat, smelt
		return roast(pos, "tech:green_glass_mix", "tech:green_glass_ingot", 40, 1500)
	end,
})

-- Finished Products
-- Glass ingot - 1/4 block
minetest.register_node("tech:green_glass_ingot", {
	description = "Green Glass Ingot",
	tiles = {"tech_green_glass.png"},
	inventory_image = "tech_glass_ingot_green_icon.png",
  	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.1, 0.3},
	},
	stack_max = minimal.stack_max_bulky * 4,
	paramtype = "light",
	groups = {cracky = 3, falling_node = 1, temp_pass = 1, heatable = 20},
	sounds = nodes_nature.node_sound_glass_defaults(),
	use_texture_alpha = true,
	sunlight_propagates = true,
})

-- Crafts
-- Mix sand and ash 50/50
crafting.register_recipe({
	type = "hammering_block",
	output = "tech:green_glass_mix 2",
	items = {'tech:wood_ash_block 1', 'nodes_nature:sand 1'},
	level = 1,
	always_known = true,
})



