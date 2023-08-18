local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")

CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB")

RegisterNetEvent("TFC:saveFaceData")
AddEventHandler("TFC:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = CLIMB.getUserId({source})
    CLIMB.setUData({user_id, "CLIMB:Face:Data", json.encode(faceSaveData)})
    --CLIMBclient.notify(source, {"~g~Your hairstyle has been saved."})

end)

RegisterNetEvent("TFC:changeHairStyle") --COULD BE USED FOR STAFFMODE AND STUFF XOTIIC IF U ARE WONDERING, JUST TRIGGER IT AND ITLL SET THE HARISTYLE, NO PARAMS
AddEventHandler("TFC:changeHairStyle", function()
    local source = source
    local user_id = CLIMB.getUserId({source})

    CLIMB.getUData({user_id, "CLIMB:Face:Data", function(data)
        if data ~= nil then
            TriggerClientEvent("TFC:setHairstyle", source, json.decode(data))
        end
    end})
end)

AddEventHandler("CLIMB:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = CLIMB.getUserId({source})
        CLIMB.getUData({user_id, "CLIMB:Face:Data", function(data)
            if data ~= nil then
                TriggerClientEvent("TFC:setHairstyle", source, json.decode(data))
            end
        end})
    end)
end)