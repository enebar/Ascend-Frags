-- local Tunnel = module('CLIMB', 'lib/Tunnel')
-- local Proxy = module('CLIMB', 'lib/Proxy')
-- CLIMB = Proxy.getInterface("CLIMB")
-- CLIMBclient = Tunnel.getInterface("CLIMB", "PDClockon")

-- RegisterNetEvent("CLIMB:Clockon")
-- AddEventHandler('CLIMB:Clockon', function(group)
--     local source = source
--     userid = CLIMB.getUserId({source})
--     name = GetPlayerName(source)
    
 
--     exports['CLIMBRoles']:isRolePresent(source, {cfgroles.pdRole} , function(hasRole, roles)
--         if hasRole == true then 
--             CLIMB.addUserGroup({userid, group})
--             TriggerClientEvent("CLIMB:NotifyPlayer", source, "You have Clocked on as " ..group)
--             hasPD = true

--         local clockonEmbed = {
--             {
--                 ["color"] = "16777215",
--                 ["title"] = name .. " has clocked on as a " .. group,
--                 ["description"] = "ID: " .. userid .. " / Name: " .. name .. " Clocked on as a **[" .. group .. "]**",
--                 ["footer"] = {
--                   ["text"] = " - "..os.date("%X"),
--                   ["icon_url"] = "https://media.discordapp.net/attachments/1014165521563914311/1038550242116784268/unknown.png",
--                 }
--             }
--         }
--         PerformHttpRequest("https://discord.com/api/webhooks/1059082722989068428/7CSx9dgY4SRrxAdlP4V89iu4fTytfXYvlME2Vn90yh5Im9P3WuiCGgJRzjdIBpm96PKd", function(err, text, headers) end, "POST", json.encode({username = "Clock On Logs", embeds = clockonEmbed}), { ["Content-Type"] = "application/json" })
--     else
--         CLIMBclient.notify(source,{"~d~You do not have permissions to clock on."})
--          end
--     end)
-- end)

-- RegisterNetEvent("removeGroups")
-- AddEventHandler("removeGroups", function()
--     local source = source
--     userid1 = CLIMB.getUserId({source})
--     local ped = GetPlayerPed(source)
--     hasPD = false
--     CLIMB.removeUserGroup({userid1, "Special Constable"})
--     CLIMB.removeUserGroup({userid1, "Commissioner"})
--     CLIMB.removeUserGroup({userid1, "Deputy Commissioner"})
--     CLIMB.removeUserGroup({userid1, "Deputy Assistant Commissioner"})
--     CLIMB.removeUserGroup({userid1, "Commander"})
--     CLIMB.removeUserGroup({userid1, "Chief Superintendent"})
--     CLIMB.removeUserGroup({userid1, "Superintendent"})
--     CLIMB.removeUserGroup({userid1, "ChiefInspector"})
--     CLIMB.removeUserGroup({userid1, "Inspector"})
--     CLIMB.removeUserGroup({userid1, "Sergeant"})
--     CLIMB.removeUserGroup({userid1, "Senior Constable"})
--     CLIMB.removeUserGroup({userid1, "Police Constable"})
--     CLIMB.removeUserGroup({userid1, "PCSO"})


-- end)





