

local boostingData = LoadBoosting()
local waitingForEngineSteal = {}

RegisterMissionSyncCallback("steal_engine", function(playerId, boostId, missionData)
    if missionData.vehicleEntity then
        TriggerClientEvent("cframework:boostingBeginStealEngine", playerId, NetworkGetNetworkIdFromEntity(missionData.vehicleEntity), missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("steal_engine", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingCompleteStealEngine", playerId)
end)

RegisterBoostMission("steal_engine", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    waitingForEngineSteal[boostId] = true

    missionData.missionType = contractInfo.missionType
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginStealEngine", boostId, NetworkGetNetworkIdFromEntity(missionData.vehicleEntity), contractInfo.missionType)

    while waitingForEngineSteal[boostId] do
        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_ENGINE_STEAL_TIME_EXPIRED"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingCompleteStealEngine", boostId)

    return true
end)

RegisterNetEvent("cframework:boostingEngineStolen", function()
    local source <const> = source
    local missionData <const> = GetBoostingMissionDataByPlayerMember(source)

    if missionData == nil then
        return
    end

    local boostId <const> = missionData.boostId
    local inventory <const> = ESX.getInvContainer(source)

    if waitingForEngineSteal[boostId] then
        waitingForEngineSteal[boostId] = nil

        inventory.addItem("car_motor", 1)
    end
end)