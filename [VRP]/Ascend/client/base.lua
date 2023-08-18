cfg = module("cfg/client")
cfgweapons = module("CLIMBWeapons", "cfg/cfg_weaponNames")
local user_id = 0
tCLIMB = {}
allowedWeapons = {}
local players = {} -- keep track of connected players (server id)

-- bind client tunnel interface
Tunnel.bindInterface("CLIMB",tCLIMB)

-- get server interface
CLIMBserver = Tunnel.getInterface("CLIMB","CLIMB")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("CLIMB",tCLIMB)



-- anti cheat shite for giveweapontoped cancelling stuff


function tCLIMB.allowWeapon(name)
  if allowedWeapons[name] then
  else
    allowedWeapons[name] = true
  end
end

function tCLIMB.removeWeapon(name)
  if allowedWeapons[name] then
    allowedWeapons[name] = nil
  end
end

function tCLIMB.ClearWeapons()
  allowedWeapons = {}
end


function tCLIMB.checkWeapon(name)
  if allowedWeapons[name] == nil then
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(name))
    print("Tried to spawn "..name)
    return
  end
end




Citizen.CreateThread(function()
  while true do 
    Wait(300)
    for k,v in pairs(cfgweapons.weaponNames) do 
      if GetHashKey(k) then
        if HasPedGotWeapon(PlayerPedId(),GetHashKey(k),false) then   
          tCLIMB.checkWeapon(k)
        end
      end
    end
  end
end)



-- functions
function tCLIMB.teleport(x,y,z)
  tCLIMB.unjail() -- force unjail before a teleportation
  SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
  CLIMBserver.updatePos({x,y,z})
end

-- return x,y,z
function tCLIMB.getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

--returns the distance between 2 coordinates (x,y,z) and (x2,y2,z2)
function tCLIMB.getDistanceBetweenCoords(x,y,z,x2,y2,z2)

-- local distance = GetDistanceBetweenCoords(x,y,z,x2,y2,z2, true)
local distance = #(vec(x, y, z) - vector3(x2, y2, z2)) 
  
  return distance
end

-- return false if in exterior, true if inside a building
function tCLIMB.isInside()
  local x,y,z = tCLIMB.getPosition()
  return not (GetInteriorAtCoords(x,y,z) == 0)
end

-- return vx,vy,vz
function tCLIMB.getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(GetPlayerPed(-1)))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function tCLIMB.getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function tCLIMB.addPlayer(player)
  players[player] = true
end

function tCLIMB.removePlayer(player)
  players[player] = nil
end

function tCLIMB.getNearestPlayers(radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = tCLIMB.getPosition()

  --[[
  for i=0,GetNumberOfPlayers()-1 do
    if i ~= pid then
      local oped = GetPlayerPed(i)

      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(i)] = distance
      end
    end
  end
  --]]

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tCLIMB.getNearestPlayer(radius)
  local p = nil

  local players = tCLIMB.getNearestPlayers(radius)
  local min = radius+10.0
  for k,v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end

  return p
end

function tCLIMB.notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true, false)
end

function tCLIMB.notifyPicture(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tCLIMB.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tCLIMB.stopScreenEffect(name)
  StopScreenEffect(name)
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)

function tCLIMB.playAnim(upper, seq, looping)
  if seq.task ~= nil then -- is a task (cf https://github.com/ImagicTheCat/CLIMB/pull/118)
    tCLIMB.stopAnim(true)

    local ped = GetPlayerPed(-1)
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x,y,z = tCLIMB.getPosition()
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tCLIMB.stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(GetPlayerPed(-1),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(GetPlayerPed(-1),dict,name) <= 0.95 and IsEntityPlayingAnim(GetPlayerPed(-1),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tCLIMB.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(GetPlayerPed(-1))
  else
    ClearPedTasks(GetPlayerPed(-1))
  end
end

-- RAGDOLL
local ragdoll = false

-- set player ragdoll flag (true or false)
function tCLIMB.setRagdoll(flag)
  ragdoll = flag
end

-- ragdoll thread
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if ragdoll then
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)
-- SOUND
-- some lists: 
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tCLIMB.playSpatializedSound(dict,name,x,y,z,range)
  PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function tCLIMB.playSound(dict,name)
  PlaySound(-1,name,dict,0,0,1)
end

--[[
-- not working
function tCLIMB.setMovement(dict)
  if dict then
    SetPedMovementClipset(GetPlayerPed(-1),dict,true)
  else
    ResetPedMovementClipset(GetPlayerPed(-1),true)
  end
end
--]]

-- events

AddEventHandler("playerSpawned",function()
  TriggerServerEvent("CLIMBcli:playerSpawned")
  TriggerServerEvent("CLIMB:gettingUserID")
  TriggerServerEvent("CLIMB:PoliceCheck")
  TriggerServerEvent("CLIMB:RebelCheck")
  TriggerServerEvent("CLIMB:VIPCheck")
  TriggerServerEvent("CLIMB:getHouses")
end)

AddEventHandler("playerSpawned",function()
  TriggerEvent("CLIMB:UnFreezeRespawn")
end)

AddEventHandler("onPlayerDied",function(player,reason)
  TriggerServerEvent("CLIMBcli:playerDied")
end)

AddEventHandler("onPlayerKilled",function(player,killer,reason)
  TriggerServerEvent("CLIMBcli:playerDied")
end)

TriggerServerEvent('CLIMB:CheckID')

RegisterNetEvent('CLIMB:CheckIdRegister')
AddEventHandler('CLIMB:CheckIdRegister', function()
    TriggerEvent('playerSpawned', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent("CLIMB:setUserID")
AddEventHandler("CLIMB:setUserID", function(serverid)
  user_id = serverid
end)

local developers = {
  [1] = true,
  [2] = true,
}
local grind = {
  [1] = true,
  [2] = true,
}
function tCLIMB.isGrinder(user_id) 
  return grind[user_id] or false
end

function tCLIMB.isDeveloper(user_id) 
  return developers[user_id] or false
end

function tCLIMB.getUserId(val)
  if val==nil then
    return user_id
  end
end

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tCLIMB.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tCLIMB.stopScreenEffect(name)
  StopScreenEffect(name)
end

local Q={}
local R={}
function tCLIMB.createArea(l,W,T,U,X,Y,Z,_)
  local V={position=W,radius=T,height=U,enterArea=X,leaveArea=Y,onTickArea=Z,metaData=_}
  if V.height==nil then 
      V.height=6 
  end
  Q[l]=V
  R[l]=V 
end
function tCLIMB.doesAreaExist(l)
  if Q[l] then
      return true
  end
  return false
end

function DrawText3D(a, b, c, d, e, f, g)
  local h, i, j = GetScreenCoordFromWorldCoord(a, b, c)
  if h then
      SetTextScale(0.4, 0.4)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      BeginTextCommandDisplayText("STRING")
      SetTextCentre(1)
      AddTextComponentSubstringPlayerName(d)
      EndTextCommandDisplayText(i, j)
  end
end
function tCLIMB.add3DTextForCoord(d, a, b, c, k)
  local function l(m)
      DrawText3D(m.coords.x, m.coords.y, m.coords.z, m.text)
  end
  local n = tCLIMB.generateUUID("3dtext", 8, "alphanumeric")
  tCLIMB.createArea("3dtext_" .. n,vector3(a, b, c),k,6.0,function()
  end,
  function()
  end,l,{coords = vector3(a, b, c), text = d})
end

Citizen.CreateThread(function()
  while true do
    SetVehicleDensityMultiplierThisFrame(0.0)
    SetPedDensityMultiplierThisFrame(0.0)
    SetRandomVehicleDensityMultiplierThisFrame(0.0)
    SetParkedVehicleDensityMultiplierThisFrame(0.0)
    SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed) 
    RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
    SetGarbageTrucks(0)
    SetRandomBoats(0)
    Citizen.Wait(1)
  end
end)

function tCLIMB.drawTxt(L, M, N, D, E, O, P, Q, R, S)
  SetTextFont(M)
  SetTextProportional(0)
  SetTextScale(O, O)
  SetTextColour(P, Q, R, S)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(N)
  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(L)
  EndTextCommandDisplayText(D, E)
end

function drawNativeText(V)
  if not globalHideUi then
      BeginTextCommandPrint("STRING")
      AddTextComponentSubstringPlayerName(V)
      EndTextCommandPrint(100, 1)
  end
end

function clearNativeText()
  BeginTextCommandPrint("STRING")
  AddTextComponentSubstringPlayerName("")
  EndTextCommandPrint(1, true)
end


function tCLIMB.announceClient(d)
    if d~=nil then 
        CreateThread(function()
            local e=GetGameTimer()
            local scaleform=RequestScaleformMovie('MIDSIZED_MESSAGE')
            while not HasScaleformMovieLoaded(scaleform)do 
                Wait(0)
            end
            PushScaleformMovieFunction(scaleform,"SHOW_SHARD_MIDSIZED_MESSAGE")
            PushScaleformMovieFunctionParameterString("~g~CLIMB Announcement")
            PushScaleformMovieFunctionParameterString(d)
            PushScaleformMovieMethodParameterInt(5)
            PushScaleformMovieMethodParameterBool(true)
            PushScaleformMovieMethodParameterBool(false)
            EndScaleformMovieMethod()
            while e+6*1000>GetGameTimer()do 
                DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
                Wait(0)
            end 
        end)
    end 
end


local UUIDs = {}

local uuidTypes = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789",
}

local function randIntKey(length,type)
    local index, pw, rnd = 0, "", 0
    local chars = {
        uuidTypes[type]
    }
    repeat
        index = index + 1
        rnd = math.random(chars[index]:len())
        if math.random(2) == 1 then
            pw = pw .. chars[index]:sub(rnd, rnd)
        else
            pw = chars[index]:sub(rnd, rnd) .. pw
        end
        index = index % #chars
    until pw:len() >= length
    return pw
end

function tCLIMB.generateUUID(key,length,type)
    if UUIDs[key] == nil then
        UUIDs[key] = {}
    end

    if type == nil then type = "alphanumeric" end

    local uuid = randIntKey(length,type)
    if UUIDs[key][uuid] then
        while UUIDs[key][uuid] ~= nil do
            uuid = randIntKey(length,type)
            Wait(0)
        end
    end
    UUIDs[key][uuid] = true
    return uuid
end


function tCLIMB.spawnVehicle(W,v,w,H,X,Y,Z,_)
  local a0=tCLIMB.loadModel(W)
  local a1=CreateVehicle(a0,v,w,H,X,Z,_)
  SetModelAsNoLongerNeeded(a0)
  SetEntityAsMissionEntity(a1)
  DecorSetInt(a1, "CLIMBACVeh", 955)
  SetModelAsNoLongerNeeded(a0)
  if Y then 
      TaskWarpPedIntoVehicle(PlayerPedId(),a1,-1)
  end
  setVehicleFuel(a1, 100)
  return a1 
end

local a2={}
Citizen.CreateThread(function()
    while true do 
        local b2={}
        b2.playerPed=tCLIMB.getPlayerPed()
        b2.playerCoords=tCLIMB.getPlayerCoords()
        b2.playerId=tCLIMB.getPlayerId()
        b2.vehicle=tCLIMB.getPlayerVehicle()
        b2.weapon=GetSelectedPedWeapon(b2.playerPed)
        for c2=1,#a2 do 
            local d2=a2[c2]
            d2(b2)
        end
        Wait(0)
    end 
end)
function tCLIMB.createThreadOnTick(d2)
    a2[#a2+1]=d2
end

local a = 0
local b = 0
local c = 0
local d = vector3(0, 0, 0)
local e = false
local f = PlayerPedId
function savePlayerInfo()
    a = f()
    b = GetVehiclePedIsIn(a, false)
    c = PlayerId()
    d = GetEntityCoords(a)
    local g = GetPedInVehicleSeat(b, -1)
    e = g == a
end
_G["PlayerPedId"] = function()
    return a
end
function tCLIMB.getPlayerPed()
    return a
end
function tCLIMB.getPlayerVehicle()
    return b, e
end
function tCLIMB.getPlayerId()
    return c
end
function tCLIMB.getPlayerCoords()
    return d
end

createThreadOnTick(savePlayerInfo)

function tCLIMB.getClosestVehicle(bm)
  local br = tCLIMB.getPlayerCoords()
  local bs = 100
  local bt = 100
  for T, bu in pairs(GetGamePool("CVehicle")) do
      local bv = GetEntityCoords(bu)
      local bw = #(br - bv)
      if bw < bt then
          bt = bw
          bs = bu
      end
  end
  if bt <= bm then
      return bs
  else
      return nil
  end
end