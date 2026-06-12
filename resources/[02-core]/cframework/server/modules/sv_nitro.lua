

RegisterNetEvent("cframework:syncNitro", function(vehNetId, nitroLevel)
    local source <const> = source
    local veh <const> = NetworkGetEntityFromNetworkId(vehNetId)

    if not DoesEntityExist(veh) then
        return
    end

    local state = Entity(veh).state

    state.nitroLevel = nitroLevel
end)

RegisterNetEvent("cframework:toggleNitro", function(vehNetId, enableNitro)
    local source <const> = source
    local veh <const> = NetworkGetEntityFromNetworkId(vehNetId)

    if not DoesEntityExist(veh) then
        return
    end

    local state = Entity(veh).state

    state.nitroEnabled = enableNitro
end)