----------------------------------------------------------
--BIO GEN
--[[
	Biography.

	Who is the character for this life?
	Displayed on Char_tab.'

	Gives sense of character.

	Each life is a chance to behave different, try new strategies, methods, modes of being.
	The traits suggested are a primer to do things different than your normal patterns.

	"[Outgoing] and [diligent],
	[Bob] had lived a [miserable] life,
	until one day [he][picked a fight with the wrong people].... "
]]
local random = math.random
----------------------------------------------------------
local gender = {
	male   = "he",
	female = "she"
}
-- Big Five
-- (Try to make sure these are different from virtues!)
local personality = {
  -- openness
  "Conventional",
  "Unconventional",
  "Practical",
  "Imaginative",
  "Unadventurous",
  "Adventurous",
  "Traditional",
  "Rebellious",
  -- conscientiousness
  "Organized",
  "Disorganized",
  "Goal-driven",
  "Impulsive",
  "Dutiful",
  "Careless",
  "Precise",
  "Slapdash",
  -- extroversion
  "Shy",
  "Gregarious",
  "Quiet",
  "Outgoing",
  "Withdrawn",
  "Sociable",
  "Reserved",
  "Expressive",
  -- agreeableness
  "Pleasant",
  "Argumentative",
  "Good-natured",
  "Critical",
  "Soft-hearted",
  "Suspicious",
  "Gullible",
  "Cynical",
  -- neuroticism
  "Calm",
  "Neurotic",
  "Steady",
  "Unstable",
  "Self-satisfied",
  "Moody",
  "Complacent",
  "Paranoid"
}
-- Miscellaneous Virtues
local virtue = {
  "courageous",
  "temperate",
  "charitable",
  "extravagant",
  "magnanimous",
  "patient",
  "honest",
  "witty",
  "friendly",
  "modest",
  "just",
  "ambitious",
  "assertive",
  "benevolent",
  "brave",
  "caring",
  "chaste",
  "cautious",
  "fastidious",
  "committed",
  "compassionate",
  "confident",
  "considerate",
  "contented",
  "cooperative",
  "courteous",
  "creative",
  "curious",
  "defiant",
  "dependable",
  "determined",
  "devoted",
  "diligent",
  "discerning",
  "discrete",
  "disciplined",
  "eloquent",
  "empathic",
  "enthusiastic",
  "faithful",
  "flexible",
  "focused",
  "tolerant",
  "forgiving",
  "strong",
  "frugal",
  "gentle",
  "graceful",
  "grateful",
  "helpful",
  "honorable",
  "hopeful",
  "humble",
  "comical",
  "idealistic",
  "virtuous",
  "impartial",
  "industrious",
  "innocent",
  "joyful",
  "kind",
  "knowledgeable",
  "loving",
  "loyal",
  "noble",
  "dignified",
  "merciful",
  "moderate",
  "peaceful",
  "persistent",
  "prudent",
  "purposeful",
  "reliable",
  "resolute",
  "resourceful",
  "respectful",
  "responsible",
  "reverent",
  "righteous",
  "selfless",
  "sensitive",
  "contemplative",
  "sincere",
  "sober",
  "spontaneous",
  "steadfast",
  "tactful",
  "thrifty",
  "tough",
  "tranquil",
  "trusting",
  "trustworthy",
  "understanding",
  "vigorous",
  "wise",
  "zealous"
}
-- State of former life:
-- (Ought to contrast with the world of Exile.)
local life = {
  -- Favorable
  "a good",
  "a happy",
  "a pleasant",
  "an enjoyable",
  -- Drab
  "a boring",
  "an uneventful",
  "a mediocre",
  "a dull",
  "a humdrum",
  -- Easy
  "a comfortable",
  "a satisfied",
  "a soft",
  "an easy",
  -- Nominal
  "a normal",
  "an average",
  "an unremarkable",
  -- Diminutive
  "a restricted",
  "a narrow-horizoned",
  "a homely",
  "a constricted",
  -- Grievous
  "a frustrated",
  "an empty",
  "an unfulfilling",
  "a sorrowful",
  "a mournful",
  "a long-suffering",
  -- Toiling
  "an overburdened",
  "a hardworking",
  "a slave-like",
  -- Social
  "a family centred",
  "a communal",
  "a self-centred",
  "a selfless",
  "a solitary",
  "a low-born",
  "an aristocratic",
  -- Moral
  "a well respected",
  "an upstanding",
  "a patriotic",
  "an honorable",
  -- Wasted
  "a dissipated",
  "a dissolute",
  "a slothful",
  "an indulgent",
  "a misspent",
  -- Aberrant
  "an eccentric",
  "an oddball",
  "a strange"
}
-- What went wrong:
local woe = {
  -- Bad Business
  "made a bad bargain",
  "made a deal with the wrong people",
  "sold out and got swindled",
  "was made an offer too good to be true",
  "saw a fantastic opportunity",
  "took a gamble",
  "found a new way to make a living",
  -- Emotion
  "lost all hope",
  "fell into despair",
  "discovered a great passion",
  "found a source of great joy",
  "was provoked to anger",
  "lashed out",
  "snapped",
  "couldn't take it anymore",
  "decided love was dead",
  "felt like the world didn't care",
  "was disgusted by life",
  "became obsessed",
  -- Fight the Power
  "stood up for the truth",
  "spoke truth to power",
  "took a stand",
  "picked a fight with the wrong people",
  "raged against the machine",
  "fought for justice",
  "put everything toward the cause",
  "rose up against the oppressor",
  -- Wrong Type of Person/Corruption
  "was persecuted by the intolerant",
  "refused to conform",
  "refused to hide anymore",
  "chose to live differently",
  "saw things others did not see",
  -- Life Change
  "decided not live that way anymore",
  "thought life needed shaking up",
  "made a few minor changes",
  "had an epiphany",
  "took up a new hobby",
  -- Crime
  "got in too deep",
  "chose the wrong path",
  "thought no one would notice",
  "got caught",
  "got snitched on",
  "bungled a sure thing",
  -- Poverty
  "fell on hard times",
  "did what needed to be done",
  "did what it took to feed the family",
  -- Politics
  "picked the losing side",
  "took a chance to grab power",
  "ended up on the wrong side of history",
  "offended a powerful man",
  "offended a powerful woman",
  "provoked the jealousy a rival",
  -- Random Acts
  "was just passing by, when",
  "had an accident",
  "was mistaken for someone else",
  "was imprisoned on false charges",
  "got caught up in someone else's mess",
  "witnessed what was supposed to be a secret",
  -- One Stupid Mistake
  "made one bad decision",
  "said one wrong thing",
  "gave in to temptation",
  "had a momentary lapse of judgement",
  "started something too big",
  "lost control",
  "followed bad advice",
  "had too much to drink",
  "learned the truth too late",
  "committed a simple indiscretion",
  "had a great idea",
  "misjudged the situation entirely",
  -- Romance/Family
  "fell in love",
  "had an affair",
  "gave up everything for love",
  "had a son",
  "had a daughter",
  "discovered a long-lost relative",
  "got mixed up in a love triangle",
  -- Weird
  "got involved with a travelling magician",
  "met a man with two heads",
  "found a bird that could predict the future",
  "ate some odd beans",
  "tried to learn the flute",
  "was given a secret map",
  "discovered a secret chamber",
  "saw a ghost",
  "received a vision from the other side",
  "had a dream that explained everything",
  "built a perpetual-motion machine",
  "learned the meaning of life"
}
lore.generate_bio = function(player)
	local text = ""

	local meta = player:get_meta()
	local gend = player_api.get_gender(player)

	local persona   = personality[random(#personality)]
	local virt      = virtue[random(#virtue)]
	local your_name = meta:get_string("char_name")
	local lif       = life[random(#life)]
	local your_woe  = woe[random(#woe)]

	text =
		"\n "..persona.." and "..virt..","..
		"\n "..your_name.." had lived "..lif.." life,"..
		"\n until one day "..gender[gend].." "..your_woe.."...."
		meta:set_string("bio", text)
	return text
end
