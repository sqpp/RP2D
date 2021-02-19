graphManager = { data = {}, sortedList = {} }

GraphLoaded = false
function AddGraph(statName, _increasing)
	graphManager.data[statName] = { name = statName,  type = 1,increasing = _increasing, valueGlobal = {}, valueGlobalMinutes = {}, timeGlobal = 0 }
	table.insert(graphManager.sortedList,statName)
end

function AddGraphPieChart(statName, top, func)
	graphManager.data[statName] = { name = statName, type = 2, topCount = top, pieGraphFunction = func}
	table.insert(graphManager.sortedList,statName)
end

function AddOverallStatistics(statName, _descriptionFunc)
	graphManager.data[statName] = { name = statName, type = 3, descriptionFunction = _descriptionFunc}
	table.insert(graphManager.sortedList,statName)
end

function GetGraphByID(id)
	local k = graphManager.sortedList[id + 1] 
	if (k ~= nil) then
		return(k)
	end
	return("NULL")
end

function UpdateGraphManager()
	for i , k in pairs (graphManager.data) do
		if (k.type == 1) then
			k.timeGlobal = k.timeGlobal + 1
		end
	end
end

function IncGraphGlobalVariable(statName, var)
	local k = graphManager.data[statName]
	if k then
		if (k.timeGlobal < 3600) and var < 256 then
			if (k.valueGlobal[k.timeGlobal] == nil) then
				k.valueGlobal[k.timeGlobal] = var
			else
				k.valueGlobal[k.timeGlobal] = k.valueGlobal[k.timeGlobal] + var
			end
		else
			local time = math.floor(k.timeGlobal / 60) * 60
			if (k.valueGlobalMinutes[time] == nil) then
				k.valueGlobalMinutes[time] = var
			else
				k.valueGlobalMinutes[time] = k.valueGlobalMinutes[time] + var -- Use Minute if > 256
			end
		end
	end
end

function SetGraphGlobalVariable(statName, var)
	local k = graphManager.data[statName]
	if k then
		if (k.timeGlobal < 3600 and var < 255) then
			k.valueGlobal[k.timeGlobal] = var
		else
			local time = math.floor(k.timeGlobal / 60)  * 60
			k.valueGlobalMinutes[time] = var
		end
	end
end

function GraphManagerSaveValues()
	PrintDebug("[Starting To Save Graph Statistics Data] ")
	local m = os.clock()
	if (GraphLoaded == false) then
		return
	end
	local stream = WriteStream(CFG_DATA_GRAPH_PATH)
	WriteInt(stream,#graphManager.sortedList)
	for m, p in pairs(graphManager.sortedList) do
		local k = graphManager.data[p]
		local type = k.type
		if (type == 1) then
			WriteLine(stream,p) 
			WriteInt(stream,1) 
			WriteInt(stream,k.timeGlobal)  
			local count = table.map_length(k.valueGlobal)
			WriteInt(stream,count)          
			for m, p in pairs(k.valueGlobal) do
				WriteInt(stream,m)                    
				WriteByte(stream,p)
			end
			local count = table.map_length(k.valueGlobalMinutes)
			WriteInt(stream,count)                          
			for m, p in pairs(k.valueGlobalMinutes) do
				WriteInt(stream,m)                       
				WriteInt(stream,p)
			end
		end
	end
	CloseStream(stream)
	PrintDebug("[Graph Statistics Saved] "..(os.clock() - m).."ms")
end


function GraphManagerLoadValues()
	PrintDebug("[Starting To Load Graph Statistics Data] ")
	local stream = ReadStream(CFG_DATA_GRAPH_PATH)
	local m = os.clock()
	if (stream) then
		local count = ReadInt(stream)
		for i = 1, count do	
			local name = ReadLine(stream)
			local type = ReadInt(stream)	
			if (type == 1) then
				local graph = graphManager.data[name]
				local time = ReadInt(stream)
				local cnt = ReadInt(stream)
				if graph then
					graph.timeGlobal = time
				end
				for k = 1, cnt do
					local j = ReadInt(stream)
					local b = ReadByte(stream)
					if (j > 3600) then
						j = math.floor(j / 60) * 60
					end
					if graph then
						graph.valueGlobal[j] = b	
					end
				end
				local cnt = ReadInt(stream)
				for k = 1, cnt do
					local j = ReadInt(stream)
					local b = ReadInt(stream)
					if graph then 
						graph.valueGlobalMinutes[j] = b 
					end
				end
			end
		end
		CloseStream(stream)
	end
	GraphLoaded = true
	PrintDebug("[Values Loaded ] "..(os.clock() - m).."ms")
end

AddGlobalFunction("second",UpdateGraphManager)
