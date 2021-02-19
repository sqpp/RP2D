
local log = {}


local errType =  { 1, 2, 3}


function RP2D.log (logType, errType, msg)


	if (logType == "console") then
		cmsg("[RP2D][" .. logType:upper() .. "][" ..os.date("%x %X") .. "] " .. tostring(msg))
	elseif (logType == "error") then
		print("ERR")
	elseif (logType == "warning") then
		print("WARN")
	elseif (logType == "notice") then
		print("[RP2D][" .. logType:upper() .. "][" ..os.date("%x %X") .. "] " .. tostring(msg))
	else
		print("UNKN")
	end

   
end
