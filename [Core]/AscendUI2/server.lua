local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")

CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB_fuel")

RegisterServerEvent('update:bank')
AddEventHandler('update:bank', function()
    local user_id = CLIMB.getUserId({source})
    local bank = CLIMB.getBankMoney({user_id})
    TriggerClientEvent('bank:setDisplayBankMoney', source, bank)
end)

RegisterServerEvent('update:cash')
AddEventHandler('update:cash', function()
    local user_id = CLIMB.getUserId({source})
    local wallet = CLIMB.getMoney({user_id})
    TriggerClientEvent('cash:setDisplayMoney', source, wallet)
end)