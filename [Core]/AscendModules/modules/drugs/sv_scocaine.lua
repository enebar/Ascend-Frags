





function CLIMBcfgdrugsServer.CocaineGather()
  local user_id = CLIMB.getUserId({source})

  if user_id ~= nil and CLIMB.hasPermission({user_id, "cocaine.job"}) then
    local amount = 4
    local item = 1.00
    local new_weight = CLIMB.getInventoryWeight({user_id})+(item*amount)

    if new_weight > CLIMB.getInventoryMaxWeight({user_id}) then
      CLIMBclient.notify(source,{"~d~Not enough space in inventory."})
    else
      CLIMB.giveInventoryItem({user_id, 'cocoa', 4, true})
    end

  else
    CLIMBclient.notify(source,{"~d~You do not have the correct license."})
  end
end

function CLIMBcfgdrugsServer.CocaineCanProcess()
  local user_id = CLIMB.getUserId({source})
  return CLIMB.hasPermission({user_id, "cocaine.job"}),
  CLIMB.getInventoryItemAmount({user_id, 'cocoa'}) >= 4
end

function CLIMBcfgdrugsServer.CocaineDoneProcessing()
  local user_id = CLIMB.getUserId({source})
  if CLIMB.getInventoryItemAmount({user_id, 'cocoa'}) >= 4 then
    CLIMB.tryGetInventoryItem({user_id, 'cocoa', 4, false})
    CLIMB.giveInventoryItem({user_id, 'cocaine', 1, false})
  end
end

function CLIMBcfgdrugsServer.SellCocaineJob(amount)
 local user_id = CLIMB.getUserId({source})
 if CLIMB.tryGetInventoryItem({user_id,'cocaine', 1}) then
   local item = CLIMB.getInventoryItemAmount({user_id,'cocaine'})
   local amount2 = amount
   if user_id ~= nil  then
     if amount > amount2 then
       CLIMBclient.notify(source, {"~d~You do not have that much Cocaine."})
       return
     end
     local price = 1500 * tonumber(amount) * 2
     CLIMB.giveMoney({user_id,price})
     CLIMBclient.notify(source, {"~g~Successfully sold " .. amount .. " Cocaine for £" .. price})

   end
 end
end