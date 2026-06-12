

local boostingData = LoadBoosting()

RegisterMissionSyncCallback("find_vehicle", function(playerId, boostId, missionData)
    if missionData.vehicleSpawnLocation then
        TriggerClientEvent("cframework:boostingBeginFindVehicle", playerId, missionData.vehicleSpawnLocation, missionData.missionType)
    end
end)

RegisterMissionCleanupCallback("find_vehicle", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingFinishFindVehicleBoost", playerId)
end)

RegisterBoostMission("find_vehicle", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomSpawnIndex <const> = math.random(1, #boostingData.locations[contractInfo.vehicleSpawn])
    local choosenSpawn <const> = boostingData.locations[contractInfo.vehicleSpawn][randomSpawnIndex]
    local vehiclePlate = "P" .. math.random(10000, 99999)

    local randomVehicleModelIndex <const> = math.random(1, #boostingData.vehicles[contractInfo.vehicleType])
    local vehicleModel <const> = boostingData.vehicles[contractInfo.vehicleType][randomVehicleModelIndex]

    local spawnLocation = vector3(0.0, 0.0, 0.0)
    local pedsToSpawn = {}

    if type(choosenSpawn) == "vector4" then
        spawnLocation = choosenSpawn
    elseif type(choosenSpawn) == "table" then
        spawnLocation = choosenSpawn.spawn
        pedsToSpawn = choosenSpawn.peds
    end

    missionData.vehicleSpawnLocation = spawnLocation
    missionData.missionType = contractInfo.missionType

    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginFindVehicle", boostId, spawnLocation, contractInfo.missionType)

    while GetDistanceOfClosestBoostMemberParty(boostId, spawnLocation.xyz) > 200.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_VEHICLE"))
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
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_VEHICLE"))
            return false
        end

        Citizen.Wait(20)
    end

    SetEntityIgnoreRequestControlFilter(vehicle, true)
    SetVehicleNumberPlateText(vehicle, vehiclePlate)

    if contractInfo.vehicleLocked then
        SetVehicleDoorsLocked(vehicle, 2)
    end

    missionData.vehicleEntity = vehicle
    missionData.vehicleModel = vehicleModel
    missionData.vehiclePlate = vehiclePlate

    local createdPeds, createdPedsNetId = {}, {}
    if pedsToSpawn and #pedsToSpawn > 0 then
        for _, pedInfo in ipairs(pedsToSpawn) do
            Citizen.Wait(500)
            local ped <const> = CreatePedInsideVehicle(vehicle, 0, pedInfo.model, -1, true, true)
            local time <const> = os.time()

            while not DoesEntityExist(ped) do
                if os.time() - time > 5 then
                    goto continue
                end

                Citizen.Wait(20)
            end

            Citizen.Wait(500)

            TaskLeaveVehicle(ped, vehicle, 16)
            SetEntityCoords(ped, pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z, false, false, false, false)
            SetEntityHeading(ped, pedInfo.coords.w)

            if pedInfo.weapon then
                GiveWeaponToPed(ped, pedInfo.weapon, 255, true, true)
            end

            SetEntityIgnoreRequestControlFilter(ped, true)

            TriggerClientEvent("cframework:boostingInitPed", NetworkGetEntityOwner(ped), NetworkGetNetworkIdFromEntity(ped), pedInfo.scenario, pedInfo.animDict, pedInfo.anim)

            table.insert(createdPeds, ped)
            table.insert(createdPedsNetId, NetworkGetNetworkIdFromEntity(ped))

            ::continue::
        end
    end

    missionData.createdPeds = createdPeds

    SetBoostingMissionData(boostId, missionData)

    if #createdPedsNetId > 0 then
        while #(GetEntityCoords(playerPed) - vector3(spawnLocation.x, spawnLocation.y, spawnLocation.z)) > 75.0 do
            if not DoesEntityExist(playerPed) then
                return false
            end

            if os.time() - missionData.startTime > contractInfo.timer then
                TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_VEHICLE"))
                return false
            end

            Citizen.Wait(1000)
        end

        TriggerClientEventForBoostParty("cframework:boostingAgroPeds", boostId, spawnLocation, createdPedsNetId)
    end

    while GetDistanceOfClosestBoostMemberParty(boostId, GetEntityCoords(missionData.vehicleEntity)) > 5.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_FINDING_VEHICLE"))
            return false
        end

        if not DoesEntityExist(missionData.vehicleEntity) then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_VEHICLE_DESTROYED"))
            return false
        end

        Citizen.Wait(1000)
    end

    TriggerClientEventForBoostParty("cframework:boostingFinishFindVehicleBoost", boostId)

    return true
end)