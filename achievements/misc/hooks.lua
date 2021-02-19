hooksList = {"objectdamage","join","startround_prespawn","objectkill","name","achievement","move","drop","select","attack2","leave","objectupgrade","buildattempt","build","reload","ms100","projectile","parse","hostagerescue","dominate","flagcapture","use","buy","shieldhit","minute","mapchange","movetile","bombdefuse","bombplant","endround","spawn",  "die", "kill", "hit","attack","team","second","serveraction","startround","clientdata","menu"}

for i , k in pairs (hooksList) do
	addhook(k,k.."Hook")
	_G[k.."HookFunctions"] = {}
	_G[k.."HookGlobalFunctions"] = {}
end

StartRound = true

function AddGlobalFunction(functionHook, statFunction)
	local found = 0
	for i , k in pairs (hooksList) do
		if (functionHook == k) then
			found = 1
			table.insert(_G[k.."HookGlobalFunctions"],statFunction)	
		end
	end
	if found == 0 then
		PrintErrorDebug("[E4] "..functionHook.." hooks global function not found")
	end 
end

function RemoveGlobalFunction(functionHook, statFunction)
	local found = 0
	for i , k in pairs (_G[functionHook.."HookGlobalFunctions"]) do
		if (statFunction == k) then
			found = 1
			_G[functionHook.."HookGlobalFunctions"][i] = nil	
		end
	end
	if (found == 0) then
		PrintErrorDebug("[E3] "..functionHook.." hooks function not found")
	end 
end

function AddFunction(functionHook, statFunction)
	local found = 0
	if statFunction == nil then
		PrintErrorDebug("[E1] "..functionHook.." hooks function in nil")
	end
	for i , k in pairs (hooksList) do
		if (functionHook == k) then
			found = 1
			table.insert(_G[k.."HookFunctions"],statFunction)	
		end
	end
	if (found == 0) then
		PrintErrorDebug("[E2] "..functionHook.." hooks function not found")
	end 
end

function moveHook(id,x,y,w)
	shortcut(moveHookFunctions,id,x,y,w)
end

function achievementHook(id)
	shortcut(achievementHookFunctions,id)
end

function joinHook(id)
	shortcut(joinHookFunctions,id)
end

function objectkillHook(id, player)
	shortcut(objectkillHookFunctions,id, player)
end

function nameHook(id,old,new,forced)
	shortcut(nameHookFunctions,id,old,new,forced)
end

function teamHook(id,team,look)
	UserManager.addUser(id)
	shortcut(teamHookFunctions,id,team,look)
end

function spawnHook(id)
	local m = os.clock()
	closeAllMenus(id)
	shortcut(spawnHookFunctions,id)
	UpdatePlayerParameters(id)
	PrintHookDebug(" [Spawn] ".. (os.clock() - m))
end

function objectdamageHook(id, damage, player)
	shortcut(objectdamageHookFunctions,id, damage, player)
end

function dropHook(id)
	shortcut(dropHookFunctions,id)
end

function dieHook(victim, killer)
	local m = os.clock()
	closeAllMenus(victim)
	shortcut(dieHookFunctions,victim,killer)
	PrintHookDebug(" [Die] ".. (os.clock() - m))
end

function killHook(id,v,wpn)
	local m = os.clock()
	shortcut(killHookFunctions,id,v,wpn)
	PrintHookDebug(" [Kill] ".. (os.clock() - m))
end

function hitHook(v, id,weapon,hpdmg,apdmg,rawdmg)
	local m = os.clock()
	shortcut(hitHookFunctions,v,id,weapon,hpdmg,apdmg,rawdmg)
	PrintHookDebug(" [Hit] ".. (os.clock() - m))
end

function attack2Hook(id,m)
	local m = os.clock()
	shortcut(attack2HookFunctions,id,m)
	PrintHookDebug(" [Attack2] ".. (os.clock() - m))
end

function attackHook(id)
	local m = os.clock()
	shortcut(attackHookFunctions,id)
	PrintHookDebug(" [Attack] ".. (os.clock() - m))
end

function selectHook(id,type,mode)
	shortcut(selectHookFunctions,id,type,mode)
end

function menuHook(id)
	shortcut(menuHookFunctions,id)
end

function clientdataHook(id,mode,data,data2)
	shortcut(clientdataHookFunctions,id,mode,data,data2)
end

function serveractionHook(id,action)
	shortcut(serveractionHookFunctions,id,action)
end
function leaveHook(id)
	closeAllMenus(id)
	shortcut(leaveHookFunctions,id)
end
function bombplantHook(id)
	shortcut(bombplantHookFunctions,id)
end
function bombdefuseHook(id)
	shortcut(bombdefuseHookFunctions,id)
end

function movetileHook(id)
	shortcut(movetileHookFunctions,id)
end

function reloadHook(id, mode)
	shortcut(reloadHookFunctions,id, mode)
end

function shieldhitHook(id,s,w,a)
	shortcut(shieldhitHookFunctions,id,s,w,a)
end

function buyHook(id,w)
	shortcut(buyHookFunctions,id,w)
end

function objectupgradeHook(id,player,p,total)
	shortcut(objectupgradeHookFunctions,id,player,p,total)
end
function buildHook(id,type,x,y,mode,objID)
	shortcut(buildHookFunctions,id,type,x,y,mode,objID)
end

function buildattemptHook(id,type,x,y,mode,objID)
	shortcut(buildattemptHookFunctions,id,type,x,y,mode,objID)
end

function useHook(id,x,y)
	shortcut(useHookFunctions,id,x,y)
end
function flagcaptureHook(id)
	shortcut(flagcaptureHookFunctions,id,x,y)
end

function dominateHook(id)
	shortcut(dominateHookFunctions,id,x,y)
end

function hostagerescueHook(id)
	shortcut(hostagerescueHookFunctions,id)
end

function projectileHook(id,w,x,y)
	shortcut(projectileHookFunctions,id,w,x,y)
end

-- Global Functions
function mapchangeHook()
	shortcut(mapchangeHookGlobalFunctions)
	for m, p in pairs(player(0,"table")) do
		shortcut(mapchangeHookFunctions,p)
	end
end

function minuteHook()
	shortcut(minuteHookGlobalFunctions)
	for m, p in pairs(player(0,"table")) do
		shortcut(minuteHookFunctions,p)
	end
end

function secondHook()
	shortcut(secondHookGlobalFunctions)
	for m, p in pairs(player(0,"table")) do
		shortcut(secondHookFunctions,p)
	end
end

function startroundHook()
	shortcut(startroundHookGlobalFunctions)
	for m, p in pairs(player(0,"table")) do
		shortcut(startroundHookFunctions,p)
	end
end

function startround_prespawnHook(str)
	for id = 0, 32 do
		closeAllMenus(id)
		ResetAllMenus(id)
	end
	shortcut(startround_prespawnHookGlobalFunctions,str)
end

function ms100Hook()
	shortcut(ms100HookGlobalFunctions)
	for m, p in pairs(player(0,"table")) do
		shortcut(ms100HookFunctions,p)
	end
end

function endroundHook(mode)
	StartRound = true	
	shortcut(endroundHookGlobalFunctions,mode)
	for m, p in pairs(player(0,"table")) do
		shortcut(endroundHookFunctions,p,mode)
	end
end

function parseHook(str)
	shortcut(parseHookGlobalFunctions,str)
end

function shortcut(stat, a,b,c,d,e,f,g)
	for i , statFunction in pairs (stat) do
		statFunction(a,b,c,d,e,f,g)
	end
end





