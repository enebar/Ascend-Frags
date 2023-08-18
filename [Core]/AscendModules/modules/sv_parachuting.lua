local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "CLIMB_gunshop")
hasMoney = false

RegisterNetEvent("CLIMB:checkParachuteMoney")
AddEventHandler("CLIMB:checkParachuteMoney", function()
    local source = source
    user_id = CLIMB.getUserId({source})
    local bankBalance = CLIMB.getBankMoney({user_id})
    if bankBalance >= 15000 then
        newBalance = bankBalance - 15000
        CLIMB.setBankMoney({user_id, newBalance})
        hasMoney = true
        CLIMBclient.notify(user_id, {"~g~You have paid £15,000 to parachute."})
        TriggerClientEvent("CLIMB:PlaySound", source, 1)
        TriggerClientEvent("CLIMB:goParachuting", source, 1)
    else
        CLIMBclient.notify(user_id, {"~d~You do not have enough money."})
    end
end)