unlockMenu = { images = {}, showingAchievement = {}, showList = {}}
FadeOutImageList = {}
function removeFadeOutImage(id)
	id = tonumber(id)
	if FadeOutImageList[id] and unlockMenu.images[id] then	
		for i, f in pairs (unlockMenu.images[id]) do
			freeimage(f)
		end
		unlockMenu.images[id] = {}
	end
	unlockMenu.showingAchievement[id] = nil
	FadeOutImageList[id] = nil
end

function CloseUnlockAchievement(id)
	id = tonumber(id)
	unlockMenu.showingAchievement[id] = true
	parse("hudtxtalphafade "..id.." 41 500 0")
	parse("hudtxtalphafade "..id.." 42 500 0")
	parse("hudtxtalphafade "..id.." 43 500 0")
	if unlockMenu.images[id] then
		for i, f in pairs (unlockMenu.images[id]) do
			tween_alpha(f,500,0)
		end
	end
	timer(500,"removeFadeOutImage",id)
	FadeOutImageList[id] = true
end

function GetUnlockCount(StatValue)
	local count = 0
	for i, a in pairs (UserManager.data) do -- wrong if data was deleted
		if ( GetAchievementValue(i,StatValue)  > 1) then
			count = count + 1
		end
	end
	for i, a in pairs (UserManager.dataIP) do
		if (GetAchievementDataValue(i,StatValue) > 1) then
			count = count + 1
		end
	end
	return(count)
end

function OpenUnlockAchievement(id, StatName)	
	if (GetAchievementValue(id,StatName) > 0) then
		return
	end
	local m = tonumber(GetAchievementGameModeByValue(StatName)) % 10
	if m ~= 5 and m  ~= tonumber(game("sv_gamemode")) then
		return
	end
	local name = GetAchievementNameByValue(StatName)
	SetAchievementValue(id,StatName,1)
	if (unlockMenu.showList[id] == nil) then
		unlockMenu.showList[id] = {}
	end
	table.insert(unlockMenu.showList[id],name)
end

function OpenUnlockWindow(id,achName)
	closeTopMenu(id)
	closeMenu(id)
	closeAchiementsMenu(id)
	closeAchievementTopMenu(id)
	closeLeaderboardMenu(id)
	local StatName = GetAchievementValueByName(achName)
	SetAchievementValue(id,StatName,GetUnlockCount(StatName) + 2) 

	local windowX = CFG_ACHIEVEMENT_WINDOW_X
	local windowY = CFG_ACHIEVEMENT_WINDOW_Y
	msg("©255175060[Achievement] ©160160160"..player(id,"name")..' ©160235160unlocked "'..achName..'"')

	unlockMenu.showingAchievement[id] = true

	timer(3500,"CloseUnlockAchievement",id)
	unlockMenu.images[id] = {}
	
	
	if player(id,"health") > 0 then
		SpawnEffect("colorsmoke",player(id,"x"),player(id,"y"),32,32,255,175,64)
	end
	parse("sv_sound2 "..id..' "stats/Achievement.ogg"')
	local des = GetAchievementDescriptionByName(achName)
	if CFG_UNLOCK_WINDOW_SMALL then
		table.insert(unlockMenu.images[id],image("gfx/stats/ui/unlocked2.png",windowX,windowY,2,id))
		table.insert(unlockMenu.images[id], loadImage(GetAchievementImageByName(achName),windowX,windowY - 5,2,id,nil, nil,.5,.5))
		hudText2(id, 41, '©160235160'..achName,windowX,windowY + 23,1)
		fadeImageEffect(id,"gfx/stats/ui/unlockedeff2.png",windowX,windowY,400)
	else
		if (#des == 2) then
			hudText2(id, 42, '©160160160'..des[1],windowX,windowY + 45,1)
			hudText2(id, 43, '©160160160'..des[2],windowX,windowY + 60,1)
		elseif (#des == 1) then
			hudText2(id, 42, '©160160160'..des[1],windowX,windowY + 50,1)
		end
		table.insert(unlockMenu.images[id],image("gfx/stats/ui/unlocked.png",windowX,windowY,2,id))
		table.insert(unlockMenu.images[id], image(GetAchievementImageByName(achName),windowX,windowY - 10,2,id))
		hudText2(id, 41, '©160235160'..achName,windowX,windowY - 70,1)	
		fadeImageEffect(id,"gfx/stats/ui/unlockedeff.png",windowX,windowY,400)
	end
	
	achievementHook(id)

	
	
end

function UnlockSecond(id)
	if unlockMenu.showList[id] and unlockMenu.showingAchievement[id] == nil and FadeOutImageList[id] == nil then -- might be nil
		for m, p in pairs(unlockMenu.showList[id]) do
			OpenUnlockWindow(id,p)
			table.remove(unlockMenu.showList[id], m)
			return
		end
	end
end
function ResetUnlockImages(id)
	FadeOutImageList[id] = nil
	unlockMenu.images[id] = {}	
	unlockMenu.showingAchievement[id] = nil
end

function UnlockStartround()
	FadeOutImageList = {}	
	unlockMenu.showingAchievement = {}
	for i = 0, 32 do
		unlockMenu.images[i] = {}
		closeHudText(i,41)
		closeHudText(i,42)
		closeHudText(i,43)
		ResetUnlockImages(i)
	end
end



AddFunction("leave",ResetUnlockImages)
AddGlobalFunction("startround_prespawn",UnlockStartround)
AddFunction("second",UnlockSecond)
UnlockStartround()

