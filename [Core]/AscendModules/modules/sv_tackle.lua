-- 2018 Henric 'Kekke' Johansson
local Proxy = module("CLIMB", "lib/Proxy")
local Tunnel = module("CLIMB","lib/Tunnel")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB_tackle")


RegisterServerEvent('CLIMB:tryTackle')
AddEventHandler('CLIMB:tryTackle', function(target)
  local target = target
  local source = source
  local user_id = CLIMB.getUserId({source})
  if CLIMB.hasPermission({user_id, "police.armoury"}) or CLIMB.hasGroup({user_id, 'dev'}) then
	  TriggerClientEvent('CLIMB:getTackled', target, source)
    TriggerClientEvent('CLIMB:playTackle', source)
  end
end)