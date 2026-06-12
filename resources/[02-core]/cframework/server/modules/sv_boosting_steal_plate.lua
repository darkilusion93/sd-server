

local boostingData = LoadBoosting()
local waitingForPlateSteal = {}

RegisterMissionSyncCallback("steal_plate", function(playerId, boostId, missionData)
    if missionData.vehicleEntity then
        TriggerClientEvent("cframework:boostingBeginStealPlate", playerId, NetworkGetNetworkIdFromEntity(missionData.vehicleEntity), missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("steal_plate", function(playerId, boostId)
    TriggerClientEvent("cframework:boostingCompleteStealPlate", playerId)
end)

RegisterBoostMission("steal_plate", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    missionData.missionType = contractInfo.missionType
    SetBoostingMissionData(boostId, missionData)

    waitingForPlateSteal[boostId] = true

    TriggerClientEventForBoostParty("cframework:boostingBeginStealPlate", boostId, NetworkGetNetworkIdFromEntity(missionData.vehicleEntity), contractInfo.missionType)

    while waitingForPlateSteal[boostId] do
        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_STEALING_PLATE"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingCompleteStealPlate", boostId)

    return true
end)

RegisterNetEvent("cframework:boostingPlateStolen", function()
    local source <const> = source
    local missionData <const> = GetBoostingMissionDataByPlayerMember(source)

    if missionData == nil then
        return
    end

    local boostId <const> = missionData.boostId
    local inventory <const> = ESX.getInvContainer(source)

    if waitingForPlateSteal[boostId] then
        waitingForPlateSteal[boostId] = nil

        inventory.addItem("vehicleplate", 1, nil, {
            label = missionData.vehiclePlate
        })
    end
end)