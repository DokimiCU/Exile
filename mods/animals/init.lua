animals = {}

-- Internationalization
animals.S = minetest.get_translator("animals")

local path = minetest.get_modpath(minetest.get_current_modname())

dofile(path.."/crafts.lua")
dofile(path.."/api_capture.lua")
dofile(path.."/api.lua")


dofile(path.."/impethu.lua")
dofile(path.."/kubwakubwa.lua")
dofile(path.."/darkasthaan.lua")

dofile(path.."/gundu.lua")
dofile(path.."/sarkamos.lua")

dofile(path.."/pegasun.lua")
dofile(path.."/sneachan.lua")

---
--Food Web

--[[
The aim is for mobs to be permanent populations, rather than spawning "ex nihilo".
Therefore most are small animals with small ranges. Have actual food webs that keep them alive.

Ocean:
"plankton (water)" -> gundu -> sarkamos


Caves:
"invisibly small stuff" -> impethu -> kubwakubwa/darkasthaan-> darkasthaan



Land:
plants/dirt/sneachan -> pegasun














]]
