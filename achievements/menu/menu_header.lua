UserInputHandler = {}
for i = 1, 32 do
	UserInputHandler[i] = 0
end

function StatsMenuServeraction(id,action)
	PrintDebug("[F"..(action+1).."] "..player(id,"name").." (#"..player(id,"usgn")..")")
	if UserInputHandler[id] > CFG_MENUSPAM then
		if UserInputHandler[id] < CFG_MENUSPAM + 2 then
			msg2(id,"©255175060[Menu] ©160160160Do not spam with menus")
			UserInputHandler[id] = UserInputHandler[id] + 1
			closeAllMenus(id)
		end
		return
	end
	if (CFG_MENU_SERVERACTION_STATISTICS and action == CFG_MENU_SERVERACTION_STATISTICS_ACTION) then
		if (userMenu.open[id] == nil) then
			closeAllMenus(id)
			CloseUnlockAchievement(id)
			openMenu(id)	
		else
			closeMenu(id)
		end
	end
	if (CFG_MENU_SERVERACTION_ACHIEVEMENTS and action == CFG_MENU_SERVERACTION_ACHIEVEMENTS_ACTION) then
		if (userAchievementsMenu.open[id] == nil) then
			closeAllMenus(id)
			CloseUnlockAchievement(id)
			openAchiementsMenu(id)
		else
			closeAchiementsMenu(id)
		end
	end
	if (CFG_MENU_SERVERACTION_BUTTONPRESSING and action == CFG_MENU_SERVERACTION_BUTTONPRESSING_ACTION) then
		if (userRankInfoMenu.open[id] ~= nil  or graphMenu.open[id] ~= nil or userAchievementTopMenu.open[id] ~= nil) or (userMenu.open[id] ~= nil) or (userTopMenu.open[id] ~= nil ) or (userAchievementsMenu.open[id] ~= nil or userLeaderboard.open[id] ~= nil) then 
			reqcld(id,0)	
		end
	end
	UserInputHandler[id] = UserInputHandler[id] + 1
end

function InitMenuTable()
	return({ page = {}, images = {}, open = {}, nextPage = {}, StatID = {}})
end

function SetUpMenuTable(menuTable,id,page)
	parse("sv_sound2 "..id..' "stats/MenuOn.ogg"')
	menuTable.images[id] = {}
	menuTable.open[id] = true
	menuTable.nextPage[id] = true
	menuTable.page[id] = nilZero(menuTable.page[id])
	if page == nil then
		page = menuTable.page[id]
	else
		menuTable.page[id] = page
	end
	return(page)
end

function CloseMenuTable(id,table,hudTextID,path,x,y, noSound)
	if (table.open[id] == nil) then return end
	bringInfo(id)
	PrintDebug("[CloseMenu] "..player(id,"name").." (#"..player(id,"usgn")..")")
	for i, f in pairs (table.images[id]) do
		removeImage(f)	
	end
	table.images[id] = {}
	for i = 0, hudTextID do
		closeHudText(id,i)
	end
	if (noSound ~= true) then
		parse("sv_sound2 "..id..' "Stats/MenuOff.ogg"')
		fadeImageEffect(id,path,x,y)
	end
	table.open[id] = nil
end

function StatsMenuPushButton(id)
	if (userRankInfoMenu.open[id] or graphMenu.open[id] or userAchievementTopMenu.open[id] or userLeaderboard.open[id] or userMenu.open[id] or userTopMenu.open[id] or userAchievementsMenu.open[id]) then 
		if UserInputHandler[id] > CFG_MENUSPAM then
			if UserInputHandler[id] < CFG_MENUSPAM + 2 then
				msg2(id,"©255175060[Menu] ©160160160Do not spam with menus")
				closeAllMenus(id)
			end
			UserInputHandler[id] = UserInputHandler[id] + 1
			return
		end
		PrintDebug("[reqcld] "..player(id,"name").." (#"..player(id,"usgn")..")")
		reqcld(id,0)
		UserInputHandler[id] = UserInputHandler[id] + 1
	end
end

if CFG_MENU_BUTTONPRESSING_USE then
	AddFunction("use",StatsMenuPushButton)
end
if CFG_MENU_BUTTONPRESSING_ATTACK then
	AddFunction("attack",StatsMenuPushButton)
end

function closeAllMenus(id)
	closeAchiementsMenu(id)
	closeTopMenu(id)
	closeLeaderboardMenu(id)
	closeMenu(id)
	closeAchievementTopMenu(id)
	closegraphMenu(id)
	closeRankInfoMenu(id)
end

function ResetAllMenus(id)
	userAchievementsMenu.images[id] = {}
	userTopMenu.images[id] = {}
	userLeaderboard.images[id] = {}
	userMenu.images[id] = {}
	userAchievementTopMenu.images[id] = {}
	graphMenu.images[id] = {}
	userRankInfoMenu.images[id] = {}
	userAchievementsMenu.open[id] = nil
	userTopMenu.open[id] = nil
	userLeaderboard.open[id] = nil
	userMenu.open[id] = nil
	userAchievementTopMenu.open[id] = nil
	graphMenu.open[id] = nil
	userRankInfoMenu.open[id] = nil
end

function ResetPages(id)
	if userMenu.page[id] then
		userMenu.page[id] = 0
	end
	if userAchievementsMenu.page[id] then
		userAchievementsMenu.page[id] = 0
	end
end
function InputHandlerFunction(id)
	if UserInputHandler[id] > 0 then
		UserInputHandler[id] = UserInputHandler[id] - 2
	end
end
AddFunction("leave",ResetPages)
AddFunction("leave",ResetAllMenus)
AddFunction("serveraction",StatsMenuServeraction)
AddFunction("second",InputHandlerFunction)
