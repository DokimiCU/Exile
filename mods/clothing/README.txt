Exile mod: clothing
========================
Allows adding of clothing.





Groups:
-clothing vs cape: for rendering. Regular clothes layer vs cape clothes layer.
-clothing_pants/hat/shirt etc: type of clothes (to stop stacking the same type of item)

Stack max should always be 1, to prevent wearing 50 hats at once etc.


temp_min = lowers minimum temperature tolerance by this much
temp_max = raises maximum by this much

Use default calls for most clothes. This adds removes temperature effects.
on_equip = clothing.default_equip,
on_unequip = clothing.default_unequip

Modified versions of these functions could be made for special effects. e.g. enabling flight, speed shoes etc

See test clothing for examples.





Authors of source code
----------------------
Adapted from "Clothing" by Stuart Jones - LGPL v2.1





Authors of media
------------------------
Textures: Stuart Jones - CC-BY-SA 3.0
