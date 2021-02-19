dofile("sys/lua/achievements/config.cfg")

dofile("sys/lua/achievements/misc/hooks.lua")

dofile("sys/lua/achievements/misc/bonusfunctions.lua")

dofile("sys/lua/achievements/manager/manager_user.lua")
dofile("sys/lua/achievements/manager/manager_statistics.lua")
dofile("sys/lua/achievements/manager/manager_graph.lua")
dofile("sys/lua/achievements/manager/manager_achievements.lua")

dofile("sys/lua/achievements/misc/filestream.lua")
dofile("sys/lua/achievements/misc/statsinfo.lua")
dofile("sys/lua/achievements/misc/rankhandler.lua")

dofile("sys/lua/achievements/menu/menu_header.lua")
dofile("sys/lua/achievements/menu/menu_rankinfo.lua")
dofile("sys/lua/achievements/menu/menu_achievementstoplist.lua")
dofile("sys/lua/achievements/menu/menu_leaderboard.lua")
dofile("sys/lua/achievements/menu/menu_unlock.lua")
dofile("sys/lua/achievements/menu/menu_toplist.lua")
dofile("sys/lua/achievements/menu/menu_achievements.lua")
dofile("sys/lua/achievements/menu/menu_graph.lua")
dofile("sys/lua/achievements/menu/menu_statistics.lua")

dofile("sys/lua/achievements/scripts/statistics_script_part1.cfg")
dofile("sys/lua/achievements/scripts/statistics_script_part2.cfg")
dofile("sys/lua/achievements/scripts/statistics_script_part3.cfg")
dofile("sys/lua/achievements/scripts/statistics_script_values.cfg")

dofile("sys/lua/achievements/scripts/achievements_script_part1.cfg")
dofile("sys/lua/achievements/scripts/achievements_script_part2.cfg")
dofile("sys/lua/achievements/scripts/achievements_script_part3.cfg")
dofile("sys/lua/achievements/scripts/achievements_script_part4.cfg")
dofile("sys/lua/achievements/scripts/achievements_script_part5.cfg")

dofile("sys/lua/achievements/scripts/achievements_script_values.cfg")
dofile("sys/lua/achievements/scripts/graphs_scripts.cfg")

dofile("sys/lua/achievements/list_achievements.cfg")
dofile("sys/lua/achievements/list_statistics.cfg")
dofile("sys/lua/achievements/list_graphs.cfg")

StatsManager.LoadValues()
GraphManagerLoadValues()

AddGlobalFunction("mapchange",StatsManager.SaveValues)
AddGlobalFunction("mapchange",GraphManagerSaveValues)
AddGlobalFunction("minute",StatsManager.SaveValues)
AddGlobalFunction("minute",GraphManagerSaveValues)

dofile("sys/lua/achievements/locmod/main.lua")
