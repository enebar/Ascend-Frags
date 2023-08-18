RegisterNetEvent("CLIMB:tchat_receive")
AddEventHandler("CLIMB:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("CLIMB:tchat_channel")
AddEventHandler("CLIMB:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('CLIMB:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('CLIMB:tchat_channel', data.channel)
end)
