# ISSUES AND TO DO LIST
Exile is a Work in Progress!

This is a working document to keep track of various issues as they arise.
This also lists various ideas, planned, and possible features.

## ISSUES
-------------------------------------------------------------------
Urgent Fixes needed:

- Climate:
  - Weather saving would be better done with `on_leaveplayer` (but that doesn’t 
    work for some reason...). Being called unnecessarily to work around this.
  - Weather effects if exposed to sun?? 
    (I.e. so can’t dig a massive pit to stop rain.)
- Bed:
  - Bed rest wipes physics effects. (Almost a feature...)
  - Need something to stop beds getting destroyed while a player is one them. 
    (A problem for punchable/floodable/buildable sleeping spot.)
- Health:
  - `Character` tab (lore) might need a scroll bar.
  - `minetest.after` effects (e.g. staggering) linger into re-spawn after death. 
    (For now recommended to wait a while on the death screen.)
- Animals:
  - Some spiders were getting `nil` energy. 
    (From egg spawning? Maybe only in dev., not happening now?)
  - `mobs_chicken_white.png` is being called by something. 
    (The chicken model itself? Isn’t in the code anywhere...)
  - Stability of animal populations over time is unknown.
  - Some animals can be a bit too unintelligent (e.g. hunting).
  - Predators don’t do well (perhaps swap out for generalists?).
- Nature:
  - Ocean flora lacks spreading (though that barely matters at this point).
  - Tangkal tree schematic has grass in it.
  - Freshwater is bad for reservoirs because of evaporation + nonrenewable, 
    but making it renewable allows infinite water.
  - Two `Snow Slab`s should turn into a `Snow Block` when placed on top of self.
    (Instead of vanishing due to `buildable_to = true`.)
  - Bottom texture on wet sediment should be the sediment (currently is top).
- Volcano:
  - Occasional dark spots.
- Megamorph Mod:
  - A silly string stair doesn’t line up (from overpass).
  - `self.params.share.surface` crash with some layouts.  
    (Where they cross over edges. No current morphs do this.)
  - All doors ought to have floors, to avoid doors hanging in space from caves.
  - May have redundant and nonfunctional code.  
    (Due to difficulty of extracting it from source mods.)
- Tech:
  - `temp_pass` should probably act like air temp, allowing air heat to move 
    through them. (For example, an open door should let air out.)
  - Torches/oil lamp should burn when held. (i.e. no infinite burn exploit)
  - Graffiti would benefit from something stopping it on silly things.
    (e.g. beds, crafting spots)
  - Ropes don’t transmit heat from adjacent air nodes.
  - Partly cooked, etc., should save progress in meta for inventory.  
    (Otherwise they can be reset.) (`Maraka Flour`, `Cana` retting, food cooking)
- Illumination:
  - Node `light_source` value exceeds maximum, limiting to maximum: `illumination:light_full`
  - Doesn’t illuminate invisible functional non-air nodes (e.g. tree markers).
- Artifacts:
  - Airboat collision allows going into things, dig pointer is out of line with crosshair, 
    can jump off inside blocks (exists because wanted to be able to dig while attached).
- Crafting Mod (by ***rubenwardy***)
  - Adds stack to inventory at crafted stack size, rather than node stack size (over-stacked).
  - Some items need inventory images with space around edges (e.g. wattle).
  - Sound effects would be nice.
- Canoe:
  - Rare: Canoe vanished and teleported player a few hundred meters away 
    (while pushing `forward` repeatedly, again while view full range).
- Backpacks:
  - Uses deprecated meta.
- Multiplayer:
  - Add protection (i.e. locks) to wooden chest and doors.
- Misc:
  - Various bits of code could be tidied up, and duplicated code rolled into functions.
    (For example, cooking/smelting, saving to inventory, etc., are are all very similar).
  - Might be missing credit for some textures and such.  
    (Mostly from _Minetest Game_? Plus some plants?)
  - Many registered nodes currently cluttering creative-inventory could be hidden.
  - Performance testing, etc., etc. ... (Can become slow, as all the dynamic-nature 
    stuff might be a bit much. Also, large numbers of mobs.)
  - Irrlicht: `PNG warning: iCCP: profile 'ICC PROFILE': 9019A303h: invalid length`
  - Irrlicht: `PNG warning: iCCP: CRC error`

## IDEAS AND TO DO LIST
-------------------------------------------------------------------

### Features needed:
  - _Rimworld_-style storyteller (for events, dynamic and unexpected challenges).
  - Dynamism and decoration for underground city.
  - The logic of burning things needs sorting out 
    (e.g. must light fires, but torches always lit).

### Features ideas:
- MISC:
  - Easy start option (start with axe, bag, clothes, water pot, mattress, food).
  - Once a sophisticated camp has been built it is too easy to just stay there 
    and live the good life. Needs something to be able to go horribly wrong, 
    big enough to force a migration, rebuild, temporary escape. (story teller)
- INTERFACE
  - Remove inventory trash when not creative?
  - Nameable bags.
  - Tutorials, help menus, maybe a set of beginners achievements to work through.  
    (Very helpful for new players, but should only be done after core content complete.)
- PROCESSES
  - Punch with torch for firelighter?
  - Boil water in pots?
  - Food decay.
  - `weildview` + register wield effects (e.g. burn torch).
- HEALTH
  - Effects: `on_node` + `in_node` health check, biome check, venom on bite, 
    more components (e.g. HUDs, tunnel vision).
  - Effects currently handled by low-thirst/hunger/low-body-temp/etc., could 
    be turned into effects (e.g. malnutrition, hypothermia).
- NATURE
  - Shellfish.
  - Mangroves.
  - Unique environ tolerances for each plant species.
  - Frozen wet ground (cracky).
  - Fire tolerance for trees (`on_burn` to charred tree, regenerates).
  - Seasonal fruit.
- CLIMATE
  - Humidity, wet bulb temperatures.
  - More sophisticated shelter adjustment using lines of sight as a wall detector.  
    (Requires something better than `minetest.line_of_sight` as that doesn’t 
    include `temp_pass group` — too easy to game it without that.)
- MOBS
  - More mobs: land predator, and more of everything in general.
  - Catch chance based on wield item (can catch with hand).
  - Seasonal behavior.
  - _Rimworld_-style colonists.
- LORE/LOOT/DUNGEONS
  - Artifacts (loot): scuba, tree grower.
  - Dangerous “pandora’s box” loot.
  - Surface ruins left by the Ancients.
  - `Geomoria`-mod decorations.
  - More `megamorph` biomes: gardens, waste dumps, public baths, transporter room, 
    laboratory, storage dumps, factories.
  - NPCs, quests, etc.
  - Currently looking for loot is a bit gambling/grindy. 
    Doesn’t have the right feel for the game.
    - Going into the lost city needs to feel like a terrifying bad idea. 
    - Searching through the junk of a people who destroyed themselves 
      should also be a dubious/bad idea.
  - Dangerous contaminants, traps, etc.
- SOFT PERMA-DEATH (i.e. new life = new character)
  - More stuff for character page with: achievements?, earnable nickname?, Character skin image.
  - Random (re)spawn location: based on the faction that exiled you there  
    (e.g. Empire of X all spawn at same place — needs some hard-coded factions).
    - Thus players get mixed around to diff places, but do sometimes return to old place. 
      (balance variety and build).
    - Currently travel is very hard, so all lives get lived at one base. 
      This would add some variation. Develop separate towns.
  - Acquired character traits (see each life becomes meaningfully unique)
  - Death screen — name and days survived (also put in Breaktaker, maybe a Highscores page?). 
    Put name in bones meta.
  - Multiplayer protection that allows protection to fade after death?? Might get abused?
- CLOTHING
  - Speed effects. (Likely to cause issues with bed physics.)
- TECH
  - More sophisticated fires: heat and output controlled by airflow.
  - More graffiti in more colors. (Old health symbols can be reused here.)
  - Inventory storage on canoe.
  - Wood shingle roof, wood walls, beams etc.
  - Cooking: bulk cooking method (cauldron - add food and water to it, take out by bowlful)
  - Water pots: drink a bit at a time (e.g. tooltip displays units, drink 1 per click)
  - Tool repair and modifiers.
  - Climbing pick?
  - Chair (small bed rest effect, but better for crafting).
  - Sailing.
  - Glassware (windows, bottles, distillery, solar still).
  - More-sophisticated medicines, e.g. needing a apothecary kit, can heal for toxins.
  - Compost.
  - Bellows that displaces `air_temp` nodes.
  - Scythe.
  - A use for broken pottery.
  - Ash crafts (glass).
  - Watering can (make soil wet).
  - Pottery wheel and more sophisticated glazed pottery.
  - Iron doors (e.g. for furnaces, nonflammable).
  - Automation (via cogs, gears, windmills etc.).
  - Ranged weapons.
  - Armor.
  - Right-click to turn torches/lamps off (+require lighting them like with fires)
  - Degradation of perishable building materials (e.g. mudbrick -> clay, log -> rotten). 
    Gives an advantage to sophisticated building materials.
  - Grinding stones and clubs craftable using more stone types (basalt/jade).

## INFERNO
- DECO
  - More ambience: rustling leaves, lava.
- MULTIPLAYER
  - Various standard server tools (e.g. protection, chat, etc)?
  - Signs, letters, etc. (graffiti could have an alphabet paint kit, 
    but servers need more detailed signage)
  - Intro page (optional - off in single player) (or just help menu)
  - Multiplayer only crafts (e.g. for trade). (optional - off in single player)?
