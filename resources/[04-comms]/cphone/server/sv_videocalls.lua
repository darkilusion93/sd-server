RegisterNetEvent("cphone:newIceCandidateStreamer", function(data)
    TriggerClientEvent("cphone:newIceCandidateStreamer", data.serverid, data)
end)

RegisterNetEvent("cphone:sendRTCOffer", function(data)
    TriggerClientEvent("cphone:sendRTCOffer", data.serverid, data)
end)

RegisterNetEvent("cphone:newIceCandidateWatcher", function(data)
    local targetSource = ESX.GetPlayerFromPhoneNumber(data.streamId)

    if targetSource == nil then return end

    TriggerClientEvent("cphone:newIceCandidateWatcher", targetSource.source, data)
end)

RegisterNetEvent("cphone:joinStream", function(data)
    local targetSource = ESX.GetPlayerFromPhoneNumber(data.streamId)

    if targetSource == nil then return end

    TriggerClientEvent("cphone:joinStream", targetSource.source, data)
end)

RegisterNetEvent("cphone:sendRTCAnswer", function(data)
    local targetSource = ESX.GetPlayerFromPhoneNumber(data.streamId)

    if targetSource == nil then return end

    TriggerClientEvent("cphone:sendRTCAnswer", targetSource.source, data)
end)
