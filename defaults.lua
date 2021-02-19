
--[[
Script Name: RP2D Defaults
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, defauls, config
This script is licensed under the GPL.
(C) 2020 Marcell
]]

json = require "json"

function initPlayerTable(m)
    local array = {}
    for i = 1, m do
        array[i]= player(i, "name")
    end
    return array
end

function dump(o, tblname)
    if type(o) == 'table' then
       local s = tblname..' = { '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

 function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end



dofile("sys/lua/wrapper.lua")
dofile("sys/lua/includes/timerex.lua")
--[[
1. Call getPlayerID() once and store the value at local variable then reference that everywhere.
3. Consider using inline table declaration, like RP2D.player = {name = ..., usgn = ..., etc}. Same for RP2D.data DONE
]]

