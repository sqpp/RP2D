userMenu = InitMenuTable()


function openMenu(id, pageID,next)
	PrintDebug("[Open Statistics Menu] "..player(id,"name").." (#"..player(id,"usgn")..")")
	closeMenu(id,true)
	fadeInfo(id)
	setKnife(id)
	if (#StatsManager.sortedList < 1) then
		msg2(id,"©255175060[Statistics] ©160235160There are no statistics available in the list.")
		return;
	end
	pageID = SetUpMenuTable(userMenu,id,pageID)
	table.insert(userMenu.images[id],image("gfx/stats/ui/statmenus.png",320,260,2,id))
	for z = 0, 2 do
		for i = 0, 3 do
			local tID = z * 4 + i
			local iid = tID  + pageID * 12	
			local stat = GetStatsByID(iid)
			if (stat ~= "NULL") then
				local ix = i * 145
				local iy = z * 60
				local var = GetStatsVariableByID(iid,id)
				if (var == nil)  then
					var = "none"
				end
				hudText2(id, tID,'©160160160'..var,37+82 + ix,151 + iy, 1)
				hudText2(id, tID + 15,'©160160160'..stat,37+82 + ix,173 + iy, 1)
				table.insert(userMenu.images[id],image("gfx/stats/ui/stat_slot.png",102 + ix,170 + iy,2,id))
				table.insert(userMenu.images[id],image(GetStatsImageByID(iid),60 + ix, 170 + iy,2,id))
			end
		end
	end
	if (pageID > 0) then
		table.insert(userMenu.images[id],image("gfx/stats/ui/stat_arrow_left.png",46 , 340,2,id))
	else
		table.insert(userMenu.images[id],image("gfx/stats/ui/stat_pageslot.png",46 , 340,2,id))
	end
	local pagesCount = math.ceil(#StatsManager.sortedList / 12)
	hudText2(id, 30,'©255255255(page '..(pageID + 1)..' of '..pagesCount..")",110,113)
	if (pageID < pagesCount - 1) then
		table.insert(userMenu.images[id],image("gfx/stats/ui/stat_arrow_right.png",186 + 405, 340,2,id))
	else
		table.insert(userMenu.images[id],image("gfx/stats/ui/stat_pageslot.png",186 + 405, 340,2,id))
	end
	local size = (107 + 405) / pagesCount
	local x = (115) - ((106) - size) / 2 + size * pageID
	table.insert(userMenu.images[id],image("gfx/stats/ui/stat_scrolls.png",116 + 405 / 2 , 340,2,id))
	table.insert(userMenu.images[id],loadImage("gfx/stats/ui/stat_scroll_b.png",x, 340,2,id,nil,nil,size - 2 / pagesCount ,1))	
	table.insert(userMenu.images[id],loadImage("gfx/stats/ui/stat_scroll_a.png",x - size / 2 , 340,2,id))
	table.insert(userMenu.images[id],loadImage("gfx/stats/ui/stat_scroll_a.png",x + size / 2 , 340,2,id,180))
	if next == nil then
		fadeImageEffect(id,"gfx/stats/ui/statmenuseff.png",320,250)
	end
end 

function closeMenu(id, noSound)
	CloseMenuTable(id,userMenu ,30,"gfx/stats/ui/statmenuseff.png",320,250, noSound)
end 

function StatsMenuClientdata(id,mode,data1,data2)
	if (mode == 0 and userMenu.open[id] ~= nil) then
		local px = data1
		local py = data2
		if (pointInRect(px,py,510,330 + 25,105,20) or pointInRect(px,py,590,115,15,15)) then
			closeMenu(id)
		end

		if (pointInRect(px,py,35,385,180,20)) then
			if CFG_RANK then
				closeMenu(id)
				openRankInfoMenu(id)	
			else
				msg2(id,"©255175060[Rank] ©160160160This feature is disabled")
			end	
		end
		if (pointInRect(px,py,34,330 + 25,180,20) or pointInRect(px,py,590,115,15,15)) then
			if CFG_GRAPHSTATISTICS then
				closeMenu(id)
				openGraphMenuMenu(id, 0, 0, nil, 0)
			else
				msg2(id,"©255175060[GraphStatistics] ©160160160This feature is disabled")
			end
		end
		if (pointInRect(px,py,222,330 + 25,135,20)) then
			if CFG_TOPLIST then
				closeMenu(id)
				openAchiementsMenu(id)
			else
				msg2(id,"©255175060[TopList] ©160160160This feature is disabled")
			end
		end
		if pointInRect(px,py,365,330 + 25,135,20) then
			if CFG_LEADERBOARD then
				closeMenu(id)
				openLeaderboardMenu(id,0)
			else
				msg2(id,"©255175060[Leaderboard] ©160160160This feature is disabled")
			end
		end
		if (pointInRect(px,py,30,330,30,20) and userMenu.page[id] > 0) then
			PrintDebug("[PreviousPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
			openMenu(id, userMenu.page[id] - 1,true)
		end
		local pagesCount = math.ceil(#StatsManager.sortedList / 12)
		if (pointInRect(px,py,405+170,330,30,20) and userMenu.page[id] < pagesCount - 1) then
			PrintDebug("[NextPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
			openMenu(id, userMenu.page[id] + 1,true)
		end
		for z = 0, 2 do
			for i = 0, 3 do
				local ix = i * 145
				local iy = z * 60
				if pointInRect(px,py,35 + ix,145 + iy,150,50) then
					local iid = z * 4 + i + userMenu.page[id] * 12	
					if (GetStatsCByID(iid,id) ~= false) then
						closeMenu(id)
						openTopMenu(id, iid,0)
					end
				end
			end
		end
	end
end

function closeMenuDie(a,b)
	closeMenu(b)
end



AddFunction("clientdata",StatsAchievementTopMenuClientdata)
AddFunction("clientdata",StatsAchiementsMenuClientdata)
AddFunction("clientdata",StatsLeaderboardMenuClientdata)
AddFunction("clientdata",StatsMenuClientdata)
AddFunction("clientdata",StatsTopMenuClientdata)
AddFunction("clientdata",StatGraphMenuClientdata)
AddFunction("clientdata",StatsRankInfoClientdata)

