--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

RegisterNetEvent("CLIMB:twitter_getTweets")
AddEventHandler("CLIMB:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("CLIMB:twitter_getFavoriteTweets")
AddEventHandler("CLIMB:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("CLIMB:twitter_newTweets")
AddEventHandler("CLIMB:twitter_newTweets", function(tweet)
  SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
end)

RegisterNetEvent("CLIMB:twitter_updateTweetLikes")
AddEventHandler("CLIMB:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("CLIMB:twitter_setAccount")
AddEventHandler("CLIMB:twitter_setAccount", function(username, password, avatarUrl)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("CLIMB:twitter_createAccount")
AddEventHandler("CLIMB:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("CLIMB:twitter_showError")
AddEventHandler("CLIMB:twitter_showError", function(title, message)
  SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent("CLIMB:twitter_showSuccess")
AddEventHandler("CLIMB:twitter_showSuccess", function(title, message)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent("CLIMB:twitter_setTweetLikes")
AddEventHandler("CLIMB:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)



RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('CLIMB:twitter_login', data.username, data.password)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('CLIMB:twitter_getTweets')
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('CLIMB:twitter_getFavoriteTweets')
end)

RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('CLIMB:twitter_postTweets', data.message)
end)

RegisterNUICallback('twitter_postTweetImg', function(data, cb)
  TriggerServerEvent('CLIMB:twitter_postTweets', data.username or '', data.password or '', data.message)
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('CLIMB:likeTweet',data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
    TriggerServerEvent("CLIMB:setTwitterAvatar", data.avatarUrl)
end)
