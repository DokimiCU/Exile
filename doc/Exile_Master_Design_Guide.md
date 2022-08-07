# Exile's Master Design Guide

This document exists to explain Exile's design approach. It is the master document for any design elements you might need to know about (as a contributor, modder, or curious player).

Any collective activity needs a shared vision and culture. The hope is that the ideas and principles described here can guide discussions, keep the design focused around a coherent vision, and help new contributors understand what Exile is about and how it works.

This is a set of suggestions and guides, subject to discussion and revision, rather than unbreakable laws. People make decisions, not pieces of paper. 

Please read relevant sections if you want to contribute content to the game (beyond simple bugfixes). It's much easier to discover that an idea clashes with Exile's design at the start rather than after long hours of coding.

Please be aware: at a surface level Exile is similar to many other games. However, underneath the design is often coming from a significantly different perspective.


## CONTENTS

- Core Values & Goals
- I Have an Idea for a Feature, What Should I Do?
- Review and Critique
- Quality Standard
- Places to Get Inspiration
- Intended Audience
- Core Design Elements
- Design Principles
- Design Principles - Welfare
- Design Principles - Choice
- Design Principles - Nature
- Design Principles - Ease of Use
- Design Principles - Artistic
- Lore and Story
- Map Context (Climate, Geology, Lifeforms)
- Map Areas
- Biomes
- Naming Conventions for Nature
- Art Style
- Controversial and Sensitive Subjects
- Programming and Code
- Module Directory



## Core Values & Goals
- Exile's minimum core values are those which are necessary for Exile and Mintest's continued existence. As such, these values are not negotiable. To violate them is self-defeating. Exile will necessarily reflect these values in its design.

### *Exile is free and open source:*
- The Free and Open Source software movements have a history. Minetest and Exile have emerged out of that history, and would not exist otherwise.
- Philosophically these movements contain and attract a lot things. At a minimum some core values to consider are freedom, community, and prioritizing the needs of the user.

### *Exile is created and played by diverse people from around the world:*
- Acceptance and respect for that diversity is therefore non-negotiable. To do otherwise would be to reject the game's own creators and players.

### *The aim of Exile is to leave the player better off:*
- People often use games for escapism from difficult situations (e.g. stress, trauma, disrupted home life, physical or mental illness etc). Exile was originally created to be a safe and positive place for that kind of escapism.
- Excessive escapism is unhealthy, and many commonly available methods of escapism are problematic (e.g. exploitative lootbox games). Destructive forms of escapism make people's lives worse during vulnerable situations. At a minimum Exile is intended to be a form of harm reduction - it's better than what the player might have been doing otherwise.
- At its best Exile aims to be a life affirming activity e.g. promoting a sense of self-efficacy, endurance, and coping.
- While you might not relate to the game in this very serious way, please remember, this was why the game was originally created. Well designed features will contribute towards this goal.

## I Have an Idea for a Feature, What Should I Do?
- Make sure you understand how Exile is designed and that your idea aligns with that design.
- Consider starting a conversation with existing contributors. Sometimes the idea might need substantial changes before its suitable. That's okay. This is how ideas go from good to great. Ideas and experimentation are always welcome.
- After this early design stage, consider making a prototype. See how the idea works in practice.

### *Is My Idea Good?*
- Rather than "Good" or "Bad" try to think in terms of "Fit". Is this idea right for the game? Does it meet the design criteria? A bad implementation can be improved. A bad fit was never appropriate to begin with.
- We'd rather accept new ideas and contributions than reject them. That said, oftentimes even good ideas just don't fit. No game can be all things to all people. 

### *My Idea Doesn't Fit, But I Still Think it's a Good Idea*
- This is why modding exists. Create an independent mod. 
- Exile is intended to be modding friendly. If something in the game makes it difficult to add your mod, then raise the issue so this can be fixed and made easier for modders.

### *But I Really Want My Idea in the Core Game*
- Exile has some areas where it's possible to be more relaxed about what fits. These areas contain non-critical content. Even very strange or silly ideas might do okay here.
- If your idea can be adapted to work in one of these areas, then it's more likely your idea can be added to the game.
- Giving people a sense of ownership is important. This is the easiest and most appropriate place for features that are meaningful mostly only to a few people who just really, really, really want to have it in the game.

These areas are:
- *Artifacts & the Undercity:* if your idea is an item, consider if it would work as an Artifact. More complex ideas might also be able to be tied into the world of the Undercity. An entire civilisation existed down there, so that's a lot of scope for possibility
- *Character Backstory:* every character is unique, therefore it might be possible to tie your feature to particular kinds of character. Characters can be anyone from anywhere, so again that's a lot of scope for possibility.

Limitations:
- The feature still must not break the game in any way.
- While it might "bend the rules", the feature still shouldn't break the design intent of the game.
- The feature should be non-critical content. The game can be played without it.

## Review and Critique 
- Having other people examine your work can be an anxiety inducing. This document exists to help remove some of the pain by keeping things focused on design rather than personality.
- If discussions drift into bad process, consider referring to design points in this guide to get things refocused on the project instead of clashing personalities.
- Remember, we all have bad days and limitations.

Good process:
- focuses on the design
- is iterative
- is prepared for mistakes
- is open to feedback
- communicates on specific details
- acknowledges effort
- acts with compassion and persuasion
- distinguishes personal preference from good design

Bad process:
- focuses on personality
- is resistant to changes
- is perfectionistic
- is closed to feedback
- communicates vague liking or disliking
- attacks shortcomings
- acts with pride and domination
- confuses personal preference for good design

## Quality Standard
- Exile aims to reach a high standard, with the limitation that it's made by amateurs in their spare time for the joy of it.
- The game might be eternally unfinished, and rough because of that, but hopefully never clumsy or badly done. New features naturally start out a bit rough. That's okay. But this is different from being sloppy or derivative.
- Make something you can be proud to share with the world. This is a place to experiment with things you might never get to do elsewhere.


## Places to Get Inspiration
- Exile might be described as Minecraft meets Rimworld meets Darksouls.
- Minecraft in the sense of being an openworld sandbox voxel game.
- Rimworld in the sense of science fiction survival on an alien planet, with a tendency towards tragi-comic disaster where enjoying the story is just as important as building stuff.
- Darksouls in the sense of high difficultly, attention to artistic value, and a willingness to engage with a darker subject matters.
- Exile includes a lot of realistic historical technology. Historical re-enactment, archaeology, anthropology and similar are worth checking out.
- Exile's natural world is scientifically informed, based on the original developer's own expertise in ecology, plus inspiration from landscape painting, nature documentaries and similar.
- Science fiction and fantasy are great sources of ideas. Exile is sci-fi, and often uses fantasy aesthetics.
- The themes of tragedy and exile are inspired by ancient Greek plays, and real history.
 
## Intended Audience
- Age range: older teen to adult. The game might contain mature content and themes, but we are not interested in the "bad taste" types of mature content that typically cause controversy (e.g. extreme gore, pornography etc).
- Culture/Language: global, with translations where possible. A common project does require a common language. Lacking anything better, the preferred language for development is English. We acknowledge this creates unwanted difficulties for non-English speakers. 
- Player skill level: sufficiently accessible to beginners for casual play, but optimized for experienced players.

## Core Design Elements
- These are the combination of mechanics which make Exile what it is, and not some other game.

### *Minimal Core:*
- The core Exile experience is defined by at least these three aspects: Survival + Creativity + Sense of Accomplishment
- If an area of the game is lacking this core, then it's drifting from what Exile truly is about.

### *Core Mechanics:*
- The minimal core exists within, and is created by, a set of core mechanics.

What do you do // Why is it in the game (e.g. emotional effect)
- Environment: explore and interact with the world. // Sense of wonder and discovery.
- Physiology: maintain your health or die // Constant high stakes
- Building: make things and access new crafts // Creativity and problem solving
- Character: role-play as a specific person // Meaning and purpose
- Dynamism: prepare for and respond to changes. // New challenges


### *Feature Creep:*
- It can be tempting to add entirely new mechanics to make the game more interesting. However, this can turn into "feature creep". The new features might not actually add much, and mostly just increase burdens for performance/maintenance/player learning, and dilute the core experience.
- For example, adding a "Return Home" phase of the game requiring conquering a city would be feature creep. That idea is better as an independent game (and it might be a great game too!).

### *Depth*
- True depth comes from adding interaction between core mechanics. 
- Core Mechanics Interaction = Emergent Possibility Space
- The core mechanics interact so that emergent experiences come out of them (both in terms of actual actions, and the emotions or "feel" of the experience). The more these mechanics interact the more possibility of depth exists. A wider possibility space of player experiences. 
- For example, Building can influence Physiology (e.g. building shelters to rest in), and Physiology can influence Building (e.g. running out of energy to build shelter). This sets up a feedback loop of interacting mechanics generating interesting experiences and player actions. (e.g. the player runs out of energy, so can't build shelter, so builds a fire instead, then accidently sets themselves on fire, then it rains and the fire goes out, and because they are now wounded they soon freeze to death. Without the interactions this wouldn't happen).
- All the core mechanics combined gives the game it's underlying soul. Wonder at the environment + Meaning from character + High stakes from physiology + Creative accomplishment from building = the feeling you get playing Exile specifically, rather than some other game.

### *Core Mechanic Combinations:*
Rather than only coming up with new mechanics, consider ways of deepening interactions for the core. We currently have gaps and weak spots for some.
- Enviro + Enviro = e.g. weather changes plant growth, animals eat each other (wonder + wonder = fascination)
- Enviro + Physiology = e.g. survive adverse conditions (wonder + fear = awe)
- Enviro + Building = e.g. landscaping (wonder + creativity = playfulness)
- Enviro + Character = e.g. bones of dead (wonder + meaning = spirituality)
- Enviro + Dynamism = e.g. sea ice forms in Winter (wonder + new challenges = anticipation)
- Physiology + Physiology = e.g. lack of rest worsens diseases (fear + fear = terror)
- Physiology + Building = e.g. create survival aids (fear + creativity = accomplishment)
- Physiology + Character = e.g. ??? (fear + meaning = tragedy)
- Physiology + Dynamism = e.g. Winter weather is hard to survive (fear + new challenges = anxiety)
- Building + Building = e.g. make smelter to access iron crafts (creativity + creativity = design)
- Building + Character = e.g. build a tomb for the dead (creativity + meaning = expression)
- Building + Dynamism = e.g. house struck by lightning burns down (creativity + new challenges = experimentation)
- Character + Character = e.g. ??? (meaning + meaning = profundity)
- Character + Dynamism = e.g ??? (meaning + new challenges = insight/revelation)
- Dynamism + Dynamism = e.g. erupting lava gives warmth in Winter (new challenges + new challenges = chaos)

## Design Principles
- These principles exist to serve as guides for what is and is not good fit.
- A well designed feature should be consistent with these principles.
- Features also need to be consistent with Exile's core mechanics, lore, values, and aims.

## Design Principles - Welfare

### *Player Welfare:*
- The wellbeing of players is the number one priority, and the core goal of the game. At a minimum do no harm.

### *Virtual Training Arena for Life:*
- This game is about making hard choices in an safe space where failure doesn't matter. The hope is that you should learn something about yourself.
- The skills required to succeed in the game should match the skills required to live well in general (e.g. setting priorities, self-knowledge, creativity, etc).  

### *Dark Souls Approach to Mental Wellbeing:*
Dark Souls is famous for helping people overcome depression. This is achieved by elements such as:
- High difficultly giving players a sense of accomplishment. The confrontation with the struggle, and learning to overcome can provide a sense of self-efficacy, which is a necessary part of good mental health.
- Beauty amidst pain and struggle. Not everything is bad or evil. In fact much remains wonderful, even in the darkest times.
- Acceptance for failure and brokenness. Two of the biggest fears people have are rejection and failure. Exile starts out by rejecting you, after that you fail repeatedly. You can learn to accept and overcome these fears.

Compare this with games based on wish fulfilment. Success is easy, or everything is happy. This provides escapism, but only by contrasting with the difficulties of your real life. In Exile you are presented with problems worse than your real life, then you discover you can overcome them. 

### *No Toxic Heroism or Excessive Wish-fulfilment:*
Many games are built around the belief that people want to experience a god-like power fantasy of violent domination. Exile is not that game. This means: no Hero's Journey, no Chosen Ones, no singlehandedly saving the universe. You're character is a small thing in an overwhelming world of vast size and age.
- Thinking you are a god should backfire in this game. The entire world-story lore is about why pursuing power for power's sake might be a bad idea.
- Exile is about growth via overcoming struggle, not "Strength" versus "Weakness".
- Violence and domination probably are not the answer, or at least will have serious consequences.
- Exile does not follow the "Prison Island" trope where hardened criminals fight to the death. Exile is about the tragedy of being outcast. Many of the characters did nothing meaningfully wrong.
- Player power is limited. The sense of accomplishment is measured by the difficulty of achieving the goal, not the size of the reward. e.g. compare a game quest that makes you King for massacring a few goblins, versus the feeling Exile gives you for finally making your first clay pot without dying.
- Despite Exile leaving the player to survive alone, the fantasy of the rugged individual who can successfully do it alone should be shown to be problematic by just how often you end up dead, dying, or diseased.

For more understanding of this perspective, read "The Carrier Bag Theory of Fiction" by Ursula K Le Guin. She makes this anti-heroism argument in an Exile relevant way.

### *Amor fati (love fate):*
- Central to good mental health is learning to accept reality (e.g. as in mindfulness meditation).
- The game might not give you what you wanted, but perhaps you will discover things you didn't know you needed. You don't choose your hand, you choose how you play it. You must learn to accept who your character is, and their tragic fate. 

### *Multiplayer Favours Cooperation Rather Than Conflict:*
- While people are free to play as they please, consistency with the rest of the design is likely to push things towards cooperation.
- Multiplayer can be a means of achieving the game's core aim by providing a space for community and friendship. Therefore multiplayer should aim to be a positive and supportive social experience.

### *Best Practice on Sensitive Subjects:*
- Exile aims to follow best practice with sensitive and controversial subjects, admitting that its often a difficult process of self-education to do so.

## Design Principles - Choice

### *Emphasis on Difficult Choices & Problem Solving:*
- The player should be thinking more than mindlessly grinding. When the game drifts into mere grind it is drifting away from Exile's minimum core and will struggle to achieve any of its objectives.

### *Choice-focused Realism:*
- The game world should make you behave how you would in the real world.
- Game content should be aim to be scientifically and historically accurate, but with the focus always on how the player interacts with that content. The player choices should be realistic.
- This is not to be confused with pedantic realism. e.g. having 50 varieties of coal, to match every scientifically possible variety of coal.
- In contrast to pedantic realism, choice-focused realism would emphasize the fact that coal is non-renewable, so compared with using wood you need to make different choices.

### *Choice Means the Freedom to Choose:*
- Real ethical decision making requires confronting ethical ambiguity. That means no Black-n-White or simplistic Good vs Evil morality.
- Real choices require real options with real consequences. The player can to do stupid, wrong, even unethical things. e.g. drugs can be appealing, but you can also overdose and die. Don't forget the inverse. The player should have the freedom to do intelligent, correct, and ethical things too.

### *Multiple Possible Strategies:*
- The game can be played "successfully" many different ways.
- "Success" is left up the player to define.
- The player should seldom feel trapped into following one particular path.

### *The Edge of Impossible:*
- Difficulty should be at the edge of success and failure. Not so easy that it gets boring, yet not so hard that you give up. The correct choice should not always be obvious.
- Pacing does require some areas of the game are free from this high difficulty. This gives the player space to recover for the next challenge.
- What counts as difficult varies between players and skill levels, so the game requires a spread of challenge in different areas.

### *Experimentation and Discovery:*
- Mastering survival and technology is never about levelling up it's about figuring out how the world works. Exile contains secrets to discover and problems to solve. 

### *Appropriate Technology Choices:*
- The player tries to choose the best technology for the situation, rather than grind up a linear tech tree.
- Naturally some items depend on simpler items, so progression does exist, but that progress is itself a choice.
- Don't confuse this type of progression for the inbuilt levels many other games use (stone age -> bronze age -> etc).

### *Intrinsic Motivators Over Extrinsic Motivators:*
- The player should be primarily engaged internally (e.g. creativity, exploration, fun, joy, meaning etc).
- External engagement (e.g. rewards, points, access to items, new levels etc) are okay, but they take second place and are problematic if they conflict with intrinsic motivators (which they often do). 


## Design Principles - Nature

### *Respect for Nature & Environmental Issues:*
- Exile's original designer was a trained as an ecologist, so Exile has ended up with many environmental aspects deeply embedded within the design. Exile could be considered a work of Eco-fiction (ecological fiction, the genre that includes Solarpunk).

### *Relating to a Living World Rather Than Fighting Against a Hostile World:*
- The player should learn to relate appropriately to natural elements rather than simply fight to control them. Nature is not hostile as such, rather it is alive with interests of its own. This is a subtle but simple distinction.

For example, we can imagine what nature might say if it were human. This sounds strange, but demonstrates the point:
- A thorn bush might say, "Touch me and I'll cut you." Appropriate relation = don't touch it.
- A fruit tree might say, "Care for me and I will care for you." Appropriate relation = care for it.
- The seasons might say, "Respect me and I will feed you, ignore me and I will destroy you." Appropriate relation = respect the seasons.

Even when these relationships are negative towards the player this is not the same as a hostile world that wants you dead.

### *No Cannon Fodder Wilderness (or similar):*
- Many games use nature to merely throw monsters at the player so the player can kill them and feel powerful. Such games might stock the forests with absurd numbers of murderous suicidal wolves, meaning every journey requires killing dozens of wolves. Exile is not that game.
- Nature is not always cute and cuddly, but very little in nature is ever truly out to get you. Exile intends to reflect that reality.

## Design Principles - Ease of Use

### *Clarity:*
- The player should be trying to figure out the world of Exile, not the user interface of Exile!
- Both developers and users often benefit from documentation, tutorials, and guides.

### *Support for Modding and Customization:*
- You can't please everyone. Ideally the code should be set up in a way that makes it easy for people to create mods, modify, or adjust things.

### *Complexity Rather than Complicatedness:*
- Sheer quantity of stuff tends to make a game confusing rather than good.
- A limited set of content that behaves in interesting ways is far better than mere quantity (refer to Core Design Elements section).

### *Accessibility:*
Any one should be able to play this game if they want. That means:
- Free and Open Source values (e.g. no price, source code available)
- able to run on low-end hardware
- support for language translations when possible
- support disabilities when possible

## Design Principles - Artistic

### *Avoid Clichés, Stereotypes, and Overused Tropes:*
- Exile is a place to have fun making something unique rather than just rehashing worn out ideas.
- Certain things are massively overdone in media (e.g. the "Fantasy = Medieval Europe" trope). If they're going to be in Exile they need a unique Exile twist.

### *Function First:*
- Few things in Exile are purely decorative. Even things like decorative statues serve a gameplay function, in that their existence is an opportunity for the player to make choices.
- Aesthetics often requires being loose with this principle (e.g. many biome grasses are functionally very similar).

### *Meaning:*
- Exile exists in its own world. Names, characters, objects, etc, are chosen to build a consistent world which feels like a real place with a real history.
- Character and world story add significance to the world.
- The player should have the tools and abilities neeeded to add their own meanings to the world.

### *Dynamism:*
- The world is alive. It will act and you must respond (and vice versa).
- Stories and challenges emerge out of the world itself, whether you are ready or not, rather than being rigidly scripted.

### *Artistic Value:*
- Exile aims to be an artistic experience (like a film or a sculpture), not only a game (like chess or football). The entire medium of gaming is still immature and finding itself in this area, so be prepared to experiment!

## Lore and Story

### *Genre:*
- The underlying core is science fiction. Hard scifi where feasible. Softer scifi is okay when dealing with more extreme speculative elements e.g. teleportation.
- The surface experience presented to the player is a more ambiguous fantasy-scifi world. In-world characters might believe in magic. Fantasy tropes might be used, but their underlying core would be science fictional. e.g. supernatural elements could exist, but there should be at least the possibility that a scientific explanation exists.
- Some players might choose to interpret the game as being entirely fantasy (but it would be up to mods if they wanted to push it all the way).

### *Style:*
- Narrative is mostly open and ambiguous, left to the player's own interpretation and imagination. As with the ambiguous scifi-fantasy aspect, this allows a diverse range of players to have very different experiences of the game.

### *Tone:* 
- The subject matter is fairly dark, but being a block world it's hard to take the game overly seriously.
- Exile is open to being light-hearted in tone when appropriate, in combination with the inherently darker aspects of the game. e.g. some Exile character stories are fairly ridiculous, and deaths often come from having done something idiotic.

### *Setting: The Ancients*
Thousands of years ago a powerful civilization once existed. They are known as the Ancients.

The Ancient's ruling ideology pursued power above all else, with the ultimate goal of transcending physical reality itself. They believed the physical world was corrupt, compared to a perfect disembodied state of pure rational consciousness capable of shaping reality at will. Nature, and even people, were simply resources to be used in the pursuit of this ultimate power. 

The Ancients never saw a megaproject they didn't like.

In the real world people have suggested ideas like using thermonuclear bombs to dig the Panama Canal, solving climate change with billions of space mirrors, and draining the Mediterranean sea for farmland. The Ancients looked at ideas like that and said, "Genius! Let's do that!" Then they actually did it.

This resulted in great power, and a series of self-inflicted catastrophes. Each catastrophe was "solved" by yet another grasp for ultimate power, fixing the first problem by creating another self-inflicted catastrophe. All their problems culminated in a mega-disaster, leading to the abandonment of the city.

The survivors were scattered, transporting themselves via The Gateways to various far off locations. The destruction of the city was an event so traumatic it has haunted every surviving culture for thousands of years.

The Undercity and various ruins are what remains. Littered there are the remnants of the Ancient's attempts at ultimate power. They might have tried things such as:
- Mining to the centre of the planet
- Super tall skyscrapers
- Teleportation
- Weather control
- Genetic engineering (including on humans)
- Synthetic biology
- Nanotechnology
- Cyborg implants
- Autonomous robots
- Artificial Intelligence
- Virtual reality
- Mind uploading
- Mind control and mind reading
- Panopticon surveillance
- Space elevators
- Space colonization
- terraforming
- Nuclear power
- Weapons of mass destruction
- Total war
- Totalitarianism
- Eugenics
- Mass slavery
- Genocide
- Irrational actions based on conspiracies, delusions, or fanaticism
- Coups, Rebellions, and Civil War
- and much more...

Despite their destructiveness the Ancients would also have done many good things. The Ancient's society would have also included many varied factions resistant to the dominant ideology.

### *Setting: Name of the Ancient's City*
Currently this is based on corrupted versions of the word Ozymandias (from the poem by Percy Shelley).

>"...And on the pedestal these words appear:
 'My name is OZYMANDIAS, King of Kings.'
Look on my works ye Mighty, and despair!
No thing beside remains.  Round the decay
Of that Colossal Wreck, boundless and bare,
The lone and level sands stretch far away."

While the mood is appropriate, it might not make much sense to explicitly identify the city as called Ozymandias.

### *Setting: The Exodus Cultures*
- The exodus resulted in most former residents of the city losing access to their advanced technology.
- For example: imagine if a modern passenger plane crashed on an island - what skills would those people have? What knowledge? What society would emerge after a thousand years? Now imagined this repeated several thousand times, spawning tens of thousands of new societies.
- For our purposes the Classical Era (e.g. Rome, Greece, Persia) is a reference regarding technology. However, our imagined societies might also retain knowledge, skills, and even artifacts much more advanced.

### *Setting: Gateways*
- This is how the exodus left the city, and how exiles are sent back. It is a ultra-powerful form of teleportation.
- The Gateways were created for the same reasons people fantasize about colonizing Mars because they think Earth is doomed. In this world people actually tried to do something like that. The Gateways create wormholes (or something similar) to other planets, or maybe even space stations or other exotic locations. 

### *Setting: Non-exodus Cultures*
- The Ancient's city in the game is just one city. A civilisation of this sophistication could have controlled an entire planet.
- This particular city was the capital of an empire. Given their power hungry behaviour they kept most other societies in a weakened and subservient position. After the various planetary catastrophes and the disintegration of the empire these other societies have been focused on their own internal problems.
- These societies have much better technology than exodus-cultures, but not as advanced as the empire that once ruled over them.
- These cultures do not exile people to the city. To them it is a place to avoid (comparable to the Chernobyl exclusion zone). The entire thing is a forbidden zone. Occasional adventurers might risk a visit. Some people may have tried to heal and remediate this location, and still be trying to do so, though they clearly have not succeeded.
- Non-exodus cultures could plausibly show up in the game, but generally they stay as far away as possible.

### *Plot & Character: Exiled to the Land of Catastrophe*
- The Ancients had an established tradition of using exile as a punishment.
- After the exodus, the Gateways provided a convenient solution for continuing this practice of exile. People got pushed back through the Gateway, to the worst place anyone could think of.
- People get exiled for many reasons: crimes, rebellion, to eliminate political rivals, to persecute ethnic and religious minorities, etc. Some exiles are legitimately scary evil people, but most are not.
- Most exiles don't live long. The harshness, and the legacy effects of the Ancient's disasters have so far prevented exiles from building a new society.

The landscape of the game is the result of various interacting histories:
- nature itself
- the decaying ruins of the Ancients
- many centuries worth of exiles
- the surrounding societies efforts to isolate, explore, or heal the area

Character stories might find their conclusion in any one of these aspects. The most obvious is the possibility of getting out alive. e.g. by walking to the edge of the map, getting teleported back through the gateway, going into space (via a spaceship, or space elevator), etc. Many other story types could be possible using the other aspects e.g. joining adventurers, trying to heal the land etc.


### *Theme: Tragedy*
The overarching story is tragedy. The Ancient's are a tragedy. Individual exiles are tragedies.

The core of tragedy is an otherwise admirable person who has a flaw which brings about their downfall. It involves situations such as these:
- Pursuing the wrong thing in the right way.
- Pursuing the right thing in the wrong way.
- Pursuing one good thing by neglecting another good thing.
- Facing a dilemma where both options lead to failure.

Exile is very close to being a post-apocalyptic story about crime and punishment. That is not the intention. That kind of story is about evil getting its just reward. Please note, tragedy is very different than that.

### *Theme: Overcoming Trauma*
- A survival game is inherently about dealing with traumatic situations and finding ways to cope and look after yourself.
- Exile adds onto this the multiple other traumas, making trauma a central feature of the game-world's story. The player character has suffered some tragedy, leading to the trauma of total social abandonment. The Ancient's self-destructive philosophy is itself the kind of ideology which gets born out of trauma. The surviving societies are traumatized what the Ancients done to them. Even the landscape itself is traumatized.
- It's an interesting coincidence that at least one trauma focused form of psychotherapy (Internal Family Systems) refers to wounded parts of the self as "exiles", with the aim being to bring them home, accept and heal them.

## Map Context (Climate, Geology, Lifeforms):
- The extreme climate is consistent with somewhere very far inland and continental, like Mongolia. Extreme seasonality suggests high latitudes, or a planet with an extremely tilted axis of rotation (or some similar effect).
- The sedimentary rock layers are based on places like Cape Kidnappers in New Zealand. These represent young rocks (a few million years old) laid down during periods of varying sea levels, then uplifted and eroded.
- Highly erodible and porous rock full of caves would explain the lack of surface water - rainfall would quickly end up underground (as is typical in Karst landscapes), and accumulate where it hits impermeable rock.
- The hard rock layers represent a plausible basement rock of great age (10s to 100s of million years old).
- Geologically speaking, the map is consistent with an area that was once an inland sea, which has been uplifted leaving behind only salt lakes. But, given the Ancient's love of megaprojects who knows what might have been done to this landscape.
- The volcanoes suggest the area has become a volcanic field after the Undercity was built, or is even starting to undergo catastrophic Flood Basalt volcanism (the kind associated with mass extinctions) which would one day bury the entire landscape under several kilometres of basalt.
- The lifeforms represent the kind of life that might reclaim an area after human abandonment. It is a damaged and recovering ecosystem, and might include feral or even genetically engineered species.


## Map Areas
- Surface World: the ordinary wilderness. Harsh to the unwise, abundant to the experienced. A few signs of prior habitation might be found, but it is mostly wild.
- Ancient City: A mysterious, awe inspiring and dangerous place. Should feel like *The Zone* from *Roadside Picnic* by the Strugatsky brothers, or like Chernobyl if explored by a cave man, or like the underground machine city of the film *The Forbidden Planet*. This is a place of high risks and high rewards, of follies and greed, of madness, of darkness, and of grandeur. Enter at your own risk.
- Deep Underground: Extremely hot. The map gets deep enough to reach the edge of the Earth's mantle (although this planet could differ).
- High Altitude: Very cold. High enough to reach the edge of  Earth's atmosphere, but not space proper (although this planet could differ).


## Biomes

### *Biome Axis*
In general:
- Humidity divides major ecosystem types between abundant and hostile.
Rich areas are wet, lifeless ones dry. e.g. Forests (wet), dunelands (dry).
- Heat divides ecosystem subtypes between dense and open.
Dense areas are cold, open are hot. e.g. woodland (hot) vs forest (cold).
- Altitude divides main biomes into Coastal, Lowland, Upland types

### *Main Biome Categories:*
- Forests
- Wetlands
- Grasslands
- Barren lands
- Highlands
- Coasts
- Salt lakes
- Underground

### *Full Biome List:*
01.	Coastal Forest
02. Coastal Woodland
03. Lowland Forest
04. Lowland Woodland
05. Upland Forest
06. Upland Woodland
07.	Swamp Forest
08. Marshland
09. Coastal Shrubland
10. Coastal Grassland
11. Lowland Shrubland
12. Lowland Grassland
13. Upland Shrubland
14. Upland Grassland
15. Coastal Barrenland
16. Coastal Duneland
17. Lowland Barrenland
18. Lowland Duneland
19. Upland Barrenland
20. Upland Duneland
21. Highland
22. Highland Scree
23. Highland Rock
24. Sandy Beach
25. Silty Beach
26. Gravel Beach
27. Sandy Coast
28. Silty Coast
29. Gravel Coast
30. Shallow Water
31. Deep Water
32. Underground
33. Deep Underground
34. Mantle


### *Forests & Woodlands:*
- Easy part of the map. Abundant resources, shelter, and food.
- A place of peace and calm, or mystery and enchantment.

### *Wetlands:*
- Abundant in specific resources, but with survival difficulties.
- Enchanted, mysterious, disorientating.

### *Shrublands & Grasslands:*
- Dominant biome. Moderate difficulty. Occasionally abundant, occasionally hostile.
- Open and inviting, or sometimes overwhelming and vast.

### *Barrenlands & Dunelands:*
- Hard part of the map. Scarce resources.
- Hostile, intimidating, overwhelming.

### *Highlands:*
- Extreme difficulty. High altitude barren areas. Almost no resources.
- Awe, fearful.
- (note: not snowy, nothing in this game gets high enough to remain permanently frozen due to altitude)

### *Beaches, Coasts, and Salt Lakes:*
- Abundant in specific resources, but with survival difficulties.
- Peaceful, enchanted, mysterious, disorientating.

### *Underground:*
- Mostly filled with Undercity, rather than biomes.
- Bottom of the map is unsurvivable lava.

## Naming Conventions for Nature
Exile is not Earth. Plants and animals are unique species with unique names.

Many of the names were adapted from world languages (often by typing random words into online Translators), or at least mimic the sound structure of certain languages. Things got jumbled up, but it roughly started out this way: 
- grasslands: African
- marshlands: Celtic
- barren lands: Central Asia
- forests: S/SE/E Asia
- underground: India
- water life: Polynesian

Geology, soils etc uses standard names (e.g. limestone, clay) as such processes are the same regardless what planet you are on.  



## Art Style
- Try to match any art with the existing art.
- Most textures are 16x16 pixels.
- Complex shapes are typically done with nodeboxes rather than models.
- The intended artistic vibe might be described as "moody", but this is very subjective.

Biomes typically follow a color scheme (more or less), with one dominant color, and perhaps one or two minor colors.
For example...
- dunelands: orange
- barrenlands: pale brown
- grasslands: yellow
- shrublands: green
- marshlands: red
- swamp forest: black and red
- Undercity & Artifacts: blue, green, and gold


## Controversial and Sensitive Subjects

Some subjects:
- are associated with strong emotions and/or strong beliefs
- touch on matters of pain, trauma, and abuse
- touch on matters of discrimination or injustices
- commonly trigger aggressive arguments, proselytizing, condemnation, hatred, and personal attacks
- are associated with serious real world consequences

If a feature touches on such subjects then it may need more careful attention than normal. Community discussions also need to be aware of the tendency for such conversations to spiral out of control.

Hopefully Exile can become a game that deals with difficult subjects successfully.

Because it's better to have the argument in a self-aware manner, rather than painfully rehash the same debate every time the subject comes up, here is Exile's current approach to some sensitive subjects.

### *General Points:*
- Exile must necessarily support its own core values, and oppose any views that contradict those values. However, Exile does not need to be didactic or evangelistic about this. Exile needs such values to exist, but the game does not need to be about those values.
- Exile does not exile people, unless they are truly damaging the ability of the community to function. Indeed the whole game is about why getting booted out or persecuted sucks. Diverse perspectives are welcome. Listen with respect. Agree to disagree. Be compassionate.
- Fiction can be a place of moral and philosophical exploration. It's not always necessary to pick a side. A controversy can be represented within the game without having to say who is right.
- Some vexed issues can be easily addressed via settings allowing a feature to be turned off e.g. disable gore, or disable drugs. If people can be accommodated this way, it makes sense to do so, as long as that setting is not itself problematic e.g. disable non-white races.
- Try to be aware of the limits of your own knowledge and experience. Sensitive subjects get portrayed badly in media when people base them on clichés and stereotypes rather than real insight.
- Exile cannot be all things to all people. Always avoiding difficult subjects or trying to accommodate every belief will result in something bland and soulless. Sometimes we have do have to pick a side. Great art typically has a strong vision, or at least a strong willingness to explore the questions.

### *Representation of Diversity:*
- Exile's characters are aimed to reflect the true diversity of human experience. Whatever one's personal opinions, the world does include a wide variety of ethnicities, beliefs, gender and sexual orientations - they are appropriate to include in the game.
- Many groups have historically been excluded from representation in media, including developers and players of Exile. Diverse representations matter: seeing yourself represented in media is important. It helps people form a sense of self, identity, and belonging.
- Exile aims to portray people, beliefs, and cultures accurately, fairly, and compassionately. Many groups have historically been subject to offensive stereotyping in media, including developers and players of Exile. Please be aware of common clichés and stereotypes (e.g. Female = Hysterical, or Mental illness = Violent) so as not to repeat them.
- Even if you disagree with a particular viewpoint, consider it a case of "Steel Manning" the opposition if such a view is included in the game. It is possible to represent something without promoting it. Even the Bible includes Satan without being pro-Satan.
- Exile is not Earth. Therefore no real world cultures, religions, or politics are represented; though analogous things might plausibly show up. e.g. A monarchy, but not the Queen of England.

### *Trauma:*
- Anything involving trauma must not be trivialized (e.g. suicide, abuse, rape, etc). The game will be played by people who have experienced such traumas, including people who are actively struggling with that experience while playing. A game can successfully deal with traumatic issues, but that means doing so consciously and sensitively.
- Basic content warnings for common issues are useful to some people. That's a good reason to include them if necessary. No one gets harmed by basic warnings, people do get harmed by getting into something they weren't ready for.
- Interactive art has the power to create new experiences that might reinforce, trigger, or disconfirm (potentially healing) the distressing psychological patterns that are created by trauma. Therefore it's important to be aware of what patterns of experience the game does create for the player, especially regarding threat and strong emotions. The player needs to be able to experience competency, healthy coping, the ability to create and feel safety.

### *Spirituality & Philosophy:*
- Being science fiction Exile is committed to a scientific worldview, at minimum.
- The core value of respecting diversity makes it problematic for the game to either promote or denigrate particular religions. However, some worldviews do directly conflict or align with the game's core values and outlook. Exile cannot be all things to all people.
- Spirituality & philosophy are directly relevant to the game's core aim. Finding meaning is an essential part of life. The game doesn't need to be about spirituality, rather if spiritual subjects come up then they need to be treated with nuance and depth to meet that core aim.

### *Politics:*
- The core value of respecting diversity makes it problematic for the game to either promote or denigrate particular political positions. However, some worldviews do directly conflict or align with the game's core values and outlook. Exile cannot be all things to all people.

### *Racism:*
- Lore includes human genetic modification, or even things like societies that practice eugenics. This means different ethnic groups might have noteworthy different genetic attributes. Care is needed so that this is not pro-eugenics or pro-racism, rather an exploration of what world it would create if people actually did this to each other.

### *Drugs and Alcohol:*
- Exile includes drugs without being either pro-drug nor anti-drug. The player is free to make up their own mind. The game will give them realistic consequences whatever their choice.
- As a non-critical feature settings could easily turn this off for people who prefer that.

### *Mental Illness:*
- Character psychological states are difficult to represent in a first-person game for practical reasons.
- Be aware of the potential for accidently trivializing serious conditions. 

### *Gaming Addiction"*
- Many people have problems with excessive gaming. Exile should be designed in a way that minimizes that issue, or at least doesn't worsen things.

### *Suicide (and self-harm):*
- This game might be played by someone who is actively suicidal or experiencing suicidal thoughts. The game needs to be a safe place for them while they manage that problem.
- Game balance should never make suicide an optimal strategy, nor have rewards that can only be achieved via suicide.
- Anything that is not the player consciously deciding to end a character's life should not be framed as suicide. e.g. "choose new character" NOT "commit suicide"
- Detailing suicide methods is problematic (e.g. allowing the player to make a noose and hang themselves). A suicidal person may attempt to use such a method for real. 
- Suicide should not be glamorized as something easy, painless, or desirable (the "Werther Effect"). If suicide is to be deliberately portrayed it should show the reality - the attempt is often slow, painful, and results in long term injury instead of death. Better still is to portray characters overcoming suicidal impulses and achieving recovery (The "Papageno Effect").

### Misc:
Many any other subjects might arise, and need more careful attention one day. e.g.
- Homosexuality and Gender Issues:
- Offensive Language:
- Violence and Gore:
- Cannibalism:
- Sex & Nudity:
- Abortion:
- Sexual Abuse:
- Child Abuse:
- Addiction (in general):
- Animal Cruelty:


## Programming and Code

### *How to Create Content in Minetest:*
Refer to [Rubenwardy's modding book for a guide](https://rubenwardy.com/minetest_modding_book/en/index.html)

### *Clarity:*
- The code base needs to be understandable to diverse people, many of whom are amateurs.

### *Hardware Requirements:*
- Ideally Exile should be playable of low end computers. As a free game many people are here because they do not have access to expensive equipment.
- However, Exile also contains some ambitious features which does make it heavier than some other Minetest games.
- Each new addition puts a burden on performance, maintenance, and potentially on player ease of use. We can't add everything. Much of the performance budget has already been spent, or will be needed for future essential content. Don't Blow the Budget!
- Efficiency and performance improvements are greatly appreciated.

### *Compatibility:*
- Compatibility breaking updates are acceptable while Exile is still in early development (preferably including legacy support).
- However, as the player base grows and the game gets more stable breaking things will become more problematic.


## Module Directory

- animals: animal mobs
- artifacts: Undercity items
- backpacks: api for bags
- bed_rest: api for beds
- bones: api for bones
- canoe: api for small boats
- climate: weather and temperature system
- clothing: api for clothes
- crafting: api for crafting system (shared Minetest content)
- creative: enables creative mode
- doors: api for doors
- exile_env_sounds: environmental sound effects
- grafitti: api for paint
- health: the health system
- inferno: fires and flammability
- lightning: thunder and lightning
- liquid_store: api for water vessels
- lore: character and story system
- mapgen: biomes and decorations
- megamorph: mapgen Undercity structures
- minimal: core essential and commonly used code
- mobkit: mobs api (shared Minetest content)
- naturalslopeslib: stepped hillsides api (shared Minetest content)
- ncrafting: in world crafting functions e.g. soaking, baking
- nodes_nature: natural world blocks and associated processes
- player_api: player models etc (shared Minetest content)
- player_monoids: api for assisting with player physics (shared Minetest content)
- rings: mapgen spawns large ruined ring structures
- ropes: api for ropes and rope ladders
- sfinv: inventory api (shared Minetest content)
- spears: throwable spears api (shared Minetest content)
- stairs: slabs and stairs api
- tech: most player crafted items
- volcano: mapgen spawns volcanoes and lava tubes
- wielded_light: player holdable light effects (shared Minetest content)


 

