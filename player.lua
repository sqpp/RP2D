--[[
Script Name: RP2D Player Functions
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, player
This script is licensed under the GPL.
(C) 2020 Marcell
]]
    

function RP2D.ApplySkins(id)
    local usgn = player(id, "usgn") -- Get Player USGN ID
    local steam = player(id, "steamid") -- Get Player Steam ID

        if file_exists("sys/lua/cache/usgn_"..usgn..".dat") then -- if player uses USGN ID
            local file = io.open("sys/lua/cache/usgn_"..usgn..".dat", "r")
            local jsondata = file:read("*a")
            local data = json.decode(jsondata)
            playerTable[id].body = image(data['cSkin'], player(id, "x"), player(id, "y"), 200+id)
            imagescale(playerTable[id].body, 0.7,0.7)

            RP2D.log("console", 1, " custom skin applied for player: "..player(id,"name").."("..usgn..")")
        
        if (data['cHair']) > 0 then   -- If player has different hair
            playerTable[id].hair = image("gfx/miami/skins/hairs/"..data['cHair']..".png", player(id, "x"), player(id, "y"), 200+id)
            imagescale(playerTable[id].hair, 0.7,0.7)
        else
            return nil end
        end
        
        if file_exists("sys/lua/cache/steam_"..steam..".dat") then -- if player uses Steam
            local file = io.open("sys/lua/cache/steam_"..steam..".dat", "r")
            local jsondata = file:read("*a")
            local data = json.decode(jsondata)
            playerTable[id].body = image(data['skin']['path'], player(id, "x"), player(id, "y"), 201, id)
            imagescale(playerTable[id].body, 0.7,0.7)
        else
            return false end
    end


function RP2D.RemoveSkins(id)
    freeimage(playerTable[id].body)
    freeimage(playerTable[id].hair)
    playerTable[id].body = nil
    playerTable[id].hair = nil
    RP2D.log("console", 1, " custom skin removed for player: "..player(id,"name").."("..usgn..")")
end


function RP2D.CustomSkinAttack(id)
        usgn = player(id, "usgn") -- Get Player USGN ID
        steam = player(id, "steamid") -- Get Player Steam ID
        if file_exists("sys/lua/cache/usgn_"..usgn..".dat") then -- if player uses USGN ID
        file = io.open("sys/lua/cache/usgn_"..usgn..".dat", "r")
        jsondata = file:read("*a")
        data = json.decode(jsondata)
        playerTable[id].attack = image(data['cAttack'], player(id, "x"), player(id, "y"), 200+id)
        imagescale(playerTable[id].attack, 0.7,0.7)
        else
            return false end
end




