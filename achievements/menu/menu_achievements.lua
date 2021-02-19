userAchievementsMenu = InitMenuTable()


function openAchiementsMenu(id, page)
	PrintDebug("[Open Achievements Menu] "..player(id,"name").." (#"..player(id,"usgn")..")")
	closeAchiementsMenu(id,true)
	fadeInfo(id)
	setKnife(id)
	page = SetUpMenuTable(userAchievementsMenu,id,page)
	table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/achievementsmenu.png",322,230,2,id))
	for i = 0, 7 do
		local p = i + page * 2
		local ach = GetAchievementByID(p)
		if (ach ~= "NULL") then
			local value = GetAchievementValue(id,GetAchievementValueByName(ach))
			table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/stat_slotachievement.png",307,68 + i * 45,2,id))
			if (value == 0) then
				local process = AchievementsManager.data[ach].progressFunction
				if process ~= nil then
					local ratio = process(id)
					if  ratio > 1 then
						ratio = 1
					end
					table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/stat_unlock.png",269,68 + i * 45,2,id))
					if AchievementsManager.data[ach].tempProgress then
						table.insert(userAchievementsMenu.images[id],loadImage("gfx/stats/ui/block2.png",269 - (1 - ratio) * 64,68 + i * 45,2,id, nil, nil,4*ratio,0.5))
					else
						table.insert(userAchievementsMenu.images[id],loadImage("gfx/stats/ui/block.png",269 - (1 - ratio) * 64,68 + i * 45,2,id, nil, nil,4*ratio,0.5))
					end
					hudText2(id, i, '©160160160Progress ('..math.ceil(100 * ratio).."%)",269,60 + i * 45,1)
				end
				table.insert(userAchievementsMenu.images[id], image("gfx/stats/ui/locked.png",144,68 + i * 45,2,id))
			else
				table.insert(userAchievementsMenu.images[id],loadImage(GetAchievementImageByID(p),144,68 + i * 45,2,id, nil, nil,.5,.5))
				hudText2(id, i, '©160235160'..ach,265,62 + i * 45,1)
				value = value - 1
				hudText2(id, i + 33, '©235235068#'..value,100 + 56,61 + 14 + i * 45,1)
			end
			
			local des = GetAchievementDescriptionByID(p)
			if (#des == 2) then
				hudText2(id, i * 2 + 8, '©160160160'..des[1],453,54 + i * 45,1)
				hudText2(id, i * 2 + 9, '©160160160'..des[2],453,68 + i * 45,1)
			elseif (#des == 1) then
				hudText2(id, i * 2 + 8, '©160160160'..des[1],453,61 + i * 45,1)
			end
			hudText2(id, i + 25, '©235235068'..GetAchievementGameModeByID(p),100,61 + i * 45,1)
		end
	end
	local pagesCount = math.ceil(#AchievementsManager.sortedList / 8)
	if (pagesCount * 8) <= page * 2 + 8 then
		userAchievementsMenu.nextPage[id] = false 
	end
	if userAchievementsMenu.page[id] > 0 then
		table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/stat_arrow_up.png",561,60,2,id))
	else
		table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/stat_pageslot.png",561,60,2,id))
	end
	if userAchievementsMenu.nextPage[id] and pagesCount > 1 then
		table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/stat_arrow_down.png",561,389,2,id))
	else
		table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/stat_pageslot.png",561,389,2,id))
	end
	local size = 302 / pagesCount
	local y = 223 - (300 - size) / 2 + size * (page * (2 / 8)) 
	table.insert(userAchievementsMenu.images[id],image("gfx/stats/ui/ach_scroll.png",561,224,2,id))
	table.insert(userAchievementsMenu.images[id],loadImage("gfx/stats/ui/ach_scroll_b.png",561 ,y,2,id,nil,nil,1,size))
	table.insert(userAchievementsMenu.images[id],loadImage("gfx/stats/ui/ach_scroll_a.png",561, y - size / 2,2,id))
	table.insert(userAchievementsMenu.images[id],loadImage("gfx/stats/ui/ach_scroll_a.png",561, y + size / 2,2,id, 180))
end


function closeAchiementsMenu(id, noSound) -- 40?
	CloseMenuTable(id,userAchievementsMenu,40,"gfx/stats/ui/achievementsmenueff.png",322,230, noSound)
end

function StatsAchiementsMenuClientdata(id,mode,data1,data2)
	if (mode == 0 and userAchievementsMenu.open[id] ~= nil) then
		local px = data1
		local py = data2	
		if (pointInRect(px,py,245,413,150,20) or pointInRect(px,py,547,20,15,15)) then
			closeAchiementsMenu(id)
		end
		local pagesCount = math.ceil(#AchievementsManager.sortedList / 8)
		if pointInRect(px,py,541,375,27,20) and userAchievementsMenu.nextPage[id] and pagesCount > 1 then
			openAchiementsMenu(id, userAchievementsMenu.page[id] + 4)
			PrintDebug("[NextPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
		end
		if pointInRect(px,py,541,46,27,20) and userAchievementsMenu.page[id] > 0 then
			openAchiementsMenu(id, userAchievementsMenu.page[id] - 4)
			PrintDebug("[PreviousPage] "..player(id,"name").." (#"..player(id,"usgn")..")")
		end	

		for i = 0, 7 do
			local ix = i * 45
			if pointInRect(px,py,76,45 + ix,290,40) then
				local iid = i + userAchievementsMenu.page[id] * 2
				local ach = GetAchievementByID(iid)
				local value = GetAchievementValue(id,GetAchievementValueByName(ach))
				if value > 0 then
					closeAchiementsMenu(id)
					OpenAchievementTopMenu(id,0,iid)
				end
			end
		end
	end
end

function closeAchiementsMenuDie(a,b)
	closeAchiementsMenu(b)
end
