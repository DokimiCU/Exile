dofile(minetest.get_modpath("spears").."/defaults.lua")

local input = io.open(minetest.get_modpath("spears").."/spears.conf", "r")
if input then
	dofile(minetest.get_modpath("spears").."/spears.conf")
	input:close()
	input = nil
end

dofile(minetest.get_modpath("spears").."/functions.lua")

dofile(minetest.get_modpath("spears").."/tools.lua")


if minetest.setting_get("log_mods") then
	minetest.log("action", "spears loaded")
end
