--[[
Script Name: RP2D HUD Functions
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, hud
This script is licensed under the GPL.
(C) 2020 Marcell
]]

function RP2D.HUD()
    for _,pid in pairs (player(0,"table")) do
    usgn = player(pid, "usgn")
        if player(pid, "usgn") == 0 then -- If player has no USGN ID then return nothing
            return false
        else
        
            file = io.open("sys/lua/cache/usgn_"..usgn..".dat", "r")
            jsondata = file:read("*a")
            data = json.decode(jsondata)
            money = getPlayerMoney(pid) -- Get last money from save
            drink = getPlayerThirst(pid) -- Get last thrist from save
            food = getPlayerHunger(pid) -- Get last hunger from save
            local x = player(pid,"screenw") -- Player screen width in pixels
            local y = player(pid,"screenh") -- Player screen height in pixels
            
            if (x == 1912 or x == 1920) and (y == 1080) then -- FULLHD
                playerTable[pid].ui_bg = image("gfx/miami/gui/CS2D.png", (x-200), (y/2), 2, pid)
                parse('hudtxt2 '..pid.. ' 1 " '..color['Green'].. " " ..usgn.. '" '..x..' '..((y/2)-135)..' 2 0 25')
                parse('hudtxt2 '..pid.. ' 2 " '..color['Green'].. "$"  ..money.. '" '..x..' '..((y/2)-10)..' 2 0 25')
                parse('hudtxt2 '..pid.. ' 3 " '..color['Red'].. " "  ..drink.. '%" '..x..' '..((y/2)+50)..' 2 0 25')
                parse('hudtxt2 '..pid.. ' 4 " '..food.. '%" '..x..' '..((y/2)+100)..' 2 0 25')
                
            end
            if (x == 850) and (y == 480) then -- 850x480
                playerTable[pid].ui_bg = image("gfx/miami/gui/CS2D.png", (x-140), (y/2), 2, pid)
                imagescale(playerTable[pid].ui_bg,0.7,0.7)
                parse('hudtxt2 '..pid.. ' 1 " '..color['Green'].. " " ..usgn.. '" '..x..' '..((y/2)-93)..' 2 0 15')
                parse('hudtxt2 '..pid.. ' 2 " '..color['Green'].. "$"  ..money.. '" '..x..' '..((y/2)-5)..' 2 0 15')
                parse('hudtxt2 '..pid.. ' 3 " '..color['Red'].. " "  ..drink.. '%" '..x..' '..((y/2)+35)..' 2 0 15')
                parse('hudtxt2 '..pid.. ' 4 " '..food.. '%" '..x..' '..((y/2)+70)..' 2 0 15')
            end
        end
    end
end

function RP2D.RemHUD()
    for _,pid in pairs (player(0,"table")) do
    freeimage (playerTable[pid].ui_bg)
    playerTable[pid].ui_bg = nil
    parse('hudtxt2 '..pid.. ' 1 ')
    parse('hudtxt2 '..pid.. ' 2 ')
    parse('hudtxt2 '..pid.. ' 3 ')
    parse('hudtxt2 '..pid.. ' 4 ')
    end
end
