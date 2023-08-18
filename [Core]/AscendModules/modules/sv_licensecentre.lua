local cfg = module("CLIMBModules", "cfg/cfg_licenses")

local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB")

RegisterNetEvent("CLIMB:BuyLicense")
AddEventHandler("CLIMB:BuyLicense", function(name)
    local user_id = CLIMB.getUserId({source})

    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if v.name == name then
                if CLIMB.hasGroup({user_id, v.group}) == false then
                    if v.group == 'AdvancedRebel' and not CLIMB.hasGroup({user_id, 'Rebel'}) then CLIMBclient.notify(source,{"~d~You need to have Rebel License to be able to purchase this."}) return end
                    if CLIMB.tryBankPayment({user_id, v.price}) then
                        CLIMBclient.notify(source,{"~g~Bought "..v.name.." for £"..getMoneyStringFormatted(v.price)})
                        CLIMBclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
                        CLIMB.addUserGroup({user_id, v.group})
                        webhook = "https://discord.com/api/webhooks/1059083806306467842/VRFkrnGpNI0-LIuQ4Q1a-mRYaeHQYh88Thvlyxsal-fG7ybNqL-XJM9sB-Uq0UkwOQ12"
                        PerformHttpRequest(webhook, function(err, text, headers) 
                        end, "POST", json.encode({username = "CLIMB", embeds = {
                            {
                                ["color"] = "15158332",
                                ["title"] = "Purchase",
                                ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..user_id.."\n**Purchased License:** "..v.name.. "\nPrice: " ..v.price,
                                ["footer"] = {
                                    ["text"] = "Time - "..os.date("%x %X %p"),
                                }
                        }}}), { ["Content-Type"] = "application/json" })
                    else
                        CLIMBclient.notify(source,{"~d~You don't have enough money to buy "..v.name})
                        CLIMBclient.playFrontendSound(source,{"Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
                    end
                else
                    CLIMBclient.notify(source,{"~d~You already own "..v.name})
                end
            end
        end
    end
end)

RegisterNetEvent("CLIMB:BuyIllegalLicense")
AddEventHandler("CLIMB:BuyIllegalLicense", function(name)
    local user_id = CLIMB.getUserId({source})

    if user_id ~= nil then
        for k, v in pairs(cfg.illegal) do
            if v.name == name then
                if CLIMB.hasGroup({user_id, v.group}) == false then
                    if v.group == 'AdvancedRebel' and not CLIMB.hasGroup({user_id, 'Rebel'}) then CLIMBclient.notify(source,{"~d~You need to have Rebel License to be able to purchase this."}) return end
                    if CLIMB.tryBankPayment({user_id, v.price}) then
                        CLIMBclient.notify(source,{"~g~Bought "..v.name.." for £"..getMoneyStringFormatted(v.price)})
                        CLIMBclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
                        CLIMB.addUserGroup({user_id, v.group})
                        webhook = "https://discord.com/api/webhooks/1059083806306467842/VRFkrnGpNI0-LIuQ4Q1a-mRYaeHQYh88Thvlyxsal-fG7ybNqL-XJM9sB-Uq0UkwOQ12"
                        PerformHttpRequest(webhook, function(err, text, headers) 
                        end, "POST", json.encode({username = "CLIMB", embeds = {
                            {
                                ["color"] = "15158332",
                                ["title"] = "Purchase",
                                ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..user_id.."\n**Purchased License:** "..v.name.. "\nPrice: " ..v.price,
                                ["footer"] = {
                                    ["text"] = "Time - "..os.date("%x %X %p"),
                                }
                        }}}), { ["Content-Type"] = "application/json" })
                    else
                        CLIMBclient.notify(source,{"~d~You don't have enough money to buy "..v.name})
                        CLIMBclient.playFrontendSound(source,{"Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
                    end
                else
                    CLIMBclient.notify(source,{"~d~You already own "..v.name})
                end
            end
        end
    end
end)

RegisterNetEvent("CLIMB:RemoveLicense")
AddEventHandler("CLIMB:RemoveLicense", function(name)
    local user_id = CLIMB.getUserId({source})

    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if v.name == name then
                if CLIMB.hasGroup({user_id, v.group}) then
                    CLIMB.removeUserGroup({user_id, "HighRoller"})
                    CLIMB.giveBankMoney({user_id, 5000000})
                    CLIMBclient.notify(source,{"~g~Removed "..v.name.." for £5,000,000"})
                    CLIMBclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
                    webhook = "https://discord.com/api/webhooks/1059083806306467842/VRFkrnGpNI0-LIuQ4Q1a-mRYaeHQYh88Thvlyxsal-fG7ybNqL-XJM9sB-Uq0UkwOQ12"
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "CLIMB", embeds = {
                        {
                            ["color"] = "15158332",
                            ["title"] = "Refund",
                            ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..user_id.."\n**Refunded License:** "..v.name,
                            ["footer"] = {
                                ["text"] = "Time - "..os.date("%x %X %p"),
                            }
                    }}}), { ["Content-Type"] = "application/json" })
                else
                    CLIMBclient.notify(source,{"~d~You do not own "..v.name.." License"})
                end
            end
        end
    end
end)
RegisterNetEvent("CLIMB:RemoveLicensecenter")
AddEventHandler("CLIMB:RemoveLicensecenter", function(name)
    local user_id = CLIMB.getUserId({source})

    if user_id ~= nil then
        for k, v in pairs(cfg.refundlicenese) do
            if v.name == name then
                if CLIMB.hasGroup({user_id, v.group}) then
                    CLIMB.removeUserGroup({user_id, v.group })
                    CLIMB.giveBankMoney({user_id, v.refund})
                    CLIMBclient.notify(source,{"~g~Removed "..v.name.." for £"..getMoneyStringFormatted(v.refund)})
                    CLIMBclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
                    webhook = "https://discord.com/api/webhooks/1059083806306467842/VRFkrnGpNI0-LIuQ4Q1a-mRYaeHQYh88Thvlyxsal-fG7ybNqL-XJM9sB-Uq0UkwOQ12"
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "CLIMB", embeds = {
                        {
                            ["color"] = "15158332",
                            ["title"] = "Refunds",
                            ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..user_id.."\n**Refunded License:** "..v.name,
                            ["footer"] = {
                                ["text"] = "Time - "..os.date("%x %X %p"),
                            }
                    }}}), { ["Content-Type"] = "application/json" })
                else
                    CLIMBclient.notify(source,{"~d~You do not own "..v.name.." License"})
                end
            end
        end
    end
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end