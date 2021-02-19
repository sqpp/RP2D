userTopMenu = InitMenuTable()
userTopMenuTable = {}

function GetYourPlace(id,table,StatID)	
	if GetPlayerUSGN(id) > 0 then
		for i = 1, #table do
			if (table[i] == player(id,"usgn")) then
				return(i)
			end
		end
	else
		for i = 1, #table do
			if (table[i] == GetIP(id)) then
				return(i)
			end
		end
	end
	return(0)
end

function updateTopStatsList(StatID) 	-- INSERTION SORT
	local m = os.clock()
	local TopStatsList = {}
	local TopStatsListVar = {}
	for i, a in pairs (UserManager.data) do
		table.insert(TopStatsList,i)
		TopStatsListVar[i] = nilZero(tonumber(GetStatsCompareByID(StatID,i))) -- functions are ID, not USGN
	end
	for i, a in pairs (UserManager.dataIP) do
		table.insert(TopStatsList,i)
		TopStatsListVar[i] = nilZero(tonumber(GetStatsCompareByID(StatID,i)))
	end
	local temp, aj
	for i = 2, #TopStatsList do
		aj = TopStatsListVar[TopStatsList[i]]
		j = (i - 1)
		while (j > 0) and (aj > TopStatsListVar[TopStatsList[j]]) do
			temp = TopStatsList[j + 1]
			TopStatsList[j + 1] = TopStatsList[j]
			TopStatsList[j] = temp
			j = j - 1
		end
        end
	PrintDebug("[TopList Sorting] "..(os.clock() - m).."ms")
	return(TopStatsList)
end

function openTopMenu(id, StatID, page, next)
	local m = os.clock()
	
	closeTopMenu(id,true)
	fadeInfo(id)
	setKnife(id)
	local TopStatsList
	if (next == nil) then 
		userTopMenuTable[id] = updateTopStatsList(StatID)		
	end
	TopStatsList = userTopMenuTable[id]
	page = SetUpMenuTable(userTopMenu,id,page)
	userTopMenu.StatID[id] = StatID
	table.insert(userTopMenu.images[id],image("gfx/Stats/ui/topmenu.png",320,230,2,id))
	local maxScore = GetStatsCompareByID(StatID,TopStatsList[1])
	if (maxScore == nil or maxScore == 0) then
		maxScore = 1
	end
	for i = 1, 9 do
		local p = i + page * 9
		if (#TopStatsList >= p) then
			local usgn = TopStatsList[p]
			local varNumber = nilZero(tonumber(GetStatsCompareByID(StatID,usgn)))
			local displayVariable = GetStatsVariableByID(StatID,usgn,true)
			displayVariable = nilZero(displayVariable,"none")
			if GetStatsCompVarByName(StatID) == true then
				table.insert(userTopMenu.images[id],image("gfx/Stats/ui/stat_slottop.png",320,100 + i * 30,2,id))
				local ratio = (varNumber / maxScore)
				if ratio > 0.01 then	
					table.insert(userTopMenu.images[id],loadImage("gfx/Stats/ui/block.png",489 - (1 -ratio) * 57,100 + i * 30,2,id, nil, nil, 4*ratio * (114 / 128),0.5))
				end
				hudText2(id, i + 30, '©160160160'..tonumber(tostring((100 * ratio)):sub(1, 5)) ..'%',490,(93 + i * 30), 1)
				hudText2(id, i + 20, '©160160160'..displayVariable,395,(93 + i * 30), 1)
			else
				table.insert(userTopMenu.images[id],image("gfx/Stats/ui/stat_slottop2.png",320,100 + i * 30,2,id))
				hudText2(id, i + 20, '©160160160'..displayVariable,460,(93 + i * 30), 1)
			end
			local color, color2 = "©160160160", ""
			local user
			if (tonumber(usgn) ~= nil) then	
				if (GetPlayerUSGN(id) == usgn) then
					color = "©160255160"
				end
				user = UserManager.data[usgn]
				color2 = "©100180100#"..usgn
			else
				if player(id,"usgn") < 1 then
					if (GetIP(id) == usgn) then
						color = "©160255160"
					end
				end
				user = UserManager.dataIP[usgn]
				color2 = "©255160160IP"
			end
			hudText2(id, i, '©160160160'..p,105,(93 + i * 30), 1)
			hudText2(id, i + 10, color..user.name..' ('..color2..color..')',260,(93 + i * 30), 1)
			if CFG_LOCATION_MODE then
				local iso = user.flagIso 
				if iso and iso ~= "--" and iso ~= "none"  and iso ~= "ZZ" then
					local path = "<flag:"..iso..">"
					table.insert(userTopMenu.images[id],loadImage(path,138 ,100 + i * 30,2,id))
				end
			end
		else
			userTopMenu.nextPage[id] = false 
			break
		end
	end
	
	local pagesCount = math.ceil((#TopStatsList) / 9)
	if page + 1 == pagesCount then
		userTopMenu.nextPage[id] = false
	end
	table.insert(userTopMenu.images[id],image("gfx/Stats/ui/stat_slot5.png",320 , 85,2,id))
	table.insert(userTopMenu.images[id],image(GetStatsImageByID(StatID), 320 , 85 ,2,id))
	if (page > 0) then
		table.insert(userTopMenu.images[id], image("gfx/Stats/ui/Stat_arrow_up.png",106 , 99,2,id))
	end
	if userTopMenu.nextPage[id] then
		table.insert(userTopMenu.images[id],image("gfx/Stats/ui/Stat_arrow_down.png",106 , 400,2,id))
	end	
	local var = GetStatsVariableByID(StatID,id)
	var = nilZero(var,"none")
	hudText2(id, 40, '©255255255(page '..(page + 1)..' of '..pagesCount..')',310,38, 1)
	hudText2(id, 41, '©160160160'..GetStatsByID(StatID),390,65, 1)
	hudText2(id, 42, '©160160160'..var,390,88, 1)
	hudText2(id, 43, '©160255160'..player(id,"name"),250,65, 1)
	hudText2(id, 44, '©255160060'..GetYourPlace(id,TopStatsList,StatID).."©160160160 / "..#TopStatsList,250,88, 1)
	if (next == nil) then
		fadeImageEffect(id,"gfx/Stats/ui/topmenueff.png",320,230)
	end
	PrintDebug("[Open '"..GetStatsByID(StatID).."' Statistics Top List Menu] "..player(id,"name").." (#"..player(id,"usgn")..") "..(os.clock() - m).."ms")
end

function closeTopMenu(id, noSound)
	CloseMenuTable(id,userTopMenu,44,"gfx/Stats/ui/topmenueff.png",320,230, noSound)
end

function StatsTopMenuClientdata(id,mode,data1,data2)
	if (mode == 0 and userTopMenu.open[id] ~= nil) then
		local px = data1
		local py = data2
		if (pointInRect(px,py,90,85,30,20) and userTopMenu.page[id] > 0) then
			openTopMenu(id, userTopMenu.StatID[id], userTopMenu.page[id] - 1,true)
			PrintDebug("[PreviousPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
		end
		if (pointInRect(px,py,90,390,30,20) and userTopMenu.nextPage[id]) then
			openTopMenu(id, userTopMenu.StatID[id], userTopMenu.page[id] + 1,true)
			PrintDebug("[NextPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
		end
		if (pointInRect(px,py,245,390,150,25) or pointInRect(px,py,535,40,15,15)) then
			closeTopMenu(id)
		end
	end
end
