graphMenu = InitMenuTable()
graphMenu.Check = {}

function secToStr(sec)
	if sec < 60 then
		return(sec.."s")
	elseif sec < 3600 then
		return(math.floor(sec / 60).."min "..(sec % 60).."s")
	elseif sec < 86400 then
		return(math.floor(sec / 3600).."h "..(math.floor(sec / 60) % 60).."min")
	else
		return(math.floor(sec / 86400).."day "..(math.floor(sec / 3600) % 24).."h")
	end
end


function GetAllValues(value)
	local time = 0
	for userID, user in pairs (UserManager.data) do
		local var = GetUserValue(userID,value)
		time = time + var
	end	
	for userID, user in pairs (UserManager.dataIP) do
		local var = GetUserValue(userID,value)
		time = time + var
	end
	return(time)
end

function openGraphMenuMenu(id, page, StatID, nextPage, check)
	PrintDebug("[Open Graph Menu] "..player(id,"name").." (#"..player(id,"usgn")..")")
	closegraphMenu(id,true)
	fadeInfo(id)
	setKnife(id)
	page = SetUpMenuTable(graphMenu,id,page)
	
	if nil == StatID then
		StatID = 0
	end
	graphMenu.StatID[id] = StatID
	if (check == nil) then
		graphMenu.Check[id] = 0
		
	else
		graphMenu.Check[id] = check
		
	end
	table.insert(graphMenu.images[id],image("gfx/stats/ui/graphmenu.png",320,230,2,id))
	for i = 0, 2 do
		local p = i + page
		local GraphName = GetGraphByID(p)
		if GraphName ~= "NULL" then
			local color = "©160160160"
			if (p == StatID) then
				color = "©160255160"
			end
			hudText2(id, 40 + i,color..GraphName,162 + i * 160,92, 1)
			table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_slot6.png",162 + i * 160,100,2,id))
		else

			table.insert(graphMenu.images[id],DrawRect("rect",id,88+ i * 160,87,150,26))
		end
	end
	if #graphManager.sortedList > page + 3 then
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_slotgraphpage_right.png",582,100,2,id))
	else
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_slotgraphpage.png",582,100,2,id))
	end
	if page > 0 then
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_slotgraphpage_left.png",58,100,2,id))
	else
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_slotgraphpage.png",58,100,2,id))
	end
	local graph = graphManager.data[GetGraphByID(StatID)]
	if graph == nil then
		--msg("NIL")
		return
	end
	if graph.type == 3 then
		GenerateInfoGraph(id,graph)
	elseif graph.type == 2 then
		GeneratePieChart(id,graph)
	elseif graph.type == 1 then
		GenerateGraph(id,graph)
	end
end

function closegraphMenu(id, noSound)
	CloseMenuTable(id,graphMenu ,45,"gfx/stats/ui/graphmenu.png",320,230, noSound)
end

function GenerateInfoGraph(id,graph)
	local des = graph.descriptionFunction()
	local i = 0
	for valueName, valueCount in pairs (des) do
		hudText2(id, i + 1,'©160160160'..valueCount[1]..':',195,i * 23 + 128)
		hudText2(id, i + 15,'©160160160'..valueCount[2],455,i * 23 + 128, 2)
		table.insert(graphMenu.images[id], loadImage("gfx/stats/ui/stat_info.png",325,i * 23 + 136,2,id))
		i = i  + 1
	end
end

function DrawPieSlice(id,fromA, toA, path, name, i, perc)
	local line, ox, oy, fx, fy
	local x, y = 320, 240
	local step, maxStep = 5, 5
	if (toA - fromA < maxStep) then
		step = toA - fromA
	end
	for i = fromA, toA, step do
		local r = math.rad(i)
		local nx = x + math.cos(r) * 100
		local ny = y + math.sin(r) * 100
		if line == true then
			table.insert(graphMenu.images[id],DrawLineForPlayer(path,id,ox,oy,nx ,ny))
		else
			fx, fy = nx, ny
			line = true
		end
		ox, oy = nx, ny
	end	
	if (perc ~= 1) then
		local a = (fromA + toA) / 2
		local rot = math.rad(a)
		local cX = 320 + math.cos(rot) * 5
		local cY = 240 + math.sin(rot) * 5
		local img = DrawLineForPlayer(path,id,cX,cY,ox ,oy)
		if img then 
			table.insert(graphMenu.images[id],img)
		end
		local img = DrawLineForPlayer(path,id,fx,fy,cX ,cY)
		if img then 
			table.insert(graphMenu.images[id],img)
		end
		
		if math.abs(fromA - toA) > 120 then
			local x = 320 + math.cos(rot) * 50
			local y = 240 + math.sin(rot) * 50
			hudText2(id, 30 + i,name,x,y, 1)
		else
			local cX = 320 + math.cos(rot) * 120
			local cY = 240 + math.sin(rot) * 120
			local x = 320 + math.cos(rot) * 70
			local y = 240 + math.sin(rot) * 70
			
		
			if math.abs(320 - x) < 20  then
				hudText2(id, 30 + i,name,cX,cY - 5, 1)
			elseif x > 320  then
				hudText2(id, 30 + i,name,cX,cY - 5, 0)
			else
				hudText2(id, 30 + i,name,cX,cY - 5, 2)
			end
			
		
		end
	else
		hudText2(id, 30 + i,name,320,240, 1)
	end
	
end

function PieChartDrawing(id, top, allVotes)
	local a = 0
	local c = 1
	local perc = 1
	local color = {"©180225030","©205205100","©235100100","©130130242","©120064064","©255195150","©255060140","©060230250","©255060150"}
	local other = allVotes
	for name, value in pairs (top) do
		if value > 0 then
			local b = (value / allVotes) * 360
			other = other - value
			
			local varz = tostring( (  (value / allVotes) *100)  ):sub(1, 4)			
	
			if (value / allVotes) == 1 then
				DrawPieSlice(id,a, a + b, "line"..c, color[c]..name.." ("..value..") ("..varz.."%)",c, 1)
			else
				DrawPieSlice(id,a, a + b - 5, "line"..c, color[c]..name.." ("..value..") ("..varz.."%)",c)
			end
			perc = perc - (value / allVotes)
			a = a + b
			c = c + 1
		end
	end
	if other > 0 then
		if (perc == 1) then
			DrawPieSlice(id,a, 360, "lineother", "©170130242Other ("..other..") ("..tostring(   (perc*100)     ):sub(1, 4).."%)", 6, 1)
		else
			DrawPieSlice(id,a, 355, "lineother", "©170130242Other ("..other..") ("..tostring(   (perc*100)     ):sub(1, 4).."%)", 6, perc)
		end
	end
end	


function StatGraphMenuClientdata(id,mode,data1,data2)
	if (mode == 0 and graphMenu.open[id] ~= nil) then
		local px = data1
		local py = data2
		local graph = graphManager.data[GetGraphByID(graphMenu.StatID[id])]
		if (graph and graph.type == 1) then
			if (pointInRect(px,py,56,129,10,10) ) then
				openGraphMenuMenu(id, graphMenu.page[id],graphMenu.StatID[id],nil,0)
			end
			if (pointInRect(px,py,156,129,10,10) ) then
				openGraphMenuMenu(id, graphMenu.page[id],graphMenu.StatID[id],nil,2)
			end
			if (pointInRect(px,py,256,129,10,10) ) then
				openGraphMenuMenu(id, graphMenu.page[id],graphMenu.StatID[id],nil,1)
			end
		end
		if (pointInRect(px,py,243,385,150,23) or pointInRect(px,py,601,50,15,15)) then
			closegraphMenu(id)
		end
		if (pointInRect(px,py,45,85,25,25) and graphMenu.page[id] > 0) then
			openGraphMenuMenu(id, graphMenu.page[id] - 1, -1,nil,0) 
		end
		if (pointInRect(px,py,570,85,25,25) and graphMenu.page[id] < (#graphManager.sortedList - 3)) then
			openGraphMenuMenu(id, graphMenu.page[id] +1 , -1,nil,0)
		end
		for i = 0, 2 do
			local p = graphMenu.page[id] + i
			local GraphName = GetGraphByID(p)	
			if GraphName ~= "NULL" then
				if pointInRect(px,py,88+ i * 160,87,150,26) and p ~= graphMenu.StatID[id] then -- and 
					closegraphMenu(id)
					openGraphMenuMenu(id, graphMenu.page[id],p)
				end
			end
		end
	end
end

function GeneratePieChart(id,graph)
	PrintDebug("[Starting To Generate Pie Chard] ["..id.."]")
	local m = os.clock()
	


	table.insert(graphMenu.images[id],DrawRect("rect",id,320-270,240-110,520,240))
	table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,320-270,240-110,320-270,240 + 240-110))
	table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,320-270 + 520,240-110,320-270  + 520,240 + 240-110))
	table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,320-270,240-110,520+320-270,240-110))
	table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,320-270,240-110+240,520+320-270,240-110+240))
	
	local country = graph.pieGraphFunction()
	local topListCount = graph.topCount
	local top, allVotes = {}, 0
	for valueName, valueCount in pairs (country) do
		allVotes = allVotes + valueCount
		if (table.map_length(top) < topListCount) then
			top[valueName] = valueCount
		else
			for name, value in pairs (top) do
				if (value < valueCount) then
					top[name] = nil
					top[valueName] = valueCount
					break
				end
			end
		end	
	end
	if (allVotes > 0) then
		PieChartDrawing(id,top, allVotes)
	else
		-- NOT ENOUGH OF DATA
	end
	PrintDebug("[Pie Chart Generated] "..(os.clock() - m).."ms")
end

function GenerateGraph(id,graph)	
	if graphMenu.Check[id] == 0 then
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_check1.png",62 ,135,2,id))
	else
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_check0.png",62 ,135,2,id))
	end
	hudText2(id, 39,'©160160160ALL Time',73 ,128)
	if graphMenu.Check[id] == 2 then
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_check1.png",162 ,135,2,id))
	else
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_check0.png",162 ,135,2,id))
	end
	hudText2(id, 38,'©160160160Last 15 Minutes',273 ,128)
	if graphMenu.Check[id] == 1 then
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_check1.png",262 ,135,2,id))
	else
		table.insert(graphMenu.images[id],image("gfx/stats/ui/stat_check0.png",262 ,135,2,id))
	end
	hudText2(id, 37,'©160160160Last Hour',173 ,128)


	PrintDebug("[Starting To Generate Graph] ["..id.."]")
	local m = os.clock()
	
	
	local graphBar = {}

	local DataTable
	local timeElapse
	table.insert(graphMenu.images[id],DrawRect("rect",id,45,150,550,200))
		if (graph.type == true) then
		DataTable = graph.valuePlayer[GetUsgn(id)]
		timeElapse = graph.timePlayer[GetUsgn(id)] -- am USGN 0?
		--print(timeElapse)
	else
		DataTable = graph.valueGlobal
		timeElapse = graph.timeGlobal
	end
	--if timeElapse == nil then
	--	timeElapse = 0
	--end
	local maxVariable = 0
	local BarsXCount = 8
	local BarsYCount = 10
	local detail = 2
	if detail > 1 then
		BarsXCount = BarsXCount * 2
	end
	local period
	local skip = (550 / (BarsXCount - 1))
	if (timeElapse > BarsXCount and DataTable) then -- msg("global. Time: "..graph.timeElapsed )
		period = timeElapse / BarsXCount
		if graphMenu.Check[id] == 1 then
			period = 60 * 15 / BarsXCount
		end
		if graphMenu.Check[id] == 2 then
			period = 60 * 60 / BarsXCount
		end
		local count = 0
		for i , k in pairs (DataTable) do
			count = count + 1
			if (graphMenu.Check[id] == 1 and i > timeElapse - 60 * 15) or graphMenu.Check[id] == 0 or (graphMenu.Check[id] == 2 and i > timeElapse - 60 *  60) then
				local timeID
				if graphMenu.Check[id] == 1 then
					timeID = math.floor((i - timeElapse + 60 * 15) / period)
				elseif graphMenu.Check[id] == 0 then
					timeID = math.floor(i / period)
				elseif graphMenu.Check[id] == 2 then
					timeID = math.floor((i - timeElapse + 60 * 60) / period)
				end
				if timeID == 0 then
					timeID = 1
				end
				--if graphBar[timeID] then -- plus or set
				if graphBar[timeID] then
					if graphBar[timeID] < k then
						graphBar[timeID] = (k + graphBar[timeID]) / 2
					end 
				else
					graphBar[timeID] = k
				end
			end
		end
		for i , k in pairs (graph.valueGlobalMinutes) do
			count = count + 1
			if (graphMenu.Check[id] == 1 and i > timeElapse - 60 * 15) or graphMenu.Check[id] == 0 or (graphMenu.Check[id] == 2 and i > timeElapse - 60 * 60) then
				local timeID 
				
				if graphMenu.Check[id] == 1 then
				
					timeID = math.floor((i - timeElapse + 60 * 15) / period)
				elseif graphMenu.Check[id] == 0 then
					timeID = math.floor(i / period)
				elseif graphMenu.Check[id] == 2 then
					timeID = math.floor((i - timeElapse + 60 * 60) / period)
				end
				
				if timeID == 0 then
					timeID = 1
				end
				if graphBar[timeID] then
					if graphBar[timeID] < k then
						graphBar[timeID] = (k + graphBar[timeID]) / 2
					end
				else
					
					graphBar[timeID] = k
				end
			end
		end
		PrintDebug("[Graph Points] "..count)
		local LastValue = 0
		for i = 1, BarsXCount do
			if i == BarsXCount  then
				BarsXCount = BarsXCount - 1
				skip = (550 / (BarsXCount - 1))
			elseif graphBar[i] == nil then 
				if graph.increasing then
					graphBar[i] = LastValue
				else
					graphBar[i] = 0
				end
				
			end
			LastValue = graphBar[i]
		end
		for i = 1, BarsXCount do
			if (maxVariable < graphBar[i]) then
				maxVariable = graphBar[i]
			end
		end
	else
		--msg("You haven't played enough")
	end
	for i = 0, BarsXCount - 1, detail do
		if period then
			hudText2(id, i,'©160160160'..secToStr(math.floor(period*(i+1))),45 + i * skip,360, 1)
		else
			hudText2(id, i,'©160160160'..i,45 + i * skip,360, 1)
		end
		
	end
	if (maxVariable < 1) then
		BarsYCount = 2
	elseif (maxVariable > 0 and maxVariable < 10) then
		BarsYCount = maxVariable + 1
	end
	local skipY = (200 / (BarsYCount - 1))

	for i = 0,  BarsXCount - 1, detail do
		table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,45 + i * (550 / (BarsXCount - 1)), 150 , 45 + i * (550 / (BarsXCount - 1)), 350))
	end
	i = BarsXCount - 1 -- a fill
	table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,45 + i * (550 / (BarsXCount - 1)), 150 , 45 + i * (550 / (BarsXCount - 1)), 350))
	for i = 0, BarsYCount - 1 do
		table.insert(graphMenu.images[id],DrawLineForPlayer("lineblack",id,45,350 - i * skipY,45 + 400 + 150,350 - i * skipY))
		if maxVariable > 0 then
			hudText2(id, i + BarsXCount + 1,'©160160160'..math.floor(((i + 1)/BarsYCount)*maxVariable),13 + 450 + 150,330 - i * skipY + 12, 1)
		else
			hudText2(id, i + BarsXCount + 1,'©160160160'..i,13 + 450 + 150,330 - i * skipY + 12, 1)
		end
	end
	local firstValue
	for i = 1, BarsXCount do
		local value = graphBar[i]
		if value then
			if firstValue then
				local vara
				local varb
				if (maxVariable > 0) then
					vara = (firstValue / maxVariable)
					varb = (value / maxVariable)
				else
					vara = 0
					varb = 0
				end
				table.insert(graphMenu.images[id],image("gfx/stats/ui/dot.png",45 + (i - 2) * skip ,350 - vara * 200,2,id))
				table.insert(graphMenu.images[id],DrawLineForPlayer("line1",id,45 + (i - 2) * skip ,500 - vara * 200 -150,45 + (i - 2) * skip + skip,500 - varb * 200 - 150))
			end
			firstValue = value
		end
	end
	
	PrintDebug("[Graph Generated] "..(os.clock() - m).."ms")
end


--	table.insert(graphMenu.images[id],DrawLineForPlayer("line1",id,100 + i * skip,350 - vara * 200,100 + i * skip + skip * I,350 - var * 200))