# Exile
Created by Dokimi  
for `Minetest 5.4`

CAUTION: _Some people may find parts of this game difficult or disturbing._

## Installation
Installation from the Minetest `ContentDB` is preferred; just add _Exile_ from the in-game menu &gg; `Content` &gg; `Browse online content` &gg; search in the textbox &gg; click on the `Install` plus sign.

If extracting manually, _Exile_ should be placed in the `games` folder of your user’s Minetest settings, like so:

	Minetest > games > exile > mods/menu/.../etc.

Where `Minetest` is `~/.minetest` in most Linux, and macOS configurations, `~/.var/app/net.minetest.Minetest/.minetest` in Linux Flatpak, and `%USERHOME%\Roaming\Minetest` in most Windows versions.

Since `0.2.3`, _Exile_ requires `naturalslopeslib` (`nsl`). If you’re installing the source from `git`, you’ll need to install `nsl` as well. Extract it into the `./Exile/mods/` folder or use `git pull --recurse submodules` if you have cloned the repository.

## Gameplay
Challenging, at times brutal, wilderness survival with simple technology.
Use your wits to find food, water, and shelter before succumbing to the elements, while exploring the mysterious world, and developing your capacities to endure your exile.

### Features
*Player health effects* — Hypothermia, exhaustion, disease, …  
*Dynamic natural world* — Seasonal weather, erosion, water flows through soil, …  
*Plausible building materials* — Make shelters from the rain, kilns, smelters, …  

## World Settings
Valleys is the standard `mapgen` for _Exile_. `Carpathian` is also supported, for a somewhat more difficult and slower-paced game.

`Flat` mostly works, but `Merki`, and therefore the `Glow Paint` and `Herbal Medicine` made from it, will be unavailable. Enable it in `game.conf` if you’d like to try it anyway.

## Gameplay Guide
Check out `doc > walkthrough` for a more detailed guide.

Many different strategies might work, and part of the fun is figuring out what does, and catastrophically does not, work. &smile; &frown;

Here are some early steps you might pass though:
1. **Craft**   basic tools. **Find** a suitable camp site quickly before you get tired.
1. **Build**   a bed to rest in, plus shelter, and maybe fires for warmth.
1. **Weave**   rudimentary clothing and blankets to begin improving your rest rate.
1. **Make**    a kiln, and fire pots. **Harvest** wild foods from trees while you wait.
1. **Collect** water with pots, and build up a freshwater supply, into a cistern if needed.
1. **Farm**    food plants, herbs, and fibrous canes to build up supplies.
1. **Explore** and gather mineral resources for more advanced tools.

You start in spring. Maybe some pangs of winter linger, so beware the night.
Enjoy the rains while you can. Soon the hot, dry weather of summer will arrive.
Running out of water, or becoming exhausted from the heat, is a real risk.
After that will come the sub-zero conditions of winter.
Starvation and freezing are hard to avoid without preparation.

### Some Tips and Tricks
- **Beds**           are important: If you’re exhausted you get hypothermia/heat stroke.
                     Get under shelter in a nice temperature.
- **Time**:          Do your crafting, organizing, planning while you rest.
- **Weather**:       Extremes sap your energy.
                     Like real life, walking around in a snowstorm is a bad idea!
- **Temperature**:   Build a shelter, with a fire place or lots of torches.
                     You can also go underground; caves sufficiently deep are safe from weather.
- **Water**:         You can drink cave drips (click them).
                     Water pots collect rain water.
                     Some plants, and food quench your thirst.
                     If you’re desperate, you can try to melt ice, 
                     or dig a seepage pit in wet ground and wait for water to flow into it.
- **Food**:          Eat things and see if you live!
                     You can catch animals with clubs (right-click while wielding).
- **Clothing**:      Simple grass clothing can be woven quickly, and can be a lifesaver.
                     Better clothes can be made by soaking bundles of the right kind of plants.
- **Farming**:       Digging tools also can till soil.
                     Punching depleted agricultural soils with fertilizers will restore them.
- **Illness**:       Keep an eye on “health effects.”
                     You may have eaten something bad, or have a terrible disease.
- **Drugs**:         Some plants have useful medicinal effects.
                     Be careful not to overdose, however.
- **Spelunking**:    Go deep enough underground and you might find something….
- **Woodcutting**:   Hardwood trees are more difficult to cut than soft wood.
                     You will need better tools for those.
- **Climbing**:      Build stairs and shelters around your base.
                     This will save you energy and protect you from extremes.
                     You can use sticks to build a ladder, or a pole to shimmy up, 
                     to get to high places, or descend if you’re careful.
- **Environment**:   Not every step in crafting can be done at a work station.
                     Some things need to be fired, or soaked in water, etc.
- **Industry**:      Build ovens, kilns, furnaces the same as you would for real.
                     Start a fire with access to air, and a sealed chamber that gets heated up.
- **Fires**:         Blocks are hotter than slabs. Charcoal is hotter than wood.
                     Fires can be temporarily extinguished by punching while them holding sediment.
- **Charcoal**:      Make it as you would for real — make a wood fire sealed up to limit airflow.
- **Glassmaking**:   Sand and wood-ash can be made into green glass.
                     The ash must be soaked, dried, and roasted to make clear glass — 
                     Glass can be melted onto iron trays to make panes for real windows!
- **Iron smelting**: This is hard. It needs plenty of charcoal, 
                     and a space below the iron mixture for slag to drain out.

## Settings for Multiplayer
The variable `time_speed` defaults to `72`, and at this rate a player who logs on at 8:00 AM every day will get a change in season every 2.5 days.

Changing speed to `60` will make days last 24 minutes and a new season every real-world day, but he will see the seasons in reverse. At `time_speed` of `96`, days last only 15 minutes, but the player might see spring (year 1) on day 1, summer (year 2) on day 2, etc.

Set `exile_hud_update` to `1.0` second for multiplayer servers on the Internet; a LAN server can probably handle `0.2` seconds.

## Mods for Multiplayer
- [Wield3d](https://github.com/stujones11/wield3d) is recommended.
- `Alternode` was used to add the “infotext” popups in the spawn shelter on the [Land of Catastrophe](https://github.com/AntumMT/mod-alternode) server.

## Development
_Exile_ is open-source software — that means the game is as good as you choose to make it. It also means development can be erratic and haphazard at times, so be patient!

_Exile_ is currently in “Alpha,” therefore you can expect that there may be bugs, missing features, performance issues, and perhaps compatibility-breaking updates.
Despite this, _Exile_ does have enough features to be a playable game and should be stable and mostly bug-free.

See the [GitHub repository](https://github.com/jeremyshannon/Exile/) for known bugs, and to report new ones.

## Credits
Gratitude is due to all those whose mods have been adapted for use in _Exile_ (see `./mod/` folders for details).

Thanks also to all who have given feedback, fixes, etc.  
A full, up-to-date list of contributors can be found on the GitHub repository, under the `Insights` tab.
