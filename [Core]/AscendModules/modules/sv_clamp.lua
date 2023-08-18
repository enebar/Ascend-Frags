-- CLIMB TUNNEL/PROXY
local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB_Clamp")

-- RESOURCE TUNNEL/PROXY
CLIMBClampServer = {}
Tunnel.bindInterface("CLIMB_Clamp",CLIMBClampServer)
Proxy.addInterface("CLIMB_Clamp",CLIMBClampServer)
CLIMBClampClient = Tunnel.getInterface("CLIMB_Clamp","CLIMB_Clamp")


RegisterCommand("clamp", function(source, args, rawCommand)
  local user_id = CLIMB.getUserId({source})
  if CLIMB.hasPermission({user_id,"police.menu"}) then
    CLIMBClampClient.ClampVehicle(source)
  else
    CLIMBclient.notify(source,{"~d~You are not on duty."})
  end
end, false)

function CLIMBClampServer.ChangeVehState(veh, disable)
  print(veh, disable)
  CLIMBClampClient.ChangeVehState(-1, {veh, disable})
end


RegisterServerEvent("CLIMB:ClampVehicle")
AddEventHandler("CLIMB:ClampVehicle", function()
  local user_id = CLIMB.getUserId({source})
  if CLIMB.hasPermission({user_id,"police.menu"}) then
    CLIMBClampClient.ClampVehicle(source)
  else
    CLIMBclient.notify(source,{"~d~You are not on duty."})
  end
end, false)