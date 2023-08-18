RegisterNetEvent('whoIs')
AddEventHandler('whoIs', function(vehicle, price)
    local user_id = CLIMB.getUserId(source)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = CLIMB.getUserId(source)
    local playerName = GetPlayerName(source)   


 
        MySQL.query("CLIMB/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
            if #pvehicle > 0 then
                CLIMBclient.notify(player,{"~d~Vehicle already owned."})
            else

                if CLIMB.tryFullPayment(user_id, price) then
                CLIMB.getUserIdentity(user_id, function(identity)
                    MySQL.execute("CLIMB/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = identity.registration})
                    webhook = "https://discord.com/api/webhooks/1059088844483473518/1wYTvpcbLFUN4AYk8grpm8flAOTawwBztBRYtgYI9kQRSDXv09htxTP7-q4FhkuF4Q33"
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "CLIMB", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Simeons Purchase",
                        ["description"] = "**Player Name:** "..playerName.."\n**PermID:** "..user_id.."\n**Car Spawncode:** "..vehicle.."\n**Price Paid:** £"..tostring(price),
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                        }
                    }}), { ["Content-Type"] = "application/json" })
                end)

                    CLIMBclient.notify(player,{"You paid ~d~£"..price.."~w~."})
                    TriggerClientEvent("CLIMB:PlaySound", player, 1)
                    
                else
                    CLIMBclient.notify(player,{"~d~Not enough money."})
                    TriggerClientEvent("CLIMB:PlaySound", player, 2)
                end
            end
        end)
   
end)