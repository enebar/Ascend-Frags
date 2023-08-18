netObjects = {}

RegisterServerEvent("CLIMB:spawnVehicleCallback")
AddEventHandler('CLIMB:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = CLIMB.getUserSource(a), id = a, name = GetPlayerName(CLIMB.getUserSource(a))}
end)

RegisterServerEvent("CLIMB:delGunDelete")
AddEventHandler("CLIMB:delGunDelete", function(object)
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("CLIMB:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("CLIMB:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)