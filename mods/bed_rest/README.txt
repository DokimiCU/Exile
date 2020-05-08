Exile mod: bed_rest
=======================
Adds api for beds on which player can lie down. Does nothing else beyond this,
but allows the fact that the player is in bed to be known by other mods
 e.g. for applying rest effect in Health.

bed_level is how effective the bed is (base rest X bed level = rest).

Example register:
 bed_rest.register_bed("tech:primitive_bed", {
 	description = "Primitive Bed",
 	inventory_image = "tech_primitive_bed.png",
 	wield_image = "tech_primitive_bed.png",
  stack_max = minimal.stack_max_bulky,
   tiles = {
 		bottom = {
 			"tech_thatch.png^[transformR90",
 			"tech_primitive_bed_bottom.png",
 			"tech_primitive_bed_side.png",
 			"tech_primitive_bed_side.png^[transformfx",
 			"tech_primitive_bed_side.png"
 		},
 		top = {
 			"tech_thatch.png^[transformR90",
 			"tech_primitive_bed_bottom.png",
 			"tech_primitive_bed_side.png",
 			"tech_primitive_bed_side.png^[transformfx",
 			"tech_primitive_bed_side.png",
 		}
 	},
 	nodebox = {
 		bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
 		top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
 	},
 	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
 	sounds =  nodes_nature.node_sound_wood_defaults(),
  groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, temp_pass = 1},
  bed_level = 2,
 })



Authors of source code
----------------------
Adapted for Exile from Minetest Game mod beds:
Originally by BlockMen (MIT)
Various Minetest developers and contributors (MIT)


Authors of media (sounds)
-------------------------
bed_rest_breakbell adapted from "Japanese temple bell" Mike Koenig (Attribution 3.0) http://soundbible.com/1496-Japanese-Temple-Bell-Small.html
