-- Server-side script

RegisterNetEvent("CLIMB:twitter_login")
AddEventHandler("CLIMB:twitter_login", function(username, password)
  -- Your code to handle the login here
  local success = true -- Example code, replace with actual logic
  if success then
    TriggerClientEvent("CLIMB:twitter_setAccount", source, username, password, "avatarUrl")
  else
    TriggerClientEvent("CLIMB:twitter_showError", source, "Login Error", "Incorrect username or password.")
  end
end)

RegisterNetEvent("CLIMB:twitter_getTweets")
AddEventHandler("CLIMB:twitter_getTweets", function()
  -- Your code to handle getting the tweets here
  local tweets = {} -- Example code, replace with actual logic
  TriggerClientEvent("CLIMB:twitter_getTweets", source, tweets)
end)

-- Repeat the same pattern for each of the other client-side events
