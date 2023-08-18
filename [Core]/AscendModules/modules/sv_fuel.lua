local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "CLIMB_fuel")

if cfgfuel.UseCLIMB then
	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local user_id = CLIMB.getUserId({source})
		local fuelAmount = math.floor(price)
		if price >= 99999999999 then 
			print(user_id.. "is cheating")
		if CLIMB.tryFullPayment({user_id ,fuelAmount})then
			end
		end
	end)
end
