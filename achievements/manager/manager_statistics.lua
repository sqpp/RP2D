StatsManager = { data = {}, values = {}, sortedList = {}, globalData = {},  globalSortedList = {} }
StatsLoaded = false

function AddStats(statName, image_path, vFunction, cFunction, compBar)
	StatsManager.data[statName] = { image = image_path, variableFunction =  vFunction, compareFunction = cFunction	, compareBar }
	if compBar then
		StatsManager.data[statName].compareBar = true
	else
		StatsManager.data[statName].compareBar = false
	end
	table.insert(StatsManager.sortedList,statName)
end

function AddGlobalStats(statName, var)
	if var then
		StatsManager.globalData[statName] = var
	else
		StatsManager.globalData[statName] = 0
	end 
	table.insert(StatsManager.globalSortedList,statName)
end

function GetGlobalStats(statName)
	if StatsManager.globalData[statName] then
		return(StatsManager.globalData[statName])
	end
	return (0)
end

function IncGlobalStats(statName)
	if StatsManager.globalData[statName] then
		StatsManager.globalData[statName] = StatsManager.globalData[statName] + 1
	end
end

function GetStatsIDByName(id)
	for i , k in pairs (StatsManager.sortedList) do
		if (k == id) then
			return(i)
		end
	end
	return("NULL")
end

function GetStatsByName(id)
	local k = StatsManager.data[id]
	if k ~= nil then
		return(k)
	end
	return("NULL")
end

function GetStatsByID(id)
	local k = StatsManager.sortedList[id + 1]
	if k ~= nil then
		return(k)
	end
	return("NULL")
end

function GetStatsCompVarByName(id)
	local k = StatsManager.data[GetStatsByID(id)]
	if k ~= nil and k.compareBar ~= nil then
		return(k.compareBar)
	end
	return(false)
end
function GetStatsVariableByName(id)
	local k = StatsManager.data[id]
	if k ~= nil and k.variableFunction then
		return(k.variableFunction)
	end
	return("NULL")
end

function GetStatsImageByID(id)
	return(StatsManager.data[GetStatsByID(id)].image)
end

function GetStatsVariableByID(iid,id,extended)
	local k = GetStatsByID(iid)
	if k ~= "NULL" then
		if StatsManager.data[k] and StatsManager.data[k].variableFunction ~= nil then
			local var = StatsManager.data[k].variableFunction(id,extended)
			if (var ~= nil) then 
				return(var)
			else
				return("NULL")
			end
		end
	end
	return("NULL")
end

function GetStatsCompareByID(iid,id) -- iid stat id
	local k = StatsManager.sortedList[iid + 1]
	if (k ~= nil and StatsManager.data[k] ~= nil and StatsManager.data[k].compareFunction ~= nil) then
		local var = StatsManager.data[k].compareFunction(id)
		if (var ~= nil) then 
			return(var)
		else
			return("NULL")
		end
	end
	return("NULL")
end

function GetStatsCByID(iid,id)
	local k = GetStatsByID(iid)
	if k ~= "NULL" then
		if StatsManager.data[k].compareFunction == nil then
			return(false)
		else
			return(true)
		end
	end
	return(false)
end

function AddValue(valueName)
	table.insert(StatsManager.values,valueName)
end

function StatsManager.SaveValues()
	PrintDebug("[Starting To Save Values] ")
	local m = os.clock()
	if (StatsLoaded == false) then
		return
	end
	local stream = WriteStream(CFG_DATA_FILE_PATH)
	local valueList = {}
	WriteInt(stream, table.getn(StatsManager.values))
	for id, name in pairs (StatsManager.values) do
		WriteInt(stream, id)
		WriteLine(stream, name)
		valueList[name] = id
	end
	local maxval = 0
	WriteInt(stream, table.map_length(UserManager.data))
	for userID, user in pairs (UserManager.data) do
		if user.name == nil then user.name = "[error] weird name" end
		if user.flagName == nil then user.flagName = "none" end
		if user.flagIso == nil then user.flagIso = "none" end
		WriteInt(stream, userID)
		WriteLine(stream, user.name)
		WriteLine(stream, user.flagIso)
		WriteByte(stream, table.map_length(user.values))
		for valueName, valueCount in pairs (user.values) do
			if (valueList[valueName] ~= nil) then
				WriteByte(stream, valueList[valueName] )
				WriteInt(stream, valueCount)
			else	
				WriteByte(stream, 0)
				WriteInt(stream, 0)
			end
		end
	end
	WriteInt(stream, table.map_length(UserManager.dataIP))
	for userID, user in pairs (UserManager.dataIP) do
		if user.name == nil then user.name = "[error] weird name" end
		if user.flagName == nil then user.flagName = "none" end
		if user.flagIso == nil then user.flagIso = "none" end
		WriteLine(stream, userID)
		WriteLine(stream, user.name)
		WriteLine(stream, user.flagIso)
		WriteByte(stream, table.map_length(user.values))
		for valueName, valueCount in pairs (user.values) do
			if (valueList[valueName] ~= nil) then
				WriteByte(stream, valueList[valueName] )
				WriteInt(stream, valueCount)
			else
				WriteByte(stream, 0)
				WriteInt(stream, 0)
			end	
		end

	end
	WriteInt(stream, table.map_length(StatsManager.globalData))
	for valueName, valueCount in pairs (StatsManager.globalData) do
		WriteLine(stream, valueName )
		WriteInt(stream, valueCount )
	end
	CloseStream(stream)
	PrintDebug("[Values Saved] "..(os.clock() - m).."ms")
end

function StatsManager.LoadValues()
	local stream = ReadStream(CFG_DATA_FILE_PATH)
	PrintDebug("[Starting To Load Values] ")
	local m = os.clock()
	if (stream) then
		local valuesList = {}
		local valuesCount = ReadInt(stream)
  		for i = 1, valuesCount do
			id = ReadInt(stream)
			name = ReadLine(stream)
			valuesList[id] = name
		end
		local userCount = ReadInt(stream)
		for i = 1, userCount do
			userID = ReadInt(stream)
			userName = ReadLine(stream)
			userFlagIso = ReadLine(stream)
			userFlagName = countryGet(userFlagIso)
			UserManager.addUser(userID, userName,userFlagIso)
			valuesCount = ReadByte(stream)
			for i = 1, valuesCount do
				id = ReadByte(stream)
				count = ReadInt(stream)
				if (valuesList[id] == nil) then
					-- bug or statistics names were changed
				else
					if (userID > 32) then --remove later
						LoadSetUserValue(userID,valuesList[id],count)	
					end
				end
			end
		end
		local userCount = ReadInt(stream)
		for i = 1, userCount do
			userID = ReadLine(stream)
			userName = ReadLine(stream)
			userFlagIso = ReadLine(stream)
			UserManager.addUser(userID, userName,userFlagIso)
			valuesCount = ReadByte(stream)
			for i = 1, valuesCount do
				id = ReadByte(stream)
				count = ReadInt(stream)
				if (valuesList[id] == nil) then
					-- bug or statistics names were changed
				else
					LoadSetIPUserValue(userID,valuesList[id],count)	
				end
			end
		end
		local valuesCount = ReadInt(stream)
		for i = 1, valuesCount do
			valueName = ReadLine(stream)
			valueCount = ReadInt(stream)
			AddGlobalStats(valueName,valueCount )
		end
		CloseStream(stream)
	end
	StatsLoaded = true
	PrintDebug("[Values Loaded] "..(os.clock() - m).."ms")
end


