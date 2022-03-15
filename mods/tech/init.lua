-------------------------------------
--TECH
------------------------------------
tech = {}

local modpath = minetest.get_modpath('tech')


dofile(modpath..'/craft_stations.lua')
dofile(modpath..'/tools.lua')
dofile(modpath..'/lever.lua')
dofile(modpath..'/backpacks.lua')
dofile(modpath..'/plant_crafts.lua')
dofile(modpath..'/fires.lua')
dofile(modpath..'/pottery.lua')
dofile(modpath..'/drugs.lua')
dofile(modpath..'/storage.lua')
dofile(modpath..'/earthen_building.lua')
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/doors.lua")
dofile(modpath .. "/torch.lua")
dofile(modpath .. "/ironworking.lua")
dofile(modpath .. "/woodworking.lua")
dofile(modpath .. "/fibreworking.lua")
dofile(modpath .. "/glassworking.lua")
dofile(modpath .. "/clothing.lua")
dofile(modpath .. "/grafitti.lua")
dofile(modpath .. "/bricks_and_mortar.lua")
dofile(modpath .. "/cooking_pot.lua")
-------------------------------

-----------------------------------------------
-- Dying recipes

crafting.register_recipe({
	type = "crafting_spot",
	output = "ncrafting:dye_pot 1",
	items = {"tech:clay_water_pot 1", "tech:stick 1"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "crafting_spot",
	output = "ncrafting:dye_table 1",
	items = {"tech:stick 12"},
	level = 1,
	always_known = true,
})
