SetDiscordAppId()

local UserID = 0
local PlayerCount = 0





RegisterNetEvent('CLIMB:StartGetPlayersLoopCL')
AddEventHandler('CLIMB:StartGetPlayersLoopCL', function()
    StartLoop()
end)

RegisterNetEvent('CLIMB:ReturnGetPlayersLoopCL')
AddEventHandler('CLIMB:ReturnGetPlayersLoopCL', function(UserID, PlayerCount)
    UserID = UserID
    PlayerCount = PlayerCount
    SetRichPresence("[ID: "..UserID.."] | "..PlayerCount.." / 64")
end)

function StartLoop()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            TriggerServerEvent("CLIMB:StartGetPlayersLoopSV")
        end
    end)
end