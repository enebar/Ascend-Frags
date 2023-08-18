-- local cfg = module("CLIMBModules", "cfg/cfg_stores")

-- local Tunnel = module("CLIMB", "lib/Tunnel")
-- local Proxy = module("CLIMB", "lib/Proxy")
-- CLIMB = Proxy.getInterface("CLIMB")
-- CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB")

-- RegisterNetEvent("CLIMB:BuyHeistItem")
-- AddEventHandler("CLIMB:BuyHeistItem", function(itemID, amount)
--     local user_id = CLIMB.getUserId({source})

--     if user_id ~= nil then
--         for k, v in pairs(cfg.items) do
--             if itemID == v.itemID then
--                 if CLIMB.tryPayment({user_id, v.price * amount}) then
--                     CLIMB.giveInventoryItem({user_id, v.itemID, amount, true})
--                     CLIMBclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
--                 else
--                     CLIMBclient.notify(source,{"~d~You don't have enough money!"})
--                 end
--             end
--         end
--     end
-- end)

-- RegisterNetEvent("CLIMB:SellHeistItem")
-- AddEventHandler("CLIMB:SellHeistItem", function(itemID, amount)
--     local user_id = CLIMB.getUserId({source})

--     if user_id ~= nil then
--         for k, v in pairs(cfg.items) do
--             if itemID == v.itemID then
--                 if CLIMB.tryGetInventoryItem({user_id,'jewellery', amount}) then
--                     local item = CLIMB.getInventoryItemAmount({user_id,'jewellery'})
--                     local price = v.price * tonumber(amount)
--                     CLIMB.giveMoney({user_id,price})
--                     CLIMBclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
--                 else
--                     CLIMBclient.notify(source,{"~d~You don't have enough jewellery!"})
--                 end
--             end
--         end
--     end
-- end)