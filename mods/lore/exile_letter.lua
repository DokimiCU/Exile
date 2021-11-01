
----------------------------------------------------------
--EXILE LETTER
--[[
sentence of exile.
Unique, randomly generated, for each "life".
 i.e. Respawn means starting as someone new

 Sets the scene for the game.
 Explains why you are there, where "there" is.


]]


local random = math.random

----------------------------------------------------------
local judger = {
  --monarchs ec
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
  "Annoited One",
  "God King",
  "Philosopher King",
  "Seers",
  "Sanctum",
  "Order",
  "Monks",
  "Priests",
  "Priestesses",
  "Englightened Ones",
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
  "Imperial Phylogistar",
  "Sacred Snake-god",
  "Eternal Pyramid",
  "Towering Tree",
  "Viridian Majestar",
  "Thousand-tongued All-speaker"

}


--exile worthy crime
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


--flavour crime
local crime2 = {
  "leading the youth astray",
  "smuggling",
  "vagabondage",
  "banditry",
  "unathourized piracy",
  "drunkness",
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
  "assasination",
  "sharing secrets with foriegn powers",
  "black magic",
  "witchcraft",
  "placing curses upon the innocent",
  "shameful conduct",
  "cowardice",
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
  "deception",
  "fraud",
  "fakery",
  "consorting with disreputables",
  "trespassing",
  "poaching",
  "impersonation",
  "insulting our great leaders",
  "disobedience",
  "dealing in harmful substances",
  "pickpocketing",
  "possession of stolen goods",
  "rioting",
  "racketeering",
  "arson",
  "soliciting assassains to commit murder",
  "stealing livestock",
  "usury",
  "aspirations to tyranny",
  "improper ambition",
  "failing to acknowledge the gods",
  "vandalism",
  "uncouth manners",
  "adopting barbarian customs",
  "speaking a forbidden tongue",
  "harassment",
  "forgery",
  "bribery",
  "forsaking the ancestors",
  "mocking all that is good",
  "stubborn foolishness",
  "persistent idiocy",
  "failure to perform duty",
  "disregard of honor",
  "breaking faith",
  "touching the forbidden",
  "seeking banned knowledge",
  "slander",
  "rejecting common sense",
  "failing to appear for military service",
  "hoarding food during famine",
  "fouling the good reputation of our people",
  "sowing discord among the populace",
  "sleeping with unclean creatures",
  "violating the chastity of the priesthood",
  "marrying outside their caste",
  "cheating at dice",
  "gardening without a permit",
  "stealing priceless art",
  "aiding an adulterous princess",
  "leading an unathourized military campagain"

}


--woe upon ye
local woe = {
  "May their name be forgotten.",
  "They are outlaw.",
  "Never suffer to return.",
  "May the gods have mercy upon them.",
  "Let none come to their aid.",
  "May their weeping never cease.",
  "Their life is forfeit.",
  "It shall be as if they were never born.",
  "May their end be swift.",
  "May fortune forgive them.",
  "They shall live so long as they deserve.",
  "Let the beasts do with them as they wish.",
  "This is justice.",
  "Let none dispute it.",
  "May they wander fruitlessly.",
  "May their bones bleach in the sun.",
  "Thus we declare.",
  "For we are merciful.",
  "Let this be our kindness to them.",
  "Begone evildoer.",
  "Thus do we cleanse ourselves.",
  "We wash our hands of them.",
  "Fortune shall be their final judge.",
  "They are disowned.",
  "We never knew them.",
  "They are cut off.",
  "Let them live with the beasts.",
  "Let the barbarians and wild folk have them.",
  "They are not fit for civilized lands.",
  "Thus we ensure our security.",
  "Only the righteous belong among us.",
  "May they toil in vain.",
  "So it is done.",
  "Even the dogs despise them.",
  "We break no bread with traitors."

}

--Various curruptions of "Ozymandias"
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

--what happened here? Lost to memory
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
  "Firey Breath",
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

  local judge = judger[random(#judger)]
  local your_name = meta:get_string("char_name")
  local origin_name = lore.generate_name(4)
  local polity_name = lore.generate_name(5)
  local cr1 = crime1[random(#crime1)]
  local cr2 = crime2[random(#crime2)]
  local your_woe = woe[random(#woe)]
  local exile_land = exile[random(#exile)]
  local terror = mythic_terror[random(#mythic_terror)]

  letter_text =
    "By decree of the "..judge..
    " of "..polity_name..": "..
    "\n \n "..
    "\n "..your_name.." of "..origin_name..
    "\n \n "..
    "\nis hereby sentenced to exile for the crimes of "..
    "\n  "..
    "\n"..cr1..
    "\n  "..
    "\nand "..
    "\n  "..
    "\n"..cr2.."."..
    "\n \n \n"..
    "\nThey are banished to the land of "..exile_land.."."..
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

----------------------------------------------
local dig = function(pos, node, digger, width, height)
  if not digger then
		minetest.remove_node(pos)
		return
	end

	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end

	local meta = minetest.get_meta(pos)
	local letter_text = meta:get_string("lore:letter_text")

	local new = ItemStack(node)
  local stack_meta = new:get_meta()
	stack_meta:set_string("lore:letter_text", letter_text)
	minetest.remove_node(pos)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new) then
		player_inv:add_item("main", new)
	else
		minetest.add_item(pos, new)
	end
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
  on_dig = dig
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
