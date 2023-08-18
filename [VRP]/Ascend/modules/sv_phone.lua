local cfg_inventory = module("CLIMBVehicles", "cfg/cfg_inventory")
local lang = CLIMB.lang

RegisterServerEvent("CLIMB:AskID")
AddEventHandler("CLIMB:AskID",function()
    local player = source

    CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = CLIMB.getUserId(nplayer)
      if nuser_id ~= nil then
        CLIMBclient.notify(player,{lang.police.menu.askid.asked()})
        CLIMB.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
          if ok then
            CLIMB.getUserIdentity(nuser_id, function(identity)
              if identity then
                -- display identity and business
                local name = identity.name
                local firstname = identity.firstname
                local age = identity.age
                local phone = identity.phone
                local registration = identity.registration
                local home = ""
                local number = ""
  
  
                  CLIMB.getUserAddress(nuser_id, function(address)
                    if address then
                      home = address.home
                      number = address.number
                    end
  
                    local content = lang.police.identity.info({name,firstname,age,registration,phone,home,number})
                    CLIMBclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                    -- request to hide div
                    CLIMB.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                      CLIMBclient.removeDiv(player,{"police_identity"})
                    end)
                  end)
              
              end
            end)
          else
            CLIMBclient.notify(player,{lang.common.request_refused()})
          end
        end)
      else
        CLIMBclient.notify(player,{lang.common.no_player_near()})
      end
    end)
end)

RegisterServerEvent("CLIMB:GiveMoney2")
AddEventHandler("CLIMB:GiveMoney2",function()
    local player = source
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil then
      CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
        local nuser_id = CLIMB.getUserId(nplayer)
        if nuser_id ~= nil then
            CLIMB.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and CLIMB.tryPayment(user_id,amount) then
                CLIMB.giveMoney(nuser_id,amount)
                CLIMBclient.notify(player,{"~d~You have gave ~w~" .. amount .. " ~d~Cash(s)" })
                CLIMBclient.notify(nplayer,{"~g~You have recieved ~w~" .. amount .. " ~g~Cash(s)"})
            else
                CLIMBclient.notify(player,{lang.money.not_enough()})
                end
            end)
            else
                CLIMBclient.notify(player,{lang.common.no_player_near()})
            end
            else
                CLIMBclient.notify(player,{lang.common.no_player_near()})
            end
        end)
    end
end)

local function ch_vehicle(player,choice)
  local user_id = CLIMB.getUserId(player)
  if user_id ~= nil then
    -- check vehicle
    CLIMBclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
      if ok then
        -- build vehicle menu
        CLIMB.buildMenu("vehicle", {user_id = user_id, player = player, vtype = vtype, vname = name}, function(menu)
          menu.name=lang.vehicle.title()
          menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}

          for k,v in pairs(veh_actions) do
            menu[k] = {function(player,choice) v[1](user_id,player,vtype,name) end, v[2]}
          end

          CLIMB.openMenu(player,menu)
        end)
      else
        CLIMBclient.notify(player,{lang.vehicle.no_owned_near()})
      end
    end)
  end
end

RegisterNetEvent('CLIMB:TrunkOpened')
AddEventHandler('CLIMB:TrunkOpened', function()
  local user_id = CLIMB.getUserId(source)
  CLIMBclient.getNearestOwnedVehicle(source,{7},function(ok,vtype,name)
    if ok then 
      local chestname = "u"..user_id.."veh_"..string.lower(name)
      local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

      CLIMBclient.vc_openDoor(source, {vtype,5})
      CLIMB.openChest(source, chestname, max_weight, function()
        CLIMBclient.vc_closeDoor(source, {vtype,5})
      end)
    end
  end)
end)

RegisterNetEvent('CLIMB:SearchPlr')
AddEventHandler("CLIMB:SearchPlr", function()
  player = source
  CLIMBclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = CLIMB.getUserId(nplayer)
    if nuser_id ~= nil then
      -- TriggerClientEvent('CLIMB:handsUpNearest', nplayer)
      CLIMBclient.notify(nplayer,{lang.police.menu.check.checked()})
      CLIMBclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = CLIMB.getMoney(nuser_id)
        local items = ""
        local data = CLIMB.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = CLIMB.getItemName(k)
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
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
end)

RegisterServerEvent('CLIMB:searchNearestPlayer')
AddEventHandler('CLIMB:searchNearestPlayer', function(nplayer)
  CLIMBclient.notify(nplayer,{lang.police.menu.check.checked()})
  CLIMBclient.getWeapons(nplayer,{},function(weapons)
    -- prepare display data (money, items, weapons)
    local money = CLIMB.getMoney(nuser_id)
    local items = ""
    local data = CLIMB.getUserDataTable(nuser_id)
    if data and data.inventory then
      for k,v in pairs(data.inventory) do
        local item_name = CLIMB.getItemName(k)
        if item_name then
          items = items.."<br />"..item_name.." ("..v.amount..")"
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
end)

RegisterServerEvent("CLIMB:SendPayment")
AddEventHandler('CLIMB:SendPayment', function(playerid, price)
    local source = source
    userid = CLIMB.getUserId(source)
    reciever = CLIMB.getUserSource(tonumber(playerid))
    recieverid = CLIMB.getUserId(reciever)
    
    if recieverid == nil then
        CLIMBclient.notify(source, {"~d~This ID does not exist/ is offline!"})
        TriggerClientEvent("CLIMB:PlaySound", source, 2)
    else

        if userid == recieverid then 
            CLIMBclient.notify(source, {"~d~Unable to send money to yourself!"})
            TriggerClientEvent("CLIMB:PlaySound", source, 2)
        else
    
            if CLIMB.tryBankPayment(userid, tonumber(price)) then 

                CLIMBclient.notify(source, {"~g~Successfully transfered: ~w~" .. price .. " Token(s) ~g~to ~w~" .. CLIMB.getPlayerName(reciever) .. " ~d~ ~n~ ~n~[ID: ~w~" .. playerid .. " ~d~]"})
                TriggerClientEvent("CLIMB:PlaySound", source, 1)
                CLIMB.giveBankMoney(tonumber(playerid), tonumber(price))

                CLIMBclient.notify(reciever, {"~g~You have recieved: ~w~" .. price .. " Token(s)~g~ from ~w~".. CLIMB.getPlayerName(source) .. " ~d~ ~n~ ~n~[ID: ~w~" .. userid .. " ~d~]"})
                TriggerClientEvent("CLIMB:PlaySound", reciever, 1)

                else 
                CLIMBclient.notify(source, {"~d~You do not have enough money complete transaction 🤦‍♂️"})
                TriggerClientEvent("CLIMB:PlaySound", source, 2)
            end
        end
    end
end)