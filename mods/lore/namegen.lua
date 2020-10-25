

local random = math.random

-- syllables
-- a, e, i, o, u
--'B', 'C', 'D','F', 'G', 'H', 'J',
local syl_start = {
	'A', 'Aa', 'Ab', 'Ac', 'Ad', 'Ae', 'Af', 'Ag', 'Ah', 'Ai', 'Aj',
	'Ak', 'Al', 'Am', 'An', 'Ao', 'Ap', 'Aqu', 'Ar', 'As', 'At', 'Au', 'Av', 'Aw',
	'Ax', 'Ay', 'Az',
	'E', 'Ea', 'Eb', 'Ec', 'Ed', 'Ee', 'Ef', 'Eg', 'Eh', 'Ei', 'Ej',
	'Ek', 'El', 'Em', 'En', 'Eo', 'Ep', 'Equ', 'Er', 'Es', 'Et', 'Eu', 'Ev', 'Ew',
	'Ex', 'Ey', 'Ez',
	'I', 'Ia', 'Ib', 'Ic', 'Id', 'Ie', 'If', 'Ig', 'Ih', 'Ii', 'Ij',
	'Ik', 'Il', 'Im', 'In', 'Io', 'Ip', 'Iqu', 'Ir', 'Is', 'It', 'Iu', 'Iv', 'Iw',
	'Ix', 'Iy', 'Iz',
	'O', 'Oa', 'Ob', 'Oc', 'Od', 'Oe', 'Of', 'Og', 'Oh', 'Oi', 'Oj',
	'Ok', 'Ol', 'Om', 'On', 'Oo', 'Op', 'Oqu', 'Or', 'Os', 'Ot', 'Ou', 'Ov', 'Ow',
	'Ox', 'Oy', 'Oz',
	'U', 'Ua', 'Ub', 'Uc', 'Ud', 'Ue', 'Uf', 'Ug', 'Uh', 'Ui', 'Uj',
	'Uk', 'Ul', 'Um', 'Un', 'Uo', 'Up', 'Uqu', 'Ur', 'Us', 'Ut', 'Uu', 'Uv', 'Uw',
	'Ux', 'Uy', 'Uz',
	--
	'Ba', 'Ca', 'Da','Fa', 'Ga', 'Ha', 'Ja', 'Ka', 'La', 'Ma', 'Na', 'Pa', 'Qua', 'Ra', 'Sa', 'Ta',
	'Va', 'Wa',	'Xa', 'Ya', 'Za',
	'Cha', 'Zha', 'Tha',
	'Nga', 'Bla', 'Kra', 'Cra', 'Kla', 'Cla', 'Fra', 'Dra', 'Bra', 'Gra', 'Pra',
	'Sma', 'Sna', 'Spa', 'Sha', 'Scha', 'Sta', 'Swa', 'Sya',
	'Be', 'Ce', 'De','Fe', 'Ge', 'He', 'Je', 'Ke', 'Le', 'Me', 'Ne', 'Pe', 'Que', 'Re', 'Se', 'Te',
	'Ve', 'We',	'Xe', 'Ye', 'Ze',
	'Che', 'Zhe', 'The',
	'Nge', 'Ble', 'Kre', 'Cre', 'Kle', 'Cle', 'Fre', 'Dre', 'Bre', 'Gre', 'Pre',
	'Sme', 'Sne', 'Spe', 'She', 'Sche', 'Ste', 'Swe', 'Sye',
	'Bi', 'Ci', 'Di','Fi', 'Gi', 'Hi', 'Ji', 'Ki', 'Li', 'Mi', 'Ni', 'Pi', 'Qui', 'Ri', 'Si', 'Ti',
	'Vi', 'Wi',	'Xi', 'Yi', 'Zi',
	'Chi', 'Zhi', 'Thi',
	'Ngi', 'Bli', 'Kri', 'Cri', 'Kli', 'Cli', 'Fri', 'Dri', 'Bri', 'Gri', 'Pri',
	'Smi', 'Sni', 'Spi', 'Shi', 'Schi', 'Sti', 'Swi', 'Syi',
	'Bo', 'Co', 'Do','Fo', 'Go', 'Ho', 'Jo', 'Ko', 'Lo', 'Mo', 'No', 'Po', 'Quo', 'Ro', 'So', 'To',
	'Vo', 'Wo',	'Xo', 'Yo', 'Zo',
	'Cho', 'Zho', 'Tho',
	'Ngo', 'Blo', 'Kro', 'Cro', 'Klo', 'Clo', 'Fro', 'Dro', 'Bro', 'Gro', 'Pro',
	'Smo', 'Sno', 'Spo', 'Sho', 'Scho', 'Sto', 'Swo', 'Syo',
	'Bu', 'Cu', 'Du','Fu', 'Gu', 'Hu', 'Ju', 'Ku', 'Lu', 'Mu', 'Nu', 'Pu', 'Qu', 'Ru', 'Su', 'Tu',
	'Vu', 'Wu',	'Xu', 'Yu', 'Zu',
	'Chu', 'Zhu', 'Thu',
	'Ngu', 'Blu', 'Kru', 'Cru', 'Klu', 'Clu', 'Fru', 'Dru', 'Bru', 'Gru', 'Pru',
	'Smu', 'Snu', 'Spu', 'Shu', 'Schu', 'Stu', 'Swu', 'Syu',
	--
	'Ach', 'Azh', 'Ath',
	'Ang', 'Alb', 'Ark', 'Arc', 'Alk', 'Alc', 'Arf', 'Ard', 'Arb', 'Arg', 'Arp',
	'Asm', 'Asn', 'Asp', 'Ash', 'Asch', 'Ast',
	'Ech', 'Ezh', 'Eth',
	'Eng', 'Elb', 'Erk', 'Erc', 'Elk', 'Elc', 'Erf', 'Erd', 'Erb', 'Erg', 'Erp',
	'Esm', 'Esn', 'Esp', 'Esh', 'Esch', 'Est',
	'Ich', 'Izh', 'Ith',
	'Ing', 'Ilb', 'Irk', 'Irc', 'Ilk', 'Ilc', 'Irf', 'Ird', 'Irb', 'Irg', 'Irp',
	'Ism', 'Isn', 'Isp', 'Ish', 'Isch', 'Ist',
	'Och', 'Ozh', 'Oth',
	'Ong', 'Olb', 'Ork', 'Orc', 'Olk', 'Olc', 'Orf', 'Ord', 'Orb', 'Org', 'Orp',
	'Osm', 'Isn', 'Osp', 'Osh', 'Osch', 'Ost',
	'Uch', 'Uzh', 'Uth',
	'Ung', 'Ulb', 'Urk', 'Urc', 'Ulk', 'Ulc', 'Urf', 'Urd', 'Urb', 'Urg', 'Urp',
	'Usm', 'Usn', 'Usp', 'Ush', 'Usch', 'Ust',
	--Various Full
	'Ari', 'Abne', 'Abi', 'Ane',
	'Bern', 'Bio',
	"Call", 'Calu', 'Cale',
	'Dona', 'Dela', 'Dan', 'Duo', 'Deca',
	'Halcy', 'Hyne',
	'Feli',
	'Jad', 'Joh',
	'Meth', 'Mar', 'Max', 'Mega',
	'Noto', 'Neo',
	'Ore', 'Oct', 'Ozy',
	'Per', 'Pent', 'Phil',
	'Resh', 'Roch', 'Rach',
	'Soph',
	'Vict',
	'Yesh'

	}


local syl_mid = {
	'a', 'ab', 'ac', 'ad', 'ae', 'af', 'ag', 'ah', 'ai', 'aj',
	'ak', 'al', 'am', 'an', 'ao', 'ap', 'aqu', 'ar', 'as', 'at', 'au', 'av', 'aw',
	'ax', 'ay', 'az',
	'e', 'ea', 'eb', 'ec', 'ed', 'ef', 'eg', 'eh', 'ei', 'ej',
	'ek', 'el', 'em', 'en', 'eo', 'ep', 'equ', 'er', 'es', 'et', 'eu', 'ev', 'ew',
	'ex', 'ey', 'ez',
	'i', 'ia', 'ib', 'ic', 'id', 'ie', 'if', 'ig', 'ih', 'ij',
	'ik', 'il', 'im', 'in', 'io', 'ip', 'iqu', 'ir', 'is', 'it', 'iu', 'iv', 'iw',
	'ix', 'iy', 'iz',
	'o', 'oa', 'ob', 'oc', 'od', 'oe', 'of', 'og', 'oh', 'oi', 'oj',
	'ok', 'ol', 'om', 'on', 'op', 'oqu', 'or', 'os', 'ot', 'ou', 'ov', 'ow',
	'ox', 'oy', 'oz',
	'u', 'ua', 'ub', 'uc', 'ud', 'ue', 'uf', 'ug', 'uh', 'ui', 'uj',
	'uk', 'ul', 'um', 'un', 'uo', 'up', 'uqu', 'ur', 'us', 'ut', 'uv', 'uw',
	'ux', 'uy', 'uz',
	--
	'ba', 'ca', 'da','fa', 'ga', 'ha', 'ja', 'ka', 'la', 'ma', 'na', 'pa', 'qua', 'ra', 'sa', 'ta',
	'va', 'wa',	'xa', 'ya', 'za',
	'cha', 'zha', 'tha',
	'nga', 'bla', 'kra', 'cra', 'kla', 'cla', 'fra', 'dra', 'bra', 'gra', 'pra',
	'sma', 'sna', 'spa', 'sha', 'scha', 'sta', 'swa', 'sya',
	'be', 'ce', 'de','fe', 'ge', 'he', 'je', 'ke', 'le', 'me', 'ne', 'pe', 'que', 're', 'se', 'te',
	've', 'we',	'xe', 'ye', 'ze',
	'che', 'zhe', 'the',
	'nge', 'ble', 'kre', 'cre', 'kle', 'cle', 'fre', 'dre', 'bre', 'gre', 'pre',
	'sme', 'sne', 'spe', 'she', 'sche', 'ste', 'swe', 'sye',
	'bi', 'ci', 'di','fi', 'gi', 'hi', 'ji', 'ki', 'li', 'mi', 'ni', 'pi', 'qui', 'ri', 'si', 'ti',
	'vi', 'wi',	'xi', 'yi', 'zi',
	'chi', 'zhi', 'thi',
	'ngi', 'bli', 'kri', 'cri', 'kli', 'cli', 'fri', 'dri', 'bri', 'gri', 'pri',
	'smi', 'sni', 'spi', 'shi', 'schi', 'sti', 'swi', 'syi',
	'bo', 'co', 'do','fo', 'go', 'ho', 'jo', 'ko', 'lo', 'mo', 'no', 'po', 'quo', 'ro', 'so', 'to',
	'vo', 'wo',	'xo', 'yo', 'zo',
	'cho', 'zho', 'tho',
	'ngo', 'blo', 'kro', 'cro', 'klo', 'clo', 'fro', 'dro', 'bro', 'gro', 'pro',
	'smo', 'sno', 'spo', 'sho', 'scho', 'sto', 'swo', 'syo',
	'bu', 'cu', 'du','fu', 'gu', 'hu', 'ju', 'ku', 'lu', 'mu', 'nu', 'pu', 'qu', 'ru', 'su', 'tu',
	'vu', 'wu',	'xu', 'yu', 'zu',
	'chu', 'zhu', 'thu',
	'ngu', 'blu', 'kru', 'cru', 'klu', 'clu', 'fru', 'dru', 'bru', 'gru', 'pru',
	'smu', 'snu', 'spu', 'shu', 'schu', 'stu', 'swu', 'syu',
	--
	'ach', 'azh', 'ath',
	'ang', 'alb', 'ark', 'arc', 'alk', 'alc', 'arf', 'ard', 'arb', 'arg', 'arp',
	'asm', 'asn', 'asp', 'ash', 'asch', 'ast',
	'ech', 'ezh', 'eth',
	'eng', 'elb', 'erk', 'erc', 'elk', 'elc', 'erf', 'erd', 'erb', 'erg', 'erp',
	'esm', 'esn', 'esp', 'esh', 'esch', 'est',
	'ich', 'izh', 'ith',
	'ing', 'ilb', 'irk', 'irc', 'ilk', 'ilc', 'irf', 'ird', 'irb', 'irg', 'irp',
	'ism', 'isn', 'isp', 'ish', 'isch', 'ist',
	'och', 'ozh', 'oth',
	'ong', 'olb', 'ork', 'orc', 'olk', 'olc', 'orf', 'ord', 'orb', 'org', 'orp',
	'osm', 'isn', 'osp', 'osh', 'osch', 'ost',
	'uch', 'uzh', 'uth',
	'ung', 'ulb', 'urk', 'urc', 'ulk', 'ulc', 'urf', 'urd', 'urb', 'urg', 'urp',
	'usm', 'usn', 'usp', 'ush', 'usch', 'ust',
	--Various Full
	'uckle',
	'cifer',
	'grippa',
	'grun',
	'midor',
	'anael',
	'umber',
	'erild',
	'rendra', 'rillus', 'riah',
	'avius',
	'phoros',
	'-',
	"'"


}

local syl_end = {
	'a', 'ab', 'ac', 'ad', 'ae', 'af', 'ag', 'ah', 'ai', 'aj',
	'ak', 'al', 'am', 'an', 'ao', 'ap', 'aqu', 'ar', 'as', 'at', 'au', 'av', 'aw',
	'ax', 'ay', 'az',
	'e', 'ea', 'eb', 'ec', 'ed', 'ef', 'eg', 'eh', 'ei', 'ej',
	'ek', 'el', 'em', 'en', 'eo', 'ep', 'equ', 'er', 'es', 'et', 'eu', 'ev', 'ew',
	'ex', 'ey', 'ez',
	'i', 'ia', 'ib', 'ic', 'id', 'ie', 'if', 'ig', 'ih', 'ij',
	'ik', 'il', 'im', 'in', 'io', 'ip', 'iqu', 'ir', 'is', 'it', 'iu', 'iv', 'iw',
	'ix', 'iy', 'iz',
	'o', 'oa', 'ob', 'oc', 'od', 'oe', 'of', 'og', 'oh', 'oi', 'oj',
	'ok', 'ol', 'om', 'on', 'op', 'oqu', 'or', 'os', 'ot', 'ou', 'ov', 'ow',
	'ox', 'oy', 'oz',
	'u', 'ua', 'ub', 'uc', 'ud', 'ue', 'uf', 'ug', 'uh', 'ui', 'uj',
	'uk', 'ul', 'um', 'un', 'uo', 'up', 'uqu', 'ur', 'us', 'ut', 'uv', 'uw',
	'ux', 'uy', 'uz',
	--
	'ba', 'ca', 'da','fa', 'ga', 'ha', 'ja', 'ka', 'la', 'ma', 'na', 'pa', 'qua', 'ra', 'sa', 'ta',
	'va', 'wa',	'xa', 'ya', 'za',
	'cha', 'zha', 'tha',
	'nga', 'bla', 'kra', 'cra', 'kla', 'cla', 'fra', 'dra', 'bra', 'gra', 'pra',
	'sma', 'sna', 'spa', 'sha', 'scha', 'sta', 'swa', 'sya',
	'be', 'ce', 'de','fe', 'ge', 'he', 'je', 'ke', 'le', 'me', 'ne', 'pe', 'que', 're', 'se', 'te',
	've', 'we',	'xe', 'ye', 'ze',
	'che', 'zhe', 'the',
	'nge', 'ble', 'kre', 'cre', 'kle', 'cle', 'fre', 'dre', 'bre', 'gre', 'pre',
	'sme', 'sne', 'spe', 'she', 'sche', 'ste', 'swe', 'sye',
	'bi', 'ci', 'di','fi', 'gi', 'hi', 'ji', 'ki', 'li', 'mi', 'ni', 'pi', 'qui', 'ri', 'si', 'ti',
	'vi', 'wi',	'xi', 'yi', 'zi',
	'chi', 'zhi', 'thi',
	'ngi', 'bli', 'kri', 'cri', 'kli', 'cli', 'fri', 'dri', 'bri', 'gri', 'pri',
	'smi', 'sni', 'spi', 'shi', 'schi', 'sti', 'swi', 'syi',
	'bo', 'co', 'do','fo', 'go', 'ho', 'jo', 'ko', 'lo', 'mo', 'no', 'po', 'quo', 'ro', 'so', 'to',
	'vo', 'wo',	'xo', 'yo', 'zo',
	'cho', 'zho', 'tho',
	'ngo', 'blo', 'kro', 'cro', 'klo', 'clo', 'fro', 'dro', 'bro', 'gro', 'pro',
	'smo', 'sno', 'spo', 'sho', 'scho', 'sto', 'swo', 'syo',
	'bu', 'cu', 'du','fu', 'gu', 'hu', 'ju', 'ku', 'lu', 'mu', 'nu', 'pu', 'qu', 'ru', 'su', 'tu',
	'vu', 'wu',	'xu', 'yu', 'zu',
	'chu', 'zhu', 'thu',
	'ngu', 'blu', 'kru', 'cru', 'klu', 'clu', 'fru', 'dru', 'bru', 'gru', 'pru',
	'smu', 'snu', 'spu', 'shu', 'schu', 'stu', 'swu', 'syu',
	--
	'b', 'c', 'd','f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't',
	'v', 'w',	'x', 'y', 'z',
	'ch', 'zh', 'th',
	'ng', 'lb', 'rk', 'rc', 'lk', 'lc', 'rf', 'rd', 'rb', 'rgr', 'rp',
	'sm', 'sn', 'sp', 'sh', 'sch', 'st',
	--
	'ach', 'azh', 'ath',
	'ang', 'alb', 'ark', 'arc', 'alk', 'alc', 'arf', 'ard', 'arb', 'arg', 'arp',
	'asm', 'asn', 'asp', 'ash', 'asch', 'ast',
	'ech', 'ezh', 'eth',
	'eng', 'elb', 'erk', 'erc', 'elk', 'elc', 'erf', 'erd', 'erb', 'erg', 'erp',
	'esm', 'esn', 'esp', 'esh', 'esch', 'est',
	'ich', 'izh', 'ith',
	'ing', 'ilb', 'irk', 'irc', 'ilk', 'ilc', 'irf', 'ird', 'irb', 'irg', 'irp',
	'ism', 'isn', 'isp', 'ish', 'isch', 'ist',
	'och', 'ozh', 'oth',
	'ong', 'olb', 'ork', 'orc', 'olk', 'olc', 'orf', 'ord', 'orb', 'org', 'orp',
	'osm', 'isn', 'osp', 'osh', 'osch', 'ost',
	'uch', 'uzh', 'uth',
	'ung', 'ulb', 'urk', 'urc', 'ulk', 'ulc', 'urf', 'urd', 'urb', 'urg', 'urp',
	'usm', 'usn', 'usp', 'ush', 'usch', 'ust',
	--Various Full
	'sea',
	'ghu',
	'tius', 'lius',
	'hild',
	'via',
	'tina',
	'tia',
	'lia',
	'iana',
	'laus',
	'ecca',
	'ara',
	'vus',
	'etos',
	'gund',
	'alaa',
	'ion',
	'ium'


}


lore.generate_name = function(max_length)
	local length = random(1, max_length)
	local first = ""
	local mid = ""
	local last = ""

	if length == 1 then
		first = syl_start[random(#syl_start)]
		return first
	elseif length == 2 then
		first = syl_start[random(#syl_start)]
		last = syl_end[random( #syl_end)]
		return first..last
	else
		first = syl_start[random(#syl_start)]
		last = syl_end[random( #syl_end)]
		local cnt = 0
		--mid = syl_mid[random( #syl_mid)]
		while cnt < length - 2 do
			mid = mid..syl_mid[random( #syl_mid)]
			cnt = cnt + 1
		end
		return first..mid..last
	end

end
