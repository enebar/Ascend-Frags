
admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false


--[[ {enabled -- true or false}, permission required ]]
admincfg.buttonsEnabled = {

    --[[ admin Menu ]]
    ["adminMenu"] = {true, "admin.tickets"},
    ["warn"] = {true, "admin.warn"},      
    ["showwarn"] = {true, "admin.showwarn"},
    ["ban"] = {true, "admin.ban"},
    ["unban"] = {true, "admin.unban"},
    ["kick"] = {true, "admin.kick"},
    ["revive"] = {true, "admin.revive"},
    ["armour"] = {true, "admin.special"},
    ["TP2"] = {true, "admin.tp2player"},
    ["TP2ME"] = {true, "admin.summon"},
    ["FREEZE"] = {true, "admin.freeze"},
    ["spectate"] = {true, "admin.spectate"}, 
    ["SS"] = {true, "admin.screenshot"},
    ["slap"] = {true, "admin.slap"},
    ["giveMoney"] = {true, "admin.givemoney"},
    ["addcar"] = {true, "admin.addcar"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},
    ["spawnGun"] = {true, "admin.spawnGun"},

    --[[ Add Groups ]]
    ["getgroups"] = {true, "group.add"},
    ["staffGroups"] = {true, "admin.staffAddGroups"},
    ["mpdGroups"] = {true, "admin.mpdAddGroups"},
    ["povGroups"] = {true, "admin.povAddGroups"},
    ["licenseGroups"] = {true, "admin.licenseAddGroups"},
    ["donoGroups"] = {true, "admin.donoAddGroups"},
    ["nhsGroups"] = {true, "admin.nhsAddGroups"},

    --[[ Vehicle Functions ]]
    ["vehFunctions"] = {true, "admin.vehmenu"},
    ["noClip"] = {true, "admin.noclip"},

    -- [[ Developer Functions ]]
    ["devMenu"] = {true, "dev.menu"},
}


RegisterServerEvent('CLIMB:OpenSettings')
AddEventHandler('CLIMB:OpenSettings', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if user_id ~= nil and CLIMB.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("CLIMB:OpenSettingsMenu", source, true)
    else
        TriggerClientEvent("CLIMB:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent("CLIMB:GetPlayerData")
AddEventHandler("CLIMB:GetPlayerData",function()
    local source = source
    user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, admincfg.perm) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if CLIMB.getUserId(p) ~= nil then
                name = GetPlayerName(p)
                user_idz = CLIMB.getUserId(p)
                data = CLIMB.getUserDataTable(user_idz)
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                players_table[user_idz] = {name, p, user_idz, math.ceil(PlayerTimeInHours)}
                table.insert(useridz, user_idz)
            else
                DropPlayer(p, " - The server was unable to cache your ID, please rejoin.")
            end
         end
        if admincfg.IgnoreButtonPerms == false then
            for i, b in pairs(admincfg.buttonsEnabled) do
                if b[1] and CLIMB.hasPermission(user_id, b[2]) then
                    menu_btns_table[i] = true
                else
                    menu_btns_table[i] = false
                end
            end
        else
            for j, t in pairs(admincfg.buttonsEnabled) do
                menu_btns_table[j] = true
            end
        end
        TriggerClientEvent("CLIMB:SendPlayerInfo", source, players_table, menu_btns_table)
    end
end)


RegisterCommand("gethours", function(source, args)
    local v = source
    local UID = CLIMB.getUserId(v)
    local D = math.ceil(CLIMB.getUserDataTable(UID).PlayerTime/60) or 0
    if UID then
            CLIMBclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
    end
end)


RegisterCommand("sethours", function(source, args) if source == 0 then data = CLIMB.getUserDataTable(tonumber(args[1])); data.PlayerTime = tonumber(args[2])*60; print(GetPlayerName(CLIMB.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))end  end)

RegisterNetEvent("CLIMB:GetNearbyPlayers")
AddEventHandler("CLIMB:GetNearbyPlayers", function(dist)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local plrTable = {}

    if CLIMB.hasPermission(user_id, admincfg.perm) then
        CLIMBclient.getNearestPlayers(source, {dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                data = CLIMB.getUserDataTable(CLIMB.getUserId(k))
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                plrTable[CLIMB.getUserId(k)] = {GetPlayerName(k), k, CLIMB.getUserId(k), math.ceil(PlayerTimeInHours)}
            end
            TriggerClientEvent("CLIMB:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)


RegisterServerEvent("CLIMB:GetGroups")
AddEventHandler("CLIMB:GetGroups",function(temp, perm)
    local user_groups = CLIMB.getUserGroups(perm)
    TriggerClientEvent("CLIMB:GotGroups", source, user_groups)
end)

RegisterServerEvent("CLIMB:CheckPov")
AddEventHandler("CLIMB:CheckPov",function(userperm)
    --print(userperm)
    local user_id = CLIMB.getUserId(source)
  
    if CLIMB.hasPermission(user_id, "admin.menu") then
        if CLIMB.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('CLIMB:ReturnPov', source, true)
        elseif not CLIMB.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('CLIMB:ReturnPov', source, false)
        end
    else 
     end
    
end)


RegisterServerEvent("other:deletevehicle")
AddEventHandler("other:deletevehicle",function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'police.armoury') or CLIMB.hasPermission(user_id, 'dev.menu')then
        TriggerClientEvent('wk:deleteVehicle', source)
    end
end)

RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

RegisterServerEvent("admin:cancelRent")
AddEventHandler("admin:cancelRent",function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    local originalOwner = ''
    if CLIMB.hasPermission(user_id, 'admin.noclip') then
        CLIMB.prompt(source,"Current Owner:","",function(source, currentOwner)
            if currentOwner == '' then return end
            local currentOwner = currentOwner
            CLIMB.prompt(source,"Spawncode:","",function(source, spawncode)
                local spawncode = spawncode
                if spawncode == '' then return end
                exports['ghmattimysql']:execute("SELECT * FROM `climb_user_vehicles` WHERE user_id = @user_id", {user_id = currentOwner}, function(result)
                    if result ~= nil then 
                        for k, v in pairs(result) do
                            if v.user_id == tonumber(currentOwner) and v.vehicle == spawncode then
                                originalOwner = v.rentedid
                                exports['ghmattimysql']:execute("UPDATE `climb_user_vehicles` SET user_id = @originalOwner, rented = 0, rentedid = '', rentedtime = '' WHERE user_id = @currentOwner AND vehicle = @spawncode", {currentOwner = currentOwner, originalOwner = tonumber(originalOwner), spawncode = spawncode})
                                CLIMBclient.notify(source,{"~g~Successfully cancelled rent."})
                            end
                        end
                    end
                end)
            end)
        end)
    end
end)

RegisterServerEvent("CLIMB:getNotes")
AddEventHandler("CLIMB:getNotes",function(admin, player)
    local source = source
    local admin_id = CLIMB.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    if CLIMB.hasPermission(admin_id, perm2) then
        exports['ghmattimysql']:execute("SELECT * FROM climb_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('CLIMB:sendNotes', source, json.encode(result))
            end
        end)
    else
        local player = CLIMB.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("CLIMB:acBan", admin_id, reason, name, player, 'Attempted to Get Notes')
    end
end)

RegisterServerEvent("CLIMB:addNote")
AddEventHandler("CLIMB:addNote",function(admin, player)
    local source = source
    local admin_id = CLIMB.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(player)
    local playerperm = CLIMB.getUserId(player)
    if CLIMB.hasPermission(admin_id, perm2) then
        CLIMB.prompt(source,"Reason:","",function(source,text) 
            if text == '' then return end
            exports['ghmattimysql']:execute("INSERT INTO climb_user_notes (`user_id`, `text`, `admin_name`, `admin_id`) VALUES (@user_id, @text, @admin_name, @admin_id);", {user_id = playerperm, text = text, admin_name = adminName, admin_id = admin_id}, function() end) 
            TriggerClientEvent('CLIMB:NotifyPlayer', source, '~g~You have added a note to '..playerName..'('..playerperm..') with the reason '..text)
            TriggerClientEvent('CLIMB:updateNotes', -1, admin, playerperm)
            local webhook = "https://discord.com/api/webhooks/1043328414469341224/NNOjJ5CbFao49hpkQyoLACBUe1Ec7rWtAQWxK-Xr9hU6qbYA04UiqJ1WyDgjbhl5De-h"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Group Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = adminName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = player,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = playerperm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note Message",
                            ["value"] = text,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        end)
    else
        local player = CLIMB.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("CLIMB:acBan", admin_id, reason, name, player, 'Attempted to Add Note')
    end
end)

RegisterServerEvent("CLIMB:removeNote")
AddEventHandler("CLIMB:removeNote",function(admin, player)
    local source = source
    local admin_id = CLIMB.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    local playerName = GetPlayerName(player)
    local playerperm = CLIMB.getUserId(player)
    if CLIMB.hasPermission(admin_id, perm2) then
        CLIMB.prompt(source,"Note ID:","",function(source,noteid) 
            if noteid == '' then return end
            exports['ghmattimysql']:execute("DELETE FROM climb_user_notes WHERE note_id = @noteid", {noteid = noteid}, function() end)
            TriggerClientEvent('CLIMB:NotifyPlayer', admin, '~g~You have removed note #'..noteid..' from '..playerName..'('..playerperm..')')
            TriggerClientEvent('CLIMB:updateNotes', -1, admin, playerperm)
            local webhook = "https://discord.com/api/webhooks/1043328414469341224/NNOjJ5CbFao49hpkQyoLACBUe1Ec7rWtAQWxK-Xr9hU6qbYA04UiqJ1WyDgjbhl5De-h"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Group Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = player,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = playerperm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note ID",
                            ["value"] = noteid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        end)
    else
        local player = CLIMB.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("CLIMB:acBan", admin_id, reason, name, player, 'Attempted to Remove Note')
    end
end)


local onesync = GetConvar('onesync', nil)
RegisterNetEvent('CLIMB:SpectatePlayer')
AddEventHandler('CLIMB:SpectatePlayer', function(id)
    local source = source 
    local SelectedPlrSource = CLIMB.getUserSource(id) 
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "admin.spectate") then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                
                TriggerClientEvent('CLIMB:Spectate', source, SelectedPlrSource, pedCoords)
            else 
                TriggerClientEvent('CLIMB:Spectate', source, SelectedPlrSource)
            end
        else 
            CLIMBclient.notify(source,{"~r~This player may have left the game."})
        end
    end
end)

RegisterNetEvent('CLIMB:Restart')
AddEventHandler('CLIMB:Restart', function()
    local source = source 
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, 'dev.menu') then
        TriggerClientEvent("CLIMB:closeToRestart", -1)
        TriggerClientEvent('CLIMB:announceRestart', -1, 60, false)
        Wait(60000)
        restartServer()
    end
end)

RegisterNetEvent('CLIMB:RemoveTimer')
AddEventHandler('CLIMB:RemoveTimer', function(player)
    local source = source 
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, 'admin.freeze') then
        TriggerClientEvent("CLIMB:StopTimer", player)
    end
end)

function restartServer()
    kickAllPlayers()
    Citizen.Wait(1000)
    os.exit()
end

function kickAllPlayers()
    for i,v in pairs(GetPlayers()) do 
        DropPlayer(v, 'CLIMB, Server Restart')
    end
end

RegisterServerEvent("CLIMB:Giveweapon")
AddEventHandler("CLIMB:Giveweapon",function()
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.menu") then
        CLIMB.prompt(source,"Weapon Name:","",function(source,hash) 
            TriggerClientEvent("CLIMB:allowWeaponSpawn", source, hash)
        end)
    end
end)

RegisterServerEvent("CLIMB:AddGroup")
AddEventHandler("CLIMB:AddGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = CLIMB.getUserId(admin_temp)
    local user_id = CLIMB.getUserId(source)
    local permsource = CLIMB.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if CLIMB.hasPermission(user_id, "group.add") then
        if selgroup == "founder" and not CLIMB.hasPermission(admin_perm, "group.add.founder") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "operationsmanager" and not CLIMB.hasPermission(user_id, "group.add.operationsmanager") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not CLIMB.hasPermission(admin_perm, "group.add.staffmanager") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not CLIMB.hasPermission(admin_perm, "group.add.commanager") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not CLIMB.hasPermission(admin_perm, "group.add.headadmin") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not CLIMB.hasPermission(admin_perm, "group.add.senioradmin") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not CLIMB.hasPermission(admin_perm, "group.add.administrator") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "srmoderator" and not CLIMB.hasPermission(admin_perm, "group.add.srmoderator") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not CLIMB.hasPermission(admin_perm, "group.add.moderator") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "supportteam" and not CLIMB.hasPermission(admin_perm, "group.add.supportteam") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not CLIMB.hasPermission(admin_perm, "group.add.trial") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not CLIMB.hasPermission(admin_perm, "group.add.vip") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not CLIMB.hasGroup(perm, "group.add.pov") then
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Group Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = "POV",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/1043327069049860206/fjvMgg2C79u_PHqHSoVph34OiQdJPHTaTkmbr3lKLPF8KAclBVt0p9o5BqIHv364cVSp"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            CLIMB.addUserGroup(perm, "pov")
        else
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Group Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/1043327069049860206/fjvMgg2C79u_PHqHSoVph34OiQdJPHTaTkmbr3lKLPF8KAclBVt0p9o5BqIHv364cVSp"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            CLIMB.addUserGroup(perm, selgroup)
        end
    else
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterServerEvent("CLIMB:RemoveGroup")
AddEventHandler("CLIMB:RemoveGroup",function(perm, selgroup)
    local user_id = CLIMB.getUserId(source)
    local admin_temp = source
    local permsource = CLIMB.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if CLIMB.hasPermission(user_id, "group.remove") then
        if selgroup == "founder" and not CLIMB.hasPermission(user_id, "group.remove.founder") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "operationsmanager" and not CLIMB.hasPermission(user_id, "group.remove.operationsmanager") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not CLIMB.hasPermission(user_id, "group.remove.staffmanager") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not CLIMB.hasPermission(user_id, "group.remove.commanager") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not CLIMB.hasPermission(user_id, "group.remove.headadmin") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not CLIMB.hasPermission(user_id, "group.remove.senioradmin") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not CLIMB.hasPermission(user_id, "group.remove.administrator") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "srmoderator" and not CLIMB.hasPermission(user_id, "group.remove.srmoderator") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not CLIMB.hasPermission(user_id, "group.remove.moderator") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "supportteam" and not CLIMB.hasPermission(user_id, "group.remove.supportteam") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not CLIMB.hasPermission(user_id, "group.remove.trial") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not CLIMB.hasPermission(user_id, "group.remove.vip") then
            CLIMBclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and CLIMB.hasGroup(perm, "group.remove.pov") then
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Group Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = "POV",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/1043327069049860206/fjvMgg2C79u_PHqHSoVph34OiQdJPHTaTkmbr3lKLPF8KAclBVt0p9o5BqIHv364cVSp"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            CLIMB.removeUserGroup(perm, "pov")
        else
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Group Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/1043327069049860206/fjvMgg2C79u_PHqHSoVph34OiQdJPHTaTkmbr3lKLPF8KAclBVt0p9o5BqIHv364cVSp"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            CLIMB.removeUserGroup(perm, selgroup)
        end
    else 
        print("Stop trying to remove a fucking cheater")
    end
end)

RegisterServerEvent("CLIMB:ForceClockOff")
AddEventHandler("CLIMB:ForceClockOff",function(admin, perm)
    local admin_id = CLIMB.getUserId(admin)
    local adminName = GetPlayerName(source)
    local targetPlayer = perm
    local targerPlayerSource = CLIMB.getUserSource(perm)
    local adminSource = CLIMB.getUserSource(admin_id)
    CLIMB.removeUserGroup(targetPlayer, 'Special Constable')
    CLIMB.removeUserGroup(targetPlayer, 'Commissioner')
    CLIMB.removeUserGroup(targetPlayer, 'Deputy Commissioner')
    CLIMB.removeUserGroup(targetPlayer, 'Assistant Commissioner')
    CLIMB.removeUserGroup(targetPlayer, 'Deputy Assistant Commissioner')
    CLIMB.removeUserGroup(targetPlayer, 'Commander')
    CLIMB.removeUserGroup(targetPlayer, 'Chief Superintendent')
    CLIMB.removeUserGroup(targetPlayer, 'Superintendent')
    CLIMB.removeUserGroup(targetPlayer, 'ChiefInspector')
    CLIMB.removeUserGroup(targetPlayer, 'Inspector')
    CLIMB.removeUserGroup(targetPlayer, 'Sergeant')
    CLIMB.removeUserGroup(targetPlayer, 'Senior Constable')
    CLIMB.removeUserGroup(targetPlayer, 'Police Constable')
    CLIMB.removeUserGroup(targetPlayer, 'PCSO')
    TriggerClientEvent('CLIMB:policeRemove', targerPlayerSource)
    CLIMBclient.notify(targerPlayerSource, {'~g~You have been force clocked off by ~r~'..adminName..'['..admin_id..']'})
end)

RegisterServerEvent('CLIMB:BanPlayer')
AddEventHandler('CLIMB:BanPlayer', function(admin, target, reason)
    local source = source
    local userid = CLIMB.getUserId(source)
    local target = target
    local target_id = CLIMB.getUserSource(target)
    local admin_id = CLIMB.getUserId(admin)
    local adminName = GetPlayerName(source)
    warningDate = getCurrentDate()
    if CLIMB.hasPermission(userid, "admin.ban") then
            CLIMB.prompt(source,"Duration:","",function(source,Duration)
                if Duration == "" then return end
                Duration = parseInt(Duration)
                CLIMB.prompt(source,"Evidence:","",function(source,Evidence)  
                    if Evidence == "" then return end
                    videoclip = Evidence
                        local webhook = "https://discord.com/api/webhooks/1043328828057063445/jbkNlDcMpC5aIKfT1odY6aFp6WonbxKnCjBn32Mc7NEavvA0b4YbQSIwmLFJ9q11Oaz-"
                        local command = {
                            {
                                ["color"] = "3944703",
                                ["title"] = " Ban Logs",
                                ["description"] = "",
                                ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                                ["fields"] = {
                                    {
                                        ["name"] = "Admin Name",
                                        ["value"] = GetPlayerName(source),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin TempID",
                                        ["value"] = source,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin PermID",
                                        ["value"] = userid,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player Name",
                                        ["value"] = GetPlayerName(target_id),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player TempID",
                                        ["value"] = target_id,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player PermID",
                                        ["value"] = target,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Reason",
                                        ["value"] = reason,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Duration",
                                        ["value"] = Duration,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Evidence",
                                        ["value"] = Evidence,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Custom",
                                        ["value"] = "false",
                                        ["inline"] = true
                                    }
                                }
                            }
                        }
                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
                        TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'You have banned '..GetPlayerName(target_id)..'['..target..']'..' for '..reason)
                        if tonumber(Duration) == -1 then
                            CLIMB.ban(source,target,"perm",reason)
                            f10Ban(target, adminName, reason, "-1")
                        else
                            CLIMB.ban(source,target,Duration,reason)
                            f10Ban(target, adminName, reason, Duration)
                    end
                end)
            end)
        end
end)

RegisterServerEvent('CLIMB:CustomBan')
AddEventHandler('CLIMB:CustomBan', function(admin, target)
    local source = source
    local userid = CLIMB.getUserId(source)
    local target = target
    local target_id = CLIMB.getUserSource(target)
    local admin_id = CLIMB.getUserId(admin)
    local adminName = GetPlayerName(source)
    warningDate = getCurrentDate()
    if CLIMB.hasPermission(userid, "admin.ban") then
        CLIMB.prompt(source,"Reason:","",function(source,Reason)
            if Reason == "" then return end
            CLIMB.prompt(source,"Duration:","",function(source,Duration)
                if Duration == "" then return end
                Duration = parseInt(Duration)
                CLIMB.prompt(source,"Evidence:","",function(source,Evidence)  
                    if Evidence == "" then return end
                    videoclip = Evidence
                    local webhook = "https://discord.com/api/webhooks/1043328828057063445/jbkNlDcMpC5aIKfT1odY6aFp6WonbxKnCjBn32Mc7NEavvA0b4YbQSIwmLFJ9q11Oaz-"
                    local command = {
                        {
                            ["color"] = "3944703",
                            ["title"] = " Ban Logs",
                            ["description"] = "",
                            ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                            ["fields"] = {
                                {
                                    ["name"] = "Admin Name",
                                    ["value"] = GetPlayerName(source),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Admin TempID",
                                    ["value"] = source,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Admin PermID",
                                    ["value"] = userid,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Player Name",
                                    ["value"] = GetPlayerName(target_id),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Player TempID",
                                    ["value"] = target_id,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Player PermID",
                                    ["value"] = target,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Ban Reason",
                                    ["value"] = Reason,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Ban Duration",
                                    ["value"] = Duration,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Evidence",
                                    ["value"] = Evidence,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Custom",
                                    ["value"] = "true",
                                    ["inline"] = true
                                }
                            }
                        }
                    }
                    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
                    TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'You have banned '..GetPlayerName(target)..'['..target_id..']'..' for '..Reason)
                    if tonumber(Duration) == -1 then
                        CLIMB.ban(source,target,"perm",Reason)
                        f10Ban(target, adminName, Reason, "-1")
                    else
                        CLIMB.ban(source,target,Duration,Reason)
                        f10Ban(target, adminName, Reason, Duration)
                    end
                end)
            end)
        end)
    end
end)


RegisterServerEvent('CLIMB:RequestScreenshot')
AddEventHandler('CLIMB:RequestScreenshot', function(admin,target)
    local target_id = CLIMB.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = CLIMB.getUserId(admin)
    local admin_name = GetPlayerName(source)
    local perm = admincfg.buttonsEnabled["SS"][2]
    if CLIMB.hasPermission(admin_id, perm) then
        exports["discord-screenshot"]:requestClientScreenshotUploadToDiscord(target,
            {
                username = " Screenshot Logs",
                avatar_url = "",
                embeds = {
                    {
                        color = 11111111,
                        title = admin_name.."["..admin_id.."] Took a screenshot",
                        description = "**Admin Name:** " ..admin_name.. "\n**Admin ID:** " ..admin_id.. "\n**Player Name:** " ..target_name.. "\n**Player ID:** " ..target_id,
                        footer = {
                            text = ""..os.date("%x %X %p"),
                        }
                    }
                }
            },
            30000,
            function(error)
                if error then
                    return print("^1ERROR: " .. error)
                end
                print("Sent screenshot successfully")
                TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Successfully took a screenshot of ' ..target_name.. "'s screen.")
            end
        )
    end   
end)

RegisterServerEvent('CLIMB:offlineban')
AddEventHandler('CLIMB:offlineban', function(admin)
    local source = source
    local userid = CLIMB.getUserId(source)
    local admin_id = CLIMB.getUserId(admin)
    local adminName = GetPlayerName(admin)
    warningDate = getCurrentDate()
    if CLIMB.hasPermission(userid, "admin.ban") then
        CLIMB.prompt(source,"Perm ID:","",function(source,permid)
            if permid == "" then return end
            permid = parseInt(permid)
            CLIMB.prompt(source,"Duration:","",function(source,Duration) 
                if Duration == "" then return end
                Duration = parseInt(Duration)
                CLIMB.prompt(source,"Reason:","",function(source,Reason) 
                    if Reason == "" then return end
                    CLIMB.prompt(source,"Evidence:","",function(source,Evidence) 
                        if Evidence == "" then return end
                        videoclip = Evidence
                        local target = permid
                        local target_id = CLIMB.getUserSource(target)
                        local webhook = "https://discord.com/api/webhooks/1043328828057063445/jbkNlDcMpC5aIKfT1odY6aFp6WonbxKnCjBn32Mc7NEavvA0b4YbQSIwmLFJ9q11Oaz-"
                        local command = {
                            {
                                ["color"] = "3944703",
                                ["title"] = " Offline Ban Logs",
                                ["description"] = "",
                                ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                                ["fields"] = {
                                    {
                                        ["name"] = "Admin Name",
                                        ["value"] = GetPlayerName(source),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin TempID",
                                        ["value"] = source,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin PermID",
                                        ["value"] = userid,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player Name",
                                        ["value"] = GetPlayerName(target_id),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player TempID",
                                        ["value"] = target_id,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player PermID",
                                        ["value"] = target,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Reason",
                                        ["value"] = Reason,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Duration",
                                        ["value"] = Duration,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Evidence",
                                        ["value"] = Evidence,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Custom",
                                        ["value"] = "true",
                                        ["inline"] = true
                                    }
                                }
                            }
                        }
                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
                        TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'You have offline banned '..permid..' for '..Reason)
                        if tonumber(Duration) == -1 then
                            CLIMB.ban(source,target,"perm",Reason)
                            f10Ban(target, adminName, Reason, "-1")
                        else
                            CLIMB.ban(source,target,Duration,Reason)
                            f10Ban(target, adminName, Reason, Duration)
                        end
                    end)
                end)
            end)
        end)
    end
end)

RegisterServerEvent('CLIMB:noF10Kick')
AddEventHandler('CLIMB:noF10Kick', function()
    local admin_id = CLIMB.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["kick"][2]
    playerName = GetPlayerName(source)
    if CLIMB.hasPermission(admin_id, perm2) then
        CLIMB.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            CLIMB.prompt(source,"Reason:","",function(source,reason) 
                if reason == '' then return end
                local reason = reason
                CLIMBclient.notify(source,{'~g~Kicked ID: ' .. permid})
                local webhook = "https://discord.com/api/webhooks/1043329089966194829/UDjN9M2JNdES7BbgIxuv3TeHqS7Uc1yTNjOdUfESxOf6m0ZcpcSiz_6fh4AjWStgEuaq"
                local command = {
                    {
                        ["color"] = "3944703",
                        ["title"] = " Kick Logs",
                        ["description"] = "",
                        ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                        ["fields"] = {
                            {
                                ["name"] = "Admin Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin PermID",
                                ["value"] = userid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Name",
                                ["value"] = GetPlayerName(CLIMB.getUserSource({permid})),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player TempID",
                                ["value"] = CLIMB.getUserSource({permid}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player PermID",
                                ["value"] = permid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Kick Reason",
                                ["value"] = reason,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Type",
                                ["value"] = "No F10",
                                ["inline"] = true
                            }
                        }
                    }
                }
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
                DropPlayer(CLIMB.getUserSource(permid), reason)
            end)
        end)
    end
end)


RegisterServerEvent('CLIMB:KickPlayer')
AddEventHandler('CLIMB:KickPlayer', function(admin, target, reason, tempid)
    local source = source
    local target_id = CLIMB.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = CLIMB.getUserId(admin)
    local adminName = GetPlayerName(admin)
    local webhook = "https://discord.com/api/webhooks/1043329089966194829/UDjN9M2JNdES7BbgIxuv3TeHqS7Uc1yTNjOdUfESxOf6m0ZcpcSiz_6fh4AjWStgEuaq"
    if CLIMB.hasPermission(admin_id, perm) then
            CLIMB.prompt(source,"Reason:","",function(source,Reason) 
                if Reason == "" then return end
                local webhook = "https://discord.com/api/webhooks/1043329089966194829/UDjN9M2JNdES7BbgIxuv3TeHqS7Uc1yTNjOdUfESxOf6m0ZcpcSiz_6fh4AjWStgEuaq"
                local command = {
                    {
                        ["color"] = "3944703",
                        ["title"] = " Kick Logs",
                        ["description"] = "",
                        ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                        ["fields"] = {
                            {
                                ["name"] = "Admin Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin PermID",
                                ["value"] = userid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Name",
                                ["value"] = GetPlayerName(CLIMB.getUserSource({target})),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player TempID",
                                ["value"] = CLIMB.getUserSource({target}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player PermID",
                                ["value"] = target,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Kick Reason",
                                ["value"] = Reason,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Type",
                                ["value"] = "F10",
                                ["inline"] = true
                            }
                        }
                    }
                }
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
                CLIMB.kick(target_id, " You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
                f10Kick(target_permid, adminName, Reason)
                TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Kicked Player')
            end)
        end
    
end)

RegisterServerEvent('CLIMB:RemoveWarning')
AddEventHandler('CLIMB:RemoveWarning', function(admin, warningid)
    local admin_id = CLIMB.getUserId(admin)
    local perm = admincfg.buttonsEnabled["removewarn"][2]
    if CLIMB.hasPermission(admin_id, perm) then     
        CLIMB.prompt(source,"Warning ID:","",function(source,warningid) 
            if warningid == "" then return end
            exports['ghmattimysql']:execute("DELETE FROM CLIMB_warnings WHERE warning_id = @uid", {uid = warningid})
            TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Removed warning #'..warningid..'')
            local webhook = "https://discord.com/api/webhooks/1043329380266557460/sDty6L5GEaaCTC_C_J-Xy6_sEEUIBqf9kfnRZrySIIrNVVZpLdvC4HBiaQMwvbAFBhKp"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Warning Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Warning ID",
                            ["value"] = warningid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
        end)
    end
end)

RegisterServerEvent("CLIMB:Unban")
AddEventHandler("CLIMB:Unban",function()
    local admin_id = CLIMB.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["unban"][2]
    local playerName = GetPlayerName(source)
    if CLIMB.hasPermission(admin_id, perm2) then
        CLIMB.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            CLIMBclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            local webhook = "https://discord.com/api/webhooks/1043329476379037767/FIUO_s3EXUsiiuiJwMS7x8F87D6EX8_Xf26Hf1UfsJ9OSrn2FsXT1fGBOs1HMbK2XTxz"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Ban Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = permid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Unban",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            CLIMB.setBanned(permid,false)
        end)
    end
end)

RegisterServerEvent("CLIMB:GetNotes")
AddEventHandler("CLIMB:GetNotes",function(player)
    local source = source
    local admin_id = CLIMB.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    if CLIMB.hasPermission(admin_id, perm2) then
        exports['ghmattimysql']:execute("SELECT * FROM `climb_users` WHERE id = @user_id", {user_id = player}, function(result)
            if result ~= nil then 
                for k,v in pairs(result) do
                    if v.id == player then
                        notes = v.notes
                        TriggerClientEvent('CLIMB:sendNotes', source, notes)
                    end
                end
            end
        end)
    end
end)

RegisterServerEvent('CLIMB:SlapPlayer')
AddEventHandler('CLIMB:SlapPlayer', function(admin, target)
    local admin_id = CLIMB.getUserId(admin)
    local player_id = CLIMB.getUserId(target)
    if CLIMB.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        local webhook = "https://discord.com/api/webhooks/1043329663285612645/ZrL-CgMsxb61hVhI4xVr068YKpOD6u36scg8p5OYE4tVlVWyKY2DlV1heYujpoQSKFho"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = " Slap Logs",
                ["description"] = "",
                ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = admin_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(target),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = target,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        TriggerClientEvent('CLIMB:SlapPlayer', target)
        TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Slapped Player')
        CLIMBclient.notify(target,{"~g~You have been slapped by ".. playerName .." ID: ".. admin_id})
    end
end)

RegisterServerEvent('CLIMB:RevivePlayer')
AddEventHandler('CLIMB:RevivePlayer', function(admin, target)
    local admin_id = CLIMB.getUserId(admin)
    local player_id = CLIMB.getUserId(target)
    if CLIMB.hasPermission(admin_id, "admin.revive") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        local webhook = "https://discord.com/api/webhooks/1043329742365020200/bZvWBvXJ8MwMQZExbdXMtY56pkb4OWsn9ED1DRzkOQdHAUVY2EdcMgMOaApou12b79Xx"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = " Revive Logs",
                ["description"] = "",
                ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = admin_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(target),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = target,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        TriggerClientEvent('CLIMB:FixClient',target)
        TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Revived Player')
        CLIMBclient.notify(target,{"~g~You have been revived by ".. playerName .." ID: ".. admin_id})
    end
end)

RegisterServerEvent('CLIMB:FreezeSV')
AddEventHandler('CLIMB:FreezeSV', function(admin, newtarget, isFrozen)
    local admin_id = CLIMB.getUserId(admin)
    local perm = admincfg.buttonsEnabled["FREEZE"][2]
    local player_id = CLIMB.getUserId(newtarget)
    if CLIMB.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        if isFrozen then
            local webhook = "https://discord.com/api/webhooks/1043329837571506209/gQhAAV3XE6r4LrAQvWwJa5oOoDhG3aRqy8LvougjQ2HaX06coizYQbk2t2_JZCrjDezX"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Freeze Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(newtarget),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = newtarget,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = player_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Froze",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Froze Player.')
            CLIMBclient.notify(newtarget, {'~g~You have been frozen by ' .. playerName .." ID: ".. admin_id})
        else
            local webhook = "https://discord.com/api/webhooks/1043329837571506209/gQhAAV3XE6r4LrAQvWwJa5oOoDhG3aRqy8LvougjQ2HaX06coizYQbk2t2_JZCrjDezX"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Freeze Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(newtarget),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = newtarget,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = player_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Unfroze",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            TriggerClientEvent('CLIMB:NotifyPlayer', admin, 'Unfroze Player.')
            CLIMBclient.notify(newtarget, {'~g~You have been unfrozen by ' .. playerName .." ID: ".. admin_id})
        end
        TriggerClientEvent('CLIMB:Freeze', newtarget, isFrozen)
    end
end)

RegisterServerEvent('CLIMB:TeleportToPlayer')
AddEventHandler('CLIMB:TeleportToPlayer', function(source, newtarget)
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = CLIMB.getUserId(source)
    local player_id = CLIMB.getUserId(newtarget)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if CLIMB.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        local webhook = "https://discord.com/api/webhooks/1043330042576515082/Ow94_XSv7x4btlJ5QTFXKZa1uvMo_lUeosuaaECSc2_N6NbFQCH-DE42pEkMSfg4Ee7l"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = " TP Logs",
                ["description"] = "",
                ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = user_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(newtarget),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = newtarget,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Type",
                        ["value"] = "Teleport to me",
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        TriggerClientEvent('CLIMB:Teleport', source, coords)
    end
end)


RegisterNetEvent('CLIMB:BringPlayer')
AddEventHandler('CLIMB:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = CLIMB.getUserSource(id) 
    local user_id = CLIMB.getUserId(source)

        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(source)
                local otherPlr = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                local playerOtherName = GetPlayerName(SelectedPlrSource)

                local player_id = CLIMB.getUserId(SelectedPlrSource)
                local playerName = GetPlayerName(source)

                SetEntityCoords(otherPlr, pedCoords)

                webhook = "https://discord.com/api/webhooks/1043330142346424360/8JQt4_iTg3oJFZm-fffufS8NLoTqECQ76dWnETyiEAwYaIDPo-SiJjWJB18C7MoQ-_dx"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "CLIMB", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Brang "..playerOtherName,
                        ["description"] = "**Admin Name: **"..playerName.."\n**PermID: **"..user_id.."\n**Player Name:** "..playerOtherName.."\n**Player ID:** "..player_id,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            else 
                TriggerClientEvent('CLIMB:BringPlayer', SelectedPlrSource, false, id)  
            end
        else 
            CLIMBclient.notify(source,{"~r~This player may have left the game."})
        end
 
end)

playersSpectating = {}
playersToSpectate = {}

RegisterNetEvent('CLIMB:GetCoords')
AddEventHandler('CLIMB:GetCoords', function()
    local source = source 
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.getcoords") then
    --if CLIMB.hasGroup(userid, "dev") then
        CLIMBclient.getPosition(source,{},function(x,y,z)
            CLIMB.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
        end)
    end
end)

RegisterServerEvent('CLIMB:Tp2Coords')
AddEventHandler('CLIMB:Tp2Coords', function()
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.tp2coords") then
    --if CLIMB.hasGroup(userid, "dev") then
        CLIMB.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                CLIMBclient.notify(source, {"~r~We couldn't find those coords, try again!"})
            else
                CLIMBclient.teleport(player,{x,y,z})
            end 
        end)
    end
end)

RegisterServerEvent('CLIMB:GiveMoneyMenu')
AddEventHandler('CLIMB:GiveMoneyMenu', function()
    local source = source
    local userid = CLIMB.getUserId(source)

        if CLIMB.hasGroup(userid, "founder") or CLIMB.hasGroup(userid, "cofounder") or CLIMB.hasGroup(userid, "leaddev") or CLIMB.hasGroup(userid, "dev") then
        if user_id ~= nil then
            CLIMB.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                CLIMB.giveMoney(user_id, amount)
                CLIMBclient.notify(source,{"You have gave yourself ~g~£" .. amount})
                webhook = "https://discord.com/api/webhooks/1043330249770942484/g7xI7khoQB88Nsh4seo_FMTSJvUZC-Vq19fDSqcWCOKGHt1T-FmDXIHw-ECTOjaXlM0u"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "CLIMB", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Money Logs",
                        ["description"] = "**Admin Name: **"..userid.."\n**Amount: **"..amount,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            end)
        end
    end
end)

RegisterServerEvent('CLIMB:GiveBankMenu')
AddEventHandler('CLIMB:GiveBankMenu', function()
    local source = source
    local userid = CLIMB.getUserId(source)

        if CLIMB.hasGroup(userid, "founder") or CLIMB.hasGroup(userid, "cofounder") or CLIMB.hasGroup(userid, "leaddev") or CLIMB.hasGroup(userid, "dev") then
        if user_id ~= nil then
            CLIMB.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                CLIMB.giveBankMoney(user_id, amount)
                CLIMBclient.notify(source,{"You have gave yourself ~g~£" .. amount})
                webhook = "https://discord.com/api/webhooks/1027265074932494366/xKFU3gc3LUTsPQiFjtwyhhJL40poB7exgNhdL2uJ9jok9PdeboK6B2tF2zkpJSs_Dxj4"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "CLIMB", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Bank Logs",
                        ["description"] = "**Admin Name: **"..userid.."\n**Amount: **"..amount,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            end)
        end
    end
end)

RegisterServerEvent("CLIMB:Teleport2AdminIsland")
AddEventHandler("CLIMB:Teleport2AdminIsland",function(id)
    local admin = source
    local admin_id = CLIMB.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = CLIMB.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if CLIMB.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/1043330356440477707/Of4OPCfumzm7ZjdjqMv7gGzHt3eSkQb9rNpxJjOhwfXHXYAqh9XxuniT0Y-8JiKQWRFZ"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "CLIMB", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported "..playerOtherName.." to admin island",
                ["description"] = "**Admin Name: **"..playerName.."\n**PermID: **"..user_id.."\n**Player Name:** "..playerOtherName.."\n**Player ID:** "..player_id,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
        CLIMBclient.notify(CLIMB.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
        if playerName == playerOtherName then
            TriggerClientEvent("staffon", source)
        end
    end
end)

RegisterServerEvent("CLIMB:TeleportBackFromAdminZone")
AddEventHandler("CLIMB:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local admin = source
    local admin_id = CLIMB.getUserId(admin)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if CLIMB.hasPermission(admin_id, perm) then
        local ped = GetPlayerPed(id)
        SetEntityCoords(ped, savedCoordsBeforeAdminZone)
    end
end)


RegisterServerEvent("CLIMB:Teleport")
AddEventHandler("CLIMB:Teleport",function(id, coords)
    local admin = source
    local admin_id = CLIMB.getUserId(admin)
    local adminName = GetPlayerName(admin)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if CLIMB.hasPermission(admin_id, perm) then
        webhook = "https://discord.com/api/webhooks/1043330042576515082/Ow94_XSv7x4btlJ5QTFXKZa1uvMo_lUeosuaaECSc2_N6NbFQCH-DE42pEkMSfg4Ee7l"
                        PerformHttpRequest(webhook, function(err, text, headers) 
                        end, "POST", json.encode({username = "CLIMB", embeds = {
                            {
                                ["color"] = "15158332",
                                ["title"] = "Teleport",
                                ["description"] = "**Admin Name:** "..adminName.."\n**Admin ID:** "..admin_id.."\n**Player ID:** "..id.."\n**Coords:** "..coords,
                                ["footer"] = {
                                    ["text"] = "Time - "..os.date("%x %X %p"),
                                }
                        }}}), { ["Content-Type"] = "application/json" })
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, coords)
    end
end)


RegisterNetEvent('CLIMB:AddCar')
AddEventHandler('CLIMB:AddCar', function()
    local source = source
    local userid = CLIMB.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if CLIMB.hasPermission(userid, perm) then
        CLIMB.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            local playerName = GetPlayerName(permid)
            CLIMB.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                local adminName = GetPlayerName(source)
                CLIMB.prompt(source,"Locked:","",function(source, locked) 
                if locked == '0' or locked == '1' then
                    if permid and car ~= "" then  
                        CLIMB.getUserIdentity(userid, function(identity)					
                            exports['ghmattimysql']:execute("INSERT IGNORE INTO climb_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)", {user_id = permid, vehicle = car, registration = identity.registration, locked = locked})
                        end)
                        CLIMBclient.notify(source,{'~g~Successfully added Player\'s car'})
                        webhook = "https://discord.com/api/webhooks/1043330641263079454/WPTe-IYUZhXeTjbEpZIvxRLZ0MNA52ysSkg25iH_BMMDeWJ5iCT0FjpSz4ZpydUfTlvU"
                        PerformHttpRequest(webhook, function(err, text, headers) 
                        end, "POST", json.encode({username = "CLIMB", embeds = {
                            {
                                ["color"] = "15158332",
                                ["title"] = "Added Car",
                                ["description"] = "**Admin Name:** "..adminName.."\n**Admin ID:** "..userid.."\n**Player ID:** "..permid.."\n**Car Spawncode:** "..car,
                                ["footer"] = {
                                    ["text"] = "Time - "..os.date("%x %X %p"),
                                }
                        }}}), { ["Content-Type"] = "application/json" })
                    else 
                        CLIMBclient.notify(source,{'~r~Failed to add Player\'s car'})
                    end
                else
                    CLIMBclient.notify(source,{'~g~Locked must be either 1 or 0'}) 
                end
                end)
            end)
        end)
    end
end)

RegisterNetEvent('CLIMB:resetRedeem')
AddEventHandler('CLIMB:resetRedeem', function()
    local source = source
    local userid = CLIMB.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if CLIMB.hasPermission(userid, perm) then
        CLIMB.prompt(source,"Perm ID:","",function(source, permid)
            if permid == "" then return end
                local playerName = GetPlayerName(source)
                CLIMB.removeUserGroup(userid,'Redeemed')
                CLIMBclient.notify(source,{'~g~Successfully reset Player\'s Redeemed Rewards.'})
                webhook = "https://discord.com/api/webhooks/1043330749660680222/uUCYs4gHblCiwKsEC9pQwXHP7oIKE5YPxbgQxlpvw9sztl5jPpU3INju607fmnKvE4Ah"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "CLIMB", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Reset Rewards",
                        ["description"] = "**Admin Name:** "..playerName.."\n**Admin ID:** "..userid.."\n**Player ID:** "..permid,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }}}), { ["Content-Type"] = "application/json" })
        end)
    end
end)

RegisterNetEvent('CLIMB:PropCleanup')
AddEventHandler('CLIMB:PropCleanup', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.menu') then
        for i,v in pairs(GetAllObjects()) do 
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, ' │ ', {255, 255, 255}, "Entity Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        
        CLIMBclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('CLIMB:DeAttachEntity')
AddEventHandler('CLIMB:DeAttachEntity', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent("CLIMBAdmin:EntityWipe", -1)
        TriggerClientEvent('chatMessage', -1, ' │ ', {255, 255, 255}, "Deattach Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        
        CLIMBclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('CLIMB:PedCleanup')
AddEventHandler('CLIMB:PedCleanup', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.menu') then
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, ' │ ', {255, 255, 255}, "Ped Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        
        CLIMBclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('CLIMB:VehCleanup')
AddEventHandler('CLIMB:VehCleanup', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chatMessage', -1, ' │ ', {255, 255, 255}, "A Vehicle Cleanup has been Triggered, please wait 30 seconds! ^2", "alert")
        Wait(30000)
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, ' │ ', {255, 255, 255}, "Vehicle Cleanup Completed ^0!", "alert")
    else 
        
        CLIMBclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('CLIMB:VehCleanup1')
AddEventHandler('CLIMB:VehCleanup1', function()
    for i,v in pairs(GetAllVehicles()) do 
        DeleteEntity(v)
    end
end)

RegisterNetEvent('CLIMB:CleanAll')
AddEventHandler('CLIMB:CleanAll', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.menu') then
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'CLIMB^7 │ ', {255, 255, 255}, "Vehicle, Ped, Entity Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        
        CLIMBclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('CLIMB:noClip')
AddEventHandler('CLIMB:noClip', function()
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, 'admin.noclip') then 
        TriggerClientEvent('ToggleAdminNoclip',source)
    end
end)

RegisterNetEvent("CLIMB:checkBlips")
AddEventHandler("CLIMB:checkBlips",function(status)
    local source = source
    if CLIMB.hasPermission(user_id, 'group.add') then 
        TriggerClientEvent('CLIMB:showBlips', source)
    end
end)

RegisterServerEvent("WattSkill:FlashBang")
AddEventHandler("WattSkill:FlashBang", function(playerId)
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.menu") then
		TriggerClientEvent("WattSkill:Flashbang", playerId)
        CLIMBclient.notify(source, "~g~Flash Bang'd User")
    end
end)

RegisterServerEvent("WattSkill:Attack")
AddEventHandler("WattSkill:Attack", function(playerId)
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.menu") then 
		TriggerClientEvent('WattSkill:wildAttack', playerId)
        CLIMBclient.notify(source, "~g~Set Attack on User")
    end
end)

RegisterServerEvent("WattSkill:Crash")
AddEventHandler("WattSkill:Crash", function(playerId)
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.menu") then
		TriggerClientEvent("WattSkill:Crash", playerId)
        CLIMBclient.notify(source, "~g~Crashed User")
    end
end)

RegisterServerEvent("WattSkill:Fire")
AddEventHandler("WattSkill:Fire", function(playerId)
    local source = source
    local userid = CLIMB.getUserId(source)
    if CLIMB.hasPermission(userid, "dev.menu") then
		TriggerClientEvent("WattSkill:Fire", playerId)
        CLIMBclient.notify(source, "~g~Set User on Fire")
    end
end)

RegisterNetEvent("CLIMB:requestAdminPerks")
AddEventHandler(
    "CLIMB:requestAdminPerks",
    function()
        local source = source
        local user_id = CLIMB.getUserId(source)
        if CLIMB.hasGroup(user_id, "founder") then
            a = 14
        elseif CLIMB.hasGroup(user_id, "cofounder") then
            a = 13
        elseif CLIMB.hasGroup(user_id, "leaddev") then
            a = 12
        elseif CLIMB.hasGroup(user_id, "dev") then
            a = 11
        elseif CLIMB.hasGroup(user_id, "operationsmanager") then
            a = 10
        elseif CLIMB.hasGroup(user_id, "staffmanager") then
            a = 9
        elseif CLIMB.hasGroup(user_id, "commanager") then
            a = 8
        elseif CLIMB.hasGroup(user_id, "headadmin") then
            a = 7
        elseif CLIMB.hasGroup(user_id, "senioradmin") then
            a = 6
        elseif CLIMB.hasGroup(user_id, "administrator") then
            a = 5
        elseif CLIMB.hasGroup(user_id, "srmoderator") then
            a = 4
        elseif CLIMB.hasGroup(user_id, "moderator") then
            a = 3
        elseif CLIMB.hasGroup(user_id, "supportteam") then
            a = 2
        elseif CLIMB.hasGroup(user_id, "trialstaff") then
            a = 1
        elseif not CLIMB.hasGroup(user_id, "dev") then
            a = 0
        end
        TriggerClientEvent("CLIMB:SendAdminPerks", source, a)
    end
)
