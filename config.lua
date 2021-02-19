--[[
Script Name: RP2D Config & MySQL Conn
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.1
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay, config, mysql
This script is licensed under the GPL.
(C) 2020 Marcell
]]

RP2D.config = { alvl = nil }

local mysql = require'mysql'
conn = mysql.connect('127.0.0.1', 'rp2d', ')rIO*7bW$x_w', 'rp2d', 'utf8')
