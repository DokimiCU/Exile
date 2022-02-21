
----------------------------------------------------------
--EXILE LETTER
--[[
sentence of exile.
Unique, randomly generated, for each "life".
 i.e. Respawn means starting as someone new

 Sets the scene for the game.
 Explains why you are there, and where "there" is.


]]


local random = math.random

----------------------------------------------------------
local judger = {
  --monarchs, etc.
  "King",
  "Queen",
  "Emperor",
  "Empress",
  "Exalted Ruler",
  "Majestic Leader",
  "High King",
  "High Queen",
  "Nobles",
  "Lords",
  "Duke",
  "Duchess",
  "Lord",
  "Most Highly Exalted Supreme Ruler",
  "Great Leader",
  "Golden King",
  "Jade Queen",
  "Prince",
  "Princess",
  "Regent",
  "Dictator",
  --officials
  "High Judge",
  "Tribunal",
  "Council",
  "Courts",
  "Presidium",
  "Law Giver's",
  "King's Justice",
  "Sheriff",
  --cults
  "Brotherhood",
  "Sisterhood",
  "High Priest",
  "High Priestess",
  "Great Prophet",
  "Anointed One",
  "God King",
  "Philosopher King",
  "Seers",
  "Sanctum",
  "Order",
  "Monks",
  "Priests",
  "Priestesses",
  "Enlightened Ones",
  "Great Sage",
  "Shaman",
  --tribal
  "Elders",
  "Wise Ones",
  "Clan Council",
  "Tribal Chiefs",
  "Great Chieftain",
  "United Clans",
  "Wise Man",
  "Wise Woman",
  --republic
  "Citizenry",
  "People",
  "Senate",
  "Consul",
  "Senators",
  "Assembly",
  "Chief Minister",
  --Geographic/polity
  "City State",
  "Empire",
  "Kingdom",
  "Principality",
  "Duchy",
  "Republic",
  "League",
  "Confederation",
  "Federation",
  "Alliance",
  "Coalition",
  "Nation",
  "Clan",
  "Chiefdom",
  "Tribe",
  "Monastic Order",
  "Merchant Republic",
  "Theocracy",
  --Military
  "Generals",
  "Champion",
  "Mighty Warriors",
  "Admirals",
  "Legion",
  "Commander",
  "Commandant",
  "Warlord",
  --rogues
  "Pirates",
  "Bandits",
  "Company",
  "Horde",
  "Liberators",
  "Destroyers",
  --freaky
  "All Seeing Eye",
  "Old Children",
  "Spectre",
  "Dragon King",
  "Seven Hands",
  "Imperial Phlogistonist",
  "Sacred Snake-god",
  "Eternal Pyramid",
  "Towering Tree",
  "Viridian Magister",
  "Thousand-tongued All-speaker"
}
-- exile-worthy crime
local crime1 = {
  "treason",
  "betrayal",
  "murder",
  "heresy",
  "blasphemy",
  "betrayal",
  "regicide",
  "conspiracy",
  "kidnapping",
  "corruption",
  "abduction",
  "subversion",
  "mutiny",
  "rebellion",
  "usurpation",
  "espionage",
  "sabotage",
  "treachery",
  "sedition"
}
-- flavour-text crime
local crime2 = {
  "leading the youth astray",
  "smuggling contraband",
  "vagabondage",
  "banditry",
  "piracy absent a letter of marque",
  "drunkenness",
  "sinful living",
  "rabble rousing",
  "inciting violence",
  "unspeakable acts",
  "that of which we shall not speak",
  "endangering the survival of our people",
  "causing the great tragedy that befell us",
  "refusing to partake in the sacred rituals",
  "shameless acts",
  "willful sloth",
  "preaching foreign gods",
  "gross vanity",
  "wickedness",
  "assassination of one who was high-born",
  "sharing secrets with foreign powers",
  "black magic",
  "witchcraft afflicting the fertility of our crops",
  "placing curses upon the innocent",
  "shameful conduct",
  "cowardice in the face of glory",
  "tax evasion",
  "abusing their station for personal gain",
  "desecration of holy relics",
  "subverting the course of justice",
  "robbery",
  "attempted murder",
  "grave robbing",
  "cruelty to animals",
  "eating forbidden foods",
  "embezzlement",
  "questioning the gloriousness of our ways",
  "bearing false witness",
  "deception of those who must be obeyed",
  "fraud",
  "fakery",
  "consorting with disreputables",
  "trespassing upon the tall tower",
  "poaching on royal lands",
  "impersonation of an official",
  "insulting our great leaders",
  "disobedience toward rightful authority",
  "dealing in harmful potions",
  "pickpocketing pious pilgrims",
  "possession of stolen goods",
  "rioting",
  "racketeering",
  "arson",
  "soliciting assassins to commit murder",
  "stealing livestock",
  "usury",
  "aspirations to tyranny",
  "improper ambition",
  "failing to venerate the gods",
  "vandalism",
  "abidingly uncouth comportment",
  "adopting barbarian customs",
  "speaking a forbidden tongue",
  "harassment",
  "forgery",
  "bribery",
  "forsaking our ancestors",
  "mocking all that is good",
  "stubborn foolishness",
  "persistent idiocy",
  "failure to exercise one's duty",
  "disregard of honor",
  "breaking the faith",
  "touching the forbidden",
  "seeking banned knowledge",
  "slander",
  "rejecting common sense",
  "failing to appear for military service",
  "hoarding food during famine",
  "befouling the good reputation of our people",
  "sowing discord among the populace",
  "sleeping with unclean creatures",
  "violating the chastity of the priesthood",
  "marrying outside their caste",
  "cheating at dice",
  "gardening without a permit",
  "stealing priceless art",
  "aiding an adulterous princess",
  "leading an unauthorised military campaign",
  "claiming that the world is round",
  "claiming that the world is not round",
  "promoting belief in gravity"
}
-- woe upon ye
local woe = {}
local genderSU = {male = "He"     , female = "She"    } -- subjective + uppercase
local genderSL = {male = "he"     , female = "she"    } -- subjective + lowercase
local genderOU = {male = "Him"    , female = "Her"    } -- objective  + uppercase
local genderOL = {male = "him"    , female = "her"    } -- objective  + lowercase
local genderPU = {male = "His"    , female = "Her"    } -- possessive + uppercase
local genderPL = {male = "his"    , female = "her"    } -- possessive + lowercase
local genderRU = {male = "Himself", female = "Herself"} -- reflexive  + uppercase
local genderRL = {male = "himself", female = "herself"} -- reflexive  + lowercase
local populate_woe = function(player)
	local gend = player_api.get_gender(player)
	return {
	  "May "..genderPL[gend].." name be forgotten.",
	  genderSU[gend].."is proscribed.",
	  "Never suffer"..genderOL[gend].." to return.",
	  "May the gods have mercy upon "..genderOL[gend]..".",
	  "Let none come to "..genderPL[gend].." aid.",
	  "May "..genderPL[gend].." weeping never cease.",
	  genderPU[gend].." life is forfeit.",
	  "It shall be as if "..genderSL[gend].." were never born.",
	  "May "..genderPL[gend].." end be swift.",
	  "May fortune forgive "..genderOL[gend]..".",
	  genderSU[gend].." shall live so long as "..genderSL[gend].." deserves.",
	  "Let the beasts do with "..genderOL[gend].." as they wish.",
	  "This is justice.",
	  "Let none dispute it.",
	  "May "..genderSL[gend].." wander fruitlessly.",
	  "May "..genderPL[gend].." bones bleach in the sun.",
	  "Thus we declare.",
	  "For we are merciful.",
	  "Let this be our kindness to "..genderOL[gend]..".",
	  "Begone, evildoer.",
	  "Thus do we cleanse ourselves.",
	  "We wash our hands of "..genderOL[gend]..".", -- Perhaps a reference to Pontius Pilate
	  "Fortune shall be "..genderPL[gend].." final judge.",
	  genderSU[gend].." is disowned.",
	  "We never knew "..genderOL[gend]..".",
	  genderSU[gend].." is cut off.",
	  "Let "..genderOL[gend].." live with the beasts.",
	  "Let the barbarians and wild folk have "..genderOL[gend]..".",
	  genderSU[gend].." is not fit for civilised lands.",
	  "Thus we ensure our security.", -- Perhaps a reference to Sheev Palpatine
	  "Only the righteous belong among us.",
	  "May "..genderSL[gend].." toil in vain.",
	  "So it is written. So it is done.", -- Now a reference to Cecil B. DeMille
	  "Even the dogs despise "..genderOL[gend]..".",
	  "We break no bread with traitors.",
	  "Let this be "..genderPL[gend].." journey to cleanse "..genderRL[gend].."."
	}
end
-- Various corruptions of "Ozymandias"
local exile = {
  "Ochymadion",
  "Aseymedius",
  "Eshenadios",
  "Uzymandeos",
  "Isemendion",
  "Zymenios",
  "Hocheemundis",
  "Otemanediate",
  "Oisemondas",
  "Wazymdis",
  "Wazhmindas",
  "Okaemanadia",
  "Caemandior",
  "Oshaemediash",
  "Otzakantas",
  "Archanatus"
}
-- What happened here? Lost to memory.
local mythic_terror = {
  "Great Calamity",
  "Unending Curse",
  "Ancient Curse",
  "Curse",
  "Catastrophe",
  "Great Dying",
  "Mythic Terror",
  "Night",
  "Darkness",
  "Scourge",
  "Sleeping Evil",
  "Fiery Breath",
  "Great Burning",
  "Great Bleeding",
  "Ancient Exodus",
  "Fearful Horror",
  "Evil Spirits",
  "Ghosts",
  "Haunting",
  "Rumbling Earth",
  "Burning Rock",
  "Great Folly",
  "Old Tales",
  "Evil Wind",
  "Bitter Waters",
  "Howling Dust",
  "Hateful Sky",
  "Great Confusion",
  "Lost"
}

local generate_text = function(player)
  local letter_text = ""

  local meta = player:get_meta()

  local judge       = judger[random(#judger)]
  local your_name   = meta:get_string("char_name")
  local origin_name = lore.generate_name(4)
  local polity_name = lore.generate_name(5)
  local cr1         = crime1[random(#crime1)]
  local cr2         = crime2[random(#crime2)]
  woe               = populate_woe(player)
  local your_woe    = woe[random(#woe)]
  local exile_land  = exile[random(#exile)]
  local terror      = mythic_terror[random(#mythic_terror)]
  local gend        = player_api.get_gender(player)
  --
  letter_text =
    "By decree of the "..judge..
    " of "..polity_name..": "..
    "\n \n "..
    "\n  "..your_name.." of "..origin_name..
    "\n \n "..
    "\nis hereby sentenced to exile for the crimes of "..
    "\n  "..
    "\n"..cr1..
    "\n    "..
    "\nand "..
    "\n  "..
    "\n"..cr2.."."..
    "\n \n \n"..
    "\n"..genderSU[gend].." is banished to the land of "..exile_land.."."..
    "\n  "..
    "\nThe land of the "..terror.."."..
    "\n  \n \n"..
    "\n"..your_woe

  return letter_text
end

--------------------------------------------
local function get_formspec(meta, letter_text)

	local formspec = {
    "size[9,11]",
  	"textarea[1.5,1.5;8.6,10.6;;" .. minetest.formspec_escape(letter_text) .. ";]",
    "button_exit[8.2,10.6;0.8,0.5;exit_form;X]",
  	"background[0,0;18,11;lore_exile_letter_bg.png;true]"}

	return table.concat(formspec, "")
end


-----------------------------------------------
local after_place = function(pos, placer, itemstack, pointed_thing)
  local meta = minetest.get_meta(pos)
  local stack_meta = itemstack:get_meta()
  local letter_text = stack_meta:get_string("lore:letter_text")
  if letter_text == "" then
    letter_text = generate_text(placer)
  end

  local form = get_formspec(meta, letter_text )
  meta:set_string("formspec", form)
  meta:set_string("lore:letter_text", letter_text)

end


---------------------------------------------
--Placeable Node
minetest.register_node("lore:exile_letter", {
	description = "Sentence of Exile",
	tiles = {"lore_exile_letter.png"},
  --inventory_image = {"lore_exile_letter_inv.png"},
	stack_max = 1,
  paramtype = "light",
  paramtype2 = "wallmounted",
  sunlight_propagates = true,
  walkable = false,
  drawtype = "nodebox",
  node_box = {
     type = "fixed",
     fixed = {-0.35, -0.5, -0.4, 0.35, -0.45, 0.4},
  },
  groups = {dig_immediate = 3, temp_pass = 1, flammable = 1},
  sounds = nodes_nature.node_sound_leaves_defaults(),
  after_place_node = after_place,
  preserve_metadata = function(pos, oldnode, oldmeta, drops)
     local letter_text = oldmeta["lore:letter_text"]
     local stack_meta = drops[1]:get_meta()
     stack_meta:set_string("lore:letter_text", letter_text)
  end,
})


--------------------------------------
minetest.register_on_newplayer(function(player)
  local inv = player:get_inventory()
  local letter = ItemStack("lore:exile_letter")
  local stack_meta = letter:get_meta()
  stack_meta:set_string("lore:letter_text", generate_text(player))
  inv:add_item("main", letter)
end)

minetest.register_on_respawnplayer(function(player)
  local inv = player:get_inventory()
  local letter = ItemStack("lore:exile_letter")
  local stack_meta = letter:get_meta()
  stack_meta:set_string("lore:letter_text", generate_text(player))
  inv:add_item("main", letter)
end)
