-- local cfg = module("cfg/gangfunds")
-- local inGangFunds = false
-- local hasGangLicense = false
-- gangfunds = 0

-- RegisterNetEvent("CLIMB:sendGangFunds")
-- AddEventHandler("CLIMB:sendGangFunds",function(funds)
--     gangfunds = funds
-- end)


-- RMenu.Add('CLIMBGangFunds', 'main', RageUI.CreateMenu("Gang Funds", "~d~Gang Funds", GetRageUIMenuWidth(),GetRageUIMenuHeight())
-- RageUI.CreateWhile(1.0, true, function()
--     if RageUI.Visible(RMenu:Get('CLIMBGangFunds', 'main')) then
--         RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
--             RageUI.Separator('~g~£'..getMoneyStringFormatted(gangfunds))
--             RageUI.ButtonWithStyle("Deposit", "", {}, true, function(Hovered, Active, Selected) 
--                 if Selected then 
--                     local ped = GetPlayerPed(-1)
--                     AddTextEntry('FMMC_MPM_NC', "Enter Amount to Deposit")
--                     DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
--                     while (UpdateOnscreenKeyboard() == 0) do
--                         DisableAllControlActions(0);
--                         Wait(0);
--                     end
--                     if (GetOnscreenKeyboardResult()) then
--                         local result = GetOnscreenKeyboardResult()
--                         if tonumber(result) > 1 then 
--                             result = tonumber(result)
--                             TriggerServerEvent('GangFunds:deposit', result)
--                             Wait(60)
--                             ClearPedTasks(ped)
--                         end
--                     end
--                 end
--             end)
--             RageUI.ButtonWithStyle("Withdraw", "", {}, true, function(Hovered, Active, Selected) 
--                 local ped = GetPlayerPed(-1)
--                 if Selected then 
--                     AddTextEntry('FMMC_MPM_NC', "Enter Amount to Withdraw")
--                     DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
--                     while (UpdateOnscreenKeyboard() == 0) do
--                         DisableAllControlActions(0);
--                         Wait(0);
--                     end
--                     if (GetOnscreenKeyboardResult()) then
--                         local result = GetOnscreenKeyboardResult()
--                         if tonumber(result) > 1 then 
--                             result = tonumber(result)
--                             TriggerServerEvent('GangFunds:withdraw', result)
--                             Wait(60)
--                             ClearPedTasks(ped)
--                         end
--                     end
--                 end
--             end)
--         end)
--     end
-- end)



-- Citizen.CreateThread(function() 
--     while true do
--         Citizen.Wait(0)
--         for k,v in pairs(cfg.gangfunds) do
--             if isInArea(v, 1.4) and inGangFunds == false then 
--                 alert("Press ~INPUT_VEH_HORN~ to access ~d~Gang Funds")
--                 if IsControlJustPressed(0, 51) then 
--                     TriggerServerEvent('CLIMB:getGangFunds')
--                     RageUI.Visible(RMenu:Get('CLIMBGangFunds', 'main'), true) 
--                     inGangFunds = true
--                     currentAmmunition = k 
--                 end
--             end
    
--             if isInArea(v, 1.4) == false and inGangFunds and k == currentAmmunition then
--                 RageUI.Visible(RMenu:Get('CLIMBGangFunds', 'main'), false) 
--                 inGangFunds = false
--                 currentAmmunition = nil
--             end
--         end
--     end
-- end)

-- function isInArea(v, dis) 
--     if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
--         return true
--     else 
--         return false
--     end
-- end

-- function alert(msg) 
--     SetTextComponentFormat("STRING")
--     AddTextComponentString(msg)
--     DisplayHelpTextFromStringLabel(0,0,1,-1)
-- end

-- function getMoneyStringFormatted(cashString)
-- 	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
-- 	int = int:reverse():gsub("(%d%d%d)", "%1,")
-- 	return minus .. int:reverse():gsub("^,", "") .. fraction 
-- end
