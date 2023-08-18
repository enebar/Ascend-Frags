local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")

RegisterNetEvent('CLIMB:PoliceCheck')
AddEventHandler('CLIMB:PoliceCheck', function()
    local source = source
    local user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'police.armoury'}) then
        TriggerClientEvent('CLIMB:PolicePerms', source, true)
    else
        TriggerClientEvent('CLIMB:PolicePerms', source, false)
    end
end)

RegisterNetEvent('CLIMB:RebelCheck')
AddEventHandler('CLIMB:RebelCheck', function()
    local source = source
    local user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'rebel.guns'}) then
        TriggerClientEvent('CLIMB:RebelPerms', source, true)
    else
        TriggerClientEvent('CLIMB:RebelPerms', source, false)
    end
end)


RegisterNetEvent('CLIMB:VIPCheck')
AddEventHandler('CLIMB:VIPCheck', function()
    local source = source
    local user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'vip.guns'}) then
        TriggerClientEvent('CLIMB:VIPPerms', source, true)
    else
        TriggerClientEvent('CLIMB:VIPPerms', source, false)
    end
end)

