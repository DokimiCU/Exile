--settingswarn.lua

--Checks configuration and sends a warning if unsupported values are set

local timespeed = minetest.settings:get("time_speed")
if timespeed and timespeed ~= "72" then
   minetest.log("warning", "time_speed should be set to 72 for intended balance")
end
if minetest.get_mapgen_setting("mg_name") ~= "valleys" then
   minetest.log("error", "Mapgens other than valleys are unsupported and can break the game!")
end
