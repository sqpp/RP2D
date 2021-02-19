if UAC == nil then UAC = {} end
UAC.init = {}

dofile("sys/lua/uac/server.lua")
dofile("sys/lua/uac/client.lua")

RP2D.log("console", 1, "UAC Configuration complete")
