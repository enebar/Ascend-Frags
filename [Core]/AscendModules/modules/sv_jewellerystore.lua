-- local rewardjew = math.random(1,3)
-- local minCops = 3
-- local players = GetPlayers()

-- RegisterServerEvent("jewelryrobberry:serverstart")
-- AddEventHandler("jewelryrobberry:serverstart", function()
--     local user_id = CLIMB.getUserId({source})
--     local player = CLIMB.getUserSource({user_id})
--     local cops = CLIMB.getUsersByPermission({"police.armoury"})
--     if CLIMB.hasPermission({user_id,"police.armoury"}) then
--         CLIMBclient.notify(player,{"~d~Cops can't rob the jewellery store."})
--     else
--         if #cops >= minCops then
--             TriggerClientEvent("jewelryrobberry:start", source)
--         else
--             CLIMBclient.notify(player,{'~d~Minimum of '..minCops..' cops online.'})
--         end
--     end
-- end)

-- RegisterServerEvent('jewelryrobberry:sucess')
-- AddEventHandler('jewelryrobberry:sucess', function()
--     local user_id = CLIMB.getUserId({source})
--     if user_id ~= nil then
--         CLIMB.giveInventoryItem({user_id,"jewellery",rewardjew,true})
--     end
-- end)

-- RegisterServerEvent('jewelryrobberry:sucessRW1')
-- AddEventHandler('jewelryrobberry:sucessRW1', function()
--     local user_id = CLIMB.getUserId({source})
--     if user_id ~= nil then
--         CLIMB.giveInventoryItem({user_id,"jewellery",1,true})
--     end
-- end)

-- RegisterServerEvent('jewelryrobberry:allarmpolice')
-- AddEventHandler('jewelryrobberry:allarmpolice', function()
--     for i,v in pairs(players) do
--         local user_id = CLIMB.getUserId({v})
--         local source = CLIMB.getUserSource({user_id})
--         if user_id ~= nil then
--           if CLIMB.hasPermission({user_id, "police.armoury"}) then
--             TriggerClientEvent("CLIMB:setJewelleryBlip", source)
--           end
--         end
--     end
-- end)
