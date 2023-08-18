-- local Tunnel = module("CLIMB", "lib/Tunnel")
-- local Proxy = module("CLIMB", "lib/Proxy")
-- CLIMB = Proxy.getInterface("CLIMB")
-- cop = {}
-- nhs = {}

-- RegisterServerEvent("CLIMB:ENABLEBLIPS")
-- AddEventHandler("CLIMB:ENABLEBLIPS", function()
--   local user_id = CLIMB.getUserId({source})
--   if CLIMB.hasPermission({user_id, "police.menu"}) or CLIMB.hasPermission({user_id, "emergency.vehicle"}) then
--     TriggerClientEvent("CLIMB:BLIPS",source,cop,nhs)
--   end
-- end)

-- Citizen.CreateThread(function()
--   while true do
--     Wait(10000)
--     cop = {}
--     nhs = {}
--     local players = GetPlayers()
--     for i,v in pairs(players) do
--       name = GetPlayerName(v)
--       local  user_id = CLIMB.getUserId({v})
--       if user_id ~= nil then
--         local coords = GetPlayerPed(v)

--         if CLIMB.hasPermission({user_id, "police.menu"}) then
--           cop[user_id] = {coords,v}
--         end

--         if CLIMB.hasPermission({user_id, "emergency.vehicle"}) then
--           nhs[user_id] = {coords,v}
--         end
--       end
--     end
--   end
-- end)