--addhook("join", "multilogin")
function multilogin(id)
    local playerlist=player(0,"table")
    for i = 2,#playerlist do
    if player(id, "usgn") == player(i, "usgn") then
        msg("\169000255000[UAC] Multilogin detected. User banned.")
        parse("banusgn "..id, 0, "UAC - Multilogin")
        parse("banusgn "..i, 0, "UAC - Multilogin")
    end
end
end