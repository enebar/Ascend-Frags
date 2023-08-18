local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "CLIMB_gunshop")

RegisterNetEvent('sendPD')
AddEventHandler('sendPD', function()
    user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'police.menu'}) then 
        TriggerClientEvent('returnPd2', source, true)
    else
        TriggerClientEvent('returnPd2', source, false)
    end
end)


RegisterNetEvent('sendRebl')
AddEventHandler('sendRebl', function()
    user_id = CLIMB.getUserId({source})
    if CLIMB.hasGroup({user_id, 'Rebel'}) then 
        TriggerClientEvent('returnrebel', source, true)
    else
        TriggerClientEvent('returnrebel', source, false)
    end
end)


