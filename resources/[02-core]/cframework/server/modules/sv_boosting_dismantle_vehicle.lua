

local boostingData = LoadBoosting()
local waitingForEngineDismantle = {}

RegisterMissionSyncCallback("dismantle_vehicle", function(playerId, boostId, missionData)
    if missionData.vehicleEntity then
        TriggerClientEvent("cframework:boostingBeginDismantleVehicle", playerId, NetworkGetNetworkIdFromEntity(missionData.vehicleEntity), missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("dismantle_vehicle", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingCompleteDismantleVehicle", playerId)
end)

RegisterBoostMission("dismantle_vehicle", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    waitingForEngineDismantle[boostId] = true

    missionData.missionType = contractInfo.missionType
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginDismantleVehicle", boostId, NetworkGetNetworkIdFromEntity(missionData.vehicleEntity), contractInfo.missionType)

    while waitingForEngineDismantle[boostId] do
        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DISMANTLING_VEHICLE"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingCompleteDismantleVehicle", boostId)

    return true
end)

RegisterNetEvent("cframework:boostingVehicleDismantled", function()
    local source <const> = source
    local missionData <const> = GetBoostingMissionDataByPlayerMember(source)

    if missionData == nil then
        return
    end

    local boostId <const> = missionData.boostId

    if waitingForEngineDismantle[boostId] then
        waitingForEngineDismantle[boostId] = nil
    end
end)