RegisterServerEvent("CLIMB:returnSafe:server")
AddEventHandler("CLIMB:returnSafe:server", function(deliveryType, safeReturn)
    local source = source
    local user_id = CLIMB.getUserId(source)
    if safeReturn then
        local SafeMoney = 4000
        for k, v in pairs(dpdcfg.Safe) do
            if k == deliveryType then
                SafeMoney = v
                break
            end
        end
    else
    end
end)

RegisterServerEvent("CLIMB:finishDelivery:server")
AddEventHandler("CLIMB:finishDelivery:server", function(deliveryType)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local delieryMoney = 50000
    for k, v in pairs(dpdcfg.Rewards) do
        if k == deliveryType then
            deliveryMoney = v
            break
        end
    end
    CLIMB.giveBankMoney(user_id,delieryMoney)
    CLIMBclient.notify(source,{"Package Delivered, you received £"..tostring(deliveryMoney)})
end)

RegisterServerEvent("CLIMB:removeSafeMoney:server")
AddEventHandler("CLIMB:removeSafeMoney:server", function(deliveryType)
        local user_id = CLIMB.getUserId({source})
        local SafeMoney = 4000
            for k, v in pairs(dpdcfg.Safe) do
                if k == deliveryType then
                    SafeMoney = v
                break
            end
        end
    TriggerClientEvent("CLIMB:startJob:client", source, deliveryType)
end)
