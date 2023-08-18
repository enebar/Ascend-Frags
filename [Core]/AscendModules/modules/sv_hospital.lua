local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "Hospital")

-- RegisterServerEvent("CLIMB:HealPlayer")
-- AddEventHandler('CLIMB:HealPlayer', function()
--     userid = CLIMB.getUserId({source})
--     TriggerClientEvent("CLIMB:SetHealth", source)
--     CLIMBclient.notify(source,{"~g~You have been healed, free of charge."})
-- end)

RegisterNetEvent('CLIMB:reviveRadial')
AddEventHandler('CLIMB:reviveRadial', function()
    local player = source
    CLIMBclient.getNearestPlayer(player,{4},function(nplayer)
        TriggerClientEvent('CLIMB:cprAnim', player, nplayer)
    end)
end)

RegisterNetEvent("CLIMB:SendFixClient")
AddEventHandler("CLIMB:SendFixClient", function(player)
    TriggerClientEvent("CLIMB:FixClient", player)
end)