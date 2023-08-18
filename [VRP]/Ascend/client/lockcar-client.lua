RegisterCommand('lockcar', function()
    local veh, name, nveh = tCLIMB.getNearestOwnedVehicle(5)
    if veh then 
        tCLIMB.vc_toggleLock(GetHashKey(nveh))
        tCLIMB.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsControlJustReleased(0,  82) then
          ExecuteCommand('lockcar')
      end
      end
  end)