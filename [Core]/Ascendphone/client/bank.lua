
inMenu = true
local bank = 0
function setBankBalance (value)
    bank = value
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent("CLIMB:initMoney")
AddEventHandler("CLIMB:initMoney", function(bankMoney)
    setBankBalance(bankMoney)
end)

RegisterNUICallback("bank_transfer", function(data) 
    TriggerServerEvent("CLIMB:bankTransfer", data.user_id, data.amount)
end)