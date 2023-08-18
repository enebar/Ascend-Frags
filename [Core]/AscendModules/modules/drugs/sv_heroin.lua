function CLIMBcfgdrugsServer.HeroinGather()
  
    local user_id = CLIMB.getUserId({source})
    if user_id ~= nil and CLIMB.hasPermission({user_id, "heroin.job"}) then
      local amount = 4
      local item = 1.00
      local new_weight = CLIMB.getInventoryWeight({user_id})+(item*amount)
      if new_weight > CLIMB.getInventoryMaxWeight({user_id}) then
        CLIMBclient.notify(source,{"~d~Not enough space in inventory."})
      else
        CLIMB.giveInventoryItem({user_id, 'opium', 4, true})
      end
    else
      CLIMBclient.notify(source,{"~d~You do not have the correct license."})
    end
end

function CLIMBcfgdrugsServer.CanProcessHeroin()
    local user_id = CLIMB.getUserId({source})
    return CLIMB.hasPermission({user_id, "heroin.job"}), 
    CLIMB.getInventoryItemAmount({user_id, 'opium'}) >= 4
end


function CLIMBcfgdrugsServer.ProcessHeroin()
    local user_id = CLIMB.getUserId({source})
    if CLIMB.getInventoryItemAmount({user_id, 'opium'}) >= 4 then
      CLIMB.tryGetInventoryItem({user_id, 'opium', 4, false})
      CLIMB.giveInventoryItem({user_id, 'heroin', 1, false})
    end
end

function CLIMBcfgdrugsServer.SellHeroin(amount)
    local user_id = CLIMB.getUserId({source})
    if CLIMB.tryGetInventoryItem({user_id,'heroin', 1}) then


      local amount2 = amount

      if user_id ~= nil then
        if amount > amount2 then
          CLIMBclient.notify(source, {"~d~You do not have that much heroin."})
          return
        end
        
        local price = 10000 * tonumber(amount) * 2


        CLIMB.giveMoney({user_id,price})

        CLIMBclient.notify(source, {"~g~Successfully sold " .. amount .. " heroin for £" .. price})


      end
    else
     CLIMBclient.notify(source, {"~d~You do not have any heroin."})
    end
end
