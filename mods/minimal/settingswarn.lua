--settingswarn.lua

--Checks configuration and sends a warning if unsupported values are set

local timespeed = minetest.settings:get("time_speed")
if timespeed and ( timespeed ~= "60" or
		   timespeed ~= "72" or
		   timespeed ~= "96") then
   minetest.log("warning", "time_speed should be set to 60, 72, or 96 for intended balance")
end
if minetest.get_mapgen_setting("mg_name") ~= "valleys" then
   minetest.log("error", "Mapgens other than valleys are unsupported and can break the game!")
end

local HUS = tonumber(minetest.settings:get("exile_hud_update"))
if HUS < 1 and not minetest.is_singleplayer() then
   minetest.log("warning", "It is recommended to set hud update speed to 1 second or longer on multiplayer servers")
end
