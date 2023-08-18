local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")

CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB_Numberplate")
MySQL = module("climb_mysql", "MySQL")

local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
	"nigger",
	"cunt",
	"faggot",
	"fuck",
	"fucker",
	"fucking",
	"anal",
	"stupid",
	"damn",
	"cock",
	"cum",
	"dick",
	"dipshit",
	"dildo",
	"douchbag",
	"douch",
	"kys",
	"jerk",
	"jerkoff",
	"gay",
	"homosexual",
	"lesbian",
	"suicide",
	"mothafucka",
	"negro",
	"pussy",
	"queef",
	"queer",
	"weeb",
	"retard",
	"masterbate",
	"suck",
	"tard",
	"allahu akbar",
	"terrorist",
	"twat",
	"vagina",
	"wank",
	"whore",
	"wanker",
	"n1gger",
	"f4ggot",
	"n0nce",
	"d1ck",
	"h0m0",
	"n1gg3r",
	"h0m0s3xual",
	"free up mandem",
	"nazi",
	"hitler",
	"cheater",
	"cheating",
}

MySQL.createCommand("CLIMB/update_numplate","UPDATE climb_user_identities SET registration = @registration WHERE user_id = @user_id")
MySQL.createCommand("CLIMB/update_numplate2","UPDATE climb_user_vehicles SET vehicle_plate = @registration WHERE user_id = @user_id AND vehicle = @vehicle")

RegisterNetEvent('CLIMB:getCars')
AddEventHandler('CLIMB:getCars', function()
    local cars = {}
    local source = source
    local user_id = CLIMB.getUserId({source})
    exports['ghmattimysql']:execute("SELECT * FROM `climb_user_vehicles` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    cars[v.vehicle] = {v.vehicle, v.vehicle_plate}
                end
            end
            TriggerClientEvent('CLIMB:carsTable', source, cars)
        end
    end)
end)

RegisterNetEvent("CLIMB:ChangeNumberPlate")
AddEventHandler("CLIMB:ChangeNumberPlate", function(vehicle)
    local user_id = CLIMB.getUserId({source})

	CLIMB.prompt({source,"Plate Name:","",function(source, plateName)
		if plateName == '' then return end
		for name in pairs(forbiddenNames) do
			if plateName == forbiddenNames[name] then
				CLIMBclient.notify(source,{"~d~You cannot have this plate."})
				return
			end
		end
		if CLIMB.tryFullPayment({user_id,50000}) then
			CLIMBclient.notify(source,{"~g~Changed Number plate of "..vehicle.." to "..plateName})
			MySQL.execute("CLIMB/update_numplate2", {user_id = user_id, registration = plateName, vehicle = vehicle})
			MySQL.execute("CLIMB/update_numplate2", {user_id = user_id, registration = plateName})
			TriggerClientEvent("CLIMB:RecieveNumberPlate", source, plateName)
			TriggerClientEvent("CLIMB:PlaySound", source, 1)
			TriggerEvent('CLIMB:getCars')
		else
			CLIMBclient.notify(source,{"~d~You don't have enough money!"})
			TriggerClientEvent("CLIMB:PlaySound", source, 2)
		end
	end})
end)
