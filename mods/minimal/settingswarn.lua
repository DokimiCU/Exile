--settingswarn.lua

--Checks configuration and sends a warning if unsupported values are set

local timespeed = minetest.settings:get("time_speed")
if timespeed and ( timespeed ~= "60" and
		   timespeed ~= "72" and
		   timespeed ~= "96") then
   minetest.log("warning", "time_speed should be set to 60, 72, or 96 for intended balance")
end
if minetest.get_mapgen_setting("mg_name") ~= "valleys" and
   minetest.get_mapgen_setting("mg_name") ~= "carpathian" then
   minetest.log("error", "Mapgens other than valleys or carpathian are unsupported and can break the game!")
end

local HUS = tonumber(minetest.settings:get("exile_hud_update"))
if HUS < 1 and not minetest.is_singleplayer() then
   minetest.log("warning", "It is recommended to set hud update speed to 1 second on multiplayer servers")
end
