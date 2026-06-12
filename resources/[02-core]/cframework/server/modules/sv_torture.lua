local playerTorturingPairs = {}

RegisterNetEvent('cframework:torture:enter', function(serverId)
    local source = source

    if serverId == -1 then return end

    playerTorturingPairs[source] = serverId
end)

RegisterNetEvent('cframework:torture:leave', function()
    local source = source

    if playerTorturingPairs[source] == nil then return end

    TriggerClientEvent('cframework:torture:leaveTorture', playerTorturingPairs[source])
end)

RegisterNetEvent('cframework:torture:giveTooth', function(serverId)
    local source = source

    --//TODO: add give tooth feature
end)

RegisterNetEvent('cframework:torture:playVictimAnim', function(hostageId, chairCoords, chairHeading, animPhase)
    if hostageId == -1 then return end
    TriggerClientEvent('cframework:torture:playVictimAnim', hostageId, chairCoords, chairHeading, animPhase)
end)

RegisterNetEvent('cframework:torture:playWrenchVictimAnim', function(hostageId, chairCoords, chairHeading, animPhase)
    if hostageId == -1 then return end
    TriggerClientEvent('cframework:torture:playWrenchVictimAnim', hostageId, chairCoords, chairHeading, animPhase)
end)

RegisterNetEvent('cframework:torture:playSyringeVictimAnim', function(hostageId, chairCoords, chairHeading, animPhase)
    if hostageId == -1 then return end
    TriggerClientEvent('cframework:torture:playSyringeVictimAnim', hostageId, chairCoords, chairHeading, animPhase)
end)