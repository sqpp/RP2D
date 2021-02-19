--[[
Script Name: RP2D Admin Script
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

RP2D.admin = {
    owner = {6943}, -- use comma for more, not suggested tho
    controller = {},
    superadmin = {},
    eliteadmin = {},
    admin = {},
    moderator = {},
    helper = {}
}

function RP2D.isAdmin(id, type)
local usgn = player(id, "usgn")


    for i = 1,#RP2D.admin[type] do
      if RP2D.admin[type][i] == usgn then
        return true
      else
        return false
      end
    end
end

function RP2D.loginMSG(id)
  if (RP2D.isAdmin(id, 'owner') == true) and (RP2D.usid(id) == true) then
    msg2(id, color['Red'].. "Welcome Marcell!")
    msg2(id, color['White'].. "----------------")
    msg2(id, color['Green'].. "There are no news today.")
  else
    return false
  end
end

function RP2D.Money(id, txt)

  if (player(id, "exists") == true) then
    if (txt == "@money") then
      timerEx(1000,"RP2D.MoneyGen", 20, id)

    end
  else 
    return false
  end
end

function RP2D.MoneyGen(id)
  local x = player(id, "x") 
  local y = player(id, "y")
  money = {}
  money.image = {}
  for i = 1, 20 do
    money.image[i] = {}
  end
 
  money.image = image("gfx/miami/money.png", x, y, 0)
  imagepos(money.image, x, y, math.random(1,360))
  imagescale(money.image, 0.8, 0.8)
  local moneyglow=image("<light>", x, y, 0)
  imagecolor(moneyglow, 0, 220, 0)
  imagescale(moneyglow, 0.5, 0.5)
  imagealpha(moneyglow, 0.5)
 
  

  print("[RP2D.Admin] Money is being dropped by " .. player(id,"name"))
end

