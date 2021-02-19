--[[
Script Name: RP2D Hooks
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, hooks
This script is licensed under the GPL.
(C) 2020 Marcell
]]

-- JOIN HOOKS
addhook("join", "RP2D.playerList")

-- SPAWN HOOKS
addhook("spawn", "RP2D.LLP")

-- addhook("spawn", "RP2D.save")
addhook("spawn", "RP2D.loginMSG")
addhook("spawn", "RP2D.ApplySkins")
addhook("spawn", "RP2D.HUD")

-- SAY HOOKS
addhook("say", "RP2D.ChatIC")

-- ATTACK HOOKS
--addhook("attack", "RP2D.CustomSkinAttack")

-- MINUTE HOOKS
addhook("minute", "RP2D.Cache")

--addhook("minute", "RP2D.savePlist")

-- LEAVE HOOKS
addhook("leave", "RP2D.LastPos")
addhook("leave", "RP2D.RemHUD")
addhook("leave", "RP2D.RemoveSkins")