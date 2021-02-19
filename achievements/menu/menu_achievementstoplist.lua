userAchievementTopMenu = InitMenuTable(statID)
userAchievementMenuTable = {}
function SortAchievements(StatID) 	-- INSERTION SORT
	local m = os.clock()
	local ach = GetAchievementByID(StatID)
	local TopStatsList = {}
	local TopStatsListVar = {}
	for i, a in pairs (UserManager.data) do
		local var = nilZero(tonumber( GetAchievementValue(i,GetAchievementValueByName(ach))))
		if var > 0 then
			table.insert(TopStatsList,i)
			TopStatsListVar[i] = var
		end
	end
	for i, a in pairs (UserManager.dataIP) do
		local var = nilZero(tonumber( GetAchievementDataValue(i,GetAchievementValueByName(ach))))
		if var > 0 then
			table.insert(TopStatsList,i)
			TopStatsListVar[i] = var
		end
	end
	local temp
	for i = 2, #TopStatsList do
		j = i - 1  
		local var = TopStatsListVar[ TopStatsList[i]]
		local varb = TopStatsListVar[TopStatsList[j]]
		while j > 0 and varb > var do
			temp = TopStatsList[j + 1]
			TopStatsList[j + 1] = TopStatsList[j]
			TopStatsList[j] = temp
			j = j - 1
			if j > 0 then
				varb = TopStatsListVar[TopStatsList[j]]
			end
		end
        end
	PrintDebug("[Achievements Sorting] "..(os.clock() - m).."ms")
	return(TopStatsList)
end



function OpenAchievementTopMenu(id,page,statID, next)
	
	closeAchievementTopMenu(id, true)
	fadeInfo(id)
	setKnife(id)
	local ach = GetAchievementByID(statID)
	PrintDebug("[Open '"..ach.."' Achievement Top List Menu] "..player(id,"name").." (#"..player(id,"usgn")..")")

	page = SetUpMenuTable(userAchievementTopMenu,id,page)


	local TopStatsList
	if (next == nil) then 
		userAchievementMenuTable[id] = SortAchievements(statID)	
	end
	TopStatsList = userAchievementMenuTable[id]

	userAchievementTopMenu.StatID[id] = statID
	table.insert(userAchievementTopMenu.images[id],image("gfx/Stats/ui/achtopmenu.png",320,230,2,id))
	table.insert(userAchievementTopMenu.images[id],image("gfx/Stats/ui/stat_slotactop.png",338,65,2,id))
	table.insert(userAchievementTopMenu.images[id],loadImage(GetAchievementImageByID(statID),237,65,2,id, nil, nil,.5,.5))
	hudText2(id, 18, '©160235160'..ach,360,58,1)
	for i = 0, 8 do
		local p = i + page * 9 + 1
		if (#TopStatsList >= p) then
			local usgn = TopStatsList[p]
			local color, color2 = "©160160160", ""
			local user
			if tonumber(usgn) ~= nil then
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
			hudText2(id, i + 9, color..user.name..' ('..color2..color..')',360,98 + i * 33, 1)
			hudText2(id, i, '©160160160#'..p,196,98 + i * 33,1)
			table.insert(userAchievementTopMenu.images[id],image("gfx/Stats/ui/stat_slotactop2.png",320,105 + i * 33,2,id))
			if CFS_LOCATION_MODE then
				local iso = user.flagIso 
				if iso and iso ~= "--" and iso ~= "none" and iso ~= "ZZ" then
					local path = "gfx/stats/flag/"..iso..".png"
					table.insert(userAchievementTopMenu.images[id],loadImage(path,238,105 + i * 33,2,id))
				end
			end
		else
			userAchievementTopMenu.nextPage[id] = false
		end
		if (p == #TopStatsList) then
			userAchievementTopMenu.nextPage[id] = false
		end
	end
	if page > 0 then
		table.insert(userAchievementTopMenu.images[id],image("gfx/stats/ui/stat_arrow_up.png",196, 73,2,id))
	end
	if userAchievementTopMenu.nextPage[id] then
		table.insert(userAchievementTopMenu.images[id],image("gfx/stats/ui/stat_arrow_down.png",196, 400,2,id))
	end
	if (next == nil) then 
		fadeImageEffect(id,"gfx/stats/ui/achtopmenueff.png",320,230)
	end
end


function closeAchievementTopMenu(id, noSound)
	CloseMenuTable(id,userAchievementTopMenu,18,"gfx/Stats/ui/achtopmenueff.png",320,230, noSound)
end

function StatsAchievementTopMenuClientdata(id,mode,data1,data2)
	if (mode == 0 and userAchievementTopMenu.open[id] ~= nil) then
		local px = data1
		local py = data2
		if (pointInRect(px,py,243,412,150,20) or pointInRect(px,py,448,18,15,15)) then
			closeAchievementTopMenu(id)
		end
		if pointInRect(px,py,181,61,26,20) and userAchievementTopMenu.page[id] > 0  then
			userAchievementTopMenu.page[id] = userAchievementTopMenu.page[id] - 1
			OpenAchievementTopMenu(id, userAchievementTopMenu.page[id], userAchievementTopMenu.StatID[id],true)
			PrintDebug("[PreviousPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
		end
		if pointInRect(px,py,181,389,26,20) and userAchievementTopMenu.nextPage[id]  then
			userAchievementTopMenu.page[id] = userAchievementTopMenu.page[id] + 1
			PrintDebug("[NextPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
			OpenAchievementTopMenu(id, userAchievementTopMenu.page[id],userAchievementTopMenu.StatID[id],true)
		end
	end
end
