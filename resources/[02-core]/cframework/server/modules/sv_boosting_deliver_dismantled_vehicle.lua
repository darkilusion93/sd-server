

local boostingData = LoadBoosting()

RegisterMissionSyncCallback("deliver_dismantled_vehicle", function(playerId, boostId, missionData)
    if missionData.deliverLocation then
        TriggerClientEvent("cframework:boostingBeginDeliverDismantledVehicle", playerId, missionData.deliverLocation, missionData.missionType, missionData.pedModel)
    end
end)

RegisterMissionCleanupCallback("deliver_dismantled_vehicle", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingFinishDeliverDismantledVehicleBoost", playerId, missionData.pedModel)
end)

RegisterBoostMission("deliver_dismantled_vehicle", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomDeliverIndex <const> = math.random(1, #boostingData.locations[contractInfo.deliverLocation])
    local deliverLocation <const> = boostingData.locations[contractInfo.deliverLocation][randomDeliverIndex]

    missionData.missionType = contractInfo.missionType
    missionData.pedModel = contractInfo.pedModel
    missionData.deliverLocation = deliverLocation

    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginDeliverDismantledVehicle", boostId, deliverLocation, contractInfo.missionType, contractInfo.pedModel)

    while GetDistanceOfClosestBoostMemberParty(boostId, deliverLocation.xyz) > 10.0 or #(GetEntityCoords(missionData.towEntity) - vector3(deliverLocation.x, deliverLocation.y, deliverLocation.z)) > 10.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_PARTS"))
            return false
        end

        if not DoesEntityExist(missionData.towEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        Citizen.Wait(1000)
    end

    while GetEntitySpeed(missionData.towEntity) < 1.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_PARTS"))
            return false
        end

        if not DoesEntityExist(missionData.towEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end
        Citizen.Wait(1000)
    end

    for _, member in ipairs(missionData.members) do
        local targetPed <const> = GetPlayerPed(member.playerId)

        if GetVehiclePedIsIn(targetPed, false) == missionData.towEntity then
            TaskLeaveVehicle(targetPed, missionData.towEntity, 0)
        end
    end

    while GetVehiclePedIsIn(playerPed, false) == missionData.towEntity do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_PARTS"))
            return false
        end

        if not DoesEntityExist(missionData.towEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end
        Citizen.Wait(1000)
    end

    local vehicle <const> = missionData.towEntity

    Citizen.Wait(5000)

    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end

    if missionData.vehicleEntity and DoesEntityExist(missionData.vehicleEntity) then
        DeleteEntity(missionData.vehicleEntity)
    end

    TriggerClientEventForBoostParty("cframework:boostingFinishDeliverDismantledVehicleBoost", boostId, contractInfo.pedModel)

    return true
end)