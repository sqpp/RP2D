--[[
Script Name: RP2D
Script URI: https://github.com/sqpp/RP2D
Author: Marcell (#6943)
Author URI: https://unrealsoftware.de/profile.php?userid=6943
Description: .... modify later
Version: 0.0.0.3
License: GNU General Public License v3
License URI: http://www.gnu.org/licenses/gpl-3.0.html
Tags: cs2d, roleplay
This script is licensed under the GPL.
(C) 2020 Marcell
]]

-- Initialization

if RP2D==nil then RP2D={} end

RP2D.init={}
RP2D.init.path = "sys/lua/"
json = require("json")

playerTable = {}

function RP2D.playerList(id)
    playerTable[id] = {}
end
-----------------------
-- INITIAL SETUP     --
-----------------------

RP2D.init.scripts = {
    [1] = {
        name = "Debug",
        path = ""..RP2D.init.path.."debug.lua",
        version = "1.0",
        loaded = false
    },
    [2] = {
        name = "Colour",
        path = ""..RP2D.init.path.."colour.lua",
        version = "0.1",
        loaded = false
    },
    
    [3] = {
        name = "Defaults",
        path = ""..RP2D.init.path.."defaults.lua",
        version = "0.1",
        loaded = false
    },
    [4] = {
        name = "Config",
        path = ""..RP2D.init.path.."config.lua",
        version = "0.1",
        loaded = false
    },
    [5] = {
        name = "Functions",
        path = ""..RP2D.init.path.."functions.lua",
        version = "0.1",
        loaded = false
    },
    [6] = {
        name = "playerdata",
        path = ""..RP2D.init.path.."player.lua",
        version = "0.2",
        loaded = false
    },
    [7] = {
        name = "HUD",
        path = ""..RP2D.init.path.."hud.lua",
        version = "0.1",
        loaded = false
    },
    [8] = {
        name = "Admin",
        path = ""..RP2D.init.path.."admin.lua",
        version = "0.1",
        loaded = false
    },
    [9] = {
        name = "Hooks",
        path = ""..RP2D.init.path.."hooks.lua",
        version = "0.0.0.1",
        loaded = false
    },
    [10] = {
        name = "UnrealAntiCheat",
        path = ""..RP2D.init.path.."/uac/init.lua",
        version = "0.1",
        loaded = false
    },
    [11] = {
        name = "Say",
        path = ""..RP2D.init.path.."say.lua",
        version = "0.0.0.1",
        loaded = false
    },
    [12] = {
        name = "dayandniht",
        path = ""..RP2D.init.path.."environment.lua",
        version = "0.1",
        loaded = false
    },
   
    
    [13] = {
        name = "Save",
        path = ""..RP2D.init.path.."save.lua",
        version = "0.1",
        loaded = false
    },

    [14] = {
        name = "Bank",
        path = ""..RP2D.init.path.."bank.lua",
        version = "0.1",
        loaded = false
    },

    [15] = {
        name = "Bank",
        path = ""..RP2D.init.path.."autosave.lua",
        version = "0.1",
        loaded = false
    }
    
  --  [5] = {
   --     name = "Achievements",
   --     path = ""..RP2D.init.path.."achievements/core.lua",
   --     version = "1.3",
   --     loaded = false
  --  }
}

function RP2D.initScripts()
        for i = 1,#RP2D.init.scripts do
            dofile(RP2D.init.scripts[i]['path'])
            RP2D.init.scripts[i]['loaded'] = true
        end
            RP2D.log("console", 1, "All scripts initialized")
end

RP2D.initScripts()

