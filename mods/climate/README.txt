Exile mod: Climate
=============================
Adds seasonal weather, as well as functions for checking point temperature, exposure to rain etc.


Register weather:
-----------------
climate.register_weather(name{def})
see weathers for examples.
Can include sky, cloud, and particle effects.

For the weather to occur is must be included in the `Chain` of another weather,
which is in turn link by link connected into the network of all possible weather
states.
This is a Markov chain with temperature adjusted probabilities of switching
from one state to another.


Functions to check weather exposure:
-----------------------------------
Only give light if it has already been calculated, otherwise the function will recalculate it.

`climate.get_rain(pos, light[optional])`
Checks if the position is exposed to significant rain.
Returns true if raining.

`climate.get_snow(pos, light[optional])`
Checks if the position is exposed to significant snow.
Returns true if snowing.

`climate.can_evaporate(pos, light[optional])`
For water. Temperature based chance of returning true.
e.g. at 100 degrees it will be 100% chance. At 1 degree it will be a 1% chance.

`climate.can_freeze(pos)`
For water. Temperature based chance of returning true.

`climate.can_thaw(pos)`
For ice/snow. Temperature based chance of returning true.

`climate.get_damage_weather(pos, light[optional])`
Checks if the position is exposed to player harming weather. e.g. duststorms


Temperature:
-----------
`climate.get_point_temp(pos)`
Returns the temperature at position. Calculated based on air temperature, and
the distance adjusted sum of nearby by nodes in `temp_effect` group.

Nodes must be in line of sight (via air or `temp_pass` group) to have an effect.
Effect weakens with distance.
Node definition `temp_effect` is the amount the node raises or lowers temperature.
Node definition `temp_effect_max` is the maximum/minimum effect that node can have.

e.g. `temp_effect` = 50 `temp_effect_max` = 100, will raise temperature by 50 degrees
but max out at 100.
e.g. `temp_effect` = -50 `temp_effect_max` = 0, will lower temperature by 50 degrees
but bottom out at 0.
e.g. `temp_effect` = 50 `temp_effect_max` = -100, this strange thing will only heat up to -100

air_temp can be used for powerful heating/cooling effects where air movements are important.
e.g. for ovens, fridges, i.e. the ability to trap air matters.


Authors of source code
----------------------
Dokimi (GPLv3)



Authors of media
----------------
xeranas:
-heavy_rain_drops.png - CC-0
-light_rain_raindrop_*.png - CC-0
-light_snow_snowflake_*.png - CC-0

inchadney (http://freesound.org/people/inchadney/):
-rain_drop.ogg - CC-BY-SA 3.0 (cut from http://freesound.org/people/inchadney/sounds/58835/)
rcproductions54 (http://freesound.org/people/rcproductions54/):
-light_rain_drop.ogg - CC-0 (http://freesound.org/people/rcproductions54/sounds/265045/)

uberhuberman
-heavy_rain_drop.ogg - CC BY 3.0 (https://www.freesound.org/people/uberhuberman/sounds/21189/)
