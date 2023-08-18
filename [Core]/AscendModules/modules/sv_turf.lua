local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")

CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB", "F")

local isPlayerInTurf = {}

local completedTurf = false

RegisterServerEvent('CLIMB:TooFar')
AddEventHandler('CLIMB:TooFar', function(isnTurf)

	local user_id = CLIMB.getUserId({source})
	local player = CLIMB.getUserSource({user_id})

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source]) then
			TriggerClientEvent('CLIMB:OutOfZone', source)
			isPlayerInTurf[source] = nil

			TriggerClientEvent('chatMessage', -1, 'Turf Infomation │', {255, 255, 255}, "Turf capture failed at ^2" .. turf.nameofturf, "alert")
			TriggerClientEvent("turfTrue", -1, false)
			completedTurf = false
			TriggerClientEvent("doneIt", -1, false)
		end
	end

end)

RegisterServerEvent('CLIMB:PlayerDied')
AddEventHandler('CLIMB:PlayerDied', function(isnTurf)

	
	local user_id = CLIMB.getUserId({source})
	local player = CLIMB.getUserSource({user_id})

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source])then
			TriggerClientEvent('CLIMB:PlayerDied', source)
			isPlayerInTurf[source] = nil
			TriggerClientEvent('chatMessage', -1, 'Turf Infomation │', {255, 255, 255}, "Turf capture failed at ^2" .. turf.nameofturf, "alert")

			TriggerClientEvent("turfTrue", -1, false)
			TriggerClientEvent("doneIt", -1, false)
			completedTurf = false
		end
	end
end)

RegisterNetEvent("changeCom")
AddEventHandler("changeCom", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', -1, 'Turf Infomation │', {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^2" .. com .. "% ^0at Large Arms", "alert")			  
				CLIMBclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				sendCom(com, source)
			end
		else
			CLIMBclient.notify(source,{"~d~You cannot go higher than 35%."})
		end
	else
		CLIMBclient.notify(source,{"~d~No!"})
	end
end)


RegisterServerEvent('CLIMB:rob')
AddEventHandler('CLIMB:rob', function(isnTurf)
	local user_id = CLIMB.getUserId({source})
	local player = CLIMB.getUserSource({user_id})

	if CLIMB.hasPermission({user_id, 'pd.armory'}) then 
	  CLIMBclient.notify(player,{"~d~Police Officers can't cap turfs."})
	else

	  if turfs[isnTurf] then
		  local turf = turfs[isnTurf]

		if (os.time() - turf.lastisnTurfed) < 600 and turf.lastisnTurfed ~= 0 then
			CLIMBclient.notify(player,{"~d~This Turf has already been capped recently. Please wait another: ~w~" .. (600 - (os.time() - turf.lastisnTurfed)) .. " ~d~seconds."})

			return
		end

		
		TriggerClientEvent('chatMessage', -1, 'Turf Infomation │', {255, 255, 255}, "Turf capture started at ^2" .. turf.nameofturf, "alert")
			  completedTurf = false
			  TriggerClientEvent("turfTrue", -1, true)
			CLIMBclient.notify(player,{"~g~Defend the area for ~w~120 ~g~Seconds and the Turf is yours!"})
		  	TriggerClientEvent('CLIMB:TakenTurf', player, isnTurf)
			  TriggerClientEvent("doneIt", -1, false)

				
			if turf.nameofturf == "Heroin" then
				TriggerClientEvent("HeroinZone", -1)
			end

			if turf.nameofturf == "LSD" then
				TriggerClientEvent("LSDZone", -1)
			end

			if turf.nameofturf == "Large Arms" then
				TriggerClientEvent("LargeArmsZone", -1)
			end

			if turf.nameofturf == "Cocaine" then
				TriggerClientEvent("CocaineZone", -1)
			end

			if turf.nameofturf == "Weed" then
				TriggerClientEvent("WeedZone", -1)
			end
			  
		  	turfs[isnTurf].lastisnTurfed = os.time()
			  
		  	isPlayerInTurf[player] = isnTurf
		  	local savedSource = player
			
		  	SetTimeout(120 * 1000, function()
			  	if(isPlayerInTurf[savedSource]) then
					
				  	if(user_id) then

						
			
						TriggerClientEvent('chatMessage', -1, 'Turf Infomation │', {255, 255, 255}, "Turf capture sucessful at ^2" .. turf.nameofturf .. "^0!", "alert")
						if turf.nameofturf == "Weed" then
						
					
							CLIMB.giveMoney({CLIMB.getUserId({savedSource}), 5000})
							CLIMBclient.notify(savedSource,{'~g~You have completed Turf. Here is £5,000!'})
							
							
						end

						if turf.nameofturf == "LSD" then
						
					
							CLIMB.giveMoney({CLIMB.getUserId({savedSource}), 20000})
							CLIMBclient.notify(savedSource,{'~g~You have completed Turf. Here is £20,000!'})
							
							
						end

						if turf.nameofturf == "Cocaine" then
						
					
							CLIMB.giveMoney({CLIMB.getUserId({savedSource}), 10000})
							CLIMBclient.notify(savedSource,{'~g~You have completed Turf. Here is £10,000!'})
							
							
						end

						if turf.nameofturf == "Heroin" then
						
					
							CLIMB.giveMoney({CLIMB.getUserId({savedSource}), 15000})
							CLIMBclient.notify(savedSource,{'~g~You have completed Turf. Here is £15,000!'})
							
							
						end
					 	TriggerClientEvent('CLIMB:TurfComplete', savedSource, turf.reward, turf.nameofturf)
						 TriggerClientEvent("turfTrue", -1, false)
						 completedTurf = true
				  	end

			  	end
		  	end)		
	  	end
	end
end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end