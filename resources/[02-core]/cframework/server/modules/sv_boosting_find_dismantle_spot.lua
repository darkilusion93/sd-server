

local boostingData = LoadBoosting()

RegisterMissionSyncCallback("find_dismantle_spot", function(playerId, boostId, missionData)
    if missionData.spawnLocation then
        TriggerClientEvent("cframework:boostingBeginFindDismantleSpot", playerId, missionData.spawnLocation, missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("find_dismantle_spot", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingFinishFindDismantleSpot", playerId)
end)

RegisterBoostMission("find_dismantle_spot", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomSpawnIndex <const> = math.random(1, #boostingData.locations[contractInfo.dismantleSpotSpawn])
    local spawnLocation <const> = boostingData.locations[contractInfo.dismantleSpotSpawn][randomSpawnIndex]
    local vehiclePlate = "C" .. math.random(10000, 99999)

    local vehicleModel <const> = boostingData.dismantleCargoVehicle

    missionData.spawnLocation = spawnLocation
    missionData.missionType = contractInfo.missionType
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginFindDismantleSpot", boostId, spawnLocation, contractInfo.missionType)

    while GetDistanceOfClosestBoostMemberParty(boostId, spawnLocation.xyz) > 200.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FIND_DISMANTLE"))
            return false
        end

        Citizen.Wait(1000)
    end

    local vehicle <const> = CreateVehicle(vehicleModel, spawnLocation.x, spawnLocation.y, spawnLocation.z, spawnLocation.w, true, true)
    while not DoesEntityExist(vehicle) do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FIND_DISMANTLE"))
            return false
        end

        Citizen.Wait(20)
    end

    SetEntityIgnoreRequestControlFilter(vehicle, true)
    SetVehicleNumberPlateText(vehicle, vehiclePlate)

    missionData.towEntity = vehicle

    SetBoostingMissionData(boostId, missionData)

    while GetDistanceOfClosestBoostMemberParty(boostId, GetEntityCoords(missionData.towEntity)) > 20.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FIND_DISMANTLE"))
            return false
        end

        if not DoesEntityExist(missionData.towEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingFinishFindDismantleSpot", boostId)

    return true
end)