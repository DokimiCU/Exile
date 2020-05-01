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


Some tips and tricks:
- Beds are important. If you're exhausted you get hypothermia/heat stroke. Get under shelter in a nice temperature.
- Weather: extremes sap your energy. Like real life, walking around in a snowstorm is a bad idea!
- Temperature. Build a shelter, with a fire place or lots of torches. You can also go underground.
- Go deep enough underground and you might find something....
- Water: you can drink cave drips (click them). Water pots collect rain water, or from wet soil. Some plants, food has water.
- Ovens, kilns, furnaces: build them like you would for real. A fire with access to air, and a chamber that gets heated up.
- Fires. Blocks are hotter. Charcoal is hotter than wood.
- iron smelting. This is hard. Needs charcoal.
- Charcoal. Make it like you would for real. A wood fire with no air.
- Food: eat stuff and see if you live! You can catch animals with clubs (right click)
- Drugs: a couple of things have useful effects.
- Not every step in crafting can be done at a work station. Some things need to be fired, or soaked in water etc.



### Changelog:

# 0.1
- Initial release

# 0.1.1
- various minor fixes
- various minor balance changes
- various minor additions
- updated backgrounds
- updated version of crafting
- darkasthaan spider for deep caves
- graffitti: glow paint
- better looking bones
- fixed dungeon loot, added more artifacts, split into realms
- gneiss and jade for deep underground biome



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
-speed/jump malus from low hp
-more sophisticated health: energy drawn from Hunger.

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
-artifacts (loot): teleporter? airboat, short distance teleport
-dangerous "pandora's box" loot
-lore: sentence of exile letter, bones of lost exiles, lore in geomoria
-surface ruins
-geomoria decorations

--TECH
-more sophisticated fires: heat and output controlled by airflow
-more graffiti in more colors
-extinguish fire to partially burnt fire (so can turn-off/on)
-inventory on canoe
-clothing (with effect on temp tolerance)
-bricks and mortar (higher carry limit than mudbrick to justify cost)
-crushed lime> quicklime > mortar
-clay roof tiles
-wood shingle roof, wood walls, beams etc
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
-ash crafts (glass)
-compass
-screwdriver
-watering can (make soil wet)
-pottery wheel and more sophisticated glazed pottery
-iron doors (e.g. for furnaces, nonflammable)


--DECO
-more ambience: rustling leaves, lava
-stalactites in limestone




#Bugs/fix
Climate:
-sky twilight transition doesn't work when emerging from underground. Sky is not reset instantly like sound is.
-weather not saved when all players leave
-what does "fog" in weather actually do...?
-weather effects if exposed to sun?? ie. so can't dig a massive pit to stop rain.
-sound effects cut off underground is too abrupt (should fade)


Bed:
-bed rest wipes physics effects (almost a feature...)
-multiplayer bug caused by breaktaker?

Health:

Animals:
-occassional function animals.hq_attack_eat(self,prty,tgtobj) crash . api.lua:387: attempt to perform arithmetic on field 'height' (a nil value). From darkasthaan spider
-darkasthaan speed slide around a lot when attacking, looks strange.
-some spiders were getting nil energy (from egg spawning? maybe only in dev, not happening now?)


Nature:
-ocean flora lacks spreading (barely matters at this point)
-might need something to animal numbers in check... needs to be run over time...
-water doesn't freeze?
-Tangkal tree schem has grass in it?
-freshwater is bad for reservoirs bc of evaporation + nonrenewable, but making it renewable allows infinite water.

Volcano:
-occassional dark spots

Megamorph:
-a silly string stair doesn't line up (from overpass)


Tech:
-doors ought to toggle temp_pass group on open and close
-torches/oil lamp should burn when held (i.e. no infinite burn exploit)
-grafitti would benefit from something stopping it on silly things (e.g. beds, crafting spots)
-ropes don't go through air temp
-air temp needs to spread better in open spaces.
-partly cooked/smelted etc should save progress in meta for inventory (otherwise they can be reset)

Crafting (Rubenwardy)
-crafting when full inventory should drop crafts that don't fit inventory.
-adds stack to inventory at crafted stack size, rather than node stack size (over stacked)
-Calling get_connected_players() at mod load time is deprecated

Misc:
-might be missing credit for some textures etc
-a lot of cluttering nodes could be removed from creative inventory
-performance testing etc etc... (can get slow, all the dynamic nature stuff might be a bit much)