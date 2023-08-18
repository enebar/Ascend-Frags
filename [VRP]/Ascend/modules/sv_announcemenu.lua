RegisterNetEvent("CLIMB:buildAnnounceMenu")
AddEventHandler("CLIMB:buildAnnounceMenu", function(i)
    local a = i
    RMenu.Add(
        "CLIMBannouncements",
        "main",
        RageUI.CreateMenu(
            "",
            "~b~Announcement Menu",
            tCLIMB.getRageUIMenuWidth(),
            tCLIMB.getRageUIMenuHeight(),
            "banners",
            "announcement"
        )
    )
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if RageUI.Visible(RMenu:Get("CLIMBannouncements", "main")) then
                RageUI.DrawContent(
                    {header = true, glare = false, instructionalButton = false},
                    function()
                        for b, c in pairs(a) do
                            RageUI.Button(
                                c.name,
                                string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)),
                                {RightLabel = "→→→"},
                                true,
                                function(d, e, f)
                                    if f then
                                        TriggerServerEvent("CLIMB:serviceAnnounce", c.name)
                                    end
                                end
                            )
                        end
                    end
                )
            end
        end
    end)
end)

RegisterNetEvent("CLIMB:serviceAnnounceCl")
AddEventHandler("CLIMB:serviceAnnounceCl", function(g, h)
    tCLIMB.announce(g, h)
end)

RegisterCommand("announcemenu", function()
    TriggerServerEvent("CLIMB:getAnnounceMenu")
end)
