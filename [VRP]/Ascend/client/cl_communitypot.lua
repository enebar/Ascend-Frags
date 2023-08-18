local a = "0"
RMenu.Add(
    "CLIMBcommunitypot",
    "mainmenu",
    RageUI.CreateMenu("", "", 1300, 100, "CLIMB_atmui", "CLIMB_atmui")
)
RMenu:Get("CLIMBcommunitypot", "mainmenu"):SetSubtitle("~b~Community Pot")
local function b()
    AddTextEntry("FMMC_MPM_NA", "Enter amount")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local c = GetOnscreenKeyboardResult()
        if c then
            return c
        end
    end
    return false
end
RegisterNetEvent(
    "CLIMB:gotCommunityPotAmount",
    function(d)
        a = tostring(d)
    end
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("CLIMBcommunitypot", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("CLIMBcommunitypot", "mainmenu"),
            true,
            false,
            true,
            function()
                RageUI.Separator("Community Pot Balance: ~g~£" .. getMoneyStringFormatted(a))
                RageUI.ButtonWithStyle(
                    "Deposit",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            local d = b()
                            if tonumber(d) then
                                TriggerServerEvent("CLIMB:tryDepositCommunityPot", d)
                            else
                                tCLIMB.notify("~r~Invalid amount.")
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Withdraw",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            local d = b()
                            if tonumber(d) then
                                TriggerServerEvent("CLIMB:tryWithdrawCommunityPot", d)
                            else
                                tCLIMB.notify("~r~Invalid amount.")
                            end
                        end
                    end
                )
            end,
            function()
            end
        )
    end
)
