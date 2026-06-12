

RegisterNetEvent("cframework:syncStance", function(vehNetId, frontTrackWidth, backTrackWidth, frontTrackRotation, backTrackRotation)
    local source <const> = source
    local veh <const> = NetworkGetEntityFromNetworkId(vehNetId)

    if not DoesEntityExist(veh) then
        return
    end

    local state = Entity(veh).state

    if frontTrackWidth ~= nil and frontTrackWidth ~= true then
        state.frontTrackWidth = frontTrackWidth
    end
    if backTrackWidth ~= nil and backTrackWidth ~= true then
        state.backTrackWidth = backTrackWidth
    end
    if frontTrackRotation ~= nil and frontTrackRotation ~= true then
        state.frontTrackRotation = frontTrackRotation
    end
    if backTrackRotation ~= nil and backTrackRotation ~= true then
        state.backTrackRotation = backTrackRotation
    end
end)