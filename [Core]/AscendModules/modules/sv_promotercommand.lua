RegisterNetEvent('Promoter:RedeemRewards')
AddEventHandler('Promoter:RedeemRewards', function(claimedRewards)
    local source = source
    local user_id = CLIMB.getUserId({source})
    local playerName = GetPlayerName(source)
    if claimedRewards and not CLIMB.hasGroup({user_id, 'Redeemed'}) then 
        newbank = CLIMB.getBankMoney({user_id})+500000
        CLIMB.setBankMoney({user_id,newbank})
        CLIMB.addUserGroup({user_id, 'Redeemed'})
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = " Promoter Logs",
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
                        ["name"] = "Redeemed",
                        ["value"] = "true",
                        ["inline"] = true
                    }
                }
            }
        }
        local webhook = "https://discord.com/api/webhooks/1059084121172885515/dwjjEbTHuvcqxmrWm8iTqk8FZGqtWH0Un4-YnGeNFQp9Ryw9gns2XE5VHviH4lAQ4b31"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "CLIMB", embeds = command}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent("Promoter:checkRewardsRole")
AddEventHandler("Promoter:checkRewardsRole", function()
    local source = source
    local user_id = CLIMB.getUserId({source})
    exports['CLIMB-Roles']:isRolePresent(source, {cfgroles.promoterRole}, function(hasRole, roles)
        if (not roles) then 
            TriggerClientEvent("Promoter:NoGuild", source)
        end
        if hasRole == true then
            if not CLIMB.hasGroup({user_id, 'Redeemed'}) then
                TriggerClientEvent('Promoter:Client', source)
            else
                CLIMBclient.notify(source, {'~d~You have already claimed your rewards!'})
            end
        else
            CLIMBclient.notify(source, {'~d~You do not currently have https://dsc.gg/climbroleplay in your status.'})
        end
    end)
end)


