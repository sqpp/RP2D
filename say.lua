--[[
Script Name: RP2D Say Functions
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, say
This script is licensed under the GPL.
(C) 2020 Marcell
]]

function RP2D.ChatIC(id, message)
    x = player(id, "x")
    y = player(id, "y")
    pa = closeplayers(x, y, 150)
    for i = 1,#pa[i][i] do
            msg2(pa[i][i], (player(id,"name").." says "..message))
            return 1
    end
end
