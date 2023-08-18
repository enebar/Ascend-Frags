RegisterNetEvent('CLIMB:checkTutorial')
AddEventHandler('CLIMB:checkTutorial', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if not CLIMB.hasGroup(user_id, 'TutorialCompleted') then
        print("Not Completed")
        TriggerClientEvent('CLIMB:startTutorial', source)
    else
        
    end
end)

RegisterNetEvent('CLIMB:setCompletedTutorial')
AddEventHandler('CLIMB:setCompletedTutorial', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if not CLIMB.hasGroup(user_id, 'TutorialCompleted') then
        CLIMB.addUserGroup(user_id,'TutorialCompleted')
    end
end)