-- local Proxy = module("CLIMB", "lib/Proxy")
-- local Tunnel = module("CLIMB","lib/Tunnel")
-- CLIMB = Proxy.getInterface("CLIMB")
-- CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB_policeradial")

-- local Lang = module("CLIMB", "lib/Lang")
-- local cfg = module("CLIMB", "cfg/base")
-- local lang = Lang.new(module("CLIMB", "cfg/lang/"..cfg.lang) or {})

-- RegisterNetEvent('CLIMB:policeDrag')
-- AddEventHandler('CLIMB:policeDrag', function()
    
--     local source = source
--     Citizen.Wait(0)
--     local user_id = CLIMB.getUserId({source})
    
--     if user_id ~= nil and CLIMB.hasPermission({user_id, "police.menu"}) then
        
--         CLIMBclient.getNearestPlayer(source,{2},function(nplayer)
--             local nplayer = nplayer
            
--             if nplayer ~= nil then
--                 local nuser_id = CLIMB.getUserId({nplayer})
--             if nuser_id ~= nil then
--                 CLIMBclient.isHandcuffed(nplayer,{},function(handcuffed)
--                 if handcuffed then
--                     TriggerClientEvent("CLIMB:drag2", nplayer, source)
--                 else
--                     CLIMBclient.notify(source,{"Player is not handcuffed."})
--                 end
--                 end)
--             else
--                 CLIMBclient.notify(source,{lang.common.no_player_near()})
                
--             end
--             else
--             CLIMBclient.notify(source,{lang.common.no_player_near()})
            
--             end
--         end)
--     end
-- end)

-- local crookanim = {

--     {"mp_arrest_paired","crook_p2_back_left",1},
-- }

-- local policeanim = {

--     {"mp_arrest_paired","cop_p2_back_left",1},
-- }
-- local policeuncuff = {

--     {"mp_arresting", "a_uncuff", 1},

-- }
-- local crookuncuff = {

--     {"mp_arresting", "b_uncuff", 1},

-- }
-- local playerHandcuffed = false

--  RegisterNetEvent("CLIMB:policeCuff")
--  AddEventHandler("CLIMB:policeCuff", function()
--      local player = source
--      local user_id = CLIMB.getUserId({source})
--      handcuffed = nil
--      if user_id ~= nil and CLIMB.hasPermission({user_id, "pd.armory"}) then
--          CLIMBclient.getNearestPlayer(player,{2},function(nplayer)
--              nplayer = nplayer
--              local nuser_id = CLIMB.getUserId({nplayer})
--              CLIMBclient.isHandcuffed(nplayer,{},function(handcuffed)
--                  local nplayer = nplayer
--                  local nuser_id = CLIMB.getUserId({nplayer})
--                  local handcuffed = handcuffed
--                  if nuser_id ~= nil then
--                      if handcuffed == false then
--                          CLIMBclient.playAnim(nplayer,{true,crookanim,false})
--                          CLIMBclient.playAnim(player,{true,policeanim,false})
--                          CLIMBclient.toggleHandcuff(nplayer,{})
--                     elseif handcuffed == true then
--                          CLIMBclient.playAnim(nplayer,{true,crookuncuff,false})
--                          CLIMBclient.playAnim(player,{true,policeuncuff,false})
--                          CLIMBclient.toggleHandcuff(nplayer,{})
--                      end
--                      TriggerClientEvent("CLIMB:PlaySound", source, "handcuff")
--                  else
--                      CLIMBclient.notify(player,"No player near you")
--                  end

--              end)
--          end)
--      end

-- TriggerClientEvent('chat:addSuggestion', '/uncuffme', 'Uncuff yourself.')
-- RegisterCommand("uncuffme", function(source, args, rawCommand)
--   local user_id = CLIMB.getUserId({source})
--   CLIMBclient.isHandcuffed(source,{},function(handcuffed)
--     if handcuffed == true then
--       if CLIMB.hasPermission({user_id, 'admin.noclip'}) then
--         CLIMBclient.toggleHandcuff(source,{})
--       end
--     end
--   end)
-- end)


--  end)

-- RegisterNetEvent('CLIMB:policeCuffStaff')
-- AddEventHandler('CLIMB:policeCuffStaff', function(staffmode)
--   local player = source
--   local user_id = CLIMB.getUserId({source})
--   handcuffed = nil
--   if CLIMB.hasPermission({user_id, 'admin.tickets'}) then
--     if CLIMB.hasPermission({user_id, "pd.armory"}) then return end
--     if user_id ~= nil and staffmode == true then
--         CLIMBclient.getNearestPlayer(player,{2},function(nplayer)
--             nplayer = nplayer
--             local nuser_id = CLIMB.getUserId({nplayer})
--             CLIMBclient.isHandcuffed(nplayer,{},function(handcuffed)
--                 local nplayer = nplayer
--                 local nuser_id = CLIMB.getUserId({nplayer})
--                 local handcuffed = handcuffed
--                 if nuser_id ~= nil then
--                     if handcuffed == false then
--                         CLIMBclient.playAnim(nplayer,{true,crookanim,false})
--                         CLIMBclient.playAnim(player,{true,policeanim,false})
--                         CLIMBclient.toggleHandcuff(nplayer,{})
--                   elseif handcuffed == true then
--                         CLIMBclient.playAnim(nplayer,{true,crookuncuff,false})
--                         CLIMBclient.playAnim(player,{true,policeuncuff,false})
--                         CLIMBclient.toggleHandcuff(nplayer,{})
--                     end
--                     TriggerClientEvent("CLIMB:PlaySound", source, "handcuff")
--                 else
--                     CLIMBclient.notify(player,"No player near you")
--                 end

--             end)
--         end)
--       end
--     end
-- end)


-- Tunnel.bindInterface("CLIMB_basic_menu",CLIMBbm)
-- BMclient = Tunnel.getInterface("CLIMB_basic_menu","CLIMB_basic_menu")
-- RegisterServerEvent('CLIMB:toggleTrafficMenu')
-- AddEventHandler('CLIMB:toggleTrafficMenu', function()
--     local source = source
--     local user_id = CLIMB.getUserId({source})
--     if user_id ~= nil and CLIMB.hasPermission({user_id, "police.menu"}) then
--         print("CLIMB Identification Accepted") 
--         TriggerClientEvent("CLIMB:openTrafficMenu", source)
--     end
-- end)

-- RegisterServerEvent('CLIMB:zoneActivated')
-- AddEventHandler('CLIMB:zoneActivated', function(message, speed, radius, x, y, z)
--     TriggerClientEvent('chatMessage', -1, message)
--     TriggerClientEvent('CLIMB:createZone', -1, speed, radius, x, y, z)
-- end)

-- RegisterServerEvent('CLIMB:disableZone')
-- AddEventHandler('CLIMB:disableZone', function(blip)
--     TriggerClientEvent('CLIMB:removeBlip', -1)
-- end)


-- local unjailed = {}
-- function jail_clock(target_id,timer)
--   local target = CLIMB.getUserSource({tonumber(target_id)})
--   local users = CLIMB.getUsers({})
--   local online = false
--   for k,v in pairs(users) do
-- 	if tonumber(k) == tonumber(target_id) then
-- 	  online = true
-- 	end
--   end
--   if online then
--     if timer>0 then
-- 	  CLIMBclient.notify(target, {"~d~Remaining time: " .. timer .. " minute(s)."})
--       CLIMB.setUData({tonumber(target_id),"CLIMB:jail:time",json.encode(timer)})
-- 	  SetTimeout(60*1000, function()
-- 		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
-- 		  if v == tonumber(target_id) then
-- 	        unjailed[v] = nil
-- 		    timer = 0
-- 		  end
-- 		end
-- 		CLIMB.setHunger({tonumber(target_id), 0})
-- 		CLIMB.setThirst({tonumber(target_id), 0})
-- 	    jail_clock(tonumber(target_id),timer-1)
-- 	  end) 
--     else 
-- 	  BMclient.loadFreeze(target,{false,true,true})
-- 	  SetTimeout(15000,function()
-- 		BMclient.loadFreeze(target,{false,false,false})
-- 	  end)
-- 	  CLIMBclient.teleport(target,{1846.4332275391,2585.7666015625,45.671997070313}) -- teleport to outside jail
-- 	  CLIMBclient.setHandcuffed(target,{false})
--       CLIMBclient.notify(target,{"~d~You have been set free."})
-- 	  CLIMB.setUData({tonumber(target_id),"CLIMB:jail:time",json.encode(-1)})
--     end
--   end
-- end

-- RegisterServerEvent('CLIMB:Fine')
-- AddEventHandler('CLIMB:Fine', function() 
--     player = source
--     local user_id = CLIMB.getUserId({player})
--     if user_id ~= nil and CLIMB.hasPermission({user_id, "police.menu"}) then
--     CLIMBclient.getNearestPlayers(player,{15},function(nplayers) 
--       local user_list = ""
--       for k,v in pairs(nplayers) do
--         user_list = user_list .. "[" .. CLIMB.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
--       end 
--       if user_list ~= "" then
--         CLIMB.prompt({player,"Players Nearby:" .. user_list,"",function(player,target_id) 
--           if target_id ~= nil and target_id ~= "" then 
--             CLIMB.prompt({player,"Fine amount:","100",function(player,fine)
--               if fine ~= nil and fine ~= "" then 
--                 CLIMB.prompt({player,"Fine reason:","",function(player,reason)
--                   if reason ~= nil and reason ~= "" then 
--                     local target = CLIMB.getUserSource({tonumber(target_id)})
--                     if target ~= nil then
--                       if tonumber(fine) > 250000 then
--                           fine = 250000
--                       end
--                       if tonumber(fine) < 1 then
--                         fine = 1
--                       end
                
--                       if CLIMB.tryFullPayment({tonumber(target_id), tonumber(fine)}) then
--                         CLIMB.insertPoliceRecord({tonumber(target_id), lang.police.menu.fine.record({reason,fine})})
--                         --CLIMBclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
--                         CLIMBclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
--                         CLIMB.giveBankMoney({player, tonumber(fine)/10})
--                         CLIMBclient.notify(player,{'~g~You have received £'.. tonumber(fine)/10 ..' as you '..lang.police.menu.fine.fined({reason,fine})})
--                         local user_id = CLIMB.getUserId({player})
--                         CLIMB.closeMenu({player})
--                       else
--                         CLIMBclient.notify(player,{lang.money.not_enough()})
--                       end
--                     else
--                       CLIMBclient.notify(player,{"~d~That ID seems invalid."})
--                     end
--                   else
--                     CLIMBclient.notify(player,{"~d~You can't fine for no reason."})
--                   end
--                 end})
--               else
--                 CLIMBclient.notify(player,{"~d~Your fine has to have a value."})
--               end
--             end})
--           else
--             CLIMBclient.notify(player,{"~d~No player ID selected."})
--           end 
--         end})
--       else
--         CLIMBclient.notify(player,{"~d~No player nearby."})
--       end 
--     end)
--   else
--     print(user_id.." Could be modder")
--   end
-- end)


-- RegisterServerEvent('CLIMB:Drag')
-- AddEventHandler('CLIMB:Drag', function() 
--       -- get nearest player
--       local user_id = CLIMB.getUserId({player})
--       if user_id ~= nil then
--         CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
--           if nplayer ~= nil then
--             local nuser_id = CLIMB.getUserId({nplayer})
--             if nuser_id ~= nil then
--           CLIMBclient.isHandcuffed(nplayer,{},function(handcuffed)
--           if handcuffed then
--             TriggerClientEvent("dr:drag", nplayer, player)
--           else
--             CLIMBclient.notify(player,{"Player is not handcuffed."})
--           end
--           end)
--             else
--               CLIMBclient.notify(player,{"no one near"})
--             end
--           else
--             CLIMBclient.notify(player,{"Player is not handcuffed."})
--           end
--         end)
--       end
-- end)

-- RegisterServerEvent('CLIMB:TrafficMenuLogs')
-- AddEventHandler('CLIMB:TrafficMenuLogs', function(objspawned) 
--   local player = source
--   local admin_id = CLIMB.getUserId({player})
--   local admin_name = GetPlayerName(player)
--   local logs = ""
--   local communityname = " Staff Logs"
--   local communtiylogo = "" --Must end with .png or .jpg
        
--   local command = {
--     {
--       ["color"] = "8663711",
--       ["title"] = "Police Menu (Spawn Object)",
--       ["description"] = "** Admin Name: **" ..admin_name.. "** Admin ID:  **" ..admin_id.. "** Spawned Objects : **" ..objspawned.. "",
--       ["footer"] = {
--       ["text"] = communityname,
--       ["icon_url"] = communtiylogo,
--       },
--     }
--   }
--   PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = " Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
-- end)