function CLIMBcfgdrugsServer.ScrapJobGather()
  
    local user_id = CLIMB.getUserId({source})
    if user_id ~= nil and CLIMB.hasPermission({user_id, "scrap.job"}) then
      local amount = 4
      local item = 1.00
      local new_weight = CLIMB.getInventoryWeight({user_id})+(item*amount)
      if new_weight > CLIMB.getInventoryMaxWeight({user_id}) then
        CLIMBclient.notify(source,{"~d~Not enough space in inventory."})
      else
        CLIMB.giveInventoryItem({user_id, 'scrap', 1, true})
      end
    else
      CLIMBclient.notify(source,{"~d~You do not have the correct license."})
    end
end

function CLIMBcfgdrugsServer.SellScrapJob(amount)
    local user_id = CLIMB.getUserId({source})
    if CLIMB.tryGetInventoryItem({user_id,'scrap', 1}) then

      local item = CLIMB.getInventoryItemAmount({user_id,'scrap'})
      local amount2 = amount

      if user_id ~= nil  then
        if amount > amount2 then
          CLIMBclient.notify(source, {"~d~You do not have that much ScrapJob."})
          return
        end
        
        local price = 1000 * tonumber(amount) * 2

        CLIMB.giveMoney({user_id,price})

        CLIMBclient.notify(source, {"~g~Successfully sold " .. amount .. " Scrap for £" .. price})


      end

    end
end
