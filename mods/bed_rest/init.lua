-------------------------------------
--BED REST
--based on Minetest game Beds
------------------------------------
--
bed_rest = {}
bed_rest.player = {} -- player_name = 1 if they're in bed, 2 if bed is stored
bed_rest.bed_position = {} -- position of the bed
bed_rest.pos = {} -- position of the player
bed_rest.level = {} -- height of the bed
-- If a bed is stored due to inactivity:
bed_rest.type = {} -- itemname for the bed
bed_rest.dir = {} -- param2 of the bed

bed_rest.session_start = {}
bed_rest.session_limit = {}



local modpath = minetest.get_modpath("bed_rest")

-- Load files


dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/bed_clear.lua")

local temp = load_bedrest()
if temp then
   bed_rest.level = temp["level"]
   bed_rest.player = temp["player"]
   bed_rest.pos = temp["pos"]
   bed_rest.bed_position = temp["bed_position"]
   bed_rest.type = temp["type"]
   bed_rest.dir = temp["dir"]
end
