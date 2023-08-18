
--



RegisterServerEvent("CLIMB:InviteUserToGang")
AddEventHandler("CLIMB:InviteUserToGang", function(gangid, playerid)
    local source = source
    playerid = tonumber(playerid)
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local message = "~g~Gang invite received from "..name
    local playersource = CLIMB.getUserSource(playerid)
    if playersource == nil then
        CLIMBclient.notify(source, {"~b~Player is not online."})
        return
    end
    local playername = GetPlayerName(playersource)
    TriggerClientEvent('CLIMB:InviteReceived', playersource, message, gangid)
end)




-- 


RegisterServerEvent("CLIMB:GetGangData")
AddEventHandler("CLIMB:GetGangData", function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    local gangmembers = {}
    local gangpermission
    local ganglogs = {}
    local gangData = {}

    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs', function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            if array[tostring(user_id)] then
                gangData["money"] = math.floor(V.funds)
                gangData["id"] = V.gangname
                gangpermission = tonumber(array[tostring(user_id)].gangPermission)
                ganglogs = json.decode(V.logs)

                local memberIds = {}
                for member_id, memberData in pairs(array) do
                    memberIds[#memberIds + 1] = tonumber(member_id)
                end

                local placeholders = string.rep('?,', #memberIds):sub(1, -2)
                local playerData = exports['ghmattimysql']:executeSync('SELECT * FROM climb_users WHERE id IN (' .. placeholders .. ')', memberIds)
                local userData = exports['ghmattimysql']:executeSync('SELECT * FROM climb_user_data WHERE user_id IN (' .. placeholders .. ')', memberIds)

                for _, playerRow in ipairs(playerData) do
                    local member_id = tonumber(playerRow.id)
                    local gangPermission = array[tostring(member_id)].gangPermission
                    local online = CLIMB.getUserSource(member_id) and 'Online' or playerRow.last_login
                    local playtime = 0

                    for _, userDataRow in ipairs(userData) do
                        if userDataRow.user_id == member_id and userDataRow.dkey == 'CLIMB:datatable' then
                            local data = json.decode(userDataRow.dvalue)
                            playtime = data.PlayerTime or 0
                            playtime = math.ceil(playtime / 60)
                            if playtime < 1 then
                                playtime = 0
                            end
                            break
                        end
                    end

                    table.insert(gangmembers, {playerRow.username, member_id, gangPermission, online, playtime})
                    local emergencyblips = {}
                    TriggerClientEvent('CLIMB:sendFarBlips', -1, emergencyblips) 
                end

                -- Trigger the event for each gang member
                for _, member_id in ipairs(memberIds) do
                    local memberSource = CLIMB.getUserSource(member_id)
                    if memberSource then
                        TriggerClientEvent('CLIMB:GotGangData', memberSource, gangData, gangmembers, gangpermission, ganglogs, 0, false)
                    end
                end

                break
            end
        end
    end)
end)



RegisterServerEvent("CLIMB:newGangPanic")
AddEventHandler("CLIMB:newGangPanic", function(f)
    local source = source
    local user_id = CLIMB.getUserId(source)
    print(source)
    print(user_id)
    print(f)
    if PlayerIsInGang then
        -- Trigger the event for all gang members
        TriggerClientEvent("CLIMB:returnPanic", -1, f)
    end
end)




RegisterServerEvent("CLIMB:CreateGang")
AddEventHandler("CLIMB:CreateGang", function(gangname)
    local source=source
    local user_id=CLIMB.getUserId(source)
    local user_name = GetPlayerName(source)
    local funds = 0 
    local logs = "NOTHING"
    exports['ghmattimysql']:execute('SELECT gangname FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        if not CLIMB.hasGroup(user_id,"Gang") then
            CLIMBclient.notify(source,{"~r~you do not have gang licence."})
            return
        end
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            CLIMBclient.notify(source,{"~b~Gang name is already in use."})
            return
        end
        local gangmembers = {
            [tostring(user_id)] = {
                ["rank"] = 4,
                ["gangPermission"] = 4,
            },
        }
        gangmembers = json.encode(gangmembers)
        CLIMBclient.notify(source,{"~g~"..gangname.." created."})
        exports['ghmattimysql']:execute("INSERT INTO climb_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangname,gangmembers=gangmembers,funds=funds,logs=logs}, function() end)
        TriggerClientEvent('CLIMB:gangNameNotTaken', source)
        TriggerClientEvent('CLIMB:ForceRefreshData', -1)
    end)
end)


RegisterServerEvent("CLIMB:addUserToGang")
AddEventHandler("CLIMB:addUserToGang", function(ganginvite, playerid)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local playersource = CLIMB.getUserSource(source)  -- Use source instead of playerid

    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = ganginvite}, function(G)
        if json.encode(G) == "[]" and G == nil and json.encode(G) == nil then
            CLIMBclient.notify(playersource, {"~b~Gang no longer exists."})
            return
        end

        for K, V in pairs(G) do
            local array = json.decode(V.gangmembers)
            array[tostring(user_id)] = {["rank"] = 1, ["gangPermission"] = 1}
           -- print(array)

            exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {
                gangmembers = json.encode(array),
                gangname = ganginvite
            }, function()
                TriggerClientEvent('CLIMB:ForceRefreshData', -1)
            end)
        end
    end)
end)





function sendToDiscord(webhook, id, gangname, name, action, actionValue, date, avatarUrl, webhookName)
    local embed = {
        title = action,
        color = 15078763, -- Hex color code: d9173b
        footer = {
            text = date,
        },
        description = "**Player**: "..name.." (ID: "..id..")\n"..
                      "**Action**: "..action.."\n"..
                      "**Value**: "..actionValue.."\n"
    }

    local payload = {
        username = "CLIMB " .. webhookName .. " Gang Logs",
        avatar_url = avatarUrl,
        embeds = { embed }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end


function PlayerIsInGang(playerId)
    local user_id = CLIMB.getUserId(playerId)
    local isInGang = false
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs', function(gotGangs)
        for _, gangData in pairs(gotGangs) do
            local gangmembers = json.decode(gangData.gangmembers)
            if gangmembers[tostring(user_id)] then
                PlayerIsInGang = true

                -- Create radio channel for the gang
                local gangName = gangData.gangname
                TriggerClientEvent('CLIMB:CreateRadioChannel', playerId, gangName)

                -- Add all gang members to the radio channel
                for member_id, _ in pairs(gangmembers) do
                    local memberSource = CLIMB.getUserSource(member_id)
                    if memberSource then
                        TriggerClientEvent('CLIMB:AddPlayerToRadioChannel', playerId, memberSource, gangName)
                    end
                end

                break
            end
        end
    end)
    return PlayerIsInGang
end




function addGangLog(name, id, date, action, actionValue)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs', function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I, L in pairs(array) do
                if tostring(id) == I then
                    local ganglogs = {}
                    if V.logs == 'NOTHING' then 
                        ganglogs = {}
                    else
                        ganglogs = json.decode(V.logs)
                    end
                    local gangname = V.gangname
                    table.insert(ganglogs, 1, {name, id, date, action, actionValue})
                    ganglogs = json.encode(ganglogs)
                    exports['ghmattimysql']:execute("UPDATE climb_gangs SET logs = @logs WHERE gangname = @gangname", {logs = ganglogs, gangname = gangname}, function()
                        TriggerClientEvent('CLIMB:ForceRefrshData', -1)
                    end)

                    -- Check if the gang has a webhook set
                    if V.webhook ~= nil then
                        -- Perform the webhook request to log the action
                       -- print(webhook)
                        sendToDiscord(V.webhook, id, gangname, name, action, actionValue, date, "https://media.discordapp.net/attachments/1100048805136695448/1110158585805144105/9f7a20046f99d42578f9af24fb9186f1.png", gangname)
                    end
                    break
                end
            end
        end
    end)
end




RegisterServerEvent("CLIMB:depositGangBalance")
AddEventHandler("CLIMB:depositGangBalance", function(gangname, amount)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        CLIMBclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(CLIMB.getMoney(user_id)) < tonumber(amount) then
                        CLIMBclient.notify(source,{"~r~not enough cash."})
                    else
                        CLIMB.setBankMoney(user_id, (CLIMB.getBankMoney(user_id))-tonumber(amount))
                        CLIMBclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        local newamount = tonumber(amount)+tonumber(funds)
                        local tax = tonumber(amount)*0.01
                        TriggerEvent('CLIMB:addToCommunityPot', math.floor(tax))
                        addGangLog(name, user_id, date, 'Deposited', '£'..getMoneyStringFormatted(amount))
                        exports['ghmattimysql']:execute("UPDATE climb_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                            TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
    TriggerClientEvent('CLIMB:ForceRefreshData', source)
end)


RegisterServerEvent("CLIMB:depositAllGangBalance")
AddEventHandler("CLIMB:depositAllGangBalance", function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local amount = CLIMB.getMoney(user_id)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        CLIMBclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    CLIMB.setMoney(user_id,tonumber(CLIMB.getMoney(user_id))-tonumber(amount))
                    CLIMBclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                    local newamount = tonumber(amount)+tonumber(funds)
                    local tax = tonumber(amount)*0.02
                    addGangLog(name, user_id, date, 'Deposited', '£'..getMoneyStringFormatted(amount))
                    exports['ghmattimysql']:execute("UPDATE climb_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                        TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                    end)
                end
            end
        end
    end)
    TriggerClientEvent('CLIMB:ForceRefreshData', source)
end)

local gangWithdraw = {}
RegisterServerEvent("CLIMB:withdrawGangBalance")
AddEventHandler("CLIMB:withdrawGangBalance", function(amount)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM climb_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        if tonumber(amount) < 0 then
                            CLIMBclient.notify(source,{"~r~Invalid Amount"})
                            return
                        end
                        if tonumber(funds) < tonumber(amount) then
                            CLIMBclient.notify(source,{"~r~Invalid Amount."})
                        else
                            CLIMB.setMoney(user_id,tonumber(CLIMB.getMoney(user_id))+tonumber(amount))
                            CLIMBclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            local newamount = tonumber(funds)-tonumber(amount)
                            addGangLog(name, user_id, date, 'Withdrew', '£'..getMoneyStringFormatted(amount))
                            exports['ghmattimysql']:execute("UPDATE climb_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('CLIMB:ForceRefreshData', source)
end)
RegisterServerEvent("CLIMB:withdrawAllGangBalance")
AddEventHandler("CLIMB:withdrawAllGangBalance", function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM climb_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        local amount = V.funds
                        if tonumber(funds) < 1 then
                            CLIMBclient.notify(source,{"~r~Invalid Amount."})
                        else
                            CLIMB.setMoney(user_id,tonumber(CLIMB.getMoney(user_id))+tonumber(amount))
                            CLIMBclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            addGangLog(name, user_id, date, 'Withdrew', '£'..getMoneyStringFormatted(amount))
                            exports['ghmattimysql']:execute("UPDATE climb_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('CLIMB:ForceRefreshData', source)
end)

RegisterServerEvent("CLIMB:PromoteUser")
AddEventHandler("CLIMB:PromoteUser", function(gangname, memberid)
    local source = source
    local user_id = CLIMB.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= I then
                            CLIMBclient.notify(source, {"~b~Only the leader can promote."})
                            return
                        end
                        if array[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == I then
                            CLIMBclient.notify(source, {"~b~There can only be one leader in each gang."})
                            return
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            CLIMBclient.notify(source, {"~b~You are already the highest rank."})
                            return
                        end
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission) + 1
                        array[tostring(memberid)].rank = tonumber(rank) + 1
                        array = json.encode(array)
                        local name = GetPlayerName(memberid)
                        local date = os.date("%d/%m/%Y at %H:%M:%S")
                        addGangLog(gangname, user_id, date, 'Promoted', 'ID: ' .. memberid)
                        exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = array, gangname = gangname}, function()
                            TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("CLIMB:DemoteUser")
AddEventHandler("CLIMB:DemoteUser", function(gangname, memberid)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank == 4 or gangpermission == 4 then
                            CLIMBclient.notify(source, {"~r~cannot demote the leader"})
                            return
                        end
                        if rank == 1 and gangpermission == 1 then
                            CLIMBclient.notify(source, {"~b~Member is already the lowest rank."})
                            return
                        end
                        array[tostring(memberid)].rank = tonumber(rank) - 1
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission) - 1
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Demoted', 'ID: ' .. memberid)
                        exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = array, gangname = gangname}, function()
                            TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                        end)
                    else
                        CLIMBclient.notify(source, {"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("CLIMB:kickMemberFromGang")
AddEventHandler("CLIMB:kickMemberFromGang", function(gangname, member)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local membersource = CLIMB.getUserSource(member)
    
    if membersource == nil then
        membersource = 0
    end
    
    local membergang = ""
    
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(member)].rank
                    local rank = array[tostring(user_id)].rank
                    
                    if L.rank >= 3 then
                        if tonumber(member) == tonumber(user_id) then
                            CLIMBclient.notify(source, {"~b~You cannot kick yourself!"})
                            return
                        end
                        
                        if tonumber(memberrank) >= rank then
                            CLIMBclient.notify(source, {"~r~you do not have permission to kick this member from the gang."})
                            return
                        end
                        
                        array[tostring(member)] = nil
                        array = json.encode(array)
                        
                        CLIMBclient.notify(source, {"~b~Successfully kicked member from gang"})
                        addGangLog(name, user_id, date, 'Kicked', 'ID: '..member)
                        
                        exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = array, gangname = gangname}, function()
                            TriggerClientEvent('CLIMB:ForceRefreshData', source)
                            
                            if tonumber(membersource) > 0 then
                                CLIMBclient.notify(source, {"~b~You have been kicked from the gang."})
                                TriggerClientEvent('CLIMB:disbandedGang', membersource)
                                TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                            end
                        end)
                    else
                        CLIMBclient.notify(source, {"~r~You do not have permission."})
                    end
                end
            end
        end
    end)
end)





RegisterServerEvent("CLIMB:memberLeaveGang")
AddEventHandler("CLIMB:memberLeaveGang", function(gangname)
    local source = source
    local user_id = CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local membersource = CLIMB.getUserSource(user_id)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(user_id)].rank
                    local rank = array[tostring(user_id)].rank
                    if rank == 4 then
                        CLIMBclient.notify(source,{"~rYou cannot leave the gang because you are the leader!"})
                        return
                    else
                        array[tostring(user_id)] = nil
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Left', 'ID: '..memberid)
                        exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('CLIMB:ForceRefreshData', source)
                            if tonumber(membersource) > 0 then
                                CLIMBclient.notify(source,{"~g~Successfully left gang."})
                                TriggerClientEvent('CLIMB:disbandedGang', membersource)
                                TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("CLIMB:InviteUserToGang")
AddEventHandler("CLIMB:InviteUserToGang", function(gangid,playerid)
    local source = source
    playerid = tonumber(playerid)
    local user_id=CLIMB.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local message = "~g~Gang invite recieved from "..name
    local playersource = CLIMB.getUserSource(playerid)
    if playersource == nil then
        CLIMBclient.notify(source,{"~b~Player is not online."})
        return
    else
        local playername = GetPlayerName(playersource)
        print("Player ID:", playerid)
       -- print("Array:", array)
        addGangLog(name, user_id, date, 'Invited', 'ID: '..user_id)
        TriggerClientEvent('CLIMB:InviteRecieved', playersource,message,gangid)
        CLIMBclient.notify(source,{"~g~Successfully invited " ..playername.." to the gang"})
    end
end)


RegisterServerEvent("CLIMB:DeleteGang")
AddEventHandler("CLIMB:DeleteGang", function(gangid)
    local source=source
    local user_id=CLIMB.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                    exports['ghmattimysql']:execute("DELETE FROM climb_gangs WHERE gangname = @gangname", {gangname = gangid}, function() end)
                    CLIMBclient.notify(source,{"~g~Disbanded "..gangid})
                    TriggerClientEvent('CLIMB:disbandedGang', source)
                    TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                    else
                        CLIMBclient.notify(source,{"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("CLIMB:RenameGang")
AddEventHandler("CLIMB:RenameGang", function(gangid, newname)
    local source = source 
    local user_id=CLIMB.getUserId(source) 
    exports['ghmattimysql']:execute('SELECT gangname FROM climb_gangs WHERE gangname = @gangname', {gangname = newname}, function(gotGangs)
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            CLIMBclient.notify(source,{"~b~Gang name is already in use."})
            return
        end
        exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
            for K,V in pairs(G) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        if L.rank == 4 then
                            exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangname = @newname WHERE gangname = @gangname", {gangname = gangid, newname = newname}, function(gotGangs) end)
                            CLIMBclient.notify(source, {"~g~Renamed gang to "..newname})
                            TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                        else
                            CLIMBclient.notify(source,{"~r~you do not have permission."})
                        end
                    end
                end
            end
        end)
    end)
end)


RegisterServerEvent("CLIMB:SetGangWebhook")
AddEventHandler("CLIMB:SetGangWebhook", function(gangid)
    local source = source 
    local user_id = CLIMB.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangid}, function(G)
        for K, V in pairs(G) do
            local array = json.decode(V.gangmembers) -- Convert the JSON string to a table
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L["rank"] == 4 then  -- Access rank using L["rank"]
                        CLIMB.prompt(source, "Webhook (Enter the webhook here): ", "", function(source, webhook)
                            local pattern = "^https://discord.com/api/webhooks/%d+/%S+$" -- URL pattern to match
                            if webhook ~= nil and string.match(webhook, pattern) then 
                                exports['ghmattimysql']:execute("UPDATE climb_gangs SET webhook = @webhook WHERE gangname = @gangname", {gangname = gangid, webhook = webhook}, function(gotGangs) end)
                                CLIMBclient.notify(source, {"~g~Webhook set."})
                                TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                            else
                                CLIMBclient.notify(source, {"~r~Invalid value."})
                            end
                        end)
                    else
                        CLIMBclient.notify(source, {"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)





RegisterServerEvent("CLIMB:LockGangFunds")
AddEventHandler("CLIMB:LockGangFunds", function(gangname)
    local source = source 
    local user_id=CLIMB.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.encode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                        local fundsLocked = not V.lockedfunds
                        exports['ghmattimysql']:execute("UPDATE climb_gangs SET lockedfunds = @lockedfunds WHERE gangname = @gangname", {gangname = gangid, lockedfunds = fundslocked}, function(gotGangs) end)
                        CLIMBclient.notify(source, {"~g~Funds status changed."})
                        TriggerClientEvent('CLIMB:ForceRefreshData', -1)
                    else
                        CLIMBclient.notify(source,{"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("CLIMB:sendGangMarker")
AddEventHandler("CLIMB:sendGangMarker", function(gangname, coords)
    local source = source 
    local user_id = CLIMB.getUserId(source)
    local markerCreator = GetPlayerName(source)
    local peoplesids = {}
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    for U, D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermissions)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM climb_users', function(gotUser)
                        for J, G in pairs(gotUser) do 
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = CLIMB.getUserSource(tonumber(G.id))
                                if player ~= nil then 
                                    TriggerClientEvent('CLIMB:drawGangMarker', player, markerCreator, coords)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)




                            
RegisterServerEvent("CLIMB:applyGangFit")
AddEventHandler("CLIMB:applyGangFit", function(gangname)
    local source = source
    local user_id = CLIMB.getUserId(source)
    
exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
    for K, V in pairs(gotGangs) do
        local decodedArray = json.decode(V.gangmembers)
        if type(decodedArray) == "table" then
            for I, L in pairs(decodedArray) do
                if tostring(user_id) == I then
                    if V.gangfit ~= nil then
                        CLIMBclient.setCustomization(source, {json.decode(V.gangfit)})

                        -- Update facedata and hairstyle
                        local user_id = CLIMB.getUserId(source)
                        CLIMB.getUData(user_id, "CLIMB:Face:Data", function(data)
                            if data ~= nil and data ~= 0 then
                                TriggerClientEvent("CLIMB:setHairstyle", source, json.decode(data))
                            end
                        end) -- Added closing parenthesis and callback function
                    else
                        CLIMBclient.notify(source, {"~b~Gang does not have an outfit set."})
                    end
                    break
                end
            end
        end
    end
end)

end)




RegisterServerEvent("CLIMB:setGangFit")
AddEventHandler("CLIMB:setGangFit", function(gangid)
    local source = source
    local user_id = CLIMB.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname', {gangname = gangid}, function(gotGangs)
        for K, V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                        CLIMBclient.getCustomization(source, {}, function(custom)
                            local gangfitJSON = json.encode(custom)
                            exports['ghmattimysql']:execute("UPDATE climb_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangname = gangid, gangfit = gangfitJSON}, function(updatedGangs)
                                -- Handle the update completion if needed
                            end)
                            CLIMBclient.notify(source, {"~g~Gang outfit set."})
                        end)
                    else
                        CLIMBclient.notify(source, {"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)




 AddEventHandler("CLIMB:playerSpawn", function(user_id, source) -- Refresh GANG Data on playerspawn
        TriggerClientEvent('CLIMB:ForceRefreshData', -1)
 end)
-- 

RegisterServerEvent("CLIMB:getGangHealthTable")
AddEventHandler("CLIMB:getGangHealthTable", function(gangid)
    local ac = {}
    exports['ghmattimysql']:execute('SELECT * FROM climb_gangs WHERE gangname = @gangname',{gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers) -- Convert JSON string to table
            for I,L in pairs(array) do
                local ax = tonumber(I)
                local aw = CLIMB.getUserSource(ax)
                if aw ~= nil then
                    local ay = GetPlayerPed(aw)
                    ac[ax] = {au = GetEntityHealth(ay), av = GetPedArmour(ay)}
                end
            end
        end
        
        -- Move the code inside the callback function
        TriggerClientEvent('CLIMB:sendGangHPStats', -1, ac)
      --  print("Health stats have been sent to the client")
        -- Print values inside the callback function
      --  for ax, data in pairs(ac) do
        --    print("Player Perm ID", ax)
        --    print("Health", data.au)
         --  print("HP Stats", ac)
      --  end
    end)

    Citizen.Wait(5000)
end)
