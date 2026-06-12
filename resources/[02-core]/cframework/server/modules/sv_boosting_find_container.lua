

local boostingData = LoadBoosting()

RegisterMissionSyncCallback("find_container", function(playerId, boostId, missionData)
    if missionData.spawnLocation then
        TriggerClientEvent("cframework:boostingBeginFindContainer", playerId, missionData.spawnLocation, missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("find_container", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingFinishFindContainer", playerId)
end)

RegisterBoostMission("find_container", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomSpawnIndex <const> = math.random(1, #boostingData.locations[contractInfo.containerSpawn])
    local containerSpawn <const> = boostingData.locations[contractInfo.containerSpawn][randomSpawnIndex]

    local containerModel <const> = boostingData.containerObject
    local lockModel <const> = boostingData.lockObject
    local spawnLocation <const> = containerSpawn.container

    missionData.spawnLocation = spawnLocation
    missionData.missionType = contractInfo.missionType
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginFindContainer", boostId, spawnLocation, contractInfo.missionType)

    while GetDistanceOfClosestBoostMemberParty(boostId, spawnLocation.xyz) > 200.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_CONTAINER"))
            return false
        end

        Citizen.Wait(1000)
    end

    local container <const> = CreateObject(containerModel, spawnLocation.x, spawnLocation.y, spawnLocation.z, true, true, false)
    local lock <const> = CreateObject(lockModel, spawnLocation.x, spawnLocation.y, spawnLocation.z, true, true, false)

    while not DoesEntityExist(container) or not DoesEntityExist(lock) do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_CONTAINER"))
            return false
        end

        Citizen.Wait(20)
    end

    SetEntityHeading(container, spawnLocation.w)
    SetEntityIgnoreRequestControlFilter(container, true)
    SetEntityHeading(lock, spawnLocation.w)
    SetEntityIgnoreRequestControlFilter(lock, true)

    missionData.containerEntity = container
    missionData.lockEntity = lock

    SetBoostingMissionData(boostId, missionData)

    while GetDistanceOfClosestBoostMemberParty(boostId, spawnLocation.xyz) > 5.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_CONTAINER"))
            return false
        end

        if not DoesEntityExist(missionData.containerEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_CONTAINER_DESTROYED"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingFinishFindContainer", boostId)

    return true
end)