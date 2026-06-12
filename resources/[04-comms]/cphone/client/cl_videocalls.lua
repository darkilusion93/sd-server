
RegisterNUICallback("newIceCandidateStreamer", function(data, cb)
    cb("ok")
    TriggerServerEvent("cphone:newIceCandidateStreamer", data)
end)


RegisterNUICallback("sendRTCOffer", function(data, cb)
    cb("ok")
    TriggerServerEvent("cphone:sendRTCOffer", data)
end)

RegisterNUICallback("newIceCandidateWatcher", function(data, cb)
    cb("ok")
    TriggerServerEvent("cphone:newIceCandidateWatcher", data)
end)

RegisterNUICallback("joinStream", function(data, cb)
    cb("ok")
    TriggerServerEvent("cphone:joinStream", data)
end)

RegisterNUICallback("sendRTCAnswer", function(data, cb)
    cb("ok")
    TriggerServerEvent("cphone:sendRTCAnswer", data)
end)


RegisterNetEvent("cphone:newIceCandidateStreamer", function(data)
    SendNUIMessage({
        action = "icecandidatestreamer", 
        streamId = data.streamId, 
        candidate = data.candidate
    })
end)

RegisterNetEvent("cphone:sendRTCOffer", function(data)
    SendNUIMessage({
        action = "receiveoffer", 
        streamId = data.streamId, 
        serverid = data.serverid, 
        offer = data.offer
    })
end)

local myStream = 0

RegisterNetEvent("cphone:joinStream", function(data)
    if myStream == data.streamId then
        SendNUIMessage({
            action = "joinstream", 
            streamId = data.streamId, 
            serverid = data.serverid
        })
    end
end)

RegisterNUICallback("startStreaming", function(data, cb)
    cb("ok")
    myStream = data.streamId

    print(myStream)
end)

RegisterNetEvent("cphone:newIceCandidateWatcher", function(data)
    if myStream == data.streamId then
        SendNUIMessage({
            action = "icecandidatewatcher", 
            streamId = data.streamId, 
            serverid = data.serverid, 
            candidate = data.candidate
        })
    end
end)

RegisterNetEvent("cphone:sendRTCAnswer", function(data)
    if myStream == data.streamId then
        SendNUIMessage({
            action = "receiveanswer", 
            streamId = data.streamId, 
            serverid = data.serverid, 
            answer = data.answer
        })
    end
end)
