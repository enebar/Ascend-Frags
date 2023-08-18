RegisterServerEvent('CLIMB:opendevmenu')
AddEventHandler('CLIMB:opendevmenu', function()
    local source = source
    local user_id = CLIMB.getUserId(source)
    if user_id == 1 or user_id == 19 then
      CLIMBclient.opendevelopermenu(source,{})
    end
end)