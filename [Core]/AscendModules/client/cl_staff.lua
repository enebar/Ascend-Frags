usingDelgun = false
local a = false
local c = function(d)
    local e = {}
    local f = GetGameTimer() / 200
    e.r = math.floor(math.sin(f * d + 0) * 127 + 128)
    e.g = math.floor(math.sin(f * d + 2) * 127 + 128)
    e.b = math.floor(math.sin(f * d + 4) * 127 + 128)
    return e
end
RegisterCommand("delgun",function()
    if tCLIMB.getStaffLevel() > 0 then
        usingDelgun = not usingDelgun
        local g = tCLIMB.getPlayerPed()
        local h = "WEAPON_STAFFGUN"
        if usingDelgun then
            a = HasPedGotWeapon(g, h, false)
            tCLIMB.allowWeapon(h)
            GiveWeaponToPed(g, h, nil, false, true)
            Citizen.CreateThread(function()
                while usingDelgun do
                    Citizen.Wait(0)
                    drawNativeText("~b~Aim ~w~at an object and press ~b~Enter ~w~to delete it. ~r~Have fun!")
                end
            end)
            tCLIMB.drawNativeNotification("Don't forget to use ~b~/delgun ~w~to disable the delete gun!")
        else
            if not a then
                RemoveWeaponFromPed(g, h)
            end
            a = false
        end
    end
end)

RegisterNetEvent("CLIMB:returnObjectDeleted",function(i)
    drawNativeNotification(i)
end)

local j = 0
function func_staffDelGun(k)
    if usingDelgun then
        SetPlayerTargetingMode(2)
        j = j + 1
        if j > 1000 then
            j = 0
        end
        DisableControlAction(1, 18, true)
        DisablePlayerFiring(PlayerId(), true)
        if IsPlayerFreeAiming(PlayerId()) then
            local l, m = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if l then
                local n = GetEntityType(m)
                local o = true
                if o then
                    local p = GetEntityCoords(m)
                    local q = c(0.5)
                    DrawMarker(1,p.x,p.y,p.z - 1.02,0,0,0,0,0,0,0.7,0.7,1.5,q.r,q.g,q.b,200,0,0,2,0,0,0,0)
                    if IsDisabledControlJustPressed(1, 18) then
                        local r = NetworkGetNetworkIdFromEntity(m)
                        TriggerServerEvent("CLIMB:delGunDelete", r)
                        if GetEntityType(m) == 2 then
                            SetEntityAsMissionEntity(m, false, true)
                            DeleteVehicle(m)
                        end
                    end
                end
            end
        end
    end
end
RegisterNetEvent("CLIMB:deletePropClient",function(r)
    local s = tCLIMB.getObjectId(r)
    if DoesEntityExist(s) then
        DeleteEntity(s)
    end
end)
tCLIMB.createThreadOnTick(func_staffDelGun)
local t = {}
function tCLIMB.isLocalPlayerHidden()
    if t[tCLIMB.getUserId()] then
        return true
    else
        return false
    end
end
function tCLIMB.isUserHidden(u)
    if t[u] and tCLIMB.getUserId() ~= u then
        return true
    else
        return false
    end
end
RegisterNetEvent("CLIMB:setHiddenUsers",function(v)
    t = v
end)