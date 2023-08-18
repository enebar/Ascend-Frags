RegisterNetEvent("CLIMB:speedGunFinePlayer")
AddEventHandler("CLIMB:speedGunFinePlayer",function(playerfined,fineamount)
    local source = source
    local officer_id = CLIMB.getUserId(source)
    local user_id = CLIMB.getUserId(playerfined)
    local player_id = CLIMB.getUserSource(playerfined)
    if CLIMB.hasPermission(user_id,"police.armoury") then
        CLIMBclient.notify(source,{'~d~You cannot fine another officer'})
        return
    end
    if not CLIMB.hasPermission(user_id, "police.armoury") and CLIMB.hasPermission(officer_id, "police.armoury") then
        if tonumber(CLIMB.getBankMoney(user_id)) > tonumber(fineamount*100) then
            CLIMB.setBankMoney(user_id,tonumber(CLIMB.getBankMoney(user_id))-tonumber(fineamount*100))
            CLIMB.setBankMoney(officer_id,tonumber(CLIMB.getBankMoney(officer_id))+tonumber(fineamount*100))
            CLIMBclient.notify(playerfined,{'~d~You have been issued a speeding fine of £'..(fineamount*100)..' for going '..fineamount.."MPH over the speed limit."})
            CLIMBclient.notify(source,{'~d~You issused a speeding fine '..GetPlayerName(playerfined)..' £'..(fineamount*100)..' for going '..fineamount.."MPH over the speed limit."})
            TriggerClientEvent('CLIMB:speedGunPlayerFined', playerfined)
        else
            CLIMBclient.notify(playerfined,{"~d~You have been issued a fine for speeding"})
            CLIMBclient.notify(source,{"~d~This player dosnt have enough money"}) 
        end
    end
end)

