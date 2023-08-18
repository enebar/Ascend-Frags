local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "CLIMB_Announce")


RegisterServerEvent("CLIMB:announceRestart")
AddEventHandler("CLIMB:announceRestart", function(a, b)
    local c = math.floor(tonumber(a))
    if a ~= nil then
        while c ~= -1 do
            TriggerClientEvent("CLIMB:displayRestart", -1, c, b)
            c = c - 1
            Wait(1000)
        end
    end
end)

RegisterServerEvent("CLIMB:Announce")
AddEventHandler("CLIMB:Announce", function(d)
    if d ~= nil then
        TriggerClientEvent("CLIMB:displayAnnouncement", -1, d)
    end
end)

RegisterServerEvent("CLIMB:announceRestart")
AddEventHandler("CLIMB:announceRestart", function(time, isScheduled)
    if time ~= nil then
        TriggerClientEvent("CLIMB:displayRestartAnnouncement", -1, time, isScheduled)
    end
end)