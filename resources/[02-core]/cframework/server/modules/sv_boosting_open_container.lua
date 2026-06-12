

local boostingData = LoadBoosting()
local waitingForContainerOpen = {}

RegisterMissionSyncCallback("open_container", function(playerId, boostId, missionData)
    if missionData.spawnLocation then
        TriggerClientEvent("cframework:boostingBeginOpenContainer", playerId, NetworkGetNetworkIdFromEntity(missionData.containerEntity), NetworkGetNetworkIdFromEntity(missionData.lockEntity), missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("open_container", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingCompleteOpenContainer", playerId)
end)

RegisterBoostMission("open_container", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    waitingForContainerOpen[boostId] = true

    missionData.missionType = contractInfo.missionType
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginOpenContainer", boostId, NetworkGetNetworkIdFromEntity(missionData.containerEntity), NetworkGetNetworkIdFromEntity(missionData.lockEntity), contractInfo.missionType)

    while waitingForContainerOpen[boostId] do
        if not DoesEntityExist(missionData.containerEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_CONTAINER_DESTROYED"))
            return false
        end

        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_OPENING_CONTAINER"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingCompleteOpenContainer", boostId)

    return true
end)

RegisterNetEvent("cframework:boostingContainerOpened", function()
    local source <const> = source
    local missionData <const> = GetBoostingMissionDataByPlayerMember(source)

    if missionData == nil then
        return
    end

    local boostId <const> = missionData.boostId

    if waitingForContainerOpen[boostId] then
        waitingForContainerOpen[boostId] = nil
    end
end)