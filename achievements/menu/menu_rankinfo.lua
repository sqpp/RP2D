userRankInfoMenu = InitMenuTable()


function openRankInfoMenu(id)
	SetUpMenuTable(userRankInfoMenu,id)
	fadeInfo(id)
	setKnife(id)
	table.insert(userRankInfoMenu.images[id],image("gfx/stats/rnk/rankinfo.png",320,140,2,id))
	fadeImageEffect(id,"gfx/stats/rnk/rankinfoeff.png",320,140)
end	

function closeRankInfoMenu(id)
	CloseMenuTable(id,userRankInfoMenu ,0,"gfx/stats/rnk/rankinfoeff.png",320,140)
end

function StatsRankInfoClientdata(id,mode,data1,data2)
	if (mode == 0 and userRankInfoMenu.open[id] ~= nil) then
		local px = data1
		local py = data2
		if pointInRect(px,py,200,175,140,20)  then
			closeRankInfoMenu(id)
		end
	end
end