local cfg = module("CLIMBModules", "cfg/cfg_identitystore")

local MySQL = module("climb_mysql", "MySQL")
local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB")

MySQL.createCommand("CLIMB/set_identity","UPDATE climb_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")

RegisterNetEvent("CLIMB:ChangeIdentity")
AddEventHandler("CLIMB:ChangeIdentity", function(first, second, age)
    local user_id = CLIMB.getUserId({source})

    if user_id ~= nil then
        if CLIMB.tryBankPayment({user_id, cfg.price}) then
            MySQL.execute("CLIMB/set_identity", {user_id = user_id, firstname = first, name = second, age = age})
            CLIMBclient.notifyPicture(source,{"CHAR_FACEBOOK",1,"GOV.UK",false,"You have purchased a new identity!"})
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = " Identity Logs",
                    ["description"] = "",
                    ["text"] = " Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player GOV Name",
                            ["value"] = first,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player GOV LastName",
                            ["value"] = second,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player GOV Age",
                            ["value"] = age,
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/1059083136560025650/Dt0s7Ub2RmDjfgpvPNf2zMxbg_hukGXzA7SAdlHxGT40J2kuFVp3N9ejqLS21S2i9u9D"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })  
        else
            CLIMBclient.notify(source,{"~d~You don't have enough money!"})
        end
    end
end)