local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")

local usersInTruckJob = {}

RegisterNetEvent('CLIMB:startTruckJob')
AddEventHandler('CLIMB:startTruckJob', function()
    local source = source
    local user_id = CLIMB.getUserId({source})
    if user_id ~= nil then
        if not usersInTruckJob[user_id] then
            usersInTruckJob[user_id] = true
        else
            CLIMBclient.notify(source, {"~d~You're already in a job!"})
        end
    end
    print(usersInTruckJob)
end)

RegisterNetEvent('CLIMB:finishTruckJob')
AddEventHandler('CLIMB:finishTruckJob', function(jobname)
    local source = source
    local user_id = CLIMB.getUserId({source})
    if user_id ~= nil then
        if usersInTruckJob[user_id] then
            usersInTruckJob[user_id] = false
            for k, v in pairs(truckjob.locations) do 
                if v.name == jobname then
                    CLIMB.giveBankMoney({user_id, v.pay})
                end
            end
        else
            CLIMBclient.notify(source, {"~d~You're not in a job!"})
        end
    end
    print(usersInTruckJob)
end)