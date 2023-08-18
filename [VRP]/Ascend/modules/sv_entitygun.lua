RegisterCommand("Delgun", function(source, args)
    local source = source 
    local user_id = CLIMB.getUserId(source)
    if CLIMB.hasPermission(user_id, "admin.tickets") then 
        TriggerClientEvent('CLIMB:EntityCleanupGun', source)
    end
end)