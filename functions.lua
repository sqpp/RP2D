--[[
Script Name: RP2D Main Functions
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, core, functions
This script is licensed under the GPL.
(C) 2020 Marcell
]]



-- Get Player's USGN
function getPlayerUSGN(id)

end

-- Get Player's Steam64 ID
function getPlayerSteamID(id)

end

-- Get Player's Health
function getPlayerHealth(id)

end

-- Get Player's Hunger
function getPlayerHunger(id)

    local usgn = player(id, "usgn")
    local query = conn:query("SELECT food FROM players WHERE usgn like "..usgn..";")
    local result = conn:store_result()
    
    for id, food in result:rows() do
        return food
    end

    result:free()
end

-- Get Player's Thirst
function getPlayerThirst(id)

    local usgn = player(id, "usgn")
    local query = conn:query("SELECT drink FROM players WHERE usgn like "..usgn..";")
    local result = conn:store_result()

    for id, drink in result:rows() do
        return drink
     end

    result:free()
end



function getPlayerMoney(id)

    local usgn = player(id, "usgn")
    local query = conn:query("SELECT money FROM players WHERE usgn like "..usgn..";")
    local result = conn:store_result()

    for id, money in result:rows() do
        return money
     end

    result:free()
end

function addMoney(id, money)
    usgn = player(id, "usgn") -- Get Player USGN ID
    steam = player(id, "steamid") -- Get Player Steam ID
    local query = conn:query("SELECT money from players WHERE usgn like "..usgn..";")
end

function setHunger(id, value)
 
end

function setThirst(id, thirst)

end

function RP2D.usid(id)
    local uuid = require 'uuid'
    local usgn = player(id, "usgn")
    local query = conn:query("SELECT uuid FROM players WHERE usgn like "..usgn..";")
    
    local result = conn:store_result()

    for i, usid in result:rows() do
        if (uuid.is_valid(usid) == true) then
            return true
        else
            return false
        end
     end
    
     result:free()
end

function getResolution(id)
    local screenX = player(id, "screenw")
    local screenY = player(id, "screenh")
    return screenX.. "," ..screenY
end
