local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")

RegisterNetEvent('CLIMB:IDsAboveHead')
AddEventHandler('CLIMB:IDsAboveHead', function(status)
    local status = status
    local user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'admin.noclip'}) then
        TriggerClientEvent('CLIMB:ChangeIDs', source, status)
    end
end)