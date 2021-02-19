AchievementsManager = { data = {}, values = {}, sortedList = {} }

GameModes = { [5] = "©100100100ALL", [0] = "©160160160SD", [10] = "©255160160DE", [20] = "AS", [1] = "©160160255DM", [2] = "©160160255TDM", [3] = "©160160255CON", [4] = "ZM"}

function AddAchievement(statName, _gamemode,image_path,  _description, _value, procFunc,  temp)
	AchievementsManager.data[statName] = { image = image_path, description = _description, value = _value, progressFunction = procFunc, gameMode = _gamemode, tempProgress = temp }
	table.insert(AchievementsManager.sortedList,statName)
	if (_value ~= nil) then 
		AddValue("ACHIEVEMENT_".._value)
	end
end

function GetAchievementByID(id)
	local k = AchievementsManager.sortedList[id + 1]
	if k then
		return(k)
	end
	return("NULL")
end

function GetAchievementGameModeByID(id)
	local k = GetAchievementByID(id)	
	if (k ~= "NULL") then
		return(GameModes[AchievementsManager.data[k].gameMode])
	end
	return("NULL")
end

function GetAchievementDescriptionByID(id)
	local k = GetAchievementByID(id)	
	if (k ~= "NULL") then
		return(AchievementsManager.data[k].description)
	end
	return("NULL")
end

function GetAchievementImageByID(id)
	local k = GetAchievementByID(id)	
	if (k ~= "NULL") then
		return(AchievementsManager.data[k].image)
	end
	return("NULL")
end

function GetAchievementValueByName(name)
	local ach = AchievementsManager.data[name]
	if ach and ach.value then 
		return(ach.value)
	end
	return("NULL")
end

function GetAchievementDescriptionByName(id)
	return(AchievementsManager.data[id].description)
end

function GetAchievementImageByName(id)
	return(AchievementsManager.data[id].image)
end

function GetAchievementNameByValue(id)
	for i , k in pairs (AchievementsManager.sortedList) do
		if (GetAchievementValueByName(k) == id) then
			return(k)
		end
	end
	return("NULL")
end

function GetAchievementGameModeByValue(id)
	for i , k in pairs (AchievementsManager.sortedList) do
		if (GetAchievementValueByName(k) == id) then
			return(AchievementsManager.data[k].gameMode)
		end
	end
	return("NULL")
end

function GetAchievementValue(id,value)
	return(GetUserValue(id,"ACHIEVEMENT_"..value))
end

function GetAchievementDataValue(id,value) 
	return(GetUserValue(id,"ACHIEVEMENT_"..value))
end
function SetAchievementValue(id,value,inc)
	SetUserValue(id,"ACHIEVEMENT_"..value,inc)
end


