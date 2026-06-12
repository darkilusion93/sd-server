RegisterNetEvent("sync:request", function(native, ownerID, netID, ...)
    --TriggerClientEvent("sync:execute", ownerID, native, netID, ...)
end)

RegisterNetEvent("sync:delete", function(netID)
    DeleteEntity(NetworkGetEntityFromNetworkId(netID))
end)