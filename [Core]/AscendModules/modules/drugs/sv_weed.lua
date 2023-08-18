function CLIMBcfgdrugsServer.WeedGather()
  
    local user_id = CLIMB.getUserId({source})
    if user_id ~= nil and CLIMB.hasPermission({user_id, "weed.job"}) then
      local amount = 4
      local item = 1.00
      local new_weight = CLIMB.getInventoryWeight({user_id})+(item*amount)
      if new_weight > CLIMB.getInventoryMaxWeight({user_id}) then
        CLIMBclient.notify(source,{"~d~Not enough space in inventory."})
      else
        CLIMB.giveInventoryItem({user_id, 'leef', 4, true})
      end
    else
      CLIMBclient.notify(source,{"~d~You do not have the correct license."})
    end
end

function CLIMBcfgdrugsServer.CanProcessWeed()
    local user_id = CLIMB.getUserId({source})
    return CLIMB.hasPermission({user_id, "weed.job"}), 
    CLIMB.getInventoryItemAmount({user_id, 'leef'}) >= 4
end


function CLIMBcfgdrugsServer.ProcessWeed()
    local user_id = CLIMB.getUserId({source})
    if CLIMB.getInventoryItemAmount({user_id, 'leef'}) >= 4 then
      CLIMB.tryGetInventoryItem({user_id, 'leef', 4, false})
      CLIMB.giveInventoryItem({user_id, 'weed2', 1, false})
    end
end

function CLIMBcfgdrugsServer.SellWeed(amount)
    local user_id = CLIMB.getUserId({source})
    if CLIMB.tryGetInventoryItem({user_id,'weed2', 1}) then

      local item = CLIMB.getInventoryItemAmount({user_id,'weed2'})
      local amount2 = amount

      if user_id ~= nil  then
        if amount > amount2 then
          CLIMBclient.notify(source, {"~d~You do not have that much Weed."})
          return
        end
        
        local price = 2500 * tonumber(amount) * 2

        CLIMB.giveMoney({user_id,price})

        CLIMBclient.notify(source, {"~g~Successfully sold " .. amount .. " Weed for £" .. price})


      end

    end
end
