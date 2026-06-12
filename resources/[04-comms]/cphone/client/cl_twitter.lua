local patt = "[?!@#]"
local tweets = {}
local twitterMessages = nil

RegisterNetEvent('cphone:recentTweets', function(pTweets)
    tweets = pTweets

    while not IsPhoneReady() do Citizen.Wait(0) end

    SendNUIMessage({action = "loadTweets", tweets = pTweets})
end)

RegisterNUICallback('twitter_login', function(data, cb)
    local success, avatar_url, name = RPC.execute('cframework:twitter_login', data.username, data.password)

    cb({
        success = success, 
        avatar = avatar_url,
        name = name
    })
end)

RegisterNUICallback('twitter_register', function(data, cb)
    local success, response = RPC.execute('cframework:twitter_register', data.username, data.password, data.name)

    cb({
        success = success,
        response = response
    })
end)

RegisterNUICallback('twitter_updateaccount', function(data, cb)
    local success = RPC.execute('cframework:twitter_updateaccount', data.username, data.password, data.newpassword, data.newname, data.newavatar, data.newbio)

    cb({
        success = success
    })
end)

RegisterNUICallback('twitter_post', function(data, cb)
    TriggerServerEvent('cframework:twitter_post', data.message, data.picture, data.username, data.password)

    cb(true)
end)

RegisterNUICallback('twitter_sendmessage', function(data, cb)
    TriggerServerEvent('cframework:twitter_send_message', data.username, data.password, data.target, data.message, data.attachments)

    cb(true)
end)

RegisterNUICallback('twitter_getmessages', function(data, cb)
    if twitterMessages == nil then
        twitterMessages = RPC.execute('cframework:twitter_getmessages', data.username, data.password)
    end

    cb({
        messages = twitterMessages
    })
end)

RegisterNUICallback('twitter_searchuser', function(data, cb)
    local users = RPC.execute('cframework:twitter_searchuser', data.username)

    cb({
        users = users
    })
end)

RegisterNUICallback('twitter_getprofile', function(data, cb)
    local profile = RPC.execute('cframework:twitter_getprofile', data.myUsername, data.username)

    cb({
        profile = profile
    })
end)

RegisterNUICallback('twitter_getfollowfeed', function(data, cb)
    local followTweets = RPC.execute('cframework:twitter_getfollowfeed', data.username, data.password)

    cb({
        tweets = followTweets
    })
end)

RegisterNUICallback('twitter_follow', function(data, cb)
    TriggerServerEvent('cframework:twitter_follow', data.username, data.password, data.target)

    cb(true)
end)

RegisterNUICallback('twitter_unfollow', function(data, cb)
    TriggerServerEvent('cframework:twitter_unfollow', data.username, data.password, data.target)

    cb(true)
end)

RegisterNUICallback('twitter_logout', function(data, cb)
    TriggerServerEvent('cframework:twitter_logout', data.username, data.password)
    twitterMessages = nil

    cb(true)
end)

RegisterNetEvent('cframework:twitter_newfollower', function(followerName)
    TriggerEvent("cphone:showPhoneNotification", "Novo seguidor", followerName .. " começou a seguir-te!", "fab fa-twitter", "#1DA1F2")
end)

RegisterNetEvent('cframework:twitter_newmessage', function(messageData, notify)
    if notify then
        TriggerEvent("cphone:showPhoneNotification", "Nova mensagem de " .. messageData.senderLabel, messageData.content, "fab fa-twitter", "#1DA1F2")
    end

    if twitterMessages == nil then return end

    table.insert(twitterMessages, 1, messageData)

    SendNUIMessage({
        action = "loadMessages",
        messages = twitterMessages,
    })
end)

RegisterNetEvent('cframework:twitter_newpost', function(tweet)
    table.insert(tweets, 1, tweet)

    TriggerEvent("cphone:showPhoneNotification", "Novo tweet (@"..tweet.username..")", tweet.message.text, "fab fa-twitter", "#1DA1F2")

    SendNUIMessage({action = "loadTweets", tweets = tweets})
end)


