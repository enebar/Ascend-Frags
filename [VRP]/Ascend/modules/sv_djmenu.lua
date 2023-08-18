local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasGroup(userid,"DJ") then
        TriggerClientEvent('CLIMB:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid,"admin.menu") then
        TriggerClientEvent('CLIMB:toggleDjAdminMenu', source,c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if CLIMB.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('CLIMB:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("CLIMB:adminStopSong")
AddEventHandler("CLIMB:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('CLIMB:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('CLIMB:toggleDjAdminMenu', source,c)
        end
    end
end)
RegisterServerEvent("CLIMB:playDjSongServer")
AddEventHandler("CLIMB:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('CLIMB:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("CLIMB:skipServer")
AddEventHandler("CLIMB:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('CLIMB:skipDj', -1,coords,param)
end)
RegisterServerEvent("CLIMB:stopSongServer")
AddEventHandler("CLIMB:stopSongServer", function(coords)
    local source = source
    TriggerClientEvent('CLIMB:stopSong', -1,coords)
end)
RegisterServerEvent("CLIMB:updateVolumeServer")
AddEventHandler("CLIMB:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('CLIMB:updateDjVolume', -1,coords,volume)
end)
