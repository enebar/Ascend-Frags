local tickets = {}

local d=0

RegisterCommand('calladmin', function(source)
    local source = source
    local a = GetPlayerName(source)
    local b = CLIMB.getUserId(source)
    local c = GetEntityCoords(GetPlayerPed(source))
    CLIMB.prompt(source,"Reason: ","",function(source,reason)
        if reason ~= "" then
            d=d+1
            tickets[d] = {
                type = "admin",
                permID = b,
                tempID = source
            }
            for k,v in pairs(CLIMB.getUsers({})) do
                TriggerClientEvent("CLIMB:AddCall",v,d,a,b,c,reason,"admin")
            end
        else
            CLIMBclient.notify(source,{"Please enter a reason."})
        end
    end)
end)

RegisterNetEvent("CLIMB:AcceptCall")
AddEventHandler("CLIMB:AcceptCall", function(ticketID)
    local admin_id = CLIMB.getUserId(source)
    local admin = CLIMB.getUserSource(admin_id)
    if tickets[ticketID] ~= nil then
        for k,v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == "admin" and CLIMB.hasPermission(admin_id, "admin.OpenMenu") then
                    if CLIMB.getUserSource(v.permID) ~= nil then
                        if admin_id ~= v.permID then
                            local adminbucket = GetPlayerRoutingBucket(admin)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            if adminbucket ~= playerbucket then
                                SetPlayerRoutingBucket(admin, playerbucket)
                                CLIMBclient.notify(admin, {"~g~You have been sent to bucket ID: "..playerbucket})
                            end
                            CLIMBclient.getPosition(v.tempID, {}, function(x,y,z)
                                CLIMB.giveBankMoney(admin_id, 50000)
                                CLIMBclient.notify(admin,{"~g~You have recived £50,000 for taking an admin ticket.❤️"})
                                CLIMBclient.notify(v.tempID,{"~g~Your admin ticket has been taken!"})
                                CLIMBclient.teleport(admin, {x,y,z})
                                tickets[ticketID] = nil
                                TriggerClientEvent("CLIMB:RemoveCall", -1, ticketID)
                                TriggerClientEvent("CLIMB:StartAdminTicket",admin,true,GetPlayerName(v.tempID),CLIMB.getUserId(v.tempID))
                            end)
                        else
                            CLIMBclient.notify(admin,{"~d~You can't take your own ticket."})
                            TriggerClientEvent("CLIMB:RemoveCall", -1, ticketID)
                        end
                    else
                        CLIMBclient.notify(admin,{"~d~Player is offline."})
                        TriggerClientEvent("CLIMB:RemoveCall", -1, ticketID)
                    end
                else
                    CLIMBclient.notify(admin,{"~d~For some reason you've got perms on the client but not on the server... weird."})
                end
            end
        end
    else
        CLIMBclient.notify(admin,{"~d~Big boi error."})
    end
end)

