
UserManager = {}
UserManager.data = { }
UserManager.dataIP = { }

function UserManager.addUser(id, setName, _flagIso) -- ADD BY PLAYER ID or HIS IP
	if (_flagIso == nil) then _flagIso = "none"  end
	if (setName == nil) then setName = "Undenified" end
	local userData =  { name = setName , values = {}, flagIso = _flagIso}
	userData.flagName = countryGet(_flagIso)
	if (tonumber(id) ~= nil) then 
		if (id > 32) then
			if (UserManager.data[id] ~= nil) then
				return
			end
			UserManager.data[id] = userData
		elseif (GetPlayerUSGN(id) > 32) then
			id = GetPlayerUSGN(id)
			if (UserManager.data[id] ~= nil) then
				return
			end
			UserManager.data[id] = userData
		else
			local ip = GetIP(id)
			if (UserManager.dataIP[ip] ~= nil) then
				return
			end
			UserManager.dataIP[ip] = userData
		end
	else
		local ip = id
		if (UserManager.dataIP[ip] ~= nil) then
			return
		end
		UserManager.dataIP[ip] = userData
	end
end

function GetPlayerID(id)
	if (tonumber(id) ~= nil) then 
		if (id > 32) then
			if (UserManager.data[id] ~= nil and UserManager.data[id].playerID ~= nil) then
				return(UserManager.data[id].playerID)
			end
		else
			local ip = GetIP(id)
			if (UserManager.dataIP[ip] ~= nil and UserManager.dataIP[ip].playerID ~= nil) then
				return(UserManager.dataIP[ip].playerID)
			end
		end	
	else
		local ip = id
		if (UserManager.dataIP[ip] ~= nil and UserManager.dataIP[ip].playerID ~= nil) then
			return(UserManager.dataIP[ip].playerID)
		end
	end
	return(0)
end

---- LOADING
function LoadSetIPUserValue(ip,value,set)
	if set < 1 then
		return
	end
	if (UserManager.dataIP[ip] == nil) then
		PrintErrorDebug("error: User IP ("..ip..") does not exist ") 
		UserManager.addUser(ip)
	end
	if UserManager.dataIP[ip].values == nil then
		PrintErrorDebug("error: User Values ("..ip..") does not exist ") 
		UserManager.dataIP[ip].values = {}
	end
	UserManager.dataIP[ip].values[value] = set
end

function LoadSetUserValue(id,value,set)
	if set < 1 then
		return
	end
	
	if id > 32 then -- FIX
		UserManager.data[id].values[value] = set
	end
	
end
-----------------------------

function UpdatePlayerParameters(id)
	if ( GetPlayerUSGN(id) > 32 ) then
		local usgn  = GetPlayerUSGN(id)
		UserManager.data[usgn].name = player(id,"name")
		UserManager.data[usgn].playerID = id
		if CFG_LOCATION_MODE then
			iso, name = w:lookup(player(id,"ip"))
			UserManager.data[usgn].flagIso = iso
			UserManager.data[usgn].flagName = name
		else	
			UserManager.data[usgn].flagIso = "ZZ"
			UserManager.data[usgn].flagName = "ZZ"
		end
	else
		local ip = GetIP(id)
		if (player(id,"bot") == false) then
			if CFG_LOCATION_MODE then
				iso, name = w:lookup(player(id,"ip"))
				UserManager.dataIP[ip].flagIso = iso
				UserManager.dataIP[ip].flagName = name
			else	
				UserManager.data[ip].flagIso = "ZZ"
				UserManager.data[ip].flagName = "ZZ"
			end
		else
			UserManager.addUser(ip, player(id,"name"))
		end
		UserManager.dataIP[ip].name = player(id,"name")
		UserManager.dataIP[ip].playerID = id	
	end
end

function SetUserValue(id,value,set)
	if (GetPlayerUSGN(id) > 32) then
		local usgn = GetPlayerUSGN(id)
		if (UserManager.data[usgn] == nil) then 
			PrintErrorDebug("error: User ID does not exist") 
			UserManager.addUser(id,player(id,"name")) 	
			UpdatePlayerParameters(id)
		end
		if UserManager.data[usgn].values == nil then
			PrintErrorDebug("error: a real '"..value.."' value bug") 
			UserManager.data[usgn].values = {}
		end
		UserManager.data[usgn].values[value] = set				-- check if set is NIL
	
	else
		local ip = GetIP(id)
		if (UserManager.dataIP[ip] == nil) then 
			PrintErrorDebug("error: User ID does not exist") 
			UserManager.addUser(id,player(id,"name")) 	
			UpdatePlayerParameters(id)                    --------
		end
		if UserManager.dataIP[ip].values == nil then
			PrintErrorDebug("error: a real '"..value.."' value bug") 
			UserManager.dataIP[ip].values = {}
		end
		UserManager.dataIP[ip].values[value] = set 				-- check if set is NIL
	end
end

function IncreaseUserValue(id,value,Inc) -- why exists
	if (GetPlayerUSGN(id) > 32) then
		local usgn = GetPlayerUSGN(id)
		if (UserManager.data[usgn] == nil) then 
			PrintErrorDebug("error: User ID does not exist") 
			UserManager.addUser(id,player(id,"name")) 	
			UpdatePlayerParameters(id)
		end
		if UserManager.data[usgn].values == nil then
			PrintErrorDebug("error: a real '"..value.."' value bug") 
			UserManager.data[usgn].values = {}
		end
		if (UserManager.data[usgn].values[value] == nil) then
			UserManager.data[usgn].values[value] = Inc
		else
			if Inc then
				UserManager.data[usgn].values[value] = UserManager.data[usgn].values[value] + Inc	
			else
				PrintErrorDebug("[ERROR] No 'inc' variable in 'IncValue' function")
			end
		end
	else
		local ip = GetIP(id)
		if (UserManager.dataIP[ip] == nil) then 
			PrintErrorDebug("error: User ID does not exist") 
			UserManager.addUser(ip,pName,flagName,flagIso)
			UpdatePlayerParameters(id)
		end
		if UserManager.dataIP[ip].values == nil then
			PrintErrorDebug("error: a real '"..value.."' value bug") 
			UserManager.dataIP[ip].values = {}
		end
		if (UserManager.dataIP[ip].values[value] == nil) then
			UserManager.dataIP[ip].values[value] = Inc
		else
			if Inc then
				UserManager.dataIP[ip].values[value] = UserManager.dataIP[ip].values[value] + Inc	
			else
				PrintErrorDebug("[ERROR] No 'inc' variable in 'IncValue' function")
			end
		end
	end
end

function GetUserValue(id,value)
	if (tonumber(id) ~= nil) then 
		if (id > 32) then
			if (UserManager.data[id] == nil or UserManager.data[id].values[value] == ni) then 
				return(0) 
			end
			return(UserManager.data[id].values[value])
		else
			if (GetPlayerUSGN(id) > 0) then
				id = GetPlayerUSGN(id)
				if (UserManager.data[id] == nil or UserManager.data[id].values[value] == nil) then 
					return(0) 
				end
				return(UserManager.data[id].values[value])
			else
				local ip = GetIP(id)	
				if (UserManager.dataIP[ip] == nil or UserManager.dataIP[ip].values[value] == nil) then 
					return(0)
				end
				return(UserManager.dataIP[ip].values[value])
			end
		end
	else
		local ip = id	
		if (UserManager.dataIP[ip] == nil or UserManager.dataIP[ip].values[value] == nil) then 
			return(0)
		end
		return(UserManager.dataIP[ip].values[value])
	end
end


function GetPlayerUSGN(id)
	if id == "NULL" then
		return(nil)
	end
	if tonumber(id) == nil then
		return("ERROR")
	end
	if player(id,"exists") and player(id,"usgn") > 0 then
		id = player(id,"usgn")
		return(id)
	end 
	return(0)
end

function GetPlayerIP(id)
	if player(id,"exists") and player(id,"ip") then
		return(player(id,"ip"))
	end 
	return("NULL")
end

function GetIP(id)
	local ip
	if (player(id,"bot") == true) then
		ip = "bot #"..player(id,"name")
	else
		ip = GetPlayerIP(id)
	end
	return(ip)
end