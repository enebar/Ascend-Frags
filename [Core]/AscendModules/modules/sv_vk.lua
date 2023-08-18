local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "vk")



RegisterServerEvent("CLIMB:PDVK")
AddEventHandler('CLIMB:PDVK', function()
    local source = source
    user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'police.armoury'}) then 
    -- if CLIMB.hasGroup(user_id, "ScorpianBlue")
        TriggerClientEvent('sendvkpdperms', source, true)
    else
        TriggerClientEvent('sendvkpdperms', source, false)
    end
end)