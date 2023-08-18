RegisterNetEvent("CLIMB:openPhone")
AddEventHandler("CLIMB:openPhone", function()
  if GetEntityHealth(PlayerPedId()) <= 102 then return end
  if takePhoto ~= true then
      TogglePhone()
  end
  TriggerEvent('CLIMB:getGarageFolders')
end)

  AddEventHandler("CLIMB:startFixeCall", function(fixeNumber)
    local number = ''
    TriggerEvent("CLIMB:displayOnscreenKeyboard", "FMMC_MPM_NA", "", "", "", "", "", 10)
    while (true) do
        Wait(0)
        local keyboardResult = nil
        TriggerEvent("CLIMB:getOnscreenKeyboardResult", function(result)
            keyboardResult = result
        end)
        if keyboardResult then
            number = keyboardResult
            break
        end
    end
    if number ~= '' then
        TriggerEvent('CLIMB:autoCall', number, {
            useNumber = fixeNumber
        })
        TriggerEvent("CLIMB:phonePlayCall", true)
    end
end)

AddEventHandler("CLIMB:takeAppel", function(infoCall)
  TriggerEvent('CLIMB:autoAcceptCall', infoCall)
end)

RegisterNetEvent("CLIMB:notifyFixePhoneChange")
AddEventHandler("CLIMB:notifyFixePhoneChange", function(_PhoneInCall)
  PhoneInCall = _PhoneInCall
  TriggerClientEvent("CLIMB:notifyFixePhoneChange", -1, PhoneInCall)
end)

-- Register the events to receive data from the client
RegisterNetEvent("CLIMB:startFixeCall")
AddEventHandler("CLIMB:startFixeCall", function(number)
  -- Perform the main action for starting a fixed call
  -- ...
end)

RegisterNetEvent("CLIMB:togglePhone")
AddEventHandler("CLIMB:togglePhone", function()
  -- Perform the main action for toggling the phone
  -- ...
end)

-- Send the data to the client
TriggerEvent("CLIMB:myPhoneNumber", source, myPhoneNumber)
TriggerEvent("CLIMB:contactList", source, contacts)
TriggerEvent("CLIMB:allMessage", source, allmessages)

RegisterNetEvent("CLIMB:addContact")
AddEventHandler("CLIMB:addContact", function(display, num)
-- code to add a contact to the database
end)

RegisterNetEvent("CLIMB:deleteContact")
AddEventHandler("CLIMB:deleteContact", function(num)
-- code to delete a contact from the database
end)

RegisterNetEvent("CLIMB:sendMessage")
AddEventHandler("CLIMB:sendMessage", function(num, message)
-- code to send a message to a recipient
end)

RegisterNetEvent("CLIMB:deleteMessage")
AddEventHandler("CLIMB:deleteMessage", function(msgId)
-- code to delete a message from the database
end)

-- On the client side

-- Function to notify the user about a new message
function notify(msg)
   if not globalHideUi then
      BeginTextCommandThefeedPost("STRING")
      AddTextComponentSubstringPlayerName(msg)
      EndTextCommandThefeedPostTicker(true, false)
   end
end

-- Function to add a contact
function addContact(display, num)
   TriggerEvent('CLIMB:addContact', display, num)
end

-- Function to delete a contact
function deleteContact(num)
   TriggerEvent('CLIMB:deleteContact', num)
end

-- Function to send a message
function sendMessage(num, message)
   TriggerEvent('CLIMB:sendMessage', num, message)
end

-- Function to delete a message
function deleteMessage(msgId)
   print("msgId", msgId)
   TriggerEvent('CLIMB:deleteMessage', msgId)
end

function deleteMessageContact(num)
    TriggerEvent('CLIMB:deleteMessageNumber', num)
  end
  
  function deleteAllMessage()
    TriggerEvent('CLIMB:deleteAllMessage')
  end
  
  function setReadMessageNumber(num)
    TriggerEvent('CLIMB:setReadMessageNumber', num)
  end
  
  function requestAllMessages()
    TriggerEvent('CLIMB:requestAllMessages')
  end
  
  function requestAllContact()
    TriggerEvent('CLIMB:requestAllContact')
  end
  
  local aminCall = false
local inCall = false

RegisterServerEvent("CLIMB:waitingCall")
AddEventHandlerServer("CLIMB:waitingCall", function(infoCall, initiator)
if initiator then
if inCall == false then
inCall = true
SetVoiceChannel(infoCall.id + 1)
SetTalkerProximity(0.0)
end
end
end)

RegisterServerEvent("CLIMB:acceptCall")
AddEventHandlerServer("CLIMB:acceptCall", function(infoCall, initiator)
if inCall == false then
inCall = true
SetVoiceChannel(infoCall.id + 1)
SetTalkerProximity(0.0)
end
end)

RegisterServerEvent("CLIMB:rejectCall")
AddEventHandlerServer("CLIMB:rejectCall", function(infoCall)
if inCall == true then
inCall = false
ClearVoiceChannel()
SetTalkerProximity(2.5)
end
exports["CLIMB"]:playSound("hangup")
end)

RegisterServerEvent("CLIMB:sendCallHistory")
AddEventHandlerServer("CLIMB:sendCallHistory", function(historique)
-- This event does not need to be handled on the server
end)

function startCall (phone_number, rtcOffer, extraData)
    if rtcOffer == nil then
      rtcOffer = ''
    end
    TriggerEvent('CLIMB:startCall', phone_number, rtcOffer, extraData)
  end
  
  function acceptCall (infoCall, rtcAnswer)
    TriggerEvent('CLIMB:acceptCall', infoCall, rtcAnswer)
  end
  
  function rejectCall(infoCall)
    TriggerEvent('CLIMB:rejectCall', infoCall)
  end
  
  function ignoreCall(infoCall)
    TriggerEvent('CLIMB:ignoreCall', infoCall)
  end
  
  function requestHistoriqueCall()
    TriggerEvent('CLIMB:getHistoriqueCall')
  end
  
  function appelsDeleteHistorique (num)
    TriggerEvent('CLIMB:appelsDeleteHistorique', num)
  end
  
  function appelsDeleteAllHistorique ()
    TriggerEvent('CLIMB:appelsDeleteAllHistorique')
  end

  RegisterNUICallback('onCandidates', function (data, cb)
    TriggerEvent('CLIMB:candidates', data.id, data.candidates)
    cb()
  end)
  
  RegisterNetEvent("CLIMB:candidates")
  AddEventHandler("CLIMB:candidates", function(candidates)
    SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
  end)
  
  
  
  RegisterNetEvent('CLIMB:autoCall')
  AddEventHandler('CLIMB:autoCall', function(number, extraData)
    if number ~= nil then
      SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
    end
  end)
  
  RegisterNetEvent('CLIMB:autoCallNumber')
  AddEventHandler('CLIMB:autoCallNumber', function(data)
    TriggerEvent('CLIMB:autoCall', data.number)
  end)
  
  RegisterNetEvent('CLIMB:autoAcceptCall')
  AddEventHandler('CLIMB:autoAcceptCall', function(infoCall)
    SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
  end)
  RegisterNUICallback('log', function(data, cb)
    print(data)
    cb()
  end)
  RegisterNUICallback('focus', function(data, cb)
    cb()
  end)
  RegisterNUICallback('blur', function(data, cb)
    cb()
  end)
  RegisterNUICallback('reponseText', function(data, cb)
      local limit = data.limit or 255
      local text = data.text or ''
      local ask = data.ask or "Enter:"
      exports["CLIMB"]:prompt(ask, text, function(text)
          cb(json.encode({text = text}))
      end)
  end)
  --====================================================================================
  --  Event - Messages
  --====================================================================================
  RegisterNUICallback('getMessages', function(data, cb)
    cb(json.encode(messages))
  end)
  RegisterNUICallback('sendMessage', function(data, cb)
    if data.message == '%pos%' then
      local myPos = GetEntityCoords(PlayerPedId())
      data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
    end
    TriggerEvent('CLIMB:sendMessage', data.phoneNumber, data.message)
  end)
  RegisterNUICallback('deleteMessage', function(data, cb)
    deleteMessage(data.id)
    cb()
  end)
  RegisterNUICallback('deleteMessageNumber', function (data, cb)
    deleteMessageContact(data.number)
    cb()
  end)
  RegisterNUICallback('deleteAllMessage', function (data, cb)
    deleteAllMessage()
    cb()
  end)
  RegisterNUICallback('setReadMessageNumber', function (data, cb)
    setReadMessageNumber(data.number)
    cb()
  end)
  --====================================================================================
  --  Event - Contacts
  --====================================================================================
  RegisterNUICallback('addContact', function(data, cb)
    print(json.encode(data))
    TriggerEvent('CLIMB:addContact', data.display, data.phoneNumber)
  end)
  RegisterNUICallback('updateContact', function(data, cb)
    TriggerEvent('CLIMB:updateContact', data.id, data.display, data.phoneNumber)
  end)
  RegisterNUICallback('deleteContact', function(data, cb)
    TriggerEvent('CLIMB:deleteContact', data.id)
  end)
  RegisterNUICallback('getContacts', function(data, cb)
    cb(json.encode(contacts))
  end)
  RegisterNUICallback('setGPS', function(data, cb)
    SetNewWaypoint(tonumber(data.x), tonumber(data.y))
    cb()
  end)
  
  -- Add security for event (leuit#0100)
  RegisterNUICallback('callEvent', function(data, cb)
    local eventName = data.eventName or ''
    if string.match(eventName, 'gcphone') then
      if data.data ~= nil then
        TriggerEvent(data.eventName, data.data)
      else
        TriggerEvent(data.eventName)
      end
    else
      print('Event not allowed')
    end
    cb()
  end)
  RegisterNUICallback('useMouse', function(um, cb)
    useMouse = um
  end)
  RegisterNUICallback('deleteALL', function(data, cb)
    TriggerEvent('CLIMB:deleteALL')
    cb()
  end)
  
  function TogglePhone(anim)
    if anim == nil then anim = true end
    menuIsOpen = not menuIsOpen
    SendNUIMessage({show = menuIsOpen})
    if menuIsOpen == true then
      if anim then
        PhonePlayIn()
      end
      TriggerEvent('CLIMB:setMenuStatus', true)
    else
      if anim then
        PhonePlayOut()
      end
      TriggerEvent('CLIMB:setMenuStatus', false)
    end
  end
  
  RegisterNUICallback('faketakePhoto', function(data, cb)
      notify("~g~Press UP ARROW to change to selfie mode. ENTER to take picture. BACKSPACE to cancel.")
      CreateMobilePhone(1)
      CellCamActivate(true, true)
      takePhoto = true
      Citizen.Wait(0)
      TogglePhone()
      if hasFocus == true then
        SetNuiFocus(false, false)
        hasFocus = false
      end
      while takePhoto do
        Citizen.Wait(0)
  
        if IsControlJustPressed(1, 27) then -- Toogle Mode
          frontCam = not frontCam
          CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then -- CANCEL
          DestroyMobilePhone()
          CellCamActivate(false, false)
          cb(json.encode({ url = nil }))
          takePhoto = false
          break
        elseif IsControlJustPressed(0, 191) then -- TAKE.. PIC
            print(json.encode(data))
            exports['screenshot-basic']:requestScreenshotUpload('https://cmgstudios.net/upld/upload.php', 'files[]', function(data)
                local resp = json.decode(data)
                DestroyMobilePhone()
                CellCamActivate(false, false)
                exports["CLIMB"]:prompt("CTRL + A, CTRL + C to copy link to image", data)
                cb(json.encode({ url = data }))
                TogglePhone()
                takePhoto = false
            end)
        end
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
      end
      Citizen.Wait(1000)
      PhonePlayAnim('text', false, true)
  end)
  
  RegisterNUICallback('closePhone', function(data, cb)
    menuIsOpen = false
    TriggerEvent('CLIMB:setMenuStatus', false)
    SetNuiFocus(false, false)
    SendNUIMessage({show = false})
    PhonePlayOut()
    SetBigmapActive(0,0)
    cb()
  end)
  
  RegisterNUICallback("setFocus", function(data, cb)
      SetNuiFocus(data.focus)
      cb(json.encode(data.focus))
  end)
  
  
  
  
  ----------------------------------
  ---------- GESTION APPEL ---------
  ----------------------------------
  RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
    appelsDeleteHistorique(data.numero)
    cb()
  end)
  RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
    appelsDeleteAllHistorique(data.infoCall)
    cb()
  end)
  
  
  ----------------------------------
  ---------- GESTION VIA WEBRTC ----
  ----------------------------------
  AddEventHandler('onClientResourceStart', function(res)
    DoScreenFadeIn(300)
    if res == "CLIMBphone" then
      TriggerEvent('CLIMB:allUpdate')
      -- Try again in 2 minutes (Recovers bugged phone numbers)
      Citizen.Wait(120000)
      TriggerEvent('CLIMB:allUpdate')
    end
  end)
  
  
  RegisterNUICallback('setIgnoreFocus', function (data, cb)
    ignoreFocus = data.ignoreFocus
    cb()
  end)
  
  RegisterNUICallback('takePhoto', function(data, cb)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    takePhoto = true
    Citizen.Wait(0)
    if hasFocus == true then
      SetNuiFocus(false, false)
      hasFocus = false
    end
    while takePhoto do
      Citizen.Wait(0)
  
      if IsControlJustPressed(1, 27) then -- Toogle Mode
        frontCam = not frontCam
        CellFrontCamActivate(frontCam)
      elseif IsControlJustPressed(1, 177) then -- CANCEL
        DestroyMobilePhone()
        CellCamActivate(false, false)
        cb(json.encode({ url = nil }))
        takePhoto = false
        break
      elseif IsControlJustPressed(0, 191) then -- TAKE.. PIC
          print(json.encode(data))
          exports['screenshot-basic']:requestScreenshotUpload('https://cmgstudios.net/upld/upload.php', 'files[]', function(data)
              local resp = json.decode(data)
              DestroyMobilePhone()
              CellCamActivate(false, false)
              cb(json.encode({ url = data }))
              takePhoto = false
          end)
      end
      HideHudComponentThisFrame(7)
      HideHudComponentThisFrame(8)
      HideHudComponentThisFrame(9)
      HideHudComponentThisFrame(6)
      HideHudComponentThisFrame(19)
      HideHudAndRadarThisFrame()
    end
    Citizen.Wait(1000)
    PhonePlayAnim('text', false, true)
  end)
  
  RegisterNUICallback("block_number", function(data)
      local number = data.number
      TriggerEvent("CLIMB:blockNumber", number)
  end)
  RegisterNUICallback("unblock_number", function(data)
      local number = data.number
      TriggerEvent("CLIMB:unBlockNumber", number)
  end)
  
  RegisterNetEvent("CLIMB:setVehicleFolders", function(folders)
      SendNUIMessage({
          event = "SetFolders",
          folders = folders or {}
      })
  end)
  
  RegisterNUICallback("valet_spawn", function(data)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local bool, _,  outHeading= GetNthClosestVehicleNode(playerCoords.x,playerCoords.y,playerCoords.z,nil,8,8,8,8,8,8)
    local _, outPos, _ = GetNthClosestVehicleNode(playerCoords.x,playerCoords.y,playerCoords.z,15)
  
    local boolTarget, _,  outHeadingTarget= GetClosestVehicleNodeWithHeading(playerCoords.x,playerCoords.y,playerCoords.z,nil,8,8,8,8,8,8)
    local _, outPosTarget, _ = GetPointOnRoadSide(playerCoords.x,playerCoords.y,playerCoords.z,0.0)
  
    if tostring(outPosTarget) ~= "vector3(0, 0, 0)" and tostring(outPos) ~= "vector3(0, 0, 0)" then
        TriggerEvent("CLIMB:valetSpawnVehicle", data.spawncode)
    else
        notify("~r~No suitable location for valet.")
        TriggerEvent("CLIMB:johnnyCantMakeIt")
    end
  end)
  
  local json_data = [[{
      initiator: false,
      id: 5,
      transmitter_src: 5,
      // transmitter_num: '###-####',
      transmitter_num: '336-4557',
      receiver_src: undefined,
      // receiver_num: '336-4557',
      receiver_num: '###-####',
      is_valid: 0,
      is_accepts: 0,
      hidden: 0
    }]]