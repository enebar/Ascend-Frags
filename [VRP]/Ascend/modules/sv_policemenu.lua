local lang = CLIMB.lang
local cfg = module("cfg/police")

RegisterServerEvent('CLIMB:OpenPoliceMenu')
AddEventHandler('CLIMB:OpenPoliceMenu', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.armoury") then
        TriggerClientEvent("CLIMB:PoliceMenuOpened", source)
    elseif user_id ~= nil and CLIMB.hasPermission(user_id, "clockon.menu") then
      CLIMBclient.notify(source,{"You are not on duty"})
    end
end)

RegisterServerEvent('CLIMB:ActivateZone')
AddEventHandler('CLIMB:ActivateZone', function(message, speed, radius, x, y, z)
    TriggerClientEvent('chatMessage', -1, "" , { 128, 128, 128 }, message, "alert")
    TriggerClientEvent('CLIMB:ZoneCreated', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('CLIMB:RemoveZone')
AddEventHandler('CLIMB:RemoveZone', function(blip)
    TriggerClientEvent('CLIMB:RemovedBlip', -1)
end)

RegisterServerEvent('CLIMB:Drag')
AddEventHandler('CLIMB:Drag', function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.armoury") then
        CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
            local nuser_id = CLIMB.getUserId(nplayer)
            if nuser_id ~= nil then
            CLIMBclient.isHandcuffed(nplayer,{},function(handcuffed)
                if handcuffed then
                    TriggerClientEvent("CLIMB:DragPlayer", nplayer, player)
                else
                    CLIMBclient.notify(player,{"~d~Player is not handcuffed."})
                end
            end)
            else
                CLIMBclient.notify(player,{"~d~There is no player nearby"})
            end
            else
                CLIMBclient.notify(player,{"~d~There is no player nearby"})
            end
        end)
    end
end)

local cuff = false

RegisterServerEvent('CLIMB:Handcuff')
AddEventHandler('CLIMB:Handcuff', function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "pd.armory") then
      CLIMBclient.getNearestPlayer(player,{20},function(nplayer)
          local nuser_id = CLIMB.getUserId(nplayer)
          if nuser_id ~= nil then
         
            CLIMBclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
              if not handcuffed then
                  CLIMBclient.setHandcuffed(nplayer, {true})
              else
                  CLIMBclient.setHandcuffed(nplayer, {false})
              end
            end)

           
           
            CLIMB.closeMenu(nplayer)
          else
            CLIMBclient.notify(player,{"~d~There is no player nearby"})
          end
      end)
    end
end)

local unjailed = {}
function jail_clock(target_id,timer)
  local target = CLIMB.getUserSource(tonumber(target_id))
  local users = CLIMB.getUsers()
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  CLIMBclient.notify(target, {"~d~Remaining time: " .. timer .. " minute(s)."})
      CLIMB.setUData(tonumber(target_id),"CLIMB:jail:time",json.encode(timer))
	  SetTimeout(60*1000, function()
		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        unjailed[v] = nil
		    timer = 0
		  end
		end
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
    TriggerClientEvent("returnFalse", target)
	  CLIMBclient.teleport(target,{1854.2919921875,2586.1066894531,45.672054290771}) -- teleport to outside jail
	  CLIMBclient.setHandcuffed(target,{false})
      CLIMBclient.notify(target,{"~d~You have been set free."})
      
	  CLIMB.setUData({tonumber(target_id),"CLIMB:jail:time",json.encode(-1)})
    end
  end
end

RegisterServerEvent('CLIMB:SeizeWeapons2')
AddEventHandler('CLIMB:SeizeWeapons2', function()
  local source = source
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.menu") then
            CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
              CLIMBclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = CLIMB.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  CLIMB.clearInventory(nuser_id) 
                  CLIMBclient.notify(player, {'~g~Seized players weapons'})
                  CLIMBclient.notify(nplayer, {'~d~Your weapons were seized'})
                else
                    CLIMBclient.notify(player,{"~d~There is no player nearby"})
                end
                else
                    CLIMBclient.notify(player,{"~d~There is no player nearby"})
                end
              else
                CLIMBclient.notify(player, {'~d~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

RegisterServerEvent('CLIMB:JailPlayer')
AddEventHandler('CLIMB:JailPlayer', function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.armoury") then
    CLIMBclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. CLIMB.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
        CLIMB.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            if not target_id and nplayers then return end
            CLIMB.prompt(player,"Jail Time in minutes:","1",function(player,jail_time)
              if jail_time ~= nil and jail_time ~= "" then 
                local target = CLIMB.getUserSource(tonumber(target_id))
                if target ~= nil then
                  if tonumber(jail_time) > 60 then
                      jail_time = 60
                  end
                  if tonumber(jail_time) < 1 then
                    jail_time = 1
                  end
            
                  CLIMBclient.isHandcuffed(target,{}, function(handcuffed)  
                        CLIMBclient.loadFreeze(target,{false,true,true})
                      SetTimeout(15000,function()
                        CLIMBclient.loadFreeze(target,{false,false,false})
                      end)
                      CLIMBclient.teleport(target,{1779.8850097656,2584.3186035156,45.797779083252}) -- teleport to inside jail
                      CLIMBclient.notify(target,{"~d~You have been sent to jail."})
                      CLIMBclient.notify(player,{"~d~You sent a player to jail."})
                      CLIMBclient.setHandcuffed(target, {false})
                      jail_clock(tonumber(target_id),tonumber(jail_time))
                      TriggerClientEvent("returnTrue", target)
                      TriggerClientEvent("stopjail", target)
                      local user_id = CLIMB.getUserId(player)
                      local jaillogs = {
                        {
                            ["color"] = "16777215",
                            ["description"] = "**ID:** " .. user_id .. " **jailed **" .. target_id .. "** for **" .. jail_time .. " **minutes**",
                            ["footer"] = {
                              ["text"] = " - "..os.date("%X"),
                              ["icon_url"] = "https://media.discordapp.net/attachments/1014165521563914311/1038550242116784268/unknown.png",
                            }
                        }
                    }
                    PerformHttpRequest("https://discord.com/api/webhooks/1038909072184975450/ZITMWPZksHHzGnDkWK-dnh_xb5R1Kwrwz822P6R4lRNlM0JMc5VYct07BaBx06e6f8O4", function(err, text, headers) 
                    end, "POST", json.encode({username = "Jail Logs", embeds = jaillogs}), { ["Content-Type"] = "application/json" })
                  end)
                else
                  CLIMBclient.notify(player,{"~d~That ID seems invalid."})
                end
              else
                CLIMBclient.notify(player,{"~d~The jail time can't be empty."})
              end
            end)
          else
            CLIMBclient.notify(player,{"~d~No player ID selected."})
          end 
        end)
    end)
    else
        print(user_id.." could be modding")
    end
end)

RegisterServerEvent('CLIMB:UnJailPlayer')
AddEventHandler('CLIMB:UnJailPlayer', function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "admin.noclip") then
	  CLIMB.prompt(player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
      CLIMB.getUData(tonumber(target_id),"CLIMB:jail:time",function(value)
        if value ~= nil then
        custom = json.decode(value)
        if custom ~= nil then
          local user_id = CLIMB.getUserId(player)
          if tonumber(custom) > 0 or CLIMB.hasPermission(user_id,"admin.noclip") then
                local target = CLIMB.getUserSource(tonumber(target_id))
          if target ~= nil then
            unjailed[target] = tonumber(target_id)
            CLIMB.setUData(tonumber(target_id),"CLIMB:jail:time",json.encode(-1))
            CLIMBclient.notify(player,{"~g~Target will be released soon."})
            CLIMBclient.notify(target,{"~g~Someone lowered your sentence."})
            local unjaillogs = {
              {
                  ["color"] = "16777215",
                  ["description"] = "**ID:** " .. user_id .. " **unjailed** " .. target_id,
                  ["footer"] = {
                    ["text"] = " - "..os.date("%X"),
                    ["icon_url"] = "https://media.discordapp.net/attachments/1014165521563914311/1038550242116784268/unknown.png",
                  }
              }
          }
          PerformHttpRequest("", function(err, text, headers) 
          end, "POST", json.encode({username = "Unjail Logs", embeds = unjaillogs}), { ["Content-Type"] = "application/json" })
          else
            CLIMBclient.notify(player,{"~d~That ID seems invalid."})
          end
          else
          CLIMBclient.notify(player,{"~d~Target is not jailed."})
          end
        end
		  end
		end)
      else
        CLIMBclient.notify(player,{"~d~No player ID selected."})
      end 
  end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterServerEvent('CLIMB:sendFine')
AddEventHandler('CLIMB:sendFine', function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.group") then
      CLIMBclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. CLIMB.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        CLIMB.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            CLIMB.prompt(player,"Fine amount:","100",function(player,fine)
              if fine ~= nil and fine ~= "" then 
                CLIMB.prompt(player,"Fine reason:","",function(player,reason)
                  if reason ~= nil and reason ~= "" then 
                    local target = CLIMB.getUserSource(tonumber(target_id))
                    if target ~= nil then
                      if tonumber(fine) > 100000 then
                          fine = 100000
                      end
                      if tonumber(fine) < 100 then
                        fine = 100
                      end
                
                      if CLIMB.tryFullPayment(tonumber(target_id), tonumber(fine)) then
                        CLIMB.insertPoliceRecord(tonumber(target_id), lang.police.menu.fine.record({reason,fine}))
                        CLIMBclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                        CLIMBclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                        local user_id = CLIMB.getUserId(player)
                        CLIMB.closeMenu(player)
                      else
                        CLIMBclient.notify(player,{lang.money.not_enough()})
                      end
                    else
                      CLIMBclient.notify(player,{"~d~That ID seems invalid."})
                    end
                  else
                    CLIMBclient.notify(player,{"~d~You can't fine for no reason."})
                  end
                end)
              else
                CLIMBclient.notify(player,{"~d~Your fine has to have a value."})
              end
            end)
          else
            CLIMBclient.notify(player,{"~d~No player ID selected."})
          end 
        end)
      else
        CLIMBclient.notify(player,{"~d~No player nearby."})
      end 
    end)
  else
    print(user_id.." Could be modder")
  end
end)
RegisterNetEvent("CLIMB:PutPlrInVeh")
AddEventHandler("CLIMB:PutPlrInVeh", function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.armoury") then
    CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = CLIMB.getUserId(nplayer)
      if nuser_id ~= nil then
        CLIMBclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            CLIMBclient.putInNearestVehicleAsPassenger(nplayer, {5})
          else
            CLIMBclient.notify(player,{"~d~Player is not not cuffed."})
          end
        end)
      else
        CLIMBclient.notify(player,{"~d~No player nearby."})
      end
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("CLIMB:TakeOutOfVehicle")
AddEventHandler("CLIMB:TakeOutOfVehicle", function()
    player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.armoury") then
    CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = CLIMB.getUserId(nplayer)
        if nuser_id ~= nil then
        CLIMBclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
            CLIMBclient.ejectVehicle(nplayer, {})
            else
              CLIMBclient.notify(player,{"~d~Player is not not cuffed."})
            end
        end)
        else
          CLIMBclient.notify(player,{"~d~No player nearby."})
        end
    end)
    else
        print(user_id.." Could be modder")
    end
end)

RegisterNetEvent("CLIMB:SearchPlayer")
AddEventHandler("CLIMB:SearchPlayer", function()
    player = source
    if user_id ~= nil and CLIMB.hasPermission(user_id, "police.armoury") then
      CLIMBclient.getNearestPlayer(player,{5},function(nplayer)
          local nuser_id = CLIMB.getUserId(nplayer)
          if nuser_id ~= nil then
            CLIMBclient.notify(nplayer,{lang.police.menu.check.checked()})
            CLIMBclient.getWeapons(nplayer,{},function(weapons)
              -- prepare display data (money, items, weapons)
              local money = CLIMB.getMoney(nuser_id)
              local items = ""
              local data = CLIMB.getUserDataTable(nuser_id)
              if data and data.inventory then
                for k,v in pairs(data.inventory) do
                  local item = CLIMB.items[k]
                  if item then
                    items = items.."<br />"..item.name.." ("..v.amount..")"
                  end
                end
              end
      
              local weapons_info = ""
              for k,v in pairs(weapons) do
                weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
              end
      
              CLIMBclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
              -- request to hide div
              CLIMB.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                CLIMBclient.removeDiv(player,{"police_check"})
              end)
            end)
          else
            CLIMBclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end
end)