--[[function elite(_, arg)
    print("^3User Has Bought Package! ^7")
	user_id = tonumber(arg[1])
    usource = CLIMB.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought elite')

    CLIMBclient.notify(usource, {"~g~You have purchased the elite Rank! ❤️"})
    CLIMB.giveBankMoney(user_id, 200)
    CLIMB.addUserGroup(user_id,"VIP")


    
end

function soldier(_, arg)
	user_id = tonumber(arg[1])
    usource = CLIMB.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Soldier')

    CLIMBclient.notify(usource, {"~g~You have purchased the Soldier Rank! ❤️"})
    CLIMB.giveBankMoney(user_id, 400)
    CLIMB.addUserGroup(user_id,"VIP")


    
end

function warrior(_, arg)
	user_id = tonumber(arg[1])
    usource = CLIMB.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Warrior')

    CLIMBclient.notify(usource, {"~g~You have purchased the Warrior Rank! ❤️"})
    CLIMB.giveBankMoney(user_id, 400)
    CLIMB.addUserGroup(user_id,"VIP")


    
end

function diamond(_, arg)
	user_id = tonumber(arg[1])
    usource = CLIMB.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Diamond')

    CLIMBclient.notify(usource, {"~g~You have purchased the Diamond Rank! ❤️"})
    CLIMB.giveBankMoney(user_id, 2000)
    CLIMB.addUserGroup(user_id,"VIP")


    
end

function tokens(_, arg)
    user_id = tonumber(arg[1])
    usource = CLIMB.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought a '..tostring(arg[2])..' Money Bag')

    CLIMBclient.notify(usource, {"~g~You have purchased " .. tostring(arg[2]) .. " Money! ❤️"})
    CLIMB.giveBankMoney(user_id, tonumber(arg[2]))
end


 RegisterCommand("elite", elite, true)
 RegisterCommand("soldier", soldier, true)
 RegisterCommand("warrior", warrior, true)
 RegisterCommand("diamond", champion, true)
 RegisterCommand("givemoney", tokens, true)
]] 