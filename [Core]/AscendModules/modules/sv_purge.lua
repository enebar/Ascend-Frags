local Tunnel = module('CLIMB', 'lib/Tunnel')
local Proxy = module('CLIMB', 'lib/Proxy')
CLIMB = Proxy.getInterface("CLIMB")

RegisterServerEvent("CLIMB:activatePurgeSV")
AddEventHandler("CLIMB:activatePurgeSV", function(purge)
    local source = source
    local user_id = CLIMB.getUserId({source})
    if CLIMB.hasPermission({user_id, 'dev.menu'}) then
        if purge then
            TriggerClientEvent('CLIMB:activatePurge', source)
        end
    end
end) 


RegisterNetEvent("CLIMB:purgeRespawn")
AddEventHandler("CLIMB:purgeRespawn", function()
    if purge then
        math.randomseed(GetGameTimer())
        randomweapon = math.random(1,#weapons)
        randomcoords = math.random(1,#coords)
        local a = weapons[randomweapon]
        print(weapons[randomweapon])
       tCLIMB.allowWeapon(weapons[randomweapon])
      
        tCLIMB.giveWeapons(weapons[randomweapon], false)
        SetEntityCoords(PlayerPedId(), coords[randomcoords])
    else
        print('Player is cheating')
    end
end)