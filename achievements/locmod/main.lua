
if CFG_LOCATION_MODE then
	PrintDebug("[Starting To Load Localisation] ")
	local m = os.clock()
	dofile("sys/lua/achievements/locmod/webnet.lua")
	w = webnet.new()
	e,e_msg,s = w:load('sys/lua/achievements/locmod/IpToCountry.csv')
	PrintDebug("[Localisation Loaded] "..(os.clock() - m).."ms")
else
	
end


