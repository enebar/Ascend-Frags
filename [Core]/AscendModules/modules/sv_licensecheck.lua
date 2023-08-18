local Tunnel = module('CLIMB','lib/Tunnel')
local Proxy = module('CLIMB','lib/Proxy')
CLIMB = Proxy.getInterface('CLIMB')

--settings-
local DISCORD_URL = "" --your own webhook--
local discordbotname = "Helper" --The username of the bot who sends the message to your discord
local permission = "police.drag" -- the permission you want to be able to access this command
local license = "driver" -- this is the license it wants to check for/ must be set up in groups.lua



RegisterCommand("checklicense", function(source)
    local player = source
    local userid = CLIMB.getUserId({source})
    if CLIMB.hasPermission({userid, permission}) then
        CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
            local target = CLIMB.getUserId({nplayer})
            if target == nil then 
                CLIMBclient.notify(source,{"~d~No Player Nearby"})
            elseif CLIMB.hasGroup({target, license}) then
                CLIMBclient.notify(target,{"Officer is checking your driving license."})
                CLIMBclient.notify(source,{"~g~Driver has license."})
            else
                CLIMBclient.notify(source,{"~d~Driver does not a driving license."})
            end
        end)
    end
end)


 RegisterCommand("removelicense", function(source)
    local player = source 
    local userid = CLIMB.getUserId({source})
    local name = GetPlayerName(source)
    if CLIMB.hasPermission({userid, permission}) then 
        CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
            local target = CLIMB.getUserId({nplayer})
            if target == nil then
                CLIMBclient.notify(source,{"~d~No Player Nearby"})
            elseif CLIMB.hasGroup({target, license}) then 
                CLIMB.removeUserGroup({target,license})
                CLIMB.removeUserGroup({target,"driver"})
                CLIMBclient.notify(source,{"~g~Removed Driving License from ID: " ..target})
                CLIMBclient.notify(target,{"~d~Officer " ..name.. " Has removed your driving license."})
                local command = {
                    {
                        ["color"] = "3944703",
                        ["title"] = " Police Logs",
                        ["description"] = "",
                        ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                        ["fields"] = {
                            {
                                ["name"] = "Officer Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Officer TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Officer PermID",
                                ["value"] = user_id,
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
                                ["value"] = CLIMB.getUserId({target}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "License",
                                ["value"] = license,
                                ["inline"] = true
                            }
                        }
                    }
                }
                local webhook = "https://discord.com/api/webhooks/1059083806306467842/VRFkrnGpNI0-LIuQ4Q1a-mRYaeHQYh88Thvlyxsal-fG7ybNqL-XJM9sB-Uq0UkwOQ12"
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })           
            else
                CLIMBclient.notify(source,{"~d~Driver does not have a driving license."})
            end
        end)
    end
end)

