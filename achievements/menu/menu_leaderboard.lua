userLeaderboard = InitMenuTable()
userLeaderboardTable = {}
function openLeaderboardMenu(id, page, StatID, next)
	PrintDebug("[Open Leaderboard Menu] "..player(id,"name").." (#"..player(id,"usgn")..")")
	closeLeaderboardMenu(id,true)
	fadeInfo(id)
	setKnife(id)

	page = SetUpMenuTable(userLeaderboard,id,page)

	userLeaderboard.StatID[id] = nilZero(userLeaderboard.StatID[id],GetStatsIDByName(CFG_LEADERBOARD_STAT_FIRST))
	
	if (StatID == nil) then
		StatID = userLeaderboard.StatID[id]
	else
		userLeaderboard.StatID[id] = StatID
	end
	local TopStatsList

	if (next == nil) then 
		userLeaderboardTable[id] = updateTopStatsList(StatID - 1)		
	end
	TopStatsList = userLeaderboardTable[id]

	table.insert(userLeaderboard.images[id],image("gfx/stats/ui/leaderboard.png",320,230,2,id))
	table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_slot2.png",565 , 65 + 30,2,id))
	table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_slot2.png",460 , 65+ 30,2,id))
	table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_slot2.png",355 , 65+ 30,2,id))
	table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_slot3.png",192 , 65+ 30,2,id))
	local StatA = GetStatsByName(CFG_LEADERBOARD_STAT_FIRST)
	local StatB = GetStatsByName(CFG_LEADERBOARD_STAT_SECOND)
	local StatC = GetStatsByName(CFG_LEADERBOARD_STAT_THIRD)
	if StatA ~= "NULL" then
		table.insert(userLeaderboard.images[id],image(StatA.image,360 - 35, 65+ 30,2,id))
		local color = "©160160160"
		if StatID == GetStatsIDByName(CFG_LEADERBOARD_STAT_FIRST) then
			color = "©160255160"
		end
		hudText2(id, 41,color..CFG_LEADERBOARD_STAT_FIRST,355 , 58+ 30, 1)
	end
	if StatB ~= "NULL" then
		table.insert(userLeaderboard.images[id],image(StatB.image,460- 30 , 65+ 30,2,id))
		local color = "©160160160"
		if StatID == GetStatsIDByName(CFG_LEADERBOARD_STAT_SECOND) then
			color = "©160255160"
		end

		hudText2(id, 42,color..CFG_LEADERBOARD_STAT_SECOND,460 , 58+ 30, 1)
	end
	if StatC ~= "NULL" then
		local color = "©160160160"
		if StatID == GetStatsIDByName(CFG_LEADERBOARD_STAT_THIRD) then
			color = "©160255160"
		end
		table.insert(userLeaderboard.images[id],image(StatC.image,565 - 30 , 65+ 30,2,id))
		hudText2(id, 43,color..CFG_LEADERBOARD_STAT_THIRD, 570, 53+ 36, 1)
	end
	for i = 0, 7 do
		local p = i + 1 + page * 8
		if (#TopStatsList >= p) then
			
			local usgn = TopStatsList[p]
			local vF = GetStatsVariableByName("Favorite Look",usgn)
			if vF ~= "NULL" then
				vF(id)
			end
			table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_slot4.png",333 - 17 , 103 + i * 32+ 30,2,id))
			hudText2(id, i,"©160160160"..p,30 , 96 + i * 32+ 30, 1)
			local color, color2 = "©160160160", ""
			if tonumber(usgn) ~= nil then
				user = UserManager.data[usgn]
				if (GetPlayerUSGN(id) == usgn) then
					color = "©160255160"
				end
				color2 = "©100180100#"..usgn
			else
				user = UserManager.dataIP[usgn]
				local ip = GetIP(id)
				if (ip == usgn) then
					color = "©160255160"
				end
				color2 = "©255160160IP"
			end
			if user.name then -- debug
				hudText2(id, i + 8,color..user.name..' ('..color2..color..')',195 , 96 + i * 32+ 30, 1)
			end
			if StatA ~= "NULL" then
				local var1 = StatA.variableFunction(usgn)
				hudText2(id, i + 16,"©160160160"..var1,355 , 96 + i * 32+ 30, 1)
			end

			if StatB ~= "NULL" then
				local var2 = StatB.variableFunction(usgn)
				hudText2(id, i + 24,"©160160160"..var2,460 , 96 + i * 32+ 30, 1)
			end
			if StatC ~= "NULL" then
				local var3 = StatC.variableFunction(usgn)
				hudText2(id, i + 32,"©160160160"..var3,565 , 96 + i * 32+ 30, 1)
			end
			if CFG_LOCATION_MODE then
				local iso = user.flagIso 
				if iso and iso ~= "--" and iso ~= "none"  and iso ~= "ZZ" then
					local path = "gfx/stats/flag/"..iso..".png"
					table.insert(userLeaderboard.images[id],loadImage(path,65 , 103 + i * 32+ 30,2,id))
				end
			else
				StatsManager.data["Favorite Look"].variableFunction(usgn)
				table.insert(userLeaderboard.images[id],loadImage(StatsManager.data["Favorite Look"].image,65 , 103 + i * 32+ 30,2,id,nil,nil,.7,.7))
			end
		else
			userLeaderboard.nextPage[id] = false
			break
		end
	end
	local pagesCount = math.ceil((#TopStatsList) / 8)
	if page + 1 == pagesCount then
		userLeaderboard.nextPage[id] = false
	end
	if userLeaderboard.nextPage[id] then
		table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_arrow_down.png",65 - 34, 386,2,id))
	end
	if userLeaderboard.page[id] > 0 then
		table.insert(userLeaderboard.images[id],image("gfx/stats/ui/stat_arrow_up.png",65 - 34, 73+ 30,2,id))
	end
	if next == nil then
		fadeImageEffect(id,"gfx/stats/ui/leaderboardeff.png",320,230)
	end
	hudText2(id, 44,"©160160160Player", 193, 58+ 30, 1)

	
	hudText2(id, 45, '©255255255(page '..(page + 1)..' of '..(pagesCount)..')',155,48, 1)
end

function closeLeaderboardMenu(id, noSound)
	CloseMenuTable(id,userLeaderboard,45,"gfx/stats/ui/leaderboardeff.png",320,230, noSound)
end

function closeLeaderboardMenuDie(a,b)
	closeLeaderboardMenu(b)
end


function StatsLeaderboardMenuClientdata(id,mode,data1,data2)
	if (mode == 0 and userLeaderboard.open[id] ~= nil) then
		local px = data1
		local py = data2
		if (pointInRect(px,py,243,378,150,23) or pointInRect(px,py,605,50,15,15)) then
			closeLeaderboardMenu(id)
		end
		if pointInRect(px,py,305,76,100,40) and GetStatsIDByName(CFG_LEADERBOARD_STAT_FIRST) ~= userLeaderboard.StatID[id] then
			openLeaderboardMenu(id, userLeaderboard.page[id], GetStatsIDByName(CFG_LEADERBOARD_STAT_FIRST))
		end
		if pointInRect(px,py,410,76,100,40) and GetStatsIDByName(CFG_LEADERBOARD_STAT_SECOND) ~= userLeaderboard.StatID[id] then
			openLeaderboardMenu(id, userLeaderboard.page[id], GetStatsIDByName(CFG_LEADERBOARD_STAT_SECOND))
		end
		if pointInRect(px,py,515,76,100,40) and GetStatsIDByName(CFG_LEADERBOARD_STAT_THIRD) ~= userLeaderboard.StatID[id] then
			openLeaderboardMenu(id, userLeaderboard.page[id], GetStatsIDByName(CFG_LEADERBOARD_STAT_THIRD))
		end
		if pointInRect(px,py,17,375,26,20) and userLeaderboard.nextPage[id] then
			userLeaderboard.page[id] = userLeaderboard.page[id] + 1
			PrintDebug("[NextPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
			openLeaderboardMenu(id, userLeaderboard.page[id], userLeaderboard.StatID[id],true)
		end
		if pointInRect(px,py,17,95,26,20) and userLeaderboard.page[id] > 0 then
			userLeaderboard.page[id] = userLeaderboard.page[id] - 1
			PrintDebug("[PreviousPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
			openLeaderboardMenu(id, userLeaderboard.page[id],userLeaderboard.StatID[id],true)
		end
	end
end
