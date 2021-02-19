--[[
Script Name: RP2D Saving System
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.2
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, save, load
This script is licensed under the GPL.
(C) 2020 Marcell
]]



function RP2D.save(id)
    
    if ( stats(id, "exists") or steamstats(steamid, "exists") == true ) then

    local stmt, params = conn:prepare("INSERT INTO players VALUES (default, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);")
    local params = stmt:bind_params ("int", "varchar(255)", "varchar(255)", "varchar(255)", "varchar(255)", "varchar(255)", "smallint", "smallint", "int", "int", "varchar(255)", "int", "varchar(255)", "varchar(255)", "int", "int", "varchar(255)", "int", "int", "int", "varchar(100)")

    -- Default New Comer Player Values
    params:set(1, player(id, 'usgn'))
    params:set(2, player(id, 'usgnname'))
    params:set(3, player(id, 'ip'))
    params:set(4, player(id, 'name'))
    params:set(5, player(id, 'steamid'))
    params:set(6, player(id, 'steamname'))
    params:set(7, 100) -- Drink
    params:set(8, 120) -- Food,
    params:set(9, 1500) -- Cash Money
    params:set(10, 0) -- Bank Money
    params:set(11, tostring(2)) -- Item IDs, separated by comma
    params:set(12, 100) -- Health
    params:set(13, "gfx\\miami\\skins\\default.png") -- Path to Skin
    params:set(14, "nil") -- Path to Attack
    params:set(15, 1) -- Hair ID
    params:set(16, 1) -- Hat ID
    params:set(17, player(id, "language_iso")) -- Currently Set Lang in 2D
    params:set(18, player(id, "x")) -- Default Position, later last position in X tiles
    params:set(19, player(id, "y")) -- Default Position, later last position in Y tiles
    params:set(20, os.time())   -- Last Login time.
    params:set(21, uuid())
    stmt:exec()

    else 
        return false
    end
end

function RP2D.LastPos(id)
    local usgn = player(id, "usgn")
    local x = player(id, "x")
    local y = player(id, "y")
    local query = conn:query("UPDATE players SET lastPOSX="..x..", lastPOSY="..y.." WHERE usgn="..usgn..";")
    print(color["White"].."Player:["..usgn.."] left at "..x.." and "..y)
end


function RP2D.LLP(id)
    local usgn = player(id, "usgn")
    local query = conn:query("SELECT lastPOSX, lastPOSY FROM players WHERE usgn like "..usgn..";")
    
    local result = conn:store_result()

    for i, lastPOSX, lastPOSY in result:rows() do
        setpos(id, lastPOSX, lastPOSY)
        
     end
     
     result:free()
     
end