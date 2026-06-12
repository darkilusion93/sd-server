

local boostingData = LoadBoosting()

RegisterMissionSyncCallback("deliver_vehicle", function(playerId, boostId, missionData)
    if missionData.deliverLocation then
        TriggerClientEvent("cframework:boostingBeginDeliverVehicle", playerId, missionData.deliverLocation, missionData.missionType, missionData.pedModel)
    end
end)

RegisterMissionCleanupCallback("deliver_vehicle", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingFinishDeliverVehicleBoost", playerId, missionData.pedModel)
end)

RegisterBoostMission("deliver_vehicle", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomDeliverIndex <const> = math.random(1, #boostingData.locations[contractInfo.deliverLocation])
    local deliverLocation <const> = boostingData.locations[contractInfo.deliverLocation][randomDeliverIndex]

    missionData.deliverLocation = deliverLocation
    missionData.missionType = contractInfo.missionType
    missionData.pedModel = contractInfo.pedModel
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginDeliverVehicle", boostId, deliverLocation, contractInfo.missionType, contractInfo.pedModel)

    while GetDistanceOfClosestBoostMemberParty(boostId, deliverLocation.xyz) > 10.0 or #(GetEntityCoords(missionData.vehicleEntity) - vector3(deliverLocation.x, deliverLocation.y, deliverLocation.z)) > 10.0 do
        if missionData.towEntity and GetDistanceOfClosestBoostMemberParty(boostId, deliverLocation.xyz) < 10.0 and GetVehiclePedIsIn(playerPed, false) == missionData.towEntity then
            break
        end

        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_VEHICLE"))
            return false
        end

        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        Citizen.Wait(1000)
    end

    while GetEntitySpeed(missionData.vehicleEntity) < 1.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_VEHICLE"))
            return false
        end

        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end
        Citizen.Wait(1000)
    end

    if missionData.towEntity then
        while #(GetEntityCoords(missionData.towEntity) - vector3(deliverLocation.x, deliverLocation.y, deliverLocation.z)) > 10.0 do
            if not DoesEntityExist(playerPed) then
                return false
            end

            if os.time() - missionData.startTime > contractInfo.timer then
                TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_VEHICLE"))
                return false
            end

            if not DoesEntityExist(missionData.vehicleEntity) then
                TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
                return false
            end

            if not DoesEntityExist(missionData.towEntity) then
                TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TOW_DESTROYED"))
                return false
            end
            Citizen.Wait(1000)
        end
    end

    for _, member in ipairs(missionData.members) do
        local targetPed <const> = GetPlayerPed(member.playerId)

        if GetVehiclePedIsIn(targetPed, false) == missionData.vehicleEntity then
            TaskLeaveVehicle(targetPed, missionData.vehicleEntity, 0)
        elseif missionData.towEntity and GetVehiclePedIsIn(targetPed, false) == missionData.towEntity then
            TaskLeaveVehicle(targetPed, missionData.towEntity, 0)
        end
    end

    while GetVehiclePedIsIn(playerPed, false) == missionData.vehicleEntity do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_VEHICLE"))
            return false
        end

        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end
        Citizen.Wait(1000)
    end

    local vehicle <const> = missionData.vehicleEntity

    Citizen.Wait(5000) -- Wait 5 seconds before turning off the engine

    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end

    if missionData.towEntity and DoesEntityExist(missionData.towEntity) then
        DeleteEntity(missionData.towEntity)
    end

    TriggerClientEventForBoostParty("cframework:boostingFinishDeliverVehicleBoost", boostId, contractInfo.pedModel)

    return true
end)