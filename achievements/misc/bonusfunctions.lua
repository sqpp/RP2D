local _player = player
function player(id, value)
	if (value == "usgn") then
		if _player(id, "usgn") > 0 then
			return(_player(id, "usgn"))
		end
		if _player(id, "steamid") ~= "0" then
			return(tonumber(_player(id, "steamid")) % 2147483647)
		end
		return(0)
	end
	if (value == "usgntype") then
		if _player(id, "usgn") > 0 then
			return("U.S.G.N")
		end
		if _player(id, "steamid") ~= "0" then
			return("Steam")
		end
		return("Uknown")
	end
	if (value == "usgnname") then
		if string.len(_player(id, "usgnname")) > 0 then
			return(_player(id, "usgnname"))
		end
		if string.len(_player(id, "steamname")) > 0 then
			return(_player(id, "steamname"))
		end
		return("")
	end
	return(_player(id, value))
end

function removeImage(id)
	if (id ~= nil) then
		freeimage(id)
	end
end

function pointInRect(px,py,x,y,w,h)
	return(px > x and py > y and px < x + w and py < y + h)
end

function table.map_length(t)
	local c = 0
	for k,v in pairs(t) do
		c = c+1
	end
	return c
end

function nilZero(number, var)
	if (number ~= nil) then
		return(number)
	end
	if var then
		return(var)
	end
	return(0)
end

function closeHudText(id,iid)
	parse('hudtxt2 '..id..' '..iid..' "" 0 0')
end

function hudText2(id, i, text,x,y, align)
	align = nilZero(align)
	parse('hudtxt2 '..id..' '..i..' "'..text..'" '..x..' '..y..' '..align)
end

function SpawnEffect(effect,x,y,p1,p2,r,g,b)
	parse('effect "'..effect..'" '..x..' '..y..' '..p1..' '..p2..' '..r..' '..g..' '..b)
end

function removeFadeImage(id)
	id = tonumber(id)
	if FadeImageList[id] then
		freeimage(id)
	end
end

FadeImageList = {}
function FadeStartround()
	FadeImageList = {}	
end
AddGlobalFunction("startround",FadeStartround)
function fadeImageEffect(id,path,x,y, ms, scale)
	if (CFG_EFFECT_MENU_FADE_OUT ~= true) then
		return
	end
	effect = image(path,x,y,2,id)
	imageblend(effect,1)
	if ms == nil then
		ms = 100 		
	end
	if scale then
		tween_scale(effect,ms * 2,1,0)
	end
	tween_alpha(effect,ms,0)
	timer(200,"removeFadeImage",effect)
	FadeImageList[effect] = true
end

function setKnife(id)
	parse("setweapon "..id..' 50') 
end

function loadImage(path,x , y,mode,id,rot,blend,scaleX,scaleY)
	local img = image(path,x , y,mode,id)
	if rot then
		imagepos(img,x ,y, rot)
	end
	if blend then
		imagepos(img,blend)
	end
	if scaleX and scaleY then
		imagescale(img,scaleX,scaleY)
	end
	return(img)
end

function PrintDebug(txt)
	if CFG_DEBUG then
		print("©160160255[DEBUG] "..txt)
	end
end
function PrintHookDebug(txt)
	if CFG_DEBUG_HOOK then
		print("©160160255[HOOK TIME] "..txt)
	end
end

function PrintErrorDebug(txt)
	if CFG_DEBUG_HOOK then
		print("©255000000[ERROR] "..txt)
	end
end

function distance(x1,y1,x2,y2)
	local xd = x2 - x1
	local yd = y2 - y1
	return( math.sqrt(xd*xd + yd*yd) )
end

function DrawLineForPlayer(path,id,x1,y1,x2,y2)
	if x1 == nil or y2 == nil or x2 == nil or y2 == nil then
		return
	end
	local mX = (x1 + x2) / 2
	local mY = (y1 + y2) / 2
	local d = distance(x1,y1,x2,y2) 
	local r = math.deg(math.atan2(y1-y2,x1-x2))
	local img = image("gfx/stats/ui/"..path..".png",mX,mY,2,id)
	imagescale(img,d/100,1)
	imagepos(img,mX,mY,r)
	return(img)
end

function DrawRect(path,id,x,y,w,h)
	local img = image("gfx/stats/ui/"..path..".png",x  + w / 2,y  + h / 2,2,id)
	imagescale(img,w/32,h/32)
	return(img)
end

countryISO = {}
function countryInsert(name, iso)
	countryISO[iso] = name
end

function countryGet(iso)
	if countryISO[iso] == nil then
		return("none")
	else
		return(countryISO[iso])
	end
end

countryInsert("Andorra, Principality Of", "AD")
countryInsert("United Arab Emirates", "AE")
countryInsert("Afghanistan, Islamic State Of", "AF")
countryInsert("Antigua And Barbuda", "AG")
countryInsert("Anguilla", "AI")
countryInsert("Albania", "AL")
countryInsert("Armenia", "AM")
countryInsert("Netherlands Antilles", "AN")
countryInsert("Angola", "AO")
countryInsert("Antarctica", "AQ")
countryInsert("Argentina", "AR")
countryInsert("American Samoa", "AS")
countryInsert("Austria", "AT")
countryInsert("Australia", "AU")
countryInsert("Aruba", "AW")
countryInsert("Azerbaidjan", "AZ")
countryInsert("Bosnia-Herzegovina", "BA")
countryInsert("Barbados", "BB")
countryInsert("Bangladesh", "BD")
countryInsert("Belgium", "BE")
countryInsert("Burkina Faso", "BF")
countryInsert("Bulgaria", "BG")
countryInsert("Bahrain", "BH")
countryInsert("Burundi", "BI")
countryInsert("Benin", "BJ")
countryInsert("Bermuda", "BM")
countryInsert("Brunei Darussalam", "BN")
countryInsert("Bolivia", "BO")
countryInsert("Brazil", "BR")
countryInsert("Bahamas", "BS")
countryInsert("Bhutan", "BT")
countryInsert("Bouvet Island", "BV")
countryInsert("Botswana", "BW")
countryInsert("Belarus", "BY")
countryInsert("Belize", "BZ")
countryInsert("Canada", "CA")
countryInsert("Cocos (Keeling) Islands", "CC")
countryInsert("Central African Republic", "CF")
countryInsert("Congo, The Democratic Republic Of The", "CD")
countryInsert("Congo", "CG")
countryInsert("Switzerland", "CH")
countryInsert("Ivory Coast (Cote D'Ivoire)", "CI")
countryInsert("Cook Islands", "CK")
countryInsert("Chile", "CL")
countryInsert("Cameroon", "CM")
countryInsert("China", "CN")
countryInsert("Colombia", "CO")
countryInsert("Costa Rica", "CR")
countryInsert("Former Czechoslovakia", "CS")
countryInsert("Cuba", "CU")
countryInsert("Cape Verde", "CV")
countryInsert("Christmas Island", "CX")
countryInsert("Cyprus", "CY")
countryInsert("Czech Republic", "CZ")
countryInsert("Germany", "DE")
countryInsert("Djibouti", "DJ")
countryInsert("Denmark", "DK")
countryInsert("Dominica", "DM")
countryInsert("Dominican Republic", "DO")
countryInsert("Algeria", "DZ")
countryInsert("Ecuador", "EC")
countryInsert("Estonia", "EE")
countryInsert("Egypt", "EG")
countryInsert("Western Sahara", "EH")
countryInsert("Eritrea", "ER")
countryInsert("Spain", "ES")
countryInsert("Ethiopia", "ET")
countryInsert("Finland", "FI")
countryInsert("Fiji", "FJ")
countryInsert("Falkland Islands", "FK")
countryInsert("Micronesia", "FM")
countryInsert("Faroe Islands", "FO")
countryInsert("France", "FR")
countryInsert("France (European Territory)", "FX")
countryInsert("Gabon", "GA")
countryInsert("Great Britain", "UK")
countryInsert("Grenada", "GD")
countryInsert("Georgia", "GE")
countryInsert("French Guyana", "GF")
countryInsert("Ghana", "GH")
countryInsert("Gibraltar", "GI")
countryInsert("Greenland", "GL")
countryInsert("Gambia", "GM")
countryInsert("Guinea", "GN")
countryInsert("Guadeloupe (French)", "GP")
countryInsert("Equatorial Guinea", "GQ")
countryInsert("Greece", "GR")
countryInsert("S. Georgia & S. Sandwich Isls.", "GS")
countryInsert("Guatemala", "GT")
countryInsert("Guam (USA)", "GU")
countryInsert("Guinea Bissau", "GW")
countryInsert("Guyana", "GY")
countryInsert("Hong Kong", "HK")
countryInsert("Heard And McDonald Islands", "HM")
countryInsert("Honduras", "HN")
countryInsert("Croatia", "HR")
countryInsert("Haiti", "HT")
countryInsert("Hungary", "HU")
countryInsert("Indonesia", "ID")
countryInsert("Ireland", "IE")
countryInsert("Israel", "IL")
countryInsert("India", "IN")
countryInsert("British Indian Ocean Territory", "IO")
countryInsert("Iraq", "IQ")
countryInsert("Iran", "IR")
countryInsert("Iceland", "IS")
countryInsert("Italy", "IT")
countryInsert("Jamaica", "JM")
countryInsert("Jordan", "JO")
countryInsert("Japan", "JP")
countryInsert("Kenya", "KE")
countryInsert("Kyrgyz Republic (Kyrgyzstan)", "KG")
countryInsert("Cambodia, Kingdom Of", "KH")
countryInsert("Kiribati", "KI")
countryInsert("Comoros", "KM")
countryInsert("Saint Kitts & Nevis Anguilla", "KN")
countryInsert("North Korea", "KP")
countryInsert("South Korea", "KR")
countryInsert("Kuwait", "KW")
countryInsert("Cayman Islands", "KY")
countryInsert("Kazakhstan", "KZ")
countryInsert("Laos", "LA")
countryInsert("Lebanon", "LB")
countryInsert("Saint Lucia", "LC")
countryInsert("Liechtenstein", "LI")
countryInsert("Sri Lanka", "LK")
countryInsert("Liberia", "LR")
countryInsert("Lesotho", "LS")
countryInsert("Lithuania", "LT")
countryInsert("Luxembourg", "LU")
countryInsert("Latvia", "LV")
countryInsert("Libya", "LY")
countryInsert("Morocco", "MA")
countryInsert("Monaco", "MC")
countryInsert("Moldavia", "MD")
countryInsert("Madagascar", "MG")
countryInsert("Marshall Islands", "MH")
countryInsert("Macedonia", "MK")
countryInsert("Mali", "ML")
countryInsert("Myanmar", "MM")
countryInsert("Mongolia", "MN")
countryInsert("Macau", "MO")
countryInsert("Northern Mariana Islands", "MP")
countryInsert("Martinique (French)", "MQ")
countryInsert("Mauritania", "MR")
countryInsert("Montserrat", "MS")
countryInsert("Malta", "MT")
countryInsert("Mauritius", "MU")
countryInsert("Maldives", "MV")
countryInsert("Malawi", "MW")
countryInsert("Mexico", "MX")
countryInsert("Malaysia", "MY")
countryInsert("Mozambique", "MZ")
countryInsert("Namibia", "NA")
countryInsert("New Caledonia (French)", "NC")
countryInsert("Niger", "NE")
countryInsert("Norfolk Island", "NF")
countryInsert("Nigeria", "NG")
countryInsert("Nicaragua", "NI")
countryInsert("Netherlands", "NL")
countryInsert("Norway", "NO")
countryInsert("Nepal", "NP")
countryInsert("Nauru", "NR")
countryInsert("Neutral Zone", "NT")
countryInsert("Niue", "NU")
countryInsert("New Zealand", "NZ")
countryInsert("Oman", "OM")
countryInsert("Panama", "PA")
countryInsert("Peru", "PE")
countryInsert("Polynesia (French)", "PF")
countryInsert("Papua New Guinea", "PG")
countryInsert("Philippines", "PH")
countryInsert("Pakistan", "PK")
countryInsert("Poland", "PL")
countryInsert("Saint Pierre And Miquelon", "PM")
countryInsert("Pitcairn Island", "PN")
countryInsert("Puerto Rico", "PR")
countryInsert("Portugal", "PT")
countryInsert("Palau", "PW")
countryInsert("Paraguay", "PY")
countryInsert("Qatar", "QA")
countryInsert("Reunion (French)", "RE")
countryInsert("Romania", "RO")
countryInsert("Russian Federation", "RU")
countryInsert("Rwanda", "RW")
countryInsert("Saudi Arabia", "SA")
countryInsert("Solomon Islands", "SB")
countryInsert("Seychelles", "SC")
countryInsert("Sudan", "SD")
countryInsert("Sweden", "SE")
countryInsert("Singapore", "SG")
countryInsert("Saint Helena", "SH")
countryInsert("Slovenia", "SI")
countryInsert("Svalbard And Jan Mayen Islands", "SJ")
countryInsert("Slovak Republic", "SK")
countryInsert("Sierra Leone", "SL")
countryInsert("San Marino", "SM")
countryInsert("Senegal", "SN")
countryInsert("Somalia", "SO")
countryInsert("Serbia", "RS")
countryInsert("Suriname", "SR")
countryInsert("Saint Tome (Sao Tome) And Principe", "ST")
countryInsert("Former USSR", "SU")
countryInsert("El Salvador", "SV")
countryInsert("Syria", "SY")
countryInsert("Swaziland", "SZ")
countryInsert("Turks And Caicos Islands", "TC")
countryInsert("Chad", "TD")
countryInsert("French Southern Territories", "TF")
countryInsert("Togo", "TG")
countryInsert("Thailand", "TH")
countryInsert("Tadjikistan", "TJ")
countryInsert("Tokelau", "TK")
countryInsert("Turkmenistan", "TM")
countryInsert("Tunisia", "TN")
countryInsert("Tonga", "TO")
countryInsert("East Timor", "TP")
countryInsert("Turkey", "TR")
countryInsert("Trinidad And Tobago", "TT")
countryInsert("Tuvalu", "TV")
countryInsert("Taiwan", "TW")
countryInsert("Tanzania", "TZ")
countryInsert("Ukraine", "UA")
countryInsert("Uganda", "UG")
countryInsert("United Kingdom", "UK")
countryInsert("USA Minor Outlying Islands", "UM")
countryInsert("United States", "US")
countryInsert("Uruguay", "UY")
countryInsert("Uzbekistan", "UZ")
countryInsert("Holy See (Vatican City State)", "VA")
countryInsert("Saint Vincent & Grenadines", "VC")
countryInsert("Venezuela", "VE")
countryInsert("Virgin Islands (British)", "VG")
countryInsert("Virgin Islands (USA)", "VI")
countryInsert("Vietnam", "VN")
countryInsert("Vanuatu", "VU")
countryInsert("Wallis And Futuna Islands", "WF")
countryInsert("Samoa", "WS")
countryInsert("Yemen", "YE")
countryInsert("Mayotte", "YT")
countryInsert("Yugoslavia", "YU")
countryInsert("South Africa", "ZA")
countryInsert("Zambia", "ZM")
countryInsert("Zaire", "ZR")
countryInsert("Zimbabwe", "ZW")

