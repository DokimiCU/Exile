-------------------------------------
--ARTIFACTS
------------------------------------
artifacts = {}
artifacts.S = minetest.get_translator("artifacts")
artifacts.FS = function(...)
	return minetest.formspec_escape(artifacts.S(...))
end

local modpath = minetest.get_modpath('artifacts')

dofile(modpath..'/storage.lua')
dofile(modpath..'/tools.lua')
dofile(modpath..'/materials.lua')
dofile(modpath..'/map.lua')
dofile(modpath..'/bell.lua')
dofile(modpath..'/wayfinder.lua')
dofile(modpath..'/art.lua')
dofile(modpath..'/airboat.lua')
dofile(modpath..'/transporter.lua')
dofile(modpath..'/pandora.lua')
-------------------------------
