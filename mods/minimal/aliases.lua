--aliases.lua

--for importing old saves

--Changed in Exile 0.3.5c/0.2.8c
--Swapping illumination out for wielded_light
minetest.register_alias("illumination:light_faint",
			"air")
minetest.register_alias("illumination:light_dim",
			"air")
minetest.register_alias("illumination:light_mid",
			"air")
minetest.register_alias("illumination:light_full",
			"air")

--Changed in Exile 0.3.5/0.2.8
--standardizing uncooked/cooked/burned
minetest.register_alias("tech:anperla_tuber_peeled",
			"tech:peeled_anperla")
minetest.register_alias("tech:anperla_tuber_cooked",
			"tech:peeled_anperla_cooked")
minetest.register_alias("tech:maraka_cake_unbaked",
			"tech:maraka_bread")
minetest.register_alias("tech:maraka_cake",
			"tech:maraka_bread_cooked")
minetest.register_alias("tech:maraka_cake_burned",
			"tech:maraka_bread_burned")

--Changed in Exile 0.3.1/0.2.4
minetest.register_alias("tech:peeled_anperal_tuber",
			"tech:anperla_tuber_peeled")
minetest.register_alias("tech:cooked_anperal_tuber",
			"tech:anperla_tuber_cooked")
minetest.register_alias("tech:mashed_anperal",
			"tech:mashed_anperla")
minetest.register_alias("tech:mashed_anperal_cooked",
			"tech:mashed_anperla_cooked")
minetest.register_alias("tech:mashed_anperal_burned",
			"tech:mashed_anperla_burned")

minetest.register_alias("tech:clay_oil_lamp_empty",
			"tech:clay_oil_lamp_unlit")
