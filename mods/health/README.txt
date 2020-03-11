Exile mod: Health
=============================
Adds player health effects e.g. hunger, thirst, fatigue, hypothermia


Consummable items:
-----------------
HEALTH.use_item(itemstack, user, hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item)

call from on_use.
e.g. adds 5 food, minus 10 energy.
on_use = function(itemstack, user, pointed_thing)
  return HEALTH.use_item(itemstack, user, 0, 0, 5, -10, 0)
end,


Authors of source code
----------------------
Dokimi (GPLv3)



Authors of media
-----------------
Health_alert http://soundbible.com/1669-Robot-Blip-2.html, Attribution 3.0, Marianne Gagnon
