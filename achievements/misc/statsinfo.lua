infoImages = { images = {}, fadeout = {}}



function AddInfo(id)
	if (CFG_INFO ~= true) then
		return
	end
	RemoveInfo(id)
	local pw = player(id,"screenw")
	local w0 = 640 / 2 - pw / 2
	local w1 = 640 / 2 + pw / 2
	local h1 = 480 / 2 + player(id,"screenh") / 2
	table.insert(infoImages.images[id], loadImage("gfx/stats/ui/stat_info.png",w1-20,h1-(480-365),2,id))
	table.insert(infoImages.images[id], loadImage("gfx/stats/ui/stat_info.png",w1-40,h1-(480-395),2,id))
	table.insert(infoImages.images[id], loadImage("gfx/stats/ui/stat_info.png",w1-10,h1-(480-335),2,id))
	table.insert(infoImages.images[id], loadImage("gfx/stats/ui/stat_info.png",w0+50,h1-(480-400),2,id))
	hudText2(id, 46, "©180180180Look at statistics - [F2]",w1-10,h1-(480-358), 2)
	hudText2(id, 47, "©180180180Press buttons - [E] or [F4]",w1-10,h1-(480-388), 2)
	if GetPlayerUSGN(id) > 0 then
		hudText2(id, 48, "©180255180User: #"..player(id,"usgnname").." ("..player(id,"usgntype")..")",w0+5,h1-(480-394))
	else
		hudText2(id, 48, "©180255180IPN: #"..GetPlayerUSGN(id),w0+5,h1-(480-394))
		hudText2(id, 48, "©255080080USGN: Failed ("..GetIP(id)..")",w0+5,h1-(480-394))
	end
	hudText2(id,49, "©128128128by Blazing (v2.0b)",w1-10,h1-(480-328),2)
end

function bringInfo(id)
	if (CFG_INFO ~= true) then
		return
	end
	if CFG_INFO_FADEOUT then
		if infoImages.fadeout[id] and infoImages.fadeout[id] > CFG_INFO_FADEOUT then
			return
		end
	end
	if infoImages.images[id] then
		for i, f in pairs (infoImages.images[id]) do
			tween_alpha(f,500,1) 
		end
		parse("hudtxtalphafade "..id.." 46 1000 1")
		parse("hudtxtalphafade "..id.." 47 1000 1")
		parse("hudtxtalphafade "..id.." 48 1000 1")
		parse("hudtxtalphafade "..id.." 49 1000 1")
	end
end

function fadeInfo(id)
	if (CFG_INFO ~= true) then
		return
	end
	if infoImages.images[id] then
		for i, f in pairs (infoImages.images[id]) do
			tween_alpha(f,500,0) 
		end
		parse("hudtxtalphafade "..id.." 46 1000 0")
		parse("hudtxtalphafade "..id.." 47 1000 0")
		parse("hudtxtalphafade "..id.." 48 1000 0")
		parse("hudtxtalphafade "..id.." 49 1000 0")
	end
end

function resetInfoTable(id)
	infoImages.images[id] = {}
	infoImages.fadeout[id] = 0
end

function InfoStartRound()
	for i = 1, 32 do
		if CFG_INFO_FADEOUT then
			infoImages.fadeout[i] = 0
		end
		resetInfoTable(i)
	end
end

function InfoTextFadeOutSecond(id)
	if CFG_INFO_FADEOUT then
		infoImages.fadeout[id] = infoImages.fadeout[id] + 1
		if (infoImages.fadeout[id] == CFG_INFO_FADEOUT) then
			fadeInfo(id)
		end
	end
end

function RemoveInfo(id)
	if infoImages.images[id] then
		for i, f in pairs (infoImages.images[id]) do
			removeImage(f)
		end
	end
	resetInfoTable(id)
	hudText2(id,46, "",0,0,2)
	hudText2(id,47, "",0,0,2)
	hudText2(id,48, "",0,0,2)
	hudText2(id,49, "",0,0,2)
end

if CFG_INFO then
	AddGlobalFunction("startround_prespawn",InfoStartRound)
	AddFunction("spawn", AddInfo)
	AddFunction("startround", AddInfo)
	AddFunction("die", RemoveInfo)
	AddFunction("leave",resetInfoTable)
	AddFunction("second", InfoTextFadeOutSecond)
	InfoStartRound()
end