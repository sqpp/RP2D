--[[
Script Name: RP2D Bank Script
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.2
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, bank, controlling, server managment
This script is licensed under the GPL.
(C) 2020 Marcell
]]


addhook("say", "RP2D.CreditCard")

function RP2D.CreditCard(id, txt)
    if string.sub(txt,1,4 ) == "@cc " then
    local usgn = player(id, "usgn")
    local sid = player(id, "steamid")

    local query = conn:query("SELECT id, cc, expire, cvv, owner, active, bank FROM creditcards WHERE owner like "..usgn.." ORDER by id;")
    local result = conn:store_result()
    for row_num, id, cc, expire, cvv, owner, active, bank in result:rows() do

        local input4 =string.sub(txt, -4, -1)
        local last4 = string.sub(cc, -4, -1)
        local expire = tostring(expire)
        if (input4 == last4) then
               msg2(id, color["Red"] .. "---------- Bank of America ---------")
               msg2(id, color["White"] .. cc)
               msg2(id, color["Yellow"] .. expire.. " | CVV: " .. color["Green"] .. cvv)
            end
        end
    result:free()
    end

end