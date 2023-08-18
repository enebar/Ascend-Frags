local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "CLIMBRP_RadialMenu")

RegisterServerEvent("CLIMBRP:PoliceCheckRadial")
AddEventHandler("CLIMBRP:PoliceCheckRadial", function()
    local source = source
    local user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, "police.armoury"}) then
        MetPD = true
    else
        MetPD = false
    end
    TriggerClientEvent("CLIMBRP:PoliceClockedOn", source, MetPD)
end)

RegisterServerEvent("serverBoot")
AddEventHandler("serverBoot", function()
    TriggerClientEvent('openBoot', source)
end)
