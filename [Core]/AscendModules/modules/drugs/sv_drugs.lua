-- CLIMB TUNNEL/PROXY
Tunnel = module("CLIMB", "lib/Tunnel")
Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB_cfgdrugs")

-- RESOURCE TUNNEL/PROXY
CLIMBcfgdrugsServer = {}
Tunnel.bindInterface("CLIMB_cfgdrugs",CLIMBcfgdrugsServer)
Proxy.addInterface("CLIMB_cfgdrugs",CLIMBcfgdrugsServer)
CLIMBcfgdrugsClient = Tunnel.getInterface("CLIMB_cfgdrugs","CLIMB_cfgdrugs")

function CLIMBcfgdrugsServer.IsPlayerNearCoords(source, coords, radius)
  local distance = #(GetEntityCoords(GetPlayerPed(source)) - coords)
  if distance < (radius + 0.00001) then
    return true
  end
  return false
end
