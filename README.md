# Exile
Version 0.1.1
by Dokimi

### Gameplay
Challenging, at times brutal, wilderness survival with simple technology.
Use your wits to find food, water, and shelter before succumbing to the elements,
while exploring the mysterious world, and developing your capacities to endure your exile.

Features:
Player health effects: hypothermia, exhaustion,...
Dynamic nature with: Seasonal weather, erosion, soil water flows...
Building matters: make shelters from the rain, kilns, water reservoirs,...
...

### Gameplay Guide
Many different strategies might work, and part of the fun is figuring out what does,
and catastrophically does not, work.

Here are some early steps you might pass though:
1. Make basic tools, and a bag. Find a suitable camp site.
2. Build a bed to rest in, shelter, and maybe fire for warmth.
3. Make a kiln, and make pots. Harvest wild foods while you wait.
4. Collect water with pots, and build up a water supply.
5. Farm food, drugs, and fibre to build up supplies.
6. Explore and gather resources for more advanced tools.

You start in spring. Soon the hot dry weather of summer will arrive.
Running out of water, or getting exhausted by the heat is a real risk.
After that will come the sub-zero conditions of winter.
Starvation and freezing are hard to avoid without preparation.



### Changelog:

# 0.1.1
- Initial release

# 0.1.1
- prevent crash in megamorph from default (placeholder solution)
- minor fixes: snow carry limit, slower evaporation
- minor balance changes: cheaper bed recipe, less water from Tangkal fruit, more random weather
- minor additions: add more recipes at stations, break falling with snow, crafting selection boxes , iron slag can drain into iron_slag_mix
- updated backgrounds



### To Do:

Urgent Fixes needed:



Features needed:
-Rimworld style story-teller (for events, dynamic and unexpected challenges)



Features ideas:

--INTERFACE
-remove inventory trash when not creative?
-nameable bags

--PROCESSES
-punch with torch for firelighter?
-boil water in pots?
-food decay


HEALTH
-disease and other player effects

--NATURE
-bamboo like thing (like canes but for sticks)
-shellfish
-tree seedling?/sapling?/slow growth (no insta-trees!...maybe have a biotech artifact)
-unique environ tolerances for each plant species
-frozen wet ground (cracky)
-fire tolerance for trees (on_burn to charred tree, regenerates)
-underground flora: food, wood, light


--MOBS
-more mobs: hive, pack/farm animal, bird, lizard/scorpion
-better looking dead animals, cooking

--LORE/LOOT/DUNGEONS
-artifacts (loot): a way to get map, teleporter, etc
-lore: sentence of exile letter, bones of lost exiles, lore in geomoria
-divide geomoria depths
-surface ruins

--TECH
-more graffiti in more colors (white: two more spirals.)
-extinguish fire to partially burnt fire (so can turn-off/on)
-inventory on canoe
-clothing (with effect on temp tolerance)
-bricks and mortar (higher carry limit than mudbrick to justify cost)
-cooking: e.g  juice (fermented)? soup? Stim drug
-tool repair and modifiers
-climbing pick?
-chair (small bed rest effect, but better for crafting)
-sailing
-glassware (windows, bottles, distillery, solar still)
-compost
-bellows that displaces air_temp nodes
-Scyth
-a use for broken pottery,
-bell?
-ash crafts
-compass
-screwdriver

--DECO
-more ambience: rustling leaves,
-stalactites in limestone
-coastal sea rocks



#Bugs/fix
Climate:
-sky twilight transition doesn't work when emerging from underground. Sky is not reset instantly like sound is.
-weather not saved when all players leave
-what does "fog" in weather actually do...?
-weather effects if exposed to sun?? ie. so can't dig a massive pit to stop rain.
-sound effects cut off underground is too abrupt (should fade)

Bed:
-bed rest wipes physics effects (almost a feature...)

Health:


Nature:
-ocean flora lacks spreading (barely matters at this point)
-might need something to animal numbers in check... needs to be run over time...
-some spiders were getting nil energy (from egg spawning?)
-water doesn't freeze?



Megamorph:
-megamorph dungeon_loot doesn't work (disabled)
-megamorph would benefit from some doors and ladders nodes to use (disabled), also appropriate treasure chests
-something odd going on ...?? (new Minetest activated code that previously wasn't running)

Tech:
-oil lamp doesn't remove oil from inv
-doors ought to toggle temp_pass group on open and close
-torches should save how much burnt when returned to inventory, and should burn when held (i.e. no infinite burn exploit)
-grafitti would benefit from something stopping it on silly things (e.g. beds, crafting spots)
-ropes don't go through air temp
-air temp needs to spread better in open spaces.
-smelt mix > iron and slag missing heat transfer on change

Crafting (Rubenwardy)
-get connected players deprecated.
-crafting when full inventory should drop crafts that don't fit inventory.
-Highlights no longer work.
-adds stack to inventory at crafted stack size, rather than node stack size (over stacked)

Misc:
-might be missing credit for some textures etc
-a lot of cluttering nodes could be removed from creative inventory
-performance testing etc etc... (can get slow, all the dynamic nature stuff might be a bit much)
