local sv_police = false

tCLIMB.getInfo = function()
    local user_id = CLIMB.getUserId(source)

    if CLIMB.hasPermission(user_id, "pd.armory") then
        sv_police = true
    else
        sv_police = false
    end


    CLIMBclient.hasPoliceJob(source, {sv_police})
end

tCLIMB.PanicSV = function(s1, s2)
    local src = source

    for i, v in pairs(CLIMB.rusers) do
        local player = CLIMB.getUserSource(tonumber(i))
        local playername = GetPlayerName(src)
        if CLIMB.hasPermission(i, "pd.armory") then
            CLIMBclient.PanicCL(player, {src, s1, s2, playername})
        end
    end
    webhook = "https://discord.com/api/webhooks/1059088475028209685/xY_vCMh-1x0ZQrpegUzg6aUMMJth8uDu-QlNW-wS9ul-Db-KLUGV_CSlSWow_IqFG5EI"
    PerformHttpRequest(webhook, function(err, text, headers) 
    end, "POST", json.encode({username = "Panic Logs", embeds = {
        {
            ["color"] = "15158332",
            ["title"] = "Panic button activated.",
            ["description"] = "**Officer Name:** "..GetPlayerName(src).."**\nOfficer ID:** "..CLIMB.getUserId(src).."**\nStreet:** "..s2,
            ["footer"] = {
                ["text"] = "Time - "..os.date("%x %X %p"),
            }
    }
    }}), { ["Content-Type"] = "application/json" })
end

tCLIMB.BlipSV = function(gx, gy, gz)
    for i, v in pairs(CLIMB.rusers) do
        if CLIMB.hasPermission(i, "pd.armory") then
            CLIMBclient.BlipCL(-1, {gx, gy, gz})
        end
    end
end