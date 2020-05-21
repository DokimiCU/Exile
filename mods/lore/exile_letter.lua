
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
  "Great Leader",
  --officials
  "High Judge",
  "Tribunal",
  "Council",
  "Courts",
  "Presidium",
  --cults
  "Botherhood",
  "Sisterhood",
  "High Priest",
  "High Priestess",
  "Great Prophet",
  "Annoited One",
  "Seers",
  "Order",
  "Monks",
  "Priests",
  "Priestessess",
  "Englightened Ones",
  "Great Sage",
  --tribal
  "Elders",
  "Wise Ones",
  "Clan Council",
  "Tribal Chiefs",
  "Great Chieftain",
  --republic
  "Citizenry",
  "People",
  "Senate",
  "Consul",
  "Senators",
  "Assembly",
  --Military/rouges/misc
  "Generals",
  "Mighty Warriors",
  "Pirates",
  "Bandits",
  "Admirals",
  "League",
  "Alliance",
  "Coalition",
  "Company",
  "Legion",
  "Horde"

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
  "espionage",
  "sabotage",
  "treachery",
  "sedition",
  "terrorism"

}


--flavour crime
local crime2 = {
  "leading the youth astray",
  "smuggling",
  "vagabondage",
  "banditry",
  "piracy in peacetime",
  "drunkness",
  "sinful living",
  "rabble rousing",
  "inciting violence",
  "unspeakable acts",
  "that of which we shall not speak",
  "shameless acts",
  "willful sloth",
  "preaching foriegn gods",
  "gross vanity",
  "wickedness",
  "assasination",
  "sharing secrets with foriegn powers",
  "black magic",
  "witchcraft",
  "shameful conduct",
  "cowardice",
  "tax evasion",
  "desecration of holy relics",
  "subverting the course of justice",
  "robbery",
  "attempted murder",
  "grave robbing",
  "cruelty to animals",
  "embezzlement",
  "questioning the gloriousness of our ways",
  "bearing false witness",
  "deception",
  "fraud",
  "fakery",
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
  "hooliganism",
  "harassment",
  "forgery",
  "bribery"

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
  "They are disowned."

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
  "Catastrohpe",
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
  "Old Tales"
}



local generate_text = function()
  local letter_text = ""

  local judge = judger[random(#judger)]
  local your_name = lore.generate_name(3)
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
    "\nIs hereby sentenced to exile for the crimes of "..
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
  	"textarea[2.5,1.5;8.6,10.6;;" .. minetest.formspec_escape(letter_text) .. ";]",
  	"background[0,0;18,11;lore_exile_letter_bg.png;true]",
  	"button_exit[17.3,0;0.8,0.5;exit_form;X]"}

	return table.concat(formspec, "")
end





-----------------------------------------------
local after_place = function(pos, placer, itemstack, pointed_thing)
  local meta = minetest.get_meta(pos)
  local stack_meta = itemstack:get_meta()

  local letter_text = stack_meta:get_string("lore:letter_text")
  if letter_text == "" then
    letter_text = generate_text()
  end

  local form = get_formspec(meta, letter_text )
  meta:set_string("formspec", form)
  meta:set_string("lore:letter_text", letter_text)

end

----------------------------------------------
local dig = function(pos, node, digger, width, height)
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
  inv:add_item("main", "lore:exile_letter")
end)

minetest.register_on_respawnplayer(function(player)
  local inv = player:get_inventory()
  inv:add_item("main", "lore:exile_letter")
end)
