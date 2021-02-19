--[[
Script Name: RP2D Autosave
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.2
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, admin, controlling, server managment
This script is licensed under the GPL.
(C) 2020 Marcell
]]
function initPlayerTable(m)
    local array = {}
    for i = 1, m do
        array[i]= player(i, "name")
    end
    return array
end

function savePlayerList()
 _players = initPlayerTable(32)
 playerlist = io.open("D:/SteamLibrary/steamapps/common/playerlist.json", "w+")
 test = json.encode(_players)
 playerlist:write(test)
 playerlist:close()
end

function RP2D.Cache(pid)
local players = player(0,"tableliving")
for _,pid in pairs (players) do
    local query = conn:query("SELECT * FROM players")
    local result = conn:store_result()
    local realUSGN = player(pid, "usgn")
    local realSteamID = player(pid, "steamid")
    for i, id, usgn, usgnname, ip, name, steamid, steamname, drink, food, money, bank, items, health, path_skin, path_attack, hair, hat, lang, lastPOSX, lastPOSY, lastLogin, uuid in result:rows() do
        

        RP2D.player = {

            cID = id,
            cUsgn = usgn,
            cUsgnname = usgnname,
            cIP = ip,
            cName = name,
            cSteamID = steamid,
            cSteamname = steamname,
            cDrink = drink,
            cFood = food,
            cMoney = money,
            cBank = bank,
            cData = {
                pItems = items
            },
            cHealth = health,
            cSkin = path_skin,
            cAttack = path_attack,
            cHair = hair,
            cHat = hat,
            cLang = lang,
            cLastPOSX = lastPOSX,
            cLastPOSY = lastPOSY,
            cLastLogin = lastLogin,
            pUUID = uuid
                
            }

       
        local playerdata = json.encode(RP2D.player)
        if (realUSGN > 0 and realSteamID ~= "") then 
            file = io.open("sys/lua/cache/usgn_"..realUSGN..".dat", "w+")
            file:write(playerdata)
            file:close()
        -- else if has no USGN ID, but logged in Steam and has valid SteamID    
        else  
            file = io.open("sys/lua/cache/steam_"..realSteamID..".dat", "w+")
            file:write(playerdata)
            file:close()
        end  
    end
    result:free()
end
RP2D.log("notice", 2, "logCache 0x1029")
end
    
        -- If USGN ID is valid (not a bot, real player and has ID, and also owns Steam ID logged in)
      

--savePlayerList()