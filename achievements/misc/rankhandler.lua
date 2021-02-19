
rankData = { images = {}}
rankNames = {"Peasant I","Peasant II","Peasant III","Corporal I","Corporal II","Corporal III","Sergeant I","Sergeant II","Sergeant III","Sergeant IV","Master I", "Master II", "Master II", "Master IV","Major I","Major II","Lieutenant I","Lieutenant II","Lieutenant Gold","General I","General II","General III","Commander I","Commander II","Gold Commander"}

function RankSpawn(id)
	if (CFG_RANK ~= true) then
		return
	end
	local rank = GetRankVariable(id)
	addRankImage(id,rank)
end

function GetRankVariable(id)
	local ach = AchievementsUnlockedVariable(id) 
	local rank = math.floor((ach) / 3) + 1
	if (rank > #rankNames) then
		rank = #rankNames
	end
	return(rank)
end

function RankVariable(id)
	local rank = GetRankVariable(id)
	if (rank == #rankNames) then
		return("©240140080"..rankNames[rank])
	else
		return("©240140080"..rankNames[rank].." ("..rank..")")
	
	end
end

function RankAchievement(id)
	if (CFG_RANK ~= true) then
		return
	end 
	local oldrank = math.floor((AchievementsUnlockedVariable(id) - 1)  / 3) + 1
	local rank = GetRankVariable(id)
	if (oldrank ~= rank) then
		msg("©255175060[Rank] ©160160160"..player(id,"name")..' is now "'..rankNames[rank]..'"')
	end
	addRankImage(id,rank)
end

function removeRankImage(id)
	if (CFG_RANK ~= true) then
		return
	end
	if rankData.images[id] then
		for i, f in pairs (rankData.images[id]) do
			removeImage(f) 
		end
	end
	rankData.images[id] = {}
end

function resetRankImage(id)
	rankData.images[id] = {}
end

function resetRankImagesAll()
	for i = 1, 32 do
		resetRankImage(i)
	end
end

function addRankImage(id,rank)
	removeRankImage(id)
	local w0 = 640 / 2 - player(id,"screenw") / 2
	local h1 = 480 / 2 + player(id,"screenh") / 2
	table.insert(rankData.images[id], loadImage("gfx/stats/ui/rank_info.png",w0 + 35,h1-(480-430),2,id))
	table.insert(rankData.images[id], loadImage("gfx/stats/ui/rankProgressBack.png",w0 + 35,h1-(480-437),2,id))
	local ach = AchievementsUnlockedVariable(id) 
	local rankRatio = ((ach ) % 3) / 3
	local x = 36 - 44 * (1-rankRatio) /2
	if rankRatio < .5 then
		x = x - 1
	end
	local img = loadImage("gfx/stats/ui/rankProgress.png", w0+x - 1,h1-(480-437),2,id)
	imagescale(img,rankRatio,1)
	table.insert(rankData.images[id], img)
	table.insert(rankData.images[id], loadImage("gfx/stats/rnk/rank"..rank..".png",w0 + 47,h1-(480-432),2,id))
	table.insert(rankData.images[id], image("gfx/stats/rnk/rank"..rank..".png",w0,0,id+132))
end

if CFG_RANK then
	AddGlobalFunction("startround_prespawn",resetRankImagesAll)

	AddFunction("team",removeRankImage)
	AddFunction("die",removeRankImage)
	AddFunction("leave",removeRankImage)	

	AddFunction("spawn",RankSpawn)
	AddFunction("startround",RankSpawn)
	AddFunction("achievement",RankAchievement)
	
	AddStats("Rank", "gfx/stats/stat/stat_rank.png", RankVariable , GetRankVariable)
end