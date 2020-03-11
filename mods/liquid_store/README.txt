Exile mod: liquid_store
=========================
Adds water storage nodes.

Liquids and storage items registered separately.

e.g. For freshwater and a pot for freshwater
liquid_store.register_liquid(
	"nodes_nature:freshwater_source",
	"nodes_nature:freshwater_flowing",
	false)


liquid_store.register_stored_liquid(
	"nodes_nature:freshwater_source",
	"tech:clay_water_pot_freshwater",
	"tech:clay_water_pot",
	{
		"tech_water_pot_water.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png",
		"tech_pottery.png"
	},
	{
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.25, 0.25, 0.5, 0.25},
			{-0.375, -0.25, -0.375, 0.375, 0.3125, 0.375},
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125},
			{-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- NodeBox4
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.375, 0.3125},
		}
	},
	"Clay Water Pot with Freshwater",
	{dig_immediate = 2})




Authors of source code
----------------------
Adapted for Exile from buckets from Minetest game:
Kahrl <kahrl@gmx.net> (LGPLv2.1+)
celeron55, Perttu Ahola <celeron55@gmail.com> (LGPLv2.1+)
Various Minetest developers and contributors (LGPLv2.1+)
