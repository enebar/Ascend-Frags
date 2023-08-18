-- -- a basic garage implementation
-- -- vehicle db
local lang = CLIMB.lang
local cfg = module("CLIMBVehicles", "cfg/cfg_garages")
local cfg_inventory = module("CLIMBVehicles", "cfg/cfg_inventory")
local vehicle_groups = cfg.garage_types
local limit = 500000000
MySQL.createCommand("CLIMB/add_vehicle","INSERT IGNORE INTO climb_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)")
MySQL.createCommand("CLIMB/remove_vehicle","DELETE FROM climb_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CLIMB/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate FROM climb_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("CLIMB/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM climb_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("CLIMB/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM climb_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("CLIMB/get_vehicle","SELECT vehicle FROM climb_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CLIMB/check_rented","SELECT * FROM climb_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("CLIMB/sell_vehicle_player","UPDATE climb_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("CLIMB/rentedupdate", "UPDATE climb_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("CLIMB/fetch_rented_vehs", "SELECT * FROM climb_user_vehicles WHERE rented = 1")


Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('CLIMB/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('CLIMB/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
               end
            end
        end)
    end
end)

RegisterNetEvent('CLIMB:FetchCars')
AddEventHandler('CLIMB:FetchCars', function(owned, type)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local returned_table = {}
    if user_id then
        if not owned then
            for i, v in pairs(vehicle_groups) do
                local noperms = false;
                local config = vehicle_groups[i]._config
                if config.vtype == type or config.vtype2 == type or config.vtype3 == type then 
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not CLIMB.hasPermission(user_id, v) then
                                noperms = true;
                            end
                        end
                    end
                    if not noperms then 
                        returned_table[i] = {
                            ["config"] = config
                        }
                        returned_table[i].vehicles = {}
                        for a, z in pairs(v) do
                            if a ~= "_config" then
                                returned_table[i].vehicles[a] = {z[1], z[2]}
                            end
                        end
                    end
                end 
            end
            TriggerClientEvent('CLIMB:ReturnFetchedCars', source, returned_table)
        else
            MySQL.query("CLIMB/get_vehicles", {
                user_id = user_id
            }, function(pvehicles, affected, plate)
                for _, veh in pairs(pvehicles) do
                    for i, v in pairs(vehicle_groups) do
                        local noperms = false;
                        local config = vehicle_groups[i]._config
                        if config.vtype == type or config.vtype2 == type or config.vtype3 == type then 
                            local perm = config.permissions or nil
                            if perm then
                                for i, v in pairs(perm) do
                                    if not CLIMB.hasPermission(user_id, v) then
                                        noperms = true;
                                    end
                                end
                            end
                            if not noperms then 
                                for a, z in pairs(v) do
                                    if a ~= "_config" and veh.vehicle == a then
                                        if not returned_table[i] then 
                                            returned_table[i] = {
                                                ["config"] = config
                                            }
                                        end
                                        if not returned_table[i].vehicles then 
                                            returned_table[i].vehicles = {}
                                        end
                                        returned_table[i].vehicles[a] = {z[1], z[2], veh.vehicle_plate} -- plate from CLIMB/get_vehicles
                                    end
                                end
                            end
                        end
                    end
                end
                TriggerClientEvent('CLIMB:ReturnFetchedCars', source, returned_table)
            end)
        end
    end
end)

RegisterNetEvent('CLIMB:ScrapVehicle')
AddEventHandler('CLIMB:ScrapVehicle', function(vehicle)
    local source = source
    local user_id = CLIMB.getUserId(source)
    if user_id then 
        MySQL.query("CLIMB/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("CLIMB/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    CLIMBclient.notify(source,{"~d~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    CLIMBclient.notify(source,{"~d~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('CLIMB/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                TriggerClientEvent('CLIMB:CloseGarage', source)
            end)
        end)
    end
end)

RegisterNetEvent('CLIMB:SellVehicle')
AddEventHandler('CLIMB:SellVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = CLIMB.getUserId(source)
    if playerID ~= nil then
		CLIMBclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. CLIMB.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				CLIMB.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = CLIMB.getUserSource(tonumber(user_id))
						if target ~= nil then
							CLIMB.prompt(player,"Price £: ","",function(player,amount)
								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
									MySQL.query("CLIMB/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
										if #pvehicle > 0 then
											CLIMBclient.notify(player,{"~d~The player already has this vehicle type."})
										else
											local tmpdata = CLIMB.getUserTmpTable(playerID)
											MySQL.query("CLIMB/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                if #pvehicles > 0 then 
                                                    CLIMBclient.notify(player,{"~d~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    CLIMB.request(target,GetPlayerName(player).." wants to sell: " ..name.. " Price: £"..amount, 10, function(target,ok)
                                                        if ok then
                                                            local pID = CLIMB.getUserId(target)
                                                            amount = tonumber(amount)
                                                            if CLIMB.tryFullPayment(pID,amount) then
                                                                CLIMBclient.despawnGarageVehicle(player,{'car',15}) 
                                                                CLIMB.getUserIdentity(pID, function(identity)
                                                                    MySQL.execute("CLIMB/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
                                                                end)
                                                                CLIMB.giveBankMoney(playerID, amount)
                                                                CLIMBclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for £"..amount.."!"})
                                                                CLIMBclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for £"..amount.."!"})
                                                                TriggerClientEvent('CLIMB:CloseGarage', player)
                                                                webhook = "https://discord.com/api/webhooks/1059088139496456262/MTU3go60fzGKmbopBFEkgWvcnqdvJdXSuOw9STWmUF3XcftrD6ckxFuan_5w7JWjB4E4"
       
                                                                PerformHttpRequest(webhook, function(err, text, headers) 
                                                                end, "POST", json.encode({username = "CLIMB", embeds = {
                                                                    {
                                                                        ["color"] = "15158332",
                                                                        ["title"] = "Car Sale",
                                                                        ["description"] = "**Seller Name: **" .. GetPlayerName(player) .. "** \nUser ID: **" .. playerID.. "** \nPrice: **£" .. amount .. '**\nReciever ID: **' ..pID..'**\nSpawncode:** '..name,
                                                                        ["footer"] = {
                                                                            ["text"] = "Time - "..os.date("%x %X %p"),
                                                                        }
                                                                }
                                                            }}), { ["Content-Type"] = "application/json" })
                                                            else
                                                                CLIMBclient.notify(player,{"~d~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                CLIMBclient.notify(target,{"~d~You don't have enough money!"})
                                                            end
                                                        else
                                                            CLIMBclient.notify(player,{"~d~"..GetPlayerName(target).." has refused to buy the car."})
                                                            CLIMBclient.notify(target,{"~d~You have refused to buy "..GetPlayerName(player).."'s car."})
                                                        end
                                                    end)
                                                end
                                            end)
										end
									end) 
								else
									CLIMBclient.notify(player,{"~d~The price of the car has to be a number."})
								end
							end)
						else
							CLIMBclient.notify(player,{"~d~That ID seems invalid."})
						end
					else
						CLIMBclient.notify(player,{"~d~No player ID selected."})
					end
				end)
			else
				CLIMBclient.notify(player,{"~d~No players nearby."})
			end
		end)
    end
end)


RegisterNetEvent('CLIMB:RentVehicle')
AddEventHandler('CLIMB:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = CLIMB.getUserId(source)
    if playerID ~= nil then
		CLIMBclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. CLIMB.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				CLIMB.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = CLIMB.getUserSource(tonumber(user_id))
						if target ~= nil then
							CLIMB.prompt(player,"Price £: ","",function(player,amount)
                                CLIMB.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("CLIMB/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    CLIMBclient.notify(player,{"~d~The player already has this vehicle type."})
                                                else
                                                    local tmpdata = CLIMB.getUserTmpTable(playerID)
                                                    MySQL.query("CLIMB/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            CLIMBclient.notify(player,{"~d~You cannot rent a rented vehicle!"})
                                                            return
                                                        else
                                                            CLIMB.request(target,GetPlayerName(player).." wants to rent: " ..name.. " Price: £"..amount .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                if ok then
                                                                    local pID = CLIMB.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if CLIMB.tryFullPayment(pID,amount) then
                                                                        CLIMBclient.despawnGarageVehicle(player,{'car',15}) 
                                                                        CLIMB.getUserIdentity(pID, function(identity)
                                                                            local rentedTime = os.time()
                                                                            rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                            MySQL.execute("CLIMB/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                        end)
                                                                        CLIMB.giveBankMoney(playerID, amount)
                                                                        CLIMBclient.notify(player,{"~g~You have successfully rented the vehicle to ".. GetPlayerName(target).." for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        CLIMBclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you the car for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        TriggerClientEvent('CLIMB:CloseGarage', player)
                                                                    else
                                                                        CLIMBclient.notify(player,{"~d~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                        CLIMBclient.notify(target,{"~d~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    CLIMBclient.notify(player,{"~d~"..GetPlayerName(target).." has refused to rent the car."})
                                                                    CLIMBclient.notify(target,{"~d~You have refused to rent "..GetPlayerName(player).."'s car."})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            CLIMBclient.notify(player,{"~d~The price of the car has to be a number."})
                                        end
                                    else 
                                        CLIMBclient.notify(player,{"~d~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							CLIMBclient.notify(player,{"~d~That ID seems invalid."})
						end
					else
						CLIMBclient.notify(player,{"~d~No player ID selected."})
					end
				end)
			else
				CLIMBclient.notify(player,{"~d~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('CLIMB:FetchVehiclesIn')
AddEventHandler('CLIMB:FetchVehiclesIn', function()
    local returned_table = {}
    local source = source
    local user_id = CLIMB.getUserId(source)
    MySQL.query("CLIMB/get_rented_vehicles_in", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not CLIMB.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left"
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a] = {z[1], datetime}
                    end
                end
            end
        end
        TriggerClientEvent('CLIMB:ReturnFetchedCars', source, returned_table)
    end)
end)

RegisterNetEvent('CLIMB:FetchVehiclesOut')
AddEventHandler('CLIMB:FetchVehiclesOut', function()
    local returned_table = {}
    local source = source
    local user_id = CLIMB.getUserId(source)
    MySQL.query("CLIMB/get_rented_vehicles_out", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not CLIMB.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left."
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a .. ':' .. veh.user_id] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        TriggerClientEvent('CLIMB:ReturnFetchedCars', source, returned_table)
    end)
end)


local veh_actions = {}

-- open trunk
veh_actions[lang.vehicle.trunk.title()] = {function(user_id,player,vtype,name)
  local chestname = "u"..user_id.."veh_"..string.lower(name)
  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

  -- open chest
  CLIMBclient.vc_openDoor(player, {vtype,5})
  CLIMB.openChest(player, chestname, max_weight, function()
    CLIMBclient.vc_closeDoor(player, {vtype,5})
  end)
end, lang.vehicle.trunk.description()}

--sell2
MySQL.createCommand("CLIMB/sell_vehicle_player","UPDATE climb_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")




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

-- ask trunk (open other user car chest)
local function ch_asktrunk(player,choice)
  CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = CLIMB.getUserId(nplayer)
    if nuser_id ~= nil then
      CLIMBclient.notify(player,{lang.vehicle.asktrunk.asked()})
      CLIMB.request(nplayer,lang.vehicle.asktrunk.request(),15,function(nplayer,ok)
        if ok then -- request accepted, open trunk
          CLIMBclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
            if ok then
              local chestname = "u"..nuser_id.."veh_"..string.lower(name)
              local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

              -- open chest
              local cb_out = function(idname,amount)
                CLIMBclient.notify(nplayer,{lang.inventory.give.given({CLIMB.getItemName(idname),amount})})
              end

              local cb_in = function(idname,amount)
                CLIMBclient.notify(nplayer,{lang.inventory.give.received({CLIMB.getItemName(idname),amount})})
              end

              CLIMBclient.vc_openDoor(nplayer, {vtype,5})
              CLIMB.openChest(player, chestname, max_weight, function()
                CLIMBclient.vc_closeDoor(nplayer, {vtype,5})
              end,cb_in,cb_out)
            else
              CLIMBclient.notify(player,{lang.vehicle.no_owned_near()})
              CLIMBclient.notify(nplayer,{lang.vehicle.no_owned_near()})
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
end

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = CLIMB.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if CLIMB.tryGetInventoryItem(user_id,"repairkit",1,true) then
      CLIMBclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        CLIMBclient.fixeNearestVehicle(player,{7})
        CLIMBclient.stopAnim(player,{false})
      end)
    end
  end
end

-- replace nearest vehicle
local function ch_replace(player,choice)
  CLIMBclient.replaceNearestVehicle(player,{7})
end

RegisterNetEvent("returnVIP")
AddEventHandler("returnVIP", function()
    
    local source = source 
    userid = CLIMB.getUserId(source)
    if CLIMB.hasGroup(userid, "VIP") then 
        TriggerClientEvent("openVIP", source)
    end
end)
RegisterNetEvent("returnVIPaircraft")
AddEventHandler("returnVIPaircraft", function()
    
    local source = source 
    userid = CLIMB.getUserId(source)
    if CLIMB.hasGroup(userid, "VIP") then 
        TriggerClientEvent("openVIPaircraft", source)
    end
end)

RegisterServerEvent("CLIMB:FetchFolders")
AddEventHandler('CLIMB:FetchFolders', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    exports["ghmattimysql"]:execute("SELECT * from `CLIMB_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("CLIMB:ReturnFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("CLIMB:UpdateFolders")
AddEventHandler('CLIMB:UpdateFolders', function(FolderUpdated)
    local source = source
    local user_id = CLIMB.getUserId(source)

    exports["ghmattimysql"]:execute("SELECT * from `CLIMB_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['ghmattimysql']:execute("UPDATE CLIMB_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['ghmattimysql']:execute("INSERT INTO CLIMB_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

RegisterNetEvent("returnpolice")
AddEventHandler("returnpolice", function()
    
    local source = source 
    userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "police.armoury" ) then
        TriggerClientEvent("openPolice", source)
    end
end)

RegisterNetEvent("returnRebel")
AddEventHandler("returnRebel", function()
    
    local source = source 
    userid = CLIMB.getUserId(source)
   if CLIMB.hasGroup(userid, "Rebel") then 
        TriggerClientEvent("openRebel", source)
    end
end)

RegisterNetEvent("CLIMB:PayVehicleTax")
AddEventHandler("CLIMB:PayVehicleTax", function()
    local user_id = CLIMB.getUserId(source)

    if user_id ~= nil then
        local bank = CLIMB.getBankMoney(user_id)
        local payment = bank / 10000
    
       
        if bank == 0 then
            CLIMBclient.notify(source,{"~d~Its fine... Tax payers will pay your vehicle tax instead."})
        elseif CLIMB.tryBankPayment(user_id, payment) then
            CLIMBclient.notify(source,{"~g~Paid £"..getMoneyStringFormatted(roundnumber(payment, 0)).." vehicle tax."})
        end
    end
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function roundnumber(P, Q)
    local R = 10 ^ (Q or 0)
    return math.floor(P * R + 0.5)
end

Citizen.CreateThread(function()
    Wait(1500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `CLIMB_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)